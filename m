Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F34278F4F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 19:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgIYREp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 13:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729477AbgIYREo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 13:04:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926B1C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:04:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b8so3207211yba.10
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=sS14qXlHQeACaFSxqte1R6lt/hihH4b4s5UsI5x9MDg=;
        b=L3pHUsT2LCEXRIJy5TuZ6GzxAx8/aIBXz+0MykXPqftm0UNl4QiZwM6eWD72GbVZMB
         NC3s6EIHJsPpdXgC1GK1Wlu9QvvirZmj9v5yQ58qROnPLs/J1n75XMuyR5MGuu6bCwR2
         CtYA23SXJaIWf6sIItLH8y0CwXtW1gcAS2OL1hqYHTGgexfz0Qo6o3cyUfqZdp7EFfCn
         fVmTjWunMtZcSp+uqDzvCfuPWkgeBeWXPQcD+zKUckIxBUuLSYiacg4btRFoG9hTiwe/
         3cpBY8cy/IPJZfRz2X26cnlrMuYJ5hUsFuQ9OYKYeSfzXcw1iY1f0qhkFtfg6XNrikPc
         /pDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sS14qXlHQeACaFSxqte1R6lt/hihH4b4s5UsI5x9MDg=;
        b=bxO5Rp7ndYqID5ulWXDNzbdJoabXDj3gES729v84aE6TKbb+i3GsUh3LLys8JvLJgX
         SGMENL0Uf+Yf25etFv7MC5yAEtVm1Dv8qHEywgII1K5+pI9Lr9USy8DdeK9AzSV2oUrF
         PHYrfSGMI3yu60nvl3aDFDxgzMK7psPSFWPBZZaojnOuDHD/1k8cJbE8CxxWsg+HgclY
         1QEK7BfQTHzaV8KMZ11lvCLBV18fc2I8wo8pbdkgQLvyVbl3U6OrOfGESCejpLpMoBvq
         xCdvVWHP38hunooA7wJHCpxxHWWtvd8HHwAyU+o4pSKGwz9jKHHsbPoNsyZOJaOiBFcL
         RvHA==
X-Gm-Message-State: AOAM532NYy+DNzL6x7Ib8Qc5NObwi5M733/2L1v4vGDkiAc6N9CQCGcm
        IsLDQbxPM0J7VCSODgRSJaMR9BY3hQ0=
X-Google-Smtp-Source: ABdhPJxMr23e1heat0S6+ua8ocW+hgJLPvVrg76oCswp6iEGy8/D4UbW3+vM8S/95cSiyrM0cATDxFkwUUQ=
Sender: "ycheng via sendgmr" <ycheng@ycheng.svl.corp.google.com>
X-Received: from ycheng.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef4:fc76])
 (user=ycheng job=sendgmr) by 2002:a25:9d88:: with SMTP id v8mr226244ybp.43.1601053482840;
 Fri, 25 Sep 2020 10:04:42 -0700 (PDT)
Date:   Fri, 25 Sep 2020 10:04:30 -0700
In-Reply-To: <20200925170431.1099943-1-ycheng@google.com>
Message-Id: <20200925170431.1099943-4-ycheng@google.com>
Mime-Version: 1.0
References: <20200925170431.1099943-1-ycheng@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH net-next 3/4] tcp: simplify tcp_mark_skb_lost
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch consolidates and simplifes the loss marking logic used
by a few loss detections (RACK, RFC6675, NewReno). Previously
each detection uses a subset of several intertwined subroutines.
This unncessary complexity has led to bugs (and fixes of bug fixes).

tcp_mark_skb_lost now is the single one routine to mark a packet loss
when a loss detection caller deems an skb ist lost:

   1. rewind tp->retransmit_hint_skb if skb has lower sequence or
      all lost ones have been retransmitted.

   2. book-keeping: adjust flags and counts depending on if skb was
      retransmitted or not.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 59 +++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 37 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0f8d33b95678..9be41b69a75b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1006,7 +1006,11 @@ static void tcp_check_sack_reordering(struct sock *sk, const u32 low_seq,
 		      ts ? LINUX_MIB_TCPTSREORDER : LINUX_MIB_TCPSACKREORDER);
 }
 
