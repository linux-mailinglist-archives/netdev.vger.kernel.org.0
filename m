Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4EEB5A662F
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 16:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiH3OX6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Aug 2022 10:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiH3OXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 10:23:48 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D22EEC4E6
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 07:23:46 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-n2DuEj2UP4SAr4yLzUBwyQ-1; Tue, 30 Aug 2022 10:23:41 -0400
X-MC-Unique: n2DuEj2UP4SAr4yLzUBwyQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 914172999B43;
        Tue, 30 Aug 2022 14:23:41 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7FA0C4010D42;
        Tue, 30 Aug 2022 14:23:40 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 5/6] xfrm: add extack to validate_tmpl
Date:   Tue, 30 Aug 2022 16:23:11 +0200
Message-Id: <f5c01706a29424306338085788865b5c10147c1f.1661162395.git.sd@queasysnail.net>
In-Reply-To: <cover.1661162395.git.sd@queasysnail.net>
References: <cover.1661162395.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
2.37.2

