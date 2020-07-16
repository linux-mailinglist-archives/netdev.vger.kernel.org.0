Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B021222F2B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgGPXjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGPXjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:39:10 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DF9C061755;
        Thu, 16 Jul 2020 16:39:09 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f18so13794634wml.3;
        Thu, 16 Jul 2020 16:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aQJS4LtbLCQvfu7mGghXSDasI9/b533DTTDrGlAmNPs=;
        b=IeyrUblxNQcBMfO7BFJu0k5BstF56BkMqrVpODhO30j+amMYabdJCrZgfEb3/+KGOT
         LhygE+0gr5/oY+3unfL9aEyb+6kurkj2q1FHNn8q/qFGnvKqXwnPj7xg5fcb76ABxloP
         r+sSLgZdXGrEFIyZIidnxYZx8LXAzpYzMg4BTv14jo/gwcob16ETX/4LrOXkAp9by7mQ
         axd3GdoPU1cetyALWJ88TLhCze7GCi3hMsWBgc/w/ewYYMgeAGXeSbw4rb/BdtPMImzF
         hdv5Xsc7B9bslJhf+vfP+HDNCZDFmO5LOIagtvPjraHutuZCi5IGDRGAVUwT9+RlRnPa
         7xAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aQJS4LtbLCQvfu7mGghXSDasI9/b533DTTDrGlAmNPs=;
        b=fkr5sWu1NwGDcsn9HQNNc2kvHENbbEz5/BycY8Th10jdzzsxa4YYskDlkG3SZTa07z
         SBHJB6fKQq1CCtNtERzqcJ0JEgVyKT4YI9ls7a41mDNZOWuD+lGLC9xpkMI93iY3DUX0
         x3tsK+a5loYF07UK7iCge1VToElVbRYvkjKkX+T4XqzHaokruKfO7TzTJVhfToH65GD+
         +Y7WiTAIIgkVto+AvM2tVuNEmUdqbCmWR0MR6r7LwVmbaDUH4wSNSQzwF5LbPu3lAKEV
         /Avr41sL3IfI1MbtrBXrvOj7v+GwgRPXMS6UEF1sIJGA3QKcaapSXuVMNeg7zvOhwRRd
         FQkw==
X-Gm-Message-State: AOAM533PCH2Ib8UI/Z6/XEIiMjsZNWrnerm5kfbufGHtdcXtDtyMniR8
        TariaVpQLvu0jK7Dw8InFMU=
X-Google-Smtp-Source: ABdhPJyYVVrhdVTm5IXVaYzaW6jwyn+YVGmCVO7rLwY5GEQyaR9FSbeyptCTbo7ee5Lnp3gdJO5Plg==
X-Received: by 2002:a1c:e303:: with SMTP id a3mr6319619wmh.26.1594942748275;
        Thu, 16 Jul 2020 16:39:08 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u65sm11278013wmg.5.2020.07.16.16.39.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 16:39:07 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 3/3] net: bcmgenet: restore HFB filters on resume
Date:   Thu, 16 Jul 2020 16:38:17 -0700
Message-Id: <1594942697-37954-4-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594942697-37954-1-git-send-email-opendmb@gmail.com>
References: <1594942697-37954-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Hardware Filter Block RAM may not be preserved when the GENET
block is reset during a deep sleep, so it is not sufficient to
only backup and restore the enables.

This commit clears out the HFB block and reprograms the rxnfc
rules when the system resumes from a suspended state. To support
this the bcmgenet_hfb_create_rxnfc_filter() function is modified
to access the register space directly so that it can't fail due
to memory allocation issues.

Fixes: f50932cca632 ("net: bcmgenet: add WAKE_FILTER support")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 138 +++++++++++--------------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |   1 -
 2 files changed, 62 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index af924a8b885f..368e05b16ae9 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -543,14 +543,14 @@ static int bcmgenet_hfb_validate_mask(void *mask, size_t size)
 #define VALIDATE_MASK(x) \
 	bcmgenet_hfb_validate_mask(&(x), sizeof(x))
 
