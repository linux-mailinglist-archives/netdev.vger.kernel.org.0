Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6AF31986C
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhBLC6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:58:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229797AbhBLC6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F186B64E6C;
        Fri, 12 Feb 2021 02:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098644;
        bh=GQet7CXeQHwWK3FuUy/5m6DgHpQoxsJbr/ag62cVQiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtmW9Ig+vH3fK3XwD0hErDng9UtWB6wd7AFdFL/5XoQgSTVUz2tN8cO+X8VPLFPhO
         easYYyI6oMqT5EvmaSklWkAdT1M+6it2ykALdVWIEDfuVGbDApFmlfe/DUJq5wUr+y
         BxKEoSWcA78EtJ3l06k+Pnu4rKyu18Nh8XWeRUBftv1Zo8S7TKgZ1cWC4zaqgVxMiy
         EqXZuEuzQ6uiOO3t6HIZClphRE0W/nAmapOQ4MtgQRZWrQbttkDeSAv1/GBQs/WCEB
         M50XLwkldCdw9rhTGYZWGnXO1Xuaj/BLtqkmplMKKGNUBgm0KqTkO+1H/d1wnafUJ9
         omNz/IGdYh00g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/15] net/mlx5e: Fix CQ params of ICOSQ and async ICOSQ
Date:   Thu, 11 Feb 2021 18:56:34 -0800
Message-Id: <20210212025641.323844-9-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

The commit mentioned below has split the parameters of ICOSQ and async
ICOSQ, but it contained a typo: the CQ parameters were swapped for ICOSQ
and async ICOSQ. Async ICOSQ is longer than the normal ICOSQ, and the CQ
size must be the same as the size of the corresponding SQ, but due to
this bug, the CQ of async ICOSQ was much shorter than async ICOSQ
itself. It led to overflows of the CQ with such messages in dmesg, in
particular, when running multiple kTLS-offloaded streams:

mlx5_core 0000:08:00.0: cq_err_event_notifier:529:(pid 9422): CQ error
on CQN 0x406, syndrome 0x1
mlx5_core 0000:08:00.0 eth2: mlx5e_cq_error_event: cqn=0x000406
event=0x04

This commit fixes the issue by using the corresponding parameters for
ICOSQ and async ICOSQ.

Fixes: c293ac927fbb ("net/mlx5e: Refactor build channel params")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3edc826cc6bb..a2e0b548bf57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1827,12 +1827,12 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 
 	mlx5e_build_create_cq_param(&ccp, c);
 
-	err = mlx5e_open_cq(c->priv, icocq_moder, &cparam->icosq.cqp, &ccp,
+	err = mlx5e_open_cq(c->priv, icocq_moder, &cparam->async_icosq.cqp, &ccp,
 			    &c->async_icosq.cq);
 	if (err)
 		return err;
 
-	err = mlx5e_open_cq(c->priv, icocq_moder, &cparam->async_icosq.cqp, &ccp,
+	err = mlx5e_open_cq(c->priv, icocq_moder, &cparam->icosq.cqp, &ccp,
 			    &c->icosq.cq);
 	if (err)
 		goto err_close_async_icosq_cq;
-- 
2.29.2

