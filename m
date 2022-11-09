Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323C1622BEE
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 13:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiKIMzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 07:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiKIMy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 07:54:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F96233BA
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 04:54:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3F5AB81E69
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB33FC433D6;
        Wed,  9 Nov 2022 12:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667998492;
        bh=9tCTtXs76v/GZvuTuuScTFdMZC4fvPZTd/sX7KDjTyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNJCmcBWj7DhtkcrQoLNyA6xXonG+8604ktof7gYMKUA9cfTGx1zYRbABY1zaUcyP
         c/vr/xF2DJeRoh+eE2ONyQ2zgUpYoiyaTRVJTh2/FPGMsrA+AMqJHpao9jXS9iAZxw
         WC2/hDnUBwNp00Zpl4Eoon6u4sQ7w5ldn9Wgq6R5hlwsEG6X/PHjVnBcNkFYapM7Og
         c4P01Ek/S8RUh5vuSWu+oSNGMJiOWVBM4OaoUeCG6yP+KhCpXEIOOi4CJDroTlYj+a
         a0QuCvBkO9hieI7eitrGndKLim5KnjHG4cXlyOF6ivlgQenHTJksgPoMD9xyJ3vzGi
         44bDA3ngDxI1g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH xfrm-next v7 4/8] xfrm: add TX datapath support for IPsec packet offload mode
Date:   Wed,  9 Nov 2022 14:54:32 +0200
Message-Id: <f0148001c77867d288251a96f6d838a16a6dbdc4.1667997522.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1667997522.git.leonro@nvidia.com>
References: <cover.1667997522.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

In IPsec packet mode, the device is going to encrypt and encapsulate
packets that are associated with offloaded policy. After successful
policy lookup to indicate if packets should be offloaded or not,
the stack forwards packets to the device to do the magic.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_device.c | 15 +++++++++++++--
 net/xfrm/xfrm_output.c | 12 +++++++++++-
 net/xfrm/xfrm_policy.c | 21 ++++++++++++++++++++-
 3 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 8e18abc5016f..6affb3d1e204 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -120,6 +120,16 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	if (xo->flags & XFRM_GRO || x->xso.dir == XFRM_DEV_OFFLOAD_IN)
 		return skb;
 
+	/* The packet was sent to HW IPsec packet offload engine,
+	 * but to wrong device. Drop the packet, so it won't skip
+	 * XFRM stack.
+	 */
+	if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET && x->xso.dev != dev) {
+		kfree_skb(skb);
+		dev_core_stats_tx_dropped_inc(dev);
+		return NULL;
+	}
+
 	/* This skb was already validated on the upper/virtual dev */
 	if ((x->xso.dev != dev) && (x->xso.real_dev == dev))
 		return skb;
@@ -385,8 +395,9 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 	if (!x->type_offload || x->encap)
 		return false;
 
-	if ((!dev || (dev == xfrm_dst_path(dst)->dev)) &&
-	    (!xdst->child->xfrm)) {
+	if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET ||
+	    ((!dev || (dev == xfrm_dst_path(dst)->dev)) &&
+	     !xdst->child->xfrm)) {
 		mtu = xfrm_state_mtu(x, xdst->child_mtu_cached);
 		if (skb->len <= mtu)
 			goto ok;
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 9a5e79a38c67..ce9e360a96e2 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -494,7 +494,7 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
 	struct xfrm_state *x = dst->xfrm;
 	struct net *net = xs_net(x);
 
-	if (err <= 0)
+	if (err <= 0 || x->xso.type == XFRM_DEV_OFFLOAD_PACKET)
 		goto resume;
 
 	do {
@@ -718,6 +718,16 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		break;
 	}
 
+	if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET) {
+		if (!xfrm_dev_offload_ok(skb, x)) {
+			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
+			kfree_skb(skb);
+			return -EHOSTUNREACH;
+		}
+
+		return xfrm_output_resume(sk, skb, 0);
+	}
+
 	secpath_reset(skb);
 
 	if (xfrm_dev_offload_ok(skb, x)) {
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 07f43729ac4e..06226942a152 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2619,6 +2619,7 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 	int tos;
 	int family = policy->selector.family;
 	xfrm_address_t saddr, daddr;
+	struct dst_entry *dst1;
 
 	xfrm_flowi_addr_get(fl, &saddr, &daddr, family);
 
@@ -2628,7 +2629,8 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 
 	for (; i < nx; i++) {
 		struct xfrm_dst *xdst = xfrm_alloc_dst(net, family);
-		struct dst_entry *dst1 = &xdst->u.dst;
+
+		dst1 = &xdst->u.dst;
 
 		err = PTR_ERR(xdst);
 		if (IS_ERR(xdst)) {
@@ -2708,6 +2710,23 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 	if (!dev)
 		goto free_dst;
 
+	dst1 = &xdst0->u.dst;
+	/* Packet offload: both policy and SA should be offloaded */
+	if ((policy->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
+	     dst1->xfrm->xso.type != XFRM_DEV_OFFLOAD_PACKET) ||
+	    (policy->xdo.type != XFRM_DEV_OFFLOAD_PACKET &&
+	     dst1->xfrm->xso.type == XFRM_DEV_OFFLOAD_PACKET)) {
+		err = -EINVAL;
+		goto free_dst;
+	}
+
+	/* Packet offload: both policy and SA should have same device */
+	if (policy->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
+	    policy->xdo.dev != dst1->xfrm->xso.dev) {
+		err = -EINVAL;
+		goto free_dst;
+	}
+
 	xfrm_init_path(xdst0, dst, nfheader_len);
 	xfrm_init_pmtu(bundle, nx);
 
-- 
2.38.1

