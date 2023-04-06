Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E576D9ED0
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 19:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239764AbjDFRdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 13:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240032AbjDFRdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 13:33:41 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B1A93D8
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 10:33:21 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 183F240005;
        Thu,  6 Apr 2023 17:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680802400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AO+WFZSi5dejShmV6sNCLEI3ZlhMdfKqwn6QZy3oVuU=;
        b=GVutoYDUHz8i8nMVUkdXgANPPeKk98WnKoGCjIgb2H0PfkZ1wmuy9Ds501jCi3zHqCud/+
        oLroba+m7mTrUdD6G+KpCvcDRLeTQ+AkrxNh9my1szVeHNxDaCIS6VZbhqg9/t/1oT/jOV
        f3nVR6NeibcQemVB8E2h6/igBvNn3IZBJQOLeQut+IYLUat3tUUXe5T7ZY71Hodhp8HBuj
        xyYCaYAmGJPduzLk8RpyodyyBqM4JOISz1pYA6echA+9fa0eKgnuuf/JCv6PbzZTh87h0k
        KBcvwPAAIctZ9ZTXgqKpYIgrucx73f+Bg6sle5f8SOQ+r2GfMP68gIeoWcatdw==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, glipus@gmail.com, maxime.chevallier@bootlin.com,
        vladimir.oltean@nxp.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk,
        Kory Maincent <kory.maincent@bootlin.com>
Subject: [PATCH net-next RFC v4 4/5] net: Let the active time stamping layer be selectable.
Date:   Thu,  6 Apr 2023 19:33:07 +0200
Message-Id: <20230406173308.401924-5-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230406173308.401924-1-kory.maincent@bootlin.com>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kory Maincent <kory.maincent@bootlin.com>

Add the ETHTOOL_MSG_TS_SET ethtool netlink socket, and add checks in the
ioctl and time stamping paths to respect the currently selected time
stamping layer.

Add a preferred-timestamp devicetree binding to select the preferred
hardware timestamp layer between PHY and MAC. The choice of using
devicetree binding has been made as the PTP precision and quality depends
of external things, like adjustable clock, or the lack of a temperature
compensated crystal or specific features. Even if the preferred timestamp
is a configuration it is hardly related to the design oh the board.

Introduce a NETDEV_CHANGE_HWTSTAMP netdev notifier to let MAC or DSA know
when a hwtstamp change happen. This is useful to manage packet trap in that
case like done by the lan966x driver.

Change the API to select MAC default time stamping instead of the PHY.
Indeed the PHY is closer to the wire therefore theoretically it have less
delay than the MAC timestamping but the reality is different. Due to lower
time stamping clock frequency, latency in the MDIO bus and no PHC hardware
synchronization between different PHY, the PHY PTP is often less precise
than the MAC. The exception is for PHY designed specially for PTP case but
these board are not very widespread. For not breaking the compatibility I
introduce a whitelist to reference all current PHY that support
time stamping and let them keep the old API behavior.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
---

Notes:
    Changes in v2:
    - Move selected_timestamping_layer introduction in this patch.
    - Replace strmcmp by sysfs_streq.
    - Use the PHY timestamp only if available.
    
    Changes in v3:
    - Add a devicetree binding to select the preferred timestamp
    - Replace the way to select timestamp through ethtool instead of sysfs
    You can test it with the ethtool source on branch feature_ptp of:
    https://github.com/kmaincent/ethtool
    
    Changes in v4:
    - Change the API to select MAC default time stamping instead of the PHY.
    - Add a whitelist to no break the old timestamp PHY default preferences
      for current PHY.
    - Replace the ethtool ioctl by netlink.
    - Add a netdev notifier to allow network device to create trap on PTP
      packets. Not tested as it need to change the lan966x driver that
      implement packet traps. I will do after the hwtstamp management change
      to NDOs.

 Documentation/networking/ethtool-netlink.rst | 13 +++
 drivers/net/phy/phy_device.c                 | 85 ++++++++++++++++++++
 include/linux/netdevice.h                    | 12 +++
 include/uapi/linux/ethtool_netlink.h         |  2 +
 net/core/dev.c                               |  2 +-
 net/core/dev_ioctl.c                         | 56 ++++++++++++-
 net/core/timestamping.c                      |  6 ++
 net/ethtool/common.c                         | 15 +++-
 net/ethtool/netlink.c                        | 10 +++
 net/ethtool/netlink.h                        |  1 +
 net/ethtool/ts.c                             | 68 ++++++++++++++--
 11 files changed, 256 insertions(+), 14 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 539425fdaf7c..12996f38b956 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -2028,6 +2028,18 @@ Kernel response contents:
   ``ETHTOOL_A_TS_LAYER``   u32     available hardware timestamping
   =======================  ======  ===================================
 
