Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E33F42FF7B
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239381AbhJPAlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236462AbhJPAlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0FC561245;
        Sat, 16 Oct 2021 00:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634344747;
        bh=i08mVnylhdCOmLi0p4Uz4gij/bCIISJNMBgaFjdQfJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S26bymzdDQQK9g0F1X/SQSa3TTLrHkPmwObKTxM8bMN2HCq4NEZcrp+RIi7KuoSnw
         AJqUjzM2s3B8afqsdFOAWvctPGFM/4Oq79dPQHCNHCPIDxfDaoSWC4DIqSALL7LcYf
         mRbwEPRiG/2tpe/zwfiHYPOVTi5VmZKL34IXAB5s60MxgYdcskhoghaW8gmvYqpEqC
         1LWhQJrmPVXXvV5ZIQPn9SyERgYPo3HNcmUnb514zggP8hNn6PgL8s9knSFpuY48gh
         p/uK+Swtm4BwDkMeg4jAMsCiAD9M0kYLCBWxoOpRaCp7g9IVxWilrwRUvF33pTaTZ1
         sYKEWbqU3UrMw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Len Baker <len.baker@gmx.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/13] net/mlx5: DR, Prefer kcalloc over open coded arithmetic
Date:   Fri, 15 Oct 2021 17:38:58 -0700
Message-Id: <20211016003902.57116-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211016003902.57116-1-saeed@kernel.org>
References: <20211016003902.57116-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Len Baker <len.baker@gmx.com>

As noted in the "Deprecated Interfaces, Language Features, Attributes,
and Conventions" documentation [1], size calculations (especially
multiplication) should not be performed in memory allocator (or similar)
function arguments due to the risk of them overflowing. This could lead
to values wrapping around and a smaller allocation being made than the
caller was expecting. Using those allocations could lead to linear
overflows of heap memory and other misbehaviors.

So, refactor the code a bit to use the purpose specific kcalloc()
function instead of the argument size * count in the kzalloc() function.

[1] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments

Signed-off-by: Len Baker <len.baker@gmx.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_action.c  | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 50630112c8ff..07936841ce99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -854,6 +854,7 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 	struct mlx5dr_action *action;
 	bool reformat_req = false;
 	u32 num_of_ref = 0;
+	u32 ref_act_cnt;
 	int ret;
 	int i;
 
@@ -862,11 +863,14 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 		return NULL;
 	}
 
-	hw_dests = kzalloc(sizeof(*hw_dests) * num_of_dests, GFP_KERNEL);
+	hw_dests = kcalloc(num_of_dests, sizeof(*hw_dests), GFP_KERNEL);
 	if (!hw_dests)
 		return NULL;
 
-	ref_actions = kzalloc(sizeof(*ref_actions) * num_of_dests * 2, GFP_KERNEL);
+	if (unlikely(check_mul_overflow(num_of_dests, 2u, &ref_act_cnt)))
+		goto free_hw_dests;
+
+	ref_actions = kcalloc(ref_act_cnt, sizeof(*ref_actions), GFP_KERNEL);
 	if (!ref_actions)
 		goto free_hw_dests;
 
-- 
2.31.1

