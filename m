Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29EA2925E2
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 12:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgJSKdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 06:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgJSKdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 06:33:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9BFC0613CE;
        Mon, 19 Oct 2020 03:33:14 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603103593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aKA2eYNo0tRyWFjey5VCWB5m13CWJjS0iw4yD8SF5eA=;
        b=CcX6tzElPYUO1nkyuBaVspg5k5BMlZFQwZ5U6J62eNeDgRzE43paXiUfw6tMROG+fSrvf6
        igYtCsmr+HeLVWDguz3XoGUG7A5EBYAgEwvCGzn+JjhxQ2gQJO5RoF/8R0lO2KagpqSyLP
        8MbfMZ2EeQPNs4HU30xnP46OE/mnkj2lI+2Uw4bMFQB7nnySRG3p0fAnbNHS7WuM3zEgBt
        Z1FDIPlDpnUhRlC3Tr4aXoRWKNboLi5SyBUemkQOseNGrFJMPgBQP6bo141QoWrk1+ZAoj
        o5LiWhELHrjAPkYwcYWv7NYbCK2qyvVQxBggLVOE4d1ZBEC7p1NyWlaXci8pYw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603103593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aKA2eYNo0tRyWFjey5VCWB5m13CWJjS0iw4yD8SF5eA=;
        b=/GKktdwwjmHvEG5j+CWj85M5AdiombMk4VRDFF3rcm886EWbj5sYrcLuRner9OKKdfEiLc
        66LXrH04JdYYo3Ag==
To:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Remove __napi_schedule_irqoff?
In-Reply-To: <20201018101947.419802df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <01af7f4f-bd05-b93e-57ad-c2e9b8726e90@gmail.com> <20201017162949.0a6dd37a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CANn89i+q=q_LNDzE23y74Codh5EY0HHi_tROsEL2yJAdRjh-vQ@mail.gmail.com> <668a1291-e7f0-ef71-c921-e173d4767a14@gmail.com> <20201018101947.419802df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 19 Oct 2020 12:33:12 +0200
Message-ID: <87ft6aa4k7.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18 2020 at 10:19, Jakub Kicinski wrote:
> On Sun, 18 Oct 2020 10:20:41 +0200 Heiner Kallweit wrote:
>> >> Otherwise a non-solution could be to make IRQ_FORCED_THREADING
>> >> configurable.  
>> > 
>> > I have to say I do not understand why we want to defer to a thread the
>> > hard IRQ that we use in NAPI model.
>> >   
>> Seems like the current forced threading comes with the big hammer and
>> thread-ifies all hard irq's. To avoid this all NAPI network drivers
>> would have to request the interrupt with IRQF_NO_THREAD.

In a !RT kernel, forced threading (via commandline option) is mostly a
debug aid. It's pretty useful when something crashes in hard interrupt
context which usually takes the whole machine down. It's rather unlikely
to be used on production systems, and if so then the admin surely should
know what he's doing.

> Right, it'd work for some drivers. Other drivers try to take spin locks
> in their IRQ handlers.

I checked a few which do and some of these spinlocks just protect
register access and are not used for more complex serialization. So
these could be converted to raw spinlocks because their scope is short
and limited. But yes, you are right that this might be an issue in
general.

> What gave me a pause was that we have a busy loop in napi_schedule_prep:
>
> bool napi_schedule_prep(struct napi_struct *n)
> {
> 	unsigned long val, new;
>
> 	do {
> 		val = READ_ONCE(n->state);
> 		if (unlikely(val & NAPIF_STATE_DISABLE))
> 			return false;
> 		new = val | NAPIF_STATE_SCHED;
>
> 		/* Sets STATE_MISSED bit if STATE_SCHED was already set
> 		 * This was suggested by Alexander Duyck, as compiler
> 		 * emits better code than :
> 		 * if (val & NAPIF_STATE_SCHED)
> 		 *     new |= NAPIF_STATE_MISSED;
> 		 */
> 		new |= (val & NAPIF_STATE_SCHED) / NAPIF_STATE_SCHED *
> 						   NAPIF_STATE_MISSED;
> 	} while (cmpxchg(&n->state, val, new) != val);
>
> 	return !(val & NAPIF_STATE_SCHED);
> }
>
>
> Dunno how acceptable this is to run in an IRQ handler on RT..

In theory it's bad, but I don't think it's a big deal in reality.

Thanks,

        tglx
