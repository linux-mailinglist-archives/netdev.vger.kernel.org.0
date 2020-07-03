Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB7C2134D5
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 09:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgGCHUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 03:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgGCHUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 03:20:14 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94546C08C5C1
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 00:20:14 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b6so31526143wrs.11
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 00:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yOUewmzjVuXtk+kzDwoBFTKtglO7O0DZV2wRvp9/YVg=;
        b=AOAVaAYViF1KNI00dezqK8pBYVQ+vXFxqSC8jwO0l6Tdq8961v/0ZJGmugDEzy5jM3
         Spvf/JMja30cUPFpVxW1CehPFOsxTpAMwjtuUqzpVXxx3K69Ln8FqRv3HonWLbBNLODt
         Hp4RaRImaN4g5TJhs2EHELb83buySoILhlgfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yOUewmzjVuXtk+kzDwoBFTKtglO7O0DZV2wRvp9/YVg=;
        b=Euq2vJ7EgJLKJfU3K2v4rYZ+0H+pihqyTii+fCdmrgdziG/B7J1kQ/TVh/PhKihBEj
         WaM7GRDgu+tw7B0RR/bdQmpF3xo1n9IhditgROEduZ/W2anJvhzuYlWqk51KyKGKan4Y
         aWUGbRGQbjHdw0eYrXz1LauJXx5u2wt7ZjU9MQpbbKaTx5oUqNgbHIXqU+wpztGwdbg0
         H1DODPWRMU7fZZb5RtEQzrVPRD1dK2YtYzr207VenHe5eRMUKPpeDxyiERkOorY/lkr/
         Cy/QJS89f2td9lBbm3mkJvgMJF74c9gU3LSxpFGN0LK2uw3NIj7qDV40FMMal1CTbgyd
         cDTA==
X-Gm-Message-State: AOAM5328udKDoZU5727f3/2x29U/vC3fek982xcGYwyMZkoaR5E1Vjxe
        F9DjHeiE9O0okY1E2y/MhE2bqnYQ45E=
X-Google-Smtp-Source: ABdhPJx/I/oTekntckQHDITvTDgjq+Wbk3DJEgO8ZyU+wvSRM+WSsfOObWFnsrr4iJY+LIpmA4WaQQ==
X-Received: by 2002:a05:6000:1143:: with SMTP id d3mr24466647wrx.235.1593760813182;
        Fri, 03 Jul 2020 00:20:13 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a22sm12529564wmj.9.2020.07.03.00.20.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2020 00:20:12 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 7/8] bnxt_en: clean up VLAN feature bit handling
Date:   Fri,  3 Jul 2020 03:19:46 -0400
Message-Id: <1593760787-31695-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
References: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
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
index 0edb692..c7a6a2a 100644
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
@@ -9911,24 +9911,16 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
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
@@ -9951,7 +9943,7 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
 		flags &= ~BNXT_FLAG_TPA;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (features & BNXT_HW_FEATURE_VLAN_ALL_RX)
 		flags |= BNXT_FLAG_STRIP_VLAN;
 
 	if (features & NETIF_F_NTUPLE)
@@ -12039,8 +12031,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -12096,7 +12088,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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

