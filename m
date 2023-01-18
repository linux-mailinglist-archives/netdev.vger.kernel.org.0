Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E85D671072
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 03:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjARB75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 20:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjARB74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 20:59:56 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2A232520;
        Tue, 17 Jan 2023 17:59:55 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so794303pjg.4;
        Tue, 17 Jan 2023 17:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dOQsc3ED40InAGrmwJD0MA/AC6XNhADd5xAaCdBAITM=;
        b=KxJJNA+tkQb4hVNsAjPgRgngCk2WF6G5BmHFchHXEE4S4LQ4Tklni31MPHUmzWB740
         QDL+ym2CjAAUmLW8jF00KFyYfV9+1A2o0Sz1WctHxvYoFutKpIMYC8A9wscg1kMLN+Rz
         VHXxge1qnCiCArHpJeZ7PxmeNQ2gU/idnyP3Pt9HJVdt58RorKdFfivW965D75hK4WHq
         1OKaJnFv8OA/YDhyI/SKBkMxfDUgIL4Dbd3abT9k63GEsIn7Jv3YSuVA4Mecxc77qscy
         5Jv9d2ClyESipYhw+296/RrPnkZzLd6EhVpEQJ51TQGdXalTD/66tveuewwGLWKn1ytb
         0jHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dOQsc3ED40InAGrmwJD0MA/AC6XNhADd5xAaCdBAITM=;
        b=yDPzKrVx8cQyf7V4h5dh2UKq06TmkC7FhMR6Oa3CvPHGYaiCcZVyMbmfvj9cCQBCjJ
         FpUdyVt9e3vDkGpN7gQsILoe8btgwMIOKELiT5TVZ/6s15SxarMmEoDGp/pKESjBsvO7
         ZiLXyUNx9mto9oIZPOrUF8KP0gIQke+sBNbf266plsS5I5RJ7mMyhNk7HKYeTrQmhq57
         M8vw+rHEiwsoOPK+dRxwsR3lgUVNy+POHiLur1wRXlPoZshcHkyl6u/M8hoKBmS3kJDM
         kQMni2UQeDuZHx7QHH2DdLVS8lsiWaJ46KBflRoD04EnG68pWWEHLsXtPqKySpIcpRnW
         TbXw==
X-Gm-Message-State: AFqh2kpE2VRWKBJ+hyGzDZURjamMi/8DTeJutffwu8M4LUa97AUh7Icc
        jfaXsEPfviYaIMnFqLp5FdQ=
X-Google-Smtp-Source: AMrXdXvMvLzOV7yoDbIUnjtJNlU9cHI0UfDBGSWEjFS1oHL34U2K86wm8hF+ZZ+Q+4uNHVY24AvtWg==
X-Received: by 2002:a17:902:9a82:b0:18d:d954:5f24 with SMTP id w2-20020a1709029a8200b0018dd9545f24mr5700101plp.6.1674007195222;
        Tue, 17 Jan 2023 17:59:55 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id n9-20020a170903110900b00178b6ccc8a0sm21976053plh.51.2023.01.17.17.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:59:54 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH v7 net] tcp: avoid the lookup process failing to get sk in ehash table
Date:   Wed, 18 Jan 2023 09:59:41 +0800
Message-Id: <20230118015941.1313-1-kerneljasonxing@gmail.com>
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
v3,4,5,6,7:
1) nit: adjust the coding style.

v2:
1) add the sk node into the tail of list to prevent the race.
2) fix the race condition when handling time-wait socket hashdance.
---
 net/ipv4/inet_hashtables.c    | 17 +++++++++++++++--
 net/ipv4/inet_timewait_sock.c |  8 ++++----
 2 files changed, 19 insertions(+), 6 deletions(-)

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
index 1d77d992e6e7..beed32fff484 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -91,10 +91,10 @@ void inet_twsk_put(struct inet_timewait_sock *tw)
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
@@ -147,7 +147,7 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 
 	spin_lock(lock);
 
-	inet_twsk_add_node_rcu(tw, &ehead->chain);
+	inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
 
 	/* Step 3: Remove SK from hash chain */
 	if (__sk_nulls_del_node_init_rcu(sk))
-- 
2.37.3

