Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57FD66B5B3
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 03:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbjAPCrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 21:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjAPCrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 21:47:23 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B187E7286;
        Sun, 15 Jan 2023 18:47:21 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso32580121pjt.0;
        Sun, 15 Jan 2023 18:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=abWfWv7dx4M21bFcNtuB4f9xzNG3ZWU0shwDajE0q7k=;
        b=TcpScGUIrGvJSXZgqAPxAiPea0EJwMAvQlVaPUDbDh0YoXF5dBbuCSkAongzzdFXdb
         +h1Op4dUg/W7Kn3+JuBps7B51HGtvh1pcwbSLSBh5dFrmFEBozuFGWycb8xKHHbzRlRs
         /Jn854qSvVwEGSTAOG+tjbMRLn8UliJV3K8OJxFtwmo0kHHorpdoR8WqTn/N/HgnRgVg
         dvoVEmn7j6wLKnKeLsU5128L/0qNtyBzK/yGiq+cG3bRbsPJxuMIzkyCFcqthOkugXEa
         MBUuF4AN+Zc32mqdbeB1Kx6AQMRydOIaiMV0UZwFXo5twKXgY1tVqXIf/sjzVvHX/yoO
         9ywg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=abWfWv7dx4M21bFcNtuB4f9xzNG3ZWU0shwDajE0q7k=;
        b=lOPHbmTJ26EtwBeGnGtO02Ef1RWibycFhiwK7ourG+RNM9mrfzdW873aCjD754yNMq
         dQn45u6x4CjQM0PkCFyEieNbSKgpVbtrJsp80x8pM4VBr/gGw7hD1ESBGHUR5t6H2wpb
         PFJ+RLMKSTyC5SB95iibs9i8qOe1tQgjxv2DmclBjVZpSJgIwVz1GyE9FcmH1NJ9gEJq
         UkkgqL7u8iiY9iSkOzVrG5yqne+8WlV1/4gJgakkVeiKRb9PZXsNKlPy0VzLnKiiAJnd
         Jkq1tq9oiWPBkCwrLAWDXgMtkicjE76SBuMhbW+1ycdZG/WWcACy/twuG2z2rSVbdVZ2
         BNwg==
X-Gm-Message-State: AFqh2kppqMleaWFBTDm2XDe4HyrLg3hfgmobJEs02SS4Mgojse7DGTNz
        zwY+Wa8TW/L4vBTEP3RSPzU=
X-Google-Smtp-Source: AMrXdXshFAWZ3CUECgS0/72Q4g8B4z2MmJltI2s8Aeo+GTLha1iEXGI5YktYAwT52bEgDu5d6vsEQQ==
X-Received: by 2002:a17:902:e042:b0:194:9b4e:1c90 with SMTP id x2-20020a170902e04200b001949b4e1c90mr588179plx.57.1673837241165;
        Sun, 15 Jan 2023 18:47:21 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902d90500b001946119c22esm7091715plz.146.2023.01.15.18.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 18:47:20 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v3 net] tcp: avoid the lookup process failing to get sk in ehash table
Date:   Mon, 16 Jan 2023 10:46:07 +0800
Message-Id: <20230116024607.47164-1-kerneljasonxing@gmail.com>
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
v3:
1) get rid of else-if statement.

v2:
1) adding the sk node into the tail of list to prevent the race.
2) fix the race condition when handling time-wait socket hashdance.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 net/ipv4/inet_hashtables.c    | 14 +++++++++++++-
 net/ipv4/inet_timewait_sock.c |  6 +++---
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 24a38b56fab9..28374f44e3d8 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -650,8 +650,19 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	spin_lock(lock);
 	if (osk) {
 		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
+		if (sk_hashed(osk)) {
+			/* Before deleting the node, we insert a new one to make
+			 * sure that the look-up-sk process would not miss either
+			 * of them and that at least one node would exist in ehash
+			 * table all the time. Otherwise there's a tiny chance
+			 * that lookup process could find nothing in ehash table.
+			 */
+			__sk_nulls_add_node_tail_rcu(sk, list);
+		}
 		ret = sk_nulls_del_node_init_rcu(osk);
-	} else if (found_dup_sk) {
+		goto unlock;
+	}
+	if (found_dup_sk) {
 		*found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
 		if (*found_dup_sk)
 			ret = false;
@@ -660,6 +671,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
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

