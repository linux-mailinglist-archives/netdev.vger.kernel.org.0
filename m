Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC8C44D646
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 13:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhKKMF4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Nov 2021 07:05:56 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:40847 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232987AbhKKMF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 07:05:56 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-7X2aI_mUNRmZtThWsGSfwQ-1; Thu, 11 Nov 2021 07:03:05 -0500
X-MC-Unique: 7X2aI_mUNRmZtThWsGSfwQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E3361923762;
        Thu, 11 Nov 2021 12:03:04 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C8AA1017CE3;
        Thu, 11 Nov 2021 12:03:03 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [RFC PATCH ipsec-next 2/6] xfrm: add extack support to verify_newpolicy_info
Date:   Thu, 11 Nov 2021 13:02:43 +0100
Message-Id: <d6d08abb35c1c15dfbd28c409d0429e08a010ccc.1636450303.git.sd@queasysnail.net>
In-Reply-To: <cover.1636450303.git.sd@queasysnail.net>
References: <cover.1636450303.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/xfrm_user.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 7af2104281e3..9d7f6de53238 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1497,7 +1497,8 @@ static int verify_policy_type(u8 type)
 	return 0;
 }
 
-static int verify_newpolicy_info(struct xfrm_userpolicy_info *p)
+static int verify_newpolicy_info(struct xfrm_userpolicy_info *p,
+				 struct netlink_ext_ack *extack)
 {
 	int ret;
 
@@ -1509,6 +1510,7 @@ static int verify_newpolicy_info(struct xfrm_userpolicy_info *p)
 		break;
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid policy share");
 		return -EINVAL;
 	}
 
@@ -1518,35 +1520,44 @@ static int verify_newpolicy_info(struct xfrm_userpolicy_info *p)
 		break;
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid policy action");
 		return -EINVAL;
 	}
 
 	switch (p->sel.family) {
 	case AF_INET:
-		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
+		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32) {
+			NL_SET_ERR_MSG(extack, "Invalid prefix length in selector (must be <= 32 for IPv4)");
 			return -EINVAL;
+		}
 
 		break;
 
 	case AF_INET6:
 #if IS_ENABLED(CONFIG_IPV6)
-		if (p->sel.prefixlen_d > 128 || p->sel.prefixlen_s > 128)
+		if (p->sel.prefixlen_d > 128 || p->sel.prefixlen_s > 128) {
+			NL_SET_ERR_MSG(extack, "Invalid prefix length in selector (must be <= 128 for IPv6)");
 			return -EINVAL;
+		}
 
 		break;
 #else
+		NL_SET_ERR_MSG(extack, "IPv6 support disabled");
 		return  -EAFNOSUPPORT;
 #endif
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid selector family");
 		return -EINVAL;
 	}
 
 	ret = verify_policy_dir(p->dir);
 	if (ret)
 		return ret;
-	if (p->index && (xfrm_policy_id2dir(p->index) != p->dir))
+	if (p->index && (xfrm_policy_id2dir(p->index) != p->dir)) {
+		NL_SET_ERR_MSG(extack, "Policy index doesn't match direction");
 		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -1753,7 +1764,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int err;
 	int excl;
 
-	err = verify_newpolicy_info(p);
+	err = verify_newpolicy_info(p, extack);
 	if (err)
 		return err;
 	err = verify_sec_ctx_len(attrs);
@@ -2450,7 +2461,7 @@ static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	xfrm_mark_get(attrs, &mark);
 
-	err = verify_newpolicy_info(&ua->policy);
+	err = verify_newpolicy_info(&ua->policy, extack);
 	if (err)
 		goto free_state;
 	err = verify_sec_ctx_len(attrs);
@@ -3226,7 +3237,7 @@ static struct xfrm_policy *xfrm_compile_policy(struct sock *sk, int opt,
 	*dir = -EINVAL;
 
 	if (len < sizeof(*p) ||
-	    verify_newpolicy_info(p))
+	    verify_newpolicy_info(p, NULL))
 		return NULL;
 
 	nr = ((len - sizeof(*p)) / sizeof(*ut));
-- 
2.33.1

