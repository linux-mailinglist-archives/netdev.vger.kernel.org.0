Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EAC54FE25
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 22:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbiFQULC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbiFQUKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:10:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941A91BEA1
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 13:10:53 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k5-20020a17090a404500b001e8875e6242so5033733pjg.5
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 13:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HVl+r09haBMAqy+vmcvDrMELaW/03KoNIKh2/3ZwLyY=;
        b=jm7fYti+wm3+klxWQM3nk7LYRbcqmXL/fQavN81emOWiMyvxspuA9JOwnTY7MFlLVz
         +rwAORWWf/RXJ0iQi6UOjc3R0r/tsnQtzfQqZXLbpnyys2xlS0TKU+rUAic6aMwQwaT+
         959KHTpCgmrFTc/+eIFWLYTN/8jAGT6Ra+wR8agHL6wO5rA5Y7s5qq43VZrcAWJE6isc
         yfjrUtbF7yozNMBNyssO6lUMsYMRhOWq1HrrUU39q5Cfg/nouw9okmOEvqg2o/w0yyVq
         v7VeY4dOVSS7iA+hiECT1RrwYKzPE8xGYLLQP/frzO3J5huzbvnjbZRDVginaT9yZqES
         eLtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HVl+r09haBMAqy+vmcvDrMELaW/03KoNIKh2/3ZwLyY=;
        b=QtPd1LsUpwnUoK7wtgs729loS5vxtgTms37HzUWmdjaMnNxtKGpJ0Z/bjTTP6rh1y2
         JmV+8J5TYR4ZkPMmHR3HW/5cfSOyzxEOIFQiPgL0be4JpgyZbiaQXhncJ7ShxI5PPTx/
         UPfmdDlZnu5Rq8JMlNPHfBrzwR8Af6XZGZHpKQg2O/Ez6nmsu8xzfXu/HEG84WlKLmw8
         bTGSjfnijEvuPtqevZ3NRxBD7uM6kd6hJGpnWyI734X5LkI11UZkG0wmXQMPhjNuRph9
         ODWdeQusmhcXLhXmqH+00mUbZldh+rCbTU0aBQ9MAKJ/kn2K9o8HFLmqnFqx5VYHfTV6
         UywA==
X-Gm-Message-State: AJIora+P5zoZgH4uTslIb1/EixOf8zaR7npV9YgPSIEOOGeGTUexiEhw
        Do5VGICeK8r/g8Bu1TF+mM+hGPENMaY=
X-Google-Smtp-Source: AGRyM1sLhAb2iSrQ6ya3ujLuK8JKH0bkXxWXxkM503eK6Bw1CK9MhaNqUVtySa6GRvn4KQ9n8p0QGw==
X-Received: by 2002:a17:902:bb86:b0:169:caf:895c with SMTP id m6-20020a170902bb8600b001690caf895cmr7846966pls.13.1655496653037;
        Fri, 17 Jun 2022 13:10:53 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d5d2:fc18:6baf:e16b])
        by smtp.gmail.com with ESMTPSA id ja14-20020a170902efce00b00168adae4ea2sm3931758plb.39.2022.06.17.13.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 13:10:52 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/2] raw: convert raw sockets to RCU
Date:   Fri, 17 Jun 2022 13:10:45 -0700
Message-Id: <20220617201045.2659460-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220617201045.2659460-1-eric.dumazet@gmail.com>
References: <20220617201045.2659460-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Using rwlock in networking code is extremely risky.
writers can starve if enough readers are constantly
grabing the rwlock.

I thought rwlock were at fault and sent this patch:

https://lkml.org/lkml/2022/6/17/272

But Peter and Linus essentially told me rwlock had to be unfair.

We need to get rid of rwlock in networking code.

Without this fix, following script triggers soft lockups:

for i in {1..48}
do
 ping -f -n -q 127.0.0.1 &
 sleep 0.1
done

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/raw.h   | 11 ++++++-
 include/net/rawv6.h |  1 +
 net/ipv4/af_inet.c  |  2 ++
 net/ipv4/raw.c      | 71 ++++++++++++++++++++++-----------------------
 net/ipv4/raw_diag.c | 10 +++++--
 net/ipv6/af_inet6.c |  3 ++
 net/ipv6/raw.c      | 28 +++++++++---------
 7 files changed, 71 insertions(+), 55 deletions(-)

diff --git a/include/net/raw.h b/include/net/raw.h
index 719d3556fc0a6a764b0072a76dac8c436c96d53d..d81eeeb8f1e6790c398eaa7cb9921f7387b2afcf 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -33,9 +33,18 @@ int raw_rcv(struct sock *, struct sk_buff *);
 
 struct raw_hashinfo {
 	rwlock_t lock;
-	struct hlist_head ht[RAW_HTABLE_SIZE];
+	struct hlist_nulls_head ht[RAW_HTABLE_SIZE];
 };
 
