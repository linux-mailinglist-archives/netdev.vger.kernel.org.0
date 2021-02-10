Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94EE315BE1
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 02:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhBJBGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 20:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbhBJBEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 20:04:24 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E80C06178A
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 17:02:57 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id e4so319898ote.5
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 17:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Jx62OiEXDib1xRp8Mx3bWL31WWrS0KuHnddJf9fxMWc=;
        b=drch+NcOACwp3xLlsktQfowO4ymrayUZZyh9sRI5uHxD4tsYal0NHALWMSWC1Olgze
         sh4fifoqdQCj4Qb5UesjoaFm5JDmgItcbHAcOG1da2oE9RchDuNP8++/wrO9ZsnKmhQu
         Y9Uy9aisd3cAOr/LBD2djzvRNvo2GG4cuAW1KdAp0y3mVFD+HgMgT0M7e2Fc3xLY1geu
         eMxofwAGC5YcdqNC5BCBvdtlYkY74VBNmbpRtzbgzXLceLghJIhcoc6l7zcZhVMPBOpH
         rJR0wfbZvtvDmOJz9SgZpeS+18u5T97YxhGT8AqZyREK7j2VnxT3G6mLFkJiLOlg7x/U
         Wo3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Jx62OiEXDib1xRp8Mx3bWL31WWrS0KuHnddJf9fxMWc=;
        b=sWbj0ExZHBkecRkCyavGFqWXHdvURPdTeKw6EqDHBLOrFL5WeeK/8iXklNId94zNG9
         lJDkPYOTdkhAYelf7/s1mlm3LqzdLr1YusAB81GNSbQRPP/YLFoo6IPlfUjKMBnPx5wU
         I1G9d/8nR5O/CeVK2ZsddKsdkHSl7NiV21QfjCkxUXAVapTVFFtfgvs/jkph2hoiBvKc
         0KkNQvlueFs3Fp0sgNGtQ7HkX3VJ5LWDQxCONfvOP1NMHj9cHibxj6WU4JxAQeW9xAuR
         9VetlpmAPcj7q9cQ0cwlJMKsRXAL3wxu4UTZF/1N8ZeUTcEv4kU8vyx8JoOpyqs1Ibfq
         kI7Q==
X-Gm-Message-State: AOAM5329GMNBTErYC57M4S9GfUilc2HtFoiUzj1ThYS38r4sye+585oT
        5x1AsgVULBz0MqwqaRmylQ==
X-Google-Smtp-Source: ABdhPJw8BvHnlPeZflb3n0pXcH3MHALQwzCVWuOZ8dXJwbbk3bUC9NgK+TJjExk60yJ8+otpr8SVzQ==
X-Received: by 2002:a9d:70d3:: with SMTP id w19mr290466otj.177.1612918977194;
        Tue, 09 Feb 2021 17:02:57 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id i9sm101811oii.34.2021.02.09.17.02.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 17:02:55 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v3 4/4] net: dsa: xrs700x: add HSR offloading support
Date:   Tue,  9 Feb 2021 19:02:13 -0600
Message-Id: <20210210010213.27553-5-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210210010213.27553-1-george.mccollister@gmail.com>
References: <20210210010213.27553-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add offloading for HSR/PRP (IEC 62439-3) tag insertion, tag removal
forwarding and duplication supported by the xrs7000 series switches.

Only HSR v1 and PRP v1 are supported by the xrs7000 series switches (HSR
v0 is not).

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/dsa/xrs700x/xrs700x.c     | 121 ++++++++++++++++++++++++++++++++++
 drivers/net/dsa/xrs700x/xrs700x_reg.h |   5 ++
 net/dsa/tag_xrs700x.c                 |   7 +-
 3 files changed, 132 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 259f5e657c46..f025f968f96d 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -7,11 +7,17 @@
 #include <net/dsa.h>
 #include <linux/if_bridge.h>
 #include <linux/of_device.h>
+#include <linux/netdev_features.h>
+#include <linux/if_hsr.h>
 #include "xrs700x.h"
 #include "xrs700x_reg.h"
 
 #define XRS700X_MIB_INTERVAL msecs_to_jiffies(3000)
 
+#define XRS7000X_SUPPORTED_HSR_FEATURES \
+	(NETIF_F_HW_HSR_TAG_INS | NETIF_F_HW_HSR_TAG_RM | \
+	 NETIF_F_HW_HSR_FWD | NETIF_F_HW_HSR_DUP)
+
 #define XRS7003E_ID	0x100
 #define XRS7003F_ID	0x101
 #define XRS7004E_ID	0x200
@@ -496,6 +502,119 @@ static void xrs700x_bridge_leave(struct dsa_switch *ds, int port,
 	xrs700x_bridge_common(ds, port, bridge, false);
 }
 
