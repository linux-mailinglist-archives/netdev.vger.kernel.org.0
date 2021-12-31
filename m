Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6840E482142
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 02:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240247AbhLaB0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 20:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237159AbhLaB0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 20:26:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E064BC061574;
        Thu, 30 Dec 2021 17:26:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61AB061750;
        Fri, 31 Dec 2021 01:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBD0C36AEA;
        Fri, 31 Dec 2021 01:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640913981;
        bh=qtB9ZhOMubllfEYxEIdvsOI05SobzEu1Rd8gZ87Bpf0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NLqpDu8YK0lc8g/gVJUHrBiQ+N/gTj8iJyHoUd6TMKJ0VUd2JlOsq4Ji/Ir11gQ8n
         6TscRRE2SsLROg46bycWTJXzJxScmzS4+GdVf1vnLtM6OivPdlbEUirh/qv61hAMCQ
         aH8nzXueHnpMBa8owq3a9LvS9ZLpkaRQnutDrOaSmnUwagvKe2MW2pR7D30wKEhHUN
         YDza44IILD0TDuM8DuPQHvcL/vPZRPlCdegBKXO3U9aJsvNydjuLsnyh2hv5kPAFSb
         +I665XjkC3jMu7yVEA9pOpypQCeQSWTnu1dJj4VCQU2uMVNXft1PWBhPpjEIsRVKaB
         IQlI5IwAzSSYw==
Date:   Thu, 30 Dec 2021 17:26:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     rostedt@goodmis.org, dsahern@kernel.org, mingo@redhat.com,
        davem@davemloft.net, nhorman@tuxdriver.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        keescook@chromium.org, pabeni@redhat.com, talalahmad@google.com,
        haokexin@gmail.com, imagedong@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, weiwan@google.com, arnd@arndb.de,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mengensun@tencent.com, mungerjiang@tencent.com
Subject: Re: [PATCH v2 net-next 1/3] net: skb: introduce
 kfree_skb_with_reason()
Message-ID: <20211230172619.40603ff3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211230093240.1125937-2-imagedong@tencent.com>
References: <20211230093240.1125937-1-imagedong@tencent.com>
        <20211230093240.1125937-2-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Dec 2021 17:32:38 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Introduce the interface kfree_skb_with_reason(), which is used to pass
> the reason why the skb is dropped to 'kfree_skb' tracepoint.
> 
> Add the 'reason' field to 'trace_kfree_skb', therefor user can get
> more detail information about abnormal skb with 'drop_monitor' or
> eBPF.

>  void skb_release_head_state(struct sk_buff *skb);
>  void kfree_skb(struct sk_buff *skb);

Should this be turned into a static inline calling
kfree_skb_with_reason() now? BTW you should drop the 
'_with'.

> +void kfree_skb_with_reason(struct sk_buff *skb,
> +			   enum skb_drop_reason reason);

continuation line is unaligned, please try checkpatch

>  void kfree_skb_list(struct sk_buff *segs);
>  void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
>  void skb_tx_error(struct sk_buff *skb);
> diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> index 9e92f22eb086..cab1c08a30cd 100644
> --- a/include/trace/events/skb.h
> +++ b/include/trace/events/skb.h
> @@ -9,29 +9,51 @@
>  #include <linux/netdevice.h>
>  #include <linux/tracepoint.h>
>  
> +#define TRACE_SKB_DROP_REASON					\
> +	EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)	\
> +	EMe(SKB_DROP_REASON_MAX, HAHA_MAX)

HAHA_MAX ?

> +
> +#undef EM
> +#undef EMe
> +
> +#define EM(a, b)	TRACE_DEFINE_ENUM(a);
> +#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
> +
> +TRACE_SKB_DROP_REASON
> +
> +#undef EM
> +#undef EMe
> +#define EM(a, b)	{ a, #b },
> +#define EMe(a, b)	{ a, #b }
> +
> +

double new line