+static inline void raw_hashinfo_init(struct raw_hashinfo *hashinfo)
+{
+	int i;
+
+	rwlock_init(&hashinfo->lock);
+	for (i = 0; i < RAW_HTABLE_SIZE; i++)
+		INIT_HLIST_NULLS_HEAD(&hashinfo->ht[i], i);
+}
+
 #ifdef CONFIG_PROC_FS
 int raw_proc_init(void);
 void raw_proc_exit(void);
diff --git a/include/net/rawv6.h b/include/net/rawv6.h
index c48c1298699a049b907cd4b4e09c9b3f6a961d5b..bc70909625f60dcd819f50a258841d20e5ba0c68 100644
--- a/include/net/rawv6.h
+++ b/include/net/rawv6.h
@@ -3,6 +3,7 @@
 #define _NET_RAWV6_H
 
 #include <net/protocol.h>
+#include <net/raw.h>
 
 extern struct raw_hashinfo raw_v6_hashinfo;
 bool raw_v6_match(struct net *net, struct sock *sk, unsigned short num,
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 30e0e8992085d5d4ac5941b5f3a101f798588be9..da81f56fdd1c54f6773db6b776cd0b4e22de1e75 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1929,6 +1929,8 @@ static int __init inet_init(void)
 
 	sock_skb_cb_check_size(sizeof(struct inet_skb_parm));
 
+	raw_hashinfo_init(&raw_v4_hashinfo);
+
 	rc = proto_register(&tcp_prot, 1);
 	if (rc)
 		goto out;
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index c194e758ea8b132966ef606afe8e63fef3db7075..f3c9b21ed7eb737b3c57574ec77b4846e43e618a 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -85,20 +85,19 @@ struct raw_frag_vec {
 	int hlen;
 };
 
-struct raw_hashinfo raw_v4_hashinfo = {
-	.lock = __RW_LOCK_UNLOCKED(raw_v4_hashinfo.lock),
-};
+struct raw_hashinfo raw_v4_hashinfo;
 EXPORT_SYMBOL_GPL(raw_v4_hashinfo);
 
 int raw_hash_sk(struct sock *sk)
 {
 	struct raw_hashinfo *h = sk->sk_prot->h.raw_hash;
-	struct hlist_head *head;
+	struct hlist_nulls_head *hlist;
 
-	head = &h->ht[inet_sk(sk)->inet_num & (RAW_HTABLE_SIZE - 1)];
+	hlist = &h->ht[inet_sk(sk)->inet_num & (RAW_HTABLE_SIZE - 1)];
 
 	write_lock_bh(&h->lock);
-	sk_add_node(sk, head);
+	hlist_nulls_add_head_rcu(&sk->sk_nulls_node, hlist);
+	sock_set_flag(sk, SOCK_RCU_FREE);
 	write_unlock_bh(&h->lock);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 
@@ -111,7 +110,7 @@ void raw_unhash_sk(struct sock *sk)
 	struct raw_hashinfo *h = sk->sk_prot->h.raw_hash;
 
 	write_lock_bh(&h->lock);
-	if (sk_del_node_init(sk))
+	if (__sk_nulls_del_node_init_rcu(sk))
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 	write_unlock_bh(&h->lock);
 }
@@ -164,17 +163,16 @@ static int icmp_filter(const struct sock *sk, const struct sk_buff *skb)
 static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 {
 	struct net *net = dev_net(skb->dev);;
+	struct hlist_nulls_head *hlist;
+	struct hlist_nulls_node *hnode;
 	int sdif = inet_sdif(skb);
 	int dif = inet_iif(skb);
-	struct hlist_head *head;
 	int delivered = 0;
 	struct sock *sk;
 
-	head = &raw_v4_hashinfo.ht[hash];
-	if (hlist_empty(head))
-		return 0;
-	read_lock(&raw_v4_hashinfo.lock);
-	sk_for_each(sk, head) {
+	hlist = &raw_v4_hashinfo.ht[hash];
+	rcu_read_lock();
+	hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
 		if (!raw_v4_match(net, sk, iph->protocol,
 				  iph->saddr, iph->daddr, dif, sdif))
 			continue;
@@ -189,7 +187,7 @@ static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 				raw_rcv(sk, clone);
 		}
 	}
-	read_unlock(&raw_v4_hashinfo.lock);
+	rcu_read_unlock();
 	return delivered;
 }
 
