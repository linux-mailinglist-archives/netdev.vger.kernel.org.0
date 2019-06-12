Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99CB242CBF
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502270AbfFLQwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:52:55 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:37957 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502240AbfFLQwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:52:55 -0400
Received: by mail-qt1-f201.google.com with SMTP id r58so15146414qtb.5
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M3F7Izx4cNirXpQhq1PSeTwK2hypRmIccMm2QY5z9Zc=;
        b=dtwz/w/58BlerQ85V8sQlBKx0E5WwXwD/DeTqFEjqaMxbgfiwUy2SpSb8J0jGLZiXi
         1/669j3RZmR4+sVwYCcvL/YDC+fLLIw3VWKLA0TFbCCgvDJSk8gCwsIaMf+X9p+8b+pw
         0NTtBOWCoDFby1ltP3MYq5J5L0xx477XEwSKAMO05ksAAP4nqmza/vWjSqFkR8WNEyrZ
         xFIWleFY5zsn2konXhUGT8UaGHmMDKrVNnONKFxoie5YKdAlWuvKErlA6Zoz1pFbuR/C
         IZJtSWNQ3cxfgRJAQpEJezNu8FOuBuaWD9Hv6X+09pKa2uxIDlJr/+d2MWPTof5Z3IE9
         T+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M3F7Izx4cNirXpQhq1PSeTwK2hypRmIccMm2QY5z9Zc=;
        b=VR+tGYIfz1s0kvfMc1kOaZbuC4DQlT0AkFKKj8ENI74GQafsbDfF/ldQUtjUmWH1pU
         19qGfHcFBxkaRphi1M4xO2pmNGjwYwlM0RV+fUuYpdNiIqu5pS+/NP0sZS1Jrci40Y+i
         Bu5TgRFG2K+yHVhKS0Xx4Q9xZs5KoyBocZOfGxiyM8aK4ZyGz/JpeqOv6B5KsXhJ+yPB
         lPvy4ShdVR8gtuhLIUp/UpLBvfC72K8p3sSDrPV0naNdaOZqVFO7nWT9cytznuXtVp4s
         Sx5ZliKE3iXGoJmVOqB17y59HXxskJnjGrChiNRSNcM51JAPU9Bo1df7bOnR+N+cNrcN
         vcZg==
X-Gm-Message-State: APjAAAXHkWWJaPIETzXF7jdEJePnLNq04ecJ7BsQSshwOiFQ/A15OCcp
        NNZHYCeToij98XM5mOxaXk1iLZJf5CN+Yg==
X-Google-Smtp-Source: APXvYqzsjtjoLqnnBlWpr9PKiBL0VPupjstoGhCD1wd5q+Ed2p/j6Gt+8yZTlaG0o+xH4ye/KC0vn6McATUI4g==
X-Received: by 2002:a37:90c2:: with SMTP id s185mr19013675qkd.161.1560358374184;
 Wed, 12 Jun 2019 09:52:54 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:52:30 -0700
In-Reply-To: <20190612165233.109749-1-edumazet@google.com>
Message-Id: <20190612165233.109749-6-edumazet@google.com>
Mime-Version: 1.0
References: <20190612165233.109749-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net-next 5/8] net/packet: make tp_drops atomic
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under DDOS, we want to be able to increment tp_drops without
touching the spinlock. This will help readers to drain
the receive queue slightly faster :/

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 20 +++++++++++---------
 net/packet/internal.h  |  1 +
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index a0564855ed9dca4be37f70ed81c6dee1b38aca39..2d499679811af53886ce0c8a1cdd74cd73107eac 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -758,7 +758,7 @@ static void prb_close_block(struct tpacket_kbdq_core *pkc1,
 	struct tpacket_hdr_v1 *h1 = &pbd1->hdr.bh1;
 	struct sock *sk = &po->sk;
 
-	if (po->stats.stats3.tp_drops)
+	if (atomic_read(&po->tp_drops))
 		status |= TP_STATUS_LOSING;
 
 	last_pkt = (struct tpacket3_hdr *)pkc1->prev;
@@ -2128,10 +2128,8 @@ static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
 
 drop_n_acct:
 	is_drop_n_account = true;
-	spin_lock(&sk->sk_receive_queue.lock);
-	po->stats.stats1.tp_drops++;
+	atomic_inc(&po->tp_drops);
 	atomic_inc(&sk->sk_drops);
-	spin_unlock(&sk->sk_receive_queue.lock);
 
 drop_n_restore:
 	if (skb_head != skb->data && skb_shared(skb)) {
@@ -2265,7 +2263,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	 * Anyways, moving it for V1/V2 only as V3 doesn't need this
 	 * at packet level.
 	 */
-		if (po->stats.stats1.tp_drops)
+		if (atomic_read(&po->tp_drops))
 			status |= TP_STATUS_LOSING;
 	}
 
@@ -2381,9 +2379,9 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 
 drop_n_account:
-	is_drop_n_account = true;
-	po->stats.stats1.tp_drops++;
 	spin_unlock(&sk->sk_receive_queue.lock);
+	atomic_inc(&po->tp_drops);
+	is_drop_n_account = true;
 
 	sk->sk_data_ready(sk);
 	kfree_skb(copy_skb);
@@ -3879,6 +3877,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 	void *data = &val;
 	union tpacket_stats_u st;
 	struct tpacket_rollover_stats rstats;
+	int drops;
 
 	if (level != SOL_PACKET)
 		return -ENOPROTOOPT;
@@ -3895,14 +3894,17 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 		memcpy(&st, &po->stats, sizeof(st));
 		memset(&po->stats, 0, sizeof(po->stats));
 		spin_unlock_bh(&sk->sk_receive_queue.lock);
+		drops = atomic_xchg(&po->tp_drops, 0);
 
 		if (po->tp_version == TPACKET_V3) {
 			lv = sizeof(struct tpacket_stats_v3);
-			st.stats3.tp_packets += st.stats3.tp_drops;
+			st.stats3.tp_drops = drops;
+			st.stats3.tp_packets += drops;
 			data = &st.stats3;
 		} else {
 			lv = sizeof(struct tpacket_stats);
-			st.stats1.tp_packets += st.stats1.tp_drops;
+			st.stats1.tp_drops = drops;
+			st.stats1.tp_packets += drops;
 			data = &st.stats1;
 		}
 
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 3bb7c5fb3bff2fd5d91c3d973d006d0cdde29a0b..b5bcff2b7a43b6c9cece329c8fe8b9b546b06cc5 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -131,6 +131,7 @@ struct packet_sock {
 	struct net_device __rcu	*cached_dev;
 	int			(*xmit)(struct sk_buff *skb);
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;
+	atomic_t		tp_drops ____cacheline_aligned_in_smp;
 };
 
 static struct packet_sock *pkt_sk(struct sock *sk)
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

