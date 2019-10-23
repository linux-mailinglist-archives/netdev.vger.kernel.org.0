Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A758E11EA
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 08:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733246AbfJWGFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 02:05:40 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55381 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbfJWGFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 02:05:40 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 56E3222050;
        Wed, 23 Oct 2019 02:05:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 23 Oct 2019 02:05:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=SLV/egfcUrU3yL8VrC5Zaszk/bVdO+CZjqWbYWd32TY=; b=PUo6gLY1
        V0mnOedH7FoS7zwlTcTO9uT3S19MUsMFhIFYCeb0pKLZs+JizpYh91DODf+yUWke
        mSv5j2fmXethnKjuVMdlWsleBCGokOZaATKdmijCHSkhIRQyEUoMei5PIBKKgcVm
        TPzR69wxGi+ZBf+khvBbaq0rKGVWNzWNrEMCTNcNv8a/gOU8BiVWMdhqSSFEdxog
        6tfGBKLR/2EfoLN1OgTShUrEpjAcZXKcFO+1IS+/5A7WGk0VE7affQlzYPqhXE0H
        J2bX9+EqFFjQuZZ2JHFZlk5K/PMVvu92PrS1Z9dz4qgJUuf5ZK84KDNCO3MXHm+W
        fzGt0JPkENdThQ==
X-ME-Sender: <xms:s-2vXTXxWZlKL8IiNR1CImUtU3TNaHkUSXaZ1X7URpp5w5dZfdhvWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrkeekgddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:s-2vXTdciIfWYHjIaDC8ZkrmneiGLlVTvDjNMnxuRv_u1S3zYOvBgg>
    <xmx:s-2vXewMUKAP0JJhsPW_NEMzqdjc329AuLVGQsF9HzA6MDlGI0z_Lg>
    <xmx:s-2vXWEQk9MWU5ru0wqDViF1BKVdiMp9jHIwM55U-AzROaQ-s5C2HQ>
    <xmx:s-2vXTzvYzSGqx79fCbND1_KF0g1fsZuZd1sCa3Ep6A0CrghVs43dw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C16EA8005C;
        Wed, 23 Oct 2019 02:05:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        jiri@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/2] mlxsw: spectrum_buffers: Calculate the size of the main pool
Date:   Wed, 23 Oct 2019 09:05:00 +0300
Message-Id: <20191023060500.19709-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023060500.19709-1-idosch@idosch.org>
References: <20191023060500.19709-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Instead of hard-coding the size of the largest pool, calculate it from the
reported guaranteed shared buffer size and sizes of other pools (currently
only the CPU port pool).

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/spectrum_buffers.c         | 46 ++++++++++++++-----
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 637151682cf2..5fd9a72c8471 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -35,6 +35,7 @@ struct mlxsw_sp_sb_cm {
 };
 
 #define MLXSW_SP_SB_INFI -1U
+#define MLXSW_SP_SB_REST -2U
 
 struct mlxsw_sp_sb_pm {
 	u32 min_buff;
@@ -421,19 +422,16 @@ static void mlxsw_sp_sb_ports_fini(struct mlxsw_sp *mlxsw_sp)
 		.freeze_size = _freeze_size,				\
 	}
 
-#define MLXSW_SP1_SB_PR_INGRESS_SIZE	13768608
-#define MLXSW_SP1_SB_PR_EGRESS_SIZE	13768608
 #define MLXSW_SP1_SB_PR_CPU_SIZE	(256 * 1000)
 
 /* Order according to mlxsw_sp1_sb_pool_dess */
 static const struct mlxsw_sp_sb_pr mlxsw_sp1_sb_prs[] = {
-	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC,
-		       MLXSW_SP1_SB_PR_INGRESS_SIZE),
+	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, MLXSW_SP_SB_REST),
 	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, 0),
 	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, 0),
 	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, 0),
-	MLXSW_SP_SB_PR_EXT(MLXSW_REG_SBPR_MODE_DYNAMIC,
-			   MLXSW_SP1_SB_PR_EGRESS_SIZE, true, false),
+	MLXSW_SP_SB_PR_EXT(MLXSW_REG_SBPR_MODE_DYNAMIC, MLXSW_SP_SB_REST,
+			   true, false),
 	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, 0),
 	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, 0),
 	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, 0),
