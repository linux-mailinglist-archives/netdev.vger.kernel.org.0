Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC758189D50
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgCRNtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:49:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45927 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727092AbgCRNtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:49:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A01535C019D;
        Wed, 18 Mar 2020 09:49:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 18 Mar 2020 09:49:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=mDhsdPzBOrHrdhBgDSBboLyXYkWtWsdwow0IYiPDV1Y=; b=D602Pht8
        fU/qobvGkHULlgVm7VgCDied7+VsLD8f2WCghYP+a/YED3Z0zyX5FNKB5jNQsF4B
        69AaXSrhP+5qUHSaDOmVmvBbTorgJZ7SKkvFpuJ6MmOErrLPElbOB0Q/Yw8CwK67
        SIuwy5luFak0mJSbbNt4rQ3lO4kvfA8xksqCAF4wDhIvHO6hG/ksOuFmdVuhdhtT
        VrQoVQQdj79D75Q1eiii0OQTAcjY8zstOhiT4GM/DcmtbxumeHtVshqUlsXBxz6G
        FI1AxybIT8kezvmF93RULBrtgF72oQnL2EcogMGwhf7lyoQ8u2WW2JfmnIWOypAC
        I763XepxPR9ikQ==
X-ME-Sender: <xms:_SZyXtE9kBXgpiSz_FlhXj4d8xmPSYWl-yHHWv4yl5rb3d3mwNGxKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefjedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekfedrkedrudekudenucevlhhushhtvghruf
    hiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:_SZyXowaCBCvmybYckwZFfGCbfUxrh16Xs73eRUhxvPgevqayG0etA>
    <xmx:_SZyXn9MjMqyXtjFNYU0Oo4xR-apKIUQRAEVRlnQAbseN7sqh1H-rQ>
    <xmx:_SZyXiWgOmIoHzpS8VFPMh7Nzq3AgtFHr46fCSa4htSpOEBTCVd6UQ>
    <xmx:_SZyXlG1-_DpBbL7oFC6EjTkMRSmIuQCP8iXGBlOENcatV8jEPZkNw>
Received: from splinter.mtl.com (bzq-79-183-8-181.red.bezeqint.net [79.183.8.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 500CA30618C1;
        Wed, 18 Mar 2020 09:49:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/9] mlxsw: spectrum_cnt: Move config validation along with resource register
Date:   Wed, 18 Mar 2020 15:48:54 +0200
Message-Id: <20200318134857.1003018-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318134857.1003018-1-idosch@idosch.org>
References: <20200318134857.1003018-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Move the validation of subpools configuration, to avoid possible over
commitment to resource registration. Add WARN_ON to indicate bug
in the code.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_cnt.c    | 31 +++++--------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
index 629355cf52a9..d36904143b10 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
@@ -40,24 +40,6 @@ static const struct mlxsw_sp_counter_sub_pool mlxsw_sp_counter_sub_pools[] = {
 	}
 };
 
-static int mlxsw_sp_counter_pool_validate(struct mlxsw_sp *mlxsw_sp)
-{
-	struct mlxsw_sp_counter_pool *pool = mlxsw_sp->counter_pool;
-	unsigned int total_bank_config = 0;
-	unsigned int pool_size;
-	unsigned int bank_size;
-	int i;
-
-	pool_size = MLXSW_CORE_RES_GET(mlxsw_sp->core, COUNTER_POOL_SIZE);
-	bank_size = MLXSW_CORE_RES_GET(mlxsw_sp->core, COUNTER_BANK_SIZE);
-	/* Check config is valid, no bank over subscription */
-	for (i = 0; i < pool->sub_pools_count; i++)
-		total_bank_config += pool->sub_pools[i].bank_count;
-	if (total_bank_config > pool_size / bank_size + 1)
-		return -EINVAL;
-	return 0;
-}
-
 static int mlxsw_sp_counter_sub_pools_prepare(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_counter_pool *pool = mlxsw_sp->counter_pool;
@@ -98,10 +80,6 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	pool->sub_pools_count = sub_pools_count;
 	spin_lock_init(&pool->counter_pool_lock);
 
-	err = mlxsw_sp_counter_pool_validate(mlxsw_sp);
-	if (err)
-		goto err_pool_validate;
-
 	err = mlxsw_sp_counter_sub_pools_prepare(mlxsw_sp);
 	if (err)
 		goto err_sub_pools_prepare;
@@ -140,7 +118,6 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 err_usage_alloc:
 err_pool_resource_size_get:
 err_sub_pools_prepare:
-err_pool_validate:
 	kfree(pool);
 	return err;
 }
@@ -216,6 +193,7 @@ int mlxsw_sp_counter_resources_register(struct mlxsw_core *mlxsw_core)
 	static struct devlink_resource_size_params size_params;
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 	const struct mlxsw_sp_counter_sub_pool *sub_pool;
+	unsigned int total_bank_config;
 	u64 sub_pool_size;
 	u64 base_index;
 	u64 pool_size;
@@ -245,6 +223,7 @@ int mlxsw_sp_counter_resources_register(struct mlxsw_core *mlxsw_core)
 	/* Allocation is based on bank count which should be
 	 * specified for each sub pool statically.
 	 */
+	total_bank_config = 0;
 	base_index = 0;
 	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_counter_sub_pools); i++) {
 		sub_pool = &mlxsw_sp_counter_sub_pools[i];
@@ -265,6 +244,12 @@ int mlxsw_sp_counter_resources_register(struct mlxsw_core *mlxsw_core)
 						&size_params);
 		if (err)
 			return err;
+		total_bank_config += sub_pool->bank_count;
 	}
+
+	/* Check config is valid, no bank over subscription */
+	if (WARN_ON(total_bank_config > pool_size / bank_size + 1))
+		return -EINVAL;
+
 	return 0;
 }
-- 
2.24.1

