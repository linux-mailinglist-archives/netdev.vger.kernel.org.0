Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A26522E473
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 05:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgG0Da1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 23:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgG0Da0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 23:30:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBCEC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:26 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id z5so8604020pgb.6
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6tptsJPMUdc0mO6knnROYlap2JYf8fFV3DG5yfDuadQ=;
        b=NWDeETuou2rvpAguFmzSmf8ugoDwhm9vNrtA9rDmkBAP2SZ4btnc7b3EWgJBfJ6U5J
         jflVNk5C4gVcsrRqu7vORB5p4llvyASWpQVvbXcuBQkpWhp0RFUHOX2U/kyTA94FeMqS
         WpoV+8aLEJ578BpsCOIR/OnzFzBbTdvENXHiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6tptsJPMUdc0mO6knnROYlap2JYf8fFV3DG5yfDuadQ=;
        b=oEgwAla9aIMY7QNpkCnieO71pTqHlCw24M0EbKyj5WjCj2690iloQ+AgfDNbEVPLNY
         lL2HpNPgR6Q4Ng/XfEgriZnDqn7DPpoJSdnfy1eWABMlqF1VCOe+r7wEj6P8DnGDrfbY
         qlyMwHFXbA6cvmJr1s9rXrFzGtx7JjojrWs6/bMrJK4ZvSOpPPEkXUinCj12pV5O1PfN
         UoF7yDy8UNUDbNkuRD28YhBWWYp9Pa02ptLxTHRwOT6QtEVSIGptFiwUtvnAA6JJkmoi
         HGR9l6JRiS9ePeRF40gkNM5wQNRpRK9z+SzCSceGXoCKV6TsUYdcDKIdQ2LELzq+Wzii
         KnUg==
X-Gm-Message-State: AOAM532IuLOlwR5dLIB9OBwUUaRmKGxKjnBWhFlIAQ/g/DmYNPo0X8jX
        BKlYUJurz8rItZlgK+4GHK2IZw==
X-Google-Smtp-Source: ABdhPJx/MRkeTL5icQQDGX9YUodo0mSLR7BfANQDNruz3umtQH81jgUdIu/gnZYm2fEXN6pC1H2+4Q==
X-Received: by 2002:a62:6305:: with SMTP id x5mr18665069pfb.81.1595820625788;
        Sun, 26 Jul 2020 20:30:25 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n25sm13504506pff.51.2020.07.26.20.30.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2020 20:30:25 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 04/10] bnxt_en: Refactor statistics code and structures.
Date:   Sun, 26 Jul 2020 23:29:40 -0400
Message-Id: <1595820586-2203-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
References: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver manages multiple statistics structures of different sizes.
They are all allocated, freed, and handled practically the same.  Define
a new bnxt_stats_mem structure and common allocation and free functions
for all staistics memory blocks.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 129 ++++++++++------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  21 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c     |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  13 ++-
 4 files changed, 76 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b4a387c..d232618 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3703,61 +3703,55 @@ static int bnxt_alloc_hwrm_short_cmd_req(struct bnxt *bp)
 	return 0;
 }
 
-static void bnxt_free_port_stats(struct bnxt *bp)
+static void bnxt_free_stats_mem(struct bnxt *bp, struct bnxt_stats_mem *stats)
 {
-	struct pci_dev *pdev = bp->pdev;
+	if (stats->hw_stats) {
+		dma_free_coherent(&bp->pdev->dev, stats->len, stats->hw_stats,
+				  stats->hw_stats_map);
+		stats->hw_stats = NULL;
+	}
+}
 
-	bp->flags &= ~BNXT_FLAG_PORT_STATS;
-	bp->flags &= ~BNXT_FLAG_PORT_STATS_EXT;
+static int bnxt_alloc_stats_mem(struct bnxt *bp, struct bnxt_stats_mem *stats)
+{
+	stats->hw_stats = dma_alloc_coherent(&bp->pdev->dev, stats->len,
+					     &stats->hw_stats_map, GFP_KERNEL);
+	if (!stats->hw_stats)
+		return -ENOMEM;
 
-	if (bp->hw_rx_port_stats) {
-		dma_free_coherent(&pdev->dev, bp->hw_port_stats_size,
-				  bp->hw_rx_port_stats,
-				  bp->hw_rx_port_stats_map);
-		bp->hw_rx_port_stats = NULL;
-	}
+	memset(stats->hw_stats, 0, stats->len);
+	return 0;
+}
 
