Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BDC583E5
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfF0Nxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:53:50 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50183 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbfF0Nxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:53:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2CA11221AD;
        Thu, 27 Jun 2019 09:53:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Jun 2019 09:53:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Qp25C1y01PHacXD2awWVzhxKMJP9Klu9hmzfn/H5f8g=; b=uA2673Hd
        qGJIu6QqqsvSYL7x7D163alVjpEcVXAicU3nCquB7cSgc0HgQvR1q4OVPVlLqgxd
        V7pMnq63ySftBq59yhrTOW0Zofi6XXeglPxkZV+YCe4VsPWvmCs0A0tDCrd/lHJD
        reHSTahq9+9S506fOYtFbMT6Bn1xfYY0G0SBhefDzt8XX8Y/ZDKXRWJHBrGmSq1e
        S/NMw1lV+CPT/gSEiYETvT66bC5o+ZQwufJ1qAVSzyUrH2LC0ZaPstiz14iOi2Cv
        VMPFwdvxR1mIbTGUIR1OsDEQNooawHZ5CuRKDYdIRlUI2j9ujGSOdVOlrsSjBuQw
        It3z9ktoOQFb9g==
X-ME-Sender: <xms:a8oUXdY9avHR9teqU-Eysb7v6QknfPLasJp1LahIV7r2Q2iXtIBijg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepge
X-ME-Proxy: <xmx:bMoUXbZYQTY9G9Iug3LnUhIJIT52qUitQx6iO7Hm8DpCKpGCyy4W4Q>
    <xmx:bMoUXU9XONkBCtgY8mdux2uQdnC4G1QpnQxeH-6CmJaFzo1gk0r5Mg>
    <xmx:bMoUXag0YvPkuxU8eTg3GIiN5eU0LWzNgpenaDalGdunoKtgDp2jKw>
    <xmx:bMoUXQ8iq65RNxiM01vZcBShciiLfHXZEL6VirbSWDd5Lk-n6ZxzMg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C22E38006A;
        Thu, 27 Jun 2019 09:53:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/16] mlxsw: spectrum: Extract a helper for trap registration
Date:   Thu, 27 Jun 2019 16:52:48 +0300
Message-Id: <20190627135259.7292-6-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627135259.7292-1-idosch@idosch.org>
References: <20190627135259.7292-1-idosch@idosch.org>
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

