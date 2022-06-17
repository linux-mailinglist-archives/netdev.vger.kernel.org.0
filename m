Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2D054F4DB
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381615AbiFQKGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381580AbiFQKGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:06:34 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E6669CD3;
        Fri, 17 Jun 2022 03:06:21 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x138so3757309pfc.12;
        Fri, 17 Jun 2022 03:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3Gn96qHlAoOUfAbi7BjXnxvBjcQcrs/ECG334HuI7sY=;
        b=Ts1MZdgJkC2/9j5vyPjBafloOsTkLrk9OwOwpXSF9iyE7EveUfQS0T38F5Lu+L0mKU
         R+W7prqkkFVo3/o86RSdJ0n7XNjps+4kRVJVUkSZd46Z/HOEBN9Fdm/V+B9yaXg+I7rW
         SD/vwiGoGMzkWeeju4ZlAhkpEDzMXu6bD+H3nFnboF89ZIS0O5xMQKp/mgDil4BzUbeW
         NheUTBfQip2m3oukAeadxxLXiRC1qrUQIFWPLYKZb+mEt/xTwyioTM4chSk0GX8c7nfY
         E04+shTSIz5vlAoeCHMGT0KJYt3mYOLsz750EqYpXYi2S4OmqqI/baDUrgQ5dH+EWgRT
         RTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Gn96qHlAoOUfAbi7BjXnxvBjcQcrs/ECG334HuI7sY=;
        b=PyeijKUFLjanXQqUFl8vPahKmgGb1lLKz1FCnk1SC/2hOKp6EE4LWyjcBeCXl12hHd
         jclWi/B3FoeAPWjZca7mdj030YRFx07J6VCN+oz1LGbkSXUzFJ/Grt710HSt92wh0gPa
         lBSsKrv7yerXmVmJ0QbBceG3ezMlzmUgiHEv/AR4CO1eXoXu3di1C9n1zuL16SmKItxk
         D83FhaIGjWssiSpWGGDZq9ZmMqeijGfyNDP133E0pw2YA645P0Mb1tveEuUmRwW+bNuK
         TdIdkSdTMyIQlTlROb2laAnHRSPybkylki0qBJlrRHc2ACFVf5DR7CdGy62IAMIIu0G+
         XKSg==
X-Gm-Message-State: AJIora+37S8eqgTghXHMKaztQ/2w7QmprrUpescNqPnM7AGVM6UFnEY0
        1469FFkgQ/8hZEeltSBB1wc=
X-Google-Smtp-Source: AGRyM1sVX1ASEstPSF1wQrJpQQnyxI+ZfDd7zM26b85Zn9RXnY4DfUoxWfSk7r+t1i8QCbWvhMbAmQ==
X-Received: by 2002:a63:2a47:0:b0:3fe:2437:5d25 with SMTP id q68-20020a632a47000000b003fe24375d25mr8616143pgq.539.1655460381469;
        Fri, 17 Jun 2022 03:06:21 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.10])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f7ca00b001621ce92196sm3126210plw.86.2022.06.17.03.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:06:21 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH net-next v4 6/8] net: tcp: add skb drop reasons to tcp tw code path
Date:   Fri, 17 Jun 2022 18:05:12 +0800
Message-Id: <20220617100514.7230-7-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220617100514.7230-1-imagedong@tencent.com>
References: <20220617100514.7230-1-imagedong@tencent.com>
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

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reported-by: Eric Dumazet <edumazet@google.com>
---
v2:
- skb is not freed on TCP_TW_ACK and 'ret' is not initizalized, fix
  it (Eric Dumazet)
---
 include/net/dropreason.h |  6 ++++++
 include/net/tcp.h        |  7 ++++---
 net/ipv4/tcp_ipv4.c      |  8 ++++++--
 net/ipv4/tcp_minisocks.c | 23 +++++++++++++++++++----
 net/ipv6/tcp_ipv6.c      |  7 +++++--
 5 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 74512e60ab12..90cdb7321926 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -246,6 +246,12 @@ enum skb_drop_reason {
 	 * socket is full, corresponding to LINUX_MIB_TCPREQQFULLDROP
 	 */
 	SKB_DROP_REASON_TCP_REQQFULLDROP,
+	/**
+	 * @SKB_DROP_REASON_TIMEWAIT: socket is in time-wait state and all
+	 * packet that received will be treated as 'drop', except a good
+	 * 'SYN' packet
+	 */
+	SKB_DROP_REASON_TIMEWAIT,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 16da150150c3..1a88fabf0cce 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -379,9 +379,10 @@ enum tcp_tw_status {
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
index e1064273062a..f2ed9763d504 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1975,6 +1975,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			reqsk_put(req);
 			goto discard_it;
 		}
+		drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 		if (tcp_checksum_complete(skb)) {
 			reqsk_put(req);
 			goto csum_error;
@@ -2049,6 +2050,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	if (drop_reason)
 		goto discard_and_relse;
 
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	nf_reset_ct(skb);
 
 	if (tcp_filter(sk, skb)) {
@@ -2104,7 +2106,6 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	}
 
 discard_it:
-	SKB_DR_OR(drop_reason, NOT_SPECIFIED);
 	/* Discard frame. */
 	kfree_skb_reason(skb, drop_reason);
 	return 0;
@@ -2128,7 +2129,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		inet_twsk_put(inet_twsk(sk));
 		goto csum_error;
 	}
-	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th)) {
+	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th,
+					   &drop_reason)) {
 	case TCP_TW_SYN: {
 		struct sock *sk2 = inet_lookup_listener(dev_net(skb->dev),
 							&tcp_hashinfo, skb,
@@ -2144,6 +2146,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			refcounted = false;
 			goto process;
 		}
+		/* TCP_FLAGS or NO_SOCKET? */
+		SKB_DR_SET(drop_reason, TCP_FLAGS);
 	}
 		/* to ACK */
 		fallthrough;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 6854bb1fb32b..dd640574d00f 100644
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
@@ -219,8 +230,10 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 		return TCP_TW_SYN;
 	}
 
-	if (paws_reject)
+	if (paws_reject) {
+		SKB_DR_SET(*reason, TCP_RFC7323_PAWS);
 		__NET_INC_STATS(twsk_net(tw), LINUX_MIB_PAWSESTABREJECTED);
+	}
 
 	if (!th->rst) {
 		/* In this case we must reset the TIMEWAIT timer.
@@ -232,9 +245,11 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
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
index dbe356a166c5..9aeb0a7b7c12 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1644,6 +1644,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			reqsk_put(req);
 			goto discard_it;
 		}
+		drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 		if (tcp_checksum_complete(skb)) {
 			reqsk_put(req);
 			goto csum_error;
@@ -1715,6 +1716,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	if (drop_reason)
 		goto discard_and_relse;
 
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (tcp_filter(sk, skb)) {
 		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto discard_and_relse;
@@ -1766,7 +1768,6 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	}
 
 discard_it:
-	SKB_DR_OR(drop_reason, NOT_SPECIFIED);
 	kfree_skb_reason(skb, drop_reason);
 	return 0;
 
@@ -1790,7 +1791,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		goto csum_error;
 	}
 
-	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th)) {
+	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th,
+					   &drop_reason)) {
 	case TCP_TW_SYN:
 	{
 		struct sock *sk2;
@@ -1810,6 +1812,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			refcounted = false;
 			goto process;
 		}
+		SKB_DR_SET(drop_reason, TCP_FLAGS);
 	}
 		/* to ACK */
 		fallthrough;
-- 
2.36.1

