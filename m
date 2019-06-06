Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A60137532
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfFFN1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:27:36 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:37340 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfFFN1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 09:27:36 -0400
Received: by mail-it1-f194.google.com with SMTP id x22so1696829itl.2
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 06:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XQnXG/+fQR7z7pvbTRBkLBV32G/MJ2J2jPpM5lMz6ww=;
        b=UF6+jGbAhxxg495eFV290t3lknY+C7VmuDGd2DFEHRFdUT17JWbQb52+JouRsANs3r
         CHzxWsUxFKw8zE1+nDsFXydQ3nq1vxlByDv/jFyNyleo3JpnGMuDzw6waiXG1d2BpjEw
         ohsk5P1XlOLtmDZpBcyhwm1uN/13ROboF4ZctriGZbRVM6klYBrj1HuRlOSH3vhXxcDQ
         B5ulyThjjbXwgReSv23IhOpE/5qYWIfYU7/CfzSEU1rwIfqAizZcojtOiM4MqJeX1vo8
         GEhXZWkKvnyaXMBRT41ATbLoE1x29tbuPdI9r2ulw4OGNtJ+DmCu5umXMin4jpoQ75Ef
         eWQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XQnXG/+fQR7z7pvbTRBkLBV32G/MJ2J2jPpM5lMz6ww=;
        b=Uiojd7vgC4D7s4E/rF/rQ57kfiiUavtGWHBckw1m4BA2mryWWF4PPusyQmqhZOIccJ
         yxs/vgEYuxSpLYqk+WmQPpU2JhixXXNzFh7Q4pYT27H48hLCSGCRd6ZUGXH0NjB7KBHz
         Gh+tdJAUNkESccZ+iOMpSviqTVKDMaKrr4j2CkLOi2nUS6B1U3SsI7rMkfbXoOLr63ig
         DWY/OGuzK2XzCFdoujEquhuxKpJxBlsa3JfUG37eT0WUFYHpJUg1pbDucaJ1pEEIR1A2
         mi/buVecEJ5NK6sr1ie8MM5VSyWPoF+YuzWO1jAXmuRn2DfIFBINdyvcMOjVufAo1Cog
         pWQQ==
X-Gm-Message-State: APjAAAUtQpILNahrswqna5pQ0Y/YLdivAaSLfBwCtgEeEp2eJZunI/9S
        6u0Q3uW8O53NN6E/x7QAIBC3iqmIE6I8qZRgr1eDn7vY
X-Google-Smtp-Source: APXvYqwvkGyeeiFG9ivvSqs7VnHQRekE3lOOqRW6DrJGu0lyG2g0jGOzH8QwK5CyMk4MVseEHk1NY7XCpc7xqkzNfqQ=
X-Received: by 2002:a24:5285:: with SMTP id d127mr17503itb.72.1559827655679;
 Thu, 06 Jun 2019 06:27:35 -0700 (PDT)
MIME-Version: 1.0
References: <1559825374-32117-1-git-send-email-john.hurley@netronome.com> <20190606125818.bvo5im2wqj365tai@breakpoint.cc>
In-Reply-To: <20190606125818.bvo5im2wqj365tai@breakpoint.cc>
From:   John Hurley <john.hurley@netronome.com>
Date:   Thu, 6 Jun 2019 14:27:24 +0100
Message-ID: <CAK+XE=kQyq-ZW=DOaQq92zSmwcEi3BBwma1MydrdpnZ6F3Gp+A@mail.gmail.com>
Subject: Re: [RFC net-next v2 1/1] net: sched: protect against loops in TC
 filter hooks
To:     Florian Westphal <fw@strlen.de>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 1:58 PM Florian Westphal <fw@strlen.de> wrote:
>
> John Hurley <john.hurley@netronome.com> wrote:
> > TC hooks allow the application of filters and actions to packets at both
> > ingress and egress of the network stack. It is possible, with poor
> > configuration, that this can produce loops whereby an ingress hook calls
> > a mirred egress action that has an egress hook that redirects back to
> > the first ingress etc. The TC core classifier protects against loops when
> > doing reclassifies but there is no protection against a packet looping
> > between multiple hooks. This can lead to stack overflow panics among other
> > things.
> >
> > Previous versions of the kernel (<4.2) had a TTL count in the tc_verd skb
> > member that protected against loops. This was removed and the tc_verd
> > variable replaced by bit fields.
> >
> > Extend the TC fields in the skb with an additional 2 bits to store the TC
> > hop count. This should use existing allocated memory in the skb.
> >
> > Add the checking and setting of the new hop count to the act_mirred file
> > given that it is the source of the loops. This means that the code
> > additions are not in the main datapath.
> >
> > v1->v2
> > - change from per cpu counter to per skb tracking (Jamal)
> > - move check/update from fast path to act_mirred (Daniel)
> >
> > Signed-off-by: John Hurley <john.hurley@netronome.com>
> > ---
> >  include/linux/skbuff.h | 2 ++
> >  net/sched/act_mirred.c | 9 +++++++++
> >  2 files changed, 11 insertions(+)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 2ee5e63..f0dbc5b 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -645,6 +645,7 @@ typedef unsigned char *sk_buff_data_t;
> >   *   @tc_at_ingress: used within tc_classify to distinguish in/egress
> >   *   @tc_redirected: packet was redirected by a tc action
> >   *   @tc_from_ingress: if tc_redirected, tc_at_ingress at time of redirect
> > + *   @tc_hop_count: hop counter to prevent packet loops
> >   *   @peeked: this packet has been seen already, so stats have been
> >   *           done for it, don't do them again
> >   *   @nf_trace: netfilter packet trace flag
> > @@ -827,6 +828,7 @@ struct sk_buff {
> >       __u8                    tc_at_ingress:1;
> >       __u8                    tc_redirected:1;
> >       __u8                    tc_from_ingress:1;
> > +     __u8                    tc_hop_count:2;
>
> I dislike this, why can't we just use a pcpu counter?
>
> The only problem is with recursion/nesting; whenever we
> hit something that queues the skb for later we're safe.
>

Hi Florian,
The per cpu counter (initial proposal) should protect against
recursion through loops and the potential stack overflows.
It will not protect against a packet infinitely looping through a poor
configuration if (as you say) the packet is queued at some point and
the cpu counter reset.
The per skb tracking seems to accommodate both issues.
Do you see the how the cpu counter could stop infinite loops in the
case of queuing?
Or perhaps these are 2 different issues and should be treated differently?

> We can't catch loops in real (physical) setups either,
> e.g. bridge looping back on itself.

yes, this is only targeted at 'internal' loops.
