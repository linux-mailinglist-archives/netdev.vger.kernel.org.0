Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5405527C80
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbiEPDqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239815AbiEPDqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:46:40 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3387D35DCE;
        Sun, 15 May 2022 20:46:03 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so13133297pjq.2;
        Sun, 15 May 2022 20:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gJWrE+ScdUB+FGwXMcStVdPkZQiEkenelJsjAXFavM0=;
        b=g+A1Bb523cKPVseEUEjtqS1T4U9SPczhD8xk5Hxh8jbD515jXjiCShOzCQOHbC9dcC
         vuwRXKFviF/xF0Z+t2KZnWgofdJEpx+Z8U5wVtsDaTcHrtAdx39gwUDmdZxUfobXWVTA
         eH3dulevHIy1rEdtc/OBevRkSGNcih/DbYl0f9baomSrhzxQc2S+v/9/joyIXOydJbDL
         FwEAhfrhr7efSIF8kl0zuOD9nC+h2ziCHS8dfzqzptzjCd5rreu3061h0rNrt7CNozop
         wGD/NEbCoTy5WdFPsCmfJi6XFilD0jm5eIaU85qraGtB79vvvDUr2YH1M5wYMN5I9oym
         BBJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gJWrE+ScdUB+FGwXMcStVdPkZQiEkenelJsjAXFavM0=;
        b=dtdCBmzQvgG/UknHQrokCyz9KJTMqnULPLVqGkpJM/YGuwI7c8iMYh6GHrmAqmnYvG
         rHZFtdQdQz68xssmgZiIFGfWyS8fFF2zbUbI2HLzZFCv68xcfKH8PEiKYlxD6EErtOyX
         nmwQ8o7IC46KyVtW+zTqF3x0AWevZ+a5lCY+OxdMYntIHEiO3PRaUXSeiAh0rOiCU+S1
         4JVdoY3VR3K96tu7ANcsDueQRJY8VAAh+VNRwSK3oEgzA/aFaPyMAd11bWkp4M5W6DEZ
         gpxZ9CZrOaVNjj0A0HMOjpTx1++Ol2T2PVuFUSjDBv/540WOgdrHlOD4+B/WJbJ1oaUj
         cxyw==
X-Gm-Message-State: AOAM53232WsTBcFxrE2xRuuuy5Qju6tJd963OlvY3xqNHpsUwNXaBjKu
        +ijyu/7aGqeE876PTnnP7hOY+FFE5IBIXQ==
X-Google-Smtp-Source: ABdhPJwiRuLEmw1ovw2SC1NcLIdkxwuAr4HQY9Jgaqdf6KgU4oPVQD9QuhhuMqbAcH2byV5zGTMo7g==
X-Received: by 2002:a17:90b:4cc7:b0:1dc:18c5:adb2 with SMTP id nd7-20020a17090b4cc700b001dc18c5adb2mr17116319pjb.121.1652672762769;
        Sun, 15 May 2022 20:46:02 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id x184-20020a6286c1000000b0050dc762819bsm5636854pfd.117.2022.05.15.20.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 20:46:02 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 6/9] net: tcp: make tcp_rcv_state_process() return drop reason
Date:   Mon, 16 May 2022 11:45:16 +0800
Message-Id: <20220516034519.184876-7-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516034519.184876-1-imagedong@tencent.com>
References: <20220516034519.184876-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

For now, the return value of tcp_rcv_state_process() is treated as bool.
Therefore, we can make it return the reasons of the skb drops.

Meanwhile, the return value of tcp_child_process() comes from
tcp_rcv_state_process(), make it drop reasons by the way.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h   |  1 +
 include/net/tcp.h        |  8 +++++---
 net/ipv4/tcp_input.c     | 22 +++++++++++-----------
 net/ipv4/tcp_ipv4.c      | 20 +++++++++++++-------
 net/ipv4/tcp_minisocks.c | 11 ++++++-----
 net/ipv6/tcp_ipv6.c      | 19 ++++++++++++-------
 6 files changed, 48 insertions(+), 33 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 36e0971f4cc9..736899cc6a13 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -620,6 +620,7 @@ struct sk_buff;
 	FN(PKT_TOO_BIG)			\
 	FN(SOCKET_DESTROYED)		\
 	FN(TCP_PAWSACTIVEREJECTED)	\
