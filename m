Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854ED1CC460
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 22:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgEIUGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 16:06:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36591 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728693AbgEIUGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 16:06:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3DA1A5C00CC;
        Sat,  9 May 2020 16:06:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 09 May 2020 16:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ble1gxihxTN/HdMNLpaljkU+86bYKoFJUEC+SNNWhR0=; b=v+1wGSjL
        eWoEoePUERRd7SUY8c83ruLB8mT5BNNef3RHsa6FKNw3NAVTy/7nc80kyWkHfpGj
        YF0+8GiknP3CfDhkBGAL9XgQrd7F0O7Z3WQlQyA67ymMJ0jPF+yHcY8OJBUqU0Me
        xm4Qde9yDrwFCK3PrgjkJMIC+bc273EV+Xwo/jRnzFPlIrJMn1eXa65OuKmn6J4u
        JSjPj9nwtZRcWJLmDCeqg+SQfaw6OEU+kbaOT6zkjyaENQp3n0tkykivb5KqmL22
        +5Jnq+bYgWOltdKnZlh6Nos+M8jZn/Hd2VbcKUTMJzLvEe9P6FUUtGGz0kDlvEnI
        VjfMacoqlt+1aA==
X-ME-Sender: <xms:VA23XpvL0uCpZ6neYTdRmDzFpEWEXS7Bvevxc0EaL4SZZcCZoZdRMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:VA23XpRYst2_ukurQg94anc5B1GL9ew8nfMxgGlt7jFbxSxvWKHW0Q>
    <xmx:VA23XltFgn5nvKzIoAP_kq2XIpkmk4C1aHyVFqfWteyCmusthaTkMw>
    <xmx:VA23XjAVrdlUgZeDo8yXwHGLgv93ih_82xYIh0MYwBAHHajdp4pd2Q>
    <xmx:VA23Xuuq_OgDB_PDYWy6jMw6M864YGuxPVhIMMR2ftR587NRLz2V-w>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E4960306612B;
        Sat,  9 May 2020 16:06:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/9] mlxsw: spectrum_matchall: Forbid to insert matchall rules in collision with flower rules
Date:   Sat,  9 May 2020 23:06:06 +0300
Message-Id: <20200509200610.375719-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509200610.375719-1-idosch@idosch.org>
References: <20200509200610.375719-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

On ingress, the matchall rules doing mirroring and sampling are offloaded
into hardware blocks that are processed before any flower rules.
On egress, the matchall mirroring rules are offloaded into hardware
block that is processed after all flower rules.

Therefore check the priorities of inserted matchall rules against
existing flower rules and ensure the correct ordering.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 +-
 .../ethernet/mellanox/mlxsw/spectrum_flow.c   |  4 +-
 .../mellanox/mlxsw/spectrum_matchall.c        | 37 ++++++++++++++++++-
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 456dbaa5ee26..147a5634244b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -894,7 +894,8 @@ extern const struct mlxsw_afk_ops mlxsw_sp1_afk_ops;
 extern const struct mlxsw_afk_ops mlxsw_sp2_afk_ops;
 
 /* spectrum_matchall.c */
-int mlxsw_sp_mall_replace(struct mlxsw_sp_flow_block *block,
+int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
+			  struct mlxsw_sp_flow_block *block,
 			  struct tc_cls_matchall_offload *f);
 void mlxsw_sp_mall_destroy(struct mlxsw_sp_flow_block *block,
 			   struct tc_cls_matchall_offload *f);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
index 76644f6a8121..47b66f347ff1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
@@ -135,9 +135,11 @@ static int mlxsw_sp_flow_block_unbind(struct mlxsw_sp *mlxsw_sp,
 static int mlxsw_sp_flow_block_mall_cb(struct mlxsw_sp_flow_block *flow_block,
 				       struct tc_cls_matchall_offload *f)
 {
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_flow_block_mlxsw_sp(flow_block);
+
 	switch (f->command) {
 	case TC_CLSMATCHALL_REPLACE:
-		return mlxsw_sp_mall_replace(flow_block, f);
+		return mlxsw_sp_mall_replace(mlxsw_sp, flow_block, f);
 	case TC_CLSMATCHALL_DESTROY:
 		mlxsw_sp_mall_destroy(flow_block, f);
 		return 0;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index b11bab76b2e1..f1a44a8eda55 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -192,13 +192,17 @@ static void mlxsw_sp_mall_prio_update(struct mlxsw_sp_flow_block *block)
 	}
 }
 
-int mlxsw_sp_mall_replace(struct mlxsw_sp_flow_block *block,
+int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
+			  struct mlxsw_sp_flow_block *block,
 			  struct tc_cls_matchall_offload *f)
 {
 	struct mlxsw_sp_flow_block_binding *binding;
 	struct mlxsw_sp_mall_entry *mall_entry;
 	__be16 protocol = f->common.protocol;
 	struct flow_action_entry *act;
+	unsigned int flower_min_prio;
+	unsigned int flower_max_prio;
+	bool flower_prio_valid;
 	int err;
 
 	if (!flow_offload_has_one_action(&f->rule->action)) {
@@ -216,6 +220,19 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_flow_block *block,
 		return -EOPNOTSUPP;
 	}
 
+	err = mlxsw_sp_flower_prio_get(mlxsw_sp, block, f->common.chain_index,
+				       &flower_min_prio, &flower_max_prio);
+	if (err) {
+		if (err != -ENOENT) {
+			NL_SET_ERR_MSG(f->common.extack, "Failed to get flower priorities");
+			return err;
+		}
+		flower_prio_valid = false;
+		/* No flower filters are installed in specified chain. */
+	} else {
+		flower_prio_valid = true;
+	}
+
 	mall_entry = kzalloc(sizeof(*mall_entry), GFP_KERNEL);
 	if (!mall_entry)
 		return -ENOMEM;
@@ -226,6 +243,18 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_flow_block *block,
 	act = &f->rule->action.entries[0];
 
 	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {
+		if (flower_prio_valid && mall_entry->ingress &&
+		    mall_entry->priority >= flower_min_prio) {
+			NL_SET_ERR_MSG(f->common.extack, "Failed to add behind existing flower rules");
+			err = -EOPNOTSUPP;
+			goto errout;
+		}
+		if (flower_prio_valid && !mall_entry->ingress &&
+		    mall_entry->priority <= flower_max_prio) {
+			NL_SET_ERR_MSG(f->common.extack, "Failed to add in front of existing flower rules");
+			err = -EOPNOTSUPP;
+			goto errout;
+		}
 		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_MIRROR;
 		mall_entry->mirror.to_dev = act->dev;
 	} else if (act->id == FLOW_ACTION_SAMPLE &&
@@ -235,6 +264,12 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_flow_block *block,
 			err = -EOPNOTSUPP;
 			goto errout;
 		}
+		if (flower_prio_valid &&
+		    mall_entry->priority >= flower_min_prio) {
+			NL_SET_ERR_MSG(f->common.extack, "Failed to add behind existing flower rules");
+			err = -EOPNOTSUPP;
+			goto errout;
+		}
 		if (act->sample.rate > MLXSW_REG_MPSC_RATE_MAX) {
 			NL_SET_ERR_MSG(f->common.extack, "Sample rate not supported");
 			err = -EOPNOTSUPP;
-- 
2.26.2

