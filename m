Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5B71984AD
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgC3Tj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:27 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:37759 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728405AbgC3Tj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id C4C6D580542;
        Mon, 30 Mar 2020 15:39:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=dZiZVo4s0hLUZKMe6kKgDC7BVXr2DLHD4NjtEqbNpGg=; b=RU0mYrHj
        hQJLI5WRZaf6ryid4LTyCIWXfOpo3yf0ItmuyzV5kMB+0GTQsemoHpGXeDCDeImn
        /MoQxtlkATrjTgAwuhLHW3AY8yI0zj/jejgM5WDxz+H+rhn8t6phzuYlFhPHcbk6
        W0tiWoUScjbB4jPMi7LA+zxBfIMqfmIebYAzymmF06Yyo3tTdVtpXTHTWb3F1rBW
        3H1KTPACNGgYKQHKaAPXXN6o1A0JN5G06i4g+DJ7WvcgvTxWl7ySj7CptRqxT4v0
        D69dteKLTjlStw17/RDEda+V2GwlIm2KGqNq+1RPj33KIHbkO7zNeTkcGvbnq30X
        ADWc9ftegbtYGg==
X-ME-Sender: <xms:7UqCXoEPVvVFtxjcV6LsNNaDDFKycR9J6yh5s8wjbjXQYjudOhqrkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:7UqCXhbh_l2txHbp2_3WqNXtQC4_uGgm3465YKPXuY0CtQG6hSPx6w>
    <xmx:7UqCXipt2EF0F9jSuBbOTRdkwu7J5lNpjKibvtrIya5j07YlV2qQ7Q>
    <xmx:7UqCXgzwCcoDIlzRpGgt1Yok3b9V2lBzCDLnoOpoaYCKpaawDZfR2Q>
    <xmx:7UqCXnP_sP8PRzUY120nXLqShGye6p2kTiedGt1-paIoIwwN850CVw>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id ACFA5306C9F4;
        Mon, 30 Mar 2020 15:39:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 09/15] mlxsw: spectrum: Track used packet trap policer IDs
Date:   Mon, 30 Mar 2020 22:38:26 +0300
Message-Id: <20200330193832.2359876-10-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330193832.2359876-1-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

During initialization the driver configures various packet trap groups
and binds policers to them.

Currently, most of these groups are not exposed to user space and
therefore their policers should not be exposed as well. Otherwise, user
space will be able to alter policer parameters without knowing which
packet traps are policed by the policer.

Use a bitmap to track the used policer IDs so that these policers will
not be registered with devlink in a subsequent patch.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 26 ++++++++++++++++---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  2 ++
 .../ethernet/mellanox/mlxsw/spectrum_trap.h   | 12 +++++++++
 4 files changed, 38 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 35d3a68ef4fd..a109ecbb62b9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -43,6 +43,7 @@
 #include "spectrum_acl_flex_actions.h"
 #include "spectrum_span.h"
 #include "spectrum_ptp.h"
+#include "spectrum_trap.h"
 #include "../mlxfw/mlxfw.h"
 
 #define MLXSW_SP1_FWREV_MAJOR 13
@@ -4556,6 +4557,7 @@ static const struct mlxsw_listener mlxsw_sp1_listener[] = {
 
 static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 {
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	char qpcr_pl[MLXSW_REG_QPCR_LEN];
 	enum mlxsw_reg_qpcr_ir_units ir_units;
 	int max_cpu_policers;
@@ -4619,6 +4621,7 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 			continue;
 		}
 
+		__set_bit(i, mlxsw_sp->trap->policers_usage);
 		mlxsw_reg_qpcr_pack(qpcr_pl, i, ir_units, is_bytes, rate,
 				    burst_size);
 		err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(qpcr), qpcr_pl);
