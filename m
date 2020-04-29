Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC961BE79A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgD2Tqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727069AbgD2Tqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:46:45 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F990C03C1AE;
        Wed, 29 Apr 2020 12:46:45 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n11so1504821pgl.9;
        Wed, 29 Apr 2020 12:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XjH6F4JHAAsbYpUGPSJyG+L4O1JRXxsxIBKmTIPDjzI=;
        b=Am/M+Fra115BlwqjQxLxKPRCbBQnIzHHmDlcT11xQS9aNPH1i7i/ngzEydEto3lhL2
         8XzInNVRXClXbEhg/x2vlsuVORYc8kY3EJc/xIrwfreXvVXOsyDGMK66LZt2lkP2+Cur
         WBK94538io/BEM2yTWnonxKXF+Wb7IjAv065TPLLrFPWwjk6T3bPKnCJfu9ulkWTqSrw
         UPe44r1J2F1rpg7h3lAc9YnU+GSMsC41FrKrZUeXb9XCC3pUxHvFFyPc7MXklNO5k99Z
         EeTFs+MVYq1xMKOd1m+Q4wSi6zySda5syvi/Q9Sa8rXtYyjzpaCe5X6TcGEEIEkA0jX2
         kCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XjH6F4JHAAsbYpUGPSJyG+L4O1JRXxsxIBKmTIPDjzI=;
        b=nqsU8LHkuxtbjsVtPWaJ6c4WtPBCh10g6QTFKwJhJy6sGjegD2TbdJOVB+bVqlMwT7
         GdBX0Vp23oMQ7+a2c5CdEensF7dkiQ4dWIZmVd+C7FURPKS7xxams/z1yde093dCat0F
         86I1FKe1yPutwP0B1Co9eB4SiW60v2/8jN3QUcD4HrVBst/pF5GF1oKdtnnoci7pAbf2
         tEo7lvxIwW0mnlnPdWZYXY4awks3SrtGBtAkPkEX6iQjM5xKsVC3mjsJsFcqHPJWDKnz
         gkD4uL/+FKj6p9jaeQEqX/nC943jieIQgZGv6zGGIDuT62agqirSBkAIojewhVnfUB+v
         p/dA==
X-Gm-Message-State: AGi0Pub2dEJE/kETrZNd9vXOKJzhYT6M82EZPfvaCr09uNE8QFFr452H
        97pEXTNzyNZJg8BdCH+gkgA=
X-Google-Smtp-Source: APiQypLePFv5yOMY54cHdeE5JDaDsZOYpXQ+/miotVBhNPjRT2wWfE2stENwmIfHTM5SaaSdqUGQ9g==
X-Received: by 2002:aa7:9302:: with SMTP id 2mr36128697pfj.256.1588189604814;
        Wed, 29 Apr 2020 12:46:44 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z15sm87956pjt.20.2020.04.29.12.46.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 12:46:44 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 6/7] net: bcmgenet: add support for ethtool rxnfc flows
Date:   Wed, 29 Apr 2020 12:45:51 -0700
Message-Id: <1588189552-899-7-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588189552-899-1-git-send-email-opendmb@gmail.com>
References: <1588189552-899-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enables driver support for ethtool commands of this form:
ethtool -N|-U|--config-nfc|--config-ntuple devname
    flow-type ether|ip4
    [src xx:yy:zz:aa:bb:cc [m xx:yy:zz:aa:bb:cc]]
    [dst xx:yy:zz:aa:bb:cc [m xx:yy:zz:aa:bb:cc]] [proto N [m N]]
    [src-ip x.x.x.x [m x.x.x.x]] [dst-ip x.x.x.x [m x.x.x.x]] [tos N [m N]]
    [l4proto N [m N]] [src-port N [m N]] [dst-port N [m N]] [spi N [m N]]
    [l4data N [m N]] [vlan-etype N [m N]] [vlan N [m N]]
    [dst-mac xx:yy:zz:aa:bb:cc [m xx:yy:zz:aa:bb:cc]] [action 0] [loc N] |
    delete N

Since there is only one Rx Ring in this implementation action 0 behaves no
differently from not specifying a rule.

