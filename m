Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C9E66BBCA
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjAPKdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjAPKdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:33:53 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFDC1ABC1;
        Mon, 16 Jan 2023 02:33:51 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id dw9so27266440pjb.5;
        Mon, 16 Jan 2023 02:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5cUtz3N0x3JZNipLsn4fvRzLAQUyw9ViksturGz/Y1w=;
        b=EpfoGEWrY4o0hXsJPnY9JrxDdM14yasX0rQreOsV27HppHB8ikJflLOkM19nJ7s3co
         mKBvOmdl/9scR5WrSgbyA3BjC+j+jDXP/NbcufPXlGNmjeb2Od3HxuyihopDebFs3cPq
         5/CH3tXqwbw6LD5RI8TF2yv6ks1ZXggt09VKap6tltkDZt3P47By1cgKPpLsaYMiDwbc
         6MziB/RZ9aKHlFMP1JVI9/J5RRSvycZbLbB1J2opUuReQ4Cq36nlKgATrwYPYNidStB6
         9IKqhqM4w02IqHUCOmXEYcBuisPQrw8CJvDcBQ0ONCkPZRCJ7pH69OYgFTAs/GGTLRrW
         D87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5cUtz3N0x3JZNipLsn4fvRzLAQUyw9ViksturGz/Y1w=;
        b=4PNbbk0QVrQmHsQNUkivLze6/FTCDUPOtvvDGMuoZY1FrerjPnu4cLR+vfQp6NZcLg
         y1SOhhL2uwhbMSeFBhVR1kfNjehb0E4EqHUl4qt/0/ZmbFvjOm92JlFUlDeGPumKJnLU
         4tn2ja+flB34Yy7B3/EewBRL4NNPUo0zE7Q+m8emytqcrdx0PIyzM709f5EJ7XJeED0T
         Zcu+dVYJF1jTLSRxE4VN/RMtXmFnDFllc594HmzDU+LiqFXGMN2EQTsZSSwj+0yXgPSo
         oBVrbydpG2UGdKh1hyca/iEdmH94W8MASwiXE1O1OxMt0CI/wMGpG5iiSUWq8YAQm2Ot
         LqSw==
X-Gm-Message-State: AFqh2kqn/c6N58ANIw5J2tu6bVbQOvUF4LLxygN2tP/uIH9hoWmHfz2a
        HZsqN3dHIb8fWDY2EVp1gVQ=
X-Google-Smtp-Source: AMrXdXsAbmsHe6SIKWFiYXfBmlRDdGJKrq0Rwh23NEnGQ0pmUClmbJAl25kGrfkV2dgknKMYvsjkUg==
X-Received: by 2002:a17:90a:be10:b0:226:d7e8:e122 with SMTP id a16-20020a17090abe1000b00226d7e8e122mr37762188pjs.19.1673865231302;
        Mon, 16 Jan 2023 02:33:51 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id nm21-20020a17090b19d500b00227252ce57fsm11987880pjb.21.2023.01.16.02.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 02:33:50 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v5 net] tcp: avoid the lookup process failing to get sk in ehash table
Date:   Mon, 16 Jan 2023 18:33:41 +0800
Message-Id: <20230116103341.70956-1-kerneljasonxing@gmail.com>
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
v5:
1) adjust the style once more.

v4:
1) adjust the code style and make it easier to read.

v3:
1) get rid of else-if statement.

v2:
1) adding the sk node into the tail of list to prevent the race.
2) fix the race condition when handling time-wait socket hashdance.
---
 net/ipv4/inet_hashtables.c    | 17 +++++++++++++++--
 net/ipv4/inet_timewait_sock.c |  6 +++---
 2 files changed, 18 insertions(+), 5 deletions(-)

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

