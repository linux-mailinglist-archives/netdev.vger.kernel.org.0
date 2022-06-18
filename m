Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF02550299
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 06:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiFREEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 00:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiFREEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 00:04:21 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EC35838D
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 21:04:19 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 31so5560995pgv.11
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 21:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V/iKtgFsie2k5cthvENgoin5HjR9Z95hzBDrSlaIGxQ=;
        b=eTNt4gWB3lRySRTq6cZcqyCy0cs2MR36ikwHXJhlB83cdZIA9QXSsbFzEuUa9UJyZH
         uYQTipc3Ean2kWIuTWFGl++w7H2OfSsN6dtaPLVVp7zdy6wMjDiMxx3fxu+2gZULO+IV
         uDKEHYewymZjeGzr12VkhtQB8zoaFIVpLu1nNIe8lLqyUYNK+3+YOJFplati/EtGgRiM
         TkTNItJosuqpJvNzI9ISCw9d2hYdRLnyMvAfDeiZEBNF5i2vi4y5ALE9oBdvSdJcbQRg
         mC92oGSBq6GTXGCZaSOz1BDyZlPFjdf6djLqcxs/9aHf2ztC4ZxO6TaYrhV40LPI5Ihc
         XICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V/iKtgFsie2k5cthvENgoin5HjR9Z95hzBDrSlaIGxQ=;
        b=EapsrVoKNujjcU9TC6C4FwuioJBkM1jZ9szBmFpIMa6R94YHO4A2l2S281L1tr/hKo
         8y92e3RKMPCbn5QxG5fofYj0gpWm15ch4f1L6dmAejlT1wb/vMUPMUG1e2aqeYFPgaP+
         YUlkjGWgBIW4/OPTqhAbzd2ir/AmZQN0ZHVxR1fSLD7LIKKSV0fYk3B69PJ4d4ZBLuGI
         rmoTx/MDVOp2wF8Av5T29vLwm5UMicxjP0Gm7IzmVB/BVpA01V1EAOsDFSHKKFAIPS+T
         CCVD/PGJDPpr/mdi72BYnofa5od9y/T76ffSH+4QBa5JZ2K2uQPm/FoY6IcVKDmhJRdk
         8B4w==
X-Gm-Message-State: AJIora9FicvWb2nkfhp9rwbCwcyHM95irAQR62P236RiHilj4jAG+5xF
        3Cb6YPXkdrpfMLcmETIhrmM=
X-Google-Smtp-Source: AGRyM1uVQCFy+kRNrfxZBAMsbSDog1lKnPlVB6WS/KFrK6opR5ymYwr/p9EzT7FdNHPXY5rLwoYHxQ==
X-Received: by 2002:a63:3f42:0:b0:408:c84e:509c with SMTP id m63-20020a633f42000000b00408c84e509cmr11676935pga.75.1655525058738;
        Fri, 17 Jun 2022 21:04:18 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d5d2:fc18:6baf:e16b])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e21200b0015e8d4eb2ddsm4250839plb.295.2022.06.17.21.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 21:04:18 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] ping: convert to RCU lookups, get rid of rwlock
Date:   Fri, 17 Jun 2022 21:04:15 -0700
Message-Id: <20220618040415.2810867-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
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

Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ping.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 1a43ca73f94d68800f7a849a01238f3d089ff8b5..3d6fc6d841b8e72671e807e7b1fc7a6686a78fb6 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -50,7 +50,7 @@
 
 struct ping_table {
 	struct hlist_nulls_head	hash[PING_HTABLE_SIZE];
-	rwlock_t		lock;
+	spinlock_t		lock;
 };
 
 static struct ping_table ping_table;
@@ -82,7 +82,7 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 	struct sock *sk2 = NULL;
 
 	isk = inet_sk(sk);
