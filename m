Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6922F20DD95
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbgF2TOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731655AbgF2TOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:04 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5118AC08EB28
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:34:51 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t6so7856330pgq.1
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZxIDzYRSXIMHmq+jYAjgYiwnSSoQmlnpzDwmxlHh5XM=;
        b=BTJOcJl0+Dfk60gPISwGW1Hf0DeXW6LwELIsPTCaiVsphVWmoqAyKvi/b+IHBZUViU
         s32CGkubJvjBGThoo1gVUuOoDKHM6Weh95gJKu9iOdmS8fccPhWtNrNf1WjAqoelQePs
         iurMwXkbCOFsfxys0f5y8C6o1qMl1Rlab3cIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZxIDzYRSXIMHmq+jYAjgYiwnSSoQmlnpzDwmxlHh5XM=;
        b=O5hqkNLVpCWxouANLiz/ayp3gi0cgkLBldHSIzj90BC1dw/Tg58po/K3CZ9hh0ZD9x
         8yVBEBeRmwQElB3ySvbbYtjDJYxIj5gO7IEQZDMyeM7j1DHcuhjqGhaPuDatfEBNxGTu
         HHP9T/2jTn/Z92zVblAkrIr2wgngaX5vYFdB3F47CqvvY7V3fmPJ66noiQrx0eYbnjYh
         vNK+Zuoh21hLmt5jth+k/bXP4kd/csqMA/sVWFjrKtOc7b+aZMt9rkFuqYFie1YN/JJ4
         M/wV006hdsL+1idp8HxiEtKiy8fiuRqfsI0tWrWUNk1CBO9ktV7Na8D8xPbjXpi9E9LW
         KrFw==
X-Gm-Message-State: AOAM533jp3shMW1OxDwWfL5ZE9cdWiaQr+9vONHYTGEMyF5sw00lJzDN
        hRfa9RGGq6G+cwfMtTfmjbrVFA==
X-Google-Smtp-Source: ABdhPJxhu6W41GV4w4wUqm9kpDUolUIaSMN9ZQVPxnTnezbZhw0foFIlH0WCOBQ5/0Q8xSqX0BGKRw==
X-Received: by 2002:a63:7c5:: with SMTP id 188mr9334404pgh.48.1593412490738;
        Sun, 28 Jun 2020 23:34:50 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i125sm28058416pgd.21.2020.06.28.23.34.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jun 2020 23:34:50 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 2/8] bnxt_en: Add logical RSS indirection table structure.
Date:   Mon, 29 Jun 2020 02:34:18 -0400
Message-Id: <1593412464-503-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
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

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 52 +++++++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  4 +++
 2 files changed, 56 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4afc1df..924bbcc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4830,6 +4830,49 @@ static u16 bnxt_cp_ring_for_tx(struct bnxt *bp, struct bnxt_tx_ring_info *txr)
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
+	bp->rss_indir_tbl = kcalloc(entries, sizeof(*bp->rss_indir_tbl),
+				    GFP_KERNEL);
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
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		max_entries = (max_rings + BNXT_RSS_TABLE_ENTRIES_P5 - 1) &
+			      ~(BNXT_RSS_TABLE_ENTRIES_P5 - 1);
+	else
+		max_entries = HW_HASH_INDEX_SIZE;
+
+	for (i = 0; i < max_entries; i++)
+		bp->rss_indir_tbl[i] = i % max_rings;
+
+	pad = bp->rss_indir_tbl_entries - max_entries;
+	if (pad)
+		memset(&bp->rss_indir_tbl[i], 0, pad * sizeof(u16));
+}
+
 static int bnxt_hwrm_vnic_set_rss(struct bnxt *bp, u16 vnic_id, bool set_rss)
 {
 	u32 i, j, max_rings;
@@ -11514,6 +11557,8 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	bnxt_free_ctx_mem(bp);
 	kfree(bp->ctx);
 	bp->ctx = NULL;
+	kfree(bp->rss_indir_tbl);
+	bp->rss_indir_tbl = NULL;
 	bnxt_free_port_stats(bp);
 	free_netdev(dev);
 }
@@ -12034,6 +12079,11 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -12078,6 +12128,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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

