Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523AA60C9F2
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbiJYKZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbiJYKYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:24:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE8E1805BF
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:22:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23D1261873
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 10:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BA0C433C1;
        Tue, 25 Oct 2022 10:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666693348;
        bh=qHmW8OCfNNSjcrFsFUby6gaoKpoXh3IysglUbRexxjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNrDmQBdxR//xI4mdcW4Q9K5DQux2kxzkC30Kdgj2KD0AF6Hj705ZwHWNV4Mjng7n
         7os9n8bmbUsdQE3ZmLuwOCUBWZ80pXvnJbRTK4dQwyr+h6VHYvemS9h4Zxr71KTkn8
         Mta7WYWj5mHyqfPQlb1cgp19C9Xo8oh97Cq+gM6Qj7YqI3H1rVOgxe5y3e+iLiCc/y
         AJpkYA4r1sNd2+B0JzKu0V4BoGbyBwQGqU86vEGOLXLH8VIYubsCQ90wvLwMLqdAK8
         V0kye35LMJte9VZ41ASKoAnp022ctLNWZ7Q1X5Mgllzxy40imKXGfByFkEC9IAyxru
         8DGN7DAjWUnFw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH xfrm-next v6 2/8] xfrm: allow state full offload mode
Date:   Tue, 25 Oct 2022 13:21:58 +0300
Message-Id: <bff5241159e18260523a2318f7133341c32057da.1666692948.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666692948.git.leonro@nvidia.com>
References: <cover.1666692948.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Allow users to configure xfrm states with full offload mode.
The full mode must be requested both for policy and state, and
such requires us to do not implement fallback.

We explicitly return an error if requested full mode can't
be configured.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../inline_crypto/ch_ipsec/chcr_ipsec.c       |  4 ++++
 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    |  5 ++++
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |  5 ++++
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  4 ++++
 drivers/net/netdevsim/ipsec.c                 |  5 ++++
 net/xfrm/xfrm_device.c                        | 24 +++++++++++++++----
 6 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
index 585590520076..ca21794281d6 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
@@ -283,6 +283,10 @@ static int ch_ipsec_xfrm_add_state(struct xfrm_state *x)
 		pr_debug("Cannot offload xfrm states with geniv other than seqiv\n");
 		return -EINVAL;
 	}
+	if (x->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
+		pr_debug("Unsupported xfrm offload\n");
+		return -EINVAL;
+	}
 
 	sa_entry = kzalloc(sizeof(*sa_entry), GFP_KERNEL);
 	if (!sa_entry) {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index 774de63dd93a..53a969e34883 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -585,6 +585,11 @@ static int ixgbe_ipsec_add_sa(struct xfrm_state *xs)
 		return -EINVAL;
 	}
 
+	if (xs->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
+		netdev_err(dev, "Unsupported ipsec offload type\n");
+		return -EINVAL;
+	}
+
 	if (xs->xso.dir == XFRM_DEV_OFFLOAD_IN) {
 		struct rx_sa rsa;
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index 9984ebc62d78..c1cf540d162a 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -280,6 +280,11 @@ static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs)
 		return -EINVAL;
 	}
 
+	if (xs->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
+		netdev_err(dev, "Unsupported ipsec offload type\n");
+		return -EINVAL;
+	}
+
 	if (xs->xso.dir == XFRM_DEV_OFFLOAD_IN) {
 		struct rx_sa rsa;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 325b56ff3e8c..1d8ce116946d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -256,6 +256,10 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		netdev_info(netdev, "Cannot offload xfrm states with geniv other than seqiv\n");
 		return -EINVAL;
 	}
+	if (x->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
+		netdev_info(netdev, "Unsupported xfrm offload type\n");
+		return -EINVAL;
+	}
 	return 0;
 }
 
diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index 386336a38f34..b93baf5c8bee 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -149,6 +149,11 @@ static int nsim_ipsec_add_sa(struct xfrm_state *xs)
 		return -EINVAL;
 	}
 
+	if (xs->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
+		netdev_err(dev, "Unsupported ipsec offload type\n");
+		return -EINVAL;
+	}
+
 	/* find the first unused index */
 	ret = nsim_ipsec_find_empty_idx(ipsec);
 	if (ret < 0) {
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 7c4e0f14df27..1294e0490270 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -216,6 +216,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	struct xfrm_dev_offload *xso = &x->xso;
 	xfrm_address_t *saddr;
 	xfrm_address_t *daddr;
+	bool is_full_offload;
 
 	if (!x->type_offload) {
 		NL_SET_ERR_MSG(extack, "Type doesn't support offload");
@@ -228,11 +229,13 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		return -EINVAL;
 	}
 
-	if (xuo->flags & ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND)) {
+	if (xuo->flags &
+	    ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND | XFRM_OFFLOAD_FULL)) {
 		NL_SET_ERR_MSG(extack, "Unrecognized flags in offload request");
 		return -EINVAL;
 	}
 
+	is_full_offload = xuo->flags & XFRM_OFFLOAD_FULL;
 	dev = dev_get_by_index(net, xuo->ifindex);
 	if (!dev) {
 		if (!(xuo->flags & XFRM_OFFLOAD_INBOUND)) {
@@ -247,7 +250,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 					x->props.family,
 					xfrm_smark_get(0, x));
 		if (IS_ERR(dst))
-			return 0;
+			return (is_full_offload) ? -EINVAL : 0;
 
 		dev = dst->dev;
 
@@ -258,7 +261,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	if (!dev->xfrmdev_ops || !dev->xfrmdev_ops->xdo_dev_state_add) {
 		xso->dev = NULL;
 		dev_put(dev);
-		return 0;
+		return (is_full_offload) ? -EINVAL : 0;
 	}
 
 	if (x->props.flags & XFRM_STATE_ESN &&
@@ -278,7 +281,10 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	else
 		xso->dir = XFRM_DEV_OFFLOAD_OUT;
 
-	xso->type = XFRM_DEV_OFFLOAD_CRYPTO;
+	if (is_full_offload)
+		xso->type = XFRM_DEV_OFFLOAD_FULL;
+	else
+		xso->type = XFRM_DEV_OFFLOAD_CRYPTO;
 
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {
@@ -288,7 +294,15 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		netdev_put(dev, &xso->dev_tracker);
 		xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
 
-		if (err != -EOPNOTSUPP) {
+		/* User explicitly requested full offload mode and configured
+		 * policy in addition to the XFRM state. So be civil to users,
+		 * and return an error instead of taking fallback path.
+		 *
+		 * This WARN_ON() can be seen as a documentation for driver
+		 * authors to do not return -EOPNOTSUPP in full offload mode.
+		 */
+		WARN_ON(err == -EOPNOTSUPP && is_full_offload);
+		if (err != -EOPNOTSUPP || is_full_offload) {
 			NL_SET_ERR_MSG(extack, "Device failed to offload this state");
 			return err;
 		}
-- 
2.37.3

