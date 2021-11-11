Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AF144CF2B
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 02:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbhKKBq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 20:46:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231312AbhKKBq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 20:46:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A160661872;
        Thu, 11 Nov 2021 01:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636595050;
        bh=JFKKUq79p5U8fw+VaK4DO9dZj2MNyU1Povus7peiRsQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gTAmQxwJ8T+9YLkFRzt33IJ8WolQ2tipUwyg8iB6RfjWxPKA8pifpWESBp7b8X4bx
         6fb/0ZaJfN8T1qs7d5LkFHKW0ZfeWYSSwDV+A7lyXWf3CZTNcGhzkBORIzms8NZ655
         WmRjZzQoeM/azMkFpmqnsYY7QlhOH32vf/fBc9O0qCHOa7nCNZUgkSMbgKnpMTB3gx
         VBEabJYmxmp99eRsedjSpmfT/NeYy/qAdHtlDZJpgSiMhFtNeg/3dHhMvDrx5Q9t3d
         m+d1zjeVqmEA/9jvqN7B5uFST8XckqUG+/u/P+oIXFwlD/x3Jn/gKUFwyhbCIli25y
         nUWRG67A9KFOA==
Date:   Wed, 10 Nov 2021 17:44:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: fix premature exit from NAPI state polling in
 napi_disable()
Message-ID: <20211110174407.2b9083a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211110194337.179-1-alexandr.lobakin@intel.com>
References: <20211110191126.1214-1-alexandr.lobakin@intel.com>
        <CANn89i+ZH83K9V7-7D6egC5AF=hxBv8FL+rroEqOskB-+TLZCA@mail.gmail.com>
        <20211110194337.179-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 20:43:37 +0100 Alexander Lobakin wrote:
> > What about replacing the error prone do {...} while (cmpxchg(..)) by
> > something less confusing ?
> > 
> > This way, no need for a label.
> > 
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 5e37d6809317fb3c54686188a908bfcb0bfccdab..9327141892cdaaf0282e082e0c6746abae0f12a7
> > 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6264,7 +6264,7 @@ void napi_disable(struct napi_struct *n)
> >         might_sleep();
> >         set_bit(NAPI_STATE_DISABLE, &n->state);
> > 
> > -       do {
> > +       for (;;) {
> >                 val = READ_ONCE(n->state);
> >                 if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) {
> >                         usleep_range(20, 200);
> > @@ -6273,7 +6273,9 @@ void napi_disable(struct napi_struct *n)
> > 
> >                 new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC;
> >                 new &= ~(NAPIF_STATE_THREADED | NAPIF_STATE_PREFER_BUSY_POLL);
> > -       } while (cmpxchg(&n->state, val, new) != val);
> > +               if (cmpxchg(&n->state, val, new) == val)
> > +                       break;
> > +       }
> > 
> >         hrtimer_cancel(&n->timer);  
> 
> LFTM, I'l queue v2 in a moment with you in Suggested-by.

Ouch.

Feel free to put

Acked-by: Jakub Kicinski <kuba@kernel.org>

on the v2.
