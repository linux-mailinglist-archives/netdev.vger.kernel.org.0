Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F37C5AECC
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfF3GF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:05:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56625 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbfF3GFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:05:55 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E3792210DC;
        Sun, 30 Jun 2019 02:05:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 Jun 2019 02:05:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Qp25C1y01PHacXD2awWVzhxKMJP9Klu9hmzfn/H5f8g=; b=giZ/TA7D
        2Phy05yUl19b0bkiL4/BEz3onX7ZJzcG0EkoNyYyzRseEFkXSckxrUaQyFP3DXOf
        bouOSy7HlRS1dfAGao9IAhALF91dwvEokaVuMkLRPefwFxYBvxFEQPuo/gVpQ57c
        jHr/CP99XWT8MSfM6pLqbNkEDxsLS1bc4VMnxa5F3rAdtwhAro29g2fZZH+2+4gQ
        uB9LTBFB0pzu17Lkgfe/4uE0N/wzhbnBZycFPl5vNk8XyaLJgUdof3CLppL/zdbB
        h535XFz00UKw7WrX38FZ2PnFHprr/FWQ+TrHk3Vt+sNzSg5gFzzOGYss3b/2DBvx
        lotHq+sTTkKZKA==
X-ME-Sender: <xms:QlEYXZvN4-VzSXuENGxMmtlqaa1VjPhKkF2j7KyiTbIzI3CQfOt9Zw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdefgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:QlEYXWvCwCJMxkooxSvF3Kd3CA6KrLpivWVDA1JlQupRESSKE6QrBA>
    <xmx:QlEYXXzWDcGSaCUjalr2lp0p5TT7dI_R7CQbrrlC4D4cXA83qeDeiw>
    <xmx:QlEYXUjE5vIEbDWvVgB5bADM9xZmOBQ0fQmwcxJx5naCH3JeJdTIQw>
    <xmx:QlEYXd_-oITBXi5L3aHIYlqhWcbZ5xcAySap4Ik0T4-Gyx5HEXbYTA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 87F298005A;
        Sun, 30 Jun 2019 02:05:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 05/16] mlxsw: spectrum: Extract a helper for trap registration
Date:   Sun, 30 Jun 2019 09:04:49 +0300
Message-Id: <20190630060500.7882-6-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190630060500.7882-1-idosch@idosch.org>
References: <20190630060500.7882-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

On Spectrum-1, timestamps for PTP packets are delivered through queues
of ingress and egress timestamps. There are two event traps
corresponding to activity on each of those queues. This mechanism is
absent on Spectrum-2, and therefore the traps should only be registered
on Spectrum-1.

Extract out of mlxsw_sp_traps_init() a generic helper,
mlxsw_sp_traps_register(), and likewise with _unregister(). The new helpers
will later be called with Spectrum-1-specific traps.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 48 +++++++++++++------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3e8593824b33..0119efe0ea7a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4251,22 +4251,16 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 	return 0;
 }
 
-static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
+static int mlxsw_sp_traps_register(struct mlxsw_sp *mlxsw_sp,
+				   const struct mlxsw_listener listeners[],
+				   size_t listeners_count)
 {
 	int i;
 	int err;
 
-	err = mlxsw_sp_cpu_policers_set(mlxsw_sp->core);
-	if (err)
-		return err;
-
-	err = mlxsw_sp_trap_groups_set(mlxsw_sp->core);
-	if (err)
-		return err;
-
-	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_listener); i++) {
+	for (i = 0; i < listeners_count; i++) {
 		err = mlxsw_core_trap_register(mlxsw_sp->core,
-					       &mlxsw_sp_listener[i],
+					       &listeners[i],
 					       mlxsw_sp);
 		if (err)
 			goto err_listener_register;
@@ -4277,23 +4271,47 @@ static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
 err_listener_register:
 	for (i--; i >= 0; i--) {
 		mlxsw_core_trap_unregister(mlxsw_sp->core,
-					   &mlxsw_sp_listener[i],
+					   &listeners[i],
 					   mlxsw_sp);
 	}
 	return err;
 }
 
-static void mlxsw_sp_traps_fini(struct mlxsw_sp *mlxsw_sp)
+static void mlxsw_sp_traps_unregister(struct mlxsw_sp *mlxsw_sp,
+				      const struct mlxsw_listener listeners[],
+				      size_t listeners_count)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_listener); i++) {
+	for (i = 0; i < listeners_count; i++) {
 		mlxsw_core_trap_unregister(mlxsw_sp->core,
-					   &mlxsw_sp_listener[i],
+					   &listeners[i],
 					   mlxsw_sp);
 	}
 }
 
+static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
+{
+	int err;
+
+	err = mlxsw_sp_cpu_policers_set(mlxsw_sp->core);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_trap_groups_set(mlxsw_sp->core);
+	if (err)
+		return err;
+
+	return mlxsw_sp_traps_register(mlxsw_sp, mlxsw_sp_listener,
+				       ARRAY_SIZE(mlxsw_sp_listener));
+}
+
+static void mlxsw_sp_traps_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_sp_traps_unregister(mlxsw_sp, mlxsw_sp_listener,
+				  ARRAY_SIZE(mlxsw_sp_listener));
+}
+
 #define MLXSW_SP_LAG_SEED_INIT 0xcafecafe
 
 static int mlxsw_sp_lag_init(struct mlxsw_sp *mlxsw_sp)
-- 
2.20.1