@@ -4747,20 +4750,32 @@ static void mlxsw_sp_traps_unregister(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
 {
+	struct mlxsw_sp_trap *trap;
+	u64 max_policers;
 	int err;
 
+	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_CPU_POLICERS))
+		return -EIO;
+	max_policers = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_CPU_POLICERS);
+	trap = kzalloc(struct_size(trap, policers_usage,
+				   BITS_TO_LONGS(max_policers)), GFP_KERNEL);
+	if (!trap)
+		return -ENOMEM;
+	trap->max_policers = max_policers;
+	mlxsw_sp->trap = trap;
+
 	err = mlxsw_sp_cpu_policers_set(mlxsw_sp->core);
 	if (err)
-		return err;
+		goto err_cpu_policers_set;
 
 	err = mlxsw_sp_trap_groups_set(mlxsw_sp->core);
 	if (err)
-		return err;
+		goto err_trap_groups_set;
 
 	err = mlxsw_sp_traps_register(mlxsw_sp, mlxsw_sp_listener,
 				      ARRAY_SIZE(mlxsw_sp_listener));
 	if (err)
-		return err;
+		goto err_traps_register;
 
 	err = mlxsw_sp_traps_register(mlxsw_sp, mlxsw_sp->listeners,
 				      mlxsw_sp->listeners_count);
@@ -4772,6 +4787,10 @@ static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
 err_extra_traps_init:
 	mlxsw_sp_traps_unregister(mlxsw_sp, mlxsw_sp_listener,
 				  ARRAY_SIZE(mlxsw_sp_listener));
+err_traps_register:
+err_trap_groups_set:
+err_cpu_policers_set:
+	kfree(trap);
 	return err;
 }
 
@@ -4781,6 +4800,7 @@ static void mlxsw_sp_traps_fini(struct mlxsw_sp *mlxsw_sp)
 				  mlxsw_sp->listeners_count);
 	mlxsw_sp_traps_unregister(mlxsw_sp, mlxsw_sp_listener,
 				  ARRAY_SIZE(mlxsw_sp_listener));
+	kfree(mlxsw_sp->trap);
 }
 
 #define MLXSW_SP_LAG_SEED_INIT 0xcafecafe
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 9f06f7a5308a..928b56880fea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -176,6 +176,7 @@ struct mlxsw_sp {
 	struct mlxsw_sp_ptp_state *ptp_state;
 	struct mlxsw_sp_counter_pool *counter_pool;
 	struct mlxsw_sp_span *span;
+	struct mlxsw_sp_trap *trap;
 	const struct mlxsw_fw_rev *req_rev;
 	const char *fw_filename;
 	const struct mlxsw_sp_kvdl_ops *kvdl_ops;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 24f15345ba84..6a77bf236c22 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -8,6 +8,7 @@
 #include "core.h"
 #include "reg.h"
 #include "spectrum.h"
+#include "spectrum_trap.h"
 
 /* All driver-specific traps must be documented in
  * Documentation/networking/devlink/mlxsw.rst
@@ -309,6 +310,7 @@ static int mlxsw_sp_trap_cpu_policers_set(struct mlxsw_sp *mlxsw_sp)
 	/* The purpose of "thin" policer is to drop as many packets
 	 * as possible. The dummy group is using it.
 	 */
+	__set_bit(MLXSW_SP_THIN_POLICER_ID, mlxsw_sp->trap->policers_usage);
 	mlxsw_reg_qpcr_pack(qpcr_pl, MLXSW_SP_THIN_POLICER_ID,
 			    MLXSW_REG_QPCR_IR_UNITS_M, false, 1, 4);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qpcr), qpcr_pl);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
new file mode 100644
index 000000000000..12c5641b2165
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2020 Mellanox Technologies. All rights reserved */
+
+#ifndef _MLXSW_SPECTRUM_TRAP_H
+#define _MLXSW_SPECTRUM_TRAP_H
+
+struct mlxsw_sp_trap {
+	u64 max_policers;
+	unsigned long policers_usage[]; /* Usage bitmap */
+};
+
+#endif
-- 
2.24.1

