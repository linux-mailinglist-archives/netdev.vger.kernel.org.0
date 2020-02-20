Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D993F16582F
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgBTHI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:27 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54395 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbgBTHIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:24 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9BC742108A;
        Thu, 20 Feb 2020 02:08:23 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=UVOIZFteFw87u73yrtU6uYusqWB1/LbaqNOf+vWrDTo=; b=WC0j9SZH
        LI6wlaWPs66sSX75RCJgonvIZq13i+FD93BM4WOn5gRrVvIEztX+TLQdASS1hKs4
        969EqZIRase0THP9/Td52uUAZ6K7aJOX7zhjsAvk3ShCBlfC4m1rxbdTxBbY3yry
        EyprerxpkYxeh7nrWMZTX7Mt4UWL1Mpbvha16qs4z+AnByMCqExz1k5DmV2JuWUY
        uVDVLWjxIrn5/aAb3gT+Rnco+E6xhfKbB3WJOm4BvMzLy3d+iaf0JegMKc1s8dCI
        0wolf/eFnXt2E8zOTkbznelMej5xhK4QojtyWCyp9ctmRCgPpZpv7KtUY4nzYBVk
        /O942qAkASww2A==
X-ME-Sender: <xms:ZzBOXmgCgPMjK-ckpbsJ-mqEObmatciYq3Bc_24zPZfGpeIC0JiWEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:ZzBOXiuvMIs4sa2SC_qWP6cJ7sEygB8MCiNnjx22pF4RB9YrYSdNqg>
    <xmx:ZzBOXqg4NPeD6w66LuPgonHdI3LSAHoDA3IMiJy914trEEgTJQ8ofA>
    <xmx:ZzBOXobnIHMdI4t4Jv0puVzySU_89vYQTY_tVgfqwwtsPZWcki_iRQ>
    <xmx:ZzBOXiKL-ba-hl5XymvXPwMyQLU3ke1g6687OARmZFJh3LMCbv4w_A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 80CCD3060C28;
        Thu, 20 Feb 2020 02:08:22 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/15] mlxsw: spectrum_span: Do no expose mirroring agents to entire driver
Date:   Thu, 20 Feb 2020 09:07:48 +0200
Message-Id: <20200220070800.364235-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220070800.364235-1-idosch@idosch.org>
References: <20200220070800.364235-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The struct holding the different mirroring agents is currently allocated
as part of the main driver struct. This is unlike other driver modules.

Allocate the memory required to store the different mirroring agents as
part of the initialization of the mirroring module.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 +-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 72 ++++++++++++-------
 2 files changed, 46 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 4c3d39223a46..2f3d2f8b2377 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -168,12 +168,8 @@ struct mlxsw_sp {
 	struct notifier_block netdevice_nb;
 	struct mlxsw_sp_ptp_clock *clock;
 	struct mlxsw_sp_ptp_state *ptp_state;
-
 	struct mlxsw_sp_counter_pool *counter_pool;
-	struct {
-		struct mlxsw_sp_span_entry *entries;
-		int entries_count;
-	} span;
+	struct mlxsw_sp_span *span;
 	const struct mlxsw_fw_rev *req_rev;
 	const char *fw_filename;
 	const struct mlxsw_sp_kvdl_ops *kvdl_ops;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 0cdd7954a085..4b76f01634c1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -14,14 +14,19 @@
 #include "spectrum_span.h"
 #include "spectrum_switchdev.h"
 
+struct mlxsw_sp_span {
+	struct mlxsw_sp_span_entry *entries;
+	int entries_count;
+};
+
 static u64 mlxsw_sp_span_occ_get(void *priv)
 {
 	const struct mlxsw_sp *mlxsw_sp = priv;
 	u64 occ = 0;
 	int i;
 
-	for (i = 0; i < mlxsw_sp->span.entries_count; i++) {
-		if (mlxsw_sp->span.entries[i].ref_count)
+	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
+		if (mlxsw_sp->span->entries[i].ref_count)
 			occ++;
 	}
 
@@ -31,21 +36,29 @@ static u64 mlxsw_sp_span_occ_get(void *priv)
 int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
-	int i;
+	struct mlxsw_sp_span *span;
+	int i, err;
 
 	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_SPAN))
 		return -EIO;
 
-	mlxsw_sp->span.entries_count = MLXSW_CORE_RES_GET(mlxsw_sp->core,
-							  MAX_SPAN);
-	mlxsw_sp->span.entries = kcalloc(mlxsw_sp->span.entries_count,
-					 sizeof(struct mlxsw_sp_span_entry),
-					 GFP_KERNEL);
-	if (!mlxsw_sp->span.entries)
+	span = kzalloc(sizeof(*span), GFP_KERNEL);
+	if (!span)
 		return -ENOMEM;
