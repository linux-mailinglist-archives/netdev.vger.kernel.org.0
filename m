Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A6052779
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbfFYJGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:06:12 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37867 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbfFYJGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:06:12 -0400
Received: by mail-io1-f68.google.com with SMTP id e5so2084912iok.4
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kLNKHOQWayNee0D8EWo9aodhV2Hm05DpYScTX3J1tGg=;
        b=nsqbBv4TSH0RD10ekIfTQsy+w2wPjf6tf9Gn5/Ihr8PE+WroAy7UdOKDbEGNIzLlP8
         BRY5MkqWvBgl7CPbKNOYrJVpqnn8lL/waVK6/Ay1embPYpbKcu9PCxUWCYCjXinwPMWQ
         DrrpuSgsKCk4c5fUmXfgGmceetftfb/On2Mbcw8/BGsdlj8TkyDAAVxzDCbxKqRTUmnN
         2fFWIXeNBil7YbHGtjHT0IT8CdaYREUywDkBCym3NxIjThhq9SRrxiHxmcQYpT4ZnGJ1
         XTasRGr1bhtto4XMJRxbrH7tGyA/mgxUmHnF84+GLf/6v0wJR30R0hKI8a+J9/OfW9VI
         rVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kLNKHOQWayNee0D8EWo9aodhV2Hm05DpYScTX3J1tGg=;
        b=F2j77TxiQPo3WzSI+CFM9e8cxD0LOR40fIhIl68VmcRAxjkshQmcfzZrulaXv4t+S/
         n628SYSftsa1/U2HNTSGsm7sxu4i5QpAMXOUyfHZwQQVmBIG4m9Z+oVouQN1DcZXO4Fi
         SFXuzj3oJD878NsLjuda1S1ft5/cDnIuZ9zRcIQGjDxClNppb4Mz3AQ/BRFVSnb/umYh
         xfaAnTbj8yhRZwgyTc8RQSPF2VgYzYjqyutVIzi74b5JqpmNkfK58QkIWJX1iGdrif2+
         IFQ4zsRZMohOsaxJz3r+d4tM36d0etypFgsH4tzHhbO7WFwomvM3F3mOP4rv2Rr3CZQK
         gC2Q==
X-Gm-Message-State: APjAAAWj1UEWHzMeDfkye+/4/JUHWHEB0AovSDvuGhB/0MKWsw7nHh+m
        wKa2ihUypEmNK7ft9x1O23Aergp9/PKbSkJdwfhicA==
X-Google-Smtp-Source: APXvYqxs/cmbqWqSL1RCHIYLt8rNVmtSrcp8f08zDFAoB756TWqTwz0wAI4BFDITjY/t9glwVg6ypxgKm5nGq0gs1ro=
X-Received: by 2002:a02:b10b:: with SMTP id r11mr21573872jah.140.1561453571484;
 Tue, 25 Jun 2019 02:06:11 -0700 (PDT)
MIME-Version: 1.0
References: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
 <1561414416-29732-3-git-send-email-john.hurley@netronome.com> <20190625113010.7da5dbcb@jimi>
In-Reply-To: <20190625113010.7da5dbcb@jimi>
From:   John Hurley <john.hurley@netronome.com>
Date:   Tue, 25 Jun 2019 10:06:00 +0100
Message-ID: <CAK+XE=mOjtp16tdz83RZ-x_jEp3nPRY3smxbG=OfCmGi9_DnXg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: sched: protect against stack overflow
 in TC act_mirred
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com, shmulik@metanetworks.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 9:30 AM Eyal Birger <eyal.birger@gmail.com> wrote:
>
> Hi John,
>
> On Mon, 24 Jun 2019 23:13:36 +0100
> John Hurley <john.hurley@netronome.com> wrote:
>
> > TC hooks allow the application of filters and actions to packets at
> > both ingress and egress of the network stack. It is possible, with
> > poor configuration, that this can produce loops whereby an ingress
> > hook calls a mirred egress action that has an egress hook that
> > redirects back to the first ingress etc. The TC core classifier
> > protects against loops when doing reclassifies but there is no
> > protection against a packet looping between multiple hooks and
> > recursively calling act_mirred. This can lead to stack overflow
> > panics.
> >
> > Add a per CPU counter to act_mirred that is incremented for each
> > recursive call of the action function when processing a packet. If a
> > limit is passed then the packet is dropped and CPU counter reset.
> >
> > Note that this patch does not protect against loops in TC datapaths.
> > Its aim is to prevent stack overflow kernel panics that can be a
> > consequence of such loops.
> >
> > Signed-off-by: John Hurley <john.hurley@netronome.com>
> > Reviewed-by: Simon Horman <simon.horman@netronome.com>
> > ---
> >  net/sched/act_mirred.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> > index 8c1d736..c3fce36 100644
> > --- a/net/sched/act_mirred.c
> > +++ b/net/sched/act_mirred.c
> > @@ -27,6 +27,9 @@
> >  static LIST_HEAD(mirred_list);
> >  static DEFINE_SPINLOCK(mirred_list_lock);
> >
> > +#define MIRRED_RECURSION_LIMIT    4
>
> Could you increase the limit to maybe 6 or 8? I am aware of cases where
> mirred ingress is used for cascading several layers of logical network
> interfaces and 4 seems a little limiting.
>
> Thanks,
> Eyal.

Hi Eyal,
The value of 4 is basically a revert to what it was on older kernels
when TC had a TTL value in the skb:
https://elixir.bootlin.com/linux/v3.19.8/source/include/uapi/linux/pkt_cls.h#L97

I also found with my testing that a value greater than 4 was sailing
close to the edge.
With a larger value (on my system anyway), I could still trigger a
stack overflow here.
I'm not sure on the history of why a value of 4 was selected here but
it seems to fall into line with my findings.
Is there a hard requirement for >4 recursive calls here?

John
