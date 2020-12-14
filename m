Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42E02D9766
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438049AbgLNLdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:33:06 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53939 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437982AbgLNLc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:32:57 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7AA9A5C016D;
        Mon, 14 Dec 2020 06:31:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Dec 2020 06:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=hi7bDuDMLwnabe6ysR8bvwsA52igsCru82Wo/dMRHR0=; b=jYRHykMF
        GzY3Kd6KPcdXn/bG7pXhTlkVMwfKgsVE5AHYl/Tbb1qh3akm+9mzazirGKgRHq+A
        O3LL/abJCQ7FxFHZ3hy2bhxBDnzzU9dMHqFZlGqJVJZ5TvGEX1s2WeWOnHAB4AoN
        9QKYQvNS+yhP+YFJg/uej5MjAsTdFBguOed9HognCTU2XZ+D+gcL8Vkq2pbC11K5
        6x9oiREcUYymirfLjHGitC35XTOQS/KeOkaXMU9/vZn02UNDH7UIfZo+l44REEnr
        6PvPpjoCaKbBxSo8IRC394loBNy7U4ZwORFjbfbM7oqBWgIcdryoEh/ORQgZ+Khy
        wswvOzMV8TD0BA==
X-ME-Sender: <xms:CE3XX-uGVhIbOhHjPXTi3wqdj7Ce_kiBwrXs3cT38mFMIml6zTClhw>
    <xme:CE3XXzewqP5P2OHBzeMFIF21AcnqReAxhWrf8plCBBWf-32G29n7cyy-ifDdWk3SJ
    u-wKu0SRQE3xoo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrfedu
    necuvehluhhsthgvrhfuihiivgepudegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:CE3XX5zJOBj1zZuBvLnKYyg2Z5RvoarUXEIEjK58wRA0B_P8dE-eJg>
    <xmx:CE3XX5NrA75W5ppwz6ekN-vWuurxih67ShxEH0EC3CqE00jruFbJfA>
    <xmx:CE3XX--j4tvDts1hHyXEHcYZW8257NRt7lPowekiSjQc4XcN1d3mhg>
    <xmx:CE3XXwKgXvsY-109sVbyn7Zxstdf8LADjXz99viDbM4UPOKhAZK9gg>
Received: from shredder.mtl.com (igld-84-229-152-31.inter.net.il [84.229.152.31])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4C1941080059;
        Mon, 14 Dec 2020 06:31:19 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 15/15] mlxsw: spectrum_router: Use eXtended mezzanine to offload IPv4 router
Date:   Mon, 14 Dec 2020 13:30:41 +0200
Message-Id: <20201214113041.2789043-16-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214113041.2789043-1-idosch@idosch.org>
References: <20201214113041.2789043-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In case the eXtended mezzanine is present on the system, use it for IPv4
router offload.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c    | 4 +++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h    | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c | 7 +++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 62d51b281b58..41424ee909a0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9213,7 +9213,9 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_xm_init;
 
-	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV4] = &mlxsw_sp_router_ll_basic_ops;
+	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV4] = mlxsw_sp_router_xm_ipv4_is_supported(mlxsw_sp) ?
+						       &mlxsw_sp_router_ll_xm_ops :
+						       &mlxsw_sp_router_ll_basic_ops;
 	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV6] = &mlxsw_sp_router_ll_basic_ops;
 
 	err = mlxsw_sp_router_ll_op_ctx_init(router);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 31612891ad48..2875ee8ec537 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -227,5 +227,6 @@ extern const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_xm_ops;
 
 int mlxsw_sp_router_xm_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_router_xm_fini(struct mlxsw_sp *mlxsw_sp);
+bool mlxsw_sp_router_xm_ipv4_is_supported(const struct mlxsw_sp *mlxsw_sp);
 
 #endif /* _MLXSW_ROUTER_H_*/
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
index 2f1e70e5a262..d213af723a2a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
@@ -803,3 +803,10 @@ void mlxsw_sp_router_xm_fini(struct mlxsw_sp *mlxsw_sp)
 	rhashtable_destroy(&router_xm->ltable_ht);
 	kfree(router_xm);
 }
+
+bool mlxsw_sp_router_xm_ipv4_is_supported(const struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
+
+	return router_xm && router_xm->ipv4_supported;
+}
-- 
2.29.2

