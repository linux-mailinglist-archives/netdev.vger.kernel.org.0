Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0AE622BEF
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 13:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiKIMzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 07:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiKIMy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 07:54:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6318B2495E
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 04:54:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C689861A87
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA15C433D6;
        Wed,  9 Nov 2022 12:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667998496;
        bh=jqKDySuwsef5aF9XrBVOEIwG8N8/BWc1llip0fwIOl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=man8cZQUa0GDsNOAUTMTdubXcOGWyGLhaS6EJ6Mkkabq8ERa9QIuiFP7ziF/Y/9ga
         YZTpkFFpMxdJY82h95dK0N4jaA9JVEbtkFIwql6E7Qk7PfQYDtam4yRhEclO0hAB2x
         7ksbis5bNopMa15RS9XHojORrU2yCO/mcb/HkQdbauSphvu2dVSmLGcA7KKkVmJAeh
         RVxVD6zoqMWrFPgsBQ38R5Kn8HfphwgFhY1MxR/Mb9YTafo99ERHR6Z8+ke5DlfJGe
         t8TGN4uDQLB9iCf84O/m/4KndY1axoMkMINJr37jIb80LTyh2M2dTDSJAghmIun1/s
         AtXWkv2/t3b6g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH xfrm-next v7 5/8] xfrm: add RX datapath protection for IPsec packet offload mode
Date:   Wed,  9 Nov 2022 14:54:33 +0200
Message-Id: <92f1b5b99c7d0d1c30f7a802885b9072bb7f38aa.1667997522.git.leonro@nvidia.com>
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

Traffic received by device with enabled IPsec packet offload should
be forwarded to the stack only after decryption, packet headers and
trailers removed.

Such packets are expected to be seen as normal (non-XFRM) ones, while
not-supported packets should be dropped by the HW.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/xfrm.h | 55 +++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index e9c0cc245623..00ce7a68bf3c 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1102,6 +1102,29 @@ xfrm_state_addr_cmp(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x, un
 	return !0;
 }
 
+#ifdef CONFIG_XFRM
+static inline struct xfrm_state *xfrm_input_state(struct sk_buff *skb)
+{
+	struct sec_path *sp = skb_sec_path(skb);
+
+	return sp->xvec[sp->len - 1];
+}
+#endif
+
+static inline struct xfrm_offload *xfrm_offload(struct sk_buff *skb)
+{
+#ifdef CONFIG_XFRM
+	struct sec_path *sp = skb_sec_path(skb);
+
+	if (!sp || !sp->olen || sp->len != sp->olen)
+		return NULL;
+
+	return &sp->ovec[sp->olen - 1];
+#else
+	return NULL;
+#endif
+}
+
 #ifdef CONFIG_XFRM
 int __xfrm_policy_check(struct sock *, int dir, struct sk_buff *skb,
 			unsigned short family);
@@ -1133,10 +1156,19 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 {
 	struct net *net = dev_net(skb->dev);
 	int ndir = dir | (reverse ? XFRM_POLICY_MASK + 1 : 0);
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	struct xfrm_state *x;
 
 	if (sk && sk->sk_policy[XFRM_POLICY_IN])
 		return __xfrm_policy_check(sk, ndir, skb, family);
 
+	if (xo) {
+		x = xfrm_input_state(skb);
+		if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET)
+			return (xo->flags & CRYPTO_DONE) &&
+			       (xo->status & CRYPTO_SUCCESS);
+	}
+
 	return __xfrm_check_nopolicy(net, skb, dir) ||
 	       __xfrm_check_dev_nopolicy(skb, dir, family) ||
 	       __xfrm_policy_check(sk, ndir, skb, family);
@@ -1870,29 +1902,6 @@ static inline void xfrm_states_delete(struct xfrm_state **states, int n)
 }
 #endif
 
-#ifdef CONFIG_XFRM
-static inline struct xfrm_state *xfrm_input_state(struct sk_buff *skb)
-{
-	struct sec_path *sp = skb_sec_path(skb);
-
-	return sp->xvec[sp->len - 1];
-}
-#endif
-
-static inline struct xfrm_offload *xfrm_offload(struct sk_buff *skb)
-{
-#ifdef CONFIG_XFRM
-	struct sec_path *sp = skb_sec_path(skb);
-
-	if (!sp || !sp->olen || sp->len != sp->olen)
-		return NULL;
-
-	return &sp->ovec[sp->olen - 1];
-#else
-	return NULL;
-#endif
-}
-
 void __init xfrm_dev_init(void);
 
 #ifdef CONFIG_XFRM_OFFLOAD
-- 
2.38.1

