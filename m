Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C83721866E
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgGHLyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbgGHLy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:54:28 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE256C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:54:27 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a6so48658710wrm.4
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TuApZD8Dd2YpdmLnWNoR+ahWPJc09UBm7kr/yREfrs4=;
        b=Ou1TVlQW/2yTJT9e4wGearkJ2+JkX02hYQVRDhE3dyVRu4oTkN7M9bdhN+R2n8fo56
         i8+/U2IX7CCknvJ37AD3xzVDJpqNbIvF0Ehu6WQ67MYbRsMThyWD+XBrJRAyNHxfinPo
         dTbNRL3zNuy1lgtEGw+i6JtqtFeT7L50Wwufc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TuApZD8Dd2YpdmLnWNoR+ahWPJc09UBm7kr/yREfrs4=;
        b=pGQo/rBSudNqY5gwiBTroECcoJ3ENdA4ZM6ENou+3ucLg9Iwe3XvBqF7NEa6ZQp+VC
         H3g/ShIUa9ArS2n7/7w2CCisGAix1DIG4TBJnzULwg2oQLSX8pPyjZrygoGcZQ3I1Hp9
         txDalk62sZ9n7+5ab8+7jc3ZI7FPnEDnf1kyBMq0b37Eo+jbaocpIiCGK/tLYnB6jEWY
         gMk5QJCfyM/xZZ46O4R8ALWwxCT7rBAG4rrx1u09MscQ1ZFPx1+ySDZFt+WfCSNKMQLz
         b412C99bD7kTYpTOR4YBsdCaj8Yym3+xfwHVRXcEvVojBAtnFqtX6SUdMM6cdV5Wyth0
         XyJA==
X-Gm-Message-State: AOAM533Tedi7SUqCVNQ4R30KyFiN9lc8DA15DP3sk4HRT0kpnIdI87pD
        /QlQydzq11UI/6c0rHNtYjKtHA==
X-Google-Smtp-Source: ABdhPJwiPeLnThdja6Cvvhew7fkxkiGum9bhCMgteqC7m2fd/3EWHznOoie3CWPRRM6I/Aj8Yms4kA==
X-Received: by 2002:adf:e40e:: with SMTP id g14mr63187282wrm.271.1594209266361;
        Wed, 08 Jul 2020 04:54:26 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm6352888wrh.54.2020.07.08.04.54.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:54:25 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v4 4/9] bnxt_en: Add helper function to return the number of RSS contexts.
Date:   Wed,  8 Jul 2020 07:53:56 -0400
Message-Id: <1594209241-1692-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
References: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some chips, this varies based on the number of RX rings.  Add this
helper function and refactor the existing code to use it.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 13 +++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 228ba66..3d0bb43 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4869,6 +4869,15 @@ static void bnxt_set_dflt_rss_indir_tbl(struct bnxt *bp)
 		memset(&bp->rss_indir_tbl[i], 0, pad * sizeof(u16));
 }
 
+int bnxt_get_nr_rss_ctxs(struct bnxt *bp, int rx_rings)
+{
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		return DIV_ROUND_UP(rx_rings, BNXT_RSS_TABLE_ENTRIES_P5);
+	if (BNXT_CHIP_TYPE_NITRO_A0(bp))
+		return 2;
+	return 1;
+}
+
 static int bnxt_hwrm_vnic_set_rss(struct bnxt *bp, u16 vnic_id, bool set_rss)
 {
 	u32 i, j, max_rings;
@@ -4924,7 +4933,7 @@ static int bnxt_hwrm_vnic_set_rss_p5(struct bnxt *bp, u16 vnic_id, bool set_rss)
 	req.hash_mode_flags = VNIC_RSS_CFG_REQ_HASH_MODE_FLAGS_DEFAULT;
 	req.ring_grp_tbl_addr = cpu_to_le64(vnic->rss_table_dma_addr);
 	req.hash_key_tbl_addr = cpu_to_le64(vnic->rss_hash_key_dma_addr);
-	nr_ctxs = DIV_ROUND_UP(bp->rx_nr_rings, 64);
+	nr_ctxs = bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings);
 	for (i = 0, k = 0; i < nr_ctxs; i++) {
 		__le16 *ring_tbl = vnic->rss_table;
 		int rc;
@@ -7677,7 +7686,7 @@ static int __bnxt_setup_vnic_p5(struct bnxt *bp, u16 vnic_id)
 {
 	int rc, i, nr_ctxs;
 
-	nr_ctxs = DIV_ROUND_UP(bp->rx_nr_rings, 64);
+	nr_ctxs = bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings);
 	for (i = 0; i < nr_ctxs; i++) {
 		rc = bnxt_hwrm_vnic_ctx_alloc(bp, vnic_id, i);
 		if (rc) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 6de2813..5890913 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2039,6 +2039,7 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 int hwrm_send_message_silent(struct bnxt *, void *, u32, int);
 int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap,
 			    int bmap_size, bool async_only);
+int bnxt_get_nr_rss_ctxs(struct bnxt *bp, int rx_rings);
 int bnxt_hwrm_vnic_cfg(struct bnxt *bp, u16 vnic_id);
 int __bnxt_hwrm_get_tx_rings(struct bnxt *bp, u16 fid, int *tx_rings);
 int bnxt_nq_rings_in_use(struct bnxt *bp);
-- 
1.8.3.1

