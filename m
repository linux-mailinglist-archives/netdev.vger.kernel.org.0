Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6286679A08
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 14:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbjAXNoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 08:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234370AbjAXNnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 08:43:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA57F1F5D0;
        Tue, 24 Jan 2023 05:42:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8646B6117D;
        Tue, 24 Jan 2023 13:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F35C4339E;
        Tue, 24 Jan 2023 13:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567768;
        bh=6qEweodQCR6FEb6DBQxVypNlBcAFlt73MVsK/n68V88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tx5mSM/9o8RUK1g8ko6Vk82gWFHAqbf5m5Yw6H5hLjXnoB3BLmiXktqQc2d1zkWzM
         3J6tsVLCXMqnhU1GKvwh5wt5xs/FwYz7C78yDfJyghYdXZat53J4uraU+ptmkTsVjW
         XmbDlEmTSWtsQOmdWflCcW46t+POoryocvJYKjgzHCf8+oTmv8Lca946DcW64Q7SBq
         Lu0APy5MAbLe+/FfI1xBN/I/nIHF5Mw0YWk/ACWp3ztA9rU7/6zNplWSlEUYa/kxm8
         k952wv0imtiMLaz/q+2a1GhAV7c766xSzSVGiHjgerh1ir2b8Lrg0skN4wb/B4mqS8
         ArQZOSQKjv9Mw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nithin Dabilpuram <ndabilpuram@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 31/35] octeontx2-af: restore rxc conf after teardown sequence
Date:   Tue, 24 Jan 2023 08:41:27 -0500
Message-Id: <20230124134131.637036-31-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nithin Dabilpuram <ndabilpuram@marvell.com>

[ Upstream commit d5b2e0a299f36c6ccdda4830525ca20550243536 ]

CN10K CPT coprocessor includes a component named RXC which
is responsible for reassembly of inner IP packets. RXC has
the feature to evict oldest entries based on age/threshold.
The age/threshold is being set to minimum values to evict
all entries at the time of teardown.
This patch adds code to restore timeout and threshold config
after teardown sequence is complete as it is global config.

Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index f970cb9b0bff..302ff549284e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -812,10 +812,21 @@ int rvu_mbox_handler_cpt_sts(struct rvu *rvu, struct cpt_sts_req *req,
 #define RXC_ZOMBIE_COUNT  GENMASK_ULL(60, 48)
 
 static void cpt_rxc_time_cfg(struct rvu *rvu, struct cpt_rxc_time_cfg_req *req,
-			     int blkaddr)
+			     int blkaddr, struct cpt_rxc_time_cfg_req *save)
 {
 	u64 dfrg_reg;
 
+	if (save) {
+		/* Save older config */
+		dfrg_reg = rvu_read64(rvu, blkaddr, CPT_AF_RXC_DFRG);
+		save->zombie_thres = FIELD_GET(RXC_ZOMBIE_THRES, dfrg_reg);
+		save->zombie_limit = FIELD_GET(RXC_ZOMBIE_LIMIT, dfrg_reg);
+		save->active_thres = FIELD_GET(RXC_ACTIVE_THRES, dfrg_reg);
+		save->active_limit = FIELD_GET(RXC_ACTIVE_LIMIT, dfrg_reg);
+
+		save->step = rvu_read64(rvu, blkaddr, CPT_AF_RXC_TIME_CFG);
+	}
+
 	dfrg_reg = FIELD_PREP(RXC_ZOMBIE_THRES, req->zombie_thres);
 	dfrg_reg |= FIELD_PREP(RXC_ZOMBIE_LIMIT, req->zombie_limit);
 	dfrg_reg |= FIELD_PREP(RXC_ACTIVE_THRES, req->active_thres);
@@ -840,7 +851,7 @@ int rvu_mbox_handler_cpt_rxc_time_cfg(struct rvu *rvu,
 	    !is_cpt_vf(rvu, req->hdr.pcifunc))
 		return CPT_AF_ERR_ACCESS_DENIED;
 
-	cpt_rxc_time_cfg(rvu, req, blkaddr);
+	cpt_rxc_time_cfg(rvu, req, blkaddr, NULL);
 
 	return 0;
 }
@@ -886,7 +897,7 @@ int rvu_mbox_handler_cpt_lf_reset(struct rvu *rvu, struct cpt_lf_rst_req *req,
 
 static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
 {
-	struct cpt_rxc_time_cfg_req req;
+	struct cpt_rxc_time_cfg_req req, prev;
 	int timeout = 2000;
 	u64 reg;
 
@@ -902,7 +913,7 @@ static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
 	req.active_thres = 1;
 	req.active_limit = 1;
 
-	cpt_rxc_time_cfg(rvu, &req, blkaddr);
+	cpt_rxc_time_cfg(rvu, &req, blkaddr, &prev);
 
 	do {
 		reg = rvu_read64(rvu, blkaddr, CPT_AF_RXC_ACTIVE_STS);
@@ -928,6 +939,9 @@ static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
 
 	if (timeout == 0)
 		dev_warn(rvu->dev, "Poll for RXC zombie count hits hard loop counter\n");
+
+	/* Restore config */
+	cpt_rxc_time_cfg(rvu, &prev, blkaddr, NULL);
 }
 
 #define INFLIGHT   GENMASK_ULL(8, 0)
-- 
2.39.0

