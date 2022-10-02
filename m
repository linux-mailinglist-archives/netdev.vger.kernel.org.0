Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD565F2213
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiJBIeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiJBIeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:34:02 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684584CA03
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:34:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B52352053B;
        Sun,  2 Oct 2022 10:33:59 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j7sJYaM1Ch4R; Sun,  2 Oct 2022 10:33:59 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id CB97C20549;
        Sun,  2 Oct 2022 10:33:58 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id BC31E80004A;
        Sun,  2 Oct 2022 10:33:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:33:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:33:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 1204A3182A22; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 10/24] xfrm: add extack to validate_tmpl
Date:   Sun, 2 Oct 2022 10:16:58 +0200
Message-ID: <20221002081712.757515-11-steffen.klassert@secunet.com>
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
 net/xfrm/xfrm_user.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 0f2a2aa1e289..9fd30914f1ff 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1616,13 +1616,16 @@ static void copy_templates(struct xfrm_policy *xp, struct xfrm_user_tmpl *ut,
 	}
 }
 
-static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family)
+static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family,
+			 struct netlink_ext_ack *extack)
 {
 	u16 prev_family;
 	int i;
 
-	if (nr > XFRM_MAX_DEPTH)
+	if (nr > XFRM_MAX_DEPTH) {
+		NL_SET_ERR_MSG(extack, "Template count must be <= XFRM_MAX_DEPTH (" __stringify(XFRM_MAX_DEPTH) ")");
 		return -EINVAL;
+	}
 
 	prev_family = family;
 
@@ -1642,12 +1645,16 @@ static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family)
 		case XFRM_MODE_BEET:
 			break;
 		default:
-			if (ut[i].family != prev_family)
+			if (ut[i].family != prev_family) {
+				NL_SET_ERR_MSG(extack, "Mode in template doesn't support a family change");
 				return -EINVAL;
+			}
 			break;
 		}
-		if (ut[i].mode >= XFRM_MODE_MAX)
+		if (ut[i].mode >= XFRM_MODE_MAX) {
+			NL_SET_ERR_MSG(extack, "Mode in template must be < XFRM_MODE_MAX (" __stringify(XFRM_MODE_MAX) ")");
 			return -EINVAL;
+		}
 
 		prev_family = ut[i].family;
 
@@ -1659,17 +1666,21 @@ static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family)
 			break;
 #endif
 		default:
+			NL_SET_ERR_MSG(extack, "Invalid family in template");
 			return -EINVAL;
 		}
 
-		if (!xfrm_id_proto_valid(ut[i].id.proto))
+		if (!xfrm_id_proto_valid(ut[i].id.proto)) {
+			NL_SET_ERR_MSG(extack, "Invalid XFRM protocol in template");
 			return -EINVAL;
+		}
 	}
 
 	return 0;
 }
 
-static int copy_from_user_tmpl(struct xfrm_policy *pol, struct nlattr **attrs)
+static int copy_from_user_tmpl(struct xfrm_policy *pol, struct nlattr **attrs,
+			       struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[XFRMA_TMPL];
 
@@ -1680,7 +1691,7 @@ static int copy_from_user_tmpl(struct xfrm_policy *pol, struct nlattr **attrs)
 		int nr = nla_len(rt) / sizeof(*utmpl);
 		int err;
 
-		err = validate_tmpl(nr, utmpl, pol->family);
+		err = validate_tmpl(nr, utmpl, pol->family, extack);
 		if (err)
 			return err;
 
@@ -1757,7 +1768,7 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net,
 	if (err)
 		goto error;
 
-	if (!(err = copy_from_user_tmpl(xp, attrs)))
+	if (!(err = copy_from_user_tmpl(xp, attrs, extack)))
 		err = copy_from_user_sec_ctx(xp, attrs);
 	if (err)
 		goto error;
@@ -3306,7 +3317,7 @@ static struct xfrm_policy *xfrm_compile_policy(struct sock *sk, int opt,
 		return NULL;
 
 	nr = ((len - sizeof(*p)) / sizeof(*ut));
-	if (validate_tmpl(nr, ut, p->sel.family))
+	if (validate_tmpl(nr, ut, p->sel.family, NULL))
 		return NULL;
 
 	if (p->dir > XFRM_POLICY_OUT)
-- 
2.25.1

