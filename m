Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B85942F66
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfFLS5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:57:30 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:57042 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfFLS5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:57:30 -0400
Received: by mail-qk1-f201.google.com with SMTP id j128so6451537qkd.23
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 11:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cmsb5a9Q+W6v7ZbQkj9o1KUHVdfxZHp3uFlANLCAj3w=;
        b=qa6EJ1ThtpokLOo2uk5WjyfDZSKik2htmcifnyblB9smoyOJw1Q/zw4blB4cW/F9gk
         QYdWu59mgFXXHkQ6SYnKh5wTsqIfZHPer1FjILIeldz+WqRw5rRmukMlvb3MRX9OX38q
         X/lhDvRKPxGa++XwbLdC3GogDO4Px0YLvQS+/2AhANaHiF4NYIkpBzCDiWqI3Ipie4C6
         8fKFro5ZchGunYyhesxzUuOtnqe4NxTPAEBmNE3qOJeVS/ZrqeVRpRVfQ7i1azMDR1Yw
         /9YxeeD5zIWzgVrcwUWXWTF4cQJ522ryhUrvahxp51fxUZlFsCbxqk1BIE3ceHV8aOSj
         5ABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cmsb5a9Q+W6v7ZbQkj9o1KUHVdfxZHp3uFlANLCAj3w=;
        b=qI4n3J+QVcq8V8dKoMEWMYGYSk/nb4nhfBWwCSixr8ozEqTX7yf0YEHm9XDVqe9joN
         HhIYltZCfBlIS5/S6AJWVlBAcYdK5A1a84RQmPRudxf6okT5Z25ZDkqhZeGxjk5rq8H2
         N5bvYrHsb3FzqTYxUG75H6vfoo98Du+wRcjV7Ez7qs+iRXrOegDIXwe4bDbfUFzYwcjZ
         3GmtTiaxDaEBcmbGmq7CRUUwEaPm1zWK7Bdf7pG/3rm/UcHD7YqJTO0mYAYPI5h7qLtE
         D0GyMdHVnuFRKVyWJAEsGBoNpqatuQECSV5ECHPL+WvkSw+S3PwwFeKqs0/48yL+niYZ
         rkDQ==
X-Gm-Message-State: APjAAAWpSFPHVbXkwTH9SmfFmlu9Tg++p8UkrRAxiYnF6Yq9MYmOD69Z
        Ku/oQsrHfFFfFlAWSby6VYsK7iAFwfmoaQ==
X-Google-Smtp-Source: APXvYqzfkGcqfMd8XTjZe97piJaHJNPEY+P8GtTdNQVZskxOcMbovubaUqstbcEy/B42VIPukiFA5Di72qxClA==
X-Received: by 2002:ac8:3918:: with SMTP id s24mr73360491qtb.226.1560365848671;
 Wed, 12 Jun 2019 11:57:28 -0700 (PDT)
Date:   Wed, 12 Jun 2019 11:57:25 -0700
Message-Id: <20190612185725.176576-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH v2 net-next] tcp: add optional per socket transmit delay
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding delays to TCP flows is crucial for studying behavior
of TCP stacks, including congestion control modules.

Linux offers netem module, but it has unpractical constraints :
- Need root access to change qdisc
- Hard to setup on egress if combined with non trivial qdisc like FQ
- Single delay for all flows.

EDT (Earliest Departure Time) adoption in TCP stack allows us
to enable a per socket delay at a very small cost.

Networking tools can now establish thousands of flows, each of them
with a different delay, simulating real world conditions.

This requires FQ packet scheduler or a EDT-enabled NIC.

This patchs adds TCP_TX_DELAY socket option, to set a delay in
usec units.

  unsigned int tx_delay = 10000; /* 10 msec */

  setsockopt(fd, SOL_TCP, TCP_TX_DELAY, &tx_delay, sizeof(tx_delay));

Note that FQ packet scheduler limits might need some tweaking :

man tc-fq

PARAMETERS
   limit
       Hard  limit  on  the  real  queue  size. When this limit is
       reached, new packets are dropped. If the value is  lowered,
       packets  are  dropped so that the new limit is met. Default
       is 10000 packets.

   flow_limit
       Hard limit on the maximum  number  of  packets  queued  per
       flow.  Default value is 100.

Use of TCP_TX_DELAY option will increase number of skbs in FQ qdisc,
so packets would be dropped if any of the previous limit is hit.

Use of a jump label makes this support runtime-free, for hosts
never using the option.

Also note that TSQ (TCP Small Queues) limits are slightly changed
with this patch : we need to account that skbs artificially delayed
wont stop us providind more skbs to feed the pipe (netem uses
skb_orphan_partial() for this purpose, but FQ can not use this trick)

