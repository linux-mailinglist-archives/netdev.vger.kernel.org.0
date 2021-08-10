Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649F13E51A9
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 05:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhHJEAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236867AbhHJD77 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 23:59:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47CC261052;
        Tue, 10 Aug 2021 03:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628567977;
        bh=naoM1dRyqsHsxDaqJipg4c6whkoshpjM8OQkOLXzP7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h//u729giIjfYmlRhvLg3NqpTVfVggafR2GRHkrFv3PTZuebE660v4+wI3hMD7Q9W
         1kTCYVBg9ClP3RP9+S9xin9XKFPuaCbFXEG40inUu7VJ8X/RONW+7ciBqo+O3ZSnps
         l87ywZKMUjPT7sE6qNl8JXoOSwZi7LF8nPpekyWaAIKjcfB9ODq+0/lg+4o+RkgYv8
         u6t0aZijSQa/zWeV9DrvWLkRFX5QvCLAJjipVbEEsyMAcgkKk9hLWw77TZMcvt8nv7
         X90nVehY/x736jAVFLBIdTDxfY03riNVnSlWIdv25Fz5WQ6EXxu74cSnnwk28oWDeR
         qd9X4T4PtUAlw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/12] net/mlx5e: Avoid creating tunnel headers for local route
Date:   Mon,  9 Aug 2021 20:59:14 -0700
Message-Id: <20210810035923.345745-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810035923.345745-1-saeed@kernel.org>
References: <20210810035923.345745-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

It could be local and remote are on the same machine and the route
result will be a local route which will result in creating encap id
with src/dst mac address of 0.

Fixes: a54e20b4fcae ("net/mlx5e: Add basic TC tunnel set action for SRIOV offloads")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 8f79f04eccd6..1e2d117082d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -124,6 +124,11 @@ static int mlx5e_route_lookup_ipv4_get(struct mlx5e_priv *priv,
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
+	if (rt->rt_type != RTN_UNICAST) {
+		ret = -ENETUNREACH;
+		goto err_rt_release;
+	}
+
 	if (mlx5_lag_is_multipath(mdev) && rt->rt_gw_family != AF_INET) {
 		ret = -ENETUNREACH;
 		goto err_rt_release;
-- 
2.31.1

