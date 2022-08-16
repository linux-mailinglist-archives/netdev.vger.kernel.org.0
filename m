Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA5B59575B
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiHPJ7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbiHPJ7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:59:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F22B12618
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A29E61215
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1282C433C1;
        Tue, 16 Aug 2022 08:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660640386;
        bh=ntahS3N5EcLzj5YGLLrlNwpgmWnPaAuR6voukNuZg8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q40qtwM6T9AVJyp3BnUn+pMnZr0reUpmzcmNhZvGy5ggumruB8JbGTlOw0uwemVxa
         aJUpI0WXPKoZBIKWW5zJT3n7WOFJ/fzs4qCvOnAw/Xe8s7WwhOQpc0ZjFhRCcp1Qyg
         yoq83sRyLNB+YQzS0fnRacf/+FwhDd0UJFV4M7a+YIsrvVMJWuo/OX8zcwBlYFHBmS
         xtRRA5WbxiViCRZ8/EYpO4c+wvSLpZ/YNDH+B0zymOhXZy9Uw0Z/ggyWa8QLIC1gAC
         G7yD9mDelMT29W4nlzBJ4nwYUj9KLP0GvLuKXPAkbMOOTGGpWgjbQ9VLXvGSUrbbup
         GFnkm04E214wA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next v2 4/6] xfrm: add TX datapath support for IPsec full offload mode
Date:   Tue, 16 Aug 2022 11:59:25 +0300
Message-Id: <aa0b418e5bccb0b32625f8615124c8d0e58d9980.1660639789.git.leonro@nvidia.com>
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

In IPsec full mode, the device is going to encrypt and encapsulate
packets that are associated with offloaded policy. After successful
policy lookup to indicate if packets should be offloaded or not,
the stack forwards packets to the device to do the magic.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_device.c | 13 +++++++++++++
 net/xfrm/xfrm_output.c | 20 ++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 1cc482e9c87d..db5ebd36f68c 100644
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
@@ -366,6 +376,9 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
 	struct net_device *dev = x->xso.dev;
 
+	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL)
+		goto ok;
+
 	if (!x->type_offload || x->encap)
 		return false;
 
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 555ab35cd119..27a8dac9ca7d 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -719,6 +719,26 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		break;
 	}
 
+	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL) {
+		struct dst_entry *dst = skb_dst_pop(skb);
+
+		if (!dst || !xfrm_dev_offload_ok(skb, x)) {
+			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
+			kfree_skb(skb);
+			return -EHOSTUNREACH;
+		}
+
+		skb_dst_set(skb, dst);
+		err = skb_dst(skb)->ops->local_out(net, skb->sk, skb);
+		if (unlikely(err != 1))
+			return err;
+
+		if (!skb_dst(skb)->xfrm)
+			return dst_output(net, skb->sk, skb);
+
+		return 0;
+	}
+
 	secpath_reset(skb);
 
 	if (xfrm_dev_offload_ok(skb, x)) {
-- 
2.37.2