@@ -265,25 +263,26 @@ static void raw_err(struct sock *sk, struct sk_buff *skb, u32 info)
 void raw_icmp_error(struct sk_buff *skb, int protocol, u32 info)
 {
 	struct net *net = dev_net(skb->dev);;
+	struct hlist_nulls_head *hlist;
+	struct hlist_nulls_node *hnode;
 	int dif = skb->dev->ifindex;
 	int sdif = inet_sdif(skb);
-	struct hlist_head *head;
 	const struct iphdr *iph;
 	struct sock *sk;
 	int hash;
 
 	hash = protocol & (RAW_HTABLE_SIZE - 1);
-	head = &raw_v4_hashinfo.ht[hash];
+	hlist = &raw_v4_hashinfo.ht[hash];
 
-	read_lock(&raw_v4_hashinfo.lock);
-	sk_for_each(sk, head) {
+	rcu_read_lock();
+	hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
 		iph = (const struct iphdr *)skb->data;
 		if (!raw_v4_match(net, sk, iph->protocol,
 				  iph->saddr, iph->daddr, dif, sdif))
 			continue;
 		raw_err(sk, skb, info);
 	}
-	read_unlock(&raw_v4_hashinfo.lock);
+	rcu_read_unlock();
 }
 
 static int raw_rcv_skb(struct sock *sk, struct sk_buff *skb)
@@ -944,44 +943,41 @@ struct proto raw_prot = {
 };
 
 #ifdef CONFIG_PROC_FS
