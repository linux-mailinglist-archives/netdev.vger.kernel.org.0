Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3319B13C48
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfEDXtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:49:06 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:49428 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbfEDXtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 19:49:06 -0400
Received: by mail-qt1-f201.google.com with SMTP id w34so10573992qtc.16
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 16:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NjercGLlU8RwOrxe/nCfrKMzIX+LOpMtiF9xMARy5Fo=;
        b=HwvDHh2xFzVmbVTqmJU1h8DogcDKoMUmG7HXma+OTxtMnsj0MeJFZOE40ejOZqMhhE
         zqO9XksnHzszWnAPAWhpLJ8mZEXwO4Lf4zmjuAowgPKo/DoiQX1O6WYrJv8MG1eeukBU
         iVaGGh3bgdQIVEkpFrSr8tqd1Gt32vJzDn5qDv+ABWomqAEVBf3+Wbr3bgJQYEQYJV+3
         tIvVpV3LhNYD1HJKkIZalBrAZl+Dzfa28OyN/VhnyePpcUaoe68ObvB+dG41ZL5CuOAL
         HWrowPAS5CcphDr+/yPHB7UVqDFjiFnDEuiT9FIz2waAerhVw0tJbRIlDXyna6QTiuPE
         s4ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NjercGLlU8RwOrxe/nCfrKMzIX+LOpMtiF9xMARy5Fo=;
        b=cqJdXODVuZMo5jc6ntawE8ub46Bx+GAGkgfg7m5A64njR5wZ6kBClsWJQkEyaOZ34o
         WXteUypGfXDaEaHKYrY6abbZ2HU8o/ic0/PEQZFiY3yOJqMx5D55nGC8vvyNPwtfhcKS
         3wYgAu06CAS+RIZGOOpZv9CnViWq4KFPszhLb11HsTbglB9hwi72aJAUCv68quV/QIOr
         IXh9/SY9zo4KW//yrzog/A0MMxSnMEPZrEHZaXvdXuRjJBryout9aUXEg6HnOPnhj5m+
         vaDhElNojhFc0ckFvCwXuPqflJMGOO6UDba82rV88I/Vqo5oNmR8odSCuqd5mINC3ur9
         ARnw==
X-Gm-Message-State: APjAAAUkkq7ZP9/0ZN4eCJhOL2+3OOddwNaYVzagQ+eetoq9t3Ti8Z0i
        xhnJ6I4BraGMoiW18KT9n3HRseubPIIbbw==
X-Google-Smtp-Source: APXvYqwjmu8UOuwTZklNFdSZ0eSU74w3m53KdMtJhOiuEruwJJiW1r17FwaYLx9ZEfmKcE/tmX7qxQutHGhWcA==
X-Received: by 2002:ad4:4025:: with SMTP id q5mr14213004qvp.41.1557013745589;
 Sat, 04 May 2019 16:49:05 -0700 (PDT)
Date:   Sat,  4 May 2019 16:48:54 -0700
In-Reply-To: <20190504234854.57812-1-edumazet@google.com>
Message-Id: <20190504234854.57812-3-edumazet@google.com>
Mime-Version: 1.0
References: <20190504234854.57812-1-edumazet@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH net-next 2/2] net_sched: sch_fq: handle non connected flows
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FQ packet scheduler assumed that packets could be classified
based on their owning socket.

This means that if a UDP server uses one UDP socket to send
packets to different destinations, packets all land
in one FQ flow.

This is unfair, since each TCP flow has a unique bucket, meaning
that in case of pressure (fully utilised uplink), TCP flows
have more share of the bandwidth.

If we instead detect unconnected sockets, we can use a stochastic
hash based on the 4-tuple hash.

This also means a QUIC server using one UDP socket will properly
spread the outgoing packets to different buckets, and in-kernel
pacing based on EDT model will no longer risk having big rb-tree on
one flow.

Note that UDP application might provide the skb->hash in an
ancillary message at sendmsg() time to avoid the cost of a dissection
in fq packet scheduler.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_fq.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index ee138365ec45ee01cb10f149ae5b1d7635fa1185..26a94e5cd5dfae34109649b04a1ebcaafa0f545b 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -270,6 +270,17 @@ static struct fq_flow *fq_classify(struct sk_buff *skb, struct fq_sched_data *q)
 		 */
 		sk = (struct sock *)((hash << 1) | 1UL);
 		skb_orphan(skb);
+	} else if (sk->sk_state == TCP_CLOSE) {
+		unsigned long hash = skb_get_hash(skb) & q->orphan_mask;
+		/*
+		 * Sockets in TCP_CLOSE are non connected.
+		 * Typical use case is UDP sockets, they can send packets
+		 * with sendto() to many different destinations.
+		 * We probably could use a generic bit advertising
+		 * non connected sockets, instead of sk_state == TCP_CLOSE,
+		 * if we care enough.
+		 */
+		sk = (struct sock *)((hash << 1) | 1UL);
 	}
 
 	root = &q->fq_root[hash_ptr(sk, q->fq_trees_log)];
@@ -290,7 +301,7 @@ static struct fq_flow *fq_classify(struct sk_buff *skb, struct fq_sched_data *q)
 			 * It not, we need to refill credit with
 			 * initial quantum
 			 */
-			if (unlikely(skb->sk &&
+			if (unlikely(skb->sk == sk &&
 				     f->socket_hash != sk->sk_hash)) {
 				f->credit = q->initial_quantum;
 				f->socket_hash = sk->sk_hash;
@@ -315,7 +326,7 @@ static struct fq_flow *fq_classify(struct sk_buff *skb, struct fq_sched_data *q)
 
 	fq_flow_set_detached(f);
 	f->sk = sk;
-	if (skb->sk)
+	if (skb->sk == sk)
 		f->socket_hash = sk->sk_hash;
 	f->credit = q->initial_quantum;
 
-- 
2.21.0.1020.gf2820cf01a-goog

