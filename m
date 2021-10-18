Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D27A4329EA
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 00:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhJRW5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 18:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:32846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231175AbhJRW5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 18:57:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0827161206;
        Mon, 18 Oct 2021 22:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634597704;
        bh=qn7K2k3tl3c2Bs0flv8jYv/3yAMgio17DfCK/q2giSc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lOpkQo7A9xHzVwScFG82QHcyHcc3Zm43CcOhTNN19K9DlivbOaGsz1O2NZt1ATvVF
         DqMgdZP3faVPoJSO2MNyXx+WyiUW29bCqdy+K1ZNwmNadjhGdOGV8RRLLa0syhi50Z
         WwMBDhGxCaW6nL970wpD3TUxROuGmj/7CVV9IsOcP6V4/bjrcGIDv3q20a4IKiJtUj
         CgNvmk2rd+df+7iSvNve7q8wEjzQ/H6Df3sDZ01uXi6FWPhdW+sWhXjNMAZNcIBdAh
         JduaHaj+JqIgyQ+e3ch/pztKZRTlsBY5Ei4p8rbKPOm9j97CjSbwB46fsRK7lXrwzJ
         hVjp/wsT468Xw==
Date:   Mon, 18 Oct 2021 15:55:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        linyunsheng@huawei.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Neil Horman <nhorman@redhat.com>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: Re: [PATCH net v2] napi: fix race inside napi_enable
Message-ID: <20211018155503.74aeaba9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YW3t8AGxW6p261hw@us.ibm.com>
References: <20210918085232.71436-1-xuanzhuo@linux.alibaba.com>
        <YW3t8AGxW6p261hw@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Oct 2021 14:58:08 -0700 Sukadev Bhattiprolu wrote:
> >                       CPU0       |                   CPU1       | napi.state
> > ===============================================================================
> > napi_disable()                   |                              | SCHED | NPSVC
> > napi_enable()                    |                              |
> > {                                |                              |
> >     smp_mb__before_atomic();     |                              |
> >     clear_bit(SCHED, &n->state); |                              | NPSVC
> >                                  | napi_schedule_prep()         | SCHED | NPSVC
> >                                  | napi_poll()                  |
> >                                  |   napi_complete_done()       |
> >                                  |   {                          |
> >                                  |      if (n->state & (NPSVC | | (1)
> >                                  |               _BUSY_POLL)))  |
> >                                  |           return false;      |
> >                                  |     ................         |
> >                                  |   }                          | SCHED | NPSVC
> >                                  |                              |
> >     clear_bit(NPSVC, &n->state); |                              | SCHED
> > }                                |                              |  
> 
> So its possible that after cpu0 cleared SCHED, cpu1 could have set it
> back and we are going to use cmpxchg() to detect and retry right? If so,

This is a state diagram before the change. There's no cmpxchg() here.
        
> > napi_schedule_prep()             |                              | SCHED | MISSED (2)
> > 
> > (1) Here return direct. Because of NAPI_STATE_NPSVC exists.
> > (2) NAPI_STATE_SCHED exists. So not add napi.poll_list to sd->poll_list
> > 
> > Since NAPI_STATE_SCHED already exists and napi is not in the
> > sd->poll_list queue, NAPI_STATE_SCHED cannot be cleared and will always
> > exist.
> > 
> > 1. This will cause this queue to no longer receive packets.
> > 2. If you encounter napi_disable under the protection of rtnl_lock, it
> >    will cause the entire rtnl_lock to be locked, affecting the overall
> >    system.
> > 
> > This patch uses cmpxchg to implement napi_enable(), which ensures that
> > there will be no race due to the separation of clear two bits.
> > 
> > Fixes: 2d8bff12699abc ("netpoll: Close race condition between poll_one_napi and napi_disable")
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > ---
> >  net/core/dev.c | 16 ++++++++++------
> >  1 file changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 74fd402d26dd..7ee9fecd3aff 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6923,12 +6923,16 @@ EXPORT_SYMBOL(napi_disable);
> >   */
> >  void napi_enable(struct napi_struct *n)
> >  {
> > -	BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
> > -	smp_mb__before_atomic();
> > -	clear_bit(NAPI_STATE_SCHED, &n->state);
> > -	clear_bit(NAPI_STATE_NPSVC, &n->state);
> > -	if (n->dev->threaded && n->thread)
> > -		set_bit(NAPI_STATE_THREADED, &n->state);
> > +	unsigned long val, new;
> > +
> > +	do {
> > +		val = READ_ONCE(n->state);
> > +		BUG_ON(!test_bit(NAPI_STATE_SCHED, &val));  
> 
> is this BUG_ON valid/needed? We could have lost the cmpxchg() and
> the other thread could have set NAPI_STATE_SCHED?

The BUG_ON() is here to make sure that when napi_enable() is called the
napi instance was dormant, i.e. disabled. We have "STATE_SCHED" bit set
on disabled NAPIs because that bit means ownership. Whoever disabled
the NAPI owns it.

That BUG_ON() could have been taken outside of the loop, there's no
point re-checking on every try. 

Are you seeing NAPI-related failures? We had at least 3 reports in the
last two weeks of strange failures which look like NAPI state getting
corrupted on net-next...
