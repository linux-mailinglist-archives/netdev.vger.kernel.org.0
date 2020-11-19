Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5050D2B9966
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgKSRhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:37:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbgKSRhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 12:37:21 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA9472225E;
        Thu, 19 Nov 2020 17:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605807441;
        bh=/uq3mQV6kvJptom0WX4bY+vpKtitRVsfXStdDA7wB1E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o01h8p6nQ8ZLg224oaybdhlqUt4YdKdlfgkK1l9PumnOtaBxGgBT5FanMT7Ydh0iC
         P4yzY+cSjkvRjOmsMREVyWg4TwWz9cD40fgMxSRjpZUXc8J6BYfW4qCycQJqQjamYX
         TINv4zAi0Q1SZ97yBmu+oHVb0F1Hur49I9YZD25E=
Date:   Thu, 19 Nov 2020 09:37:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Seewald <tseewald@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] cxbgb4: Fix build failure when CHELSIO_TLS_DEVICE=n
Message-ID: <20201119093719.15f19884@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAARYdbg+HsjCBu5vU=aHg-OU8L6u52RUBzrYUTuUMke6bXuV3g@mail.gmail.com>
References: <20201116023140.28975-1-tseewald@gmail.com>
        <20201117142559.37e6847f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAARYdbg+HsjCBu5vU=aHg-OU8L6u52RUBzrYUTuUMke6bXuV3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 23:40:40 -0600 Tom Seewald wrote:
> On Tue, Nov 17, 2020 at 4:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Sun, 15 Nov 2020 20:31:40 -0600 Tom Seewald wrote:  
> > > After commit 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
> > > building the kernel with CHELSIO_T4=y and CHELSIO_TLS_DEVICE=n results
> > > in the following error:
> > >
> > > ld: drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.o: in function
> > > `cxgb_select_queue':
> > > cxgb4_main.c:(.text+0x2dac): undefined reference to `tls_validate_xmit_skb'
> > >
> > > This is caused by cxgb_select_queue() calling cxgb4_is_ktls_skb() without
> > > checking if CHELSIO_TLS_DEVICE=y. Fix this by calling cxgb4_is_ktls_skb()
> > > only when this config option is enabled.
> > >
> > > Fixes: 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
> > > Signed-off-by: Tom Seewald <tseewald@gmail.com>
> > > ---
> > >  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> > > index 7fd264a6d085..8e8783afd6df 100644
> > > --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> > > +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> > > @@ -1176,7 +1176,9 @@ static u16 cxgb_select_queue(struct net_device *dev, struct sk_buff *skb,
> > >               txq = netdev_pick_tx(dev, skb, sb_dev);
> > >               if (xfrm_offload(skb) || is_ptp_enabled(skb, dev) ||
> > >                   skb->encapsulation ||
> > > -                 cxgb4_is_ktls_skb(skb) ||
> > > +#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
> > > +             cxgb4_is_ktls_skb(skb) ||
> > > +#endif /* CHELSIO_TLS_DEVICE */
> > >                   (proto != IPPROTO_TCP && proto != IPPROTO_UDP))
> > >                       txq = txq % pi->nqsets;
> > >  
> >
> > The tls header already tries to solve this issue, it just does it
> > poorly. This is a better fix:
> >
> > diff --git a/include/net/tls.h b/include/net/tls.h
> > index baf1e99d8193..2ff3f4f7954a 100644
> > --- a/include/net/tls.h
> > +++ b/include/net/tls.h
> > @@ -441,11 +441,11 @@ struct sk_buff *
> >  tls_validate_xmit_skb(struct sock *sk, struct net_device *dev,
> >                       struct sk_buff *skb);
> >
> >  static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
> >  {
> > -#ifdef CONFIG_SOCK_VALIDATE_XMIT
> > +#ifdef CONFIG_TLS_DEVICE
> >         return sk_fullsock(sk) &&
> >                (smp_load_acquire(&sk->sk_validate_xmit_skb) ==
> >                &tls_validate_xmit_skb);
> >  #else
> >         return false;
> >
> >
> > Please test this and submit if it indeed solves the problem.
> >
> > Thanks!  
> 
> Hi Jakub,
> 
> Thanks for the reply, unfortunately that patch does not resolve the
> issue, I still get the same error as before. After looking into this a
> bit further, the issue seems to be with CONFIG_TLS=m as everything
> works when CONFIG_TLS=y.
> 
> I also see that there was a similar issue [1] reported by Intel's
> kbuild test robot where the cxgb4 driver isn't able to see the TLS
> symbols when CONFIG_TLS=m.

Interesting. Does your original patch solve the allyesconfig + TLS=m
problem?

Seems to me that CHELSIO_T4 should depend on (TLS || TLS=n), the
CONFIG_CHELSIO_TLS_DEVICE has the dependency but AFAICT nothing prevents
CONFIG_CHELSIO_TLS_DEVICE=m and CHELSIO_T4=y and cxgb4_main.c is under
the latter.
