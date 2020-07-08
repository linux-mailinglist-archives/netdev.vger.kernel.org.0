Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26EE321866C
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgGHLy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728907AbgGHLy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:54:26 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A17EC08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:54:26 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r12so48567755wrj.13
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MP+BYuB2w1Z3uEUjvM8PLOC38Unts2KhE7vLbbhgeIM=;
        b=Rjx6dorUdFDH/JXzJRfK30hIrc7EXuZZhZyYTOPZ2q8zo6YaIrHW/Po9CTnHNXfWMy
         qXvIjOahRQyFx0g6nuUcY73tUZorTU6LK1NZ+msrbuPVU2rkoaJPiMm4SWRFdkMSiRJp
         gfSKRH2z/7MbIbGJtoeFcDxUOa2qef4S+gank=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MP+BYuB2w1Z3uEUjvM8PLOC38Unts2KhE7vLbbhgeIM=;
        b=ihwTr9hAC4wEdD+yp4jAXlEDncmHgh6BLYuT7rNEPKsqijuZGbx70VqZ22G5vMZNCL
         SihxR+gJlI0p3so95toab5ujn0r/rwFJYmU+O5GZclH+Oa2D2m3zqmd8T7TxU3DsH9w8
         rszOhekQ6PGhStb4MUiHMqEGxTPNMe2YmI/W6GD5jAW9shWlJw1bfksS+PUoWkxrXV2y
         1xoiDM4oXU4pV61S8nRGzayXzBryzwXdqYrBFiczziVcLb2FrFxHzCLzlu6Am4UgyzDb
         78FFBtxpDrflVrQL1NHfKB3sWI9Tie2fOoGqOIBD2fRFjpTRMdGpWB5RdOOoQPsWZZkQ
         yWNw==
X-Gm-Message-State: AOAM531XAKcWAoo79ThaE8VwDRw89qCBuOLkAjiiGMPfueoRpRIqlT5u
        WzKcZ38jdDt8YhAWDMot2N7W12TNKAk=
X-Google-Smtp-Source: ABdhPJySBy5RWrwHq7PpfpHCrUkgGJKKTwEvgPurRRYdE9nYLJWGYKdDBE8rWV/Ho24bM3zeze6Aqw==
X-Received: by 2002:a5d:68cc:: with SMTP id p12mr57508074wrw.111.1594209264687;
        Wed, 08 Jul 2020 04:54:24 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm6352888wrh.54.2020.07.08.04.54.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:54:24 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v4 3/9] bnxt_en: Add logical RSS indirection table structure.
Date:   Wed,  8 Jul 2020 07:53:55 -0400
Message-Id: <1594209241-1692-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
References: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver currently does not keep track of the logical RSS indirection
table.  The hardware RSS table is set up with standard default ring
distribution when initializing the chip.  This makes it difficult to
support user sepcified indirection table entries.  As a first step, add
the logical table in the main bnxt structure and allocate it according
to chip specific table size.  Add a function that sets up default
RSS distribution based on the number of RX rings.

v4: Use bnxt_get_rxfh_indir_size() for the current RSS table size.

v2: Use kmalloc_array() since we init. all entries afterwards.
    Use ALIGN() to roundup the RSS table size.
    Use ethtool_rxfh_indir_default() to init. the default entries.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 48 +++++++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  4 +++
 2 files changed, 52 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4afc1df..228ba66 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4830,6 +4830,45 @@ static u16 bnxt_cp_ring_for_tx(struct bnxt *bp, struct bnxt_tx_ring_info *txr)
 	}
 }
 
+static int bnxt_alloc_rss_indir_tbl(struct bnxt *bp)
+{
+	int entries;
+
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		entries = BNXT_MAX_RSS_TABLE_ENTRIES_P5;
+	else
+		entries = HW_HASH_INDEX_SIZE;
+
+	bp->rss_indir_tbl_entries = entries;
+	bp->rss_indir_tbl = kmalloc_array(entries, sizeof(*bp->rss_indir_tbl),
+					  GFP_KERNEL);
+	if (!bp->rss_indir_tbl)
+		return -ENOMEM;
+	return 0;
+}
+
+static void bnxt_set_dflt_rss_indir_tbl(struct bnxt *bp)
+{
+	u16 max_rings, max_entries, pad, i;
+
+	if (!bp->rx_nr_rings)
+		return;
+
+	if (BNXT_CHIP_TYPE_NITRO_A0(bp))
+		max_rings = bp->rx_nr_rings - 1;
+	else
+		max_rings = bp->rx_nr_rings;
+
+	max_entries = bnxt_get_rxfh_indir_size(bp->dev);
+
+	for (i = 0; i < max_entries; i++)
+		bp->rss_indir_tbl[i] = ethtool_rxfh_indir_default(i, max_rings);
+
+	pad = bp->rss_indir_tbl_entries - max_entries;
+	if (pad)
+		memset(&bp->rss_indir_tbl[i], 0, pad * sizeof(u16));
+}
+
 static int bnxt_hwrm_vnic_set_rss(struct bnxt *bp, u16 vnic_id, bool set_rss)
 {
 	u32 i, j, max_rings;
@@ -11514,6 +11553,8 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	bnxt_free_ctx_mem(bp);
 	kfree(bp->ctx);
 	bp->ctx = NULL;
+	kfree(bp->rss_indir_tbl);
+	bp->rss_indir_tbl = NULL;
 	bnxt_free_port_stats(bp);
 	free_netdev(dev);
 }
@@ -12034,6 +12075,11 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
 
+	rc = bnxt_alloc_rss_indir_tbl(bp);
+	if (rc)
+		goto init_err_pci_clean;
+	bnxt_set_dflt_rss_indir_tbl(bp);
+
 	if (BNXT_PF(bp)) {
 		if (!bnxt_pf_wq) {
 			bnxt_pf_wq =
@@ -12078,6 +12124,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bnxt_free_ctx_mem(bp);
 	kfree(bp->ctx);
 	bp->ctx = NULL;
+	kfree(bp->rss_indir_tbl);
+	bp->rss_indir_tbl = NULL;
 
 init_err_free:
 	free_netdev(dev);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5883b246..6de2813 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1023,6 +1023,8 @@ struct bnxt_vnic_info {
 #define BNXT_RSS_TABLE_MAX_TBL_P5	8
 #define BNXT_MAX_RSS_TABLE_SIZE_P5				\
 	(BNXT_RSS_TABLE_SIZE_P5 * BNXT_RSS_TABLE_MAX_TBL_P5)
+#define BNXT_MAX_RSS_TABLE_ENTRIES_P5				\
+	(BNXT_RSS_TABLE_ENTRIES_P5 * BNXT_RSS_TABLE_MAX_TBL_P5)
 
 	u32		rx_mask;
 
@@ -1655,6 +1657,8 @@ struct bnxt {
 	struct bnxt_ring_grp_info	*grp_info;
 	struct bnxt_vnic_info	*vnic_info;
 	int			nr_vnics;
+	u16			*rss_indir_tbl;
+	u16			rss_indir_tbl_entries;
 	u32			rss_hash_cfg;
 
 	u16			max_mtu;
-- 
1.8.3.1

