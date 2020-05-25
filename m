Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE83E1E181C
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389099AbgEYXGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44035 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388211AbgEYXG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C4E6D5C0114;
        Mon, 25 May 2020 19:06:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=pWspccMfI3CAnlIfm/svAP+mY1UoKHUcfrTm03T2w18=; b=hc4yesQ6
        c+xUSSc7hSe+mJXD/o/5NYVNbUprZmZMHICeIzegvxjqPi6SYGV4p7AWbt0xSSuk
        LTzbsB3tobeCCabWoBgtpSu2yMBNwqI7Wzg0bRbZDzdH7Cd/tltPWMU7YyLKX6XR
        sn6L+TtD+i1x8dpN6+DdEilRt3tJuwo9MOmG1prm0CTmaKhSeo9dTgav9ThdR6rc
        k37g3/b/r9ls/zLDZDDCHHBVQIeAgZQWqnuMov5Wp9uXy+tdyUT8tq8Nl/ASa53i
        ASw/bm082EudW7O0g6ULp1MEZyh3R7yKeDxk7refoAloXkBiqgGDMqJAfjgr1rhr
        6D0c1y3NNeH6Iw==
X-ME-Sender: <xms:c0_MXokynMT5UwDySh118zJ_s1Zz_385rZCdx2zq6AOZdz7u8raABw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:c0_MXn22Krgq-56hKS8wilUtYpt11M58PFsNAgA3R2Yl0g_lXWI0iw>
    <xmx:c0_MXmpZwGIHlVigq_Z2Cl5SCCxHN0eu0lUSzPLbWN7t_pY4cTwmqA>
    <xmx:c0_MXkm61nqXPutmAx4-BeULaOBfA9DSnoB5gt5rc2tB8pTrsmtAJg>
    <xmx:c0_MXr9lRZJ49KpQ1kM0_ypiTXVOo_NwtlWdurPOFnv3efsjboE7Zg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 809643280059;
        Mon, 25 May 2020 19:06:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/14] mlxsw: spectrum_trap: Do not hard code "thin" policer identifier
Date:   Tue, 26 May 2020 02:05:51 +0300
Message-Id: <20200525230556.1455927-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525230556.1455927-1-idosch@idosch.org>
References: <20200525230556.1455927-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

As explained in commit e612523041ab ("mlxsw: spectrum_trap: Introduce
dummy group with thin policer"), the purpose of the "thin" policer is to
pass as less packets as possible to the CPU.

The identifier of this policer is currently set according to the maximum
number of used trap groups, but this is fragile: On Spectrum-1 the
maximum number of policers is less than the maximum number of trap
groups, which might result in an invalid policer identifier in case the
number of used trap groups grows beyond the policer limit.

Solve this by dynamically allocating the policer identifier.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_trap.c | 17 +++++++++++------
 .../net/ethernet/mellanox/mlxsw/spectrum_trap.h |  2 ++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 78f983c1a056..f4b812276a5a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -441,8 +441,6 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 	},
 };
 
-#define MLXSW_SP_THIN_POLICER_ID	(MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1)
-
 static struct mlxsw_sp_trap_policer_item *
 mlxsw_sp_trap_policer_item_lookup(struct mlxsw_sp *mlxsw_sp, u32 id)
 {
@@ -487,14 +485,21 @@ mlxsw_sp_trap_item_lookup(struct mlxsw_sp *mlxsw_sp, u16 id)
 
 static int mlxsw_sp_trap_cpu_policers_set(struct mlxsw_sp *mlxsw_sp)
 {
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
 	char qpcr_pl[MLXSW_REG_QPCR_LEN];
+	u16 hw_id;
 
 	/* The purpose of "thin" policer is to drop as many packets
 	 * as possible. The dummy group is using it.
 	 */
-	__set_bit(MLXSW_SP_THIN_POLICER_ID, mlxsw_sp->trap->policers_usage);
-	mlxsw_reg_qpcr_pack(qpcr_pl, MLXSW_SP_THIN_POLICER_ID,
-			    MLXSW_REG_QPCR_IR_UNITS_M, false, 1, 4);
+	hw_id = find_first_zero_bit(trap->policers_usage, trap->max_policers);
+	if (WARN_ON(hw_id == trap->max_policers))
+		return -ENOBUFS;
+
+	__set_bit(hw_id, trap->policers_usage);
+	trap->thin_policer_hw_id = hw_id;
+	mlxsw_reg_qpcr_pack(qpcr_pl, hw_id, MLXSW_REG_QPCR_IR_UNITS_M,
+			    false, 1, 4);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qpcr), qpcr_pl);
 }
 
@@ -503,7 +508,7 @@ static int mlxsw_sp_trap_dummy_group_init(struct mlxsw_sp *mlxsw_sp)
 	char htgt_pl[MLXSW_REG_HTGT_LEN];
 
 	mlxsw_reg_htgt_pack(htgt_pl, MLXSW_REG_HTGT_TRAP_GROUP_SP_DUMMY,
-			    MLXSW_SP_THIN_POLICER_ID, 0, 1);
+			    mlxsw_sp->trap->thin_policer_hw_id, 0, 1);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(htgt), htgt_pl);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
index 759146897b3a..13ac412f4d53 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
@@ -17,6 +17,8 @@ struct mlxsw_sp_trap {
 	struct mlxsw_sp_trap_item *trap_items_arr;
 	u64 traps_count; /* Number of registered traps */
 
+	u16 thin_policer_hw_id;
+
 	u64 max_policers;
 	unsigned long policers_usage[]; /* Usage bitmap */
 };
-- 
2.26.2

