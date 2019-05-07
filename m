Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C27715E77
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 09:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfEGHqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 03:46:18 -0400
Received: from ja.ssi.bg ([178.16.129.10]:57926 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726249AbfEGHqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 03:46:17 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x477jXQC005216;
        Tue, 7 May 2019 10:45:34 +0300
Date:   Tue, 7 May 2019 10:45:33 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     hujunwei <hujunwei4@huawei.com>
cc:     wensong@linux-vs.org, horms@verge.net.au, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mingfangsen@huawei.com, wangxiaogang3@huawei.com,
        zhangwenhao8@huawei.com
Subject: Re: Subject: [PATCH netfilter] ipvs: Fix crash when ipv6 route
 unreach
In-Reply-To: <f40bae44-a4b1-868c-3572-3e89c4cadb6a@huawei.com>
Message-ID: <alpine.LFD.2.21.1905071009060.3512@ja.home.ssi.bg>
References: <f40bae44-a4b1-868c-3572-3e89c4cadb6a@huawei.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Tue, 7 May 2019, hujunwei wrote:

> From: Junwei Hu <hujunwei4@huawei.com>
> 
> When Tcp send RST packet in ipvs, crash occurs with the following
> stack trace:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> PID: 0 COMMAND: "swapper/2"
> TASK: ffff9ec83889bf40  (1 of 4)  [THREAD_INFO: ffff9ec8388b0000]
> CPU: 2  STATE: TASK_RUNNING (PANIC)
>  [exception RIP: __ip_vs_get_out_rt_v6+1250]
> RIP: ffffffffc0d566f2  RSP: ffff9ec83ed03c68  RFLAGS: 00010246
> RAX: 0000000000000000  RBX: ffff9ec835e85000  RCX: 000000000005e1f9
> RDX: 000000000005e1f8  RSI: 0000000000000200  RDI: ffff9ec83e801b00
> RBP: ffff9ec83ed03cd8   R8: 000000000001bb40   R9: ffffffffc0d5673f
> R10: ffff9ec83ed1bb40  R11: ffffe2d384d4fdc0  R12: ffff9ec7b7ad5900
> R13: 0000000000000000  R14: 0000000000000007  R15: ffff9ec8353f7580
> ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  [ffff9ec83ed03ce0] ip_vs_fnat_xmit_v6 at ffffffffc0d5b42c [ip_vs]
>  [ffff9ec83ed03d70] tcp_send_rst_ipv6 at ffffffffc0d6542a [ip_vs]
>  [ffff9ec83ed03df8] tcp_conn_expire_handler at ffffffffc0d65823 [ip_vs]
>  [ffff9ec83ed03e20] ip_vs_conn_expire at ffffffffc0d42373 [ip_vs]
>  [ffff9ec83ed03e70] call_timer_fn at ffffffffae0a6b58
>  [ffff9ec83ed03ea8] run_timer_softirq at ffffffffae0a904d
>  [ffff9ec83ed03f20] __do_softirq at ffffffffae09fa85
>  [ffff9ec83ed03f90] call_softirq at ffffffffae739dac
>  [ffff9ec83ed03fa8] do_softirq at ffffffffae02e62b
>  [ffff9ec83ed03fc0] irq_exit at ffffffffae09fe25
>  [ffff9ec83ed03fd8] smp_apic_timer_interrupt at ffffffffae73b158
>  [ffff9ec83ed03ff0] apic_timer_interrupt at ffffffffae737872
> 
> TCP connection timeout and send a RST packet, the skb is alloc
> by alloc_skb, the pointer skb->dev and skb_dst(skb) is NULL,
> however, ipv6 route unreach at that time, so go into err_unreach.
> In err_unreach, crash occurs when skb->dev and skb_dst(skb) is NULL.

	I guess, this is a modified IPVS module and the problem
can not occur in mainline kernel. ip_vs_in() and ip_vs_out() already 
have check for skb_dst(). May be you generate skb without attached
route, so skb_dst is NULL. Also, note that decrement_ttl() has similar
code.

> The code is added by the following patch:
> commit 326bf17ea5d4 ("ipvs: fix ipv6 route unreach panic")
> because the ip6_link_failure function requires the skb->dev
> in icmp6_send with that version.
> 
> This patch only fix the problem in specific scene, and icmp6_send in
> current version is robust against null skb->dev by adding the
> following patch.
> commit 8d9336704521
> ("ipv6: make icmp6_send() robust against null skb->dev")
> 
> So I delete the code, make __ip_vs_get_out_rt_v6() robust, when
> skb->dev and skb_dst(skb) is NULL.
> 
> Fixes: 326bf17ea5d4 ("ipvs: fix ipv6 route unreach panic")
> Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
> Reported-by: Wenhao Zhang <zhangwenhao8@huawei.com>
> ---
>  net/netfilter/ipvs/ip_vs_xmit.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index 175349fcf91f..e2bb6c223396 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -561,13 +561,6 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
>  	return -1;
> 
>  err_unreach:
> -	/* The ip6_link_failure function requires the dev field to be set
> -	 * in order to get the net (further for the sake of fwmark
> -	 * reflection).
> -	 */
> -	if (!skb->dev)
> -		skb->dev = skb_dst(skb)->dev;
> -
>  	dst_link_failure(skb);
>  	return -1;
>  }
> -- 
> 2.21.GIT

Regards

--
Julian Anastasov <ja@ssi.bg>
