Return-Path: <netdev+bounces-5209-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD3371037C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:51:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2E31280E72
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90DE1FD9;
	Thu, 25 May 2023 03:49:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E298825
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE75C4339B;
	Thu, 25 May 2023 03:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986555;
	bh=oScWBFrnLhCYGksIsJxb1pzwrK8x2qClCsX5In+LP6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQXD3+eZ8xjb/MxoYKN9ztz6gChBokeO4D1NJdvRtothQbvoZGQNehmc9e5j6y5mQ
	 Gf84sbwwcmS79x7AXSRSGxwUaO0ySLVWZ5YxMv6NOPRFnQz2MiV8g+Vza1V5Psdd74
	 MZ2YAwZvPWU40Voj6X/olbBwey3YqTAt9hIlzKAtK2R+yQBu2U49Ha7vm+WaCWd1Xl
	 /LqEoF+wcgU6CydG8NX9swABIAEmz+nAg+hvcp8Ois/Sg1Q0UiG9YCggME0gfjnWCD
	 qsf8ScI+ll8Qd3DujnAQRtXDucT/63R2+K6pHcxNIkVse031Cxpm0G+WlEQm3pTACR
	 UzAMGupvFRQdw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net 09/17] net/mlx5: Fix post parse infra to only parse every action once
Date: Wed, 24 May 2023 20:48:39 -0700
Message-Id: <20230525034847.99268-10-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525034847.99268-1-saeed@kernel.org>
References: <20230525034847.99268-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vlad Buslov <vladbu@nvidia.com>

Caller of mlx5e_tc_act_post_parse() needs it to parse only the subset of
actions starting after previous split and ending at the current action.
However, that range is not provided as arguments and
mlx5e_tc_act_post_parse() uses generic flow_action_for_each() that iterates
over all flow actions. Not only this is redundant, it also causes a bug
when mlx5e_tc_act->post_parse() callback is not idempotent since it will be
called for every split. For example, ct action tc_act_post_parse_ct()
callback obtains a reference to mlx5_ct_ft instance and calling it several
times during parsing stage will cause reference counter imbalance.

Fix the issue by providing a proper action range of the current split
subset to mlx5e_tc_act_post_parse() and only calling
mlx5e_tc_act->post_parse() for actions inside the subset range.

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c | 7 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c         | 8 +++++---
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index fc923a99b6a4..0380a04c3691 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -84,7 +84,7 @@ mlx5e_tc_act_init_parse_state(struct mlx5e_tc_act_parse_state *parse_state,
 
 int
 mlx5e_tc_act_post_parse(struct mlx5e_tc_act_parse_state *parse_state,
-			struct flow_action *flow_action,
+			struct flow_action *flow_action, int from, int to,
 			struct mlx5_flow_attr *attr,
 			enum mlx5_flow_namespace_type ns_type)
 {
@@ -96,6 +96,11 @@ mlx5e_tc_act_post_parse(struct mlx5e_tc_act_parse_state *parse_state,
 	priv = parse_state->flow->priv;
 
 	flow_action_for_each(i, act, flow_action) {
+		if (i < from)
+			continue;
+		else if (i > to)
+			break;
+
 		tc_act = mlx5e_tc_act_get(act->id, ns_type);
 		if (!tc_act || !tc_act->post_parse)
 			continue;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 0e6e1872ac62..d6c12d0ea55b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -112,7 +112,7 @@ mlx5e_tc_act_init_parse_state(struct mlx5e_tc_act_parse_state *parse_state,
 
 int
 mlx5e_tc_act_post_parse(struct mlx5e_tc_act_parse_state *parse_state,
-			struct flow_action *flow_action,
+			struct flow_action *flow_action, int from, int to,
 			struct mlx5_flow_attr *attr,
 			enum mlx5_flow_namespace_type ns_type);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 8935156f8f4e..8a5a8703f0a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3859,8 +3859,8 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 	struct mlx5_flow_attr *prev_attr;
 	struct flow_action_entry *act;
 	struct mlx5e_tc_act *tc_act;
+	int err, i, i_split = 0;
 	bool is_missable;
-	int err, i;
 
 	ns_type = mlx5e_get_flow_namespace(flow);
 	list_add(&attr->list, &flow->attrs);
@@ -3901,7 +3901,8 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		    i < flow_action->num_entries - 1)) {
 			is_missable = tc_act->is_missable ? tc_act->is_missable(act) : false;
 
-			err = mlx5e_tc_act_post_parse(parse_state, flow_action, attr, ns_type);
+			err = mlx5e_tc_act_post_parse(parse_state, flow_action, i_split, i, attr,
+						      ns_type);
 			if (err)
 				goto out_free_post_acts;
 
@@ -3911,6 +3912,7 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 				goto out_free_post_acts;
 			}
 
+			i_split = i + 1;
 			list_add(&attr->list, &flow->attrs);
 		}
 
@@ -3925,7 +3927,7 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		}
 	}
 
-	err = mlx5e_tc_act_post_parse(parse_state, flow_action, attr, ns_type);
+	err = mlx5e_tc_act_post_parse(parse_state, flow_action, i_split, i, attr, ns_type);
 	if (err)
 		goto out_free_post_acts;
 
-- 
2.40.1


