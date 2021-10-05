Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53983421B92
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhJEBQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230437AbhJEBQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB57B61507;
        Tue,  5 Oct 2021 01:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396484;
        bh=HXb4JkeDjDbMUvAJD7N9+qLaUzW3E644AOEipeY58Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSZwd3rVej2H/aHxwbJD5aXBQSA8T6/UftcCs+uLMGRGIhACAvwI04T6wgXBabX5s
         F2nX/TAOaLfoH6wct9r6tRvh6ashynXGXV4KBWaanPItfAep1dw6xKQX5rz95d9JCF
         xcxqLvawb6YDutRuhj/sWzisCvPEIjLeoyfalDrZTeWsIXntNzTsomX26Yaeh+eIks
         brJOlHA5anJtObZJoY4+kjqKdAT++MRg4zqAQvGf8XLtomOK73bmyinet+p1Cd5DwU
         RVPLilsc0C+Qw+S9M+a34PyMPBf+zPzXWVYGX4KR/IpeReS6BbPhFWZd2hm9nPR1fn
         BdG5IxffsEYSw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: TC, Refactor sample offload error flow
Date:   Mon,  4 Oct 2021 18:12:50 -0700
Message-Id: <20211005011302.41793-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Refactor sample unoffload to be symmetric to sample offload.
Use the existing del_post_rule() to release the post rule.
Also mlx5e_tc_sample_unoffload() should not return post_rule
which is NULL when post actions are supported.
Sample offload works with this NULL because many places of the
code use IS_ERR() instead of IS_ERR_OR_NULL() to check rule is valid
and when rule is detected as sample offload the code is not using the
rule. Let's be persistent and avoid returning NULL anyway and return the
pre rule, like in CT case, which is not NULL.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/sample.c         | 21 +++++--------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 6552ecee3f9b..d1d7e4b9f7ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -602,7 +602,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	}
 	sample_flow->pre_attr = pre_attr;
 
-	return sample_flow->post_rule;
+	return sample_flow->pre_rule;
 
 err_pre_offload_rule:
 	kfree(pre_attr);
@@ -613,7 +613,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 err_obj_id:
 	sampler_put(tc_psample, sample_flow->sampler);
 err_sampler:
-	if (!post_act_handle)
+	if (sample_flow->post_rule)
 		del_post_rule(esw, sample_flow, attr);
 err_post_rule:
 	if (post_act_handle)
@@ -628,9 +628,7 @@ mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *tc_psample,
 			  struct mlx5_flow_handle *rule,
 			  struct mlx5_flow_attr *attr)
 {
-	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	struct mlx5e_sample_flow *sample_flow;
-	struct mlx5_vport_tbl_attr tbl_attr;
 	struct mlx5_eswitch *esw;
 
 	if (IS_ERR_OR_NULL(tc_psample))
@@ -650,23 +648,14 @@ mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *tc_psample,
 	 */
 	sample_flow = attr->sample_attr->sample_flow;
 	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->pre_rule, sample_flow->pre_attr);
-	if (!sample_flow->post_act_handle)
-		mlx5_eswitch_del_offloaded_rule(esw, sample_flow->post_rule,
-						sample_flow->post_attr);
 
 	sample_restore_put(tc_psample, sample_flow->restore);
 	mapping_remove(esw->offloads.reg_c0_obj_pool, attr->sample_attr->restore_obj_id);
 	sampler_put(tc_psample, sample_flow->sampler);
-	if (sample_flow->post_act_handle) {
+	if (sample_flow->post_act_handle)
 		mlx5e_tc_post_act_del(tc_psample->post_act, sample_flow->post_act_handle);
-	} else {
-		tbl_attr.chain = attr->chain;
-		tbl_attr.prio = attr->prio;
-		tbl_attr.vport = esw_attr->in_rep->vport;
-		tbl_attr.vport_ns = &mlx5_esw_vport_tbl_sample_ns;
-		mlx5_esw_vporttbl_put(esw, &tbl_attr);
-		kfree(sample_flow->post_attr);
-	}
+	else
+		del_post_rule(esw, sample_flow, attr);
 
 	kfree(sample_flow->pre_attr);
 	kfree(sample_flow);
-- 
2.31.1

