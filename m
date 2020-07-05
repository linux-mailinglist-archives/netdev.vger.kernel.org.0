Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D0621502B
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgGEWW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEWW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:22:56 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD644C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:22:55 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t6so17521413pgq.1
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 15:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vMYWZjZVx7ZC/G/QFLKGbQk6+sEUgrFX0n06DTIQ3Rs=;
        b=W1ljjF43FZCq7l37kCEVH5GnraFNVTdKMnNIvSTTPQ4edOiyEFo0SfE/FupQuuPQkn
         FyRHOcX0ovWujrq9xGNeSc3kDjBMClK8kFe2FIu6dxQKWzIbL6TAlPejnNHMjfmcdrKD
         Zujy0ygsJBnekbPtsFRjLXRjNH1qUo9vNxV4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vMYWZjZVx7ZC/G/QFLKGbQk6+sEUgrFX0n06DTIQ3Rs=;
        b=b5S+iOrhRAxBHb6oQblZcjNYcYIHpD1s2qO93s8eTnvpyID1tLF3KrZqbVAcu0MfX6
         N3uhYGBWUY5QAMjx7sRv1lMiYySWkwG98PHuIVN9R2vOptZveAj2AHFw/klZJXl/jLsq
         mRNcxo984vOOHn0jq/giv8nuptD41gceg3Dg6z+LR3ZN8u0Sl8p+dXfJWjnfCJCcUMCe
         U/iBvrC2HWUK2XdzLV3NuaXKmwHFeUEdp4TP7MvPjedG+zSbt9fua6Rnqj9AjfmO47y4
         YZ3Duy71XhUkKmshB+TmZzeGIH4Yqzr/B/PddS6Xq+vOPltwDVbtFxQcnxwqHJzWWo1M
         NAvw==
X-Gm-Message-State: AOAM531LXJgiPQuipSEPYFmXCbfinzFl2qdaUgnuIV2nEJ1418LlV5v8
        0Xdx6y9otniGZMoV34QbQjdu7pH7Hws=
X-Google-Smtp-Source: ABdhPJyA3tgxU5hXcMIUK+AEtoddQ4lNlKWMB3GB6il1OF3VdT2PsCwVYKfSnMsAPN/z0kZzk+x1pA==
X-Received: by 2002:a63:1406:: with SMTP id u6mr37018713pgl.108.1593987775297;
        Sun, 05 Jul 2020 15:22:55 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i184sm16843251pfc.73.2020.07.05.15.22.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Jul 2020 15:22:54 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v3 7/8] bnxt_en: clean up VLAN feature bit handling
Date:   Sun,  5 Jul 2020 18:22:11 -0400
Message-Id: <1593987732-1336-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
References: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

