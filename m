Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908FA527C87
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239891AbiEPDrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239869AbiEPDqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:46:43 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3134336143;
        Sun, 15 May 2022 20:46:10 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y41so12895243pfw.12;
        Sun, 15 May 2022 20:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4h0zgMDxpbPpu7uK7IrYU1z+wSYdiXLHkR9K2kpvGrM=;
        b=Pswn3QCQrz7he6ge1lmOsqYf+aYwknurixcmoPz4XUa2J0Otr8NMZrGsDrWdeHP1Vl
         XEf2MSsYe9/VL1Mp6LB98x0lN6qHFBPN2N1f+fULXI6clrgeNN0TLXXWmnlfPKaZ4KyC
         D0Ug6MNa5bk2yCkqQ4FStFiEYhumzJYyRokHUz3sqLby8YMRuPSaEvHMPr6i81hvPfzE
         RDwqHAM6TUko10wsIzQLJ8G/3UezLOP+Rptsme21KqZG1NMXPlrloan4dCUcRdsKnfqN
         g+TbZEkoTXGqYTBoVAx2CNC3nS2i5RfSFSAxVzNfvGSsu3yP4riSiZEVWt2r23xqS7Kf
         rXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4h0zgMDxpbPpu7uK7IrYU1z+wSYdiXLHkR9K2kpvGrM=;
        b=zr0lweOMwM3oPjxGFsHxTZeHdWLppVyfeAD2wZF8zZIFIJpmfKu4/KvAaQ3YMUG2/r
         2KxCAO1Qls1kBi0lJA3jTIucvc5YLPVUqbbzov6y8fRg+rXpzzAsvC0mahx3jO9rtoL9
         d1UGpmpmCavXpD6gu6oWBtxatsikPsOPDIsnrAMEikdEbUJ0BrMmLVXdlM9d26u0Q5vK
         tPmmmfRYNzQ+nWKuYzbb7CeCDxGIGxljjqCGG5yAB6rK3/UwUM5977PGxXQo/35BWaek
         n1RCQd+Njl3wdwC9wsYGuMZNZoFo1KwMyIv7/qvhY+G0+z4GiTQumsu2PnPjKkSpgmpj
         eLiw==
X-Gm-Message-State: AOAM5319w+lHxGPtFGb2ALJc7N3YEQ2u9zs0/rLbNpEJQJsVgA5Mjs9g
        HzzJcAewqoPWgWYSirD+eT8=
X-Google-Smtp-Source: ABdhPJxhcWu1+NUPaGpDgeZqp9U4i53btRj2OqiRs+GdjQd2351BYlKBlhMoGqXEek5MUDc3ab+nqA==
X-Received: by 2002:a63:e155:0:b0:3c6:7514:6c0d with SMTP id h21-20020a63e155000000b003c675146c0dmr13605514pgk.249.1652672770441;
        Sun, 15 May 2022 20:46:10 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id x184-20020a6286c1000000b0050dc762819bsm5636854pfd.117.2022.05.15.20.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 20:46:10 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 8/9] net: tcp: add skb drop reasons to tcp tw code path
Date:   Mon, 16 May 2022 11:45:18 +0800
Message-Id: <20220516034519.184876-9-imagedong@tencent.com>
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

In order to get the reasons of skb drops, add a function argument of
type 'enum skb_drop_reason *reason' to tcp_timewait_state_process().

In the origin code, all packets to time-wait socket are treated as
dropping with kfree_skb(), which can make users confused. Therefore,
we use consume_skb() for the skbs that are 'good'. We can check the
value of 'reason' to decide use kfree_skb() or consume_skb().

The new reason 'TIMEWAIT' is added for the case that the skb is dropped
as the socket in time-wait state.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h   |  5 +++++
 include/net/tcp.h        |  7 ++++---
 net/ipv4/tcp_ipv4.c      | 11 +++++++++--
 net/ipv4/tcp_minisocks.c | 24 ++++++++++++++++++++----
 net/ipv6/tcp_ipv6.c      | 10 ++++++++--
 5 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4578bbab5a3e..8d18fc5a5af6 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -560,6 +560,10 @@ struct sk_buff;
  * SKB_DROP_REASON_TCP_REQQFULLDROP
  *	request queue of the listen socket is full, corresponding to
  *	LINUX_MIB_TCPREQQFULLDROP
+ *
+ * SKB_DROP_REASON_TIMEWAIT
+ *	socket is in time-wait state and all packet that received will
+ *	be treated as 'drop', except a good 'SYN' packet
  */
 #define __DEFINE_SKB_DROP_REASON(FN)	\
 	FN(NOT_SPECIFIED)		\
@@ -631,6 +635,7 @@ struct sk_buff;
 	FN(TCP_ABORTONDATA)		\
 	FN(LISTENOVERFLOWS)		\
 	FN(TCP_REQQFULLDROP)		\
