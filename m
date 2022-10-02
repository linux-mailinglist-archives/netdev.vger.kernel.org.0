Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62DB5F220B
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiJBIYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiJBIYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:24:06 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FAB41D31
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:24:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4395B2053B;
        Sun,  2 Oct 2022 10:24:00 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SwbL-oOBcL1H; Sun,  2 Oct 2022 10:23:59 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DC14A20569;
        Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id CD36C80004A;
        Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:23:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:23:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 347ED3182A32; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 17/24] xfrm: add extack to __xfrm_init_state
Date:   Sun, 2 Oct 2022 10:17:05 +0200
Message-ID: <20221002081712.757515-18-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221002081712.757515-1-steffen.klassert@secunet.com>
References: <20221002081712.757515-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h    |  3 ++-
 net/xfrm/xfrm_state.c | 26 +++++++++++++++++++-------
 net/xfrm/xfrm_user.c  |  2 +-
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 9c1cccf85f12..f427a74d571b 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1582,7 +1582,8 @@ void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
 int xfrm_init_replay(struct xfrm_state *x);
 u32 xfrm_state_mtu(struct xfrm_state *x, int mtu);
-int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload);
+int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
+		      struct netlink_ext_ack *extack);
 int xfrm_init_state(struct xfrm_state *x);
 int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type);
 int xfrm_input_resume(struct sk_buff *skb, int nexthdr);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 52e60e607f8a..7470d2474796 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2610,7 +2610,8 @@ u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 }
 EXPORT_SYMBOL_GPL(xfrm_state_mtu);
 
-int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
+int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
+		      struct netlink_ext_ack *extack)
 {
 	const struct xfrm_mode *inner_mode;
 	const struct xfrm_mode *outer_mode;
@@ -2625,12 +2626,16 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 
 	if (x->sel.family != AF_UNSPEC) {
 		inner_mode = xfrm_get_mode(x->props.mode, x->sel.family);
-		if (inner_mode == NULL)
+		if (inner_mode == NULL) {
+			NL_SET_ERR_MSG(extack, "Requested mode not found");
 			goto error;
+		}
 
 		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL) &&
-		    family != x->sel.family)
+		    family != x->sel.family) {
+			NL_SET_ERR_MSG(extack, "Only tunnel modes can accommodate a change of family");
 			goto error;
+		}
 
 		x->inner_mode = *inner_mode;
 	} else {
@@ -2638,11 +2643,15 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 		int iafamily = AF_INET;
 
 		inner_mode = xfrm_get_mode(x->props.mode, x->props.family);
-		if (inner_mode == NULL)
+		if (inner_mode == NULL) {
+			NL_SET_ERR_MSG(extack, "Requested mode not found");
 			goto error;
+		}
 
-		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL))
+		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL)) {
+			NL_SET_ERR_MSG(extack, "Only tunnel modes can accommodate an AF_UNSPEC selector");
 			goto error;
+		}
 
 		x->inner_mode = *inner_mode;
 
@@ -2657,8 +2666,10 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 	}
 
 	x->type = xfrm_get_type(x->id.proto, family);
-	if (x->type == NULL)
+	if (x->type == NULL) {
+		NL_SET_ERR_MSG(extack, "Requested type not found");
 		goto error;
+	}
 
 	x->type_offload = xfrm_get_type_offload(x->id.proto, family, offload);
 
@@ -2668,6 +2679,7 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 
 	outer_mode = xfrm_get_mode(x->props.mode, family);
 	if (!outer_mode) {
+		NL_SET_ERR_MSG(extack, "Requested mode not found");
 		err = -EPROTONOSUPPORT;
 		goto error;
 	}
@@ -2689,7 +2701,7 @@ int xfrm_init_state(struct xfrm_state *x)
 {
 	int err;
 
-	err = __xfrm_init_state(x, true, false);
+	err = __xfrm_init_state(x, true, false, NULL);
 	if (!err)
 		x->km.state = XFRM_STATE_VALID;
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 2cf5956b562e..14e9b84f9dad 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -721,7 +721,7 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 	if (attrs[XFRMA_IF_ID])
 		x->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
 
-	err = __xfrm_init_state(x, false, attrs[XFRMA_OFFLOAD_DEV]);
+	err = __xfrm_init_state(x, false, attrs[XFRMA_OFFLOAD_DEV], extack);
 	if (err)
 		goto error;
 
-- 
2.25.1

