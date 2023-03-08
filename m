Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994846B0A57
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbjCHOC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjCHOBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:01:21 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EEF3D09F;
        Wed,  8 Mar 2023 06:00:26 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0CF0D1C0002;
        Wed,  8 Mar 2023 14:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678284025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6lf6IjatvOcyoWSFI3/mxSXIMBx/zkHwZGUcOEydNR8=;
        b=AJF3cSBf4TaQaO2LV/YVHEbq7u++t/Ey4WmwvhT2pIC5jTUuxrjqyyVCqiUIHi2XNzj3nE
        Ha5ukFCiiArhYR2cdlqftJ4ChfXdo/4saBayG0AYmqNlb5u1MTEsWLmMc96OlOV/iiPqB1
        1O79SckAfDBmU/4arZd1aJBvn/tDuArCkTqhydNliZv5Vu6D3a079xm/rjiN+ZvdcILRCN
        qM8w0vvZ3TLaqS/HJPBl1/0bW4PC/OJRGVvcF3zvbAj4ggQFlsV/lRAE5k5gC/nB/dGlUU
        Vc0p8W1Xq9GE5hGxEUFwn9uW3Jo/uKMPGGB+OnPqzi6Wi7HCS0XtA1e8aYBiJA==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kory Maincent <kory.maincent@bootlin.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: [PATCH v3 3/5] net: Let the active time stamping layer be selectable.
Date:   Wed,  8 Mar 2023 14:59:27 +0100
Message-Id: <20230308135936.761794-4-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308135936.761794-1-kory.maincent@bootlin.com>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

Add the ETHTOOL_SET_PTP ethtool ioctl, and add checks in the ioctl and time
stamping paths to respect the currently selected time stamping layer.

Add a preferred-timestamp devicetree binding to select the preferred
hardware timestamp layer between PHY and MAC. The choice of using
devicetree binding has been made as the PTP precision and quality depends
of external things, like adjustable clock, or the lack of a temperature
compensated crystal or specific features. Even if the preferred timestamp
is a configuration it is hardly related to the design oh the board.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
---

Notes:
    Changes in v2:
    - Move selected_timestamping_layer introduction in this patch.
    - Replace strmcmp by sysfs_streq.
    - Use the PHY timestamp only if available.
    
    Changes in v3:
    - Added a devicetree binding to select the preferred timestamp
    - Replace the way to select timestamp through ethtool instead of sysfs
    You can test it with the ethtool source on branch feature_ptp of:
    https://github.com/kmaincent/ethtool

 Documentation/networking/ethtool-netlink.rst |  1 +
 drivers/net/phy/phy_device.c                 | 34 ++++++++++++++++
 include/linux/netdevice.h                    |  6 +++
 include/uapi/linux/ethtool.h                 |  1 +
 net/core/dev_ioctl.c                         | 43 ++++++++++++++++++--
 net/core/timestamping.c                      |  6 +++
 net/ethtool/common.c                         | 16 ++++++--
 net/ethtool/ioctl.c                          | 41 ++++++++++++++-----
 8 files changed, 131 insertions(+), 17 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index ca8e1182bc8e..4a1153dd4859 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1789,4 +1789,5 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_MODULE_SET``
   ``ETHTOOL_LIST_PTP``                n/a
   ``ETHTOOL_GET_PTP``                 n/a
+  ``ETHTOOL_SET_PTP``                 n/a
   =================================== =====================================
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8cff61dbc4b5..5e120452a358 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -34,6 +34,9 @@
 #include <linux/string.h>
 #include <linux/uaccess.h>
 #include <linux/unistd.h>
+#include <linux/of.h>
+#include <uapi/linux/net_tstamp.h>
+
 
 MODULE_DESCRIPTION("PHY library");
 MODULE_AUTHOR("Andy Fleming");
@@ -1378,6 +1381,34 @@ int phy_sfp_probe(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_sfp_probe);
 
+void of_set_timestamp(struct net_device *netdev, struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	const struct ethtool_ops *ops = netdev->ethtool_ops;
+	const char *s;
+	enum timestamping_layer ts_layer = 0;
+
+	if (phy_has_hwtstamp(phydev))
+		ts_layer = PHY_TIMESTAMPING;
+	else if (ops->get_ts_info)
+		ts_layer = MAC_TIMESTAMPING;
+
+	if (of_property_read_string(node, "preferred-timestamp", &s))
+		goto out;
+
+	if (!s)
+		goto out;
+
+	if (phy_has_hwtstamp(phydev) && !strcmp(s, "phy"))
+		ts_layer = PHY_TIMESTAMPING;
+
+	if (ops->get_ts_info && !strcmp(s, "mac"))
+		ts_layer = MAC_TIMESTAMPING;
+
+out:
+	netdev->selected_timestamping_layer = ts_layer;
+}
+
 /**
  * phy_attach_direct - attach a network device to a given PHY device pointer
  * @dev: network device to attach
@@ -1451,6 +1482,8 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	phydev->phy_link_change = phy_link_change;
 	if (dev) {
+		of_set_timestamp(dev, phydev);
+
 		phydev->attached_dev = dev;
 		dev->phydev = phydev;
 
@@ -1762,6 +1795,7 @@ void phy_detach(struct phy_device *phydev)
 
 	phy_suspend(phydev);
 	if (dev) {
+		dev->selected_timestamping_layer = MAC_TIMESTAMPING;
 		phydev->attached_dev->phydev = NULL;
 		phydev->attached_dev = NULL;
 	}
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ba2bd604359d..d9a1c12fc43c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -47,6 +47,7 @@
 #include <uapi/linux/netdevice.h>
 #include <uapi/linux/if_bonding.h>
 #include <uapi/linux/pkt_cls.h>
+#include <uapi/linux/net_tstamp.h>
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
 #include <net/net_trackers.h>
@@ -1981,6 +1982,9 @@ enum netdev_ml_priv_type {
  *
  *	@threaded:	napi threaded mode is enabled
  *
+ *	@selected_timestamping_layer:	Tracks whether the MAC or the PHY
+ *					performs packet time stamping.
+ *
  *	@net_notifier_list:	List of per-net netdev notifier block
  *				that follow this device when it is moved
  *				to another network namespace.
@@ -2339,6 +2343,8 @@ struct net_device {
 	unsigned		wol_enabled:1;
 	unsigned		threaded:1;
 
+	enum timestamping_layer selected_timestamping_layer;
+
 	struct list_head	net_notifier_list;
 
 #if IS_ENABLED(CONFIG_MACSEC)
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 56cf24388290..d3a41b6e9eb0 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1631,6 +1631,7 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_SFECPARAM	0x00000051 /* Set FEC settings */
 #define ETHTOOL_LIST_PTP	0x00000052 /* List PTP providers */
 #define ETHTOOL_GET_PTP		0x00000053 /* Get current PTP provider */
