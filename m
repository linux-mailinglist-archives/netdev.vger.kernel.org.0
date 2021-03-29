Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6571A34CDB0
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 12:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhC2KKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 06:10:48 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59247 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232582AbhC2KK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 06:10:28 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6DD815C00DF;
        Mon, 29 Mar 2021 06:10:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 06:10:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=7HS8wA+wZEaJcKL1vqVt3lb4b0TSSRq+KtW8KYHbCkw=; b=BKOcfQys
        bKRO8XT0P6yx8wiqdN8pnjzkXqgxfSIMysgVfLNQjiqaChqP3cmqFs6PM/RVk6EG
        A1P345pW2LWS7xvLaiX38g0pkwjDIfr4kWuPZpWih4JmN2uJ1TcsZdH3QmSu5Ua6
        wsliOPjNqYkxuvZcHou8FbNRQGizxQhZYPDR3sRnV2vBz7adJGE6bNLr9UZQjJuT
        3oCM+K9LcXNykGtTanYNiZ72uitrRR1uw9PSH8PPmS5/Q2lq/Wuhtk0fCtjPx7LA
        +OFPPEG9AbDKUm+uw1nBNzP4QDQPsMcOSXaYOnhdydEO9/WESP+BZBcrZG888/8R
        KtII2mLpGetADg==
X-ME-Sender: <xms:lKdhYINarNHJ56ccANMnNwCkwjAr6G934jE4tNpHCEHQ2wuPw7ZbbQ>
    <xme:lKdhYO9XbnIUpLWx1Urud1hOBIzx3ZIbG7cxVfPUI9u6CBatPaOH9fnxhuXHlMZpq
    x9-LoSfgUey8To>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:lKdhYPSCsCUw13SFzjqvP2Ew6NMngV00u9xReyGpu2fBhcjRxOCEuw>
    <xmx:lKdhYAtmojdz8IsA-lz_sr2eUkDy_5AlIOd79v_zJreVmJ6YXiXX8g>
    <xmx:lKdhYAcZO3CheeRxxku2-o3CxT5viWxSHtaDq0_rYeMt4PwIZJmRoA>
    <xmx:lKdhYBqg99-CVS8AoJH6ph17vTHsZnDPaCXFgwL6Vk-zqDqfJgzSXg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id C66AB240054;
        Mon, 29 Mar 2021 06:10:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/6] mlxsw: spectrum_matchall: Perform priority checks earlier
Date:   Mon, 29 Mar 2021 13:09:45 +0300
Message-Id: <20210329100948.355486-4-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329100948.355486-1-idosch@idosch.org>
References: <20210329100948.355486-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Perform the priority check earlier in the function instead of repeating
it for every action. This fixes a bug that allowed matchall rules with
sample action to be added in front of flower rules on egress.

Fixes: 54d0e963f683 ("mlxsw: spectrum_matchall: Add support for egress sampling")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_matchall.c        | 31 ++++++++-----------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index af0a20581a37..07b371cd9818 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -250,32 +250,27 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
 	mall_entry->priority = f->common.prio;
 	mall_entry->ingress = mlxsw_sp_flow_block_is_ingress_bound(block);
 
+	if (flower_prio_valid && mall_entry->ingress &&
+	    mall_entry->priority >= flower_min_prio) {
+		NL_SET_ERR_MSG(f->common.extack, "Failed to add behind existing flower rules");
+		err = -EOPNOTSUPP;
+		goto errout;
+	}
+	if (flower_prio_valid && !mall_entry->ingress &&
+	    mall_entry->priority <= flower_max_prio) {
+		NL_SET_ERR_MSG(f->common.extack, "Failed to add in front of existing flower rules");
+		err = -EOPNOTSUPP;
+		goto errout;
+	}
+
 	act = &f->rule->action.entries[0];
 
 	switch (act->id) {
 	case FLOW_ACTION_MIRRED:
-		if (flower_prio_valid && mall_entry->ingress &&
-		    mall_entry->priority >= flower_min_prio) {
-			NL_SET_ERR_MSG(f->common.extack, "Failed to add behind existing flower rules");
-			err = -EOPNOTSUPP;
-			goto errout;
-		}
-		if (flower_prio_valid && !mall_entry->ingress &&
-		    mall_entry->priority <= flower_max_prio) {
-			NL_SET_ERR_MSG(f->common.extack, "Failed to add in front of existing flower rules");
-			err = -EOPNOTSUPP;
-			goto errout;
-		}
 		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_MIRROR;
 		mall_entry->mirror.to_dev = act->dev;
 		break;
 	case FLOW_ACTION_SAMPLE:
-		if (flower_prio_valid &&
-		    mall_entry->priority >= flower_min_prio) {
-			NL_SET_ERR_MSG(f->common.extack, "Failed to add behind existing flower rules");
-			err = -EOPNOTSUPP;
-			goto errout;
-		}
 		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_SAMPLE;
 		mall_entry->sample.params.psample_group = act->sample.psample_group;
 		mall_entry->sample.params.truncate = act->sample.truncate;
-- 
2.30.2

