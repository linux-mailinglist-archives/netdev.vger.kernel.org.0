Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9772134D1
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 09:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgGCHUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 03:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbgGCHUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 03:20:05 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EB8C08C5C1
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 00:20:05 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f2so3577670wrp.7
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 00:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kSuwbDL8E82u6tY6mu6JUlQnm0c4tyC/+rE2UEwcntU=;
        b=EHK2sS5Knapx1VFtfeqwfmfI+SCW9du3mtlxA7T9Qp+KoEN2QJWvq83iVY6rQhWtJX
         cg+cOjyDNqFldf2TeJ13bFCYwW7pjFcAJ1EH4HlviX+UPDeGDuEMNGP8bfSLR1AawYAL
         9N1BUAIL+Zk6GoJ1xzc8VJIIv0DvGuhIeYziQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kSuwbDL8E82u6tY6mu6JUlQnm0c4tyC/+rE2UEwcntU=;
        b=kT3I6S/1EXDXOKc48xA3r7ZAroBrL+KLQByoACEfXsVm4mVaFWMIUXKqYXwMci4bBj
         2UDpZ/zwULGvWTGKDmi53sRm1wnQHs15u1TtKmMnrLHX0xGvEzIwq7Intay951ZdGJBM
         tVj/vdHqDdEGsuwTdxOggfUlLiLQI3936EgCVQ0N8ESTtyF7ECjyeDAQKuQtzWvI/lmM
         iiEDgkK7aUUtKIp33qMNa/f8WYCEo6X9ag41plk0/+PEs+GhMYcGt1HZFjWfPH8KfSvJ
         sDj4xDTQGOdo50GvUngQiALBfTEnGQNrnnyAlwDsfcXDKuCWbEuuvEqNuK3HjlekYPOA
         uDLg==
X-Gm-Message-State: AOAM532aKeEmsFP5atLCVCrr/4JOBboeI2xvh3K2klHfHA/4a2FqIGVo
        FA3K+2NK8WZJAv3i7Vdo6mEtbn7p21Q=
X-Google-Smtp-Source: ABdhPJzPDsh1g30Pq99L63T3cDeWEgGCUjv0H+zrULmvlBeUZqYTQVCxdoXEChk4b0gh99Y8Ec/Rfg==
X-Received: by 2002:a5d:5310:: with SMTP id e16mr33741638wrv.289.1593760804144;
        Fri, 03 Jul 2020 00:20:04 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a22sm12529564wmj.9.2020.07.03.00.20.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2020 00:20:03 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 2/8] bnxt_en: Add logical RSS indirection table structure.
Date:   Fri,  3 Jul 2020 03:19:41 -0400
Message-Id: <1593760787-31695-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
References: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
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

v2: Use kmalloc_array() since we init. all entries afterwards.
    Use ALIGN() to roundup the RSS table size.
    Use ethtool_rxfh_indir_default() to init. the default entries.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 51 +++++++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  4 +++
 2 files changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4afc1df..70f8302 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4830,6 +4830,48 @@ static u16 bnxt_cp_ring_for_tx(struct bnxt *bp, struct bnxt_tx_ring_info *txr)
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
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		max_entries = ALIGN(max_rings, BNXT_RSS_TABLE_ENTRIES_P5);
+	else
+		max_entries = HW_HASH_INDEX_SIZE;
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
@@ -11514,6 +11556,8 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	bnxt_free_ctx_mem(bp);
 	kfree(bp->ctx);
 	bp->ctx = NULL;
+	kfree(bp->rss_indir_tbl);
+	bp->rss_indir_tbl = NULL;
 	bnxt_free_port_stats(bp);
 	free_netdev(dev);
 }
@@ -12034,6 +12078,11 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -12078,6 +12127,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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

