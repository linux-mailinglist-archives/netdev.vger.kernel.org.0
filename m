Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8516A56C2F
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbfFZOgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:36:20 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59837 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725958AbfFZOgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:36:18 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:16 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGXx027430;
        Wed, 26 Jun 2019 17:36:16 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH bpf-next V6 01/16] net/mlx5e: Attach/detach XDP program safely
Date:   Wed, 26 Jun 2019 17:35:23 +0300
Message-Id: <1561559738-4213-2-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

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
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 31 +++++++++++++++--------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5e40db8f92e6..1b427d7fab42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4190,8 +4190,6 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 	/* no need for full reset when exchanging programs */
 	reset = (!priv->channels.params.xdp_prog || !prog);
 
-	if (was_opened && reset)
-		mlx5e_close_locked(netdev);
 	if (was_opened && !reset) {
 		/* num_channels is invariant here, so we can take the
 		 * batched reference right upfront.
@@ -4203,20 +4201,31 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
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
1.8.3.1

