Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B268AE0042
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388211AbfJVJFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:05:06 -0400
Received: from mail.jv-coder.de ([5.9.79.73]:52470 "EHLO mail.jv-coder.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726978AbfJVJFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:05:05 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Oct 2019 05:05:04 EDT
Received: from [10.61.40.7] (unknown [37.156.92.209])
        by mail.jv-coder.de (Postfix) with ESMTPSA id 0B15E9FA2B;
        Tue, 22 Oct 2019 08:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jv-coder.de; s=dkim;
        t=1571734725; bh=vmxqbKFdbAsB2xDI6xrGHn1DS1Pl2hjh1JTq6d0++zQ=;
        h=Subject:To:From:Message-ID:Date:MIME-Version;
        b=WaY/fLxdqDRfcENriUsOVoPh73icYTpF1VgO6o5bxJNM01aauwiOzp9lCRKS9B3vK
         5KoM41PObQR9ArA1fz1xpvcODULVcq0k2kO+dCgfhyg/tn/I6z8j42wYJXewMet+GD
         O7u97x0Mvf0rZp/wHmFI3R5isw3GgWdM860/tAx8=
Subject: Re: [PATCH] xfrm : lock input tasklet skb queue
To:     Tom Rix <trix@redhat.com>, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CACVy4SVuw0Qbjiv6PLRn1symoxGzyBMZx2F5O23+jGZG6WHuYA@mail.gmail.com>
From:   Joerg Vehlow <lkml@jv-coder.de>
Message-ID: <ac5f327b-d693-31cb-089f-b0880a4e298b@jv-coder.de>
Date:   Tue, 22 Oct 2019 10:58:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CACVy4SVuw0Qbjiv6PLRn1symoxGzyBMZx2F5O23+jGZG6WHuYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,HELO_MISC_IP,RDNS_NONE autolearn=no
        autolearn_force=no version=3.4.2
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.jv-coder.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I already send a patch on 2019-09-09 to this mailing list with a similar 
issue[1].
Sadly no replies, although this is a huge bug in the rt kernel.
I fixed it a bit differently, using smaller locked regions.
You have also propably a bug in your patch, because trans->queue.lock is
no initialized by __skb_queue_head_init (in xfrm_input_init)

Jörg

[1] https://lkml.org/lkml/2019/9/9/111

Am 20.10.2019 um 17:46 schrieb Tom Rix:
> On PREEMPT_RT_FULL while running netperf, a corruption
> of the skb queue causes an oops.
>
> This appears to be caused by a race condition here
>          __skb_queue_tail(&trans->queue, skb);
>          tasklet_schedule(&trans->tasklet);
> Where the queue is changed before the tasklet is locked by
> tasklet_schedule.
>
> The fix is to use the skb queue lock.
>
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>   net/xfrm/xfrm_input.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> index 9b599ed66d97..226dead86828 100644
> --- a/net/xfrm/xfrm_input.c
> +++ b/net/xfrm/xfrm_input.c
> @@ -758,12 +758,16 @@ static void xfrm_trans_reinject(unsigned long data)
>       struct xfrm_trans_tasklet *trans = (void *)data;
>       struct sk_buff_head queue;
>       struct sk_buff *skb;
> +    unsigned long flags;
>
>       __skb_queue_head_init(&queue);
> +    spin_lock_irqsave(&trans->queue.lock, flags);
>       skb_queue_splice_init(&trans->queue, &queue);
>
>       while ((skb = __skb_dequeue(&queue)))
>           XFRM_TRANS_SKB_CB(skb)->finish(dev_net(skb->dev), NULL, skb);
> +
> +    spin_unlock_irqrestore(&trans->queue.lock, flags);
>   }
>
>   int xfrm_trans_queue(struct sk_buff *skb,
> @@ -771,15 +775,20 @@ int xfrm_trans_queue(struct sk_buff *skb,
>                      struct sk_buff *))
>   {
>       struct xfrm_trans_tasklet *trans;
> +    unsigned long flags;
>
>       trans = this_cpu_ptr(&xfrm_trans_tasklet);
> +    spin_lock_irqsave(&trans->queue.lock, flags);
>
> -    if (skb_queue_len(&trans->queue) >= netdev_max_backlog)
> +    if (skb_queue_len(&trans->queue) >= netdev_max_backlog) {
> +        spin_unlock_irqrestore(&trans->queue.lock, flags);
>           return -ENOBUFS;
> +    }
>
>       XFRM_TRANS_SKB_CB(skb)->finish = finish;
>       __skb_queue_tail(&trans->queue, skb);
>       tasklet_schedule(&trans->tasklet);
> +    spin_unlock_irqrestore(&trans->queue.lock, flags);
>       return 0;
>   }
>   EXPORT_SYMBOL(xfrm_trans_queue);

