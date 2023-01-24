Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30251679A0B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 14:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbjAXNoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 08:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbjAXNne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 08:43:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA2C1E5F7;
        Tue, 24 Jan 2023 05:42:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BE34B811E1;
        Tue, 24 Jan 2023 13:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8537DC433A1;
        Tue, 24 Jan 2023 13:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567766;
        bh=oO0wEpPVDbKGv/d7IauLB1VA8rBVN7mdSwL4WrW9w40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBSr+jK7Jau9kRWMcSk3oM3zrxf5lnHHGznfnM1rxPHlGIoUZsfvnXWIhzoDeJ5M+
         PIkQz84TNFHQDFGF0Ndqlc+wUd6cnd4lpSP603nVDy3iL2n+cnlCb/MyaykjGNwqkI
         2RoGTC1b+Vp1sqUNdhw5s7FkYyK+SoRAMnYI6ml8iNEC0JdlAm3y7tAtdSlB7hJaMY
         x3kbcmdJQFrE+fFSibEB/nH0YHGmpvrsqRO9YkjlDmCnRZ0+7ZeeupNayRmkeHT0bO
         dfmxX6H9zOEyoVGloE+eUFOgMS35Ton/rNc8acPENMWboMHFgBPqiG4EQ2yVUJnEaT
         bQx/RcA/fUqMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srujana Challa <schalla@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 30/35] octeontx2-af: optimize cpt pf identification
Date:   Tue, 24 Jan 2023 08:41:26 -0500
Message-Id: <20230124134131.637036-30-sashal@kernel.org>
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

From: Srujana Challa <schalla@marvell.com>

[ Upstream commit 9adb04ff62f51265002c2c83e718bcf459e06e48 ]

Optimize CPT PF identification in mbox handling for faster
mbox response by doing it at AF driver probe instead of
every mbox message.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c     |  8 ++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h     |  2 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c | 13 ++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 3f5e09b77d4b..8683ce57ed3f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1164,8 +1164,16 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 		goto nix_err;
 	}
 
+	err = rvu_cpt_init(rvu);
+	if (err) {
+		dev_err(rvu->dev, "%s: Failed to initialize cpt\n", __func__);
+		goto mcs_err;
+	}
+
 	return 0;
 
+mcs_err:
+	rvu_mcs_exit(rvu);
 nix_err:
 	rvu_nix_freemem(rvu);
 npa_err:
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index a981463939ac..0210318698b2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -505,6 +505,7 @@ struct rvu {
 	struct ptp		*ptp;
 
 	int			mcs_blk_cnt;
+	int			cpt_pf_num;
 
 #ifdef CONFIG_DEBUG_FS
 	struct rvu_debugfs	rvu_dbg;
@@ -870,6 +871,7 @@ void rvu_cpt_unregister_interrupts(struct rvu *rvu);
 int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf,
 			int slot);
 int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc);
+int rvu_cpt_init(struct rvu *rvu);
 
 /* CN10K RVU */
 int rvu_set_channels_base(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index e8973294c4f8..f970cb9b0bff 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -340,7 +340,7 @@ static int get_cpt_pf_num(struct rvu *rvu)
 
 static bool is_cpt_pf(struct rvu *rvu, u16 pcifunc)
 {
-	int cpt_pf_num = get_cpt_pf_num(rvu);
+	int cpt_pf_num = rvu->cpt_pf_num;
 
 	if (rvu_get_pf(pcifunc) != cpt_pf_num)
 		return false;
@@ -352,7 +352,7 @@ static bool is_cpt_pf(struct rvu *rvu, u16 pcifunc)
 
 static bool is_cpt_vf(struct rvu *rvu, u16 pcifunc)
 {
-	int cpt_pf_num = get_cpt_pf_num(rvu);
+	int cpt_pf_num = rvu->cpt_pf_num;
 
 	if (rvu_get_pf(pcifunc) != cpt_pf_num)
 		return false;
@@ -1015,7 +1015,7 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf, int s
 static int cpt_inline_inb_lf_cmd_send(struct rvu *rvu, int blkaddr,
 				      int nix_blkaddr)
 {
-	int cpt_pf_num = get_cpt_pf_num(rvu);
+	int cpt_pf_num = rvu->cpt_pf_num;
 	struct cpt_inst_lmtst_req *req;
 	dma_addr_t res_daddr;
 	int timeout = 3000;
@@ -1159,3 +1159,10 @@ int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc)
 
 	return 0;
 }
+
+int rvu_cpt_init(struct rvu *rvu)
+{
+	/* Retrieve CPT PF number */
+	rvu->cpt_pf_num = get_cpt_pf_num(rvu);
+	return 0;
+}
-- 
2.39.0

