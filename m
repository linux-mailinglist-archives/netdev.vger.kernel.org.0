Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A2D5B8DCC
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiINRFA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Sep 2022 13:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiINREz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:04:55 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F85140D2
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:04:49 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-5UVz5G9UM8StgQuIHvKbpA-1; Wed, 14 Sep 2022 13:04:43 -0400
X-MC-Unique: 5UVz5G9UM8StgQuIHvKbpA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBA6F1C04B4F;
        Wed, 14 Sep 2022 17:04:42 +0000 (UTC)
Received: from hog.localdomain (unknown [10.40.195.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E83D31121314;
        Wed, 14 Sep 2022 17:04:41 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 1/7] xfrm: add extack support to verify_newsa_info
Date:   Wed, 14 Sep 2022 19:04:00 +0200
Message-Id: <b492239e903e8491abfd91178b572b59a48851e3.1663103634.git.sd@queasysnail.net>
In-Reply-To: <cover.1663103634.git.sd@queasysnail.net>
References: <cover.1663103634.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
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
2.37.3

