Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB69696FF
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732502AbfGON6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733106AbfGON6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:58:14 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91A52212F5;
        Mon, 15 Jul 2019 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199093;
        bh=Dods9Xqg4wn68YBG3bujgJMAonGAUVFm9QOofA2/0RI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuSsyK3ADSmpR/96j/H6rAVzHkrXXReKVnkpQlI+hs/ycap1znhcRH4WNn4esskHZ
         K5ZI0p3NmEP1ckbovQuSHS8AbF4P6hlOU5eAdS4zh7iKqpXX2ogS2ZWjTXSjo6gCDb
         DnVrkqp8xFqeKiM3QJFoJO7rC4tnZlwkkhV4wu2k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 189/249] net/mlx5e: Attach/detach XDP program safely
Date:   Mon, 15 Jul 2019 09:45:54 -0400
Message-Id: <20190715134655.4076-189-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit e18953240de8b46360a67090c87ee1ef8160b35d ]

When an XDP program is set, a full reopen of all channels happens in two
cases:

1. When there was no program set, and a new one is being set.

2. When there was a program set, but it's being unset.

The full reopen is necessary, because the channel parameters may change
if XDP is enabled or disabled. However, it's performed in an unsafe way:
if the new channels fail to open, the old ones are already closed, and
the interface goes down. Use the safe way to switch channels instead.
The same way is already used for other configuration changes.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 31 ++++++++++++-------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a8e8350b38aa..8db9fdbc03ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4192,8 +4192,6 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 	/* no need for full reset when exchanging programs */
 	reset = (!priv->channels.params.xdp_prog || !prog);
 
-	if (was_opened && reset)
-		mlx5e_close_locked(netdev);
 	if (was_opened && !reset) {
 		/* num_channels is invariant here, so we can take the
 		 * batched reference right upfront.
@@ -4205,20 +4203,31 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 		}
 	}
 
-	/* exchange programs, extra prog reference we got from caller
-	 * as long as we don't fail from this point onwards.
-	 */
-	old_prog = xchg(&priv->channels.params.xdp_prog, prog);
+	if (was_opened && reset) {
+		struct mlx5e_channels new_channels = {};
+
+		new_channels.params = priv->channels.params;
+		new_channels.params.xdp_prog = prog;
+		mlx5e_set_rq_type(priv->mdev, &new_channels.params);
+		old_prog = priv->channels.params.xdp_prog;
+
+		err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+		if (err)
+			goto unlock;
+	} else {
+		/* exchange programs, extra prog reference we got from caller
+		 * as long as we don't fail from this point onwards.
+		 */
+		old_prog = xchg(&priv->channels.params.xdp_prog, prog);
+	}
+
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
-	if (reset) /* change RQ type according to priv->xdp_prog */
+	if (!was_opened && reset) /* change RQ type according to priv->xdp_prog */
 		mlx5e_set_rq_type(priv->mdev, &priv->channels.params);
 
-	if (was_opened && reset)
-		err = mlx5e_open_locked(netdev);
-
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state) || reset)
+	if (!was_opened || reset)
 		goto unlock;
 
 	/* exchanging programs w/o reset, we update ref counts on behalf
-- 
2.20.1

