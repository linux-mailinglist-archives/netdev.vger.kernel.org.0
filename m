Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C2344C960
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhKJTtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:49:01 -0500
Received: from mga06.intel.com ([134.134.136.31]:31091 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231859AbhKJTtA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 14:49:00 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="293580829"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="293580829"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 11:44:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="589470791"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 10 Nov 2021 11:44:16 -0800
Received: from alobakin-mobl.ger.corp.intel.com (acetnero-MOBL1.ger.corp.intel.com [10.213.0.197])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1AAJiEIX013510;
        Wed, 10 Nov 2021 19:44:14 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: fix premature exit from NAPI state polling in napi_disable()
Date:   Wed, 10 Nov 2021 20:43:37 +0100
Message-Id: <20211110194337.179-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <CANn89i+ZH83K9V7-7D6egC5AF=hxBv8FL+rroEqOskB-+TLZCA@mail.gmail.com>
References: <20211110191126.1214-1-alexandr.lobakin@intel.com> <CANn89i+ZH83K9V7-7D6egC5AF=hxBv8FL+rroEqOskB-+TLZCA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 Nov 2021 11:24:39 -0800

> On Wed, Nov 10, 2021 at 11:11 AM Alexander Lobakin
> <alexandr.lobakin@intel.com> wrote:
> >
> > Commit 719c57197010 ("net: make napi_disable() symmetric with
> > enable") accidentally introduced a bug sometimes leading to a kernel
> > BUG when bringing an iface up/down under heavy traffic load.
> >
> > Prior to this commit, napi_disable() was polling n->state until
> > none of (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC) is set and then
> > always flip them. Now there's a possibility to get away with the
> > NAPIF_STATE_SCHE unset as 'continue' drops us to the cmpxchg()
> > call with an unitialized variable, rather than straight to
> > another round of the state check.
> >
> > Error path looks like:
> >
> > napi_disable():
> > unsigned long val, new; /* new is uninitialized */
> >
> > do {
> >         val = READ_ONCE(n->state); /* NAPIF_STATE_NPSVC and/or
> >                                       NAPIF_STATE_SCHED is set */
> >         if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) { /* true */
> >                 usleep_range(20, 200);
> >                 continue; /* go straight to the condition check */
> >         }
> >         new = val | <...>
> > } while (cmpxchg(&n->state, val, new) != val); /* state == val, cmpxchg()
> >                                                   writes garbage */
> >
> > napi_enable():
> > do {
> >         val = READ_ONCE(n->state);
> >         BUG_ON(!test_bit(NAPI_STATE_SCHED, &val)); /* 50/50 boom */
> > <...>
> >
> > while the typical BUG splat is like:
> >
> > [
> > Fix this by replacing this 'continue' with a goto to the beginning
> > of the loop body to restore the original behaviour.
> > This could be written without a goto, but would look uglier and
> > require one more indent level.
> >
> > Fixes: 719c57197010 ("net: make napi_disable() symmetric with enable")
> > Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > ---
> >  net/core/dev.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index edeb811c454e..5e101c53b9de 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6929,10 +6929,11 @@ void napi_disable(struct napi_struct *n)
> >         set_bit(NAPI_STATE_DISABLE, &n->state);
> >
> >         do {
> > +retry:
> >                 val = READ_ONCE(n->state);
> >                 if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) {
> >                         usleep_range(20, 200);
> > -                       continue;
> > +                       goto retry;
> >                 }
> >
> >                 new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC;
> > --
> > 2.33.1
> >
> 
> Good catch !

Thanks!

> What about replacing the error prone do {...} while (cmpxchg(..)) by
> something less confusing ?
> 
> This way, no need for a label.
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 5e37d6809317fb3c54686188a908bfcb0bfccdab..9327141892cdaaf0282e082e0c6746abae0f12a7
> 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6264,7 +6264,7 @@ void napi_disable(struct napi_struct *n)
>         might_sleep();
>         set_bit(NAPI_STATE_DISABLE, &n->state);
> 
> -       do {
> +       for (;;) {
>                 val = READ_ONCE(n->state);
>                 if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) {
>                         usleep_range(20, 200);
> @@ -6273,7 +6273,9 @@ void napi_disable(struct napi_struct *n)
> 
>                 new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC;
>                 new &= ~(NAPIF_STATE_THREADED | NAPIF_STATE_PREFER_BUSY_POLL);
> -       } while (cmpxchg(&n->state, val, new) != val);
> +               if (cmpxchg(&n->state, val, new) == val)
> +                       break;
> +       }
> 
>         hrtimer_cancel(&n->timer);

LFTM, I'l queue v2 in a moment with you in Suggested-by.

Thanks,
Al