@@ -445,19 +443,16 @@ static const struct mlxsw_sp_sb_pr mlxsw_sp1_sb_prs[] = {
 			   MLXSW_SP1_SB_PR_CPU_SIZE, true, false),
 };
 
-#define MLXSW_SP2_SB_PR_INGRESS_SIZE	34084800
-#define MLXSW_SP2_SB_PR_EGRESS_SIZE	34084800
 #define MLXSW_SP2_SB_PR_CPU_SIZE	(256 * 1000)
 
 /* Order according to mlxsw_sp2_sb_pool_dess */
 static const struct mlxsw_sp_sb_pr mlxsw_sp2_sb_prs[] = {
-	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC,
-		       MLXSW_SP2_SB_PR_INGRESS_SIZE),
+	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_DYNAMIC, MLXSW_SP_SB_REST),
 	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_STATIC, 0),
 	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_STATIC, 0),
 	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_STATIC, 0),
-	MLXSW_SP_SB_PR_EXT(MLXSW_REG_SBPR_MODE_DYNAMIC,
-			   MLXSW_SP2_SB_PR_EGRESS_SIZE, true, false),
+	MLXSW_SP_SB_PR_EXT(MLXSW_REG_SBPR_MODE_DYNAMIC, MLXSW_SP_SB_REST,
+			   true, false),
 	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_STATIC, 0),
 	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_STATIC, 0),
 	MLXSW_SP_SB_PR(MLXSW_REG_SBPR_MODE_STATIC, 0),
@@ -471,11 +466,33 @@ static const struct mlxsw_sp_sb_pr mlxsw_sp2_sb_prs[] = {
 
 static int mlxsw_sp_sb_prs_init(struct mlxsw_sp *mlxsw_sp,
 				const struct mlxsw_sp_sb_pr *prs,
+				const struct mlxsw_sp_sb_pool_des *pool_dess,
 				size_t prs_len)
 {
+	/* Round down, unlike mlxsw_sp_bytes_cells(). */
+	u32 sb_cells = mlxsw_sp->sb->sb_size / mlxsw_sp->sb->cell_size;
+	u32 rest_cells[2] = {sb_cells, sb_cells};
 	int i;
 	int err;
 
+	/* Calculate how much space to give to the "REST" pools in either
+	 * direction.
+	 */
+	for (i = 0; i < prs_len; i++) {
+		enum mlxsw_reg_sbxx_dir dir = pool_dess[i].dir;
+		u32 size = prs[i].size;
+		u32 size_cells;
+
+		if (size == MLXSW_SP_SB_INFI || size == MLXSW_SP_SB_REST)
+			continue;
+
+		size_cells = mlxsw_sp_bytes_cells(mlxsw_sp, size);
+		if (WARN_ON_ONCE(size_cells > rest_cells[dir]))
+			continue;
+
+		rest_cells[dir] -= size_cells;
+	}
+
 	for (i = 0; i < prs_len; i++) {
 		u32 size = prs[i].size;
 		u32 size_cells;
@@ -483,6 +500,10 @@ static int mlxsw_sp_sb_prs_init(struct mlxsw_sp *mlxsw_sp,
 		if (size == MLXSW_SP_SB_INFI) {
 			err = mlxsw_sp_sb_pr_write(mlxsw_sp, i, prs[i].mode,
 						   0, true);
+		} else if (size == MLXSW_SP_SB_REST) {
+			size_cells = rest_cells[pool_dess[i].dir];
+			err = mlxsw_sp_sb_pr_write(mlxsw_sp, i, prs[i].mode,
+						   size_cells, false);
 		} else {
 			size_cells = mlxsw_sp_bytes_cells(mlxsw_sp, size);
 			err = mlxsw_sp_sb_pr_write(mlxsw_sp, i, prs[i].mode,
@@ -926,6 +947,7 @@ int mlxsw_sp_buffers_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		goto err_sb_ports_init;
 	err = mlxsw_sp_sb_prs_init(mlxsw_sp, mlxsw_sp->sb_vals->prs,
+				   mlxsw_sp->sb_vals->pool_dess,
 				   mlxsw_sp->sb_vals->pool_count);
 	if (err)
 		goto err_sb_prs_init;
-- 
2.21.0

