Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D022A68F1
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbgKDQCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:02:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgKDQCj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 11:02:39 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00D3220782;
        Wed,  4 Nov 2020 16:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604505758;
        bh=F8joUcU8b5cCCKZVdifOGtzr1xT7T9RC/8b1vk/OZ68=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g1NtW5Gx2gCGCxb0qFiUG2HuZxpgWxLl7Kz4CS06eQXFVORtBzy5QjKJKcGcHC2uG
         2HUNuJb67e1fRYaeNFankEORQJ6aAsTHpUlebfkQucxK5G8XXMekORMXVyJkR1VJ95
         KsHPI9B6gQ51QyZFZV8a4kewCKKlkGRLA5O91HuY=
Date:   Wed, 4 Nov 2020 08:02:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Eric Dumazet <edumazet@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [net 05/27] can: dev: can_get_echo_skb(): prevent call to
 kfree_skb() in hard IRQ context
Message-ID: <20201104080237.4d6605ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <988aea6a-c6b6-5d58-3a8e-604a52df0320@hartkopp.net>
References: <20201103220636.972106-1-mkl@pengutronix.de>
        <20201103220636.972106-6-mkl@pengutronix.de>
        <20201103172102.3d75cb96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iK5xqYmLT=DZk0S15pRObSJbo2-zrO7_A0Q46Ujg1RxYg@mail.gmail.com>
        <988aea6a-c6b6-5d58-3a8e-604a52df0320@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 15:59:25 +0100 Oliver Hartkopp wrote:
> Hello Eric,
> 
> On 04.11.20 09:16, Eric Dumazet wrote:
> > On Wed, Nov 4, 2020 at 2:21 AM Jakub Kicinski <kuba@kernel.org> wrote:  
> >>
> >> On Tue,  3 Nov 2020 23:06:14 +0100 Marc Kleine-Budde wrote:  
> >>> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> >>>
> >>> If a driver calls can_get_echo_skb() during a hardware IRQ (which is often, but
> >>> not always, the case), the 'WARN_ON(in_irq)' in
> >>> net/core/skbuff.c#skb_release_head_state() might be triggered, under network
> >>> congestion circumstances, together with the potential risk of a NULL pointer
> >>> dereference.
> >>>
> >>> The root cause of this issue is the call to kfree_skb() instead of
> >>> dev_kfree_skb_irq() in net/core/dev.c#enqueue_to_backlog().
> >>>
> >>> This patch prevents the skb to be freed within the call to netif_rx() by
> >>> incrementing its reference count with skb_get(). The skb is finally freed by
> >>> one of the in-irq-context safe functions: dev_consume_skb_any() or
> >>> dev_kfree_skb_any(). The "any" version is used because some drivers might call
> >>> can_get_echo_skb() in a normal context.
> >>>
> >>> The reason for this issue to occur is that initially, in the core network
> >>> stack, loopback skb were not supposed to be received in hardware IRQ context.
> >>> The CAN stack is an exeption.
> >>>
> >>> This bug was previously reported back in 2017 in [1] but the proposed patch
> >>> never got accepted.
> >>>
> >>> While [1] directly modifies net/core/dev.c, we try to propose here a
> >>> smoother modification local to CAN network stack (the assumption
> >>> behind is that only CAN devices are affected by this issue).
> >>>
> >>> [1] http://lore.kernel.org/r/57a3ffb6-3309-3ad5-5a34-e93c3fe3614d@cetitec.com
> >>>
> >>> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> >>> Link: https://lore.kernel.org/r/20201002154219.4887-2-mailhol.vincent@wanadoo.fr
> >>> Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
> >>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>  
> >>
> >> Hm... Why do we receive a skb with a socket attached?
> >>
> >> At a quick glance this is some loopback, so shouldn't we skb_orphan()
> >> in the xmit function instead?  
> > 
> > Yes this would work, this seems the safest way, loopback_xmit() is a
> > good template for this.
> >   
> >>
> >> Otherwise we should probably fix this in enqueue_to_backlog().  
> > 
> > This is dangerous.
> > 
> > If we drop packets under flood because the per-cpu backlog is full,
> > we might also be in _big_ trouble if the per-cpu
> > softnet_data.completion_queue is filling,
> > since we do not have a limit on this list.
> > 
> > What could happen is that when the memory is finally exhausted and no
> > more skb can be fed
> > to netif_rx(), a big latency spike would happen when
> > softnet_data.completion_queue
> > can finally be purged in one shot.

Thanks, that makes sense. So no to the enqueue_to_backlog() idea.

> > So skb_orphan(skb) in CAN before calling netif_rx() is better IMO.
> >   
> 
> Unfortunately you missed the answer from Vincent, why skb_orphan() does 
> not work here:
> 
> https://lore.kernel.org/linux-can/CAMZ6RqJyZTcqZcq6jEzm5LLM_MMe=dYDbwvv=Y+dBR0drWuFmw@mail.gmail.com/

Okay, we can take this as a quick fix but to me it seems a little
strange to be dropping what is effectively locally generated frames.

Can we use a NAPI poll model here and back pressure TX if the echo
is not keeping up?
