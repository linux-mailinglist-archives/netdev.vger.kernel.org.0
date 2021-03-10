Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3626334776
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbhCJTEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233725AbhCJTD4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:03:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6863164F9F;
        Wed, 10 Mar 2021 19:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403035;
        bh=2R19Ix3DF7xlZWC+eSGRPjkgJD67VtoG8qicf8P7dU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0x0uC93ycbVIV/VZ3qyziKvB49Uw55s5dawghiIPxilsiwR4tHNlJfZCiubbMHCn
         w3I3JDK9EQTKaRC+l3wZXa/c+WX2TJHaI1XEuvVGn1zdpch7a1RJNsEOKgmePc0UBG
         1prcoPAh+9Eixxb3h0MuyB7knLfAqu55x1qQsjwuyOAkuTmPj3vZKzUqsF7LjRAmy4
         2U8/gahbBZE6YUpPK+QhE2X4/Xp2U7DkeM/1aPY0y487UAaQTbXvTZ32XiEhu/llrA
         Iovu59clmedswbEMZ7ZVttLpT9qNapJy28NDdy0TQ0SLfCmEnhVQ41DlzJLl2IZ9al
         CYwXBaK35GNyw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/18] net/mlx5e: When changing XDP program without reset, take refs for XSK RQs
Date:   Wed, 10 Mar 2021 11:03:29 -0800
Message-Id: <20210310190342.238957-6-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Each RQ (including XSK RQs) takes a reference to the XDP program. When
an XDP program is attached or detached, the channels and queues are
recreated, however, there is a special flow for changing an active XDP
program to another one. In that flow, channels and queues stay alive,
but the refcounts of the old and new XDP programs are adjusted. This
flow didn't increment refcount by the number of active XSK RQs, and this
commit fixes it.

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 66d23cd275c1..6b761fb8d269 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4695,8 +4695,10 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 		struct mlx5e_channel *c = priv->channels.c[i];
 
 		mlx5e_rq_replace_xdp_prog(&c->rq, prog);
-		if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
+		if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state)) {
+			bpf_prog_inc(prog);
 			mlx5e_rq_replace_xdp_prog(&c->xskrq, prog);
+		}
 	}
 
 unlock:
-- 
2.29.2

