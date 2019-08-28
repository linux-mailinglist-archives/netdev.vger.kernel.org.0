Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2E29FA8C
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfH1Gby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:31:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38179 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbfH1Gby (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 02:31:54 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4272B10F23E8;
        Wed, 28 Aug 2019 06:31:53 +0000 (UTC)
Received: from ovpn-116-130.ams2.redhat.com (ovpn-116-130.ams2.redhat.com [10.36.116.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 498D010016EB;
        Wed, 28 Aug 2019 06:31:49 +0000 (UTC)
Message-ID: <6c550fb7e1e01683357cc7382bad301923a2e18c.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: pfifo_fast: fix wrong dereference in
 pfifo_fast_enqueue
From:   Paolo Abeni <pabeni@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, Li Shuang <shuali@redhat.com>
Date:   Wed, 28 Aug 2019 08:31:48 +0200
In-Reply-To: <d5a7a167ab57e035685445ee641840a0c5fd39ae.1566940693.git.dcaratti@redhat.com>
References: <d5a7a167ab57e035685445ee641840a0c5fd39ae.1566940693.git.dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Wed, 28 Aug 2019 06:31:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-08-27 at 23:18 +0200, Davide Caratti wrote:
> Now that 'TCQ_F_CPUSTATS' bit can be cleared, depending on the value of
> 'TCQ_F_NOLOCK' bit in the parent qdisc, we can't assume anymore that
> per-cpu counters are there in the error path of skb_array_produce().
> Otherwise, the following splat can be seen:
> 
>  Unable to handle kernel paging request at virtual address 0000600dea430008
>  Mem abort info:
>    ESR = 0x96000005
>    Exception class = DABT (current EL), IL = 32 bits
>    SET = 0, FnV = 0
>    EA = 0, S1PTW = 0
>  Data abort info:
>    ISV = 0, ISS = 0x00000005
>    CM = 0, WnR = 0
>  user pgtable: 64k pages, 48-bit VAs, pgdp = 000000007b97530e
>  [0000600dea430008] pgd=0000000000000000, pud=0000000000000000
>  Internal error: Oops: 96000005 [#1] SMP
> [...]
>  pstate: 10000005 (nzcV daif -PAN -UAO)
>  pc : pfifo_fast_enqueue+0x524/0x6e8
>  lr : pfifo_fast_enqueue+0x46c/0x6e8
>  sp : ffff800d39376fe0
>  x29: ffff800d39376fe0 x28: 1ffff001a07d1e40
>  x27: ffff800d03e8f188 x26: ffff800d03e8f200
>  x25: 0000000000000062 x24: ffff800d393772f0
>  x23: 0000000000000000 x22: 0000000000000403
>  x21: ffff800cca569a00 x20: ffff800d03e8ee00
>  x19: ffff800cca569a10 x18: 00000000000000bf
>  x17: 0000000000000000 x16: 0000000000000000
>  x15: 0000000000000000 x14: ffff1001a726edd0
>  x13: 1fffe4000276a9a4 x12: 0000000000000000
>  x11: dfff200000000000 x10: ffff800d03e8f1a0
>  x9 : 0000000000000003 x8 : 0000000000000000
>  x7 : 00000000f1f1f1f1 x6 : ffff1001a726edea
>  x5 : ffff800cca56a53c x4 : 1ffff001bf9a8003
>  x3 : 1ffff001bf9a8003 x2 : 1ffff001a07d1dcb
>  x1 : 0000600dea430000 x0 : 0000600dea430008
>  Process ping (pid: 6067, stack limit = 0x00000000dc0aa557)
>  Call trace:
>   pfifo_fast_enqueue+0x524/0x6e8
>   htb_enqueue+0x660/0x10e0 [sch_htb]
>   __dev_queue_xmit+0x123c/0x2de0
>   dev_queue_xmit+0x24/0x30
>   ip_finish_output2+0xc48/0x1720
>   ip_finish_output+0x548/0x9d8
>   ip_output+0x334/0x788
>   ip_local_out+0x90/0x138
>   ip_send_skb+0x44/0x1d0
>   ip_push_pending_frames+0x5c/0x78
>   raw_sendmsg+0xed8/0x28d0
>   inet_sendmsg+0xc4/0x5c0
>   sock_sendmsg+0xac/0x108
>   __sys_sendto+0x1ac/0x2a0
>   __arm64_sys_sendto+0xc4/0x138
>   el0_svc_handler+0x13c/0x298
>   el0_svc+0x8/0xc
>  Code: f9402e80 d538d081 91002000 8b010000 (885f7c03)
> 
> Fix this by testing the value of 'TCQ_F_CPUSTATS' bit in 'qdisc->flags',
> before dereferencing 'qdisc->cpu_qstats'.
> 
> Fixes: 8a53e616de29 ("net: sched: when clearing NOLOCK, clear TCQ_F_CPUSTATS, too")
> CC: Paolo Abeni <pabeni@redhat.com>
> CC: Stefano Brivio <sbrivio@redhat.com>
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  net/sched/sch_generic.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 099797e5409d..137db1cbde85 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -624,8 +624,12 @@ static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc *qdisc,
>  
>  	err = skb_array_produce(q, skb);
>  
> -	if (unlikely(err))
> -		return qdisc_drop_cpu(skb, qdisc, to_free);
> +	if (unlikely(err)) {
> +		if (qdisc_is_percpu_stats(qdisc))
> +			return qdisc_drop_cpu(skb, qdisc, to_free);
> +		else
> +			return qdisc_drop(skb, qdisc, to_free);
> +	}
>  
>  	qdisc_update_stats_at_enqueue(qdisc, pkt_len);
>  	return NET_XMIT_SUCCESS;

LGTM, thanks Davide!

I just did a code audit of the others pfifo_fast callbacks, I think
this is the last spot in need of such fix.

Acked-by: Paolo Abeni <pabeni@redhat.com>

