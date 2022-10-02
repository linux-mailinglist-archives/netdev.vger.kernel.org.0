Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E39B5F2203
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiJBIYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiJBIYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:24:03 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E80727DF5
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:24:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2792C20547;
        Sun,  2 Oct 2022 10:23:59 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2RF0FH5ZAYjz; Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 596EF2053D;
        Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 4AC3F80004A;
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
        id 4E08B3182A44; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 23/24] xfrm: ipcomp: add extack to ipcomp{4,6}_init_state
Date:   Sun, 2 Oct 2022 10:17:11 +0200
Message-ID: <20221002081712.757515-24-steffen.klassert@secunet.com>
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

And the shared helper ipcomp_init_state.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/ipcomp.h   |  2 +-
 net/ipv4/ipcomp.c      |  7 +++++--
 net/ipv6/ipcomp6.c     |  7 +++++--
 net/xfrm/xfrm_ipcomp.c | 10 +++++++---
 4 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/net/ipcomp.h b/include/net/ipcomp.h
index c31108295079..8660a2a6d1fc 100644
--- a/include/net/ipcomp.h
+++ b/include/net/ipcomp.h
@@ -22,7 +22,7 @@ struct xfrm_state;
 int ipcomp_input(struct xfrm_state *x, struct sk_buff *skb);
 int ipcomp_output(struct xfrm_state *x, struct sk_buff *skb);
 void ipcomp_destroy(struct xfrm_state *x);
-int ipcomp_init_state(struct xfrm_state *x);
+int ipcomp_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack);
 
 static inline struct ip_comp_hdr *ip_comp_hdr(const struct sk_buff *skb)
 {
diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index 230d1120874f..5a4fb2539b08 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -130,17 +130,20 @@ static int ipcomp4_init_state(struct xfrm_state *x,
 		x->props.header_len += sizeof(struct iphdr);
 		break;
 	default:
+		NL_SET_ERR_MSG(extack, "Unsupported XFRM mode for IPcomp");
 		goto out;
 	}
 
-	err = ipcomp_init_state(x);
+	err = ipcomp_init_state(x, extack);
 	if (err)
 		goto out;
 
 	if (x->props.mode == XFRM_MODE_TUNNEL) {
 		err = ipcomp_tunnel_attach(x);
-		if (err)
+		if (err) {
+			NL_SET_ERR_MSG(extack, "Kernel error: failed to initialize the associated state");
 			goto out;
+		}
 	}
 
 	err = 0;
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 7e47009739e9..72d4858dec18 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -149,17 +149,20 @@ static int ipcomp6_init_state(struct xfrm_state *x,
 		x->props.header_len += sizeof(struct ipv6hdr);
 		break;
 	default:
+		NL_SET_ERR_MSG(extack, "Unsupported XFRM mode for IPcomp");
 		goto out;
 	}
 
-	err = ipcomp_init_state(x);
+	err = ipcomp_init_state(x, extack);
 	if (err)
 		goto out;
 
 	if (x->props.mode == XFRM_MODE_TUNNEL) {
 		err = ipcomp6_tunnel_attach(x);
-		if (err)
+		if (err) {
+			NL_SET_ERR_MSG(extack, "Kernel error: failed to initialize the associated state");
 			goto out;
+		}
 	}
 
 	err = 0;
diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index cb40ff0ff28d..656045a87606 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -325,18 +325,22 @@ void ipcomp_destroy(struct xfrm_state *x)
 }
 EXPORT_SYMBOL_GPL(ipcomp_destroy);
 
-int ipcomp_init_state(struct xfrm_state *x)
+int ipcomp_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	int err;
 	struct ipcomp_data *ipcd;
 	struct xfrm_algo_desc *calg_desc;
 
 	err = -EINVAL;
-	if (!x->calg)
+	if (!x->calg) {
+		NL_SET_ERR_MSG(extack, "Missing required compression algorithm");
 		goto out;
+	}
 
-	if (x->encap)
+	if (x->encap) {
+		NL_SET_ERR_MSG(extack, "IPComp is not compatible with encapsulation");
 		goto out;
+	}
 
 	err = -ENOMEM;
 	ipcd = kzalloc(sizeof(*ipcd), GFP_KERNEL);
-- 
2.25.1

