Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8B666AB97
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 14:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjANN1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 08:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjANN1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 08:27:15 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF60902A;
        Sat, 14 Jan 2023 05:27:12 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q23-20020a17090a065700b002290913a521so7359588pje.5;
        Sat, 14 Jan 2023 05:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h3Srvg8gMya4A7dC+zbFGDFarP12psPNGrevloV3ZIE=;
        b=i5sl0EI73aBU350Ih2a6okf/lB3lZNHtwcNjFgFiTaMoiWC5ef2VxuntrUzmw7mSHT
         2ip60qxw+0qDBQsmXd+A7HMbPWP8R/2kBzh6aXfQdtmrZRkR4MX+UGzx6A5djqh7+uzp
         sJlEwRdkVqWv/2Iwen9KMRoYRt3FPKtqHmzCwpAajwB3aO6RMMq9/9a4CgS5Zifu0tkM
         jSWXVzH4KtCX8v8FEThtp0afTiqmo1AGHkesIQlYSO3T+Ps96V1M1xEAlurqryocarUI
         Vo1AwKCNOQ5KJih1kygHuhDlXQFubof0tTjnWZ0ikN8HvlECS3ioE+H2eHQrtzPAdvO8
         34TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h3Srvg8gMya4A7dC+zbFGDFarP12psPNGrevloV3ZIE=;
        b=lLtykyEvzyMKmr5VRpQgvIBnVO0FfJlwHwsp6lZdIg3cnY8eknqXWHYmJ/IRdxbUkt
         QkUHyLimos2dkw2iAPeOBh6AfxkoQV2qF04ZtW8CxVfGb7SRZmgmn2G4WernAYp0yUnN
         NwsZAHnBRkuEeisPgvb6Ah+mwPLXmpqed0npLpiMK3F1mphaAmSyz8xg+y3spn2a5bvM
         Gz183GfP0/UBZ0eN1ROhFW1ypXFQe1ANgOZR5s2mxDLi0THVrd4rtMSsdRxYjhjkBKcQ
         VExTZFYQg+Ng57a5Qlhp5Fniq37W5ZL8Y32rmmr8MoHMsH6T2XTrGs+QPYHfzn4QmBVN
         BLZQ==
X-Gm-Message-State: AFqh2krfP+ZY4fHpNjqn/IbsMFqk7VnZcEkIXJXMHcDnE5VlLaaV15l2
        JqmFNXNeOoRvlDldn85tzkk=
X-Google-Smtp-Source: AMrXdXuIPghXgreCiihjtujxptMYYmb2lOSiWUIiGznbbPhNewtQQsSVNkurnJARDzDWMIX0PFBSWw==
X-Received: by 2002:a17:90a:7309:b0:226:a617:44c1 with SMTP id m9-20020a17090a730900b00226a61744c1mr36852990pjk.13.1673702832210;
        Sat, 14 Jan 2023 05:27:12 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([114.253.32.172])
        by smtp.gmail.com with ESMTPSA id mz4-20020a17090b378400b0020aacde1964sm16001950pjb.32.2023.01.14.05.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 05:27:11 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v2 net] tcp: avoid the lookup process failing to get sk in ehash table
Date:   Sat, 14 Jan 2023 21:27:05 +0800
Message-Id: <20230114132705.78400-1-kerneljasonxing@gmail.com>
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
v2:
1) adding the sk node into the tail of list to prevent the race.
2) fix the race condition when handling time-wait socket hashdance.
---
 net/ipv4/inet_hashtables.c    | 10 ++++++++++
 net/ipv4/inet_timewait_sock.c |  6 +++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 24a38b56fab9..b0b54ad55507 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -650,7 +650,16 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	spin_lock(lock);
 	if (osk) {
 		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
+		if (sk_hashed(osk))
+			/* Before deleting the node, we insert a new one to make
+			 * sure that the look-up-sk process would not miss either
+			 * of them and that at least one node would exist in ehash
+			 * table all the time. Otherwise there's a tiny chance
+			 * that lookup process could find nothing in ehash table.
+			 */
+			__sk_nulls_add_node_tail_rcu(sk, list);
 		ret = sk_nulls_del_node_init_rcu(osk);
+		goto unlock;
 	} else if (found_dup_sk) {
 		*found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
 		if (*found_dup_sk)
@@ -660,6 +669,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
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

