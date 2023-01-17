Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7E066E5BF
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 19:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjAQSOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 13:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbjAQSM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 13:12:29 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA706A4C;
        Tue, 17 Jan 2023 09:54:07 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id 7-20020a17090a098700b002298931e366so4952361pjo.2;
        Tue, 17 Jan 2023 09:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G8hEvDwlMSf2tfj591ozB94dwg3JRKRm8dUmMHqYxK0=;
        b=Nl/0cscOZqJTcM/thrcHXxKH8AZL5FFhvXmHpuqUMucIk3p3UcIc440BVuwhGgyfOT
         ilhS7N/N02uTlSfnBbsRr+k+wN/aiVoQyHQPovxUD6VX/69rNTHRnho1ibWP1i5WwklC
         hg6Bej8hrB0UYF6pfUjTGZo1jEN+Po/EaPnlPppxN7RGysPYhmm11vrT2O3ePryy2pDB
         Gld8wPFNLAYkoI/rCHLV1apvk4tnCwdTJNJfTpClmA+pUGvAOOiyokBoHPlUFqAfxoML
         YuFLYooqK0LlQY28YS7/Ggu1wckIzrqp0SxGtcxg8loVo+uzV8N9H1mzjk1mjBpas/7q
         /spA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G8hEvDwlMSf2tfj591ozB94dwg3JRKRm8dUmMHqYxK0=;
        b=wXddn6chPezn+z5C0LB5I69HCRo0XEWtyP4tp0Z0yrdZPbiN6alY3GlsZjo4SQGuq1
         ZDg2n3HuYO8AzuKu4x3t4UwbCwnSwlue/MItU6mIhD5rLpdv/Tn6B2ca2Or+Xlsjh8BI
         mzYzoJx6qIVQCcgnkAhiXMtY0Z7l5bS+fSUni7tI6X0N8bfjMgeaVpUbM7bJFgiCQkqn
         F4XeGscFvvP4AaroAkieQLppqYvuHqDa6vFZdP/EwDV/q/oegRHXuldTYO4VfuFstmBd
         Ggb+SBxuA9tRO37h8eX29iL1bEFCXMv1CJoyNF66mrEV+kmbyhSLJJu8f6LaY4isK0I1
         kktg==
X-Gm-Message-State: AFqh2ko5OZFTgyfecttfg7FrzkFa2ymPzwWisvjkouk1OAIbeBJJq1+V
        0moROS8NNg/UQ/Kur3I6tQE=
X-Google-Smtp-Source: AMrXdXsonDVhtVowwlGWbPKQPrwd3/OBWE4owFT4EVZnsBd1nRKKYJr++koerleABwUEjBrzPCfFrA==
X-Received: by 2002:a17:903:2687:b0:192:8ec5:fd58 with SMTP id jf7-20020a170903268700b001928ec5fd58mr2738024plb.6.1673978047288;
        Tue, 17 Jan 2023 09:54:07 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([114.253.32.172])
        by smtp.gmail.com with ESMTPSA id o1-20020a170902d4c100b0019320b4f832sm10512521plg.178.2023.01.17.09.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 09:54:06 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH v6 net] tcp: avoid the lookup process failing to get sk in ehash table
Date:   Wed, 18 Jan 2023 01:53:40 +0800
Message-Id: <20230117175340.91712-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

While one cpu is working on looking up the right socket from ehash
table, another cpu is done deleting the request socket and is about
to add (or is adding) the big socket from the table. It means that
we could miss both of them, even though it has little chance.

Let me draw a call trace map of the server side.
   CPU 0                           CPU 1
   -----                           -----
tcp_v4_rcv()                  syn_recv_sock()
                            inet_ehash_insert()
                            -> sk_nulls_del_node_init_rcu(osk)
__inet_lookup_established()
                            -> __sk_nulls_add_node_rcu(sk, list)

Notice that the CPU 0 is receiving the data after the final ack
during 3-way shakehands and CPU 1 is still handling the final ack.

Why could this be a real problem?
This case is happening only when the final ack and the first data
receiving by different CPUs. Then the server receiving data with
ACK flag tries to search one proper established socket from ehash
table, but apparently it fails as my map shows above. After that,
the server fetches a listener socket and then sends a RST because
it finds a ACK flag in the skb (data), which obeys RST definition
in RFC 793.

Besides, Eric pointed out there's one more race condition where it
handles tw socket hashdance. Only by adding to the tail of the list
before deleting the old one can we avoid the race if the reader has
already begun the bucket traversal and it would possibly miss the head.

Many thanks to Eric for great help from beginning to end.

Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/lkml/20230112065336.41034-1-kerneljasonxing@gmail.com/
---
v3,4,5,6:
1) nit: adjust the coding style.

v2:
1) add the sk node into the tail of list to prevent the race.
2) fix the race condition when handling time-wait socket hashdance.
---
 net/ipv4/inet_hashtables.c    | 17 +++++++++++++++--
 net/ipv4/inet_timewait_sock.c | 12 ++++++------
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 24a38b56fab9..f58d73888638 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -650,8 +650,20 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	spin_lock(lock);
 	if (osk) {
 		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
-		ret = sk_nulls_del_node_init_rcu(osk);
-	} else if (found_dup_sk) {
+		ret = sk_hashed(osk);
+		if (ret) {
+			/* Before deleting the node, we insert a new one to make
+			 * sure that the look-up-sk process would not miss either
+			 * of them and that at least one node would exist in ehash
+			 * table all the time. Otherwise there's a tiny chance
+			 * that lookup process could find nothing in ehash table.
+			 */
+			__sk_nulls_add_node_tail_rcu(sk, list);
+			sk_nulls_del_node_init_rcu(osk);
+		}
+		goto unlock;
+	}
+	if (found_dup_sk) {
 		*found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
 		if (*found_dup_sk)
 			ret = false;
@@ -660,6 +672,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	if (ret)
 		__sk_nulls_add_node_rcu(sk, list);
 
+unlock:
 	spin_unlock(lock);
 
 	return ret;
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 1d77d992e6e7..b66f2dea5a78 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -91,20 +91,20 @@ void inet_twsk_put(struct inet_timewait_sock *tw)
 }
 EXPORT_SYMBOL_GPL(inet_twsk_put);
 
-static void inet_twsk_add_node_rcu(struct inet_timewait_sock *tw,
-				   struct hlist_nulls_head *list)
+static void inet_twsk_add_node_tail_rcu(struct inet_timewait_sock *tw,
+					struct hlist_nulls_head *list)
 {
-	hlist_nulls_add_head_rcu(&tw->tw_node, list);
+	hlist_nulls_add_tail_rcu(&tw->tw_node, list);
 }
 
 static void inet_twsk_add_bind_node(struct inet_timewait_sock *tw,
-				    struct hlist_head *list)
+					struct hlist_head *list)
 {
 	hlist_add_head(&tw->tw_bind_node, list);
 }
 
 static void inet_twsk_add_bind2_node(struct inet_timewait_sock *tw,
-				     struct hlist_head *list)
+					struct hlist_head *list)
 {
 	hlist_add_head(&tw->tw_bind2_node, list);
 }
@@ -147,7 +147,7 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 
 	spin_lock(lock);
 
-	inet_twsk_add_node_rcu(tw, &ehead->chain);
+	inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
 
 	/* Step 3: Remove SK from hash chain */
 	if (__sk_nulls_del_node_init_rcu(sk))
-- 
2.37.3

