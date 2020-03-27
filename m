Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19BF7194F37
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgC0CqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:46:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34355 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0CqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:46:22 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jHf0Z-0002zW-PR; Fri, 27 Mar 2020 02:46:08 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     alexander.duyck@gmail.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ethtool: Report speed and duplex as unknown when device is runtime suspended
Date:   Fri, 27 Mar 2020 10:45:51 +0800
Message-Id: <20200327024552.22170-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
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

Since device can only be runtime suspended when there's no link partner,
we can directly report the speed and duplex as unknown.

Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Aaron Brown <aaron.f.brown@intel.com>
Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 net/ethtool/ioctl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 10d929abdf6a..2ba04aa9d775 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -28,6 +28,7 @@
 #include <net/xdp_sock.h>
 #include <net/flow_offload.h>
 #include <linux/ethtool_netlink.h>
+#include <linux/pm_runtime.h>
 
 #include "common.h"
 
@@ -429,6 +430,13 @@ int __ethtool_get_link_ksettings(struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	memset(link_ksettings, 0, sizeof(*link_ksettings));
+
+	if (pm_runtime_suspended(dev->dev.parent)) {
+		link_ksettings->base.duplex = DUPLEX_UNKNOWN;
+		link_ksettings->base.speed = SPEED_UNKNOWN;
+		return 0;
+	}
+
 	return dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
 }
 EXPORT_SYMBOL(__ethtool_get_link_ksettings);
-- 
2.17.1

