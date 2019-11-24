Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03C74108195
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 04:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfKXDba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 22:31:30 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42615 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfKXDb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 22:31:29 -0500
Received: by mail-pf1-f195.google.com with SMTP id s5so5567791pfh.9
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 19:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4ncuGcusCFBX3PPbQ8T6Twsd+4+HCj+s18jFB8rGkpY=;
        b=IfAhFwS8KOXZ4y8tffecQUJCH3eiWAh2ISm4j8ltzgs0wUkX4tshcLLwDSi6jeAFdq
         E6eSQ2s1PvJH4uJVh7sw+s1Hl7C9Kp+TbXQAUEgAZvof/1dOVmKJFcO9q1tJ/l4FCSrg
         /ZH16alEKK1St5D8WGWuf/dBVsfdVttHBc7/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4ncuGcusCFBX3PPbQ8T6Twsd+4+HCj+s18jFB8rGkpY=;
        b=KDAcHznnTKmxz4ORcESmof9EqvG8vNCx7CPP7g+emg4byA9NWBDA5KlisMPjub/FNt
         6hUz5Bs0jEv1ZGWFlD2/ypkf8f0m6YGp1IQb/LBF+S2Jqnd+ntjC/0SiwRrCinDVORkm
         R4cCRmqtcr8DWvrYYU0fefFBrDXfI04sWOQ//luNQri5sQj0W2ZlyAo105CqXW5me4BS
         1g8je77Ttq6KEaV9fuMUxaxj2TlOrC6QU5ahhkFauxYryPeUdXZvnLzwXOXVG4XajnZJ
         Guq5FPT8XeL89qBVDuWX7T7xc4spV1QHUB79wIBTU835gnlN6ysHzD9U5lXMwkPBDnIT
         Z4Qg==
X-Gm-Message-State: APjAAAXJIBJ9xhxgYsp4ZH9SWreiMqrKKSuuNUNpdfQn3PC6uhTeX/KP
        jnWLJooqmNxeeQNYzEEVHPop7R57CIc=
X-Google-Smtp-Source: APXvYqxv9QSkJdz94uduSylTTRgMocAmAkfxsT0Zgc/mi2gs1J4Y8RwkwKA1Tsk6b6504VDx5KhSAA==
X-Received: by 2002:a63:a449:: with SMTP id c9mr24832052pgp.53.1574566288587;
        Sat, 23 Nov 2019 19:31:28 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v63sm3111901pfb.181.2019.11.23.19.31.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 19:31:28 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 08/13] bnxt_en: Assign more RSS context resources to the VFs.
Date:   Sat, 23 Nov 2019 22:30:45 -0500
Message-Id: <1574566250-7546-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
References: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver currently only assignes 1 RSS context to each VF.  This works
for the Linux VF driver.  But other drivers, such as DPDK, can make use
of additional RSS contexts.  Modify the code to divide up and assign
RSS contexts to VFs just like other resources.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index f6f3454..2aba1e0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -515,6 +515,7 @@ static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs, bool reset)
 	struct bnxt_pf_info *pf = &bp->pf;
 	int i, rc = 0, min = 1;
 	u16 vf_msix = 0;
+	u16 vf_rss;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_VF_RESOURCE_CFG, -1, -1);
 
@@ -533,9 +534,9 @@ static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs, bool reset)
 	vf_tx_rings = hw_resc->max_tx_rings - bp->tx_nr_rings;
 	vf_vnics = hw_resc->max_vnics - bp->nr_vnics;
 	vf_vnics = min_t(u16, vf_vnics, vf_rx_rings);
+	vf_rss = hw_resc->max_rsscos_ctxs - bp->rsscos_nr_ctxs;
 
 	req.min_rsscos_ctx = cpu_to_le16(BNXT_VF_MIN_RSS_CTX);
-	req.max_rsscos_ctx = cpu_to_le16(BNXT_VF_MAX_RSS_CTX);
 	if (pf->vf_resv_strategy == BNXT_VF_RESV_STRATEGY_MINIMAL_STATIC) {
 		min = 0;
 		req.min_rsscos_ctx = cpu_to_le16(min);
@@ -557,6 +558,7 @@ static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs, bool reset)
 		vf_vnics /= num_vfs;
 		vf_stat_ctx /= num_vfs;
 		vf_ring_grps /= num_vfs;
+		vf_rss /= num_vfs;
 
 		req.min_cmpl_rings = cpu_to_le16(vf_cp_rings);
 		req.min_tx_rings = cpu_to_le16(vf_tx_rings);
@@ -565,6 +567,7 @@ static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs, bool reset)
 		req.min_vnics = cpu_to_le16(vf_vnics);
 		req.min_stat_ctx = cpu_to_le16(vf_stat_ctx);
 		req.min_hw_ring_grps = cpu_to_le16(vf_ring_grps);
+		req.min_rsscos_ctx = cpu_to_le16(vf_rss);
 	}
 	req.max_cmpl_rings = cpu_to_le16(vf_cp_rings);
 	req.max_tx_rings = cpu_to_le16(vf_tx_rings);
@@ -573,6 +576,7 @@ static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs, bool reset)
 	req.max_vnics = cpu_to_le16(vf_vnics);
 	req.max_stat_ctx = cpu_to_le16(vf_stat_ctx);
 	req.max_hw_ring_grps = cpu_to_le16(vf_ring_grps);
+	req.max_rsscos_ctx = cpu_to_le16(vf_rss);
 	if (bp->flags & BNXT_FLAG_CHIP_P5)
 		req.max_msix = cpu_to_le16(vf_msix / num_vfs);
 
@@ -598,7 +602,7 @@ static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs, bool reset)
 		hw_resc->max_hw_ring_grps -= le16_to_cpu(req.min_hw_ring_grps) *
 					     n;
 		hw_resc->max_cp_rings -= le16_to_cpu(req.min_cmpl_rings) * n;
-		hw_resc->max_rsscos_ctxs -= pf->active_vfs;
+		hw_resc->max_rsscos_ctxs -= le16_to_cpu(req.min_rsscos_ctx) * n;
 		hw_resc->max_stat_ctxs -= le16_to_cpu(req.min_stat_ctx) * n;
 		hw_resc->max_vnics -= le16_to_cpu(req.min_vnics) * n;
 		if (bp->flags & BNXT_FLAG_CHIP_P5)
-- 
2.5.1

