Return-Path: <netdev+bounces-11573-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E064733A51
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:03:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A44C281869
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB73C1F171;
	Fri, 16 Jun 2023 20:01:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE80F1F933
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00906C433AD;
	Fri, 16 Jun 2023 20:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686945687;
	bh=2QJtzKcnWRnadCRbCfd+lHMyvb/N45n/Z0hg6rCN5Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kz1sm9ao/tTvVOPnHlFlGzmRxr+9el6KNec8d3OzZUz8/GKWV+dZMU4/IjGy59NzE
	 +At5+9uK8BGqqJcUHk7tS3qSFTQQ0pmJt8sI91p5g7c1TOeRgqsz885hwa2JcUcnxy
	 NLLbVx6inxdejrt55nJBSFWMfkKreD3viwbhd9f0USgkHUvEryEke3YOHDXhnEg54n
	 PMooLzthn823mlBzzel0cTemhhVDYIWQSlbcmUNel2EMJmRSbYiRoxXPbZXxYf7JCk
	 XDhMJk+aoQbdY5UKi+dMdtiinbU21z9a9aua+mzt3bwTqifEEYSBKe5x5JGHqrV0Cd
	 4D4qIjHmXeI+g==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Chris Mi <cmi@nvidia.com>,
	Paul Blakey <paulb@nvidia.com>
Subject: [net 04/12] net/mlx5e: TC, Add null pointer check for hardware miss support
Date: Fri, 16 Jun 2023 13:01:11 -0700
Message-Id: <20230616200119.44163-5-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616200119.44163-1-saeed@kernel.org>
References: <20230616200119.44163-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chris Mi <cmi@nvidia.com>

The cited commits add hardware miss support to tc action. But if
the rules can't be offloaded, the pointers are null and system
will panic when accessing them.

Fix it by checking null pointer.

Fixes: 08fe94ec5f77 ("net/mlx5e: TC, Remove special handling of CT action")
Fixes: 6702782845a5 ("net/mlx5e: TC, Set CT miss to the specific ct action instance")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index ead38ef69483..a254e728ac95 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -2021,6 +2021,8 @@ void
 mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *priv,
 		       struct mlx5_flow_attr *attr)
 {
+	if (!attr->ct_attr.ft) /* no ct action, return */
+		return;
 	if (!attr->ct_attr.nf_ft) /* means only ct clear action, and not ct_clear,ct() */
 		return;
 
-- 
2.40.1


