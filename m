Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03FD5F21FA
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiJBIRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiJBIRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:17:32 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC853F1F9
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:17:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D99792053D;
        Sun,  2 Oct 2022 10:17:26 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LVV2am1KNqAz; Sun,  2 Oct 2022 10:17:26 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id F302B20571;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id E4A0480004A;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:17:23 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:17:22 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 1C9D53182A29; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 12/24] xfrm: add extack support to verify_newsa_info
Date:   Sun, 2 Oct 2022 10:17:00 +0200
Message-ID: <20221002081712.757515-13-steffen.klassert@secunet.com>
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
 net/xfrm/xfrm_user.c | 90 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 69 insertions(+), 21 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 772a051feedb..4167c189d35b 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -149,7 +149,8 @@ static inline int verify_replay(struct xfrm_usersa_info *p,
 }
 
 static int verify_newsa_info(struct xfrm_usersa_info *p,
-			     struct nlattr **attrs)
+			     struct nlattr **attrs,
+			     struct netlink_ext_ack *extack)
 {
 	int err;
 
@@ -163,10 +164,12 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		break;
 #else
 		err = -EAFNOSUPPORT;
+		NL_SET_ERR_MSG(extack, "IPv6 support disabled");
 		goto out;
 #endif
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid address family");
 		goto out;
 	}
 
@@ -175,65 +178,98 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		break;
 
 	case AF_INET:
-		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
+		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32) {
+			NL_SET_ERR_MSG(extack, "Invalid prefix length in selector (must be <= 32 for IPv4)");
 			goto out;
+		}
 
 		break;
 
 	case AF_INET6:
 #if IS_ENABLED(CONFIG_IPV6)
-		if (p->sel.prefixlen_d > 128 || p->sel.prefixlen_s > 128)
+		if (p->sel.prefixlen_d > 128 || p->sel.prefixlen_s > 128) {
+			NL_SET_ERR_MSG(extack, "Invalid prefix length in selector (must be <= 128 for IPv6)");
 			goto out;
+		}
 
 		break;
 #else
+		NL_SET_ERR_MSG(extack, "IPv6 support disabled");
 		err = -EAFNOSUPPORT;
 		goto out;
 #endif
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid address family in selector");
 		goto out;
 	}
 
 	err = -EINVAL;
 	switch (p->id.proto) {
 	case IPPROTO_AH:
-		if ((!attrs[XFRMA_ALG_AUTH]	&&
-		     !attrs[XFRMA_ALG_AUTH_TRUNC]) ||
-		    attrs[XFRMA_ALG_AEAD]	||
+		if (!attrs[XFRMA_ALG_AUTH]	&&
+		    !attrs[XFRMA_ALG_AUTH_TRUNC]) {
+			NL_SET_ERR_MSG(extack, "Missing required attribute for AH: AUTH_TRUNC or AUTH");
+			goto out;
+		}
+
+		if (attrs[XFRMA_ALG_AEAD]	||
 		    attrs[XFRMA_ALG_CRYPT]	||
 		    attrs[XFRMA_ALG_COMP]	||
-		    attrs[XFRMA_TFCPAD])
+		    attrs[XFRMA_TFCPAD]) {
+			NL_SET_ERR_MSG(extack, "Invalid attributes for AH: AEAD, CRYPT, COMP, TFCPAD");
 			goto out;
+		}
 		break;
 
 	case IPPROTO_ESP:
-		if (attrs[XFRMA_ALG_COMP])
+		if (attrs[XFRMA_ALG_COMP]) {
+			NL_SET_ERR_MSG(extack, "Invalid attribute for ESP: COMP");
 			goto out;
+		}
+
 		if (!attrs[XFRMA_ALG_AUTH] &&
 		    !attrs[XFRMA_ALG_AUTH_TRUNC] &&
 		    !attrs[XFRMA_ALG_CRYPT] &&
-		    !attrs[XFRMA_ALG_AEAD])
+		    !attrs[XFRMA_ALG_AEAD]) {
+			NL_SET_ERR_MSG(extack, "Missing required attribute for ESP: at least one of AUTH, AUTH_TRUNC, CRYPT, AEAD");
 			goto out;
+		}
+
 		if ((attrs[XFRMA_ALG_AUTH] ||
 		     attrs[XFRMA_ALG_AUTH_TRUNC] ||
 		     attrs[XFRMA_ALG_CRYPT]) &&
-		    attrs[XFRMA_ALG_AEAD])
+		    attrs[XFRMA_ALG_AEAD]) {
+			NL_SET_ERR_MSG(extack, "Invalid attribute combination for ESP: AEAD can't be used with AUTH, AUTH_TRUNC, CRYPT");
 			goto out;
+		}
+
 		if (attrs[XFRMA_TFCPAD] &&
-		    p->mode != XFRM_MODE_TUNNEL)
+		    p->mode != XFRM_MODE_TUNNEL) {
+			NL_SET_ERR_MSG(extack, "TFC padding can only be used in tunnel mode");
 			goto out;
+		}
 		break;
 
 	case IPPROTO_COMP:
