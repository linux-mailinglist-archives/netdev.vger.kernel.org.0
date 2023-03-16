Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8A86BC325
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjCPBKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCPBKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:10:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F43A86174
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z4-20020a25bb04000000b00b392ae70300so174029ybg.21
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678929035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=21ELMqwFGb3XzsIv46zrtq6gETV6WmkkiKqdVrV7LaM=;
        b=pyUysuI1ooT/TAOGDFpEB3BYOTc2OSXu+q0R+n+jlsTZlJAfekvNP5hHlCeB3EuY5d
         TBnUlNuBRC3qMrQpo+k+RPTBOWBYpEWqjuHQP5V//rIqeUr4G1HO0WvbMFzcSOJWJuBc
         TVp9UzVePrK3oJF+vBij1aKwLDw10RDILJJddQ9Y5Envz3LVFp9NevtZ6IJvqEns+F5h
         6YleHfJL9tZxpekb+4hWH6jNxjfPwbgOuiqc6u1Kb96KcX2ZvAWnhAIlChfGB8+ypjSJ
         I4noE213ca0M8QKIS6Y8Nlx72apkOsPjRDpm2/ivPo1EF4S//tS0XyLHBjy70PaFgU3r
         skDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678929035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=21ELMqwFGb3XzsIv46zrtq6gETV6WmkkiKqdVrV7LaM=;
        b=oLxeWTZXQdGpsNEV5ohxk68kS1jbIUTgiGEi3ZlqFGIEMj25C8uBMESQ531VssnUcy
         vPr4bcgvYMPplDKzQeh0+2+4B0qwluu4TFivA3K9VbxR4liVTuelYHsLzGOof4fqrCiP
         6MESaLWIgXsuC/BjIF8AqlEPng/JO5hFHgFzvXaQQMHJ5AhEGAUSKJlzjgS/hbFaBqIm
         yNDxBhJWxsdtHRv5/Cr6kIgVyJMx6pjINEB0F4/PS7kuWQ1OTBNpYRB7ntN4mMpVH7Q0
         TGr/HTNPq9rj2+Ze9Emd9KhZMXpZKVxTvPcxBQ46LhOE9ZA9Uehe60+vuN+f/KmRM11a
         mLsQ==
X-Gm-Message-State: AO0yUKWcagJ1ByNu1Dpa/roYyFJZE1Ae7Evr67kJUD74dpUw1mpt7rkx
        AJ7D9WZHIgQYnxi2bj/h0wMOzH7Eo9QJeQ==
X-Google-Smtp-Source: AK7set/h7gR8OsZZl7E+MuKkjCNMYjTLcOvYr95jDohGUXWyUtBA3fVIRRoQYggw5yx3q/9nGWwWGhOpnBlszg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1141:b0:b54:ba46:6131 with SMTP
 id p1-20020a056902114100b00b54ba466131mr1681953ybu.11.1678929034813; Wed, 15
 Mar 2023 18:10:34 -0700 (PDT)
Date:   Thu, 16 Mar 2023 01:10:14 +0000
In-Reply-To: <20230316011014.992179-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316011014.992179-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316011014.992179-10-edumazet@google.com>
Subject: [PATCH net-next 9/9] net/packet: convert po->pressure to an atomic flag
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
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

Not only this removes some READ_ONCE()/WRITE_ONCE(),
this also removes one integer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 14 ++++++++------
 net/packet/internal.h  |  2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ec446452bbe8d1b140b551006a3b2c9e5bace787..7b9367b233d34d1a8338233f2c1bd96e9a28e14c 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1307,22 +1307,23 @@ static int __packet_rcv_has_room(const struct packet_sock *po,
 
 static int packet_rcv_has_room(struct packet_sock *po, struct sk_buff *skb)
 {
-	int pressure, ret;
+	bool pressure;
+	int ret;
 
 	ret = __packet_rcv_has_room(po, skb);
 	pressure = ret != ROOM_NORMAL;
 
-	if (READ_ONCE(po->pressure) != pressure)
-		WRITE_ONCE(po->pressure, pressure);
+	if (packet_sock_flag(po, PACKET_SOCK_PRESSURE) != pressure)
+		packet_sock_flag_set(po, PACKET_SOCK_PRESSURE, pressure);
 
 	return ret;
 }
 
 static void packet_rcv_try_clear_pressure(struct packet_sock *po)
 {
-	if (READ_ONCE(po->pressure) &&
+	if (packet_sock_flag(po, PACKET_SOCK_PRESSURE) &&
 	    __packet_rcv_has_room(po, NULL) == ROOM_NORMAL)
-		WRITE_ONCE(po->pressure,  0);
+		packet_sock_flag_set(po, PACKET_SOCK_PRESSURE, false);
 }
 
 static void packet_sock_destruct(struct sock *sk)
@@ -1409,7 +1410,8 @@ static unsigned int fanout_demux_rollover(struct packet_fanout *f,
 	i = j = min_t(int, po->rollover->sock, num - 1);
 	do {
 		po_next = pkt_sk(rcu_dereference(f->arr[i]));
-		if (po_next != po_skip && !READ_ONCE(po_next->pressure) &&
+		if (po_next != po_skip &&
+		    !packet_sock_flag(po_next, PACKET_SOCK_PRESSURE) &&
 		    packet_rcv_has_room(po_next, skb) == ROOM_NORMAL) {
 			if (i != j)
 				po->rollover->sock = i;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 58f042c631723118b4b2115142b37b828a4d9e9f..680703dbce5e04fc26d0fdeab1c1c911b71a8729 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -117,7 +117,6 @@ struct packet_sock {
 	spinlock_t		bind_lock;
 	struct mutex		pg_vec_lock;
 	unsigned long		flags;
-	int			pressure;
 	int			ifindex;	/* bound device		*/
 	__be16			num;
 	struct packet_rollover	*rollover;
@@ -146,6 +145,7 @@ enum packet_sock_flags {
 	PACKET_SOCK_TP_LOSS,
 	PACKET_SOCK_HAS_VNET_HDR,
 	PACKET_SOCK_RUNNING,
+	PACKET_SOCK_PRESSURE,
 };
 
 static inline void packet_sock_flag_set(struct packet_sock *po,
-- 
2.40.0.rc2.332.ga46443480c-goog

