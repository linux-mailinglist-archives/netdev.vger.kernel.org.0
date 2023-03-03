Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362C96A9BFD
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 17:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjCCQnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 11:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjCCQna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 11:43:30 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562DE29410;
        Fri,  3 Mar 2023 08:43:25 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D2BEF40002;
        Fri,  3 Mar 2023 16:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677861804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZ91UkMulypmNWVBMqjzw2z8IeuLiIil9+GOrScIObM=;
        b=Vk4dVuMd1srKV7JC+iM96VECO5YNEE5R4FUArVO9K3NV/jnJgxCj08m6nkE4WGd3Etkry3
        9KZcAHH2iWn3WcFuJdeoLGUeXTxNIsnPVX0GcOr/nmTfgkiH+atBhCaVr7NrD7g9CIY8nd
        7+GvKL/tsjknb7iebg0hDl5z2CDniP31WsLqKLFo3iwxyRTiJSpR1UvH8qa/A5DUkXGuiq
        8+fd2t6A47K8BN4Y+5FeYZSba6B6QPT2LX++58vRr+cxARmUGIYL7MDv6JLftM7aP2Se5M
        dCKEq6CBEwQpJo6qhVpmSEtcS6ZP3WYvBm6ZJR7Yj48thmmJLPy9UWFgTmukqQ==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Richard Cochran <richardcochran@gmail.com>,
        Kory Maincent <kory.maincent@bootlin.com>,
        thomas.petazzoni@bootlin.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 3/4] net: Let the active time stamping layer be selectable.
Date:   Fri,  3 Mar 2023 17:42:40 +0100
Message-Id: <20230303164248.499286-4-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230303164248.499286-1-kory.maincent@bootlin.com>
References: <20230303164248.499286-1-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

Make the sysfs knob writable, and add checks in the ioctl and time
stamping paths to respect the currently selected time stamping layer.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
---

Notes:
    Changes in v2:
    - Move selected_timestamping_layer introduction in this patch.
    - Replace strmcmp by sysfs_streq.
    - Use the PHY timestamp only if available.

 .../ABI/testing/sysfs-class-net-timestamping  |  5 +-
 drivers/net/phy/phy_device.c                  |  6 +++
 include/linux/netdevice.h                     | 10 ++++
 net/core/dev_ioctl.c                          | 44 ++++++++++++++--
 net/core/net-sysfs.c                          | 50 +++++++++++++++++--
 net/core/timestamping.c                       |  6 +++
 net/ethtool/common.c                          | 18 +++++--
 7 files changed, 127 insertions(+), 12 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net-timestamping b/Documentation/ABI/testing/sysfs-class-net-timestamping
