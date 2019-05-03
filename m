Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFDC13174
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbfECPuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:50:44 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51992 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728172AbfECPuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:50:44 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hMaSO-0004Wx-Fd; Fri, 03 May 2019 17:50:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 4/6] xfrm: remove state and template sort indirections from xfrm_state_afinfo
Date:   Fri,  3 May 2019 17:46:17 +0200
Message-Id: <20190503154619.32352-5-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190503154619.32352-1-fw@strlen.de>
References: <20190503154619.32352-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No module dependency, placing this in xfrm_state.c avoids need for
an indirection.

This also removes the state spinlock -- I don't see why we would need
to hold it during sorting.

This in turn allows to remove the 'net' argument passed to
xfrm_tmpl_sort.  Last, remove the EXPORT_SYMBOL, there are no modular
callers.

For the CONFIG_IPV6=m case, vmlinux size increase is about 300 byte.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h     |  18 +++---
 net/ipv6/xfrm6_state.c |  98 -------------------------------
 net/xfrm/xfrm_policy.c |   2 +-
 net/xfrm/xfrm_state.c  | 129 ++++++++++++++++++++++++++++++++---------
 4 files changed, 110 insertions(+), 137 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 5d1c2bdee91e..5f35f79eb661 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -352,8 +352,6 @@ struct xfrm_state_afinfo {
 	const struct xfrm_type		*type_map[IPPROTO_MAX];
 	const struct xfrm_type_offload	*type_offload_map[IPPROTO_MAX];
 
-	int			(*tmpl_sort)(struct xfrm_tmpl **dst, struct xfrm_tmpl **src, int n);
-	int			(*state_sort)(struct xfrm_state **dst, struct xfrm_state **src, int n);
 	int			(*output)(struct net *net, struct sock *sk, struct sk_buff *skb);
 	int			(*output_finish)(struct sock *sk, struct sk_buff *skb);
 	int			(*extract_input)(struct xfrm_state *x,
@@ -1483,21 +1481,19 @@ struct xfrm_state *xfrm_state_lookup_byaddr(struct net *net, u32 mark,
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
index 03b6bf85d70b..e9ea5a9decb4 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3625,7 +3625,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		}
 		xfrm_nr = ti;
 		if (npols > 1) {
-			xfrm_tmpl_sort(stp, tpp, xfrm_nr, family, net);
+			xfrm_tmpl_sort(stp, tpp, xfrm_nr, family);
 			tpp = stp;
 		}
 
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 636b055570e7..a963755fef6d 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1681,51 +1681,126 @@ xfrm_find_acq(struct net *net, const struct xfrm_mark *mark, u8 mode, u32 reqid,
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
2.21.0