+	FN(TCP_ABORTONDATA)		\
 	FN(MAX)
 
 /* The reason of skb drop, which is used in kfree_skb_reason().
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1e99f5c61f84..ea0eb2d4a743 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -339,7 +339,8 @@ void tcp_wfree(struct sk_buff *skb);
 void tcp_write_timer_handler(struct sock *sk);
 void tcp_delack_timer_handler(struct sock *sk);
 int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg);
-int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb);
+enum skb_drop_reason tcp_rcv_state_process(struct sock *sk,
+					   struct sk_buff *skb);
 void tcp_rcv_established(struct sock *sk, struct sk_buff *skb);
 void tcp_rcv_space_adjust(struct sock *sk);
 int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp);
@@ -385,8 +386,9 @@ enum tcp_tw_status tcp_timewait_state_process(struct inet_timewait_sock *tw,
 struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 			   struct request_sock *req, bool fastopen,
 			   bool *lost_race);
-int tcp_child_process(struct sock *parent, struct sock *child,
-		      struct sk_buff *skb);
+enum skb_drop_reason tcp_child_process(struct sock *parent,
+				       struct sock *child,
+				       struct sk_buff *skb);
 void tcp_enter_loss(struct sock *sk);
 void tcp_cwnd_reduction(struct sock *sk, int newly_acked_sacked, int newly_lost, int flag);
 void tcp_clear_retrans(struct tcp_sock *tp);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e8d26a68bc45..4717af0eaea7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6422,7 +6422,7 @@ static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
  *	address independent.
  */
 
-int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
+enum skb_drop_reason tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -6439,7 +6439,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 	case TCP_LISTEN:
 		if (th->ack)
-			return 1;
+			return SKB_DROP_REASON_TCP_FLAGS;
 
 		if (th->rst) {
 			SKB_DR_SET(reason, TCP_RESET);
@@ -6460,9 +6460,9 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			rcu_read_unlock();
 
 			if (!acceptable)
-				return 1;
+				return SKB_DROP_REASON_NOT_SPECIFIED;
 			consume_skb(skb);
-			return 0;
+			return SKB_NOT_DROPPED_YET;
 		}
 		SKB_DR_SET(reason, TCP_FLAGS);
 		goto discard;
@@ -6472,13 +6472,13 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		tcp_mstamp_refresh(tp);
 		queued = tcp_rcv_synsent_state_process(sk, skb, th);
 		if (queued >= 0)
-			return queued;
+			return (enum skb_drop_reason)queued;
 
 		/* Do step6 onward by hand. */
 		tcp_urg(sk, skb, th);
 		__kfree_skb(skb);
 		tcp_data_snd_check(sk);
-		return 0;
+		return SKB_NOT_DROPPED_YET;
 	}
 
 	tcp_mstamp_refresh(tp);
@@ -6582,7 +6582,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (tp->linger2 < 0) {
 			tcp_done(sk);
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONDATA);
-			return 1;
+			return SKB_DROP_REASON_TCP_ABORTONDATA;
 		}
 		if (TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(skb)->seq &&
 		    after(TCP_SKB_CB(skb)->end_seq - th->fin, tp->rcv_nxt)) {
@@ -6591,7 +6591,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 				tcp_fastopen_active_disable(sk);
 			tcp_done(sk);
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONDATA);
-			return 1;
+			return SKB_DROP_REASON_TCP_ABORTONDATA;
 		}
 
 		tmo = tcp_fin_time(sk);
@@ -6656,7 +6656,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			    after(TCP_SKB_CB(skb)->end_seq - th->fin, tp->rcv_nxt)) {
 				NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONDATA);
 				tcp_reset(sk, skb);
-				return 1;
+				return SKB_DROP_REASON_TCP_ABORTONDATA;
 			}
 		}
 		fallthrough;
@@ -6676,11 +6676,11 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 discard:
 		tcp_drop_reason(sk, skb, reason);
 	}
-	return 0;
+	return SKB_NOT_DROPPED_YET;
 
 consume:
 	__kfree_skb(skb);
