Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4393F687918
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbjBBJlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbjBBJlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:41:12 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D8083064
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:41:09 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-514bf89d3cfso14916727b3.21
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 01:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vHMga2+LZhDSbzrFy8NhEvGjxVTUTm2Uha2q3rr3mnM=;
        b=X46ymG6mUV+YFxA9Mt9BQBG+Kp9/+sDL2NtAAyM1bfmKrL16oPo3TBY3eHb81QAHqi
         Uu729P/6bP+APzB1qtuEQr5ts/GQnCX+Fl09PPFEsIWBQFHlZZDUos6OJNkPX8Ct2Ohe
         kxPILQu+grust9NAtbkJxal+B0L2YrgMRcAJU1jL27PbOCfevHW01nIavw0A8qec8Y7R
         9CSZELgxmmvVL3HSwfvswDGz3TA+EZcp5Zi4h/KC3xTv10LPOnv9hnoX+qodjYlboPKF
         1UDkR4/WLpAaA/SUJrb+rH8620axLX4XffvTBaNtNKfFOmNVeiOyd+ApWKXIXg6Cxtly
         RHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vHMga2+LZhDSbzrFy8NhEvGjxVTUTm2Uha2q3rr3mnM=;
        b=H695X8pXzjnxevg7v6aaVNZV/VBT8DZEQ+ps/xEbzAwCNAFN6bUg+eMDe2oyRC49bJ
         lYe8K3fo+g6hyI+1c+Ti/azPowYSdq+zA+mys65GZPNfgyKOoGDjG8OUpb9DbTWBnViL
         2WykENXV70BCbfPLUco8wytPw+T/14MwATDDaJpqhXb1yR/m3BQOECedCfDo6w5+rIF7
         /A+mHtjY/o6aXv/+8YHK/ksjrnELR3somYkmmpqmpNt5ShuxoxrIU9k8LIzHiSsGZOqR
         PzLq12jzR3j+7L3nZHxdCY51bBKBU76EpX0K3lDLVI5zKF/FKvkFiV4btNFvosagneLn
         Y7JQ==
X-Gm-Message-State: AO0yUKVBYgYHL+BnHBNxV/C1Q6cvuBzU+hyNiFfPn719Gh3si7tRIVZU
        RRONM7snaIm5gn0L71qBk8mUD04HLzoOug==
X-Google-Smtp-Source: AK7set8Mut6MshLyDreNkjqgO3z3Jg46tPer+ozdVvF73PrNSil6WhgJeshpja9HN7HfNNnwIayesEq+3pM7Bw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:1cd:0:b0:373:8313:2991 with SMTP id
 196-20020a8101cd000000b0037383132991mr468748ywb.261.1675330868234; Thu, 02
 Feb 2023 01:41:08 -0800 (PST)
Date:   Thu,  2 Feb 2023 09:41:00 +0000
In-Reply-To: <20230202094100.3083177-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230202094100.3083177-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230202094100.3083177-4-edumazet@google.com>
Subject: [PATCH net-next 3/3] raw: use net_hash_mix() in hash function
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some applications seem to rely on RAW sockets.

If they use private netns, we can avoid piling all RAW
sockets bound to a given protocol into a single bucket.

Also place (struct raw_hashinfo).lock into its own
cache line to limit false sharing.

Alternative would be to have per-netns hashtables,
but this seems too expensive for most netns
where RAW sockets are not used.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/raw.h | 13 +++++++++++--
 net/ipv4/raw.c    | 13 +++++++------
 net/ipv6/raw.c    |  4 ++--
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/net/raw.h b/include/net/raw.h
index 5e665934ebc7cb5566bcc5e2ef45e6c911a3f0d8..2c004c20ed996d1dbe07f2c8d25edd2ce03cca03 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -15,6 +15,8 @@
 
 #include <net/inet_sock.h>
 #include <net/protocol.h>
+#include <net/netns/hash.h>
+#include <linux/hash.h>
 #include <linux/icmp.h>
 
 extern struct proto raw_prot;
@@ -29,13 +31,20 @@ int raw_local_deliver(struct sk_buff *, int);
 
 int raw_rcv(struct sock *, struct sk_buff *);
 
