Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F421766B84D
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 08:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbjAPHi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 02:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjAPHi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 02:38:26 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271AAEC5A;
        Sun, 15 Jan 2023 23:38:26 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id a184so20328616pfa.9;
        Sun, 15 Jan 2023 23:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wg2T7VbG1bTB43Zc6Xhxiu8pDGnHxwrmqsD8uohWqzI=;
        b=c/o2eejMpCEX9+LbXr0G3W+lLXEAq4aJO5DeAj/rq6nDlhFyWsdWwFMtsrqPALIkdZ
         tO+Y9ltQyunuUhqscifD/9mjbBvIyKUYr3Nvba6fJnXI7hNfRERcmUyB8r/a5skNHOg/
         e3CDBO2QkkgI54Ta0X3Y4NgO5NkOw4i0ktxzKy1cVoiaUWeb0SuRwRQhSUsSyjlKoyOc
         sPtFlq0uLnvuFNqiakRog1fj1jI4fyuv0LE0x7Ub/b7tw0SqIDOFU/BgUo+wADZiAE5H
         ozJmFiDkd/KBJgNeqgD4jwFECBqETrj12WCr1W/ybTb7APyrK83CvkwBfjBCLfdP1pt8
         qItQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wg2T7VbG1bTB43Zc6Xhxiu8pDGnHxwrmqsD8uohWqzI=;
        b=Dctd58H+AR8+tvfRIzR8c8jfuzyUkPH8CLggVd0PVOksYqTbDaPeIdZZEfyTcX8OzT
         QnfuD+mJGAOo3ylHQOlikWydI0+VN7T8uHjrigLrUR78PbPQQ9iyoesOT4aJYjmbUTcO
         URig7/iJKQ6yNKrLCOWfulHk+672o+SOKPRUbUFuv6XyDYB3KE5a0gcberpwg5s8DOcr
         eCzrbiJqzDUBqexTCRGS0qk+PN1xoAY+sFfiaQ9JoDCId6VMyXQErJHcwQ+EuhkpcCkA
         Kfda5CClJ0L9pnEQP7okhzp7dkKsvXPuszQ0XiBtJ2dY7Hg6/J+brzhA6Q7F/S5BEYoo
         L1tA==
X-Gm-Message-State: AFqh2kqyHy/AXI8sxUrrd6heZ/FC3Jl12D9iM4Q8z+UErhXDW2YG7e5+
        jYj1VCVT+jFJmJQXq+AqEQE=
X-Google-Smtp-Source: AMrXdXuA1AF7GFtm9Vbyh7WL1RWa6Q2O0F8ZmIdRf8KnJWCmui4roXckeQ41N3CzYX+F7LLWJGPq9w==
X-Received: by 2002:a05:6a00:bf5:b0:57c:2ab7:2c0b with SMTP id x53-20020a056a000bf500b0057c2ab72c0bmr12295617pfu.28.1673854705586;
        Sun, 15 Jan 2023 23:38:25 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id 65-20020a621844000000b005877d374069sm15020304pfy.10.2023.01.15.23.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 23:38:25 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v4 net] tcp: avoid the lookup process failing to get sk in ehash table
Date:   Mon, 16 Jan 2023 15:38:13 +0800
Message-Id: <20230116073813.24097-1-kerneljasonxing@gmail.com>
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
Link: https://lore.kernel.org/lkml/20230112065336.41034-1-kerneljasonxing@gmail.com/
---
v4:
1) adjust the code style and make it easier to read.

v3:
1) get rid of else-if statement.

v2:
1) adding the sk node into the tail of list to prevent the race.
2) fix the race condition when handling time-wait socket hashdance.
---
 net/ipv4/inet_hashtables.c    | 18 ++++++++++++++++--
 net/ipv4/inet_timewait_sock.c |  6 +++---
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 24a38b56fab9..c64eec874b31 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -650,8 +650,21 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	spin_lock(lock);
 	if (osk) {
 		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
-		ret = sk_nulls_del_node_init_rcu(osk);
-	} else if (found_dup_sk) {
+		if (sk_hashed(osk)) {
+			/* Before deleting the node, we insert a new one to make
+			 * sure that the look-up-sk process would not miss either
+			 * of them and that at least one node would exist in ehash
+			 * table all the time. Otherwise there's a tiny chance
+			 * that lookup process could find nothing in ehash table.
+			 */
+			__sk_nulls_add_node_tail_rcu(sk, list);
+			sk_nulls_del_node_init_rcu(osk);
+		} else {
+			ret = false;
+		}
+		goto unlock;
+	}
+	if (found_dup_sk) {
 		*found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
 		if (*found_dup_sk)
 			ret = false;
@@ -660,6 +673,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	if (ret)
 		__sk_nulls_add_node_rcu(sk, list);
 
+unlock:
 	spin_unlock(lock);
 
 	return ret;
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 1d77d992e6e7..6d681ef52bb2 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -91,10 +91,10 @@ void inet_twsk_put(struct inet_timewait_sock *tw)
 }
 EXPORT_SYMBOL_GPL(inet_twsk_put);
 
-static void inet_twsk_add_node_rcu(struct inet_timewait_sock *tw,
+static void inet_twsk_add_node_tail_rcu(struct inet_timewait_sock *tw,
 				   struct hlist_nulls_head *list)
 {
-	hlist_nulls_add_head_rcu(&tw->tw_node, list);
+	hlist_nulls_add_tail_rcu(&tw->tw_node, list);
 }
 
 static void inet_twsk_add_bind_node(struct inet_timewait_sock *tw,
@@ -147,7 +147,7 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 
 	spin_lock(lock);
 
-	inet_twsk_add_node_rcu(tw, &ehead->chain);
+	inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
 
 	/* Step 3: Remove SK from hash chain */
 	if (__sk_nulls_del_node_init_rcu(sk))
-- 
2.37.3