Because of that, using big delays might very well trigger
old bugs in TSO auto defer logic and/or sndbuf limited detection.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
v2: add the missing EXPORT_SYMBOL(tcp_tx_delay_enabled)

 include/linux/tcp.h      |  2 ++
 include/net/tcp.h        | 19 +++++++++++++++++++
 include/uapi/linux/tcp.h |  3 +++
 net/ipv4/tcp.c           | 24 ++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c      | 10 ++++++----
 net/ipv4/tcp_minisocks.c |  2 +-
 net/ipv4/tcp_output.c    | 23 ++++++++++++++++++++---
 net/ipv6/tcp_ipv6.c      |  1 +
 8 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 711361af9ce019f08c8b6accc33220b673b34d56..c23019a3b2647b1240e1f7b01b6d6c3bd4ade179 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -245,6 +245,7 @@ struct tcp_sock {
 		syn_smc:1;	/* SYN includes SMC */
 	u32	tlp_high_seq;	/* snd_nxt at the time of TLP retransmit. */
 
+	u32	tcp_tx_delay;	/* delay (in usec) added to TX packets */
 	u64	tcp_wstamp_ns;	/* departure time for next sent data packet */
 	u64	tcp_clock_cache; /* cache last tcp_clock_ns() (see tcp_mstamp_refresh()) */
 
@@ -436,6 +437,7 @@ struct tcp_timewait_sock {
 	u32			  tw_last_oow_ack_time;
 
 	int			  tw_ts_recent_stamp;
+	u32			  tw_tx_delay;
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key	  *tw_md5_key;
 #endif
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 204328b88412ca0da204372d6d304c1bac2b7cb5..49a178b8d5b2fafcbbeda53506ea38e3adb0f9dd 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2232,4 +2232,23 @@ void clean_acked_data_disable(struct inet_connection_sock *icsk);
 void clean_acked_data_flush(void);
 #endif
 
+DECLARE_STATIC_KEY_FALSE(tcp_tx_delay_enabled);
+static inline void tcp_add_tx_delay(struct sk_buff *skb,
+				    const struct tcp_sock *tp)
+{
+	if (static_branch_unlikely(&tcp_tx_delay_enabled))
+		skb->skb_mstamp_ns += (u64)tp->tcp_tx_delay * NSEC_PER_USEC;
+}
+
+static inline void tcp_set_tx_time(struct sk_buff *skb,
+				   const struct sock *sk)
+{
+	if (static_branch_unlikely(&tcp_tx_delay_enabled)) {
+		u32 delay = (sk->sk_state == TCP_TIME_WAIT) ?
+			tcp_twsk(sk)->tw_tx_delay : tcp_sk(sk)->tcp_tx_delay;
+
+		skb->skb_mstamp_ns = tcp_clock_ns() + (u64)delay * NSEC_PER_USEC;
+	}
+}
+
 #endif	/* _TCP_H */
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index b521464ea9627f922d2cc4b4ded68d1bc95d602e..b3564f85a762fa52b26dcb1c0380e2cee61c7685 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -127,6 +127,9 @@ enum {
 
 #define TCP_CM_INQ		TCP_INQ
 
+#define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
+
+
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
 #define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bd0856ac680ae5d13b85f8e252717151e05d0546..5542e3d778e6f5fb34e60402cd26e8992000f010 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2736,6 +2736,21 @@ static int tcp_repair_options_est(struct sock *sk,
 	return 0;
 }
 
+DEFINE_STATIC_KEY_FALSE(tcp_tx_delay_enabled);
+EXPORT_SYMBOL(tcp_tx_delay_enabled);
+
+static void tcp_enable_tx_delay(void)
+{
+	if (!static_branch_unlikely(&tcp_tx_delay_enabled)) {
+		static int __tcp_tx_delay_enabled = 0;
+
+		if (cmpxchg(&__tcp_tx_delay_enabled, 0, 1) == 0) {
+			static_branch_enable(&tcp_tx_delay_enabled);
+			pr_info("TCP_TX_DELAY enabled\n");
+		}
+	}
+}
+
 /*
  *	Socket option code for TCP.
  */
@@ -3087,6 +3102,11 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		else
 			tp->recvmsg_inq = val;
 		break;
+	case TCP_TX_DELAY:
+		if (val)
+			tcp_enable_tx_delay();
+		tp->tcp_tx_delay = val;
+		break;
 	default:
 		err = -ENOPROTOOPT;
 		break;
@@ -3546,6 +3566,10 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		val = tp->fastopen_no_cookie;
 		break;
 
+	case TCP_TX_DELAY:
+		val = tp->tcp_tx_delay;
+		break;
+
 	case TCP_TIMESTAMP:
 		val = tcp_time_stamp_raw() + tp->tsoffset;
 		break;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f059fbd81a84314ae6fef37f600b0cf28bd2ad30..1b7e9e1fbd3be3670a7fe9da4978f7a2e0959f58 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -767,9 +767,11 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	arg.uid = sock_net_uid(net, sk && sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
 	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
-	if (sk)
+	if (sk) {
 		ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_mark : sk->sk_mark;
+		tcp_set_tx_time(skb, sk);
+	}
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
 			      ip_hdr(skb)->saddr, ip_hdr(skb)->daddr,
@@ -859,9 +861,9 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
 	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
-	if (sk)
-		ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
-				   inet_twsk(sk)->tw_mark : sk->sk_mark;
+	ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
+			   inet_twsk(sk)->tw_mark : sk->sk_mark;
+	tcp_set_tx_time(skb, sk);
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
 			      ip_hdr(skb)->saddr, ip_hdr(skb)->daddr,
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 11011e8386dc97254a752514e4e6f77a068efaf4..8bcaf2586b6892b52fc3b25545017ec21afb0bde 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -274,7 +274,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 		tcptw->tw_ts_recent_stamp = tp->rx_opt.ts_recent_stamp;
 		tcptw->tw_ts_offset	= tp->tsoffset;
 		tcptw->tw_last_oow_ack_time = 0;
-
+		tcptw->tw_tx_delay	= tp->tcp_tx_delay;
 #if IS_ENABLED(CONFIG_IPV6)
 		if (tw->tw_family == PF_INET6) {
 			struct ipv6_pinfo *np = inet6_sk(sk);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f429e856e2631a9e6de1d2e060406742f97e538e..d954ff9069e8b99bfcf462e1e37e0690404720f8 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1153,6 +1153,8 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	memset(skb->cb, 0, max(sizeof(struct inet_skb_parm),
 			       sizeof(struct inet6_skb_parm)));
 
+	tcp_add_tx_delay(skb, tp);
+
 	err = icsk->icsk_af_ops->queue_xmit(sk, skb, &inet->cork.fl);
 
 	if (unlikely(err > 0)) {
@@ -2234,6 +2236,18 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 			      sock_net(sk)->ipv4.sysctl_tcp_limit_output_bytes);
 	limit <<= factor;
 
+	if (static_branch_unlikely(&tcp_tx_delay_enabled) &&
+	    tcp_sk(sk)->tcp_tx_delay) {
+		u64 extra_bytes = (u64)sk->sk_pacing_rate * tcp_sk(sk)->tcp_tx_delay;
+
+		/* TSQ is based on skb truesize sum (sk_wmem_alloc), so we
+		 * approximate our needs assuming an ~100% skb->truesize overhead.
+		 * USEC_PER_SEC is approximated by 2^20.
+		 * do_div(extra_bytes, USEC_PER_SEC/2) is replaced by a right shift.
+		 */
+		extra_bytes >>= (20 - 1);
+		limit += extra_bytes;
+	}
 	if (refcount_read(&sk->sk_wmem_alloc) > limit) {
 		/* Always send skb if rtx queue is empty.
 		 * No need to wait for TX completion to call us back,
@@ -3212,6 +3226,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	int tcp_header_size;
 	struct tcphdr *th;
 	int mss;
+	u64 now;
 
 	skb = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC);
 	if (unlikely(!skb)) {
@@ -3243,13 +3258,14 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	mss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
 
 	memset(&opts, 0, sizeof(opts));
+	now = tcp_clock_ns();
 #ifdef CONFIG_SYN_COOKIES
 	if (unlikely(req->cookie_ts))
 		skb->skb_mstamp_ns = cookie_init_timestamp(req);
 	else
 #endif
 	{
-		skb->skb_mstamp_ns = tcp_clock_ns();
+		skb->skb_mstamp_ns = now;
 		if (!tcp_rsk(req)->snt_synack) /* Timestamp first SYNACK */
 			tcp_rsk(req)->snt_synack = tcp_skb_timestamp_us(skb);
 	}
@@ -3292,8 +3308,9 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	rcu_read_unlock();
 #endif
 
-	/* Do not fool tcpdump (if any), clean our debris */
-	skb->tstamp = 0;
+	skb->skb_mstamp_ns = now;
+	tcp_add_tx_delay(skb, tp);
+
 	return skb;
 }
 EXPORT_SYMBOL(tcp_make_synack);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index ad7039137a20f9ad8581d9ca01347c67aa8a8433..5606b2131b653572f8ef6cdb6af5a118d5f4934d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -892,6 +892,7 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 		} else {
 			mark = sk->sk_mark;
 		}
+		tcp_set_tx_time(buff, sk);
 	}
 	fl6.flowi6_mark = IP6_REPLY_MARK(net, skb->mark) ?: mark;
 	fl6.fl6_dport = t1->dest;
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