-#define RAW_HTABLE_SIZE	MAX_INET_PROTOS
+#define RAW_HTABLE_LOG	8
+#define RAW_HTABLE_SIZE	(1U << RAW_HTABLE_LOG)
 
 struct raw_hashinfo {
 	spinlock_t lock;
-	struct hlist_nulls_head ht[RAW_HTABLE_SIZE];
+
+	struct hlist_nulls_head ht[RAW_HTABLE_SIZE] ____cacheline_aligned;
 };
 
+static inline u32 raw_hashfunc(const struct net *net, u32 proto)
+{
+	return hash_32(net_hash_mix(net) ^ proto, RAW_HTABLE_LOG);
+}
+
 static inline void raw_hashinfo_init(struct raw_hashinfo *hashinfo)
 {
 	int i;
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 9865d15a08dfe96f0027c51a2d580dfa5903e5d4..94df935ee0c5a83a4b1393653b79ac6060b4f12a 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -93,7 +93,7 @@ int raw_hash_sk(struct sock *sk)
 	struct raw_hashinfo *h = sk->sk_prot->h.raw_hash;
 	struct hlist_nulls_head *hlist;
 
-	hlist = &h->ht[inet_sk(sk)->inet_num & (RAW_HTABLE_SIZE - 1)];
+	hlist = &h->ht[raw_hashfunc(sock_net(sk), inet_sk(sk)->inet_num)];
 
 	spin_lock(&h->lock);
 	__sk_nulls_add_node_rcu(sk, hlist);
@@ -160,9 +160,9 @@ static int icmp_filter(const struct sock *sk, const struct sk_buff *skb)
  * RFC 1122: SHOULD pass TOS value up to the transport layer.
  * -> It does. And not only TOS, but all IP header.
  */
-static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
+static int raw_v4_input(struct net *net, struct sk_buff *skb,
+			const struct iphdr *iph, int hash)
 {
-	struct net *net = dev_net(skb->dev);
 	struct hlist_nulls_head *hlist;
 	struct hlist_nulls_node *hnode;
 	int sdif = inet_sdif(skb);
@@ -193,9 +193,10 @@ static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 
 int raw_local_deliver(struct sk_buff *skb, int protocol)
 {
-	int hash = protocol & (RAW_HTABLE_SIZE - 1);
+	struct net *net = dev_net(skb->dev);
 
-	return raw_v4_input(skb, ip_hdr(skb), hash);
+	return raw_v4_input(net, skb, ip_hdr(skb),
+			    raw_hashfunc(net, protocol));
 }
 
 static void raw_err(struct sock *sk, struct sk_buff *skb, u32 info)
@@ -271,7 +272,7 @@ void raw_icmp_error(struct sk_buff *skb, int protocol, u32 info)
 	struct sock *sk;
 	int hash;
 
-	hash = protocol & (RAW_HTABLE_SIZE - 1);
+	hash = raw_hashfunc(net, protocol);
 	hlist = &raw_v4_hashinfo.ht[hash];
 
 	rcu_read_lock();
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 2e1c8060b51aed020194d9461bff20de0768d1e1..bac9ba747bdecf8df24acb6c980a822d8f237403 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -152,7 +152,7 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 	saddr = &ipv6_hdr(skb)->saddr;
 	daddr = saddr + 1;
 
-	hash = nexthdr & (RAW_HTABLE_SIZE - 1);
+	hash = raw_hashfunc(net, nexthdr);
 	hlist = &raw_v6_hashinfo.ht[hash];
 	rcu_read_lock();
 	sk_nulls_for_each(sk, hnode, hlist) {
@@ -338,7 +338,7 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 	struct sock *sk;
 	int hash;
 
-	hash = nexthdr & (RAW_HTABLE_SIZE - 1);
+	hash = raw_hashfunc(net, nexthdr);
 	hlist = &raw_v6_hashinfo.ht[hash];
 	rcu_read_lock();
 	sk_nulls_for_each(sk, hnode, hlist) {
-- 
2.39.1.456.gfc5497dd1b-goog