+TS_SET
+======
+
+Gets transceiver module parameters.
+
+Request contents:
+
+  =============================  ======  ==============================
+  ``ETHTOOL_A_TS_HEADER``        nested  request header
+  ``ETHTOOL_A_TS_LAYER``         u32     set hardware timestamping
+  =============================  ======  ==============================
+
 Request translation
 ===================
 
@@ -2136,4 +2148,5 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_MM_SET``
   n/a                                 ``ETHTOOL_MSG_TS_GET``
   n/a                                 ``ETHTOOL_MSG_TSLIST_GET``
+  n/a                                 ``ETHTOOL_MSG_TS_SET``
   =================================== =====================================
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 917ba84105fc..d415c62938cd 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -34,6 +34,8 @@
 #include <linux/string.h>
 #include <linux/uaccess.h>
 #include <linux/unistd.h>
+#include <linux/of.h>
+#include <uapi/linux/net_tstamp.h>
 
 MODULE_DESCRIPTION("PHY library");
 MODULE_AUTHOR("Andy Fleming");
@@ -1408,6 +1410,83 @@ int phy_sfp_probe(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_sfp_probe);
 
+/**
+ * A whitelist for PHYs selected as default timesetamping.
+ * Its use is to keep compatibility with old PTP API which is selecting
+ * these PHYs as default timestamping.
+ * The new API is selecting the MAC as default timestamping.
+ */
+const char * const phy_timestamping_whitelist[] = {
+	"Broadcom BCM5411",
+	"Broadcom BCM5421",
+	"Broadcom BCM54210E",
+	"Broadcom BCM5461",
+	"Broadcom BCM54612E",
+	"Broadcom BCM5464",
+	"Broadcom BCM5481",
+	"Broadcom BCM54810",
+	"Broadcom BCM54811",
+	"Broadcom BCM5482",
+	"Broadcom BCM50610",
+	"Broadcom BCM50610M",
+	"Broadcom BCM57780",
+	"Broadcom BCM5395",
+	"Broadcom BCM53125",
+	"Broadcom BCM53128",
+	"Broadcom BCM89610",
+	"NatSemi DP83640",
+	"Microchip LAN8841 Gigabit PHY"
+	"Microchip INDY Gigabit Quad PHY",
+	"Microsemi GE VSC856X SyncE",
+	"Microsemi GE VSC8575 SyncE",
+	"Microsemi GE VSC8582 SyncE",
+	"Microsemi GE VSC8584 SyncE",
+	"NXP C45 TJA1103",
+	NULL,
+};
+
+static void of_set_timestamp(struct net_device *netdev, struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	const struct ethtool_ops *ops = netdev->ethtool_ops;
+	const char *s;
+	enum timestamping_layer ts_layer = 0;
+	int i;
+
+	/* Backward compatibility to old API */
+	for (i = 0; phy_timestamping_whitelist[i] != NULL; i++)
+	{
+		if (!strcmp(phy_timestamping_whitelist[i],
+			    phydev->drv->name)) {
+			if (phy_has_hwtstamp(phydev))
+				ts_layer = SOF_PHY_TIMESTAMPING;
+			else if (ops->get_ts_info)
+				ts_layer = SOF_MAC_TIMESTAMPING;
+			goto out;
+		}
+	}
+
+	if (ops->get_ts_info)
+		ts_layer = SOF_MAC_TIMESTAMPING;
+	else if (phy_has_hwtstamp(phydev))
+		ts_layer = SOF_PHY_TIMESTAMPING;
+
+	if (of_property_read_string(node, "preferred-timestamp", &s))
+		goto out;
+
+	if (!s)
+		goto out;
+
+	if (phy_has_hwtstamp(phydev) && !strcmp(s, "phy"))
+		ts_layer = SOF_PHY_TIMESTAMPING;
+
+	if (ops->get_ts_info && !strcmp(s, "mac"))
+		ts_layer = SOF_MAC_TIMESTAMPING;
+
+out:
+	netdev->selected_timestamping_layer = ts_layer;
+}
+
 /**
  * phy_attach_direct - attach a network device to a given PHY device pointer
  * @dev: network device to attach
@@ -1481,6 +1560,8 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	phydev->phy_link_change = phy_link_change;
 	if (dev) {
+		of_set_timestamp(dev, phydev);
+
 		phydev->attached_dev = dev;
 		dev->phydev = phydev;
 
@@ -1811,6 +1892,10 @@ void phy_detach(struct phy_device *phydev)
 
 	phy_suspend(phydev);
 	if (dev) {
+		if (dev->ethtool_ops->get_ts_info)
+			dev->selected_timestamping_layer = SOF_MAC_TIMESTAMPING;
+		else
+			dev->selected_timestamping_layer = 0;
 		phydev->attached_dev->phydev = NULL;
 		phydev->attached_dev = NULL;
 	}
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a740be3bb911..3dd6be012daf 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -48,6 +48,7 @@
 #include <uapi/linux/if_bonding.h>
 #include <uapi/linux/pkt_cls.h>
 #include <uapi/linux/netdev.h>
+#include <uapi/linux/net_tstamp.h>
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
 #include <net/net_trackers.h>
@@ -2019,6 +2020,9 @@ enum netdev_ml_priv_type {
  *
  *	@threaded:	napi threaded mode is enabled
  *
+ *	@selected_timestamping_layer:	Tracks whether the MAC or the PHY
+ *					performs packet time stamping.
+ *
  *	@net_notifier_list:	List of per-net netdev notifier block
  *				that follow this device when it is moved
  *				to another network namespace.
@@ -2388,6 +2392,8 @@ struct net_device {
 	unsigned		wol_enabled:1;
 	unsigned		threaded:1;
 
+	enum timestamping_layer selected_timestamping_layer;
+
 	struct list_head	net_notifier_list;
 
 #if IS_ENABLED(CONFIG_MACSEC)
@@ -2879,6 +2885,7 @@ enum netdev_cmd {
 	NETDEV_OFFLOAD_XSTATS_REPORT_DELTA,
 	NETDEV_XDP_FEAT_CHANGE,
 	NETDEV_PRE_CHANGE_HWTSTAMP,
+	NETDEV_CHANGE_HWTSTAMP,
 };
 const char *netdev_cmd_to_name(enum netdev_cmd cmd);
 
@@ -2934,6 +2941,11 @@ struct netdev_notifier_hwtstamp_info {
 	struct kernel_hwtstamp_config *config;
 };
 
+struct netdev_notifier_hwtstamp_layer {
+	struct netdev_notifier_info info; /* must be first */
+	enum timestamping_layer ts_layer;
+};
+
 enum netdev_offload_xstats_type {
 	NETDEV_OFFLOAD_XSTATS_TYPE_L3 = 1,
 };
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 447908393b91..4f03e7cde271 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -41,6 +41,7 @@ enum {
 	ETHTOOL_MSG_TSINFO_GET,
 	ETHTOOL_MSG_TSLIST_GET,
 	ETHTOOL_MSG_TS_GET,
+	ETHTOOL_MSG_TS_SET,
 	ETHTOOL_MSG_CABLE_TEST_ACT,
 	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
 	ETHTOOL_MSG_TUNNEL_INFO_GET,
@@ -96,6 +97,7 @@ enum {
 	ETHTOOL_MSG_TSINFO_GET_REPLY,
 	ETHTOOL_MSG_TSLIST_GET_REPLY,
 	ETHTOOL_MSG_TS_GET_REPLY,
+	ETHTOOL_MSG_TS_NTF,
 	ETHTOOL_MSG_CABLE_TEST_NTF,
 	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
 	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
diff --git a/net/core/dev.c b/net/core/dev.c
index 7ce5985be84b..481f03ef2283 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1612,7 +1612,7 @@ const char *netdev_cmd_to_name(enum netdev_cmd cmd)
 	N(SVLAN_FILTER_PUSH_INFO) N(SVLAN_FILTER_DROP_INFO)
 	N(PRE_CHANGEADDR) N(OFFLOAD_XSTATS_ENABLE) N(OFFLOAD_XSTATS_DISABLE)
 	N(OFFLOAD_XSTATS_REPORT_USED) N(OFFLOAD_XSTATS_REPORT_DELTA)
-	N(XDP_FEAT_CHANGE) N(PRE_CHANGE_HWTSTAMP)
+	N(XDP_FEAT_CHANGE) N(PRE_CHANGE_HWTSTAMP) N(CHANGE_HWTSTAMP)
 	}
 #undef N
 	return "UNKNOWN_NETDEV_EVENT";
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 6d772837eb3f..210ff1fd0574 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -7,6 +7,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/wireless.h>
 #include <linux/if_bridge.h>
+#include <linux/phy.h>
 #include <net/dsa.h>
 #include <net/wext.h>
 
@@ -252,9 +253,60 @@ static int dev_eth_ioctl(struct net_device *dev,
 	return ops->ndo_eth_ioctl(dev, ifr, cmd);
 }
 
+static int __dev_eth_ioctl(struct net_device *dev,
+			   struct ifreq *ifr, unsigned int cmd)
+{
+	struct netdev_notifier_hwtstamp_layer hwtstamp_layer = {
+		.info.dev = dev,
+		.ts_layer = dev->selected_timestamping_layer,
+	};
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct netlink_ext_ack extack = {};
+	int err;
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	switch (dev->selected_timestamping_layer) {
+	case SOF_MAC_TIMESTAMPING:
+		if (ops->ndo_do_ioctl == phy_do_ioctl) {
+			/* Some drivers set .ndo_do_ioctl to phy_do_ioctl. */
+			return -EOPNOTSUPP;
+		} else {
+			err = dev_eth_ioctl(dev, ifr, cmd);
+			if (err)
+				goto out;
+		}
+		break;
+
+	case SOF_PHY_TIMESTAMPING:
+		if (phy_has_hwtstamp(dev->phydev)) {
+			err = phy_mii_ioctl(dev->phydev, ifr, cmd);
+			if (err)
+				goto out;
+		} else {
+			return -ENODEV;
+		}
+		break;
+	}
+
+	hwtstamp_layer.info.extack = &extack;
+
+	err = call_netdevice_notifiers_info(NETDEV_CHANGE_HWTSTAMP,
+					    &hwtstamp_layer.info);
+	err = notifier_to_errno(err);
+	if (err) {
+		if (extack._msg)
+			netdev_err(dev, "%s\n", extack._msg);
+	}
+
+out:
+	return err;
+}
+
 static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 {
-	return dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
+	return __dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
 }
 
 static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
@@ -288,7 +340,7 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 		return err;
 	}
 
