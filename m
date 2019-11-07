Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A15CF34DB
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389622AbfKGQnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:43:25 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60977 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389610AbfKGQnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:43:24 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3CC2F21C24;
        Thu,  7 Nov 2019 11:43:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Nov 2019 11:43:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=eEkNWdgaIo8DG3JTJCf+RI7M9cVMEmTH57wukhe4adM=; b=YgLBvo3I
        rKQslR5keCZSdr/YIrVEhCU70vEc4yWYmbXdRJ0Ozk6DslJrFNIb3CvoV+J95Huj
        SEdC/j6e7+KMS6IQLMjQ542q70hWDexJg8lpwnbw7/Xjvn1W6bCCVcVGlOyhINGh
        cPdv58quKKxkm7BJy64nk4Ryi8rI5JmTtadxvmd6NClCC10JOeoEeQY56Mv5QRZ1
        Dmm5cp4gfmfJDxBbdpijM8lTslWOOoQ4LIG5JCZQtlBezFZmtqdXTKQ61EhgotkI
        vs2lcM+i5xb+0RSpnOaKp61mTduRFmLFyJ/AxDoNPvzqXrbERmFFLh4k5Lkk+RPM
        3OLTgKG2hQo/bw==
X-ME-Sender: <xms:q0nEXZfW-qQl7izznNqpTqNi6veddYj7faQLYNxzKbx1EMAbHTCfiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:q0nEXRdBvvxhYOil-BTSqx9s23yXXkLA0ZcHpc9fxdnyPLrVeBLKbg>
    <xmx:q0nEXRcN9Xs9VCNo6xhcHZBqCgEv-bqDzPG8WA6umKIDWQCzkN9cDA>
    <xmx:q0nEXalbjBLs58FTGFwSer-DMG7dLP_ueqViCc4E55Z-Ezx-5E9caw>
    <xmx:q0nEXUJH0jRPh7tQNbcow3fEWV98uEw4Ge6IxBnz9RgNiwpiDCovRg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A37F880059;
        Thu,  7 Nov 2019 11:43:21 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/12] mlxsw: Add new FIB entry type for reject routes
Date:   Thu,  7 Nov 2019 18:42:15 +0200
Message-Id: <20191107164220.20526-8-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107164220.20526-1-idosch@idosch.org>
References: <20191107164220.20526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Currently, packets that cannot be routed in hardware (e.g., nexthop
device is not upper of mlxsw), are trapped to the kernel for forwarding.
Such packets are trapped using "RTR_INGRESS0" trap. This trap also traps
packets that hit reject routes (e.g., "unreachable") so that the kernel
will generate the appropriate ICMP error message for them.

Subsequent patch will need to only report to devlink packets that hit a
reject route, which is impossible as long as "RTR_INGRESS0" is
overloaded like that.

Solve this by using "RTR_INGRESS1" trap for packets that hit reject
routes.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 25 +++++++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  1 +
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ea4cc2aa99e0..f41d712a3958 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4513,6 +4513,7 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(MTUERROR, TRAP_TO_CPU, ROUTER_EXP, false),
 	MLXSW_SP_RXL_MARK(TTLERROR, TRAP_TO_CPU, ROUTER_EXP, false),
 	MLXSW_SP_RXL_L3_MARK(LBERROR, MIRROR_TO_CPU, LBERROR, false),
+	MLXSW_SP_RXL_MARK(RTR_INGRESS1, TRAP_TO_CPU, REMOTE_ROUTE, false),
 	MLXSW_SP_RXL_MARK(IP2ME, TRAP_TO_CPU, IP2ME, false),
 	MLXSW_SP_RXL_MARK(IPV6_UNSPECIFIED_ADDRESS, TRAP_TO_CPU, ROUTER_EXP,
 			  false),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 0e99b64450ca..39c573b39faf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -367,6 +367,7 @@ enum mlxsw_sp_fib_entry_type {
 	MLXSW_SP_FIB_ENTRY_TYPE_LOCAL,
 	MLXSW_SP_FIB_ENTRY_TYPE_TRAP,
 	MLXSW_SP_FIB_ENTRY_TYPE_BLACKHOLE,
+	MLXSW_SP_FIB_ENTRY_TYPE_UNREACHABLE,
 
 	/* This is a special case of local delivery, where a packet should be
 	 * decapsulated on reception. Note that there is no corresponding ENCAP,
@@ -4273,6 +4274,23 @@ static int mlxsw_sp_fib_entry_op_blackhole(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
 }
 
+static int
+mlxsw_sp_fib_entry_op_unreachable(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_fib_entry *fib_entry,
+				  enum mlxsw_reg_ralue_op op)
+{
+	enum mlxsw_reg_ralue_trap_action trap_action;
+	char ralue_pl[MLXSW_REG_RALUE_LEN];
+	u16 trap_id;
+
+	trap_action = MLXSW_REG_RALUE_TRAP_ACTION_TRAP;
+	trap_id = MLXSW_TRAP_ID_RTR_INGRESS1;
+
+	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_reg_ralue_act_local_pack(ralue_pl, trap_action, trap_id, 0);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
+}
+
 static int
 mlxsw_sp_fib_entry_op_ipip_decap(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_fib_entry *fib_entry,
@@ -4314,6 +4332,9 @@ static int __mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
 		return mlxsw_sp_fib_entry_op_trap(mlxsw_sp, fib_entry, op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_BLACKHOLE:
 		return mlxsw_sp_fib_entry_op_blackhole(mlxsw_sp, fib_entry, op);
+	case MLXSW_SP_FIB_ENTRY_TYPE_UNREACHABLE:
+		return mlxsw_sp_fib_entry_op_unreachable(mlxsw_sp, fib_entry,
+							 op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_IPIP_DECAP:
 		return mlxsw_sp_fib_entry_op_ipip_decap(mlxsw_sp,
 							fib_entry, op);
@@ -4391,7 +4412,7 @@ mlxsw_sp_fib4_entry_type_set(struct mlxsw_sp *mlxsw_sp,
 		 * can do so with a lower priority than packets directed
 		 * at the host, so use action type local instead of trap.
 		 */
-		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_LOCAL;
+		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_UNREACHABLE;
 		return 0;
 	case RTN_UNICAST:
 		if (mlxsw_sp_fi_is_gateway(mlxsw_sp, fi))
@@ -5351,7 +5372,7 @@ static void mlxsw_sp_fib6_entry_type_set(struct mlxsw_sp *mlxsw_sp,
 	else if (rt->fib6_type == RTN_BLACKHOLE)
 		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_BLACKHOLE;
 	else if (rt->fib6_flags & RTF_REJECT)
-		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_LOCAL;
+		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_UNREACHABLE;
 	else if (mlxsw_sp_rt6_is_gateway(mlxsw_sp, rt))
 		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_REMOTE;
 	else
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index a4969982fce1..b7d83c67491f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -49,6 +49,7 @@ enum {
 	MLXSW_TRAP_ID_IPV6_DHCP = 0x69,
 	MLXSW_TRAP_ID_IPV6_ALL_ROUTERS_LINK = 0x6F,
 	MLXSW_TRAP_ID_RTR_INGRESS0 = 0x70,
+	MLXSW_TRAP_ID_RTR_INGRESS1 = 0x71,
 	MLXSW_TRAP_ID_IPV6_PIM = 0x79,
 	MLXSW_TRAP_ID_IPV6_VRRP = 0x7A,
 	MLXSW_TRAP_ID_IPV4_BGP = 0x88,
-- 
2.21.0

