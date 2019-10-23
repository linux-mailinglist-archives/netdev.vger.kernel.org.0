Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC117E11E9
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 08:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733214AbfJWGFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 02:05:39 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59109 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbfJWGFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 02:05:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BE3FC22056;
        Wed, 23 Oct 2019 02:05:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 23 Oct 2019 02:05:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=WmRsHbXnofGLt6lBbuzgz19iMMx1CUTd5Zf/xIQdbnY=; b=rtZYM/Um
        8w4nJA4fMsjKY4Syu1WBjUMcTqflYnhOIjTGfrnuQdEAYS6auaD5Yg4A9EttB4ZO
        agWHhFQp9QhvtABdo+IV39zAXaU5t6GCzqqKbolQgR+KwvN/2AFOw1CMUuHmt1Eb
        vDI8TCbjTheuuXVcptw9f2vYnzkkGJAM9MYoAIj4Eu3ew/1y9+UuFttoQ/i4AOnf
        zW4iOSMCLXG2jGamQKoVvbsPv/zM3y9BX3BVzUx1hzHZ7TmhDz3lQCT1IG1W1Kqz
        3hmU/yk+p24Zr5Y/AJbbLclJWbpd90la11aqSqjK9Drz1RswYdPQACzSMEOOq+6Z
        yvmMaA21ODCgQQ==
X-ME-Sender: <xms:se2vXeFcE26GdhIGDU70kgBC4PeLZCx8d5Ly4XTTyC38O2JhplvEOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrkeekgddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:se2vXYohCuW3WhGrVmtwmjgEENf8IG8ZeaieP8JErcui3M-6SoqE5g>
    <xmx:se2vXfYSIJ0TSsOYNY_jZJnVMuOmRz0P3E2n2mb2teEdngsSNggVAg>
    <xmx:se2vXZU1qRVGv3wrJ62kSM2yVCzbftpnuOkIBQIiPxfz36ZE3BOyRQ>
    <xmx:se2vXWsRXfUP7UguG87_BbJA36e18S6BW1f9GINyYka2PW6jxswKWg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4660380059;
        Wed, 23 Oct 2019 02:05:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        jiri@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/2] mlxsw: spectrum: Use guaranteed buffer size as pool size limit
Date:   Wed, 23 Oct 2019 09:04:59 +0300
Message-Id: <20191023060500.19709-2-idosch@idosch.org>
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

There are two resources associated with shared buffer size:
cap_total_buffer_size, and cap_guaranteed_shared_buffer. So far, mlxsw has
been using the former as a limit to determine how large a pool size is
allowed to be. However, the total size also includes headrooms and reserved
space, which really cannot be used for shared buffer pools.

Therefore convert mlxsw to use the latter resource as a limit. Adjust
hard-coded pool sizes to be the guaranteed size minus 256000 bytes for CPU
port pool. On Spectrum-1 that actually leads to an increase. A follow-up
patch will have this size calculated automatically.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/resources.h   |  4 ++--
 .../ethernet/mellanox/mlxsw/spectrum_buffers.c    | 15 ++++++++-------
 .../net/ethernet/mellanox/mlxsw/spectrum_qdisc.c  |  3 ++-
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/resources.h b/drivers/net/ethernet/mellanox/mlxsw/resources.h
index 33a9fc9ef6a4..85f919fe851b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/resources.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/resources.h
@@ -26,7 +26,7 @@ enum mlxsw_res_id {
 	MLXSW_RES_ID_MAX_LAG_MEMBERS,
 	MLXSW_RES_ID_LOCAL_PORTS_IN_1X,
 	MLXSW_RES_ID_LOCAL_PORTS_IN_2X,
-	MLXSW_RES_ID_MAX_BUFFER_SIZE,
+	MLXSW_RES_ID_GUARANTEED_SHARED_BUFFER,
 	MLXSW_RES_ID_CELL_SIZE,
 	MLXSW_RES_ID_MAX_HEADROOM_SIZE,
 	MLXSW_RES_ID_ACL_MAX_TCAM_REGIONS,
@@ -82,7 +82,7 @@ static u16 mlxsw_res_ids[] = {
 	[MLXSW_RES_ID_MAX_LAG_MEMBERS] = 0x2521,
 	[MLXSW_RES_ID_LOCAL_PORTS_IN_1X] = 0x2610,
 	[MLXSW_RES_ID_LOCAL_PORTS_IN_2X] = 0x2611,
-	[MLXSW_RES_ID_MAX_BUFFER_SIZE] = 0x2802,	/* Bytes */
+	[MLXSW_RES_ID_GUARANTEED_SHARED_BUFFER] = 0x2805,	/* Bytes */
 	[MLXSW_RES_ID_CELL_SIZE] = 0x2803,	/* Bytes */
 	[MLXSW_RES_ID_MAX_HEADROOM_SIZE] = 0x2811,	/* Bytes */
 	[MLXSW_RES_ID_ACL_MAX_TCAM_REGIONS] = 0x2901,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index b9eeae37a4dc..637151682cf2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -421,8 +421,8 @@ static void mlxsw_sp_sb_ports_fini(struct mlxsw_sp *mlxsw_sp)
 		.freeze_size = _freeze_size,				\
 	}
 
-#define MLXSW_SP1_SB_PR_INGRESS_SIZE	12440000
-#define MLXSW_SP1_SB_PR_EGRESS_SIZE	13232000
+#define MLXSW_SP1_SB_PR_INGRESS_SIZE	13768608
+#define MLXSW_SP1_SB_PR_EGRESS_SIZE	13768608
 #define MLXSW_SP1_SB_PR_CPU_SIZE	(256 * 1000)
 
 /* Order according to mlxsw_sp1_sb_pool_dess */
@@ -445,8 +445,8 @@ static const struct mlxsw_sp_sb_pr mlxsw_sp1_sb_prs[] = {
 			   MLXSW_SP1_SB_PR_CPU_SIZE, true, false),
 };
 