-	if (bp->hw_tx_port_stats_ext) {
-		dma_free_coherent(&pdev->dev, sizeof(struct tx_port_stats_ext),
-				  bp->hw_tx_port_stats_ext,
-				  bp->hw_tx_port_stats_ext_map);
-		bp->hw_tx_port_stats_ext = NULL;
-	}
+static void bnxt_free_port_stats(struct bnxt *bp)
+{
+	bp->flags &= ~BNXT_FLAG_PORT_STATS;
+	bp->flags &= ~BNXT_FLAG_PORT_STATS_EXT;
 
-	if (bp->hw_rx_port_stats_ext) {
-		dma_free_coherent(&pdev->dev, sizeof(struct rx_port_stats_ext),
-				  bp->hw_rx_port_stats_ext,
-				  bp->hw_rx_port_stats_ext_map);
-		bp->hw_rx_port_stats_ext = NULL;
-	}
+	bnxt_free_stats_mem(bp, &bp->port_stats);
+	bnxt_free_stats_mem(bp, &bp->rx_port_stats_ext);
+	bnxt_free_stats_mem(bp, &bp->tx_port_stats_ext);
 }
 
 static void bnxt_free_ring_stats(struct bnxt *bp)
 {
-	struct pci_dev *pdev = bp->pdev;
-	int size, i;
+	int i;
 
 	if (!bp->bnapi)
 		return;
 
-	size = bp->hw_ring_stats_size;
-
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
 		struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
 
-		if (cpr->hw_stats) {
-			dma_free_coherent(&pdev->dev, size, cpr->hw_stats,
-					  cpr->hw_stats_map);
-			cpr->hw_stats = NULL;
-		}
+		bnxt_free_stats_mem(bp, &cpr->stats);
 	}
 }
 
 static int bnxt_alloc_stats(struct bnxt *bp)
 {
 	u32 size, i;
-	struct pci_dev *pdev = bp->pdev;
+	int rc;
 
 	size = bp->hw_ring_stats_size;
 
@@ -3765,11 +3759,10 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 		struct bnxt_napi *bnapi = bp->bnapi[i];
 		struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
 
-		cpr->hw_stats = dma_alloc_coherent(&pdev->dev, size,
-						   &cpr->hw_stats_map,
-						   GFP_KERNEL);
-		if (!cpr->hw_stats)
-			return -ENOMEM;
+		cpr->stats.len = size;
+		rc = bnxt_alloc_stats_mem(bp, &cpr->stats);
+		if (rc)
+			return rc;
 
 		cpr->hw_stats_ctx_id = INVALID_STATS_CTX_ID;
 	}
@@ -3777,22 +3770,14 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 	if (BNXT_VF(bp) || bp->chip_num == CHIP_NUM_58700)
 		return 0;
 
-	if (bp->hw_rx_port_stats)
+	if (bp->port_stats.hw_stats)
 		goto alloc_ext_stats;
 
-	bp->hw_port_stats_size = BNXT_PORT_STATS_SIZE;
-
-	bp->hw_rx_port_stats =
-		dma_alloc_coherent(&pdev->dev, bp->hw_port_stats_size,
-				   &bp->hw_rx_port_stats_map,
-				   GFP_KERNEL);
-	if (!bp->hw_rx_port_stats)
-		return -ENOMEM;
+	bp->port_stats.len = BNXT_PORT_STATS_SIZE;
+	rc = bnxt_alloc_stats_mem(bp, &bp->port_stats);
+	if (rc)
+		return rc;
 
-	bp->hw_tx_port_stats = (void *)bp->hw_rx_port_stats +
-			       BNXT_TX_PORT_STATS_BYTE_OFFSET;
-	bp->hw_tx_port_stats_map = bp->hw_rx_port_stats_map +
-				   BNXT_TX_PORT_STATS_BYTE_OFFSET;
 	bp->flags |= BNXT_FLAG_PORT_STATS;
 
 alloc_ext_stats:
@@ -3801,26 +3786,26 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 		if (!(bp->fw_cap & BNXT_FW_CAP_EXT_STATS_SUPPORTED))
 			return 0;
 
-	if (bp->hw_rx_port_stats_ext)
+	if (bp->rx_port_stats_ext.hw_stats)
 		goto alloc_tx_ext_stats;
 
-	bp->hw_rx_port_stats_ext =
-		dma_alloc_coherent(&pdev->dev, sizeof(struct rx_port_stats_ext),
-				   &bp->hw_rx_port_stats_ext_map, GFP_KERNEL);
-	if (!bp->hw_rx_port_stats_ext)
+	bp->rx_port_stats_ext.len = sizeof(struct rx_port_stats_ext);
+	rc = bnxt_alloc_stats_mem(bp, &bp->rx_port_stats_ext);
+	/* Extended stats are optional */
+	if (rc)
 		return 0;
 
 alloc_tx_ext_stats:
-	if (bp->hw_tx_port_stats_ext)
+	if (bp->tx_port_stats_ext.hw_stats)
 		return 0;
 
 	if (bp->hwrm_spec_code >= 0x10902 ||
 	    (bp->fw_cap & BNXT_FW_CAP_EXT_STATS_SUPPORTED)) {
-		bp->hw_tx_port_stats_ext =
-			dma_alloc_coherent(&pdev->dev,
-					   sizeof(struct tx_port_stats_ext),
-					   &bp->hw_tx_port_stats_ext_map,
-					   GFP_KERNEL);
+		bp->tx_port_stats_ext.len = sizeof(struct tx_port_stats_ext);
+		rc = bnxt_alloc_stats_mem(bp, &bp->tx_port_stats_ext);
+		/* Extended stats are optional */
+		if (rc)
+			return 0;
 	}
 	bp->flags |= BNXT_FLAG_PORT_STATS_EXT;
 	return 0;
@@ -6431,7 +6416,7 @@ static int bnxt_hwrm_stat_ctx_alloc(struct bnxt *bp)
 		struct bnxt_napi *bnapi = bp->bnapi[i];
 		struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
 
-		req.stats_dma_addr = cpu_to_le64(cpr->hw_stats_map);
+		req.stats_dma_addr = cpu_to_le64(cpr->stats.hw_stats_map);
 
 		rc = _hwrm_send_message(bp, &req, sizeof(req),
 					HWRM_CMD_TIMEOUT);
@@ -7472,8 +7457,9 @@ static int bnxt_hwrm_port_qstats(struct bnxt *bp)
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PORT_QSTATS, -1, -1);
 	req.port_id = cpu_to_le16(pf->port_id);
-	req.tx_stat_host_addr = cpu_to_le64(bp->hw_tx_port_stats_map);
-	req.rx_stat_host_addr = cpu_to_le64(bp->hw_rx_port_stats_map);
+	req.tx_stat_host_addr = cpu_to_le64(bp->port_stats.hw_stats_map +
+					    BNXT_TX_PORT_STATS_BYTE_OFFSET);
+	req.rx_stat_host_addr = cpu_to_le64(bp->port_stats.hw_stats_map);
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
@@ -7492,11 +7478,11 @@ static int bnxt_hwrm_port_qstats_ext(struct bnxt *bp)
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PORT_QSTATS_EXT, -1, -1);
 	req.port_id = cpu_to_le16(pf->port_id);
 	req.rx_stat_size = cpu_to_le16(sizeof(struct rx_port_stats_ext));
-	req.rx_stat_host_addr = cpu_to_le64(bp->hw_rx_port_stats_ext_map);
-	tx_stat_size = bp->hw_tx_port_stats_ext ?
-		       sizeof(*bp->hw_tx_port_stats_ext) : 0;
+	req.rx_stat_host_addr = cpu_to_le64(bp->rx_port_stats_ext.hw_stats_map);
+	tx_stat_size = bp->tx_port_stats_ext.hw_stats ?
+		       sizeof(struct tx_port_stats_ext) : 0;
 	req.tx_stat_size = cpu_to_le16(tx_stat_size);