-	return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
+	return __dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
 }
 
 static int dev_siocbond(struct net_device *dev,
diff --git a/net/core/timestamping.c b/net/core/timestamping.c
index 04840697fe79..8bd7b2c21ab6 100644
--- a/net/core/timestamping.c
+++ b/net/core/timestamping.c
@@ -28,6 +28,9 @@ void skb_clone_tx_timestamp(struct sk_buff *skb)
 	if (!skb->sk)
 		return;
 
+	if (skb->dev->selected_timestamping_layer != SOF_PHY_TIMESTAMPING)
+		return;
+
 	type = classify(skb);
 	if (type == PTP_CLASS_NONE)
 		return;
@@ -50,6 +53,9 @@ bool skb_defer_rx_timestamp(struct sk_buff *skb)
 	if (!skb->dev || !skb->dev->phydev || !skb->dev->phydev->mii_ts)
 		return false;
 
+	if (skb->dev->selected_timestamping_layer != SOF_PHY_TIMESTAMPING)
+		return false;
+
 	if (skb_headroom(skb) < ETH_HLEN)
 		return false;
 
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 695c7c4a816b..daea7221dd25 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -637,10 +637,17 @@ int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	memset(info, 0, sizeof(*info));
 	info->cmd = ETHTOOL_GET_TS_INFO;
 
-	if (phy_has_tsinfo(phydev))
-		return phy_ts_info(phydev, info);
-	if (ops->get_ts_info)
-		return ops->get_ts_info(dev, info);
+	switch (dev->selected_timestamping_layer) {
+	case SOF_MAC_TIMESTAMPING:
+		if (ops->get_ts_info)
+			return ops->get_ts_info(dev, info);
+		break;
+
+	case SOF_PHY_TIMESTAMPING:
+		if (phy_has_tsinfo(phydev))
+			return phy_ts_info(phydev, info);
+		return -ENODEV;
+	}
 
 	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
 				SOF_TIMESTAMPING_SOFTWARE;
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 8d9e27b13e28..b753b7da51f1 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -294,6 +294,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_FEC_SET]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
 	[ETHTOOL_MSG_TS_GET]		= &ethnl_ts_request_ops,