-static struct sock *raw_get_first(struct seq_file *seq)
+static struct sock *raw_get_first(struct seq_file *seq, int bucket)
 {
-	struct sock *sk;
 	struct raw_hashinfo *h = pde_data(file_inode(seq->file));
 	struct raw_iter_state *state = raw_seq_private(seq);
+	struct hlist_nulls_head *hlist;
+	struct hlist_nulls_node *hnode;
+	struct sock *sk;
 
-	for (state->bucket = 0; state->bucket < RAW_HTABLE_SIZE;
+	for (state->bucket = bucket; state->bucket < RAW_HTABLE_SIZE;
 			++state->bucket) {
-		sk_for_each(sk, &h->ht[state->bucket])
+		hlist = &h->ht[state->bucket];
+		hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
 			if (sock_net(sk) == seq_file_net(seq))
-				goto found;
+				return sk;
+		}
 	}
-	sk = NULL;
-found:
-	return sk;
+	return NULL;
 }
 
 static struct sock *raw_get_next(struct seq_file *seq, struct sock *sk)
 {
-	struct raw_hashinfo *h = pde_data(file_inode(seq->file));
 	struct raw_iter_state *state = raw_seq_private(seq);
 
 	do {
-		sk = sk_next(sk);
-try_again:
-		;
+		sk = sk_nulls_next(sk);
 	} while (sk && sock_net(sk) != seq_file_net(seq));
 
-	if (!sk && ++state->bucket < RAW_HTABLE_SIZE) {
-		sk = sk_head(&h->ht[state->bucket]);
-		goto try_again;
-	}
+	if (!sk)
+		return raw_get_first(seq, state->bucket + 1);
 	return sk;
 }
 
 static struct sock *raw_get_idx(struct seq_file *seq, loff_t pos)
 {
-	struct sock *sk = raw_get_first(seq);
+	struct sock *sk = raw_get_first(seq, 0);
 
 	if (sk)
 		while (pos && (sk = raw_get_next(seq, sk)) != NULL)
@@ -1004,7 +1000,7 @@ void *raw_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct sock *sk;
 
 	if (v == SEQ_START_TOKEN)
-		sk = raw_get_first(seq);
+		sk = raw_get_first(seq, 0);
 	else
 		sk = raw_get_next(seq, v);
 	++*pos;
@@ -1079,6 +1075,7 @@ static __net_initdata struct pernet_operations raw_net_ops = {
 
 int __init raw_proc_init(void)
 {
+
 	return register_pernet_subsys(&raw_net_ops);
 }
 
diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index b6d92dc7b051d1ccf2df50689d041251d0745430..da121121b174b005bb005af8bc5450db8b7f6755 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -57,6 +57,8 @@ static bool raw_lookup(struct net *net, struct sock *sk,
 static struct sock *raw_sock_get(struct net *net, const struct inet_diag_req_v2 *r)
 {
 	struct raw_hashinfo *hashinfo = raw_get_hashinfo(r);
+	struct hlist_nulls_head *hlist;
+	struct hlist_nulls_node *hnode;
 	struct sock *sk;
 	int slot;
 
@@ -65,7 +67,8 @@ static struct sock *raw_sock_get(struct net *net, const struct inet_diag_req_v2
 
 	read_lock(&hashinfo->lock);
 	for (slot = 0; slot < RAW_HTABLE_SIZE; slot++) {
-		sk_for_each(sk, &hashinfo->ht[slot]) {
+		hlist = &hashinfo->ht[slot];
+		hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
 			if (raw_lookup(net, sk, r)) {
 				/*
 				 * Grab it and keep until we fill
@@ -141,6 +144,8 @@ static void raw_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	struct raw_hashinfo *hashinfo = raw_get_hashinfo(r);
 	struct net *net = sock_net(skb->sk);
 	struct inet_diag_dump_data *cb_data;
+	struct hlist_nulls_head *hlist;
+	struct hlist_nulls_node *hnode;
 	int num, s_num, slot, s_slot;
 	struct sock *sk = NULL;
 	struct nlattr *bc;
@@ -157,7 +162,8 @@ static void raw_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	for (slot = s_slot; slot < RAW_HTABLE_SIZE; s_num = 0, slot++) {
 		num = 0;
 
-		sk_for_each(sk, &hashinfo->ht[slot]) {
+		hlist = &hashinfo->ht[slot];
+		hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
 			struct inet_sock *inet = inet_sk(sk);
 
 			if (!net_eq(sock_net(sk), net))
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 70564ddccc4677d0e091ef6ae747b001be4bd1aa..658823e91ecab818aa6b0aca4cf0188272eb103a 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -63,6 +63,7 @@
 #include <net/compat.h>
 #include <net/xfrm.h>
 #include <net/ioam6.h>
+#include <net/rawv6.h>
 
 #include <linux/uaccess.h>
 #include <linux/mroute6.h>
@@ -1073,6 +1074,8 @@ static int __init inet6_init(void)
 		goto out;
 	}
 
+	raw_hashinfo_init(&raw_v6_hashinfo);
+
 	err = proto_register(&tcpv6_prot, 1);
 	if (err)
 		goto out;
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index c0f2e34759846562dddba24b4de8970dc4b4db89..f6119998700eefdeabd734d85f58b4d66310e88e 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -61,9 +61,7 @@
 
 #define	ICMPV6_HDRLEN	4	/* ICMPv6 header, RFC 4443 Section 2.1 */
 
-struct raw_hashinfo raw_v6_hashinfo = {
-	.lock = __RW_LOCK_UNLOCKED(raw_v6_hashinfo.lock),
-};
+struct raw_hashinfo raw_v6_hashinfo;
 EXPORT_SYMBOL_GPL(raw_v6_hashinfo);
 
 bool raw_v6_match(struct net *net, struct sock *sk, unsigned short num,
@@ -143,9 +141,10 @@ EXPORT_SYMBOL(rawv6_mh_filter_unregister);
 static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 {
 	struct net *net = dev_net(skb->dev);
+	struct hlist_nulls_head *hlist;
+	struct hlist_nulls_node *hnode;
 	const struct in6_addr *saddr;
 	const struct in6_addr *daddr;
-	struct hlist_head *head;
 	struct sock *sk;
 	bool delivered = false;
 	__u8 hash;
@@ -154,11 +153,9 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 	daddr = saddr + 1;
 
 	hash = nexthdr & (RAW_HTABLE_SIZE - 1);
-	head = &raw_v6_hashinfo.ht[hash];
-	if (hlist_empty(head))
-		return false;
-	read_lock(&raw_v6_hashinfo.lock);
-	sk_for_each(sk, head) {
+	hlist = &raw_v6_hashinfo.ht[hash];
+	rcu_read_lock();
+	hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
 		int filtered;
 
 		if (!raw_v6_match(net, sk, nexthdr, daddr, saddr,
@@ -203,7 +200,7 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 			}
 		}
 	}
-	read_unlock(&raw_v6_hashinfo.lock);
+	rcu_read_unlock();
 	return delivered;
 }
 
@@ -337,14 +334,15 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 {
 	const struct in6_addr *saddr, *daddr;
 	struct net *net = dev_net(skb->dev);
-	struct hlist_head *head;
+	struct hlist_nulls_head *hlist;
+	struct hlist_nulls_node *hnode;
 	struct sock *sk;
 	int hash;
 
 	hash = nexthdr & (RAW_HTABLE_SIZE - 1);
-	head = &raw_v6_hashinfo.ht[hash];
-	read_lock(&raw_v6_hashinfo.lock);
-	sk_for_each(sk, head) {
+	hlist = &raw_v6_hashinfo.ht[hash];
+	rcu_read_lock();
+	hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
 		/* Note: ipv6_hdr(skb) != skb->data */
 		const struct ipv6hdr *ip6h = (const struct ipv6hdr *)skb->data;
 		saddr = &ip6h->saddr;
@@ -355,7 +353,7 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 			continue;
 		rawv6_err(sk, skb, NULL, type, code, inner_offset, info);
 	}
-	read_unlock(&raw_v6_hashinfo.lock);
+	rcu_read_unlock();
 }
 
 static inline int rawv6_rcv_skb(struct sock *sk, struct sk_buff *skb)
-- 
2.36.1.476.g0c4daa206d-goog

