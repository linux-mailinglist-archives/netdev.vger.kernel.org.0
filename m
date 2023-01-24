Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717E2679A1B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 14:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbjAXNou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 08:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbjAXNoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 08:44:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091DD458BE;
        Tue, 24 Jan 2023 05:43:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66C8C611F4;
        Tue, 24 Jan 2023 13:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570BCC433A1;
        Tue, 24 Jan 2023 13:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567761;
        bh=28s8NKp/h7hNyH3Vhy7UE4qIlr0TPqn8MaWm2GVqiFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpyaIpPOsuwMCyFsoB2WGFXDnzOx6pDNivymgXVJ4Qrn5KXl7gCAY1RVMUIvWEpxe
         0rbbmqkiCl5s2m0WxKMywV8u5LWkV8QswflF6RcPbH7PUsD9ENQS1G6FoNvk7YVqlW
         fvQ6hj9duN9PKE8SI/3Y82/jAXoKvEIqF0V/xcVfTE1o+R2fSnG9pbOXhsLX11zmw2
         duElda9IkwSifPbKm97uySubjmSJ/fqs6JM0s5QyJvzJyyizoCBo8fuEGk4ANWu2zD
         n3X57k70pUwpsBny/6QlYMTByg94Kx+jl7TGYFPW1FfyjIpJ/OG4/hqdJTzGs2OqFP
         KxCx7fKSbDtBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srujana Challa <schalla@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 28/35] octeontx2-af: add mbox for CPT LF reset
Date:   Tue, 24 Jan 2023 08:41:24 -0500
Message-Id: <20230124134131.637036-28-sashal@kernel.org>
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

[ Upstream commit f58cf765e8f5f4860ea094aa12c156d9195a4c28 ]

On OcteonTX2 SoC, the admin function (AF) is the only one with all
priviliges to configure HW and alloc resources, PFs and it's VFs
have to request AF via mailbox for all their needs.
This patch adds a new mailbox for CPT VFs to request for CPT LF
reset.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  8 +++++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 33 +++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 8d5d5a0f68c4..9af4c987ab4b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -195,6 +195,7 @@ M(CPT_STATS,            0xA05, cpt_sts, cpt_sts_req, cpt_sts_rsp)	\
 M(CPT_RXC_TIME_CFG,     0xA06, cpt_rxc_time_cfg, cpt_rxc_time_cfg_req,  \
 			       msg_rsp)                                 \
 M(CPT_CTX_CACHE_SYNC,   0xA07, cpt_ctx_cache_sync, msg_req, msg_rsp)    \
+M(CPT_LF_RESET,         0xA08, cpt_lf_reset, cpt_lf_rst_req, msg_rsp)	\
 /* SDP mbox IDs (range 0x1000 - 0x11FF) */				\
 M(SET_SDP_CHAN_INFO, 0x1000, set_sdp_chan_info, sdp_chan_info_msg, msg_rsp) \
 M(GET_SDP_CHAN_INFO, 0x1001, get_sdp_chan_info, msg_req, sdp_get_chan_info_msg) \
@@ -1674,6 +1675,13 @@ struct cpt_inst_lmtst_req {
 	u64 rsvd;
 };
 
+/* Mailbox message format to request for CPT LF reset */
+struct cpt_lf_rst_req {
+	struct mbox_msghdr hdr;
+	u32 slot;
+	u32 rsvd;
+};
+
 struct sdp_node_info {
 	/* Node to which this PF belons to */
 	u8 node_id;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 1ed16ce515bb..1cd34914cb86 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -851,6 +851,39 @@ int rvu_mbox_handler_cpt_ctx_cache_sync(struct rvu *rvu, struct msg_req *req,
 	return rvu_cpt_ctx_flush(rvu, req->hdr.pcifunc);
 }
 
+int rvu_mbox_handler_cpt_lf_reset(struct rvu *rvu, struct cpt_lf_rst_req *req,
+				  struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_block *block;
+	int cptlf, blkaddr, ret;
+	u16 actual_slot;
+	u64 ctl, ctl2;
+
+	blkaddr = rvu_get_blkaddr_from_slot(rvu, BLKTYPE_CPT, pcifunc,
+					    req->slot, &actual_slot);
+	if (blkaddr < 0)
+		return CPT_AF_ERR_LF_INVALID;
+
+	block = &rvu->hw->block[blkaddr];
+
+	cptlf = rvu_get_lf(rvu, block, pcifunc, actual_slot);
+	if (cptlf < 0)
+		return CPT_AF_ERR_LF_INVALID;
+	ctl = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf));
+	ctl2 = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf));
+
+	ret = rvu_lf_reset(rvu, block, cptlf);
+	if (ret)
+		dev_err(rvu->dev, "Failed to reset blkaddr %d LF%d\n",
+			block->addr, cptlf);
+
+	rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), ctl);
+	rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf), ctl2);
+
+	return 0;
+}
+
 static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
 {
 	struct cpt_rxc_time_cfg_req req;
-- 
2.39.0