+	mlxsw_sp->span = span;
+
+	mlxsw_sp->span->entries_count = MLXSW_CORE_RES_GET(mlxsw_sp->core,
+							   MAX_SPAN);
+	mlxsw_sp->span->entries = kcalloc(mlxsw_sp->span->entries_count,
+					  sizeof(struct mlxsw_sp_span_entry),
+					  GFP_KERNEL);
+	if (!mlxsw_sp->span->entries) {
+		err = -ENOMEM;
+		goto err_alloc_span_entries;
+	}
 
-	for (i = 0; i < mlxsw_sp->span.entries_count; i++) {
-		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span.entries[i];
+	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
+		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
 
 		INIT_LIST_HEAD(&curr->bound_ports_list);
 		curr->id = i;
@@ -55,6 +68,10 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 					  mlxsw_sp_span_occ_get, mlxsw_sp);
 
 	return 0;
+
+err_alloc_span_entries:
+	kfree(span);
+	return err;
 }
 
 void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
@@ -64,12 +81,13 @@ void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
 
 	devlink_resource_occ_get_unregister(devlink, MLXSW_SP_RESOURCE_SPAN);
 
-	for (i = 0; i < mlxsw_sp->span.entries_count; i++) {
-		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span.entries[i];
+	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
+		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
 
 		WARN_ON_ONCE(!list_empty(&curr->bound_ports_list));
 	}
-	kfree(mlxsw_sp->span.entries);
+	kfree(mlxsw_sp->span->entries);
+	kfree(mlxsw_sp->span);
 }
 
 static int
@@ -645,9 +663,9 @@ mlxsw_sp_span_entry_create(struct mlxsw_sp *mlxsw_sp,
 	int i;
 
 	/* find a free entry to use */
-	for (i = 0; i < mlxsw_sp->span.entries_count; i++) {
-		if (!mlxsw_sp->span.entries[i].ref_count) {
-			span_entry = &mlxsw_sp->span.entries[i];
+	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
+		if (!mlxsw_sp->span->entries[i].ref_count) {
+			span_entry = &mlxsw_sp->span->entries[i];
 			break;
 		}
 	}
@@ -673,8 +691,8 @@ mlxsw_sp_span_entry_find_by_port(struct mlxsw_sp *mlxsw_sp,
 {
 	int i;
 
-	for (i = 0; i < mlxsw_sp->span.entries_count; i++) {
-		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span.entries[i];
+	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
+		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
 
 		if (curr->ref_count && curr->to_dev == to_dev)
 			return curr;
@@ -694,8 +712,8 @@ mlxsw_sp_span_entry_find_by_id(struct mlxsw_sp *mlxsw_sp, int span_id)
 {
 	int i;
 
-	for (i = 0; i < mlxsw_sp->span.entries_count; i++) {
-		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span.entries[i];
+	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
+		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
 
 		if (curr->ref_count && curr->id == span_id)
 			return curr;
@@ -736,8 +754,8 @@ static bool mlxsw_sp_span_is_egress_mirror(struct mlxsw_sp_port *port)
 	struct mlxsw_sp_span_inspected_port *p;
 	int i;
 
-	for (i = 0; i < mlxsw_sp->span.entries_count; i++) {
-		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span.entries[i];
+	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
+		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
 
 		list_for_each_entry(p, &curr->bound_ports_list, list)
 			if (p->local_port == port->local_port &&
@@ -842,9 +860,9 @@ mlxsw_sp_span_inspected_port_add(struct mlxsw_sp_port *port,
 	 * so if a binding is requested, check for conflicts.
 	 */
 	if (bind)
-		for (i = 0; i < mlxsw_sp->span.entries_count; i++) {
+		for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
 			struct mlxsw_sp_span_entry *curr =
-				&mlxsw_sp->span.entries[i];
+				&mlxsw_sp->span->entries[i];
 
 			if (mlxsw_sp_span_entry_bound_port_find(curr, type,
 								port, bind))
@@ -994,8 +1012,8 @@ void mlxsw_sp_span_respin(struct mlxsw_sp *mlxsw_sp)
 	int err;
 
 	ASSERT_RTNL();
-	for (i = 0; i < mlxsw_sp->span.entries_count; i++) {
-		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span.entries[i];
+	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
+		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
 		struct mlxsw_sp_span_parms sparms = {NULL};
 
 		if (!curr->ref_count)
-- 
2.24.1