-static int bcmgenet_hfb_insert_data(u32 *f, int offset,
-				    void *val, void *mask, size_t size)
+static int bcmgenet_hfb_insert_data(struct bcmgenet_priv *priv, u32 f_index,
+				    u32 offset, void *val, void *mask,
+				    size_t size)
 {
-	int index;
-	u32 tmp;
+	u32 index, tmp;
 
-	index = offset / 2;
-	tmp = f[index];
+	index = f_index * priv->hw_params->hfb_filter_size + offset / 2;
+	tmp = bcmgenet_hfb_readl(priv, index * sizeof(u32));
 
 	while (size--) {
 		if (offset++ & 1) {
@@ -567,9 +567,10 @@ static int bcmgenet_hfb_insert_data(u32 *f, int offset,
 				tmp |= 0x10000;
 				break;
 			}
-			f[index++] = tmp;
+			bcmgenet_hfb_writel(priv, tmp, index++ * sizeof(u32));
 			if (size)
-				tmp = f[index];
+				tmp = bcmgenet_hfb_readl(priv,
+							 index * sizeof(u32));
 		} else {
 			tmp &= ~0xCFF00;
 			tmp |= (*(unsigned char *)val++) << 8;
@@ -585,44 +586,26 @@ static int bcmgenet_hfb_insert_data(u32 *f, int offset,
 				break;
 			}
 			if (!size)
-				f[index] = tmp;
+				bcmgenet_hfb_writel(priv, tmp, index * sizeof(u32));
 		}
 	}
 
 	return 0;
 }
 
