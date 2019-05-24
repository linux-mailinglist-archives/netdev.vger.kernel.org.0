Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0FC729E0A
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 20:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbfEXSdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 14:33:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:51768 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfEXSdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 14:33:00 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hUEzs-0003YZ-CL; Fri, 24 May 2019 20:32:52 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hUEzs-0001eF-5K; Fri, 24 May 2019 20:32:52 +0200
Subject: Re: [RFC net-next 1/1] net: sched: protect against loops in TC filter
 hooks
To:     John Hurley <john.hurley@netronome.com>, netdev@vger.kernel.org,
        jiri@mellanox.com, davem@davemloft.net, xiyou.wangcong@gmail.com
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, alexei.starovoitov@gmail.com
References: <1558713946-25314-1-git-send-email-john.hurley@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <531c9565-5e42-3c87-891e-1cae13ae89bf@iogearbox.net>
Date:   Fri, 24 May 2019 20:32:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <1558713946-25314-1-git-send-email-john.hurley@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25459/Fri May 24 09:59:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/24/2019 06:05 PM, John Hurley wrote:
> TC hooks allow the application of filters and actions to packets at both
> ingress and egress of the network stack. It is possible, with poor
> configuration, that this can produce loops whereby an ingress hook calls
> a mirred egress action that has an egress hook that redirects back to
> the first ingress etc. The TC core classifier protects against loops when
> doing reclassifies but, as yet, there is no protection against a packet
> looping between multiple hooks. This can lead to stack overflow panics.
> 
> Add a per cpu counter that tracks recursion of packets through TC hooks.
> The packet will be dropped if a recursive limit is passed and the counter
> reset for the next packet.

NAK. This is quite a hack in the middle of the fast path. Such redirection
usually has a rescheduling point, like in cls_bpf case. If this is not the
case for mirred action as I read your commit message above, then fix mirred
instead if it's such broken.

Thanks,
Daniel

> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> ---
>  net/core/dev.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 55 insertions(+), 7 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b6b8505..a6d9ed7 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -154,6 +154,9 @@
>  /* This should be increased if a protocol with a bigger head is added. */
>  #define GRO_MAX_HEAD (MAX_HEADER + 128)
>  
> +#define SCH_RECURSION_LIMIT	4
> +static DEFINE_PER_CPU(int, sch_recursion_level);
> +
>  static DEFINE_SPINLOCK(ptype_lock);
>  static DEFINE_SPINLOCK(offload_lock);
>  struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
> @@ -3598,16 +3601,42 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL(dev_loopback_xmit);
>  
> +static inline int sch_check_inc_recur_level(void)
> +{
> +	int rec_level = __this_cpu_inc_return(sch_recursion_level);
> +
> +	if (rec_level >= SCH_RECURSION_LIMIT) {
> +		net_warn_ratelimited("Recursion limit reached on TC datapath, probable configuration error\n");
> +		return -ELOOP;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void sch_dec_recur_level(void)
> +{
> +	__this_cpu_dec(sch_recursion_level);
> +}
> +
>  #ifdef CONFIG_NET_EGRESS
>  static struct sk_buff *
>  sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
>  {
>  	struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
>  	struct tcf_result cl_res;
> +	int err;
>  
>  	if (!miniq)
>  		return skb;
>  
> +	err = sch_check_inc_recur_level();
> +	if (err) {
> +		sch_dec_recur_level();
> +		*ret = NET_XMIT_DROP;
> +		consume_skb(skb);
> +		return NULL;
> +	}
> +
>  	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
>  	mini_qdisc_bstats_cpu_update(miniq, skb);
>  
> @@ -3620,22 +3649,26 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
>  		mini_qdisc_qstats_cpu_drop(miniq);
>  		*ret = NET_XMIT_DROP;
>  		kfree_skb(skb);
> -		return NULL;
> +		skb = NULL;
> +		break;
>  	case TC_ACT_STOLEN:
>  	case TC_ACT_QUEUED:
>  	case TC_ACT_TRAP:
>  		*ret = NET_XMIT_SUCCESS;
>  		consume_skb(skb);
> -		return NULL;
> +		skb = NULL;
> +		break;
>  	case TC_ACT_REDIRECT:
>  		/* No need to push/pop skb's mac_header here on egress! */
>  		skb_do_redirect(skb);
>  		*ret = NET_XMIT_SUCCESS;
> -		return NULL;
> +		skb = NULL;
> +		break;
>  	default:
>  		break;
>  	}
>  
> +	sch_dec_recur_level();
>  	return skb;
>  }
>  #endif /* CONFIG_NET_EGRESS */
> @@ -4670,6 +4703,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
>  #ifdef CONFIG_NET_CLS_ACT
>  	struct mini_Qdisc *miniq = rcu_dereference_bh(skb->dev->miniq_ingress);
>  	struct tcf_result cl_res;
> +	int err;
>  
>  	/* If there's at least one ingress present somewhere (so
>  	 * we get here via enabled static key), remaining devices
> @@ -4679,6 +4713,14 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
>  	if (!miniq)
>  		return skb;
>  
> +	err = sch_check_inc_recur_level();
> +	if (err) {
> +		sch_dec_recur_level();
> +		*ret = NET_XMIT_DROP;
> +		consume_skb(skb);
> +		return NULL;
> +	}
> +
>  	if (*pt_prev) {
>  		*ret = deliver_skb(skb, *pt_prev, orig_dev);
>  		*pt_prev = NULL;
> @@ -4696,12 +4738,14 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
>  	case TC_ACT_SHOT:
>  		mini_qdisc_qstats_cpu_drop(miniq);
>  		kfree_skb(skb);
> -		return NULL;
> +		skb = NULL;
> +		break;
>  	case TC_ACT_STOLEN:
>  	case TC_ACT_QUEUED:
>  	case TC_ACT_TRAP:
>  		consume_skb(skb);
> -		return NULL;
> +		skb = NULL;
> +		break;
>  	case TC_ACT_REDIRECT:
>  		/* skb_mac_header check was done by cls/act_bpf, so
>  		 * we can safely push the L2 header back before
> @@ -4709,14 +4753,18 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
>  		 */
>  		__skb_push(skb, skb->mac_len);
>  		skb_do_redirect(skb);
> -		return NULL;
> +		skb = NULL;
> +		break;
>  	case TC_ACT_REINSERT:
>  		/* this does not scrub the packet, and updates stats on error */
>  		skb_tc_reinsert(skb, &cl_res);
> -		return NULL;
> +		skb = NULL;
> +		break;
>  	default:
>  		break;
>  	}
> +
> +	sch_dec_recur_level();
>  #endif /* CONFIG_NET_CLS_ACT */
>  	return skb;
>  }
> 

