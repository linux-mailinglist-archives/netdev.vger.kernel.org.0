Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324CB595884
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbiHPKhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234866AbiHPKg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:36:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16761580A2
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:59:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81BADB8124C
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C221AC433C1;
        Tue, 16 Aug 2022 08:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660640390;
        bh=PZL91AXffzFMtihnRFLeRE15m2nJ0tedTboZ/kLRP9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHZIlAms+4acYHggrlF7hQaxRAMl9WE/hfRZw6r8pg7Xr7HRLZGYQmFy9zg0Tf93p
         UaC4TBkXPQ20ZJ1xLadIUcyByulji2auzrM3E1Vaov4Cs7M6unNS1B+MOXGwvfY2wX
         RNg8KZlmmGFyqZlDUugwk+YUZfTF1FjPoX+LvrW6PDADKfkiPm+WPvpknuJe/HMSQ/
         pseDu4oIGqVrnEy8rdnfVshgkK4N+EcEOb8hqoK+GYR6ckpvYhiOfVCkEyP9rSs1Ma
         mQ9nPnyZwuxOJzaydYOq8GaOIEywCswpoLkUzWXe9A4gytKMCQqrm2KbbWVRHRGTLc
         04VT7zuQEWO6w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next v2 2/6] xfrm: allow state full offload mode
Date:   Tue, 16 Aug 2022 11:59:23 +0300
Message-Id: <de9490892eefc33723c1ae803adf881ad8ea621a.1660639789.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660639789.git.leonro@nvidia.com>
References: <cover.1660639789.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 2a8fd7020622..c182b640b80d 100644
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
index 6d1124eb1ec8..5b04e5cdca64 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -215,6 +215,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	struct xfrm_dev_offload *xso = &x->xso;
 	xfrm_address_t *saddr;
 	xfrm_address_t *daddr;
+	bool is_full_offload;
 
 	if (!x->type_offload)
 		return -EINVAL;
@@ -223,9 +224,11 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	if (x->encap || x->tfcpad)
 		return -EINVAL;
 
-	if (xuo->flags & ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND))
+	if (xuo->flags &
+	    ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND | XFRM_OFFLOAD_FULL))
 		return -EINVAL;
 
+	is_full_offload = xuo->flags & XFRM_OFFLOAD_FULL;
 	dev = dev_get_by_index(net, xuo->ifindex);
 	if (!dev) {
 		if (!(xuo->flags & XFRM_OFFLOAD_INBOUND)) {
@@ -240,7 +243,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 					x->props.family,
 					xfrm_smark_get(0, x));
 		if (IS_ERR(dst))
-			return 0;
+			return (is_full_offload) ? -EINVAL : 0;
 
 		dev = dst->dev;
 
@@ -251,7 +254,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	if (!dev->xfrmdev_ops || !dev->xfrmdev_ops->xdo_dev_state_add) {
 		xso->dev = NULL;
 		dev_put(dev);
-		return 0;
+		return (is_full_offload) ? -EINVAL : 0;
 	}
 
 	if (x->props.flags & XFRM_STATE_ESN &&
@@ -270,7 +273,10 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	else
 		xso->dir = XFRM_DEV_OFFLOAD_OUT;
 
-	xso->type = XFRM_DEV_OFFLOAD_CRYPTO;
+	if (is_full_offload)
+		xso->type = XFRM_DEV_OFFLOAD_FULL;
+	else
+		xso->type = XFRM_DEV_OFFLOAD_CRYPTO;
 
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {
@@ -280,7 +286,15 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		netdev_put(dev, &xso->dev_tracker);
 		xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
 
-		if (err != -EOPNOTSUPP)
+		/* User explicitly requested full offload mode and configured
+		 * policy in addition to the XFRM state. So be civil to users,
+		 * and return an error instead of taking fallback path.
+		 *
+		 * This WARN_ON() can be seen as a documentation for driver
+		 * authors to do not return -EOPNOTSUPP in full offload mode.
+		 */
+		WARN_ON(err == -EOPNOTSUPP && is_full_offload);
+		if (err != -EOPNOTSUPP || is_full_offload)
 			return err;
 	}
 
-- 
2.37.2