The hardware VLAN offload feature on our NIC does not have separate
knobs for handling customer and service tags on RX. Either offloading
of both must be enabled or both must be disabled. Introduce definitions
for the combined feature set in order to clean up the code and make
this constraint more clear. Technically these features can be separately
enabled on TX, however, since the default is to turn both on, the
combined TX feature set is also introduced for code consistency.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 34 ++++++++++++-------------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  5 +++++
 2 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 23f2c96..586ecfb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1614,7 +1614,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		skb_set_hash(skb, tpa_info->rss_hash, tpa_info->hash_type);
 
 	if ((tpa_info->flags2 & RX_CMP_FLAGS2_META_FORMAT_VLAN) &&
-	    (skb->dev->features & NETIF_F_HW_VLAN_CTAG_RX)) {
+	    (skb->dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)) {
 		u16 vlan_proto = tpa_info->metadata >>
 			RX_CMP_FLAGS2_METADATA_TPID_SFT;
 		u16 vtag = tpa_info->metadata & RX_CMP_FLAGS2_METADATA_TCI_MASK;
@@ -1832,7 +1832,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 	if ((rxcmp1->rx_cmp_flags2 &
 	     cpu_to_le32(RX_CMP_FLAGS2_META_FORMAT_VLAN)) &&
-	    (skb->dev->features & NETIF_F_HW_VLAN_CTAG_RX)) {
+	    (skb->dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)) {
 		u32 meta_data = le32_to_cpu(rxcmp1->rx_cmp_meta_data);
 		u16 vtag = meta_data & RX_CMP_FLAGS2_METADATA_TCI_MASK;
 		u16 vlan_proto = meta_data >> RX_CMP_FLAGS2_METADATA_TPID_SFT;
@@ -9917,24 +9917,16 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	/* Both CTAG and STAG VLAN accelaration on the RX side have to be
 	 * turned on or off together.
 	 */
-	vlan_features = features & (NETIF_F_HW_VLAN_CTAG_RX |
-				    NETIF_F_HW_VLAN_STAG_RX);
-	if (vlan_features != (NETIF_F_HW_VLAN_CTAG_RX |
-			      NETIF_F_HW_VLAN_STAG_RX)) {
-		if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
-			features &= ~(NETIF_F_HW_VLAN_CTAG_RX |
-				      NETIF_F_HW_VLAN_STAG_RX);
+	vlan_features = features & BNXT_HW_FEATURE_VLAN_ALL_RX;
+	if (vlan_features != BNXT_HW_FEATURE_VLAN_ALL_RX) {
+		if (dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)
+			features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
 		else if (vlan_features)
-			features |= NETIF_F_HW_VLAN_CTAG_RX |
-				    NETIF_F_HW_VLAN_STAG_RX;
+			features |= BNXT_HW_FEATURE_VLAN_ALL_RX;
 	}
 #ifdef CONFIG_BNXT_SRIOV
-	if (BNXT_VF(bp)) {
-		if (bp->vf.vlan) {
-			features &= ~(NETIF_F_HW_VLAN_CTAG_RX |
-				      NETIF_F_HW_VLAN_STAG_RX);
-		}
-	}
+	if (BNXT_VF(bp) && bp->vf.vlan)
+		features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
 #endif
 	return features;
 }
@@ -9957,7 +9949,7 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
 		flags &= ~BNXT_FLAG_TPA;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (features & BNXT_HW_FEATURE_VLAN_ALL_RX)
 		flags |= BNXT_FLAG_STRIP_VLAN;
 
 	if (features & NETIF_F_NTUPLE)
@@ -12045,8 +12037,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM |
 				    NETIF_F_GSO_GRE_CSUM;
 	dev->vlan_features = dev->hw_features | NETIF_F_HIGHDMA;
-	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX |
-			    NETIF_F_HW_VLAN_STAG_RX | NETIF_F_HW_VLAN_STAG_TX;
+	dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_RX |
+			    BNXT_HW_FEATURE_VLAN_ALL_TX;
 	if (BNXT_SUPPORTS_TPA(bp))
 		dev->hw_features |= NETIF_F_GRO_HW;
 	dev->features |= dev->hw_features | NETIF_F_HIGHDMA;
@@ -12102,7 +12094,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bnxt_fw_init_one_p3(bp);
 
-	if (dev->hw_features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (dev->hw_features & BNXT_HW_FEATURE_VLAN_ALL_RX)
 		bp->flags |= BNXT_FLAG_STRIP_VLAN;
 
 	rc = bnxt_init_int_mode(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5890913..13c4064 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1906,6 +1906,11 @@ struct bnxt {
 #define BNXT_PCIE_STATS_OFFSET(counter)			\
 	(offsetof(struct pcie_ctx_hw_stats, counter) / 8)
 
+#define BNXT_HW_FEATURE_VLAN_ALL_RX				\
+	(NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX)
+#define BNXT_HW_FEATURE_VLAN_ALL_TX				\
+	(NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX)
+
 #define I2C_DEV_ADDR_A0				0xa0
 #define I2C_DEV_ADDR_A2				0xa2
 #define SFF_DIAG_SUPPORT_OFFSET			0x5c
-- 
1.8.3.1

