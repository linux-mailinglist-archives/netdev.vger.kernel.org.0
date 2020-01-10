Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA59136873
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 08:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgAJHmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 02:42:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41985 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgAJHmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 02:42:35 -0500
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1ipow3-0001rj-Lx; Fri, 10 Jan 2020 07:42:24 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     davem@davemloft.ne, jeffrey.t.kirsher@intel.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Li RongQing <lirongqing@baidu.com>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] ethtool: Call begin() and complete() in __ethtool_get_link_ksettings()
Date:   Fri, 10 Jan 2020 15:41:59 +0800
Message-Id: <20200110074159.18473-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200110074159.18473-1-kai.heng.feng@canonical.com>
References: <20200110074159.18473-1-kai.heng.feng@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device like igb gets runtime suspended when there's no link partner. We
can't get correct speed under that state:
$ cat /sys/class/net/enp3s0/speed
1000

In addition to that, an error can also be spotted in dmesg:
[  385.991957] igb 0000:03:00.0 enp3s0: PCIe link lost

It's because the igb device doesn't get runtime resumed before calling
get_link_ksettings().

So let's call begin() and complete() like what dev_ethtool() does, to
runtime resume/suspend or power up/down the device properly.

Once this fix is in place, igb can show the speed correctly without link
partner:
$ cat /sys/class/net/enp3s0/speed
-1

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 net/ethtool/ioctl.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 182bffbffa78..c768dbf45fc4 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -423,13 +423,26 @@ struct ethtool_link_usettings {
 int __ethtool_get_link_ksettings(struct net_device *dev,
 				 struct ethtool_link_ksettings *link_ksettings)
 {
+	int rc;
+
 	ASSERT_RTNL();
 
 	if (!dev->ethtool_ops->get_link_ksettings)
 		return -EOPNOTSUPP;
 
+	if (dev->ethtool_ops->begin) {
+		rc = dev->ethtool_ops->begin(dev);
+		if (rc  < 0)
+			return rc;
+	}
+
 	memset(link_ksettings, 0, sizeof(*link_ksettings));
-	return dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
+	rc = dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
+
+	if (dev->ethtool_ops->complete)
+		dev->ethtool_ops->complete(dev);
+
+	return rc;
 }
 EXPORT_SYMBOL(__ethtool_get_link_ksettings);
 
-- 
2.17.1