-#define MLXSW_SP2_SB_PR_INGRESS_SIZE	35297568
-#define MLXSW_SP2_SB_PR_EGRESS_SIZE	35297568
+#define MLXSW_SP2_SB_PR_INGRESS_SIZE	34084800
+#define MLXSW_SP2_SB_PR_EGRESS_SIZE	34084800
 #define MLXSW_SP2_SB_PR_CPU_SIZE	(256 * 1000)
 
 /* Order according to mlxsw_sp2_sb_pool_dess */
@@ -904,7 +904,7 @@ int mlxsw_sp_buffers_init(struct mlxsw_sp *mlxsw_sp)
 	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, CELL_SIZE))
 		return -EIO;
 
-	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_BUFFER_SIZE))
+	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, GUARANTEED_SHARED_BUFFER))
 		return -EIO;
 
 	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_HEADROOM_SIZE))
@@ -915,7 +915,7 @@ int mlxsw_sp_buffers_init(struct mlxsw_sp *mlxsw_sp)
 		return -ENOMEM;
 	mlxsw_sp->sb->cell_size = MLXSW_CORE_RES_GET(mlxsw_sp->core, CELL_SIZE);
 	mlxsw_sp->sb->sb_size = MLXSW_CORE_RES_GET(mlxsw_sp->core,
-						   MAX_BUFFER_SIZE);
+						   GUARANTEED_SHARED_BUFFER);
 	max_headroom_size = MLXSW_CORE_RES_GET(mlxsw_sp->core,
 					       MAX_HEADROOM_SIZE);
 	/* Round down, because this limit must not be overstepped. */
@@ -1013,7 +1013,8 @@ int mlxsw_sp_sb_pool_set(struct mlxsw_core *mlxsw_core,
 	mode = (enum mlxsw_reg_sbpr_mode) threshold_type;
 	pr = &mlxsw_sp->sb_vals->prs[pool_index];
 
-	if (size > MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_BUFFER_SIZE)) {
+	if (size > MLXSW_CORE_RES_GET(mlxsw_sp->core,
+				      GUARANTEED_SHARED_BUFFER)) {
 		NL_SET_ERR_MSG_MOD(extack, "Exceeded shared buffer size");
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index bdf53cf350f6..68cc6737d45c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -305,7 +305,8 @@ mlxsw_sp_qdisc_red_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
 			p->max);
 		return -EINVAL;
 	}
-	if (p->max > MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_BUFFER_SIZE)) {
+	if (p->max > MLXSW_CORE_RES_GET(mlxsw_sp->core,
+					GUARANTEED_SHARED_BUFFER)) {
 		dev_err(mlxsw_sp->bus_info->dev,
 			"spectrum: RED: max value %u is too big\n", p->max);
 		return -EINVAL;
-- 
2.21.0