-static void bcmgenet_hfb_set_filter(struct bcmgenet_priv *priv, u32 *f_data,
-				    u32 f_length, u32 rx_queue, int f_index)
-{
-	u32 base = f_index * priv->hw_params->hfb_filter_size;
-	int i;
-
-	for (i = 0; i < f_length; i++)
-		bcmgenet_hfb_writel(priv, f_data[i], (base + i) * sizeof(u32));
-
-	bcmgenet_hfb_set_filter_length(priv, f_index, 2 * f_length);
-	bcmgenet_hfb_set_filter_rx_queue_mapping(priv, f_index, rx_queue);
-}
-
-static int bcmgenet_hfb_create_rxnfc_filter(struct bcmgenet_priv *priv,
-					    struct bcmgenet_rxnfc_rule *rule)
+static void bcmgenet_hfb_create_rxnfc_filter(struct bcmgenet_priv *priv,
+					     struct bcmgenet_rxnfc_rule *rule)
 {
 	struct ethtool_rx_flow_spec *fs = &rule->fs;
-	int err = 0, offset = 0, f_length = 0;
+	u32 offset = 0, f_length = 0, f;
 	u8 val_8, mask_8;
 	__be16 val_16;
 	u16 mask_16;
 	size_t size;
-	u32 *f_data;
-
-	f_data = kcalloc(priv->hw_params->hfb_filter_size, sizeof(u32),
-			 GFP_KERNEL);
-	if (!f_data)
-		return -ENOMEM;
 
+	f = fs->location;
 	if (fs->flow_type & FLOW_MAC_EXT) {
-		bcmgenet_hfb_insert_data(f_data, 0,
+		bcmgenet_hfb_insert_data(priv, f, 0,
 					 &fs->h_ext.h_dest, &fs->m_ext.h_dest,
 					 sizeof(fs->h_ext.h_dest));
 	}
@@ -630,11 +613,11 @@ static int bcmgenet_hfb_create_rxnfc_filter(struct bcmgenet_priv *priv,
 	if (fs->flow_type & FLOW_EXT) {
 		if (fs->m_ext.vlan_etype ||
 		    fs->m_ext.vlan_tci) {
-			bcmgenet_hfb_insert_data(f_data, 12,
+			bcmgenet_hfb_insert_data(priv, f, 12,
 						 &fs->h_ext.vlan_etype,
 						 &fs->m_ext.vlan_etype,
 						 sizeof(fs->h_ext.vlan_etype));
-			bcmgenet_hfb_insert_data(f_data, 14,
+			bcmgenet_hfb_insert_data(priv, f, 14,
 						 &fs->h_ext.vlan_tci,
 						 &fs->m_ext.vlan_tci,
 						 sizeof(fs->h_ext.vlan_tci));
@@ -646,15 +629,15 @@ static int bcmgenet_hfb_create_rxnfc_filter(struct bcmgenet_priv *priv,
 	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT)) {
 	case ETHER_FLOW:
 		f_length += DIV_ROUND_UP(ETH_HLEN, 2);
-		bcmgenet_hfb_insert_data(f_data, 0,
+		bcmgenet_hfb_insert_data(priv, f, 0,
 					 &fs->h_u.ether_spec.h_dest,
 					 &fs->m_u.ether_spec.h_dest,
 					 sizeof(fs->h_u.ether_spec.h_dest));
-		bcmgenet_hfb_insert_data(f_data, ETH_ALEN,
+		bcmgenet_hfb_insert_data(priv, f, ETH_ALEN,
 					 &fs->h_u.ether_spec.h_source,
 					 &fs->m_u.ether_spec.h_source,
 					 sizeof(fs->h_u.ether_spec.h_source));
-		bcmgenet_hfb_insert_data(f_data, (2 * ETH_ALEN) + offset,
+		bcmgenet_hfb_insert_data(priv, f, (2 * ETH_ALEN) + offset,
 					 &fs->h_u.ether_spec.h_proto,
 					 &fs->m_u.ether_spec.h_proto,
 					 sizeof(fs->h_u.ether_spec.h_proto));
@@ -664,21 +647,21 @@ static int bcmgenet_hfb_create_rxnfc_filter(struct bcmgenet_priv *priv,
 		/* Specify IP Ether Type */
 		val_16 = htons(ETH_P_IP);
 		mask_16 = 0xFFFF;
-		bcmgenet_hfb_insert_data(f_data, (2 * ETH_ALEN) + offset,
+		bcmgenet_hfb_insert_data(priv, f, (2 * ETH_ALEN) + offset,
 					 &val_16, &mask_16, sizeof(val_16));
-		bcmgenet_hfb_insert_data(f_data, 15 + offset,
+		bcmgenet_hfb_insert_data(priv, f, 15 + offset,
 					 &fs->h_u.usr_ip4_spec.tos,
 					 &fs->m_u.usr_ip4_spec.tos,
 					 sizeof(fs->h_u.usr_ip4_spec.tos));
-		bcmgenet_hfb_insert_data(f_data, 23 + offset,
+		bcmgenet_hfb_insert_data(priv, f, 23 + offset,
 					 &fs->h_u.usr_ip4_spec.proto,
 					 &fs->m_u.usr_ip4_spec.proto,
 					 sizeof(fs->h_u.usr_ip4_spec.proto));
-		bcmgenet_hfb_insert_data(f_data, 26 + offset,
+		bcmgenet_hfb_insert_data(priv, f, 26 + offset,
 					 &fs->h_u.usr_ip4_spec.ip4src,
 					 &fs->m_u.usr_ip4_spec.ip4src,
 					 sizeof(fs->h_u.usr_ip4_spec.ip4src));
-		bcmgenet_hfb_insert_data(f_data, 30 + offset,
+		bcmgenet_hfb_insert_data(priv, f, 30 + offset,
 					 &fs->h_u.usr_ip4_spec.ip4dst,
 					 &fs->m_u.usr_ip4_spec.ip4dst,
 					 sizeof(fs->h_u.usr_ip4_spec.ip4dst));
@@ -688,11 +671,11 @@ static int bcmgenet_hfb_create_rxnfc_filter(struct bcmgenet_priv *priv,
 		/* Only supports 20 byte IPv4 header */
 		val_8 = 0x45;
 		mask_8 = 0xFF;
-		bcmgenet_hfb_insert_data(f_data, ETH_HLEN + offset,
+		bcmgenet_hfb_insert_data(priv, f, ETH_HLEN + offset,
 					 &val_8, &mask_8,
 					 sizeof(val_8));
 		size = sizeof(fs->h_u.usr_ip4_spec.l4_4_bytes);
-		bcmgenet_hfb_insert_data(f_data,
+		bcmgenet_hfb_insert_data(priv, f,
 					 ETH_HLEN + 20 + offset,
 					 &fs->h_u.usr_ip4_spec.l4_4_bytes,
 					 &fs->m_u.usr_ip4_spec.l4_4_bytes,
@@ -701,34 +684,42 @@ static int bcmgenet_hfb_create_rxnfc_filter(struct bcmgenet_priv *priv,
 		break;
 	}
 
+	bcmgenet_hfb_set_filter_length(priv, f, 2 * f_length);
 	if (!fs->ring_cookie || fs->ring_cookie == RX_CLS_FLOW_WAKE) {
 		/* Ring 0 flows can be handled by the default Descriptor Ring
 		 * We'll map them to ring 0, but don't enable the filter
 		 */
-		bcmgenet_hfb_set_filter(priv, f_data, f_length,	0,
-					fs->location);
+		bcmgenet_hfb_set_filter_rx_queue_mapping(priv, f, 0);
 		rule->state = BCMGENET_RXNFC_STATE_DISABLED;
 	} else {
 		/* Other Rx rings are direct mapped here */
-		bcmgenet_hfb_set_filter(priv, f_data, f_length,
-					fs->ring_cookie, fs->location);
-		bcmgenet_hfb_enable_filter(priv, fs->location);
+		bcmgenet_hfb_set_filter_rx_queue_mapping(priv, f,
+							 fs->ring_cookie);
+		bcmgenet_hfb_enable_filter(priv, f);
 		rule->state = BCMGENET_RXNFC_STATE_ENABLED;
 	}
-
-	kfree(f_data);
-
-	return err;
 }
 
 /* bcmgenet_hfb_clear
  *
  * Clear Hardware Filter Block and disable all filtering.
  */
+static void bcmgenet_hfb_clear_filter(struct bcmgenet_priv *priv, u32 f_index)
+{
+	u32 base, i;
+
+	base = f_index * priv->hw_params->hfb_filter_size;
+	for (i = 0; i < priv->hw_params->hfb_filter_size; i++)
+		bcmgenet_hfb_writel(priv, 0x0, (base + i) * sizeof(u32));
+}
+
 static void bcmgenet_hfb_clear(struct bcmgenet_priv *priv)
 {
 	u32 i;
 
+	if (GENET_IS_V1(priv) || GENET_IS_V2(priv))
+		return;
+
 	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_CTRL);
 	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_FLT_ENABLE_V3PLUS);
 	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_FLT_ENABLE_V3PLUS + 4);
@@ -740,19 +731,18 @@ static void bcmgenet_hfb_clear(struct bcmgenet_priv *priv)
 		bcmgenet_hfb_reg_writel(priv, 0x0,
 					HFB_FLT_LEN_V3PLUS + i * sizeof(u32));
 
-	for (i = 0; i < priv->hw_params->hfb_filter_cnt *
-			priv->hw_params->hfb_filter_size; i++)
-		bcmgenet_hfb_writel(priv, 0x0, i * sizeof(u32));
+	for (i = 0; i < priv->hw_params->hfb_filter_cnt; i++)
+		bcmgenet_hfb_clear_filter(priv, i);
 }
 
 static void bcmgenet_hfb_init(struct bcmgenet_priv *priv)
 {
 	int i;
 
+	INIT_LIST_HEAD(&priv->rxnfc_list);
 	if (GENET_IS_V1(priv) || GENET_IS_V2(priv))
 		return;
 
-	INIT_LIST_HEAD(&priv->rxnfc_list);
 	for (i = 0; i < MAX_NUM_OF_FS_RULES; i++) {
 		INIT_LIST_HEAD(&priv->rxnfc_rules[i].list);
 		priv->rxnfc_rules[i].state = BCMGENET_RXNFC_STATE_UNUSED;
@@ -1437,18 +1427,15 @@ static int bcmgenet_insert_flow(struct net_device *dev,
 	loc_rule = &priv->rxnfc_rules[cmd->fs.location];
 	if (loc_rule->state == BCMGENET_RXNFC_STATE_ENABLED)
 		bcmgenet_hfb_disable_filter(priv, cmd->fs.location);
-	if (loc_rule->state != BCMGENET_RXNFC_STATE_UNUSED)
+	if (loc_rule->state != BCMGENET_RXNFC_STATE_UNUSED) {
 		list_del(&loc_rule->list);
+		bcmgenet_hfb_clear_filter(priv, cmd->fs.location);
+	}
 	loc_rule->state = BCMGENET_RXNFC_STATE_UNUSED;
 	memcpy(&loc_rule->fs, &cmd->fs,
 	       sizeof(struct ethtool_rx_flow_spec));
 
-	err = bcmgenet_hfb_create_rxnfc_filter(priv, loc_rule);
-	if (err) {
-		netdev_err(dev, "rxnfc: Could not install rule (%d)\n",
-			   err);
-		return err;
-	}
+	bcmgenet_hfb_create_rxnfc_filter(priv, loc_rule);
 
 	list_add_tail(&loc_rule->list, &priv->rxnfc_list);
 
@@ -1473,8 +1460,10 @@ static int bcmgenet_delete_flow(struct net_device *dev,
 
 	if (rule->state == BCMGENET_RXNFC_STATE_ENABLED)
 		bcmgenet_hfb_disable_filter(priv, cmd->fs.location);
-	if (rule->state != BCMGENET_RXNFC_STATE_UNUSED)
+	if (rule->state != BCMGENET_RXNFC_STATE_UNUSED) {
 		list_del(&rule->list);
+		bcmgenet_hfb_clear_filter(priv, cmd->fs.location);
+	}
 	rule->state = BCMGENET_RXNFC_STATE_UNUSED;
 	memset(&rule->fs, 0, sizeof(struct ethtool_rx_flow_spec));
 
@@ -4129,8 +4118,9 @@ static int bcmgenet_resume(struct device *d)
 {
 	struct net_device *dev = dev_get_drvdata(d);
 	struct bcmgenet_priv *priv = netdev_priv(dev);
+	struct bcmgenet_rxnfc_rule *rule;
 	unsigned long dma_ctrl;
-	u32 offset, reg;
+	u32 reg;
 	int ret;
 
 	if (!netif_running(dev))
@@ -4161,10 +4151,11 @@ static int bcmgenet_resume(struct device *d)
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	offset = HFB_FLT_ENABLE_V3PLUS;
-	bcmgenet_hfb_reg_writel(priv, priv->hfb_en[1], offset);
-	bcmgenet_hfb_reg_writel(priv, priv->hfb_en[2], offset + sizeof(u32));
-	bcmgenet_hfb_reg_writel(priv, priv->hfb_en[0], HFB_CTRL);
+	/* Restore hardware filters */
+	bcmgenet_hfb_clear(priv);
+	list_for_each_entry(rule, &priv->rxnfc_list, list)
+		if (rule->state != BCMGENET_RXNFC_STATE_UNUSED)
+			bcmgenet_hfb_create_rxnfc_filter(priv, rule);
 
 	if (priv->internal_phy) {
 		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
@@ -4208,7 +4199,6 @@ static int bcmgenet_suspend(struct device *d)
 {
 	struct net_device *dev = dev_get_drvdata(d);
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	u32 offset;
 
 	if (!netif_running(dev))
 		return 0;
@@ -4220,11 +4210,7 @@ static int bcmgenet_suspend(struct device *d)
 	if (!device_may_wakeup(d))
 		phy_suspend(dev->phydev);
 
-	/* Preserve filter state and disable filtering */
-	priv->hfb_en[0] = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
-	offset = HFB_FLT_ENABLE_V3PLUS;
-	priv->hfb_en[1] = bcmgenet_hfb_reg_readl(priv, offset);
-	priv->hfb_en[2] = bcmgenet_hfb_reg_readl(priv, offset + sizeof(u32));
+	/* Disable filtering */
 	bcmgenet_hfb_reg_writel(priv, 0, HFB_CTRL);
 
 	return 0;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index a12cb59298f4..f6ca01da141d 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -696,7 +696,6 @@ struct bcmgenet_priv {
 	u32 wolopts;
 	u8 sopass[SOPASS_MAX];
 	bool wol_active;
-	u32 hfb_en[3];
 
 	struct bcmgenet_mib_counters mib;
 
-- 
2.7.4