The rules can be seen with ethtool commands of this form:
ethtool -n|-u|--show-nfc|--show-ntuple devname [rule N]

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 483 ++++++++++++++++++++++++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |  16 +
 2 files changed, 488 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index ad41944d2cc0..5ef1ea7e5312 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -479,6 +479,30 @@ static void bcmgenet_hfb_enable_filter(struct bcmgenet_priv *priv, u32 f_index)
 	reg = bcmgenet_hfb_reg_readl(priv, offset);
 	reg |= (1 << (f_index % 32));
 	bcmgenet_hfb_reg_writel(priv, reg, offset);
+	reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
+	reg |= RBUF_HFB_EN;
+	bcmgenet_hfb_reg_writel(priv, reg, HFB_CTRL);
+}
+
+static void bcmgenet_hfb_disable_filter(struct bcmgenet_priv *priv, u32 f_index)
+{
+	u32 offset, reg, reg1;
+
+	offset = HFB_FLT_ENABLE_V3PLUS;
+	reg = bcmgenet_hfb_reg_readl(priv, offset);
+	reg1 = bcmgenet_hfb_reg_readl(priv, offset + sizeof(u32));
+	if  (f_index < 32) {
+		reg1 &= ~(1 << (f_index % 32));
+		bcmgenet_hfb_reg_writel(priv, reg1, offset + sizeof(u32));
+	} else {
+		reg &= ~(1 << (f_index % 32));
+		bcmgenet_hfb_reg_writel(priv, reg, offset);
+	}
+	if (!reg && !reg1) {
+		reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
+		reg &= ~RBUF_HFB_EN;
+		bcmgenet_hfb_reg_writel(priv, reg, HFB_CTRL);
+	}
 }
 
 static void bcmgenet_hfb_set_filter_rx_queue_mapping(struct bcmgenet_priv *priv,
@@ -513,13 +537,213 @@ static int bcmgenet_hfb_find_unused_filter(struct bcmgenet_priv *priv)
 {
 	u32 f_index;
 
-	for (f_index = 0; f_index < priv->hw_params->hfb_filter_cnt; f_index++)
+	/* First MAX_NUM_OF_FS_RULES are reserved for Rx NFC filters */
+	for (f_index = MAX_NUM_OF_FS_RULES;
+	     f_index < priv->hw_params->hfb_filter_cnt; f_index++)
 		if (!bcmgenet_hfb_is_filter_enabled(priv, f_index))
 			return f_index;
 
 	return -ENOMEM;
 }
 
+static int bcmgenet_hfb_validate_mask(void *mask, size_t size)
+{
+	while (size) {
+		switch (*(unsigned char *)mask++) {
+		case 0x00:
+		case 0x0f:
+		case 0xf0:
+		case 0xff:
+			size--;
+			continue;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+#define VALIDATE_MASK(x) \
+	bcmgenet_hfb_validate_mask(&(x), sizeof(x))
+
+static int bcmgenet_hfb_insert_data(u32 *f, int offset,
+				    void *val, void *mask, size_t size)
+{
+	int index;
+	u32 tmp;
+
+	index = offset / 2;
+	tmp = f[index];
+
+	while (size--) {
+		if (offset++ & 1) {
+			tmp &= ~0x300FF;
+			tmp |= (*(unsigned char *)val++);
+			switch ((*(unsigned char *)mask++)) {
+			case 0xFF:
+				tmp |= 0x30000;
+				break;
+			case 0xF0:
+				tmp |= 0x20000;
+				break;
+			case 0x0F:
+				tmp |= 0x10000;
+				break;
+			}
+			f[index++] = tmp;
+			if (size)
+				tmp = f[index];
+		} else {
+			tmp &= ~0xCFF00;
+			tmp |= (*(unsigned char *)val++) << 8;
+			switch ((*(unsigned char *)mask++)) {
+			case 0xFF:
+				tmp |= 0xC0000;
+				break;
+			case 0xF0:
+				tmp |= 0x80000;
+				break;
+			case 0x0F:
+				tmp |= 0x40000;
+				break;
+			}
+			if (!size)
+				f[index] = tmp;
+		}
+	}
+
+	return 0;
+}
+
+static void bcmgenet_hfb_set_filter(struct bcmgenet_priv *priv, u32 *f_data,
+				    u32 f_length, u32 rx_queue, int f_index)
+{
+	u32 base = f_index * priv->hw_params->hfb_filter_size;
+	int i;
+
+	for (i = 0; i < f_length; i++)
+		bcmgenet_hfb_writel(priv, f_data[i], (base + i) * sizeof(u32));
+
+	bcmgenet_hfb_set_filter_length(priv, f_index, 2 * f_length);
+	bcmgenet_hfb_set_filter_rx_queue_mapping(priv, f_index, rx_queue);
+}
+
+static int bcmgenet_hfb_create_rxnfc_filter(struct bcmgenet_priv *priv,
+					    struct bcmgenet_rxnfc_rule *rule)
+{
+	struct ethtool_rx_flow_spec *fs = &rule->fs;
+	int err = 0, offset = 0, f_length = 0;
+	u16 val_16, mask_16;
+	u8 val_8, mask_8;
+	size_t size;
+	u32 *f_data;
+
+	f_data = kcalloc(priv->hw_params->hfb_filter_size, sizeof(u32),
+			 GFP_KERNEL);
+	if (!f_data)
+		return -ENOMEM;
+
+	if (fs->flow_type & FLOW_MAC_EXT) {
+		bcmgenet_hfb_insert_data(f_data, 0,
+					 &fs->h_ext.h_dest, &fs->m_ext.h_dest,
+					 sizeof(fs->h_ext.h_dest));
+	}
+
+	if (fs->flow_type & FLOW_EXT) {
+		if (fs->m_ext.vlan_etype ||
+		    fs->m_ext.vlan_tci) {
+			bcmgenet_hfb_insert_data(f_data, 12,
+						 &fs->h_ext.vlan_etype,
+						 &fs->m_ext.vlan_etype,
+						 sizeof(fs->h_ext.vlan_etype));
+			bcmgenet_hfb_insert_data(f_data, 14,
+						 &fs->h_ext.vlan_tci,
+						 &fs->m_ext.vlan_tci,
+						 sizeof(fs->h_ext.vlan_tci));
+			offset += VLAN_HLEN;
+			f_length += DIV_ROUND_UP(VLAN_HLEN, 2);
+		}
+	}
+
+	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT)) {
+	case ETHER_FLOW:
+		f_length += DIV_ROUND_UP(ETH_HLEN, 2);
+		bcmgenet_hfb_insert_data(f_data, 0,
+					 &fs->h_u.ether_spec.h_dest,
+					 &fs->m_u.ether_spec.h_dest,
+					 sizeof(fs->h_u.ether_spec.h_dest));
+		bcmgenet_hfb_insert_data(f_data, ETH_ALEN,
+					 &fs->h_u.ether_spec.h_source,
+					 &fs->m_u.ether_spec.h_source,
+					 sizeof(fs->h_u.ether_spec.h_source));
+		bcmgenet_hfb_insert_data(f_data, (2 * ETH_ALEN) + offset,
+					 &fs->h_u.ether_spec.h_proto,
+					 &fs->m_u.ether_spec.h_proto,
+					 sizeof(fs->h_u.ether_spec.h_proto));
+		break;
+	case IP_USER_FLOW:
+		f_length += DIV_ROUND_UP(ETH_HLEN + 20, 2);
+		/* Specify IP Ether Type */
+		val_16 = htons(ETH_P_IP);
+		mask_16 = 0xFFFF;
+		bcmgenet_hfb_insert_data(f_data, (2 * ETH_ALEN) + offset,
+					 &val_16, &mask_16, sizeof(val_16));
+		bcmgenet_hfb_insert_data(f_data, 15 + offset,
+					 &fs->h_u.usr_ip4_spec.tos,
+					 &fs->m_u.usr_ip4_spec.tos,
+					 sizeof(fs->h_u.usr_ip4_spec.tos));
+		bcmgenet_hfb_insert_data(f_data, 23 + offset,
+					 &fs->h_u.usr_ip4_spec.proto,
+					 &fs->m_u.usr_ip4_spec.proto,
+					 sizeof(fs->h_u.usr_ip4_spec.proto));
+		bcmgenet_hfb_insert_data(f_data, 26 + offset,
+					 &fs->h_u.usr_ip4_spec.ip4src,
+					 &fs->m_u.usr_ip4_spec.ip4src,
+					 sizeof(fs->h_u.usr_ip4_spec.ip4src));
+		bcmgenet_hfb_insert_data(f_data, 30 + offset,
+					 &fs->h_u.usr_ip4_spec.ip4dst,
+					 &fs->m_u.usr_ip4_spec.ip4dst,
+					 sizeof(fs->h_u.usr_ip4_spec.ip4dst));
+		if (!fs->m_u.usr_ip4_spec.l4_4_bytes)
+			break;
+
+		/* Only supports 20 byte IPv4 header */
+		val_8 = 0x45;
+		mask_8 = 0xFF;
+		bcmgenet_hfb_insert_data(f_data, ETH_HLEN + offset,
+					 &val_8, &mask_8,
+					 sizeof(val_8));
+		size = sizeof(fs->h_u.usr_ip4_spec.l4_4_bytes);
+		bcmgenet_hfb_insert_data(f_data,
+					 ETH_HLEN + 20 + offset,
+					 &fs->h_u.usr_ip4_spec.l4_4_bytes,
+					 &fs->m_u.usr_ip4_spec.l4_4_bytes,
+					 size);
+		f_length += DIV_ROUND_UP(size, 2);
+		break;
+	}
+
+	if (!fs->ring_cookie) {
+		/* Ring 0 flows can be handled by the default Descriptor Ring
+		 * We'll map them to ring 0, but don't enable the filter
+		 */
+		bcmgenet_hfb_set_filter(priv, f_data, f_length,	0,
+					fs->location);
+		rule->state = BCMGENET_RXNFC_STATE_DISABLED;
+	} else {
+		/* Other Rx rings are direct mapped here */
+		bcmgenet_hfb_set_filter(priv, f_data, f_length,
+					fs->ring_cookie, fs->location);
+		bcmgenet_hfb_enable_filter(priv, fs->location);
+		rule->state = BCMGENET_RXNFC_STATE_ENABLED;
+	}
+
+	kfree(f_data);
+
+	return err;
+}
+
 /* bcmgenet_hfb_add_filter
  *
  * Add new filter to Hardware Filter Block to match and direct Rx traffic to
@@ -559,7 +783,6 @@ int bcmgenet_hfb_add_filter(struct bcmgenet_priv *priv, u32 *f_data,
 			    u32 f_length, u32 rx_queue)
 {
 	int f_index;
-	u32 i;
 
 	f_index = bcmgenet_hfb_find_unused_filter(priv);
 	if (f_index < 0)
@@ -568,15 +791,8 @@ int bcmgenet_hfb_add_filter(struct bcmgenet_priv *priv, u32 *f_data,
 	if (f_length > priv->hw_params->hfb_filter_size)
 		return -EINVAL;
 
-	for (i = 0; i < f_length; i++)
-		bcmgenet_hfb_writel(priv, f_data[i],
-			(f_index * priv->hw_params->hfb_filter_size + i) *
-			sizeof(u32));
-
-	bcmgenet_hfb_set_filter_length(priv, f_index, 2 * f_length);
-	bcmgenet_hfb_set_filter_rx_queue_mapping(priv, f_index, rx_queue);
+	bcmgenet_hfb_set_filter(priv, f_data, f_length, rx_queue, f_index);
 	bcmgenet_hfb_enable_filter(priv, f_index);
-	bcmgenet_hfb_reg_writel(priv, 0x1, HFB_CTRL);
 
 	return 0;
 }
@@ -607,9 +823,17 @@ static void bcmgenet_hfb_clear(struct bcmgenet_priv *priv)
 
 static void bcmgenet_hfb_init(struct bcmgenet_priv *priv)
 {
+	int i;
+
 	if (GENET_IS_V1(priv) || GENET_IS_V2(priv))
 		return;
 
+	INIT_LIST_HEAD(&priv->rxnfc_list);
+	for (i = 0; i < MAX_NUM_OF_FS_RULES; i++) {
+		INIT_LIST_HEAD(&priv->rxnfc_rules[i].list);
+		priv->rxnfc_rules[i].state = BCMGENET_RXNFC_STATE_UNUSED;
+	}
+
 	bcmgenet_hfb_clear(priv);
 }
 
@@ -1197,6 +1421,228 @@ static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_eee *e)
 	return phy_ethtool_set_eee(dev->phydev, e);
 }
 
+static int bcmgenet_validate_flow(struct net_device *dev,
+				  struct ethtool_rxnfc *cmd)
+{
+	struct ethtool_usrip4_spec *l4_mask;
+	struct ethhdr *eth_mask;
+
+	if (cmd->fs.location >= MAX_NUM_OF_FS_RULES) {
+		netdev_err(dev, "rxnfc: Invalid location (%d)\n",
+			   cmd->fs.location);
+		return -EINVAL;
+	}
+
+	switch (cmd->fs.flow_type & ~(FLOW_EXT | FLOW_MAC_EXT)) {
+	case IP_USER_FLOW:
+		l4_mask = &cmd->fs.m_u.usr_ip4_spec;
+		/* don't allow mask which isn't valid */
+		if (VALIDATE_MASK(l4_mask->ip4src) ||
+		    VALIDATE_MASK(l4_mask->ip4dst) ||
+		    VALIDATE_MASK(l4_mask->l4_4_bytes) ||
+		    VALIDATE_MASK(l4_mask->proto) ||
+		    VALIDATE_MASK(l4_mask->ip_ver) ||
+		    VALIDATE_MASK(l4_mask->tos)) {
+			netdev_err(dev, "rxnfc: Unsupported mask\n");
+			return -EINVAL;
+		}
+		break;
+	case ETHER_FLOW:
+		eth_mask = &cmd->fs.m_u.ether_spec;
+		/* don't allow mask which isn't valid */
+		if (VALIDATE_MASK(eth_mask->h_source) ||
+		    VALIDATE_MASK(eth_mask->h_source) ||
+		    VALIDATE_MASK(eth_mask->h_proto)) {
+			netdev_err(dev, "rxnfc: Unsupported mask\n");
+			return -EINVAL;
+		}
+		break;
+	default:
+		netdev_err(dev, "rxnfc: Unsupported flow type (0x%x)\n",
+			   cmd->fs.flow_type);
+		return -EINVAL;
+	}
+
+	if ((cmd->fs.flow_type & FLOW_EXT)) {
+		/* don't allow mask which isn't valid */
+		if (VALIDATE_MASK(cmd->fs.m_ext.vlan_etype) ||
+		    VALIDATE_MASK(cmd->fs.m_ext.vlan_tci)) {
+			netdev_err(dev, "rxnfc: Unsupported mask\n");
+			return -EINVAL;
+		}
+		if (cmd->fs.m_ext.data[0] || cmd->fs.m_ext.data[1]) {
+			netdev_err(dev, "rxnfc: user-def not supported\n");
+			return -EINVAL;
+		}
+	}
+
+	if ((cmd->fs.flow_type & FLOW_MAC_EXT)) {
+		/* don't allow mask which isn't valid */
+		if (VALIDATE_MASK(cmd->fs.m_ext.h_dest)) {
+			netdev_err(dev, "rxnfc: Unsupported mask\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int bcmgenet_insert_flow(struct net_device *dev,
+				struct ethtool_rxnfc *cmd)
+{
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+	struct bcmgenet_rxnfc_rule *loc_rule;
+	int err;
+
+	if (priv->hw_params->hfb_filter_size < 128) {
+		netdev_err(dev, "rxnfc: Not supported by this device\n");
+		return -EINVAL;
+	}
+
+	if (cmd->fs.ring_cookie > priv->hw_params->rx_queues) {
+		netdev_err(dev, "rxnfc: Unsupported action (%llu)\n",
+			   cmd->fs.ring_cookie);
+		return -EINVAL;
+	}
+
+	err = bcmgenet_validate_flow(dev, cmd);
+	if (err)
+		return err;
+
+	loc_rule = &priv->rxnfc_rules[cmd->fs.location];
+	if (loc_rule->state == BCMGENET_RXNFC_STATE_ENABLED)
+		bcmgenet_hfb_disable_filter(priv, cmd->fs.location);
+	if (loc_rule->state != BCMGENET_RXNFC_STATE_UNUSED)
+		list_del(&loc_rule->list);
+	loc_rule->state = BCMGENET_RXNFC_STATE_UNUSED;
+	memcpy(&loc_rule->fs, &cmd->fs,
+	       sizeof(struct ethtool_rx_flow_spec));
+
+	err = bcmgenet_hfb_create_rxnfc_filter(priv, loc_rule);
+	if (err) {
+		netdev_err(dev, "rxnfc: Could not install rule (%d)\n",
+			   err);
+		return err;
+	}
+
+	list_add_tail(&loc_rule->list, &priv->rxnfc_list);
+
+	return 0;
+}
+
+static int bcmgenet_delete_flow(struct net_device *dev,
+				struct ethtool_rxnfc *cmd)
+{
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+	struct bcmgenet_rxnfc_rule *rule;
+	int err = 0;
+
+	if (cmd->fs.location >= MAX_NUM_OF_FS_RULES)
+		return -EINVAL;
+
+	rule = &priv->rxnfc_rules[cmd->fs.location];
+	if (rule->state == BCMGENET_RXNFC_STATE_UNUSED) {
+		err =  -ENOENT;
+		goto out;
+	}
+
+	if (rule->state == BCMGENET_RXNFC_STATE_ENABLED)
+		bcmgenet_hfb_disable_filter(priv, cmd->fs.location);
+	if (rule->state != BCMGENET_RXNFC_STATE_UNUSED)
+		list_del(&rule->list);
+	rule->state = BCMGENET_RXNFC_STATE_UNUSED;
+	memset(&rule->fs, 0, sizeof(struct ethtool_rx_flow_spec));
+
+out:
+	return err;
+}
+
+static int bcmgenet_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
+{
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+	int err = 0;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_SRXCLSRLINS:
+		err = bcmgenet_insert_flow(dev, cmd);
+		break;
+	case ETHTOOL_SRXCLSRLDEL:
+		err = bcmgenet_delete_flow(dev, cmd);
+		break;
+	default:
+		netdev_warn(priv->dev, "Unsupported ethtool command. (%d)\n",
+			    cmd->cmd);
+		return -EINVAL;
+	}
+
+	return err;
+}
+
+static int bcmgenet_get_flow(struct net_device *dev, struct ethtool_rxnfc *cmd,
+			     int loc)
+{
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+	struct bcmgenet_rxnfc_rule *rule;
+	int err = 0;
+
+	if (loc < 0 || loc >= MAX_NUM_OF_FS_RULES)
+		return -EINVAL;
+
+	rule = &priv->rxnfc_rules[loc];
+	if (rule->state == BCMGENET_RXNFC_STATE_UNUSED)
+		err = -ENOENT;
+	else
+		memcpy(&cmd->fs, &rule->fs,
+		       sizeof(struct ethtool_rx_flow_spec));
+
+	return err;
+}
+
+static int bcmgenet_get_num_flows(struct bcmgenet_priv *priv)
+{
+	struct list_head *pos;
+	int res = 0;
+
+	list_for_each(pos, &priv->rxnfc_list)
+		res++;
+
+	return res;
+}
+
+static int bcmgenet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
+			      u32 *rule_locs)
+{
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+	struct bcmgenet_rxnfc_rule *rule;
+	int err = 0;
+	int i = 0;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_GRXRINGS:
+		cmd->data = priv->hw_params->rx_queues ?: 1;
+		break;
+	case ETHTOOL_GRXCLSRLCNT:
+		cmd->rule_cnt = bcmgenet_get_num_flows(priv);
+		cmd->data = MAX_NUM_OF_FS_RULES;
+		break;
+	case ETHTOOL_GRXCLSRULE:
+		err = bcmgenet_get_flow(dev, cmd, cmd->fs.location);
+		break;
+	case ETHTOOL_GRXCLSRLALL:
+		list_for_each_entry(rule, &priv->rxnfc_list, list)
+			if (i < cmd->rule_cnt)
+				rule_locs[i++] = rule->fs.location;
+		cmd->rule_cnt = i;
+		cmd->data = MAX_NUM_OF_FS_RULES;
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
 /* standard ethtool support functions. */
 static const struct ethtool_ops bcmgenet_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
@@ -1221,6 +1667,8 @@ static const struct ethtool_ops bcmgenet_ethtool_ops = {
 	.get_link_ksettings	= bcmgenet_get_link_ksettings,
 	.set_link_ksettings	= bcmgenet_set_link_ksettings,
 	.get_ts_info		= ethtool_op_get_ts_info,
+	.get_rxnfc		= bcmgenet_get_rxnfc,
+	.set_rxnfc		= bcmgenet_set_rxnfc,
 };
 
 /* Power down the unimac, based on mode. */
@@ -3730,8 +4178,8 @@ static int bcmgenet_resume(struct device *d)
 	struct net_device *dev = dev_get_drvdata(d);
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	unsigned long dma_ctrl;
+	u32 offset, reg;
 	int ret;
-	u32 reg;
 
 	if (!netif_running(dev))
 		return 0;
@@ -3766,6 +4214,11 @@ static int bcmgenet_resume(struct device *d)
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
+	offset = HFB_FLT_ENABLE_V3PLUS;
+	bcmgenet_hfb_reg_writel(priv, priv->hfb_en[1], offset);
+	bcmgenet_hfb_reg_writel(priv, priv->hfb_en[2], offset + sizeof(u32));
+	bcmgenet_hfb_reg_writel(priv, priv->hfb_en[0], HFB_CTRL);
+
 	if (priv->internal_phy) {
 		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
 		reg |= EXT_ENERGY_DET_MASK;
@@ -3809,6 +4262,7 @@ static int bcmgenet_suspend(struct device *d)
 	struct net_device *dev = dev_get_drvdata(d);
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	int ret = 0;
+	u32 offset;
 
 	if (!netif_running(dev))
 		return 0;
@@ -3820,6 +4274,13 @@ static int bcmgenet_suspend(struct device *d)
 	if (!device_may_wakeup(d))
 		phy_suspend(dev->phydev);
 
+	/* Preserve filter state and disable filtering */
+	priv->hfb_en[0] = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
+	offset = HFB_FLT_ENABLE_V3PLUS;
+	priv->hfb_en[1] = bcmgenet_hfb_reg_readl(priv, offset);
+	priv->hfb_en[2] = bcmgenet_hfb_reg_readl(priv, offset + sizeof(u32));
+	bcmgenet_hfb_reg_writel(priv, 0, HFB_CTRL);
+
 	/* Prepare the device for Wake-on-LAN and switch to the slow clock */
 	if (device_may_wakeup(d) && priv->wolopts)
 		ret = bcmgenet_power_down(priv, GENET_POWER_WOL_MAGIC);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index a858b7305832..031d91f45067 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -32,6 +32,7 @@
 #define DMA_MAX_BURST_LENGTH    0x10
 
 /* misc. configuration */
+#define MAX_NUM_OF_FS_RULES		16
 #define CLEAR_ALL_HFB			0xFF
 #define DMA_FC_THRESH_HI		(TOTAL_DESC >> 4)
 #define DMA_FC_THRESH_LO		5
@@ -609,6 +610,18 @@ struct bcmgenet_rx_ring {
 	struct bcmgenet_priv *priv;
 };
 
+enum bcmgenet_rxnfc_state {
+	BCMGENET_RXNFC_STATE_UNUSED = 0,
+	BCMGENET_RXNFC_STATE_DISABLED,
+	BCMGENET_RXNFC_STATE_ENABLED
+};
+
+struct bcmgenet_rxnfc_rule {
+	struct	list_head list;
+	struct ethtool_rx_flow_spec	fs;
+	enum bcmgenet_rxnfc_state state;
+};
+
 /* device context */
 struct bcmgenet_priv {
 	void __iomem *base;
@@ -627,6 +640,8 @@ struct bcmgenet_priv {
 	struct enet_cb *rx_cbs;
 	unsigned int num_rx_bds;
 	unsigned int rx_buf_len;
+	struct bcmgenet_rxnfc_rule rxnfc_rules[MAX_NUM_OF_FS_RULES];
+	struct list_head rxnfc_list;
 
 	struct bcmgenet_rx_ring rx_rings[DESC_INDEX + 1];
 
@@ -679,6 +694,7 @@ struct bcmgenet_priv {
 	u32 wolopts;
 	u8 sopass[SOPASS_MAX];
 	bool wol_active;
+	u32 hfb_en[3];
 
 	struct bcmgenet_mib_counters mib;
 
-- 
2.7.4

