Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060D3DE6B0
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 10:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfJUIhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 04:37:34 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:52558 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfJUIhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 04:37:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id ADFFA204E0;
        Mon, 21 Oct 2019 10:37:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zNGTWRgXWIcU; Mon, 21 Oct 2019 10:37:32 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 44981200A0;
        Mon, 21 Oct 2019 10:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 21 Oct 2019
 10:37:28 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 43CC531800D5;
 Mon, 21 Oct 2019 10:37:31 +0200 (CEST)
Date:   Mon, 21 Oct 2019 10:37:31 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Tom Rix <trix@redhat.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfrm : lock input tasklet skb queue
Message-ID: <20191021083731.GK15862@gauss3.secunet.de>
References: <CACVy4SVuw0Qbjiv6PLRn1symoxGzyBMZx2F5O23+jGZG6WHuYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACVy4SVuw0Qbjiv6PLRn1symoxGzyBMZx2F5O23+jGZG6WHuYA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 08:46:10AM -0700, Tom Rix wrote:
> On PREEMPT_RT_FULL while running netperf, a corruption
> of the skb queue causes an oops.
> 
> This appears to be caused by a race condition here
>         __skb_queue_tail(&trans->queue, skb);
>         tasklet_schedule(&trans->tasklet);
> Where the queue is changed before the tasklet is locked by
> tasklet_schedule.
> 
> The fix is to use the skb queue lock.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  net/xfrm/xfrm_input.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> index 9b599ed66d97..226dead86828 100644
> --- a/net/xfrm/xfrm_input.c
> +++ b/net/xfrm/xfrm_input.c
> @@ -758,12 +758,16 @@ static void xfrm_trans_reinject(unsigned long data)
>      struct xfrm_trans_tasklet *trans = (void *)data;
>      struct sk_buff_head queue;
>      struct sk_buff *skb;
> +    unsigned long flags;
> 
>      __skb_queue_head_init(&queue);
> +    spin_lock_irqsave(&trans->queue.lock, flags);
>      skb_queue_splice_init(&trans->queue, &queue);
> 
>      while ((skb = __skb_dequeue(&queue)))
>          XFRM_TRANS_SKB_CB(skb)->finish(dev_net(skb->dev), NULL, skb);
> +
> +    spin_unlock_irqrestore(&trans->queue.lock, flags);
>  }
> 
>  int xfrm_trans_queue(struct sk_buff *skb,
> @@ -771,15 +775,20 @@ int xfrm_trans_queue(struct sk_buff *skb,
>                     struct sk_buff *))
>  {
>      struct xfrm_trans_tasklet *trans;
> +    unsigned long flags;
> 
>      trans = this_cpu_ptr(&xfrm_trans_tasklet);
> +    spin_lock_irqsave(&trans->queue.lock, flags);

As you can see above 'trans' is per cpu, so a spinlock
is not needed here. Also this does not run in hard
interrupt context, so irqsave is also not needed.
I don't see how this can fix anything.

Can you please explain that race a bit more detailed?