>  /*
>   * Tracepoint for free an sk_buff:
>   */
>  TRACE_EVENT(kfree_skb,
>  
> -	TP_PROTO(struct sk_buff *skb, void *location),
> +	TP_PROTO(struct sk_buff *skb, void *location,
> +		 enum skb_drop_reason reason),
>  
> -	TP_ARGS(skb, location),
> +	TP_ARGS(skb, location, reason),
>  
>  	TP_STRUCT__entry(
> -		__field(	void *,		skbaddr		)
> -		__field(	void *,		location	)
> -		__field(	unsigned short,	protocol	)
> +		__field(void *,		skbaddr)
> +		__field(void *,		location)
> +		__field(unsigned short,	protocol)
> +		__field(enum skb_drop_reason,	reason)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->skbaddr = skb;
>  		__entry->location = location;
>  		__entry->protocol = ntohs(skb->protocol);
> +		__entry->reason = reason;
>  	),
>  
> -	TP_printk("skbaddr=%p protocol=%u location=%p",
> -		__entry->skbaddr, __entry->protocol, __entry->location)
> +	TP_printk("skbaddr=%p protocol=%u location=%p reason: %s",
> +		__entry->skbaddr, __entry->protocol, __entry->location,
> +		__print_symbolic(__entry->reason, TRACE_SKB_DROP_REASON))
>  );
>  
>  TRACE_EVENT(consume_skb,
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 644b9c8be3a8..9464dbf9e3d6 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4899,7 +4899,8 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
>  			if (likely(get_kfree_skb_cb(skb)->reason == SKB_REASON_CONSUMED))
>  				trace_consume_skb(skb);
>  			else
> -				trace_kfree_skb(skb, net_tx_action);
> +				trace_kfree_skb(skb, net_tx_action,
> +						SKB_DROP_REASON_NOT_SPECIFIED);
>  
>  			if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
>  				__kfree_skb(skb);
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index 3d0ab2eec916..7b288a121a41 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -110,7 +110,8 @@ static u32 net_dm_queue_len = 1000;
>  
>  struct net_dm_alert_ops {
>  	void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
> -				void *location);
> +				void *location,
> +				enum skb_drop_reason reason);
>  	void (*napi_poll_probe)(void *ignore, struct napi_struct *napi,
>  				int work, int budget);
>  	void (*work_item_func)(struct work_struct *work);
> @@ -262,7 +263,9 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>  	spin_unlock_irqrestore(&data->lock, flags);
>  }
>  
> -static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
> +static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb,
> +				void *location,
> +				enum skb_drop_reason reason)
>  {
>  	trace_drop_common(skb, location);
>  }
> @@ -490,7 +493,8 @@ static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
>  
>  static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
>  					      struct sk_buff *skb,
> -					      void *location)
> +					      void *location,
> +					      enum skb_drop_reason reason)
>  {
>  	ktime_t tstamp = ktime_get_real();
>  	struct per_cpu_dm_data *data;
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 275f7b8416fe..570dc022a8a1 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -770,11 +770,31 @@ void kfree_skb(struct sk_buff *skb)
>  	if (!skb_unref(skb))
>  		return;
>  
> -	trace_kfree_skb(skb, __builtin_return_address(0));
> +	trace_kfree_skb(skb, __builtin_return_address(0),
> +			SKB_DROP_REASON_NOT_SPECIFIED);
>  	__kfree_skb(skb);
>  }
>  EXPORT_SYMBOL(kfree_skb);
>  
> +/**
> + *	kfree_skb_with_reason - free an sk_buff with reason
> + *	@skb: buffer to free
> + *	@reason: reason why this skb is dropped
> + *
> + *	The same as kfree_skb() except that this function will pass
> + *	the drop reason to 'kfree_skb' tracepoint.
> + */
> +void kfree_skb_with_reason(struct sk_buff *skb,
> +			   enum skb_drop_reason reason)
> +{
> +	if (!skb_unref(skb))
> +		return;
> +
> +	trace_kfree_skb(skb, __builtin_return_address(0), reason);
> +	__kfree_skb(skb);
> +}
> +EXPORT_SYMBOL(kfree_skb_with_reason);
> +
>  void kfree_skb_list(struct sk_buff *segs)
>  {
>  	while (segs) {