-	write_lock_bh(&ping_table.lock);
+	spin_lock(&ping_table.lock);
 	if (ident == 0) {
 		u32 i;
 		u16 result = ping_port_rover + 1;
@@ -128,14 +128,15 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 	if (sk_unhashed(sk)) {
 		pr_debug("was not hashed\n");
 		sock_hold(sk);
-		hlist_nulls_add_head(&sk->sk_nulls_node, hlist);
+		sock_set_flag(sk, SOCK_RCU_FREE);
+		hlist_nulls_add_head_rcu(&sk->sk_nulls_node, hlist);
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 	}
-	write_unlock_bh(&ping_table.lock);
+	spin_unlock(&ping_table.lock);
 	return 0;
 
 fail:
-	write_unlock_bh(&ping_table.lock);
+	spin_unlock(&ping_table.lock);
 	return 1;
 }
 EXPORT_SYMBOL_GPL(ping_get_port);
@@ -153,19 +154,19 @@ void ping_unhash(struct sock *sk)
 	struct inet_sock *isk = inet_sk(sk);
 
 	pr_debug("ping_unhash(isk=%p,isk->num=%u)\n", isk, isk->inet_num);
-	write_lock_bh(&ping_table.lock);
+	spin_lock(&ping_table.lock);
 	if (sk_hashed(sk)) {
-		hlist_nulls_del(&sk->sk_nulls_node);
-		sk_nulls_node_init(&sk->sk_nulls_node);
+		hlist_nulls_del_init_rcu(&sk->sk_nulls_node);
 		sock_put(sk);
 		isk->inet_num = 0;
 		isk->inet_sport = 0;
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 	}
-	write_unlock_bh(&ping_table.lock);
+	spin_unlock(&ping_table.lock);
 }
 EXPORT_SYMBOL_GPL(ping_unhash);
 
+/* Called under rcu_read_lock() */
 static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 {
 	struct hlist_nulls_head *hslot = ping_hashslot(&ping_table, net, ident);
@@ -190,8 +191,6 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 		return NULL;
 	}
 
-	read_lock_bh(&ping_table.lock);
-
 	ping_portaddr_for_each_entry(sk, hnode, hslot) {
 		isk = inet_sk(sk);
 
@@ -230,13 +229,11 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 		    sk->sk_bound_dev_if != sdif)
 			continue;
 
-		sock_hold(sk);
 		goto exit;
 	}
 
 	sk = NULL;
 exit:
-	read_unlock_bh(&ping_table.lock);
 
 	return sk;
 }
@@ -588,7 +585,7 @@ void ping_err(struct sk_buff *skb, int offset, u32 info)
 	sk->sk_err = err;
 	sk_error_report(sk);
 out:
-	sock_put(sk);
+	return;
 }
 EXPORT_SYMBOL_GPL(ping_err);
 
@@ -994,7 +991,6 @@ enum skb_drop_reason ping_rcv(struct sk_buff *skb)
 			reason = __ping_queue_rcv_skb(sk, skb2);
 		else
 			reason = SKB_DROP_REASON_NOMEM;
-		sock_put(sk);
 	}
 
 	if (reason)
@@ -1080,13 +1076,13 @@ static struct sock *ping_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 void *ping_seq_start(struct seq_file *seq, loff_t *pos, sa_family_t family)
-	__acquires(ping_table.lock)
+	__acquires(RCU)
 {
 	struct ping_iter_state *state = seq->private;
 	state->bucket = 0;
 	state->family = family;
 
-	read_lock_bh(&ping_table.lock);
+	rcu_read_lock();
 
 	return *pos ? ping_get_idx(seq, *pos-1) : SEQ_START_TOKEN;
 }
@@ -1112,9 +1108,9 @@ void *ping_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 EXPORT_SYMBOL_GPL(ping_seq_next);
 
 void ping_seq_stop(struct seq_file *seq, void *v)
-	__releases(ping_table.lock)
+	__releases(RCU)
 {
-	read_unlock_bh(&ping_table.lock);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(ping_seq_stop);
 
@@ -1198,5 +1194,5 @@ void __init ping_init(void)
 
 	for (i = 0; i < PING_HTABLE_SIZE; i++)
 		INIT_HLIST_NULLS_HEAD(&ping_table.hash[i], i);
-	rwlock_init(&ping_table.lock);
+	spin_lock_init(&ping_table.lock);
 }
-- 
2.36.1.476.g0c4daa206d-goog