+static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
+			    struct net_device *hsr)
+{
+	unsigned int val = XRS_HSR_CFG_HSR_PRP;
+	struct dsa_port *partner = NULL, *dp;
+	struct xrs700x *priv = ds->priv;
+	struct net_device *slave;
+	int ret, i, hsr_pair[2];
+	enum hsr_version ver;
+
+	ret = hsr_get_version(hsr, &ver);
+	if (ret)
+		return ret;
+
+	/* Only ports 1 and 2 can be HSR/PRP redundant ports. */
+	if (port != 1 && port != 2)
+		return -EOPNOTSUPP;
+
+	if (ver == HSR_V1)
+		val |= XRS_HSR_CFG_HSR;
+	else if (ver == PRP_V1)
+		val |= XRS_HSR_CFG_PRP;
+	else
+		return -EOPNOTSUPP;
+
+	dsa_hsr_foreach_port(dp, ds, hsr) {
+		partner = dp;
+	}
+
+	/* We can't enable redundancy on the switch until both
+	 * redundant ports have signed up.
+	 */
+	if (!partner)
+		return 0;
+
+	regmap_fields_write(priv->ps_forward, partner->index,
+			    XRS_PORT_DISABLED);
+	regmap_fields_write(priv->ps_forward, port, XRS_PORT_DISABLED);
+
+	regmap_write(priv->regmap, XRS_HSR_CFG(partner->index),
+		     val | XRS_HSR_CFG_LANID_A);
+	regmap_write(priv->regmap, XRS_HSR_CFG(port),
+		     val | XRS_HSR_CFG_LANID_B);
+
+	/* Clear bits for both redundant ports (HSR only) and the CPU port to
+	 * enable forwarding.
+	 */
+	val = GENMASK(ds->num_ports - 1, 0);
+	if (ver == HSR_V1) {
+		val &= ~BIT(partner->index);
+		val &= ~BIT(port);
+	}
+	val &= ~BIT(dsa_upstream_port(ds, port));
+	regmap_write(priv->regmap, XRS_PORT_FWD_MASK(partner->index), val);
+	regmap_write(priv->regmap, XRS_PORT_FWD_MASK(port), val);
+
+	regmap_fields_write(priv->ps_forward, partner->index,
+			    XRS_PORT_FORWARDING);
+	regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
+
+	hsr_pair[0] = port;
+	hsr_pair[1] = partner->index;
+	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
+		slave = dsa_to_port(ds, hsr_pair[i])->slave;
+		slave->features |= XRS7000X_SUPPORTED_HSR_FEATURES;
+	}
+
+	return 0;
+}
+
+static int xrs700x_hsr_leave(struct dsa_switch *ds, int port,
+			     struct net_device *hsr)
+{
+	struct dsa_port *partner = NULL, *dp;
+	struct xrs700x *priv = ds->priv;
+	struct net_device *slave;
+	int i, hsr_pair[2];
+	unsigned int val;
+
+	dsa_hsr_foreach_port(dp, ds, hsr) {
+		partner = dp;
+	}
+
+	if (!partner)
+		return 0;
+
+	regmap_fields_write(priv->ps_forward, partner->index,
+			    XRS_PORT_DISABLED);
+	regmap_fields_write(priv->ps_forward, port, XRS_PORT_DISABLED);
+
+	regmap_write(priv->regmap, XRS_HSR_CFG(partner->index), 0);
+	regmap_write(priv->regmap, XRS_HSR_CFG(port), 0);
+
+	/* Clear bit for the CPU port to enable forwarding. */
+	val = GENMASK(ds->num_ports - 1, 0);
+	val &= ~BIT(dsa_upstream_port(ds, port));
+	regmap_write(priv->regmap, XRS_PORT_FWD_MASK(partner->index), val);
+	regmap_write(priv->regmap, XRS_PORT_FWD_MASK(port), val);
+
+	regmap_fields_write(priv->ps_forward, partner->index,
+			    XRS_PORT_FORWARDING);
+	regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
+
+	hsr_pair[0] = port;
+	hsr_pair[1] = partner->index;
+	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
+		slave = dsa_to_port(ds, hsr_pair[i])->slave;
+		slave->features &= ~XRS7000X_SUPPORTED_HSR_FEATURES;
+	}
+
+	return 0;
+}
+
 static const struct dsa_switch_ops xrs700x_ops = {
 	.get_tag_protocol	= xrs700x_get_tag_protocol,
 	.setup			= xrs700x_setup,
@@ -509,6 +628,8 @@ static const struct dsa_switch_ops xrs700x_ops = {
 	.get_stats64		= xrs700x_get_stats64,
 	.port_bridge_join	= xrs700x_bridge_join,
 	.port_bridge_leave	= xrs700x_bridge_leave,
+	.port_hsr_join		= xrs700x_hsr_join,
+	.port_hsr_leave		= xrs700x_hsr_leave,
 };
 
 static int xrs700x_detect(struct xrs700x *priv)
diff --git a/drivers/net/dsa/xrs700x/xrs700x_reg.h b/drivers/net/dsa/xrs700x/xrs700x_reg.h
index a135d4d92b6d..470d00e07f15 100644
--- a/drivers/net/dsa/xrs700x/xrs700x_reg.h
+++ b/drivers/net/dsa/xrs700x/xrs700x_reg.h
@@ -49,6 +49,11 @@
 
 /* Port Configuration Registers - HSR/PRP */
 #define XRS_HSR_CFG(x)			(XRS_PORT_HSR_BASE(x) + 0x0)
+#define XRS_HSR_CFG_HSR_PRP		BIT(0)
+#define XRS_HSR_CFG_HSR			0
+#define XRS_HSR_CFG_PRP			BIT(8)
+#define XRS_HSR_CFG_LANID_A		0
+#define XRS_HSR_CFG_LANID_B		BIT(10)
 
 /* Port Configuration Registers - PTP */
 #define XRS_PTP_RX_SYNC_DELAY_NS_LO(x)	(XRS_PORT_PTP_BASE(x) + 0x2)
diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
index db0ed1a5fcb7..858cdf9d2913 100644
--- a/net/dsa/tag_xrs700x.c
+++ b/net/dsa/tag_xrs700x.c
@@ -11,12 +11,17 @@
 
 static struct sk_buff *xrs700x_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_port *partner, *dp = dsa_slave_to_port(dev);
 	u8 *trailer;
 
 	trailer = skb_put(skb, 1);
 	trailer[0] = BIT(dp->index);
 
+	if (dp->hsr_dev)
+		dsa_hsr_foreach_port(partner, dp->ds, dp->hsr_dev)
+			if (partner != dp)
+				trailer[0] |= BIT(partner->index);
+
 	return skb;
 }
 
-- 
2.11.0