+	[ETHTOOL_MSG_TS_SET]		= &ethnl_ts_request_ops,
 	[ETHTOOL_MSG_TSLIST_GET]	= &ethnl_tslist_request_ops,
 	[ETHTOOL_MSG_MODULE_EEPROM_GET]	= &ethnl_module_eeprom_request_ops,
 	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
@@ -671,6 +672,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_MODULE_NTF]	= &ethnl_module_request_ops,
 	[ETHTOOL_MSG_PLCA_NTF]		= &ethnl_plca_cfg_request_ops,
 	[ETHTOOL_MSG_MM_NTF]		= &ethnl_mm_request_ops,
+	[ETHTOOL_MSG_TS_NTF]		= &ethnl_ts_request_ops,
 };
 
 /* default notification handler */
@@ -766,6 +768,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_MODULE_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_PLCA_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_MM_NTF]		= ethnl_default_notify,
+	[ETHTOOL_MSG_TS_NTF]		= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -1031,6 +1034,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_ts_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_ts_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_TS_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_default_set_doit,
+		.policy = ethnl_ts_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_ts_set_policy) - 1,
+	},
 	{
 		.cmd	= ETHTOOL_MSG_CABLE_TEST_ACT,
 		.flags	= GENL_UNS_ADMIN_PERM,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 49c700777a32..ba38aa0b5506 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -426,6 +426,7 @@ extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_HEADER + 1];
 extern const struct nla_policy ethnl_eee_set_policy[ETHTOOL_A_EEE_TX_LPI_TIMER + 1];
 extern const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_HEADER + 1];
 extern const struct nla_policy ethnl_ts_get_policy[ETHTOOL_A_TS_HEADER + 1];
