Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2E06B0A55
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbjCHOCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjCHOBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:01:18 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A16EC68;
        Wed,  8 Mar 2023 06:00:14 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F28CF1C000E;
        Wed,  8 Mar 2023 14:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678284013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=czGjNh4cWwRAo6F0QrE2kkelI5xt05bawsUna3HuQGY=;
        b=f6KmTlzeblr45vlPCuhdDXzwumIUHqVM5zW3ZhhHQkz4m6xZ6w4XUZkGofI4NJ1eSK3Eky
        C82M0vJSU7AXRex6doe1WSYdMVWM6iysuLxpA7YhaTK5z0D1gZWfdanV5cnlDJh1KcGA/e
        43GJBI8m4GkSmlvziWIagMfN+7NQ5vfaVCuK51hxNr/Aqeb07vUIrEN/LMgwOq/30DhKvW
        TlfqL9507WL/Ql9LtjMyNjoxaCkgjuQRGMi07hHSSoWoEyTexyVIXabySO8IL6XTP26YNz
        w7Vq6p9R7zYJlnbF1RWcbhvLApEj2FFXfDKu5O63915H27ZFCIN8590wr2+3xw==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Kory Maincent <kory.maincent@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
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
        Alexandru Tachici <alexandru.tachici@analog.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: [PATCH v3 2/5] net: Expose available time stamping layers to user space.
Date:   Wed,  8 Mar 2023 14:59:26 +0100
Message-Id: <20230308135936.761794-3-kory.maincent@bootlin.com>
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

From: Kory Maincent <kory.maincent@bootlin.com>

Time stamping on network packets may happen either in the MAC or in
the PHY, but not both.  In preparation for making the choice
selectable, expose both the current and available layers via ethtool.

In accordance with the kernel implementation as it stands, the current
layer will always read as "phy" when a PHY time stamping device is
present.  Future patches will allow changing the current layer
administratively.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
---

Notes:
    Changes in v2:
    - Move the introduction of selected_timestamping_layer variable in next
      patch.
    
    Changes in v3:
    - Move on to ethtool instead of syfs

 Documentation/networking/ethtool-netlink.rst |  2 +
 include/uapi/linux/ethtool.h                 |  2 +
 include/uapi/linux/net_tstamp.h              |  6 +++
 net/ethtool/ioctl.c                          | 50 ++++++++++++++++++++
 4 files changed, 60 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d578b8bcd8a4..ca8e1182bc8e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1787,4 +1787,6 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_PHC_VCLOCKS_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_SET``
+  ``ETHTOOL_LIST_PTP``                n/a
+  ``ETHTOOL_GET_PTP``                 n/a
   =================================== =====================================
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index dc2aa3d75b39..56cf24388290 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1629,6 +1629,8 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_PHY_STUNABLE	0x0000004f /* Set PHY tunable configuration */
 #define ETHTOOL_GFECPARAM	0x00000050 /* Get FEC settings */
 #define ETHTOOL_SFECPARAM	0x00000051 /* Set FEC settings */
+#define ETHTOOL_LIST_PTP	0x00000052 /* List PTP providers */
+#define ETHTOOL_GET_PTP		0x00000053 /* Get current PTP provider */
 
 /* compatibility with older code */
 #define SPARC_ETH_GSET		ETHTOOL_GSET
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index 55501e5e7ac8..1ec489e18f97 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -13,6 +13,12 @@
 #include <linux/types.h>
 #include <linux/socket.h>   /* for SO_TIMESTAMPING */
 
+/* Hardware layer of the SO_TIMESTAMPING provider */
+enum timestamping_layer {
+	MAC_TIMESTAMPING = (1<<0),
+	PHY_TIMESTAMPING = (1<<1),
+};
+
 /* SO_TIMESTAMPING flags */
 enum {
 	SOF_TIMESTAMPING_TX_HARDWARE = (1<<0),
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 81fe2422fe58..d8a0a5d991e0 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2319,6 +2319,48 @@ static int ethtool_get_ts_info(struct net_device *dev, void __user *useraddr)
 	return 0;
 }
 
+static int ethtool_list_ptp(struct net_device *dev, void __user *useraddr)
+{
+	struct ethtool_value edata = {
+		.cmd = ETHTOOL_LIST_PTP,
+		.data = 0,
+	};
+	struct phy_device *phydev = dev->phydev;
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+
+	if (phy_has_tsinfo(phydev))
+		edata.data = PHY_TIMESTAMPING;
+	if (ops->get_ts_info)
+		edata.data |= MAC_TIMESTAMPING;
+
+	if (copy_to_user(useraddr, &edata, sizeof(edata)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int ethtool_get_ptp(struct net_device *dev, void __user *useraddr)
+{
+	struct ethtool_value edata = {
+		.cmd = ETHTOOL_GET_PTP,
+		.data = 0,
+	};
+	struct phy_device *phydev = dev->phydev;
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+
+	if (phy_has_tsinfo(phydev))
+		edata.data = PHY_TIMESTAMPING;
+	else if (ops->get_ts_info)
+		edata.data = MAC_TIMESTAMPING;
+	else
+		return -EOPNOTSUPP;
+
+	if (copy_to_user(useraddr, &edata, sizeof(edata)))
+		return -EFAULT;
+
+	return 0;
+}
+
 int ethtool_get_module_info_call(struct net_device *dev,
 				 struct ethtool_modinfo *modinfo)
 {
@@ -2770,6 +2812,8 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 	case ETHTOOL_PHY_GTUNABLE:
 	case ETHTOOL_GLINKSETTINGS:
 	case ETHTOOL_GFECPARAM:
+	case ETHTOOL_LIST_PTP:
+	case ETHTOOL_GET_PTP:
 		break;
 	default:
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
@@ -2997,6 +3041,12 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 	case ETHTOOL_SFECPARAM:
 		rc = ethtool_set_fecparam(dev, useraddr);
 		break;
+	case ETHTOOL_LIST_PTP:
+		rc = ethtool_list_ptp(dev, useraddr);
+		break;
+	case ETHTOOL_GET_PTP:
+		rc = ethtool_get_ptp(dev, useraddr);
+		break;
 	default:
 		rc = -EOPNOTSUPP;
 	}
-- 
2.25.1