-		if (!attrs[XFRMA_ALG_COMP]	||
-		    attrs[XFRMA_ALG_AEAD]	||
+		if (!attrs[XFRMA_ALG_COMP]) {
+			NL_SET_ERR_MSG(extack, "Missing required attribute for COMP: COMP");
+			goto out;
+		}
+
+		if (attrs[XFRMA_ALG_AEAD]	||
 		    attrs[XFRMA_ALG_AUTH]	||
 		    attrs[XFRMA_ALG_AUTH_TRUNC]	||
 		    attrs[XFRMA_ALG_CRYPT]	||
-		    attrs[XFRMA_TFCPAD]		||
-		    (ntohl(p->id.spi) >= 0x10000))
+		    attrs[XFRMA_TFCPAD]) {
+			NL_SET_ERR_MSG(extack, "Invalid attributes for COMP: AEAD, AUTH, AUTH_TRUNC, CRYPT, TFCPAD");
+			goto out;
+		}
+
+		if (ntohl(p->id.spi) >= 0x10000) {
+			NL_SET_ERR_MSG(extack, "SPI is too large for COMP (must be < 0x10000)");
 			goto out;
+		}
 		break;
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -246,13 +282,20 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		    attrs[XFRMA_ALG_CRYPT]	||
 		    attrs[XFRMA_ENCAP]		||
 		    attrs[XFRMA_SEC_CTX]	||
-		    attrs[XFRMA_TFCPAD]		||
-		    !attrs[XFRMA_COADDR])
+		    attrs[XFRMA_TFCPAD]) {
+			NL_SET_ERR_MSG(extack, "Invalid attributes for DSTOPTS/ROUTING");
+			goto out;
+		}
+
+		if (!attrs[XFRMA_COADDR]) {
+			NL_SET_ERR_MSG(extack, "Missing required COADDR attribute for DSTOPTS/ROUTING");
 			goto out;
+		}
 		break;
 #endif
 
 	default:
+		NL_SET_ERR_MSG(extack, "Unsupported protocol");
 		goto out;
 	}
 
@@ -266,7 +309,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		goto out;
 	if ((err = verify_one_alg(attrs, XFRMA_ALG_COMP)))
 		goto out;
-	if ((err = verify_sec_ctx_len(attrs, NULL)))
+	if ((err = verify_sec_ctx_len(attrs, extack)))
 		goto out;
 	if ((err = verify_replay(p, attrs)))
 		goto out;
@@ -280,14 +323,19 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		break;
 
 	default:
+		NL_SET_ERR_MSG(extack, "Unsupported mode");
 		goto out;
 	}
 
 	err = 0;
 
-	if (attrs[XFRMA_MTIMER_THRESH])
-		if (!attrs[XFRMA_ENCAP])
+	if (attrs[XFRMA_MTIMER_THRESH]) {
+		if (!attrs[XFRMA_ENCAP]) {
+			NL_SET_ERR_MSG(extack, "MTIMER_THRESH attribute can only be set on ENCAP states");
 			err = -EINVAL;
+			goto out;
+		}
+	}
 
 out:
 	return err;
@@ -688,7 +736,7 @@ static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int err;
 	struct km_event c;
 
-	err = verify_newsa_info(p, attrs);
+	err = verify_newsa_info(p, attrs, extack);
 	if (err)
 		return err;
 
-- 
2.25.1

