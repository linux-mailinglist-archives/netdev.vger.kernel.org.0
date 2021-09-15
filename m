Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3C340CD4B
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 21:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhIOTiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 15:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231689AbhIOTiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 15:38:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2674360EB2;
        Wed, 15 Sep 2021 19:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631734604;
        bh=t09GBjce9U7iHt0gfAcWTNTklqQCqovHzk5Q+rZNPjs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vIFvSZ4xVtojfarRSYsvuAqhtFf+yXQ7xEuHJq+NXAXTtdcQ8m4Wi3mBiD7X5l4xp
         b8KBugrBTf12gSVlmioN4Yz4b71I9mhE/ajoW3wG3kDYKtOgqWgA7GPH23/6oNTJ/2
         bA3oh2Lw+vfss15SXR3BnSEWI7P2yi8L4Z+zh1cJtOXFenwa/hlmQYL/LGr2brVT1S
         +ifGWoSYk7gWGMImb93nZqx7mzdSXS/IGToGexQscYLfRujBC3DEhlbxX3+BDrNj5j
         Rc7xN6moMByGTcNzm7y5T7jNWPB7r2LqC/00D63SO5d37yDfeuCXHqRsP7Gj+YfpvW
         ZxDUjHD6/ACYA==
Date:   Wed, 15 Sep 2021 12:36:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>,
        Matthew Massey <matthewmassey@fb.com>,
        Dave Taht <dave.taht@gmail.com>
Subject: Re: [PATCH net-next 1/3] net: sched: update default qdisc
 visibility after Tx queue cnt changes
Message-ID: <20210915123642.218f7f11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpVec_FY-71n3VUUgo8YCcn00+QzBBck9h1RGNaFzXX_ig@mail.gmail.com>
References: <20210913225332.662291-1-kuba@kernel.org>
        <20210913225332.662291-2-kuba@kernel.org>
        <CAM_iQpVec_FY-71n3VUUgo8YCcn00+QzBBck9h1RGNaFzXX_ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Sep 2021 09:31:08 -0700 Cong Wang wrote:
> On Mon, Sep 13, 2021 at 3:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 74fd402d26dd..f930329f0dc2 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -2921,6 +2921,8 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
> >                 if (dev->num_tc)
> >                         netif_setup_tc(dev, txq);
> >
> > +               dev_qdisc_change_real_num_tx(dev, txq);
> > +  
> 
> Don't we need to flip the device with dev_deactivate()+dev_activate()?
> It looks like the only thing this function resets is qdisc itself, and only
> partially.

We're only making the qdiscs visible, there should be 
no datapath-visible change.

> >                 dev->real_num_tx_queues = txq;
> >
> >                 if (disabling) {

> > diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
> > index e79f1afe0cfd..db18d8a860f9 100644
> > --- a/net/sched/sch_mq.c
> > +++ b/net/sched/sch_mq.c
> > @@ -125,6 +125,29 @@ static void mq_attach(struct Qdisc *sch)
> >         priv->qdiscs = NULL;
> >  }
> >
> > +static void mq_change_real_num_tx(struct Qdisc *sch, unsigned int new_real_tx)  
> 
> This is nearly identical to mqprio_change_real_num_tx(), can we reuse
> it?

Indeed, I was a little unsure where best to place the helper.
Since mq is always built if mqprio is my instinct would be to
export mq_change_real_num_tx and use it in mqprio. But I didn't 
see any existing exports (mq_attach(), mq_queue_get() are also
identical and are not shared) so I just copy&pasted the logic.

LMK if (a) that's fine; (b) I should share the new code; 
(c) I should post a patch to share all the code that's identical;...
