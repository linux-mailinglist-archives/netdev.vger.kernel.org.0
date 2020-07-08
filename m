Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42D1218671
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgGHLyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728858AbgGHLyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:54:36 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FADC08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:54:35 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 22so2690326wmg.1
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9JYe1eY8dvQpsz05jdXNGQ5u809zswZrlB+U8/NEcUk=;
        b=MEisKJd/I7x5LdAO6E0/XWmEKlxNTZA9qpesbQX3QipTjuBM6daK5mkooBW9vDt2AS
         8Swp8hExRaM9W9dDvuyirYE5IJ8vgDTI37LMQzLGiRaP9cTTEc4cw1MeTVhPLt5d1ztl
         770uTnLwsskKkNk36Dss3DueQm8TkGbba/SoY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9JYe1eY8dvQpsz05jdXNGQ5u809zswZrlB+U8/NEcUk=;
        b=QwH50vz1z0ZrMiV582qigtURGmF8dRHps7Hi4OuB4LFoW+9HY+8TgF9gzSJNdKddbD
         4VDWS2rZcgrSe2nUk2sWQHpSggqevVIGq0JatckRjlNPjcm9HxdXYgYiOVIAzHQtNy5/
         I8ne6LdMiym/4XXpqY/BiyNDML30Y1s8KqNGJouFCNZyltgmQtGAbwiPT7oSq/xmHP3E
         H3sYcFup4D5g04ZeCb+mzI/Nr5aYs5ytFGCgM7VWIYXetUkIsmAL1nNsR68PjBE/n58S
         T5icFHvre86qpXbFfZlvpAexC2zYXiZ4DyNVkk+SXRrO1qxR/0nyfd8XJrSUCzoUPLuM
         hc6Q==
X-Gm-Message-State: AOAM5307cz8tATx8m8dU39vRExkGaqWAp5fW4JrsmxS6GEZjDFknrg3C
        qWg7NpFA6+JNxu5rzXRxra3kAw==
X-Google-Smtp-Source: ABdhPJzyDioVzezEe7h2BgUbC/f6jioW4utk35i1ooxMbgUX7c+pldWk0bNM2gfzs/6PdoB3YvTSIg==
X-Received: by 2002:a1c:dd86:: with SMTP id u128mr8766693wmg.131.1594209274283;
        Wed, 08 Jul 2020 04:54:34 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm6352888wrh.54.2020.07.08.04.54.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:54:33 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v4 8/9] bnxt_en: clean up VLAN feature bit handling
Date:   Wed,  8 Jul 2020 07:54:00 -0400
Message-Id: <1594209241-1692-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
References: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
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
index f3e45f3..749dc7c 100644
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
@@ -9932,24 +9932,16 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
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
@@ -9972,7 +9964,7 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
 		flags &= ~BNXT_FLAG_TPA;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (features & BNXT_HW_FEATURE_VLAN_ALL_RX)
 		flags |= BNXT_FLAG_STRIP_VLAN;
 
 	if (features & NETIF_F_NTUPLE)
@@ -12060,8 +12052,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -12117,7 +12109,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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