+	FN(TIMEWAIT)			\
 	FN(MAX)
 
 /* The reason of skb drop, which is used in kfree_skb_reason().
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 082dd0627e2e..88217b8d95ac 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -380,9 +380,10 @@ enum tcp_tw_status {
 };
 
 
-enum tcp_tw_status tcp_timewait_state_process(struct inet_timewait_sock *tw,
-					      struct sk_buff *skb,
-					      const struct tcphdr *th);
+enum tcp_tw_status
+tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
+			   const struct tcphdr *th,
+			   enum skb_drop_reason *reason);
 struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 			   struct request_sock *req, bool fastopen,
 			   bool *lost_race);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 708f92b03f42..9174ee162633 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2134,7 +2134,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		inet_twsk_put(inet_twsk(sk));
 		goto csum_error;
 	}
-	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th)) {
+	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th,
+					   &drop_reason)) {
 	case TCP_TW_SYN: {
 		struct sock *sk2 = inet_lookup_listener(dev_net(skb->dev),
 							&tcp_hashinfo, skb,
@@ -2150,12 +2151,18 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			refcounted = false;
 			goto process;
 		}
+		/* TCP_FLAGS or NO_SOCKET? */
+		SKB_DR_SET(drop_reason, TCP_FLAGS);
 	}
 		/* to ACK */
 		fallthrough;
 	case TCP_TW_ACK:
 		tcp_v4_timewait_ack(sk, skb);
-		break;
+		refcounted = false;
+		if (drop_reason)
+			goto discard_it;
+		else
+			goto put_and_return;
 	case TCP_TW_RST:
 		tcp_v4_send_reset(sk, skb);
 		inet_twsk_deschedule_put(inet_twsk(sk));
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 1a21018f6f64..329724118b7f 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -83,13 +83,15 @@ tcp_timewait_check_oow_rate_limit(struct inet_timewait_sock *tw,
  */
 enum tcp_tw_status
 tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
-			   const struct tcphdr *th)
+			   const struct tcphdr *th,
+			   enum skb_drop_reason *reason)
 {
 	struct tcp_options_received tmp_opt;
 	struct tcp_timewait_sock *tcptw = tcp_twsk((struct sock *)tw);
 	bool paws_reject = false;
 
 	tmp_opt.saw_tstamp = 0;
+	*reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (th->doff > (sizeof(*th) >> 2) && tcptw->tw_ts_recent_stamp) {
 		tcp_parse_options(twsk_net(tw), skb, &tmp_opt, 0, NULL);
 
@@ -113,11 +115,16 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 			return tcp_timewait_check_oow_rate_limit(
 				tw, skb, LINUX_MIB_TCPACKSKIPPEDFINWAIT2);
 
-		if (th->rst)
+		if (th->rst) {
+			SKB_DR_SET(*reason, TCP_RESET);
 			goto kill;
+		}
 
-		if (th->syn && !before(TCP_SKB_CB(skb)->seq, tcptw->tw_rcv_nxt))
+		if (th->syn && !before(TCP_SKB_CB(skb)->seq,
+				       tcptw->tw_rcv_nxt)) {
+			SKB_DR_SET(*reason, TCP_FLAGS);
 			return TCP_TW_RST;
+		}
 
 		/* Dup ACK? */
 		if (!th->ack ||
@@ -143,6 +150,9 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 		}
 
 		inet_twsk_reschedule(tw, TCP_TIMEWAIT_LEN);
+
+		/* skb should be free normally on this case. */
+		*reason = SKB_NOT_DROPPED_YET;
 		return TCP_TW_ACK;
 	}
 
@@ -174,6 +184,7 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 			 * protocol bug yet.
 			 */
 			if (twsk_net(tw)->ipv4.sysctl_tcp_rfc1337 == 0) {
+				SKB_DR_SET(*reason, TCP_RESET);
 kill:
 				inet_twsk_deschedule_put(tw);
 				return TCP_TW_SUCCESS;
@@ -216,11 +227,14 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 		if (isn == 0)
 			isn++;
 		TCP_SKB_CB(skb)->tcp_tw_isn = isn;
+		*reason = SKB_NOT_DROPPED_YET;
 		return TCP_TW_SYN;
 	}
 
-	if (paws_reject)
+	if (paws_reject) {
+		SKB_DR_SET(*reason, TCP_RFC7323_PAWS);
 		__NET_INC_STATS(twsk_net(tw), LINUX_MIB_PAWSESTABREJECTED);
+	}
 
 	if (!th->rst) {
 		/* In this case we must reset the TIMEWAIT timer.
@@ -232,9 +246,11 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 		if (paws_reject || th->ack)
 			inet_twsk_reschedule(tw, TCP_TIMEWAIT_LEN);
 
+		SKB_DR_OR(*reason, TIMEWAIT);
 		return tcp_timewait_check_oow_rate_limit(
 			tw, skb, LINUX_MIB_TCPACKSKIPPEDTIMEWAIT);
 	}
+	SKB_DR_SET(*reason, TCP_RESET);
 	inet_twsk_put(tw);
 	return TCP_TW_SUCCESS;
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 27c51991bd54..5c777006de3d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1795,7 +1795,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		goto csum_error;
 	}
 
-	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th)) {
+	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th,
+					   &drop_reason)) {
 	case TCP_TW_SYN:
 	{
 		struct sock *sk2;
@@ -1815,12 +1816,17 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			refcounted = false;
 			goto process;
 		}
+		SKB_DR_SET(drop_reason, TCP_FLAGS);
 	}
 		/* to ACK */
 		fallthrough;
 	case TCP_TW_ACK:
 		tcp_v6_timewait_ack(sk, skb);
-		break;
+		refcounted = false;
+		if (drop_reason)
+			goto discard_it;
+		else
+			goto put_and_return;
 	case TCP_TW_RST:
 		tcp_v6_send_reset(sk, skb);
 		inet_twsk_deschedule_put(inet_twsk(sk));
-- 
2.36.1

