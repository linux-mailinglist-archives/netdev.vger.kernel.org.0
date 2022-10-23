Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7C1609293
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 14:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiJWMGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 08:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiJWMGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 08:06:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BAE59EA9
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 05:06:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43B8C60AFB
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 12:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC20BC433D7;
        Sun, 23 Oct 2022 12:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666526792;
        bh=AHpV9fzwepCYxd+t9ITgxq3MFnbP2Kw3PLKq1IqRhjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAFoa9xN3SOGnaOFu926pJfkQduH9KGLyEDcia4O0MxlB2kGGGpmIQRTTi4jcMby1
         gkjOKqUKp0hH78yiMXBrLaszJhWQ8UAON3ImLzB98NCUeX5cTrVAWsU7vXOS9Ebr+5
         XI3QQJ5yV97rusvZEZxnhE3F106ondYIb958MFBVOtHf41SaCDE+URmbDhE5/usF6y
         ixkLVNxvzuIuc9zcIZxvYJCroCRTtV/Lvx4udjbZm9R3JM8WosUend4IquZ3nTLG9d
         GjOTTcTW6WJekILJisRsdknylmDrzqmyQ0qobGNIF5BneIeE44Wif6nrfAhOy+vBM/
         IMV8LYgtSAeSQ==
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
Subject: [PATCH xfrm-next v5 4/8] xfrm: add TX datapath support for IPsec full offload mode
Date:   Sun, 23 Oct 2022 15:05:56 +0300
Message-Id: <89923ed3ff624c67edf7f3e742a035f70b65dabd.1666525321.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666525321.git.leonro@nvidia.com>
References: <cover.1666525321.git.leonro@nvidia.com>
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

In IPsec full mode, the device is going to encrypt and encapsulate
packets that are associated with offloaded policy. After successful
policy lookup to indicate if packets should be offloaded or not,
the stack forwards packets to the device to do the magic.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_device.c | 15 +++++++++++++--
 net/xfrm/xfrm_output.c | 12 +++++++++++-
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index b5c6a78fdac2..783750998e80 100644
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
@@ -385,8 +395,9 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 	if (!x->type_offload || x->encap)
 		return false;
 
-	if ((!dev || (dev == xfrm_dst_path(dst)->dev)) &&
-	    (!xdst->child->xfrm)) {
+	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL ||
+	    ((!dev || (dev == xfrm_dst_path(dst)->dev)) &&
+	     !xdst->child->xfrm)) {
 		mtu = xfrm_state_mtu(x, xdst->child_mtu_cached);
 		if (skb->len <= mtu)
 			goto ok;
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 9a5e79a38c67..dde009be8463 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -494,7 +494,7 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
 	struct xfrm_state *x = dst->xfrm;
 	struct net *net = xs_net(x);
 
-	if (err <= 0)
+	if (err <= 0 || x->xso.type == XFRM_DEV_OFFLOAD_FULL)
 		goto resume;
 
 	do {
@@ -718,6 +718,16 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
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
2.37.3

