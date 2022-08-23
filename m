Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDAF59E853
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245061AbiHWRDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343764AbiHWRBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:01:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF2114EB97
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 06:32:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42A6CB81D62
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 13:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82697C433D6;
        Tue, 23 Aug 2022 13:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661261554;
        bh=77fIqVq6GyQ2HZOS+UyBZdm7wbS+2TJKlvRiomjkWxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faLYxZnPWYDMi5mqRdGmxLqsJyDJ+Gyc9O2OgLsldLVJqJr74BqkVlvVefJiCgQPd
         SEuY2aQjVKPbEwT0stQUqqAZDklj/pM+SMnnqJ89YSAbVylCFYQFgtHQsr6ddGA1LS
         tcjvjiCGdhnh4ozqwhCxSY1+JF3xyBydFOTgpNJHU+P1YZ/SlMxA7cbLa/ZbEl3lF+
         Ej7trJZk9G0AWPxcxmNHQ+zpUP2w4tYGPJSybpVB1hHU0F4vnnZyzAixpDOTXBD9EG
         Nr5MXBEOqOPpq4XiCztiVlQuXIOw5mO6RDLvJIbGClWL2L/tsOfm3qnhteaN7VEKOa
         8PZViQSXZ7nmg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next v3 4/6] xfrm: add TX datapath support for IPsec full offload mode
Date:   Tue, 23 Aug 2022 16:32:01 +0300
Message-Id: <d7b5afa45594beb1a60cba94c0e9e2b645c6a881.1661260787.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661260787.git.leonro@nvidia.com>
References: <cover.1661260787.git.leonro@nvidia.com>
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

In IPsec full mode, the device is going to encrypt and encapsulate
packets that are associated with offloaded policy. After successful
policy lookup to indicate if packets should be offloaded or not,
the stack forwards packets to the device to do the magic.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_device.c | 14 ++++++++++++--
 net/xfrm/xfrm_output.c | 12 +++++++++++-
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 1cc482e9c87d..2f0c2c6a1ed6 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -120,6 +120,16 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	if (xo->flags & XFRM_GRO || x->xso.dir == XFRM_DEV_OFFLOAD_IN)
 		return skb;
 
+	/* The packet was sent to HW IPsec full offload engine,
+	 * but to wrong device. Drop the packet, so it won't skip
+	 * XFRM stack.
+	 */
+	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL && x->xso.dev != dev) {
+		kfree_skb(skb);
+		dev_core_stats_tx_dropped_inc(dev);
+		return NULL;
+	}
+
 	/* This skb was already validated on the upper/virtual dev */
 	if ((x->xso.dev != dev) && (x->xso.real_dev == dev))
 		return skb;
@@ -369,8 +379,8 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 	if (!x->type_offload || x->encap)
 		return false;
 
-	if ((!dev || (dev == xfrm_dst_path(dst)->dev)) &&
-	    (!xdst->child->xfrm)) {
+	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL ||
+	    (!dev || (dev == xfrm_dst_path(dst)->dev)) && !xdst->child->xfrm) {
 		mtu = xfrm_state_mtu(x, xdst->child_mtu_cached);
 		if (skb->len <= mtu)
 			goto ok;
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 555ab35cd119..b554a98926bd 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -494,7 +494,7 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
 	struct xfrm_state *x = dst->xfrm;
 	struct net *net = xs_net(x);
 
-	if (err <= 0)
+	if (err <= 0 || x->xso.type == XFRM_DEV_OFFLOAD_FULL)
 		goto resume;
 
 	do {
@@ -719,6 +719,16 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		break;
 	}
 
+	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL) {
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
-- 
2.37.2