-	return 0;
+	return SKB_NOT_DROPPED_YET;
 }
 EXPORT_SYMBOL(tcp_rcv_state_process);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 24eb42497a71..12a18c5035f4 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1670,7 +1670,8 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 		if (!nsk)
 			goto discard;
 		if (nsk != sk) {
-			if (tcp_child_process(sk, nsk, skb)) {
+			reason = tcp_child_process(sk, nsk, skb);
+			if (reason) {
 				rsk = nsk;
 				goto reset;
 			}
@@ -1679,7 +1680,8 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 	} else
 		sock_rps_save_rxhash(sk, skb);
 
-	if (tcp_rcv_state_process(sk, skb)) {
+	reason = tcp_rcv_state_process(sk, skb);
+	if (reason) {
 		rsk = sk;
 		goto reset;
 	}
@@ -1688,6 +1690,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 reset:
 	tcp_v4_send_reset(rsk, skb);
 discard:
+	SKB_DR_OR(reason, NOT_SPECIFIED);
 	kfree_skb_reason(skb, reason);
 	/* Be careful here. If this function gets more complicated and
 	 * gcc suffers from register pressure on the x86, sk (in %ebx)
@@ -2019,12 +2022,15 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		if (nsk == sk) {
 			reqsk_put(req);
 			tcp_v4_restore_cb(skb);
-		} else if (tcp_child_process(sk, nsk, skb)) {
-			tcp_v4_send_reset(nsk, skb);
-			goto discard_and_relse;
 		} else {
-			sock_put(sk);
-			return 0;
+			drop_reason = tcp_child_process(sk, nsk, skb);
+			if (drop_reason) {
+				tcp_v4_send_reset(nsk, skb);
+				goto discard_and_relse;
+			} else {
+				sock_put(sk);
+				return 0;
+			}
 		}
 	}
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 6854bb1fb32b..1a21018f6f64 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -821,11 +821,12 @@ EXPORT_SYMBOL(tcp_check_req);
  * be created.
  */
 
-int tcp_child_process(struct sock *parent, struct sock *child,
-		      struct sk_buff *skb)
+enum skb_drop_reason tcp_child_process(struct sock *parent,
+				       struct sock *child,
+				       struct sk_buff *skb)
 	__releases(&((child)->sk_lock.slock))
 {
-	int ret = 0;
+	enum skb_drop_reason reason = SKB_NOT_DROPPED_YET;
 	int state = child->sk_state;
 
 	/* record sk_napi_id and sk_rx_queue_mapping of child. */
@@ -833,7 +834,7 @@ int tcp_child_process(struct sock *parent, struct sock *child,
 
 	tcp_segs_in(tcp_sk(child), skb);
 	if (!sock_owned_by_user(child)) {
-		ret = tcp_rcv_state_process(child, skb);
+		reason = tcp_rcv_state_process(child, skb);
 		/* Wakeup parent, send SIGIO */
 		if (state == TCP_SYN_RECV && child->sk_state != state)
 			parent->sk_data_ready(parent);
@@ -847,6 +848,6 @@ int tcp_child_process(struct sock *parent, struct sock *child,
 
 	bh_unlock_sock(child);
 	sock_put(child);
-	return ret;
+	return reason;
 }
 EXPORT_SYMBOL(tcp_child_process);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 636ed23d9af0..d8236d51dd47 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1489,7 +1489,8 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 			goto discard;
 
 		if (nsk != sk) {
-			if (tcp_child_process(sk, nsk, skb))
+			reason = tcp_child_process(sk, nsk, skb);
+			if (reason)
 				goto reset;
 			if (opt_skb)
 				__kfree_skb(opt_skb);
@@ -1498,7 +1499,8 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 	} else
 		sock_rps_save_rxhash(sk, skb);
 
-	if (tcp_rcv_state_process(sk, skb))
+	reason = tcp_rcv_state_process(sk, skb);
+	if (reason)
 		goto reset;
 	if (opt_skb)
 		goto ipv6_pktoptions;
@@ -1685,12 +1687,15 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		if (nsk == sk) {
 			reqsk_put(req);
 			tcp_v6_restore_cb(skb);
-		} else if (tcp_child_process(sk, nsk, skb)) {
-			tcp_v6_send_reset(nsk, skb);
-			goto discard_and_relse;
 		} else {
-			sock_put(sk);
-			return 0;
+			drop_reason = tcp_child_process(sk, nsk, skb);
+			if (drop_reason) {
+				tcp_v6_send_reset(nsk, skb);
+				goto discard_and_relse;
+			} else {
+				sock_put(sk);
+				return 0;
+			}
 		}
 	}
 
-- 
2.36.1

