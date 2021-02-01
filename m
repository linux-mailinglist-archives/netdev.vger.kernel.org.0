Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D48730B0DA
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhBATxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:53:20 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:60589 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232832AbhBATwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:52:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 99620580512;
        Mon,  1 Feb 2021 14:48:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 01 Feb 2021 14:48:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zD84T9Sw3RVG4yqvX6HApKCcETwSXu4ZVwlDkoq0KMo=; b=LF3bMYA5
        BEVS30DEmtOlykzMEmGophtZzFJ4epEhVubhBeXGoGNbLOdyrdMHyvEIKo2kud98
        ENLrys5Ooasph/6ub6mCm7/x1fi00i8sbDqnOBp+I409n0z80YIF5t1mKVSg0pU/
        FXfv19udS6E2kYSqXlBI72n9YoOqN6SxCE7ne0NP3v2YCtT62qfmFqwqoHINEBhK
        y0fGI9B293JbsCFTZw0YAQYmZR2gZ5y5gh+C/goR5FJELgEmq8TLqSFROHv3UxxL
        d8H3NdBidCJ2OlQi5x/utYHJp0aiGXZsLhEgyzIELucq4sLM0iR9K6qgVg3xXgXI
        GI5Hsp6p3LPK0g==
X-ME-Sender: <xms:KVsYYK1CSig6QqYqA0kn75XnHqogmjF1v5RxSbClWE0ddfwJTLlXFw>
    <xme:KVsYYNHt96TY5Y9XmgKj-i4vjaKX7trpRJd7vQW20zDve84Q6S_cBwppaJX7WfXV7
    6RUNoRlKMRbxP8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:KVsYYC5gRm-7Yq1hOqPB69UGwI5q4pm1d1rHDuYrBNy6Ag6braia-w>
    <xmx:KVsYYL2zq26kqWERW0OwMhDwKmuPNjKyzsH_y9PET8ApQMxjTSjvpg>
    <xmx:KVsYYNEZFzdzL5bu9U3YFhXOy3wAFrDJQZnB_SgG2AjJMMXFEgCfhw>
    <xmx:KVsYYDawJdp6v5mY4_tfxYaH434LiZQkZhsRym7PrL3TNeazLNO62g>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 59A5324005C;
        Mon,  1 Feb 2021 14:48:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, jiri@nvidia.com, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 07/10] net: Do not call fib6_info_hw_flags_set() when IPv6 is disabled
Date:   Mon,  1 Feb 2021 21:47:54 +0200
Message-Id: <20210201194757.3463461-8-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201194757.3463461-1-idosch@idosch.org>
References: <20210201194757.3463461-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

With the next patch mlxsw and netdevsim will fail in compilation if
CONFIG_IPV6 is disabled.

Do not call fib6_info_hw_flags_set() when IPv6 is disabled.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c    | 16 ++++++++++++++++
 drivers/net/netdevsim/fib.c                      |  8 ++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 5516e141f5bf..cf111e73f81e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4988,6 +4988,7 @@ mlxsw_sp_fib4_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 	fib_alias_hw_flags_set(mlxsw_sp_net(mlxsw_sp), &fri);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static void
 mlxsw_sp_fib6_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_fib_entry *fib_entry)
@@ -5007,7 +5008,15 @@ mlxsw_sp_fib6_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
 		fib6_info_hw_flags_set(mlxsw_sp_net(mlxsw_sp), mlxsw_sp_rt6->rt,
 				       should_offload, !should_offload);
 }
+#else
+static void
+mlxsw_sp_fib6_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
+				 struct mlxsw_sp_fib_entry *fib_entry)
+{
+}
+#endif
 
+#if IS_ENABLED(CONFIG_IPV6)
 static void
 mlxsw_sp_fib6_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_fib_entry *fib_entry)
@@ -5021,6 +5030,13 @@ mlxsw_sp_fib6_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 		fib6_info_hw_flags_set(mlxsw_sp_net(mlxsw_sp), mlxsw_sp_rt6->rt,
 				       false, false);
 }
+#else
+static void
+mlxsw_sp_fib6_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
+				   struct mlxsw_sp_fib_entry *fib_entry)
+{
+}
+#endif
 
 static void
 mlxsw_sp_fib_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index cb68f0cc6740..1779146926a5 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -585,6 +585,7 @@ static int nsim_fib6_rt_append(struct nsim_fib_data *data,
 	return err;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static void nsim_fib6_rt_hw_flags_set(struct nsim_fib_data *data,
 				      const struct nsim_fib6_rt *fib6_rt,
 				      bool trap)
@@ -595,6 +596,13 @@ static void nsim_fib6_rt_hw_flags_set(struct nsim_fib_data *data,
 	list_for_each_entry(fib6_rt_nh, &fib6_rt->nh_list, list)
 		fib6_info_hw_flags_set(net, fib6_rt_nh->rt, false, trap);
 }
+#else
+static void nsim_fib6_rt_hw_flags_set(struct nsim_fib_data *data,
+				      const struct nsim_fib6_rt *fib6_rt,
+				      bool trap)
+{
+}
+#endif
 
 static int nsim_fib6_rt_add(struct nsim_fib_data *data,
 			    struct nsim_fib6_rt *fib6_rt)
-- 
2.29.2

