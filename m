Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA074189D4E
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgCRNts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:49:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38351 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727092AbgCRNts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:49:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9D6185C0271;
        Wed, 18 Mar 2020 09:49:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 18 Mar 2020 09:49:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=RVReEaxVzm/Srjq+8LrC7M6OuVGrAOYIpsOGdLM+Wf8=; b=lZcGB/Jm
        wELxfbQOGaSEByE3Cqn2Ka8vD7oJ1nyZ+7ndcxzCF/Zmfff4BBCbawDwLhTVYZkO
        RvNFRGTD8Td+um6fzaB0zeoa2GPJCrI9EuqllVX4+dSC5k0EFOcvYR/Ir41YFDmo
        snJRpbLATLuOjm4mySkQWRVdtmjY30HQT+N09jwYR59/KtLKtnrBH35mUovOtNRK
        rRUdEKNyk05885QMiHMYo96XXN68KL3qc29AeEAZQZikdvqI9nTo3qwvCbYb+/57
        9+zy7INM1CNClYDJOLDeLIxvBIMbiseg0rvGaTBdTS2Dmq+5BSIHito4FgxLpFc5
        srIn1XrGgn7R8Q==
X-ME-Sender: <xms:-iZyXp0nwGabETtkmXmte3QIGCYeDaIE7Z9_w4-nb0JvO6MA-FjMAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefjedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekfedrkedrudekudenucevlhhushhtvghruf
    hiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:-iZyXrPcCoVBd5xrvCulV3m9oF09hj2JRbb6GcsRWnv13OTUJPxQmA>
    <xmx:-iZyXkP6YO6RkkXzJfq5u7piRDKbFXjb1-TXz7oqOGd-jkU25c404w>
    <xmx:-iZyXja4rw5BH38PTy0p67vM1p86ZtTUD9tY6LoPmbTbZWtjErwwIw>
    <xmx:-iZyXm4eiUj7dgsslSJhWY4cyY0EVSkzk_FkdCcgqMBqP-B0Ybp-Wg>
Received: from splinter.mtl.com (bzq-79-183-8-181.red.bezeqint.net [79.183.8.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6F06130618C1;
        Wed, 18 Mar 2020 09:49:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/9] mlxsw: spectrum_cnt: Add entry_size_res_id for each subpool and use it to query entry size
Date:   Wed, 18 Mar 2020 15:48:52 +0200
Message-Id: <20200318134857.1003018-5-idosch@idosch.org>
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

Add new field to subpool struct that would indicate which
resource id should be used to query the entry size for
the subpool from the device.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_cnt.c    | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
index 4cdabde47dd0..ef2c6c5c8b72 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
@@ -10,6 +10,7 @@
 struct mlxsw_sp_counter_sub_pool {
 	unsigned int base_index;
 	unsigned int size;
+	enum mlxsw_res_id entry_size_res_id;
 	unsigned int entry_size;
 	unsigned int bank_count;
 };
@@ -24,9 +25,11 @@ struct mlxsw_sp_counter_pool {
 
 static const struct mlxsw_sp_counter_sub_pool mlxsw_sp_counter_sub_pools[] = {
 	[MLXSW_SP_COUNTER_SUB_POOL_FLOW] = {
+		.entry_size_res_id = MLXSW_RES_ID_COUNTER_SIZE_PACKETS_BYTES,
 		.bank_count = 6,
 	},
 	[MLXSW_SP_COUNTER_SUB_POOL_RIF] = {
+		.entry_size_res_id = MLXSW_RES_ID_COUNTER_SIZE_ROUTER_BASIC,
 		.bank_count = 2,
 	}
 };
@@ -53,19 +56,18 @@ static int mlxsw_sp_counter_sub_pools_prepare(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_counter_pool *pool = mlxsw_sp->counter_pool;
 	struct mlxsw_sp_counter_sub_pool *sub_pool;
+	enum mlxsw_res_id res_id;
+	int i;
 
-	/* Prepare generic flow pool*/
-	sub_pool = &pool->sub_pools[MLXSW_SP_COUNTER_SUB_POOL_FLOW];
-	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, COUNTER_SIZE_PACKETS_BYTES))
-		return -EIO;
-	sub_pool->entry_size = MLXSW_CORE_RES_GET(mlxsw_sp->core,
-						  COUNTER_SIZE_PACKETS_BYTES);
-	/* Prepare erif pool*/
-	sub_pool = &pool->sub_pools[MLXSW_SP_COUNTER_SUB_POOL_RIF];
-	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, COUNTER_SIZE_ROUTER_BASIC))
-		return -EIO;
-	sub_pool->entry_size = MLXSW_CORE_RES_GET(mlxsw_sp->core,
-						  COUNTER_SIZE_ROUTER_BASIC);
+	for (i = 0; i < pool->sub_pools_count; i++) {
+		sub_pool = &pool->sub_pools[i];
+		res_id = sub_pool->entry_size_res_id;
+
+		if (!mlxsw_core_res_valid(mlxsw_sp->core, res_id))
+			return -EIO;
+		sub_pool->entry_size = mlxsw_core_res_get(mlxsw_sp->core,
+							  res_id);
+	}
 	return 0;
 }
 
-- 
2.24.1

