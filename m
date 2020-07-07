Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D330F2165A9
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 06:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgGGEzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 00:55:20 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:7540 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgGGEzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 00:55:17 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E5117415E3;
        Tue,  7 Jul 2020 12:55:12 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: [PATCH net-next v2 1/3] net: ip_fragment: Add ip_defrag_ignore_cb support
Date:   Tue,  7 Jul 2020 12:55:09 +0800
Message-Id: <1594097711-9365-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594097711-9365-1-git-send-email-wenxu@ucloud.cn>
References: <1594097711-9365-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlNS0tLSkNCTENKSkJZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXMjULOBw6MzMaHAw6OikdKS0ZKjocVlZVTkhNQihJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pxw6MTo4Az4DOE02QxowAhET
        N1ZPCzJVSlVKTkJPS0JMTEpIS05KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU5DSEs3Bg++
X-HM-Tid: 0a7327a0bf392086kuqye5117415e3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add ip_defrag_ignore_cb for conntrack defrag and it will
elide the CB clear when packets are defragmented by
connection tracking.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/ip.h       |  2 ++
 net/ipv4/ip_fragment.c | 55 ++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 862c954..31779a5 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -671,6 +671,8 @@ static inline bool ip_defrag_user_in_between(u32 user,
 }
 
 int ip_defrag(struct net *net, struct sk_buff *skb, u32 user);
+int ip_defrag_ignore_cb(struct net *net, struct sk_buff *skb,
+			u32 user, u16 *frag_max_size);
 #ifdef CONFIG_INET
 struct sk_buff *ip_check_defrag(struct net *net, struct sk_buff *skb, u32 user);
 #else
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index cfeb889..afc2b3d 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -76,7 +76,8 @@ static u8 ip4_frag_ecn(u8 tos)
 static struct inet_frags ip4_frags;
 
 static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
-			 struct sk_buff *prev_tail, struct net_device *dev);
+			 struct sk_buff *prev_tail, struct net_device *dev,
+			 bool ignore_skb_cb, u16 *frag_max_size);
 
 
 static void ip4_frag_init(struct inet_frag_queue *q, const void *a)
@@ -269,7 +270,8 @@ static int ip_frag_reinit(struct ipq *qp)
 }
 
 /* Add new segment to existing queue. */
-static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
+static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb,
+			 bool ignore_skb_cb, u16 *frag_max_size)
 {
 	struct net *net = qp->q.fqdir->net;
 	int ihl, end, flags, offset;
@@ -282,7 +284,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	if (qp->q.flags & INET_FRAG_COMPLETE)
 		goto err;
 
-	if (!(IPCB(skb)->flags & IPSKB_FRAG_COMPLETE) &&
+	if ((ignore_skb_cb || !(IPCB(skb)->flags & IPSKB_FRAG_COMPLETE)) &&
 	    unlikely(ip_frag_too_far(qp)) &&
 	    unlikely(err = ip_frag_reinit(qp))) {
 		ipq_kill(qp);
@@ -368,7 +370,8 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 		unsigned long orefdst = skb->_skb_refdst;
 
 		skb->_skb_refdst = 0UL;
-		err = ip_frag_reasm(qp, skb, prev_tail, dev);
+		err = ip_frag_reasm(qp, skb, prev_tail, dev, ignore_skb_cb,
+				    frag_max_size);
 		skb->_skb_refdst = orefdst;
 		if (err)
 			inet_frag_kill(&qp->q);
@@ -400,7 +403,8 @@ static bool ip_frag_coalesce_ok(const struct ipq *qp)
 
 /* Build a new IP datagram from all its fragments. */
 static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
-			 struct sk_buff *prev_tail, struct net_device *dev)
+			 struct sk_buff *prev_tail, struct net_device *dev,
+			 bool ignore_skb_cb, u16 *frag_max_size)
 {
 	struct net *net = qp->q.fqdir->net;
 	struct iphdr *iph;
@@ -430,7 +434,10 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 			       ip_frag_coalesce_ok(qp));
 
 	skb->dev = dev;
-	IPCB(skb)->frag_max_size = max(qp->max_df_size, qp->q.max_size);
+	if (!ignore_skb_cb)
+		IPCB(skb)->frag_max_size = max(qp->max_df_size, qp->q.max_size);
+	else if (frag_max_size)
+		*frag_max_size = max(qp->max_df_size, qp->q.max_size);
 
 	iph = ip_hdr(skb);
 	iph->tot_len = htons(len);
@@ -445,7 +452,8 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 	 * from one very small df-fragment and one large non-df frag.
 	 */
 	if (qp->max_df_size == qp->q.max_size) {
-		IPCB(skb)->flags |= IPSKB_FRAG_PMTU;
+		if (!ignore_skb_cb)
+			IPCB(skb)->flags |= IPSKB_FRAG_PMTU;
 		iph->frag_off = htons(IP_DF);
 	} else {
 		iph->frag_off = 0;
@@ -487,7 +495,7 @@ int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 
 		spin_lock(&qp->q.lock);
 
-		ret = ip_frag_queue(qp, skb);
+		ret = ip_frag_queue(qp, skb, false, NULL);
 
 		spin_unlock(&qp->q.lock);
 		ipq_put(qp);
@@ -500,6 +508,37 @@ int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 }
 EXPORT_SYMBOL(ip_defrag);
 
+/* Process an incoming IP datagram fragment. */
+int ip_defrag_ignore_cb(struct net *net, struct sk_buff *skb,
+			u32 user, u16 *frag_max_size)
+{
+	struct net_device *dev = skb->dev ? : skb_dst(skb)->dev;
+	int vif = l3mdev_master_ifindex_rcu(dev);
+	struct ipq *qp;
+
+	__IP_INC_STATS(net, IPSTATS_MIB_REASMREQDS);
+	skb_orphan(skb);
+
+	/* Lookup (or create) queue header */
+	qp = ip_find(net, ip_hdr(skb), user, vif);
+	if (qp) {
+		int ret;
+
+		spin_lock_bh(&qp->q.lock);
+
+		ret = ip_frag_queue(qp, skb, true, frag_max_size);
+
+		spin_unlock_bh(&qp->q.lock);
+		ipq_put(qp);
+		return ret;
+	}
+
+	__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
+	kfree_skb(skb);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(ip_defrag_ignore_cb);
+
 struct sk_buff *ip_check_defrag(struct net *net, struct sk_buff *skb, u32 user)
 {
 	struct iphdr iph;
-- 
1.8.3.1

