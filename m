Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE1C5F220A
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiJBIYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiJBIYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:24:06 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE1841D26
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:24:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C368A20561;
        Sun,  2 Oct 2022 10:24:00 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 81gK9Bo1Q0Ef; Sun,  2 Oct 2022 10:24:00 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 02E6120539;
        Sun,  2 Oct 2022 10:23:59 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id E86E880004A;
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
        id 3C85D3182A36; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 19/24] xfrm: pass extack down to xfrm_type ->init_state
Date:   Sun, 2 Oct 2022 10:17:07 +0200
Message-ID: <20221002081712.757515-20-steffen.klassert@secunet.com>
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
 include/net/xfrm.h      | 3 ++-
 net/ipv4/ah4.c          | 2 +-
 net/ipv4/esp4.c         | 2 +-
 net/ipv4/ipcomp.c       | 3 ++-
 net/ipv4/xfrm4_tunnel.c | 2 +-
 net/ipv6/ah6.c          | 2 +-
 net/ipv6/esp6.c         | 2 +-
 net/ipv6/ipcomp6.c      | 3 ++-
 net/ipv6/mip6.c         | 4 ++--
 net/ipv6/xfrm6_tunnel.c | 2 +-
 net/xfrm/xfrm_state.c   | 2 +-
 11 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c504d07bcb7c..dbc81f5eb553 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -405,7 +405,8 @@ struct xfrm_type {
 #define XFRM_TYPE_LOCAL_COADDR	4
 #define XFRM_TYPE_REMOTE_COADDR	8
 
-	int			(*init_state)(struct xfrm_state *x);
+	int			(*init_state)(struct xfrm_state *x,
+					      struct netlink_ext_ack *extack);
 	void			(*destructor)(struct xfrm_state *);
 	int			(*input)(struct xfrm_state *, struct sk_buff *skb);
 	int			(*output)(struct xfrm_state *, struct sk_buff *pskb);
diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index f8ad04470d3a..babefff15de3 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -471,7 +471,7 @@ static int ah4_err(struct sk_buff *skb, u32 info)
 	return 0;
 }
 
-static int ah_init_state(struct xfrm_state *x)
+static int ah_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	struct ah_data *ahp = NULL;
 	struct xfrm_algo_desc *aalg_desc;
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 5c03eba787e5..bc2b2c5717b5 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -1131,7 +1131,7 @@ static int esp_init_authenc(struct xfrm_state *x)
 	return err;
 }
 
-static int esp_init_state(struct xfrm_state *x)
+static int esp_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	struct crypto_aead *aead;
 	u32 align;
diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index 366094c1ce6c..230d1120874f 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -117,7 +117,8 @@ static int ipcomp_tunnel_attach(struct xfrm_state *x)
 	return err;
 }
 
-static int ipcomp4_init_state(struct xfrm_state *x)
+static int ipcomp4_init_state(struct xfrm_state *x,
+			      struct netlink_ext_ack *extack)
 {
 	int err = -EINVAL;
 
diff --git a/net/ipv4/xfrm4_tunnel.c b/net/ipv4/xfrm4_tunnel.c
index 9d4f418f1bf8..08826e0d7962 100644
--- a/net/ipv4/xfrm4_tunnel.c
+++ b/net/ipv4/xfrm4_tunnel.c
@@ -22,7 +22,7 @@ static int ipip_xfrm_rcv(struct xfrm_state *x, struct sk_buff *skb)
 	return ip_hdr(skb)->protocol;
 }
 
-static int ipip_init_state(struct xfrm_state *x)
+static int ipip_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	if (x->props.mode != XFRM_MODE_TUNNEL)
 		return -EINVAL;
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index b5995c1f4d7a..f5bc0d4b37ad 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -666,7 +666,7 @@ static int ah6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	return 0;
 }
 
-static int ah6_init_state(struct xfrm_state *x)
+static int ah6_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	struct ah_data *ahp = NULL;
 	struct xfrm_algo_desc *aalg_desc;
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 8220923a12f7..2ca9b7b7e500 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -1174,7 +1174,7 @@ static int esp_init_authenc(struct xfrm_state *x)
 	return err;
 }
 
-static int esp6_init_state(struct xfrm_state *x)
+static int esp6_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	struct crypto_aead *aead;
 	u32 align;
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 15f984be3570..7e47009739e9 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -136,7 +136,8 @@ static int ipcomp6_tunnel_attach(struct xfrm_state *x)
 	return err;
 }
 
-static int ipcomp6_init_state(struct xfrm_state *x)
+static int ipcomp6_init_state(struct xfrm_state *x,
+			      struct netlink_ext_ack *extack)
 {
 	int err = -EINVAL;
 
diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
index aeb35d26e474..3d87ae88ebfd 100644
--- a/net/ipv6/mip6.c
+++ b/net/ipv6/mip6.c
@@ -247,7 +247,7 @@ static int mip6_destopt_reject(struct xfrm_state *x, struct sk_buff *skb,
 	return err;
 }
 
-static int mip6_destopt_init_state(struct xfrm_state *x)
+static int mip6_destopt_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	if (x->id.spi) {
 		pr_info("%s: spi is not 0: %u\n", __func__, x->id.spi);
@@ -333,7 +333,7 @@ static int mip6_rthdr_output(struct xfrm_state *x, struct sk_buff *skb)
 	return 0;
 }
 
-static int mip6_rthdr_init_state(struct xfrm_state *x)
+static int mip6_rthdr_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	if (x->id.spi) {
 		pr_info("%s: spi is not 0: %u\n", __func__, x->id.spi);
diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 2b31112c0856..dda44b0671ac 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -270,7 +270,7 @@ static int xfrm6_tunnel_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	return 0;
 }
 
-static int xfrm6_tunnel_init_state(struct xfrm_state *x)
+static int xfrm6_tunnel_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	if (x->props.mode != XFRM_MODE_TUNNEL)
 		return -EINVAL;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 0b59ff7985e6..82c571d07836 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2673,7 +2673,7 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
 
 	x->type_offload = xfrm_get_type_offload(x->id.proto, family, offload);
 
-	err = x->type->init_state(x);
+	err = x->type->init_state(x, extack);
 	if (err)
 		goto error;
 
-- 
2.25.1

