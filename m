Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346475F2205
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJBIYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiJBIYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:24:03 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D8641D22
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:24:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A467320549;
        Sun,  2 Oct 2022 10:23:59 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XkAPm2UQNfCM; Sun,  2 Oct 2022 10:23:59 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9AB4120519;
        Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 8BC9E80004A;
        Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:23:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:23:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 49AE33182A43; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 22/24] xfrm: tunnel: add extack to ipip_init_state, xfrm6_tunnel_init_state
Date:   Sun, 2 Oct 2022 10:17:10 +0200
Message-ID: <20221002081712.757515-23-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221002081712.757515-1-steffen.klassert@secunet.com>
References: <20221002081712.757515-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
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
 net/ipv4/xfrm4_tunnel.c | 8 ++++++--
 net/ipv6/xfrm6_tunnel.c | 8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/xfrm4_tunnel.c b/net/ipv4/xfrm4_tunnel.c
index 08826e0d7962..8489fa106583 100644
--- a/net/ipv4/xfrm4_tunnel.c
+++ b/net/ipv4/xfrm4_tunnel.c
@@ -24,11 +24,15 @@ static int ipip_xfrm_rcv(struct xfrm_state *x, struct sk_buff *skb)
 
 static int ipip_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
-	if (x->props.mode != XFRM_MODE_TUNNEL)
+	if (x->props.mode != XFRM_MODE_TUNNEL) {
+		NL_SET_ERR_MSG(extack, "IPv4 tunnel can only be used with tunnel mode");
 		return -EINVAL;
+	}
 
-	if (x->encap)
+	if (x->encap) {
+		NL_SET_ERR_MSG(extack, "IPv4 tunnel is not compatible with encapsulation");
 		return -EINVAL;
+	}
 
 	x->props.header_len = sizeof(struct iphdr);
 
diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index dda44b0671ac..1323f2f6928e 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -272,11 +272,15 @@ static int xfrm6_tunnel_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 static int xfrm6_tunnel_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
-	if (x->props.mode != XFRM_MODE_TUNNEL)
+	if (x->props.mode != XFRM_MODE_TUNNEL) {
+		NL_SET_ERR_MSG(extack, "IPv6 tunnel can only be used with tunnel mode");
 		return -EINVAL;
+	}
 
-	if (x->encap)
+	if (x->encap) {
+		NL_SET_ERR_MSG(extack, "IPv6 tunnel is not compatible with encapsulation");
 		return -EINVAL;
+	}
 
 	x->props.header_len = sizeof(struct ipv6hdr);
 
-- 
2.25.1

