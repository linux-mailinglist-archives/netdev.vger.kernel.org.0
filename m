Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA1C44D64C
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 13:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhKKMGQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Nov 2021 07:06:16 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:56309 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230358AbhKKMGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 07:06:14 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-HEf_QjZINDWolM9s30xiXA-1; Thu, 11 Nov 2021 07:03:07 -0500
X-MC-Unique: HEf_QjZINDWolM9s30xiXA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F7781923761;
        Thu, 11 Nov 2021 12:03:06 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 914731017CF3;
        Thu, 11 Nov 2021 12:03:05 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [RFC PATCH ipsec-next 4/6] xfrm: add extack to validate_tmpl
Date:   Thu, 11 Nov 2021 13:02:45 +0100
Message-Id: <3f08a71ca86f662d1905dc957266a029ccfa3485.1636450303.git.sd@queasysnail.net>
In-Reply-To: <cover.1636450303.git.sd@queasysnail.net>
References: <cover.1636450303.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/xfrm_user.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index e8d790967ff3..1cd3e1e316da 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1600,13 +1600,16 @@ static void copy_templates(struct xfrm_policy *xp, struct xfrm_user_tmpl *ut,
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
 
@@ -1626,12 +1629,16 @@ static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family)
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
 
@@ -1643,17 +1650,21 @@ static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family)
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
 
@@ -1664,7 +1675,7 @@ static int copy_from_user_tmpl(struct xfrm_policy *pol, struct nlattr **attrs)
 		int nr = nla_len(rt) / sizeof(*utmpl);
 		int err;
 
-		err = validate_tmpl(nr, utmpl, pol->family);
+		err = validate_tmpl(nr, utmpl, pol->family, extack);
 		if (err)
 			return err;
 
@@ -1736,7 +1747,7 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 	if (err)
 		goto error;
 
-	if (!(err = copy_from_user_tmpl(xp, attrs)))
+	if (!(err = copy_from_user_tmpl(xp, attrs, extack)))
 		err = copy_from_user_sec_ctx(xp, attrs);
 	if (err)
 		goto error;
@@ -3242,7 +3253,7 @@ static struct xfrm_policy *xfrm_compile_policy(struct sock *sk, int opt,
 		return NULL;
 
 	nr = ((len - sizeof(*p)) / sizeof(*ut));
-	if (validate_tmpl(nr, ut, p->sel.family))
+	if (validate_tmpl(nr, ut, p->sel.family, NULL))
 		return NULL;
 
 	if (p->dir > XFRM_POLICY_OUT)
-- 
2.33.1

