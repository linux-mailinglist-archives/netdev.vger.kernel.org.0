Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2D0640DAB
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbiLBSoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbiLBSng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:43:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748BCDBF6F
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:42:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1075062387
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB789C433D6;
        Fri,  2 Dec 2022 18:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670006529;
        bh=TShb/E0XrR3CFBqyQHdsb6TgL1ZwTUYNPmaTunTiOGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFgSSDNfwSFrIUJgpxE3JGjQ/JIxKJ6G6RI/B2Dz+lrjWhGxT39m2a5sUPNzGyU1G
         9M2Aecax51yH4o2pRHm9O/rEpmaVYx9gEBNytBJuPlwBJPR76MeeYYschm5SzTlFvZ
         j0MILpnRidkE+l1UKMyEuHOPAGnIvAfnmkurcqv7AGG27yi87DjVeGnNLo27O7PcMC
         dmS017RsClOV7Cv2R7dOhiO5Z/MYaxbhP77pwvWp+H0cE7Czk1pcTHo7f+GHCyVVO7
         qk1KJji2ko9yGl9nAOFSzSYZQBMt0lfxWrqDzjh+r27GjK64w6ufzwHGKBCQhIs88q
         UuTcEpVXqGqJw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH xfrm-next v10 5/8] xfrm: add RX datapath protection for IPsec packet offload mode
Date:   Fri,  2 Dec 2022 20:41:31 +0200
Message-Id: <183716b45082e7294377b2b0210d88ec9d154393.1670005543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670005543.git.leonro@nvidia.com>
References: <cover.1670005543.git.leonro@nvidia.com>
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
index 6fea34cbdf48..b6ee14991a32 100644
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
@@ -1872,29 +1904,6 @@ static inline void xfrm_states_delete(struct xfrm_state **states, int n)
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

