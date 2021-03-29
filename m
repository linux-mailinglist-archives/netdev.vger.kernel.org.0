Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7623E34CDAE
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 12:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhC2KKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 06:10:43 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53035 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231784AbhC2KKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 06:10:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 14E9F5C00D5;
        Mon, 29 Mar 2021 06:10:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 06:10:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=AlTV5o5Iq/ndcjIU9F/bHZlVlJZ3RW+thjk3/mVft1o=; b=oZM4XEtX
        d0LNBPRU2rzlezjUj4Mg2w5mArxamQECjtwSbC7THMWUH0vsVOAhnjdjELVrM2+f
        m2ADntF3OWxzGy0EqyiQDyJ/vU7XXwEYhg/aL+dDBLH59eIdHMed1KMG69UWL5g0
        GHaw2XNqrr0flTaRnGpNh0wmenrvpuFoR7KlKX2+gzqGSIf9e8njZ3OErNHnCGZB
        VqawkDwITLQXCyckCCSajJa7XTxshCMLWeoDvfG4GPKt4EPKXxrqpmZaWR5ZXHIf
        x+guEXSeKPnQZUwOfGDFliY3bL0zp40biznj5P/OTQz1uCxARUBpz7kCoOJdQvc3
        Bmy55QGQBWDc2g==
X-ME-Sender: <xms:kKdhYK-vhSkOaz7iTgllKvHnusSvc7RS00SFd_lmGTW2FyX7Xpr-4w>
    <xme:kKdhYKsjDcnVYsGsf2LAVWpdomDeft6qkzTbMniYLIDNgznJBmJZN3DqiE5RJpy8f
    r6U8VUWoT6XbTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:kKdhYAAqqIuJVU_vjyIppdrflBbfkkbwt2M1sU9KoKrMLvhVIecxjw>
    <xmx:kKdhYCdOOYlXICKrzksQ10n8nGkgdN7LPJof2u6yPllfPGk1RUxIVg>
    <xmx:kKdhYPMU1QO3tG-gEa-UPrRqt41yRAnSdwyvPOhmvCKBJnhVUnSR0A>
    <xmx:kadhYIatZIeMkEeyP4CAZERQzseHQ_isEgh0609avVThftMQGRM4Rg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6149A24005B;
        Mon, 29 Mar 2021 06:10:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/6] mlxsw: spectrum_matchall: Perform protocol check earlier
Date:   Mon, 29 Mar 2021 13:09:43 +0300
Message-Id: <20210329100948.355486-2-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329100948.355486-1-idosch@idosch.org>
References: <20210329100948.355486-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Perform the protocol check earlier in the function instead of repeating
it for every action. Example:

 # tc filter add dev swp1 ingress proto ip matchall skip_sw action sample group 1 rate 100
 Error: matchall rules only supported with 'all' protocol.
 We have an error talking to the kernel

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_matchall.c    | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index ce58a795c6fc..9252e23fd082 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -238,6 +238,11 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
 		flower_prio_valid = true;
 	}
 
+	if (protocol != htons(ETH_P_ALL)) {
+		NL_SET_ERR_MSG(f->common.extack, "matchall rules only supported with 'all' protocol");
+		return -EOPNOTSUPP;
+	}
+
 	mall_entry = kzalloc(sizeof(*mall_entry), GFP_KERNEL);
 	if (!mall_entry)
 		return -ENOMEM;
@@ -247,7 +252,7 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
 
 	act = &f->rule->action.entries[0];
 
-	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {
+	if (act->id == FLOW_ACTION_MIRRED) {
 		if (flower_prio_valid && mall_entry->ingress &&
 		    mall_entry->priority >= flower_min_prio) {
 			NL_SET_ERR_MSG(f->common.extack, "Failed to add behind existing flower rules");
@@ -262,8 +267,7 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
 		}
 		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_MIRROR;
 		mall_entry->mirror.to_dev = act->dev;
-	} else if (act->id == FLOW_ACTION_SAMPLE &&
-		   protocol == htons(ETH_P_ALL)) {
+	} else if (act->id == FLOW_ACTION_SAMPLE) {
 		if (flower_prio_valid &&
 		    mall_entry->priority >= flower_min_prio) {
 			NL_SET_ERR_MSG(f->common.extack, "Failed to add behind existing flower rules");
-- 
2.30.2

