Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AB6280CFC
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 07:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgJBFBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 01:01:32 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41952 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgJBFB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 01:01:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B7481204EF;
        Fri,  2 Oct 2020 07:01:26 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bQwi5XynTGus; Fri,  2 Oct 2020 07:01:26 +0200 (CEST)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 48B47204B4;
        Fri,  2 Oct 2020 07:01:25 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 2 Oct 2020 07:01:25 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 2 Oct 2020
 07:01:24 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 60B2331846C3;
 Fri,  2 Oct 2020 07:01:23 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 6/7] xfrm/compat: Translate 32-bit user_policy from sockptr
Date:   Fri, 2 Oct 2020 07:01:12 +0200
Message-ID: <20201002050113.2210-7-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002050113.2210-1-steffen.klassert@secunet.com>
References: <20201002050113.2210-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

Provide compat_xfrm_userpolicy_info translation for xfrm setsocketopt().
Reallocate buffer and put the missing padding for 64-bit message.

Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |  3 +++
 net/xfrm/xfrm_compat.c | 26 ++++++++++++++++++++++++++
 net/xfrm/xfrm_state.c  | 17 ++++++++++++++---
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index fa18cb6bb3f7..53618a31634b 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -2012,6 +2012,9 @@ struct xfrm_translator {
 			int maxtype, const struct nla_policy *policy,
 			struct netlink_ext_ack *extack);
 
+	/* Translate 32-bit user_policy from sockptr */
+	int (*xlate_user_policy_sockptr)(u8 **pdata32, int optlen);
+
 	struct module *owner;
 };
 
diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index b1b5f972538d..e28f0c9ecd6a 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -576,10 +576,36 @@ static struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
 	return h64;
 }
 
+static int xfrm_user_policy_compat(u8 **pdata32, int optlen)
+{
+	struct compat_xfrm_userpolicy_info *p = (void *)*pdata32;
+	u8 *src_templates, *dst_templates;
+	u8 *data64;
+
+	if (optlen < sizeof(*p))
+		return -EINVAL;
+
+	data64 = kmalloc_track_caller(optlen + 4, GFP_USER | __GFP_NOWARN);
+	if (!data64)
+		return -ENOMEM;
+
+	memcpy(data64, *pdata32, sizeof(*p));
+	memset(data64 + sizeof(*p), 0, 4);
+
+	src_templates = *pdata32 + sizeof(*p);
+	dst_templates = data64 + sizeof(*p) + 4;
+	memcpy(dst_templates, src_templates, optlen - sizeof(*p));
+
+	kfree(*pdata32);
+	*pdata32 = data64;
+	return 0;
+}
+
 static struct xfrm_translator xfrm_translator = {
 	.owner				= THIS_MODULE,
 	.alloc_compat			= xfrm_alloc_compat,
 	.rcv_msg_compat			= xfrm_user_rcv_msg_compat,
+	.xlate_user_policy_sockptr	= xfrm_user_policy_compat,
 };
 
 static int __init xfrm_compat_init(void)
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index cc206ca3df78..f9961884500b 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2331,9 +2331,6 @@ int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval, int optlen)
 	struct xfrm_mgr *km;
 	struct xfrm_policy *pol = NULL;
 
-	if (in_compat_syscall())
-		return -EOPNOTSUPP;
-
 	if (sockptr_is_null(optval) && !optlen) {
 		xfrm_sk_policy_insert(sk, XFRM_POLICY_IN, NULL);
 		xfrm_sk_policy_insert(sk, XFRM_POLICY_OUT, NULL);
@@ -2348,6 +2345,20 @@ int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval, int optlen)
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
+	if (in_compat_syscall()) {
+		struct xfrm_translator *xtr = xfrm_get_translator();
+
+		if (!xtr)
+			return -EOPNOTSUPP;
+
+		err = xtr->xlate_user_policy_sockptr(&data, optlen);
+		xfrm_put_translator(xtr);
+		if (err) {
+			kfree(data);
+			return err;
+		}
+	}
+
 	err = -EINVAL;
 	rcu_read_lock();
 	list_for_each_entry_rcu(km, &xfrm_km_list, list) {
-- 
2.17.1