index 529c3a6eb607..6dfd59740cad 100644
--- a/Documentation/ABI/testing/sysfs-class-net-timestamping
+++ b/Documentation/ABI/testing/sysfs-class-net-timestamping
@@ -11,7 +11,10 @@ What:		/sys/class/net/<iface>/current_timestamping_provider
 Date:		January 2022
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
-		Show the current SO_TIMESTAMPING provider.
+		Shows or sets the current SO_TIMESTAMPING provider.
+		When changing the value, some packets in the kernel
+		networking stack may still be delivered with time
+		stamps from the previous provider.
 		The possible values are:
 		- "mac"  The MAC provides time stamping.
 		- "phy"  The PHY or MII device provides time stamping.
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8cff61dbc4b5..8dff0c6493b5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1451,6 +1451,11 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	phydev->phy_link_change = phy_link_change;
 	if (dev) {
+		if (phy_has_hwtstamp(phydev))
+			dev->selected_timestamping_layer = PHY_TIMESTAMPING;
+		else
+			dev->selected_timestamping_layer = MAC_TIMESTAMPING;
+
 		phydev->attached_dev = dev;
 		dev->phydev = phydev;
 
@@ -1762,6 +1767,7 @@ void phy_detach(struct phy_device *phydev)
 
 	phy_suspend(phydev);
 	if (dev) {
+		dev->selected_timestamping_layer = MAC_TIMESTAMPING;
 		phydev->attached_dev->phydev = NULL;
 		phydev->attached_dev = NULL;
 	}
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ba2bd604359d..d8e9da2526f0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1742,6 +1742,11 @@ enum netdev_ml_priv_type {
 	ML_PRIV_CAN,
 };
 
+enum timestamping_layer {
+	MAC_TIMESTAMPING,
+	PHY_TIMESTAMPING,
+};
+
 /**
  *	struct net_device - The DEVICE structure.
  *
@@ -1981,6 +1986,9 @@ enum netdev_ml_priv_type {
  *
  *	@threaded:	napi threaded mode is enabled
  *
+ *	@selected_timestamping_layer:	Tracks whether the MAC or the PHY
+ *					performs packet time stamping.
+ *
  *	@net_notifier_list:	List of per-net netdev notifier block
  *				that follow this device when it is moved
  *				to another network namespace.
@@ -2339,6 +2347,8 @@ struct net_device {
 	unsigned		wol_enabled:1;
 	unsigned		threaded:1;
 
+	enum timestamping_layer selected_timestamping_layer;
+
 	struct list_head	net_notifier_list;
 
 #if IS_ENABLED(CONFIG_MACSEC)
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 7674bb9f3076..cc7cf2a542fb 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -262,6 +262,43 @@ static int dev_eth_ioctl(struct net_device *dev,
 	return err;
 }
 
+static int dev_hwtstamp_ioctl(struct net_device *dev,
+			      struct ifreq *ifr, unsigned int cmd)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	int err;
+
+	err = dsa_ndo_eth_ioctl(dev, ifr, cmd);
+	if (err == 0 || err != -EOPNOTSUPP)
+		return err;
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	switch (dev->selected_timestamping_layer) {
+
+	case MAC_TIMESTAMPING:
+		if (ops->ndo_do_ioctl == phy_do_ioctl) {
+			/* Some drivers set .ndo_do_ioctl to phy_do_ioctl. */
+			err = -EOPNOTSUPP;
+		} else {
+			err = ops->ndo_eth_ioctl(dev, ifr, cmd);
+		}
+		break;
+
+	case PHY_TIMESTAMPING:
+		if (phy_has_hwtstamp(dev->phydev)) {
+			err = phy_mii_ioctl(dev->phydev, ifr, cmd);
+		} else {
+			err = -ENODEV;
+			WARN_ON(1);
+		}
+		break;
+	}
+
+	return err;
+}
+
 static int dev_siocbond(struct net_device *dev,
 			struct ifreq *ifr, unsigned int cmd)
 {
@@ -397,6 +434,9 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 			return err;
 		fallthrough;
 
+	case SIOCGHWTSTAMP:
+		return dev_hwtstamp_ioctl(dev, ifr, cmd);
+
 	/*
 	 *	Unknown or private ioctl
 	 */
@@ -407,9 +447,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 
 		if (cmd == SIOCGMIIPHY ||
 		    cmd == SIOCGMIIREG ||
-		    cmd == SIOCSMIIREG ||
-		    cmd == SIOCSHWTSTAMP ||
-		    cmd == SIOCGHWTSTAMP) {
+		    cmd == SIOCSMIIREG) {
 			err = dev_eth_ioctl(dev, ifr, cmd);
 		} else if (cmd == SIOCBONDENSLAVE ||
 		    cmd == SIOCBONDRELEASE ||
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 26095634fb31..66079424b100 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -666,17 +666,59 @@ static ssize_t current_timestamping_provider_show(struct device *dev,
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	if (phy_has_tsinfo(phydev)) {
-		ret = sprintf(buf, "%s\n", "phy");
-	} else {
+	switch (netdev->selected_timestamping_layer) {
+	case MAC_TIMESTAMPING:
 		ret = sprintf(buf, "%s\n", "mac");
+		break;
+	case PHY_TIMESTAMPING:
+		ret = sprintf(buf, "%s\n", "phy");
+		break;
 	}
 
 	rtnl_unlock();
 
 	return ret;
 }
-static DEVICE_ATTR_RO(current_timestamping_provider);
+
+static ssize_t current_timestamping_provider_store(struct device *dev,
+						   struct device_attribute *attr,
+						   const char *buf, size_t len)
+{
+	struct net_device *netdev = to_net_dev(dev);
+	struct net *net = dev_net(netdev);
+	enum timestamping_layer flavor;
+
+	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (sysfs_streq(buf, "mac"))
+		flavor = MAC_TIMESTAMPING;
+	else if (sysfs_streq(buf, "phy"))
+		flavor = PHY_TIMESTAMPING;
+	else
+		return -EINVAL;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	if (!dev_isalive(netdev))
+		goto out;
+
+	if (netdev->selected_timestamping_layer != flavor) {
+		const struct net_device_ops *ops = netdev->netdev_ops;
+		struct ifreq ifr = {0};
+
+		/* Disable time stamping in the current layer. */
+		if (netif_device_present(netdev) && ops->ndo_eth_ioctl)
+			ops->ndo_eth_ioctl(netdev, &ifr, SIOCSHWTSTAMP);
+
+		netdev->selected_timestamping_layer = flavor;
+	}
+out:
+	rtnl_unlock();
+	return len;
+}
+static DEVICE_ATTR_RW(current_timestamping_provider);
 
 static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_netdev_group.attr,
diff --git a/net/core/timestamping.c b/net/core/timestamping.c
index 04840697fe79..31c3142787b7 100644
--- a/net/core/timestamping.c
+++ b/net/core/timestamping.c
@@ -28,6 +28,9 @@ void skb_clone_tx_timestamp(struct sk_buff *skb)
 	if (!skb->sk)
 		return;
 
+	if (skb->dev->selected_timestamping_layer != PHY_TIMESTAMPING)
+		return;
+
 	type = classify(skb);
 	if (type == PTP_CLASS_NONE)
 		return;
@@ -50,6 +53,9 @@ bool skb_defer_rx_timestamp(struct sk_buff *skb)
 	if (!skb->dev || !skb->dev->phydev || !skb->dev->phydev->mii_ts)
 		return false;
 
+	if (skb->dev->selected_timestamping_layer != PHY_TIMESTAMPING)
+		return false;
+
 	if (skb_headroom(skb) < ETH_HLEN)
 		return false;
 
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 64a7e05cf2c2..255170c9345a 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -548,10 +548,20 @@ int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	memset(info, 0, sizeof(*info));
 	info->cmd = ETHTOOL_GET_TS_INFO;
 
-	if (phy_has_tsinfo(phydev))
-		return phy_ts_info(phydev, info);
-	if (ops->get_ts_info)
-		return ops->get_ts_info(dev, info);
+	switch (dev->selected_timestamping_layer) {
+
+	case MAC_TIMESTAMPING:
+		if (ops->get_ts_info)
+			return ops->get_ts_info(dev, info);
+		break;
+
+	case PHY_TIMESTAMPING:
+		if (phy_has_tsinfo(phydev)) {
+			return phy_ts_info(phydev, info);
+		}
+		WARN_ON(1);
+		return -ENODEV;
+	}
 
 	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
 				SOF_TIMESTAMPING_SOFTWARE;
-- 
2.25.1

