Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8018460292
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfGEIqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:46:25 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37444 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727588AbfGEIqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:46:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3527C20258;
        Fri,  5 Jul 2019 10:46:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ONpGkv0N0jl4; Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 84678201C6;
        Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 10:46:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 4F33931807B4;
 Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/9] xfrm: remove state and template sort indirections from xfrm_state_afinfo
Date:   Fri, 5 Jul 2019 10:46:05 +0200
Message-ID: <20190705084610.3646-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705084610.3646-1-steffen.klassert@secunet.com>
References: <20190705084610.3646-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No module dependency, placing this in xfrm_state.c avoids need for
an indirection.

This also removes the state spinlock -- I don't see why we would need
to hold it during sorting.

This in turn allows to remove the 'net' argument passed to
xfrm_tmpl_sort.  Last, remove the EXPORT_SYMBOL, there are no modular
callers.

For the CONFIG_IPV6=m case, vmlinux size increase is about 300 byte.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |  18 +++---
 net/ipv6/xfrm6_state.c |  98 ------------------------------
 net/xfrm/xfrm_policy.c |   2 +-
 net/xfrm/xfrm_state.c  | 132 ++++++++++++++++++++++++++++++++---------
 4 files changed, 113 insertions(+), 137 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 61214f5c3205..4325cb708ed4 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -353,8 +353,6 @@ struct xfrm_state_afinfo {
 	const struct xfrm_type		*type_map[IPPROTO_MAX];
 	const struct xfrm_type_offload	*type_offload_map[IPPROTO_MAX];
 
-	int			(*tmpl_sort)(struct xfrm_tmpl **dst, struct xfrm_tmpl **src, int n);
-	int			(*state_sort)(struct xfrm_state **dst, struct xfrm_state **src, int n);
 	int			(*output)(struct net *net, struct sock *sk, struct sk_buff *skb);
 	int			(*output_finish)(struct sock *sk, struct sk_buff *skb);
 	int			(*extract_input)(struct xfrm_state *x,
@@ -1501,21 +1499,19 @@ struct xfrm_state *xfrm_state_lookup_byaddr(struct net *net, u32 mark,
 					    u8 proto,
 					    unsigned short family);
 #ifdef CONFIG_XFRM_SUB_POLICY
-int xfrm_tmpl_sort(struct xfrm_tmpl **dst, struct xfrm_tmpl **src, int n,
-		   unsigned short family, struct net *net);
-int xfrm_state_sort(struct xfrm_state **dst, struct xfrm_state **src, int n,
+void xfrm_tmpl_sort(struct xfrm_tmpl **dst, struct xfrm_tmpl **src, int n,
 		    unsigned short family);
+void xfrm_state_sort(struct xfrm_state **dst, struct xfrm_state **src, int n,
+		     unsigned short family);
 #else
-static inline int xfrm_tmpl_sort(struct xfrm_tmpl **dst, struct xfrm_tmpl **src,
-				 int n, unsigned short family, struct net *net)
+static inline void xfrm_tmpl_sort(struct xfrm_tmpl **d, struct xfrm_tmpl **s,
+				  int n, unsigned short family)
 {
-	return -ENOSYS;
 }
 
-static inline int xfrm_state_sort(struct xfrm_state **dst, struct xfrm_state **src,
-				  int n, unsigned short family)
+static inline void xfrm_state_sort(struct xfrm_state **d, struct xfrm_state **s,
+				   int n, unsigned short family)
 {
-	return -ENOSYS;
 }
 #endif
 
diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
index aa5d2c52cc31..1782ebb22dd3 100644
--- a/net/ipv6/xfrm6_state.c
+++ b/net/ipv6/xfrm6_state.c
@@ -21,102 +21,6 @@
 #include <net/ipv6.h>
 #include <net/addrconf.h>
 
-/* distribution counting sort function for xfrm_state and xfrm_tmpl */
-static int
-__xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
-{
-	int count[XFRM_MAX_DEPTH] = { };
-	int class[XFRM_MAX_DEPTH];
-	int i;
-
-	for (i = 0; i < n; i++) {
-		int c;
-		class[i] = c = cmp(src[i]);
-		count[c]++;
-	}
-
-	for (i = 2; i < maxclass; i++)
-		count[i] += count[i - 1];
-
-	for (i = 0; i < n; i++) {
-		dst[count[class[i] - 1]++] = src[i];
-		src[i] = NULL;
-	}
-
-	return 0;
-}
-
-/*
- * Rule for xfrm_state:
- *
- * rule 1: select IPsec transport except AH
- * rule 2: select MIPv6 RO or inbound trigger
- * rule 3: select IPsec transport AH
- * rule 4: select IPsec tunnel
- * rule 5: others
- */
-static int __xfrm6_state_sort_cmp(void *p)
-{
-	struct xfrm_state *v = p;
-
-	switch (v->props.mode) {
-	case XFRM_MODE_TRANSPORT:
-		if (v->id.proto != IPPROTO_AH)
-			return 1;
-		else
-			return 3;
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-	case XFRM_MODE_ROUTEOPTIMIZATION:
-	case XFRM_MODE_IN_TRIGGER:
-		return 2;
-#endif
-	case XFRM_MODE_TUNNEL:
-	case XFRM_MODE_BEET:
-		return 4;
-	}
-	return 5;
-}
-
-static int
-__xfrm6_state_sort(struct xfrm_state **dst, struct xfrm_state **src, int n)
-{
-	return __xfrm6_sort((void **)dst, (void **)src, n,
-			    __xfrm6_state_sort_cmp, 6);
-}
-
-/*
- * Rule for xfrm_tmpl:
- *
- * rule 1: select IPsec transport
- * rule 2: select MIPv6 RO or inbound trigger
- * rule 3: select IPsec tunnel
- * rule 4: others
- */
-static int __xfrm6_tmpl_sort_cmp(void *p)
-{
-	struct xfrm_tmpl *v = p;
-	switch (v->mode) {
-	case XFRM_MODE_TRANSPORT:
-		return 1;
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-	case XFRM_MODE_ROUTEOPTIMIZATION:
-	case XFRM_MODE_IN_TRIGGER:
-		return 2;
-#endif
-	case XFRM_MODE_TUNNEL:
-	case XFRM_MODE_BEET:
-		return 3;
-	}
-	return 4;
-}
-
-static int
-__xfrm6_tmpl_sort(struct xfrm_tmpl **dst, struct xfrm_tmpl **src, int n)
-{
-	return __xfrm6_sort((void **)dst, (void **)src, n,
-			    __xfrm6_tmpl_sort_cmp, 5);
-}
-
 int xfrm6_extract_header(struct sk_buff *skb)
 {
 	struct ipv6hdr *iph = ipv6_hdr(skb);
@@ -138,8 +42,6 @@ static struct xfrm_state_afinfo xfrm6_state_afinfo = {
 	.proto			= IPPROTO_IPV6,
 	.eth_proto		= htons(ETH_P_IPV6),
 	.owner			= THIS_MODULE,
-	.tmpl_sort		= __xfrm6_tmpl_sort,
-	.state_sort		= __xfrm6_state_sort,
 	.output			= xfrm6_output,
 	.output_finish		= xfrm6_output_finish,
 	.extract_input		= xfrm6_extract_input,
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index b1694d5d15d3..1070dfece76b 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3628,7 +3628,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		}
 		xfrm_nr = ti;
 		if (npols > 1) {
-			xfrm_tmpl_sort(stp, tpp, xfrm_nr, family, net);
+			xfrm_tmpl_sort(stp, tpp, xfrm_nr, family);
 			tpp = stp;
 		}
 
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 5c13a8021d4c..3f0950db060a 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1688,51 +1688,129 @@ xfrm_find_acq(struct net *net, const struct xfrm_mark *mark, u8 mode, u32 reqid,
 EXPORT_SYMBOL(xfrm_find_acq);
 
 #ifdef CONFIG_XFRM_SUB_POLICY
-int
+#if IS_ENABLED(CONFIG_IPV6)
+/* distribution counting sort function for xfrm_state and xfrm_tmpl */
+static void
+__xfrm6_sort(void **dst, void **src, int n,
+	     int (*cmp)(const void *p), int maxclass)
+{
+	int count[XFRM_MAX_DEPTH] = { };
+	int class[XFRM_MAX_DEPTH];
+	int i;
+
+	for (i = 0; i < n; i++) {
+		int c = cmp(src[i]);
+
+		class[i] = c;
+		count[c]++;
+	}
+
+	for (i = 2; i < maxclass; i++)
+		count[i] += count[i - 1];
+
+	for (i = 0; i < n; i++) {
+		dst[count[class[i] - 1]++] = src[i];
+		src[i] = NULL;
+	}
+}
+
+/* Rule for xfrm_state:
+ *
+ * rule 1: select IPsec transport except AH
+ * rule 2: select MIPv6 RO or inbound trigger
+ * rule 3: select IPsec transport AH
+ * rule 4: select IPsec tunnel
+ * rule 5: others
+ */
+static int __xfrm6_state_sort_cmp(const void *p)
+{
+	const struct xfrm_state *v = p;
+
+	switch (v->props.mode) {
+	case XFRM_MODE_TRANSPORT:
+		if (v->id.proto != IPPROTO_AH)
+			return 1;
+		else
+			return 3;
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+	case XFRM_MODE_ROUTEOPTIMIZATION:
+	case XFRM_MODE_IN_TRIGGER:
+		return 2;
+#endif
+	case XFRM_MODE_TUNNEL:
+	case XFRM_MODE_BEET:
+		return 4;
+	}
+	return 5;
+}
+
+/* Rule for xfrm_tmpl:
+ *
+ * rule 1: select IPsec transport
+ * rule 2: select MIPv6 RO or inbound trigger
+ * rule 3: select IPsec tunnel
+ * rule 4: others
+ */
+static int __xfrm6_tmpl_sort_cmp(const void *p)
+{
+	const struct xfrm_tmpl *v = p;
+
+	switch (v->mode) {
+	case XFRM_MODE_TRANSPORT:
+		return 1;
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+	case XFRM_MODE_ROUTEOPTIMIZATION:
+	case XFRM_MODE_IN_TRIGGER:
+		return 2;
+#endif
+	case XFRM_MODE_TUNNEL:
+	case XFRM_MODE_BEET:
+		return 3;
+	}
+	return 4;
+}
+#else
+static inline int __xfrm6_state_sort_cmp(const void *p) { return 5; }
+static inline int __xfrm6_tmpl_sort_cmp(const void *p) { return 4; }
+
+static inline void
+__xfrm6_sort(void **dst, void **src, int n,
+	     int (*cmp)(const void *p), int maxclass)
+{
+	int i;
+
+	for (i = 0; i < n; i++)
+		dst[i] = src[i];
+}
+#endif /* CONFIG_IPV6 */
+
+void
 xfrm_tmpl_sort(struct xfrm_tmpl **dst, struct xfrm_tmpl **src, int n,
-	       unsigned short family, struct net *net)
+	       unsigned short family)
 {
 	int i;
-	int err = 0;
-	struct xfrm_state_afinfo *afinfo = xfrm_state_get_afinfo(family);
-	if (!afinfo)
-		return -EAFNOSUPPORT;
 
-	spin_lock_bh(&net->xfrm.xfrm_state_lock); /*FIXME*/
-	if (afinfo->tmpl_sort)
-		err = afinfo->tmpl_sort(dst, src, n);
+	if (family == AF_INET6)
+		__xfrm6_sort((void **)dst, (void **)src, n,
+			     __xfrm6_tmpl_sort_cmp, 5);
 	else
 		for (i = 0; i < n; i++)
 			dst[i] = src[i];
-	spin_unlock_bh(&net->xfrm.xfrm_state_lock);
-	rcu_read_unlock();
-	return err;
 }
-EXPORT_SYMBOL(xfrm_tmpl_sort);
 
-int
+void
 xfrm_state_sort(struct xfrm_state **dst, struct xfrm_state **src, int n,
 		unsigned short family)
 {
 	int i;
-	int err = 0;
-	struct xfrm_state_afinfo *afinfo = xfrm_state_get_afinfo(family);
-	struct net *net = xs_net(*src);
 
-	if (!afinfo)
-		return -EAFNOSUPPORT;
-
-	spin_lock_bh(&net->xfrm.xfrm_state_lock);
-	if (afinfo->state_sort)
-		err = afinfo->state_sort(dst, src, n);
+	if (family == AF_INET6)
+		__xfrm6_sort((void **)dst, (void **)src, n,
+			     __xfrm6_state_sort_cmp, 6);
 	else
 		for (i = 0; i < n; i++)
 			dst[i] = src[i];
-	spin_unlock_bh(&net->xfrm.xfrm_state_lock);
-	rcu_read_unlock();
-	return err;
 }
-EXPORT_SYMBOL(xfrm_state_sort);
 #endif
 
 /* Silly enough, but I'm lazy to build resolution list */
-- 
2.17.1