-	req.tx_stat_host_addr = cpu_to_le64(bp->hw_tx_port_stats_ext_map);
+	req.tx_stat_host_addr = cpu_to_le64(bp->tx_port_stats_ext.hw_stats_map);
 	mutex_lock(&bp->hwrm_cmd_lock);
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (!rc) {
@@ -9574,7 +9560,7 @@ static void bnxt_get_ring_stats(struct bnxt *bp,
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
 		struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
-		struct ctx_hw_stats *hw_stats = cpr->hw_stats;
+		struct ctx_hw_stats *hw_stats = cpr->stats.hw_stats;
 
 		stats->rx_packets += le64_to_cpu(hw_stats->rx_ucast_pkts);
 		stats->rx_packets += le64_to_cpu(hw_stats->rx_mcast_pkts);
@@ -9635,8 +9621,9 @@ static void bnxt_add_prev_stats(struct bnxt *bp,
 	bnxt_add_prev_stats(bp, stats);
 
 	if (bp->flags & BNXT_FLAG_PORT_STATS) {
-		struct rx_port_stats *rx = bp->hw_rx_port_stats;
-		struct tx_port_stats *tx = bp->hw_tx_port_stats;
+		struct rx_port_stats *rx = bp->port_stats.hw_stats;
+		struct tx_port_stats *tx = bp->port_stats.hw_stats +
+					   BNXT_TX_PORT_STATS_BYTE_OFFSET;
 
 		stats->rx_crc_errors = le64_to_cpu(rx->rx_fcs_err_frames);
 		stats->rx_frame_errors = le64_to_cpu(rx->rx_align_err_frames);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index df62897..7e9fe1f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -919,6 +919,12 @@ struct bnxt_sw_stats {
 	struct bnxt_cmn_sw_stats cmn;
 };
 
+struct bnxt_stats_mem {
+	void		*hw_stats;
+	dma_addr_t	hw_stats_map;
+	int		len;
+};
+
 struct bnxt_cp_ring_info {
 	struct bnxt_napi	*bnapi;
 	u32			cp_raw_cons;
@@ -943,8 +949,7 @@ struct bnxt_cp_ring_info {
 
 	dma_addr_t		cp_desc_mapping[MAX_CP_PAGES];
 
-	struct ctx_hw_stats	*hw_stats;
-	dma_addr_t		hw_stats_map;
+	struct bnxt_stats_mem	stats;
 	u32			hw_stats_ctx_id;
 
 	struct bnxt_sw_stats	sw_stats;
@@ -1776,15 +1781,9 @@ struct bnxt {
 	dma_addr_t		hwrm_cmd_kong_resp_dma_addr;
 
 	struct rtnl_link_stats64	net_stats_prev;
-	struct rx_port_stats	*hw_rx_port_stats;
-	struct tx_port_stats	*hw_tx_port_stats;
-	struct rx_port_stats_ext	*hw_rx_port_stats_ext;
-	struct tx_port_stats_ext	*hw_tx_port_stats_ext;
-	dma_addr_t		hw_rx_port_stats_map;
-	dma_addr_t		hw_tx_port_stats_map;
-	dma_addr_t		hw_rx_port_stats_ext_map;
-	dma_addr_t		hw_tx_port_stats_ext_map;
-	int			hw_port_stats_size;
+	struct bnxt_stats_mem	port_stats;
+	struct bnxt_stats_mem	rx_port_stats_ext;
+	struct bnxt_stats_mem	tx_port_stats_ext;
 	u16			fw_rx_stats_ext_size;
 	u16			fw_tx_stats_ext_size;
 	u16			hw_ring_stats_size;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
index 02b2755..8e90224 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -544,7 +544,7 @@ static int bnxt_dcbnl_ieee_setets(struct net_device *dev, struct ieee_ets *ets)
 static int bnxt_dcbnl_ieee_getpfc(struct net_device *dev, struct ieee_pfc *pfc)
 {
 	struct bnxt *bp = netdev_priv(dev);
-	__le64 *stats = (__le64 *)bp->hw_rx_port_stats;
+	__le64 *stats = bp->port_stats.hw_stats;
 	struct ieee_pfc *my_pfc = bp->ieee_pfc;
 	long rx_off, tx_off;
 	int i, rc;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index c8bafab..59ebb2b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -559,7 +559,8 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
 		struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
-		__le64 *hw_stats = (__le64 *)cpr->hw_stats;
+		struct ctx_hw_stats *hw = cpr->stats.hw_stats;
+		__le64 *hw_stats = cpr->stats.hw_stats;
 		u64 *sw;
 		int k;
 
@@ -593,9 +594,9 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 			buf[j] = sw[k];
 
 		bnxt_sw_func_stats[RX_TOTAL_DISCARDS].counter +=
-			le64_to_cpu(cpr->hw_stats->rx_discard_pkts);
+			le64_to_cpu(hw->rx_discard_pkts);
 		bnxt_sw_func_stats[TX_TOTAL_DISCARDS].counter +=
-			le64_to_cpu(cpr->hw_stats->tx_discard_pkts);
+			le64_to_cpu(hw->tx_discard_pkts);
 	}
 
 	for (i = 0; i < BNXT_NUM_SW_FUNC_STATS; i++, j++)
@@ -603,7 +604,7 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 
 skip_ring_stats:
 	if (bp->flags & BNXT_FLAG_PORT_STATS) {
-		__le64 *port_stats = (__le64 *)bp->hw_rx_port_stats;
+		__le64 *port_stats = bp->port_stats.hw_stats;
 
 		for (i = 0; i < BNXT_NUM_PORT_STATS; i++, j++) {
 			buf[j] = le64_to_cpu(*(port_stats +
@@ -611,8 +612,8 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 		}
 	}
 	if (bp->flags & BNXT_FLAG_PORT_STATS_EXT) {
-		__le64 *rx_port_stats_ext = (__le64 *)bp->hw_rx_port_stats_ext;
-		__le64 *tx_port_stats_ext = (__le64 *)bp->hw_tx_port_stats_ext;
+		__le64 *rx_port_stats_ext = bp->rx_port_stats_ext.hw_stats;
+		__le64 *tx_port_stats_ext = bp->tx_port_stats_ext.hw_stats;
 
 		for (i = 0; i < bp->fw_rx_stats_ext_size; i++, j++) {
 			buf[j] = le64_to_cpu(*(rx_port_stats_ext +
-- 
1.8.3.1

