Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E492DB8E6
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 03:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgLPCZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 21:25:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgLPCZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 21:25:18 -0500
Date:   Tue, 15 Dec 2020 18:24:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608085478;
        bh=MUGVE+OU898rjUjPHVWMQo5BIl4FDRgky31FhDAgFQw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=lDBvMWMR/dDCBOiBW8VkCQ+e+ZA3j0AO9QZ1hnNgCQ7mXI+lPQVvnrq3UNMQvfXOU
         Z57S+/Ln5B+hJYf9H2pfhU300BxcmAcfQVs+eKrscDo2azFvxp1dJXNUMH1mVICGCl
         On34fud8BWI6UYsB6JBI35rLdoEI3a8S3trby0XQ6uOZGB94S96eajC7mTC3EjPGkX
         dRGX9R0u4Gf2PsTSl0Uw3VNpwTvE4zgHjjdXtJrsTh/CElbcvz+yJM6Er3xcTvj3vl
         Gs7xBGddQ1nESLpf+XD/s71+9fJgOQreR9h2tQG2luw0t6vqbmSrzwPBa2KoS3SN57
         07mPFVUgjBX9g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v5 2/3] net: implement threaded-able napi poll
 loop support
Message-ID: <20201215182437.7bdfafc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_DdarvYYSdnof+mEWJ=R7gBLB0By9EME2ZEfvGBhhN+Yg@mail.gmail.com>
References: <20201216012515.560026-1-weiwan@google.com>
        <20201216012515.560026-3-weiwan@google.com>
        <20201215175333.16735bf1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_DdarvYYSdnof+mEWJ=R7gBLB0By9EME2ZEfvGBhhN+Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 18:15:06 -0800 Wei Wang wrote:
> On Tue, Dec 15, 2020 at 5:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 15 Dec 2020 17:25:14 -0800 Wei Wang wrote:  
> > > +void napi_enable(struct napi_struct *n)
> > > +{
> > > +     bool locked = rtnl_is_locked();  
> >
> > Maybe you'll prove me wrong but I think this is never a correct
> > construct.  
> 
> Sorry, I don't get what you mean here.

You're checking if the mutex is locked, not if the caller is holding
the mutex.

> > > +     BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
> > > +     smp_mb__before_atomic();
> > > +     clear_bit(NAPI_STATE_SCHED, &n->state);
> > > +     clear_bit(NAPI_STATE_NPSVC, &n->state);
> > > +     if (!locked)
> > > +             rtnl_lock();  
> >
> > Why do we need the lock? Can't we assume the caller of napi_enable()
> > has the sole ownership of the napi instance? Surely clearing the other
> > flags would be pretty broken as well, so the napi must had been
> > disabled when this is called by the driver.
> >  
> 
> Hmm... OK. The reason I added this lock operation is that we have
> ASSERT_RTNL() check in napi_set_threaded(), because it is necessary
> from the net-sysfs path to grab rtnl lock when modifying the threaded
> mode. Maybe it is not needed here.

Fair point, the sysfs write path could try to change the setting while
the NIC is starting.

> And the reason I added a rtnl_is_locked() check is I found mlx driver
> already holds rtnl lock before calling napi_enable(). Not sure about
> other drivers though.

I'd think most drivers will only mess around with napi under rtnl_lock.

> > > +     WARN_ON(napi_set_threaded(n, n->dev->threaded));
> > > +     if (!locked)
> > > +             rtnl_unlock();
> > > +}
> > > +EXPORT_SYMBOL(napi_enable);  
