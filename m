Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9942134D2
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 09:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgGCHUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 03:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbgGCHUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 03:20:07 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E08C08C5C1
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 00:20:07 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q5so31530040wru.6
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 00:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UDKCFPSIb0xgWbUg4yvKs/Wh8G+p7xYFSA8viuxklqQ=;
        b=T7+06Jx2qlanbYvEWVYYRujzKDXHhzr8fj8QBd4LbJUvP5Dz+yuHyEjn2r4L3gGx/B
         8jaRdgzseYwQ7h/JIcpJu6CpHKNtNbOcWnKiybkNLLxhnFVmpxzBmVGO8R5WFdvyRFhc
         DujsNjab1ORkDtfAalbtKFQlw1Z3k4Fq6pP4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UDKCFPSIb0xgWbUg4yvKs/Wh8G+p7xYFSA8viuxklqQ=;
        b=Z+zkpa0peZj41Tp6fjZS5xNLxHlmn/PnypdkYKqytX1BWbm0DPPsWofYv+uKGeyxf1
         lCBQ0zkiTa7AmyOAmYcbUIl1fphKok6H60Y7EgmSLp/0MHFM9LtsscqehIXbjGIWEERj
         OI4kS+pa0Cwlx/6hMDTxoR+8AmHDwE6OGh95jFnrkG5KwYduDaSEV+JGsMcAEipaDm5y
         mGb4lE5nSaJvR7Lnuh3ymGG005JvjakdEUld9bPkBQwtgeE3Tz4VhZPvYgvIPWzLvQMn
         BdluyFsBJiKc0d4JpAJ4Yp5+1LdJswd16C+L8OBZ7hYVNJSvr9QQGgKzfBb+L04cbk8B
         d9tw==
X-Gm-Message-State: AOAM531P6sG+sfcZdNilJU19lkV/6Q20QsGHWBHAVmwF7je8joWlpA1u
        YVfE4DAgIbv7YwwAB6tJx4fJmjUG5IQ=
X-Google-Smtp-Source: ABdhPJxzw5pOO9PP5SZAfZr/ypQM++8FlkwoEHlIZzfH1f9QlRDefvTqSkTTHSO2btQZu3S/4+iAOA==
X-Received: by 2002:a5d:518a:: with SMTP id k10mr34538915wrv.316.1593760806034;
        Fri, 03 Jul 2020 00:20:06 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a22sm12529564wmj.9.2020.07.03.00.20.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2020 00:20:05 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 3/8] bnxt_en: Add helper function to return the number of RSS contexts.
Date:   Fri,  3 Jul 2020 03:19:42 -0400
Message-Id: <1593760787-31695-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
References: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
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
index 70f8302..96e678b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4872,6 +4872,15 @@ static void bnxt_set_dflt_rss_indir_tbl(struct bnxt *bp)
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
@@ -4927,7 +4936,7 @@ static int bnxt_hwrm_vnic_set_rss_p5(struct bnxt *bp, u16 vnic_id, bool set_rss)
 	req.hash_mode_flags = VNIC_RSS_CFG_REQ_HASH_MODE_FLAGS_DEFAULT;
 	req.ring_grp_tbl_addr = cpu_to_le64(vnic->rss_table_dma_addr);
 	req.hash_key_tbl_addr = cpu_to_le64(vnic->rss_hash_key_dma_addr);
-	nr_ctxs = DIV_ROUND_UP(bp->rx_nr_rings, 64);
+	nr_ctxs = bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings);
 	for (i = 0, k = 0; i < nr_ctxs; i++) {
 		__le16 *ring_tbl = vnic->rss_table;
 		int rc;
@@ -7680,7 +7689,7 @@ static int __bnxt_setup_vnic_p5(struct bnxt *bp, u16 vnic_id)
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