-/* This must be called before lost_out is incremented */
+ /* This must be called before lost_out or retrans_out are updated
+  * on a new loss, because we want to know if all skbs previously
+  * known to be lost have already been retransmitted, indicating
+  * that this newly lost skb is our next skb to retransmit.
+  */
 static void tcp_verify_retransmit_hint(struct tcp_sock *tp, struct sk_buff *skb)
 {
 	if ((!tp->retransmit_skb_hint && tp->retrans_out >= tp->lost_out) ||
@@ -1018,32 +1022,25 @@ static void tcp_verify_retransmit_hint(struct tcp_sock *tp, struct sk_buff *skb)
 
 void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
 {
+	__u8 sacked = TCP_SKB_CB(skb)->sacked;
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	tcp_skb_mark_lost_uncond_verify(tp, skb);
-	if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_RETRANS) {
-		/* Account for retransmits that are lost again */
-		TCP_SKB_CB(skb)->sacked &= ~TCPCB_SACKED_RETRANS;
-		tp->retrans_out -= tcp_skb_pcount(skb);
-		NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPLOSTRETRANSMIT,
-			      tcp_skb_pcount(skb));
-	}
-}
-
-/* Sum the number of packets on the wire we have marked as lost.
- * There are two cases we care about here:
- * a) Packet hasn't been marked lost (nor retransmitted),
- *    and this is the first loss.
- * b) Packet has been marked both lost and retransmitted,
- *    and this means we think it was lost again.
- */
-static void tcp_sum_lost(struct tcp_sock *tp, struct sk_buff *skb)
-{
-	__u8 sacked = TCP_SKB_CB(skb)->sacked;
+	if (sacked & TCPCB_SACKED_ACKED)
+		return;
 
-	if (!(sacked & TCPCB_LOST) ||
-	    ((sacked & TCPCB_LOST) && (sacked & TCPCB_SACKED_RETRANS)))
-		tp->lost += tcp_skb_pcount(skb);
+	tcp_verify_retransmit_hint(tp, skb);
+	if (sacked & TCPCB_LOST) {
+		if (sacked & TCPCB_SACKED_RETRANS) {
+			/* Account for retransmits that are lost again */
+			TCP_SKB_CB(skb)->sacked &= ~TCPCB_SACKED_RETRANS;
+			tp->retrans_out -= tcp_skb_pcount(skb);
+			NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPLOSTRETRANSMIT,
+				      tcp_skb_pcount(skb));
+		}
+	} else {
+		tp->lost_out += tcp_skb_pcount(skb);
+		TCP_SKB_CB(skb)->sacked |= TCPCB_LOST;
+	}
 }
 
 static void tcp_skb_mark_lost(struct tcp_sock *tp, struct sk_buff *skb)
@@ -1057,17 +1054,6 @@ static void tcp_skb_mark_lost(struct tcp_sock *tp, struct sk_buff *skb)
 	}
 }
 
-void tcp_skb_mark_lost_uncond_verify(struct tcp_sock *tp, struct sk_buff *skb)
-{
-	tcp_verify_retransmit_hint(tp, skb);
-
-	tcp_sum_lost(tp, skb);
-	if (!(TCP_SKB_CB(skb)->sacked & (TCPCB_LOST|TCPCB_SACKED_ACKED))) {
-		tp->lost_out += tcp_skb_pcount(skb);
-		TCP_SKB_CB(skb)->sacked |= TCPCB_LOST;
-	}
-}
-
 /* Updates the delivered and delivered_ce counts */
 static void tcp_count_delivered(struct tcp_sock *tp, u32 delivered,
 				bool ece_ack)
@@ -2688,8 +2674,7 @@ void tcp_simple_retransmit(struct sock *sk)
 	unsigned int mss = tcp_current_mss(sk);
 
 	skb_rbtree_walk(skb, &sk->tcp_rtx_queue) {
-		if (tcp_skb_seglen(skb) > mss &&
-		    !(TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED))
+		if (tcp_skb_seglen(skb) > mss)
 			tcp_mark_skb_lost(sk, skb);
 	}
 
-- 
2.28.0.681.g6f77f65b4e-goog