+#define ETHTOOL_SET_PTP		0x00000054 /* Set PTP provider */
 
 /* compatibility with older code */
 #define SPARC_ETH_GSET		ETHTOOL_GSET
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 7674bb9f3076..a75cff331495 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -262,6 +262,42 @@ static int dev_eth_ioctl(struct net_device *dev,
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
@@ -397,6 +433,9 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 			return err;
 		fallthrough;
 
+	case SIOCGHWTSTAMP:
+		return dev_hwtstamp_ioctl(dev, ifr, cmd);
+
 	/*
 	 *	Unknown or private ioctl
 	 */
@@ -407,9 +446,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 
 		if (cmd == SIOCGMIIPHY ||
 		    cmd == SIOCGMIIREG ||
-		    cmd == SIOCSMIIREG ||
-		    cmd == SIOCSHWTSTAMP ||
-		    cmd == SIOCGHWTSTAMP) {
+		    cmd == SIOCSMIIREG) {
 			err = dev_eth_ioctl(dev, ifr, cmd);
 		} else if (cmd == SIOCBONDENSLAVE ||
 		    cmd == SIOCBONDRELEASE ||
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
index 64a7e05cf2c2..e55e70bdbb3c 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -548,10 +548,18 @@ int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	memset(info, 0, sizeof(*info));
 	info->cmd = ETHTOOL_GET_TS_INFO;
 
-	if (phy_has_tsinfo(phydev))
-		return phy_ts_info(phydev, info);
-	if (ops->get_ts_info)
-		return ops->get_ts_info(dev, info);
+	switch (dev->selected_timestamping_layer) {
+	case MAC_TIMESTAMPING:
+		if (ops->get_ts_info)
+			return ops->get_ts_info(dev, info);
+		break;
+
+	case PHY_TIMESTAMPING:
+		if (phy_has_tsinfo(phydev))
+			return phy_ts_info(phydev, info);
+		WARN_ON(1);
+		return -ENODEV;
+	}
 
 	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
 				SOF_TIMESTAMPING_SOFTWARE;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index d8a0a5d991e0..85a074bef17d 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2343,17 +2343,8 @@ static int ethtool_get_ptp(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_value edata = {
 		.cmd = ETHTOOL_GET_PTP,
-		.data = 0,
+		.data = dev->selected_timestamping_layer,
 	};
-	struct phy_device *phydev = dev->phydev;
-	const struct ethtool_ops *ops = dev->ethtool_ops;
-
-	if (phy_has_tsinfo(phydev))
-		edata.data = PHY_TIMESTAMPING;
-	else if (ops->get_ts_info)
-		edata.data = MAC_TIMESTAMPING;
-	else
-		return -EOPNOTSUPP;
 
 	if (copy_to_user(useraddr, &edata, sizeof(edata)))
 		return -EFAULT;
@@ -2361,6 +2352,33 @@ static int ethtool_get_ptp(struct net_device *dev, void __user *useraddr)
 	return 0;
 }
 
+static int ethtool_set_ptp(struct net_device *dev, void __user *useraddr)
+{
+	struct ethtool_value edata;
+	enum timestamping_layer flavor;
+
+	if (copy_from_user(&edata, useraddr, sizeof(edata)))
+		return -EFAULT;
+
+	flavor = edata.data;
+
+	if (!dev->phydev)
+		return 0;
+
+	if (dev->selected_timestamping_layer != flavor) {
+		const struct net_device_ops *ops = dev->netdev_ops;
+		struct ifreq ifr = {0};
+
+		/* Disable time stamping in the current layer. */
+		if (netif_device_present(dev) && ops->ndo_eth_ioctl)
+			ops->ndo_eth_ioctl(dev, &ifr, SIOCSHWTSTAMP);
+
+		dev->selected_timestamping_layer = flavor;
+	}
+
+	return 0;
+}
+
 int ethtool_get_module_info_call(struct net_device *dev,
 				 struct ethtool_modinfo *modinfo)
 {
@@ -3047,6 +3065,9 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 	case ETHTOOL_GET_PTP:
 		rc = ethtool_get_ptp(dev, useraddr);
 		break;
+	case ETHTOOL_SET_PTP:
+		rc = ethtool_set_ptp(dev, useraddr);
+		break;
 	default:
 		rc = -EOPNOTSUPP;
 	}
-- 
2.25.1

