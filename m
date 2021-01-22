Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01081300815
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 17:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbhAVQBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 11:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbhAVQBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 11:01:37 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82DFC06178B
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:00:23 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id e70so5479132ote.11
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mFLtE3g0EjsOTeRVCEtooiFyBxJeQBA83vZYyjzIIkU=;
        b=klHh1nKpjMFw44L0uVoDlefq4Va0qh4FJlG7HHQjhRbZ7E/9ZQb6nRfHAiTQ/yPStL
         vGvWAF2nXxF51zFAnKgbREbL7E6pmm4t1hxDpqHEl2zDJ0cj1IgBFQOwOWxS/QIZHGjS
         KvAZFXXH2bfrxtrUstxbDlYiV191TMnm0qk/jrET3IflQswnb88IV+rVRDJI1AfvWS2l
         k0O6NZPXyzZd9NHNgPNT+awLnYhoU5N5sdCRxhPhUASpzklZRRs3MgMqf47HiCRuVN5z
         VJPLXfBg21Mprfjd2HTLgmSUASzICTohyLjC6h3aeKdbg3q+i7ESUS6BQtdUB+ni9U7A
         nHLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mFLtE3g0EjsOTeRVCEtooiFyBxJeQBA83vZYyjzIIkU=;
        b=Qu8tij6sxKE76dQecDHPycelQ+UjpuQZ+GKGnrbJkzXawCqkDaokA2Og6KNC0yYOml
         V+zZiG//KJHQZKfxguKtGH07mBD11syxfTfC1iUfyYP1OfVetf7l9hcKnINSp+KKgtn1
         raDmXDdMeTx/1TOEQMlydErAt8qPsbtMxUl52cDe3K4f/6F9XtZ81dslrq2Xdr8MDED9
         D7o0QCTAmERPkPuSaDt4OTgDb92qAMqAI7u0Y9zUAVBQV6iTzTyk1ZjL+zeeTvSnRbmW
         8vsrblmKGtCqI800CQf2S1xslZY/nlrqaLmCUpteHyk+8QvV3aTsVqOatXhvXTmWytvw
         vilA==
X-Gm-Message-State: AOAM533s2rts6AhMDxuljfn22tMsQqIBCqsUEiR4nWF14OYbCBhNS5ko
        6UVrXeVJyY/u4Zq0YSqdqQ==
X-Google-Smtp-Source: ABdhPJxbvjb6e+YjTo6Hy2kisE5y2HLpfDXiP529boiJkENjMbruufRGec813UdHD1l0CxbD79+Kcw==
X-Received: by 2002:a05:6830:1e79:: with SMTP id m25mr3981538otr.31.1611331223138;
        Fri, 22 Jan 2021 08:00:23 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id y24sm1674942oos.44.2021.01.22.08.00.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Jan 2021 08:00:22 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Murali Karicheri <m-karicheri2@ti.com>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [RFC PATCH net-next 3/3] net: dsa: xrs700x: add HSR offloading support
Date:   Fri, 22 Jan 2021 09:59:48 -0600
Message-Id: <20210122155948.5573-4-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210122155948.5573-1-george.mccollister@gmail.com>
References: <20210122155948.5573-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add offloading for HSR/PRP (IEC 62439-3) tag insertion, tag removal
forwarding and duplication supported by the xrs7000 series switches.

Only HSR v1 and PRP v1 are supported by the xrs7000 series switches (HSR
v0 is not).

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/dsa/xrs700x/xrs700x.c     | 106 ++++++++++++++++++++++++++++++++++
 drivers/net/dsa/xrs700x/xrs700x_reg.h |   5 ++
 net/dsa/tag_xrs700x.c                 |   7 ++-
 3 files changed, 117 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 259f5e657c46..566ce9330903 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -7,6 +7,8 @@
 #include <net/dsa.h>
 #include <linux/if_bridge.h>
 #include <linux/of_device.h>
+#include <linux/netdev_features.h>
+#include <linux/if_hsr.h>
 #include "xrs700x.h"
 #include "xrs700x_reg.h"
 
@@ -496,6 +498,108 @@ static void xrs700x_bridge_leave(struct dsa_switch *ds, int port,
 	xrs700x_bridge_common(ds, port, bridge, false);
 }
 
+static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
+			    struct net_device *hsr)
+{
+	unsigned int val = XRS_HSR_CFG_HSR_PRP;
+	struct dsa_port *partner = NULL, *dp;
+	struct xrs700x *priv = ds->priv;
+	struct net_device *slave;
+	enum hsr_version ver;
+	int ret;
+
+	ret = hsr_get_version(hsr, &ver);
+	if (ret)
+		return ret;
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
+	slave = dsa_to_port(ds, port)->slave;
+
+	slave->features |= NETIF_F_HW_HSR_TAG_INS | NETIF_F_HW_HSR_TAG_RM |
+			   NETIF_F_HW_HSR_FWD | NETIF_F_HW_HSR_DUP;
+
+	return 0;
+}
+
+static void xrs700x_hsr_leave(struct dsa_switch *ds, int port,
+			      struct net_device *hsr)
+{
+	struct dsa_port *partner = NULL, *dp;
+	struct xrs700x *priv = ds->priv;
+	struct net_device *slave;
+	unsigned int val;
+
+	dsa_hsr_foreach_port(dp, ds, hsr) {
+		partner = dp;
+	}
+
+	if (!partner)
+		return;
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
+	slave = dsa_to_port(ds, port)->slave;
+
+	slave->features &= ~(NETIF_F_HW_HSR_TAG_INS | NETIF_F_HW_HSR_TAG_RM |
+			   NETIF_F_HW_HSR_FWD | NETIF_F_HW_HSR_DUP);
+}
+
 static const struct dsa_switch_ops xrs700x_ops = {
 	.get_tag_protocol	= xrs700x_get_tag_protocol,
 	.setup			= xrs700x_setup,
@@ -509,6 +613,8 @@ static const struct dsa_switch_ops xrs700x_ops = {
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

