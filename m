Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34857595995
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbiHPLMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbiHPLLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:11:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA575FDA
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 02:00:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B9D66CE1702
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75E1C433D6;
        Tue, 16 Aug 2022 08:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660640398;
        bh=dFX+xHSSSWtI0tWSLbuatDBneNSEm5tbh6OzqlMnT4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FVgcJ6/6xPlzU2JaCqJhNIU+wt+GTQVlcz2grVw7HsivjndUTw6npj12XNx/9n2rW
         EBKPZ3/yciB/f+7WUGEjbHvoAUR7euKaSjrdusuhAC2zjFcBvVEK18FeVFXAOAgXJJ
         ml6d1qo2GtnTK0hAoUgegc0h+7FwpPod7d14p+F3hK1J30IxjPAZqv/lEe+XKQz5mB
         gc9xGnqYmK28jreGOhGIjZsBXWdVbL6RbsiVIDlIDJnkYI2rQO9TKrZGdssL2DGLOX
         00l5Unm0tx5hDZYb+7zMBMBrQd8V30k4VNKiWm1qG6HKmB/O8Ol88Of0JiacfOrd1d
         WTMynZmJr+o0A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next v2 5/6] xfrm: add RX datapath protection for IPsec full offload mode
Date:   Tue, 16 Aug 2022 11:59:26 +0300
Message-Id: <8264ad13665f510b081764131b1f23ade32c7578.1660639789.git.leonro@nvidia.com>
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

Traffic received by device with enabled IPsec full offload should be
forwarded to the stack only after decryption, packet headers and
trailers removed.

Such packets are expected to be seen as normal (non-XFRM) ones, while
not-supported packets should be dropped by the HW.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/xfrm.h | 55 +++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 587697eb1d31..b64853df7262 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1094,6 +1094,29 @@ xfrm_state_addr_cmp(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x, un
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
@@ -1125,6 +1148,15 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 {
 	struct net *net = dev_net(skb->dev);
 	int ndir = dir | (reverse ? XFRM_POLICY_MASK + 1 : 0);
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	struct xfrm_state *x;
+
+	if (xo) {
+		x = xfrm_input_state(skb);
+		if (x->xso.type == XFRM_DEV_OFFLOAD_FULL)
+			return (xo->flags & CRYPTO_DONE) &&
+			       (xo->status & CRYPTO_SUCCESS);
+	}
 
 	if (sk && sk->sk_policy[XFRM_POLICY_IN])
 		return __xfrm_policy_check(sk, ndir, skb, family);
@@ -1860,29 +1892,6 @@ static inline void xfrm_states_delete(struct xfrm_state **states, int n)
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
2.37.2