+extern const struct nla_policy ethnl_ts_set_policy[ETHTOOL_A_TS_LAYER + 1];
 extern const struct nla_policy ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_HEADER + 1];
 extern const struct nla_policy ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG + 1];
 extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_HEADER + 1];
diff --git a/net/ethtool/ts.c b/net/ethtool/ts.c
index a71c47ff0c6b..7a1e27add492 100644
--- a/net/ethtool/ts.c
+++ b/net/ethtool/ts.c
@@ -31,19 +31,13 @@ static int ts_prepare_data(const struct ethnl_req_info *req_base,
 {
 	struct ts_reply_data *data = TS_REPDATA(reply_base);
 	struct net_device *dev = reply_base->dev;
-	const struct ethtool_ops *ops = dev->ethtool_ops;
 	int ret;
 
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
 
-	if (phy_has_tsinfo(dev->phydev))
-		data->ts = SOF_PHY_TIMESTAMPING;
-	else if (ops->get_ts_info)
-		data->ts = SOF_MAC_TIMESTAMPING;
-	else
-		return -EOPNOTSUPP;
+	data->ts = dev->selected_timestamping_layer;
 
 	ethnl_ops_complete(dev);
 
@@ -61,9 +55,65 @@ static int ts_fill_reply(struct sk_buff *skb,
 			     const struct ethnl_reply_data *reply_base)
 {
 	struct ts_reply_data *data = TS_REPDATA(reply_base);
+
 	return nla_put_u32(skb, ETHTOOL_A_TS_LAYER, data->ts);
 }
 
+/* TS_SET */
+const struct nla_policy ethnl_ts_set_policy[] = {
+	[ETHTOOL_A_TS_HEADER]	= NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_TS_LAYER]	= { .type = NLA_U32 },
+};
+
+static int ethnl_set_ts_validate(struct ethnl_req_info *req_info,
+				 struct genl_info *info)
+{
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
+	struct net_device *dev = req_info->dev;
+	struct nlattr **tb = info->attrs;
+
+	if (!tb[ETHTOOL_A_TS_LAYER])
+		return 0;
+
+	if (!phy_has_tsinfo(dev->phydev) && !ops->get_ts_info) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_TS_LAYER],
+				    "Hardware time stamping is not supported by this device");
+		return -EOPNOTSUPP;
+	}
+
+	return 1;
+}
+
+static int ethnl_set_ts(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	struct net_device *dev = req_info->dev;
+	struct nlattr **tb = info->attrs;
+	enum timestamping_layer flavor;
+	bool mod = false;
+
+	if (!dev->phydev) {
+		return -EOPNOTSUPP;
+	}
+
+	flavor = dev->selected_timestamping_layer;
+	ethnl_update_u32(&flavor, tb[ETHTOOL_A_TS_LAYER], &mod);
+
+	if (mod) {
+		const struct net_device_ops *ops = dev->netdev_ops;
+		struct ifreq ifr = {0};
+
+		/* Disable time stamping in the current layer. */
+		if (netif_device_present(dev) && ops->ndo_eth_ioctl)
+			ops->ndo_eth_ioctl(dev, &ifr, SIOCSHWTSTAMP);
+
+		dev->selected_timestamping_layer = flavor;
+		return 1;
+	};
+
+	return 0;
+}
+
 const struct ethnl_request_ops ethnl_ts_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_TS_GET,
 	.reply_cmd		= ETHTOOL_MSG_TS_GET_REPLY,
@@ -74,6 +124,10 @@ const struct ethnl_request_ops ethnl_ts_request_ops = {
 	.prepare_data		= ts_prepare_data,
 	.reply_size		= ts_reply_size,
 	.fill_reply		= ts_fill_reply,
+
+	.set_validate		= ethnl_set_ts_validate,
+	.set			= ethnl_set_ts,
+	.set_ntf_cmd		= ETHTOOL_MSG_TS_NTF,
 };
 
 /* TSLIST_GET */
-- 
2.25.1

