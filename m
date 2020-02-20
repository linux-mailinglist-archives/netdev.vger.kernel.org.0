Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A50165839
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgBTHIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:30 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34981 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbgBTHI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:29 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 705AF21E90;
        Thu, 20 Feb 2020 02:08:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=aOt9PswnLrzs7lGdlkFteWxqxQ7nOFWuTDmc3Bn3nsY=; b=dlj6ujrA
        weoGYuutkqf6Hz31N3zATWzP81VLPUHzZNR2Q2BNSFeZTkbQCD0QZRGjH5djI9qs
        5p04wEs8MtnCEdH/XZdDyieyZwXIevZBcyNgzb/0AbsXwwhwLsUNxljBjztxcvBe
        aB7UNipKMYzgJPJAMPc6TBkXFGwnoNE1p8ibfoW/VHorHBdpuPWLCK7kiGmVl3zN
        NQ/dBV2KYRfoI6Dlh2jBgnG+7j3wuzm8KaLeaOwgF/6jN+zBkp6DIXp5JUhOVE6F
        Ts7K+Gt9KO75/26oNEStx0MevUEO7a62f6PYXIbPhdlTPKeN+ff3M+TZUEwbQaEb
        9vw6GsEiyoprzQ==
X-ME-Sender: <xms:bDBOXgQGC7wbitpybGZyNZ4W1WSrArvFJ5sycK48aWVkTjuxkzm7uw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:bDBOXoBgupcva2O5UAwXohSgIsWq8gD3ibsLdjWZCG7056zQN3-ldg>
    <xmx:bDBOXszCUgDNtph7aXnIH6zY6sZPIRrEiJSdHU4DZ8gbUSL9lsQ0wA>
    <xmx:bDBOXrpXjxjdnokZLHnCYl-KmfdpRs4YD3jc6RvcByv11xSXq0sU4Q>
    <xmx:bDBOXsFqcX5NXQM5GiP4vTMCWVBclTV-vIdoJ-Xo_mDymQXwn3jBLg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 542613060C21;
        Thu, 20 Feb 2020 02:08:27 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/15] mlxsw: spectrum_span: Only update mirroring agents if present
Date:   Thu, 20 Feb 2020 09:07:52 +0200
Message-Id: <20200220070800.364235-8-idosch@idosch.org>
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

In order not to needlessly schedule the work item that updates the
mirroring agents, only schedule it if there are any mirroring agents
present.

This is done by adding an atomic counter that counts the active
mirroring agents.

It is incremented / decremented whenever a mirroring agent is created /
destroyed. It is read before scheduling the work item and in the
devlink-resource occupancy callback.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index f7079f9e8d19..9fb2e9d93929 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -19,6 +19,7 @@
 struct mlxsw_sp_span {
 	struct work_struct work;
 	struct mlxsw_sp *mlxsw_sp;
+	atomic_t active_entries_count;
 	int entries_count;
 	struct mlxsw_sp_span_entry entries[0];
 };
@@ -28,15 +29,8 @@ static void mlxsw_sp_span_respin_work(struct work_struct *work);
 static u64 mlxsw_sp_span_occ_get(void *priv)
 {
 	const struct mlxsw_sp *mlxsw_sp = priv;
-	u64 occ = 0;
-	int i;
 
-	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
-		if (mlxsw_sp->span->entries[i].ref_count)
-			occ++;
-	}
-
-	return occ;
+	return atomic_read(&mlxsw_sp->span->active_entries_count);
 }
 
 int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
@@ -53,6 +47,7 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 	if (!span)
 		return -ENOMEM;
 	span->entries_count = entries_count;
+	atomic_set(&span->active_entries_count, 0);
 	span->mlxsw_sp = mlxsw_sp;
 	mlxsw_sp->span = span;
 
@@ -668,6 +663,7 @@ mlxsw_sp_span_entry_create(struct mlxsw_sp *mlxsw_sp,
 	if (!span_entry)
 		return NULL;
 
+	atomic_inc(&mlxsw_sp->span->active_entries_count);
 	span_entry->ops = ops;
 	span_entry->ref_count = 1;
 	span_entry->to_dev = to_dev;
@@ -676,9 +672,11 @@ mlxsw_sp_span_entry_create(struct mlxsw_sp *mlxsw_sp,
 	return span_entry;
 }
 
-static void mlxsw_sp_span_entry_destroy(struct mlxsw_sp_span_entry *span_entry)
+static void mlxsw_sp_span_entry_destroy(struct mlxsw_sp *mlxsw_sp,
+					struct mlxsw_sp_span_entry *span_entry)
 {
 	mlxsw_sp_span_entry_deconfigure(span_entry);
+	atomic_dec(&mlxsw_sp->span->active_entries_count);
 }
 
 struct mlxsw_sp_span_entry *
@@ -740,7 +738,7 @@ static int mlxsw_sp_span_entry_put(struct mlxsw_sp *mlxsw_sp,
 {
 	WARN_ON(!span_entry->ref_count);
 	if (--span_entry->ref_count == 0)
-		mlxsw_sp_span_entry_destroy(span_entry);
+		mlxsw_sp_span_entry_destroy(mlxsw_sp, span_entry);
 	return 0;
 }
 
@@ -1033,5 +1031,7 @@ static void mlxsw_sp_span_respin_work(struct work_struct *work)
 
 void mlxsw_sp_span_respin(struct mlxsw_sp *mlxsw_sp)
 {
+	if (atomic_read(&mlxsw_sp->span->active_entries_count) == 0)
+		return;
 	mlxsw_core_schedule_work(&mlxsw_sp->span->work);
 }
-- 
2.24.1

