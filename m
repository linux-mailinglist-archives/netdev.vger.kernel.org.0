Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C222B215027
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgGEWWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEWWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:22:44 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1006C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:22:44 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b92so16157333pjc.4
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 15:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UDKCFPSIb0xgWbUg4yvKs/Wh8G+p7xYFSA8viuxklqQ=;
        b=Gf29ayIy5MayMVk6vNUWKmuaFEdIET2o+K+M5JLIlnmh06yx4H1If88ROiWBaXm9J4
         rjHZZd6G3DhyAljH42Cn2zx/rrXCMhcIMZZFbV6AznCvTphAbQUTZt5IvIlRHVNyRMEF
         AcuBomdiL3k3iqRYAm3ervgtxIj9+Y6oF9YmI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UDKCFPSIb0xgWbUg4yvKs/Wh8G+p7xYFSA8viuxklqQ=;
        b=UI9B/XEsb32PVLJvzqTSJlFLGi3qBKj7Xw+g8DkoLarMjUw0iRjDC/1+5vTjyLL2Km
         Oa5DK0VVdFOHOu46OFW5EI2WU/HreAs5XbjqEoswLPjlVDLIuxPs/zYCL3ecnF7rw3wf
         ZjHSxa0VesS9huO/L/GWEUTZDzQVd3W5NNfLbudqtvCyMjjoiZfFsKBufLK+2o9pjPyF
         ZjZjUjp1EKh48OWn5rQWJzanh080ehP08hctdRCniQd0+L5Zgbf/kJW5Zh2JvOIDFAk/
         TXr8YG6qf4TxpPQHBDfAIjrQsrOoFEyY0olw2155dBjwRJi2pin3gMm0KlfPtzprW2uf
         TRBg==
X-Gm-Message-State: AOAM5334pMU6Cr0MUDwBkJ0C1aDJ5fx5Q0lvO64mHmpkcYgJE7yrg9M6
        btAQuZu8RuS0jjbYtVAexvbcYlLJN1E=
X-Google-Smtp-Source: ABdhPJw0R7qmPmyxzDo3zdJk0vjdDwZKzjT5SuLYX7UnjI+FQNFC/971lInbH3nSgVYCotmTUulETg==
X-Received: by 2002:a17:902:8a85:: with SMTP id p5mr11573699plo.308.1593987764335;
        Sun, 05 Jul 2020 15:22:44 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i184sm16843251pfc.73.2020.07.05.15.22.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Jul 2020 15:22:43 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v3 3/8] bnxt_en: Add helper function to return the number of RSS contexts.
Date:   Sun,  5 Jul 2020 18:22:07 -0400
Message-Id: <1593987732-1336-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
References: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
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

