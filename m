Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBAA68F55
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389206AbfGOONc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389195AbfGOONb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:13:31 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B75020868;
        Mon, 15 Jul 2019 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200011;
        bh=1tGrLwkwkkeKN/uqZzZc54Hw04C36XMH00VDe3wzt0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzwmYFjThoG+jJyMidkirAzzSeWOmlBpAZ5Pv3EewAt5sFTS/fai+XUy4WiFjxnDH
         s12ES4DetkRML68j6moUDhdrcJSxxoOQJ4ZUgUVkPA41SGY/Bm/ipmlBNfFakoj+sk
         21Np2BgK4JxExle1bIbqdw2jm/p/fwk9+/s9+6Pk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianbo Liu <jianbol@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 159/219] net/mlx5: Get vport ACL namespace by vport index
Date:   Mon, 15 Jul 2019 10:02:40 -0400
Message-Id: <20190715140341.6443-159-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

[ Upstream commit f53297d67800feb5fafd94abd926c889aefee690 ]

The ingress and egress ACL root namespaces are created per vport and
stored into arrays. However, the vport number is not the same as the
index. Passing the array index, instead of vport number, to get the
correct ingress and egress acl namespace.

Fixes: 9b93ab981e3b ("net/mlx5: Separate ingress/egress namespaces for each vport")
Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 8a67fd197b79..16ed6ebd31ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -950,7 +950,7 @@ static int esw_vport_enable_egress_acl(struct mlx5_eswitch *esw,
 		  vport->vport, MLX5_CAP_ESW_EGRESS_ACL(dev, log_max_ft_size));
 
 	root_ns = mlx5_get_flow_vport_acl_namespace(dev, MLX5_FLOW_NAMESPACE_ESW_EGRESS,
-						    vport->vport);
+			mlx5_eswitch_vport_num_to_index(esw, vport->vport));
 	if (!root_ns) {
 		esw_warn(dev, "Failed to get E-Switch egress flow namespace for vport (%d)\n", vport->vport);
 		return -EOPNOTSUPP;
@@ -1068,7 +1068,7 @@ static int esw_vport_enable_ingress_acl(struct mlx5_eswitch *esw,
 		  vport->vport, MLX5_CAP_ESW_INGRESS_ACL(dev, log_max_ft_size));
 
 	root_ns = mlx5_get_flow_vport_acl_namespace(dev, MLX5_FLOW_NAMESPACE_ESW_INGRESS,
-						    vport->vport);
+			mlx5_eswitch_vport_num_to_index(esw, vport->vport));
 	if (!root_ns) {
 		esw_warn(dev, "Failed to get E-Switch ingress flow namespace for vport (%d)\n", vport->vport);
 		return -EOPNOTSUPP;
-- 
2.20.1

