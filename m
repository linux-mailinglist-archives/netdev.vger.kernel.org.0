Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF0715277A
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 09:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgBEIRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 03:17:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50633 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728029AbgBEIRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 03:17:05 -0500
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1izFrN-0008RX-T9; Wed, 05 Feb 2020 08:16:34 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     davem@davemloft.ne, mkubecek@suse.cz, jeffrey.t.kirsher@intel.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jouni Hogander <jouni.hogander@unikie.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Wang Hai <wanghai26@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li RongQing <lirongqing@baidu.com>,
        linux-kernel@vger.kernel.org (open list),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH v2 2/2] net-sysfs: Ensure begin/complete are called in speed_show() and duplex_show()
Date:   Wed,  5 Feb 2020 16:16:16 +0800
Message-Id: <20200205081616.18378-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200205081616.18378-1-kai.heng.feng@canonical.com>
References: <20200205081616.18378-1-kai.heng.feng@canonical.com>
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

So let's use a new helper to call begin() and complete() like what
dev_ethtool() does, to runtime resume/suspend or power up/down the
device properly.

Once this fix is in place, igb can show the speed correctly without link
partner:
$ cat /sys/class/net/enp3s0/speed
-1

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
 - Add a new helper with begin/complete and use it in net-sysfs.

 include/linux/ethtool.h |  4 ++++
 net/core/net-sysfs.c    |  4 ++--
 net/ethtool/ioctl.c     | 33 ++++++++++++++++++++++++++++++++-
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 95991e4300bf..785ec1921417 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -160,6 +160,10 @@ extern int
 __ethtool_get_link_ksettings(struct net_device *dev,
 			     struct ethtool_link_ksettings *link_ksettings);
 
+extern int
+__ethtool_get_link_ksettings_full(struct net_device *dev,
+				  struct ethtool_link_ksettings *link_ksettings);
+
 /**
  * ethtool_intersect_link_masks - Given two link masks, AND them together
  * @dst: first mask and where result is stored
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4c826b8bf9b1..a199e15a080f 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -201,7 +201,7 @@ static ssize_t speed_show(struct device *dev,
 	if (netif_running(netdev)) {
 		struct ethtool_link_ksettings cmd;
 
-		if (!__ethtool_get_link_ksettings(netdev, &cmd))
+		if (!__ethtool_get_link_ksettings_full(netdev, &cmd))
 			ret = sprintf(buf, fmt_dec, cmd.base.speed);
 	}
 	rtnl_unlock();
@@ -221,7 +221,7 @@ static ssize_t duplex_show(struct device *dev,
 	if (netif_running(netdev)) {
 		struct ethtool_link_ksettings cmd;
 
-		if (!__ethtool_get_link_ksettings(netdev, &cmd)) {
+		if (!__ethtool_get_link_ksettings_full(netdev, &cmd)) {
 			const char *duplex;
 
 			switch (cmd.base.duplex) {
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index b987052d91ef..faeba247c1fb 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -420,7 +420,9 @@ struct ethtool_link_usettings {
 	} link_modes;
 };
 
-/* Internal kernel helper to query a device ethtool_link_settings. */
+/* Internal kernel helper to query a device ethtool_link_settings. To be called
+ * inside begin/complete block.
+ */
 int __ethtool_get_link_ksettings(struct net_device *dev,
 				 struct ethtool_link_ksettings *link_ksettings)
 {
@@ -434,6 +436,35 @@ int __ethtool_get_link_ksettings(struct net_device *dev,
 }
 EXPORT_SYMBOL(__ethtool_get_link_ksettings);
 
+/* Internal kernel helper to query a device ethtool_link_settings. To be called
+ * outside of begin/complete block.
+ */
+int __ethtool_get_link_ksettings_full(struct net_device *dev,
+				      struct ethtool_link_ksettings *link_ksettings)
+{
+	int rc;
+
+	ASSERT_RTNL();
+
+	if (!dev->ethtool_ops->get_link_ksettings)
+		return -EOPNOTSUPP;
+
+	if (dev->ethtool_ops->begin) {
+		rc = dev->ethtool_ops->begin(dev);
+		if (rc  < 0)
+			return rc;
+	}
+
+	memset(link_ksettings, 0, sizeof(*link_ksettings));
+	rc = dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
+
+	if (dev->ethtool_ops->complete)
+		dev->ethtool_ops->complete(dev);
+
+	return rc;
+}
+EXPORT_SYMBOL(__ethtool_get_link_ksettings_full);
+
 /* convert ethtool_link_usettings in user space to a kernel internal
  * ethtool_link_ksettings. return 0 on success, errno on error.
  */
-- 
2.17.1

