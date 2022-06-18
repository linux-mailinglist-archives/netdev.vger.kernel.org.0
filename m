Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5EEA550290
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiFRDrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbiFRDrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:47:15 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BAE36B5A
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 20:47:13 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 68so128425pgb.10
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 20:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/eIk3wb0VhoOZ7j9XTqc9t73LMCdpXnuVL7sUvo3QZY=;
        b=jm2X8yJigdI14FjEfAc+jzJIv4yhLcsC3paGv3VlOS2PrPOatXlK/HvU4z7CdvueW6
         jHBRxlipsJyayfeuVT0xmOnaRfstEi/i7MAs2JMhFOYZ5WG2xu5okci+AnA6cXFtx1La
         E97GCJnCsYeh3PkQgQU/twbbq/vhqP0GAHfJcplUabWmnqaKpbn9rFOr3U/WYFMdu/I6
         wyDCjvMRRbzQM8gcM8iIZcKJ26kmWArmXd6klBbX4kGjShFGGiCGE6AQeum2/5lML54z
         0Uyk8R4eSJYSlDb/hm7Zvb+XX/ov9voBRSj0dlXPstSrRF0bCqw8bHaIHloU8qDEt5Ay
         pvyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/eIk3wb0VhoOZ7j9XTqc9t73LMCdpXnuVL7sUvo3QZY=;
        b=Lrw2IuotgBpWFtYVKLrAsgA2Ur1Rma59w+0X0BbntdtV1pjHbmenOz/m0sz8fg7uI4
         Cxg9tZJcIzwaeKsUhAohk9UqrZgO0Gdn3TecbdyudppPegcdp0rc0L6cDW8edXPS7sA9
         HSHA1pw6R8knvlLbTH/uEdTUP9UD6xSfCKVKzu7mJY8b3qNpM/S+8EsQ0Eh/5QKB/zZ+
         rV0dfbcK3xGErsuATmaYE7Hk+D8gwNxdKJZbab58lu+AEpAW0c+gTUxv4s6LjCRqvvuJ
         /tLjJjbHU8CNph6L75v9y/hBtGzqOb3VyEXesKPpTyYUZLGMWn/xvqQSBtkIpkVEAe83
         Sibg==
X-Gm-Message-State: AJIora8OkLo/+x6uthqd9eMxgdCRuZuxehvHKwKIY+G4WtAZUkOt6y5C
        K1YwxBoaFoa3syhdQJTDZRc=
X-Google-Smtp-Source: AGRyM1t8SxAsmoK0vbopTVfT458p/kdaD5XqPi49EdYAJp6ln2pprZnNcK7DtG4Gn60CF8zRh7R0tw==
X-Received: by 2002:a63:ab01:0:b0:408:c856:f70a with SMTP id p1-20020a63ab01000000b00408c856f70amr11824878pgf.109.1655524033211;
        Fri, 17 Jun 2022 20:47:13 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d5d2:fc18:6baf:e16b])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902bd4900b0016782c55790sm2275233plx.232.2022.06.17.20.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 20:47:12 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 2/2] raw: convert raw sockets to RCU
Date:   Fri, 17 Jun 2022 20:47:05 -0700
Message-Id: <20220618034705.2809237-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220618034705.2809237-1-eric.dumazet@gmail.com>
References: <20220618034705.2809237-1-eric.dumazet@gmail.com>
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
 include/net/raw.h   | 11 +++++-
 include/net/rawv6.h |  1 +
 net/ipv4/af_inet.c  |  2 ++
 net/ipv4/raw.c      | 83 +++++++++++++++++++++------------------------
 net/ipv4/raw_diag.c | 22 +++++++-----
 net/ipv6/af_inet6.c |  3 ++
 net/ipv6/raw.c      | 28 +++++++--------
 7 files changed, 80 insertions(+), 70 deletions(-)

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
index 05e0de4a7c7f55798e0a9cd6753947ed11bd447d..d28bf0b901a2772089c07104447fba362dee7796 100644
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
 	struct net *net = dev_net(skb->dev);
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
@@ -990,11 +986,9 @@ static struct sock *raw_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 void *raw_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(&h->lock)
+	__acquires(RCU)
 {
-	struct raw_hashinfo *h = pde_data(file_inode(seq->file));
-
-	read_lock(&h->lock);
+	rcu_read_lock();
 	return *pos ? raw_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
 }
 EXPORT_SYMBOL_GPL(raw_seq_start);
@@ -1004,7 +998,7 @@ void *raw_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct sock *sk;
 
 	if (v == SEQ_START_TOKEN)
-		sk = raw_get_first(seq);
+		sk = raw_get_first(seq, 0);
 	else
 		sk = raw_get_next(seq, v);
 	++*pos;
@@ -1013,11 +1007,9 @@ void *raw_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 EXPORT_SYMBOL_GPL(raw_seq_next);
 
 void raw_seq_stop(struct seq_file *seq, void *v)
-	__releases(&h->lock)
+	__releases(RCU)
 {
-	struct raw_hashinfo *h = pde_data(file_inode(seq->file));
-
-	read_unlock(&h->lock);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(raw_seq_stop);
 
@@ -1079,6 +1071,7 @@ static __net_initdata struct pernet_operations raw_net_ops = {
 
 int __init raw_proc_init(void)
 {
+
 	return register_pernet_subsys(&raw_net_ops);
 }
 
diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index b6d92dc7b051d1ccf2df50689d041251d0745430..5f208e840d859f84bdbcbd0ea12c149f831cfc4a 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -57,31 +57,32 @@ static bool raw_lookup(struct net *net, struct sock *sk,
 static struct sock *raw_sock_get(struct net *net, const struct inet_diag_req_v2 *r)
 {
 	struct raw_hashinfo *hashinfo = raw_get_hashinfo(r);
+	struct hlist_nulls_head *hlist;
+	struct hlist_nulls_node *hnode;
 	struct sock *sk;
 	int slot;
 
 	if (IS_ERR(hashinfo))
 		return ERR_CAST(hashinfo);
 
-	read_lock(&hashinfo->lock);
+	rcu_read_lock();
 	for (slot = 0; slot < RAW_HTABLE_SIZE; slot++) {
-		sk_for_each(sk, &hashinfo->ht[slot]) {
+		hlist = &hashinfo->ht[slot];
+		hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
 			if (raw_lookup(net, sk, r)) {
 				/*
 				 * Grab it and keep until we fill
-				 * diag meaage to be reported, so
+				 * diag message to be reported, so
 				 * caller should call sock_put then.
-				 * We can do that because we're keeping
-				 * hashinfo->lock here.
 				 */
-				sock_hold(sk);
-				goto out_unlock;
+				if (refcount_inc_not_zero(&sk->sk_refcnt))
+					goto out_unlock;
 			}
 		}
 	}
 	sk = ERR_PTR(-ENOENT);
 out_unlock:
-	read_unlock(&hashinfo->lock);
+	rcu_read_unlock();
 
 	return sk;
 }
@@ -141,6 +142,8 @@ static void raw_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	struct raw_hashinfo *hashinfo = raw_get_hashinfo(r);
 	struct net *net = sock_net(skb->sk);
 	struct inet_diag_dump_data *cb_data;
+	struct hlist_nulls_head *hlist;
+	struct hlist_nulls_node *hnode;
 	int num, s_num, slot, s_slot;
 	struct sock *sk = NULL;
 	struct nlattr *bc;
@@ -157,7 +160,8 @@ static void raw_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
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

