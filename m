Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64083F61A7
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 17:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238338AbhHXPav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 11:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237890AbhHXPat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 11:30:49 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8AA461265;
        Tue, 24 Aug 2021 15:30:03 +0000 (UTC)
Date:   Tue, 24 Aug 2021 11:29:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zhongya Yan <yan2228598786@gmail.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com,
        mingo@redhat.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, hengqi.chen@gmail.com, yhs@fb.com
Subject: Re: [PATCH] net: tcp_drop adds `reason` parameter for tracing
Message-ID: <20210824112957.3a780186@oasis.local.home>
In-Reply-To: <20210824125140.190253-1-yan2228598786@gmail.com>
References: <20210824125140.190253-1-yan2228598786@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Aug 2021 05:51:40 -0700
Zhongya Yan <yan2228598786@gmail.com> wrote:

> When using `tcp_drop(struct sock *sk, struct sk_buff *skb)` we can
> not tell why we need to delete `skb`. To solve this problem I updated the
> method `tcp_drop(struct sock *sk, struct sk_buff *skb, enum tcp_drop_reason reason)`
> to include the source of the deletion when it is done, so you can
> get an idea of the reason for the deletion based on the source.
> 
> The current purpose is mainly derived from the suggestions
> of `Yonghong Song` and `brendangregg`:
> 
> https://github.com/iovisor/bcc/issues/3533.
> 
> "It is worthwhile to mention the context/why we want to this
> tracepoint with bcc issue https://github.com/iovisor/bcc/issues/3533.
> Mainly two reasons: (1). tcp_drop is a tiny function which
> may easily get inlined, a tracepoint is more stable, and (2).
> tcp_drop does not provide enough information on why it is dropped.
> " by Yonghong Song
> 
> Signed-off-by: Zhongya Yan <yan2228598786@gmail.com>
> ---
>  include/net/tcp.h          | 11 ++++++++
>  include/trace/events/tcp.h | 56 ++++++++++++++++++++++++++++++++++++++
>  net/ipv4/tcp_input.c       | 34 +++++++++++++++--------
>  3 files changed, 89 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 784d5c3ef1c5..dd8cd8d6f2f1 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -254,6 +254,17 @@ extern atomic_long_t tcp_memory_allocated;
>  extern struct percpu_counter tcp_sockets_allocated;
>  extern unsigned long tcp_memory_pressure;
>  
> +enum tcp_drop_reason {
> +	TCP_OFO_QUEUE = 1,
> +	TCP_DATA_QUEUE_OFO = 2,
> +	TCP_DATA_QUEUE = 3,
> +	TCP_PRUNE_OFO_QUEUE = 4,
> +	TCP_VALIDATE_INCOMING = 5,
> +	TCP_RCV_ESTABLISHED = 6,
> +	TCP_RCV_SYNSENT_STATE_PROCESS = 7,
> +	TCP_RCV_STATE_PROCESS = 8

As enums increase by one, you could save yourself the burden of
updating the numbers and just have:

enum tcp_drop_reason {
	TCP_OFO_QUEUE = 1,
	TCP_DATA_QUEUE_OFO,
	TCP_DATA_QUEUE,
	TCP_PRUNE_OFO_QUEUE,
	TCP_VALIDATE_INCOMING,
	TCP_RCV_ESTABLISHED,
	TCP_RCV_SYNSENT_STATE_PROCESS,
	TCP_RCV_STATE_PROCESS
};

Which would do the same.


> +};
> +
>  /* optimized version of sk_under_memory_pressure() for TCP sockets */
>  static inline bool tcp_under_memory_pressure(const struct sock *sk)
>  {
> diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
> index 521059d8dc0a..a0d3d31eb591 100644
> --- a/include/trace/events/tcp.h
> +++ b/include/trace/events/tcp.h
> @@ -371,6 +371,62 @@ DEFINE_EVENT(tcp_event_skb, tcp_bad_csum,
>  	TP_ARGS(skb)
>  );
>  

If you would like to see the english translation of what these
"reasons" are and not have to remember which number is which, you can
do the following:

#define TCP_DROP_REASON							\
	EM(TCP_OFO_QUEUE,		ofo_queue)			\
	EM(TCP_DATA_QUEUE_OFO,		data_queue_ofo)			\
	EM(TCP_DATA_QUEUE,		data_queue)			\
	EM(TCP_PRUNE_OFO_QUEUE,		prune_ofo_queue)		\
	EM(TCP_VALIDATE_INCOMING,	validate_incoming)		\
	EM(TCP_RCV_ESTABLISHED,		rcv_established)		\
	EM(TCP_RCV_SYNSENT_STATE_PROCESS, rcv_synsent_state_process)	\
	EMe(TCP_RCV_STATE_PROCESS,	rcv_state_proces)

#undef EM
#undef EMe

#define EM(a,b) { a, #b },
#define EMe(a, b) { a, #b }


> +TRACE_EVENT(tcp_drop,
> +		TP_PROTO(struct sock *sk, struct sk_buff *skb, enum tcp_drop_reason reason),
> +
> +		TP_ARGS(sk, skb, reason),
> +
> +		TP_STRUCT__entry(
> +			__array(__u8, saddr, sizeof(struct sockaddr_in6))
> +			__array(__u8, daddr, sizeof(struct sockaddr_in6))
> +			__field(__u16, sport)
> +			__field(__u16, dport)
> +			__field(__u32, mark)
> +			__field(__u16, data_len)
> +			__field(__u32, snd_nxt)
> +			__field(__u32, snd_una)
> +			__field(__u32, snd_cwnd)
> +			__field(__u32, ssthresh)
> +			__field(__u32, snd_wnd)
> +			__field(__u32, srtt)
> +			__field(__u32, rcv_wnd)
> +			__field(__u64, sock_cookie)
> +			__field(__u32, reason)
> +			),
> +
> +		TP_fast_assign(
> +				const struct tcphdr *th = (const struct tcphdr *)skb->data;
> +				const struct inet_sock *inet = inet_sk(sk);
> +				const struct tcp_sock *tp = tcp_sk(sk);
> +
> +				memset(__entry->saddr, 0, sizeof(struct sockaddr_in6));
> +				memset(__entry->daddr, 0, sizeof(struct sockaddr_in6));
> +
> +				TP_STORE_ADDR_PORTS(__entry, inet, sk);
> +
> +				__entry->sport = ntohs(inet->inet_sport);
> +				__entry->dport = ntohs(inet->inet_dport);
> +				__entry->mark = skb->mark;
> +
> +				__entry->data_len = skb->len - __tcp_hdrlen(th);
> +				__entry->snd_nxt = tp->snd_nxt;
> +				__entry->snd_una = tp->snd_una;
> +				__entry->snd_cwnd = tp->snd_cwnd;
> +				__entry->snd_wnd = tp->snd_wnd;
> +				__entry->rcv_wnd = tp->rcv_wnd;
> +				__entry->ssthresh = tcp_current_ssthresh(sk);
> +		__entry->srtt = tp->srtt_us >> 3;
> +		__entry->sock_cookie = sock_gen_cookie(sk);
> +		__entry->reason = reason;
> +		),
> +
> +		TP_printk("src=%pISpc dest=%pISpc mark=%#x data_len=%d snd_nxt=%#x snd_una=%#x snd_cwnd=%u ssthresh=%u snd_wnd=%u srtt=%u rcv_wnd=%u sock_cookie=%llx reason=%d",

Then above you can have: "reason=%s"

> +				__entry->saddr, __entry->daddr, __entry->mark,
> +				__entry->data_len, __entry->snd_nxt, __entry->snd_una,
> +				__entry->snd_cwnd, __entry->ssthresh, __entry->snd_wnd,
> +				__entry->srtt, __entry->rcv_wnd, __entry->sock_cookie, __entry->reason)

And here:

	__print_symbolic(__entry->reason, TCP_DROP_REASON)

-- Steve


> +);
> +
>  #endif /* _TRACE_TCP_H */
>  
>  /* This part must be outside protection */
>
