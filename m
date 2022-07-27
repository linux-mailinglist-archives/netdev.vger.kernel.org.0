Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A1C582547
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbiG0LT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiG0LTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:19:25 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44C0B7CE
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 04:19:20 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id v21so854041ljh.3
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 04:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=krBnCNwpUxHXqZ7yrxO4yCqWb6NLq7+yMcOLgP9pI2U=;
        b=CBeBXlMRQd737/3bZhKM0SHUY1sHuKKfbbN7Szq/B5jkrA3Jon7pvBq+wxgpn8PeDI
         mIXAp/rE0sXfOO+d/Jrew7qtZWwP/aBLDsIqAqQojUyhswACP8dy1rqSiv1Xo6UTwb9q
         Ph30v+TZG+B6rOFPlWK6CsjkANlmCRFR+0SHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=krBnCNwpUxHXqZ7yrxO4yCqWb6NLq7+yMcOLgP9pI2U=;
        b=EBobnt2ABdUrjFizwpmdQV/Slod3BcdM4CvUjce8CmaS2g0tik13LAQLBjwbwCyARn
         TP493XPUP3WWhaqFzRQSxZ/2md5ATl5BYIY+rVY7NA97kXr966+V7rD2dULKdoWRUNGo
         oXEw83/m8EMg8Jz/xBO2A+oFVwJCQNGbMgKV61KT3rrQCcBob2Ag9sZvz4W9kLZp/Nhf
         Hzm4TG8A9HbXHeEgCtX7UVT1iQkxwecio+lGPFKN505tVhchIfBP0G3gG4X41mnf9d+o
         15/sGKxgw4t+I4r/DEawCNE0Ma26pwXkEh4SpL6meSySOrZIYvNC2PumydtAr6mHLvjw
         gQjA==
X-Gm-Message-State: AJIora8eMEyX1prbqF7SQ/8y5nqO/A2BvO57WfI6HP5EYBqw1ORE0BrA
        mF09mHm9B9tR/voUZ988hBep2kqAdd1voogKrPX4Nw==
X-Google-Smtp-Source: AGRyM1toiia5i7sCzBGzTLDMUN4igu1kYNC13YEZSj/u5G0MxHhmlIkFT5sysvHQmHWR8T6wODQU73kY8XcBt/+zhcM=
X-Received: by 2002:a2e:9e17:0:b0:25d:8897:2a77 with SMTP id
 e23-20020a2e9e17000000b0025d88972a77mr7202630ljk.441.1658920758963; Wed, 27
 Jul 2022 04:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220721151041.1215017-1-marek@cloudflare.com>
 <20220721151041.1215017-2-marek@cloudflare.com> <CANn89iKi2yaw=H-E8e9iet-gwr9vR6SmN9hibHF-5nT44K+e+g@mail.gmail.com>
In-Reply-To: <CANn89iKi2yaw=H-E8e9iet-gwr9vR6SmN9hibHF-5nT44K+e+g@mail.gmail.com>
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Wed, 27 Jul 2022 13:19:08 +0200
Message-ID: <CAJPywTKf1FdCRt2DZz3H+yhXqdFQ2tq9eNC4jtNHb0SgLwGfgA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] RTAX_INITRWND should be able to bring the
 rcv_ssthresh above 64KiB
To:     Eric Dumazet <edumazet@google.com>, brakmo@fb.com
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Ivan Babrou <ivan@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 11:23 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Jul 21, 2022 at 5:10 PM Marek Majkowski <marek@cloudflare.com> wrote:
> >
> > We already support RTAX_INITRWND / initrwnd path attribute:
> >
> >  $ ip route change local 127.0.0.0/8 dev lo initrwnd 1024
> >
> > However normally, the initial advertised receive window is limited to
> > 64KiB by rcv_ssthresh, regardless of initrwnd. This patch changes
> > that, bumping up rcv_ssthresh to value derived from initrwnd. This
> > allows for larger initial advertised receive windows, which is useful
> > for specific types of TCP flows: big BDP ones, where there is a lot of
> > data to send immediately after the flow is established.
> >
> > There are three places where we initialize sockets:
> >  - tcp_output:tcp_connect_init
> >  - tcp_minisocks:tcp_openreq_init_rwin
> >  - syncookies
> >
> > In the first two we already have a call to `tcp_rwnd_init_bpf` and
> > `dst_metric(RTAX_INITRWND)` which retrieve the bpf/path initrwnd
> > attribute. We use this value to bring `rcv_ssthresh` up, potentially
> > above the traditional 64KiB.
> >
> > With higher initial `rcv_ssthresh` the receiver will open the receive
> > window more aggresively, which can improve large BDP flows - large
> > throughput and latency.
> >
> > This patch does not cover the syncookies case.
> >
> > Signed-off-by: Marek Majkowski <marek@cloudflare.com>
> > ---
> >  include/net/inet_sock.h  |  1 +
> >  net/ipv4/tcp_minisocks.c |  8 ++++++--
> >  net/ipv4/tcp_output.c    | 10 ++++++++--
> >  3 files changed, 15 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
> > index daead5fb389a..bc68c9b70942 100644
> > --- a/include/net/inet_sock.h
> > +++ b/include/net/inet_sock.h
> > @@ -89,6 +89,7 @@ struct inet_request_sock {
> >                                 no_srccheck: 1,
> >                                 smc_ok     : 1;
> >         u32                     ir_mark;
> > +       u32                     rcv_ssthresh;
>
> Why do we need to store this value in the request_sock ?
>
> It is derived from a route attribute and MSS, all this should be
> available when the full blown socket is created.
>
> It would also work even with syncookies.

Eric,

Thanks for the feedback. For some context, I published a blog post
explaining this work in detail [1].

https://blog.cloudflare.com/when-the-window-is-not-fully-open-your-tcp-stack-is-doing-more-than-you-think/

I understand the suggestion is to move tcp_rwnd_init_bpf +
RTAX_INITRWND lookup from `tcp_openreq_init_rwin` into
`tcp_create_openreq_child`.

I gave it a try (patch: [2]), but I don't think this will work under
all circumstances. The issue is that we need to advertise *some*
window in the SYNACK packet, before creating the full blown socket.

With RTAX_INITRWND it is possible to move the advertised window up, or
down.

In the latter case, of reducing the window, at the SYNACK moment we
must know if the window is reduced under 64KiB. This is what happens
right now, we can _reduce_ window with RTAX_INITRWND to small values,
I guess down to 1 MSS. This smaller window is then advertised in the
SYNACK.

If we move RTAX_INITRWND lookup into the later
`tcp_create_openreq_child` then it will be too late, we won't know the
correct window size on SYNACK stage. We will likely end up sending
large window on SYNACK and then a small window on subsequent ACK,
violating TCP.

There are two approaches here. First, keep the semantics and allow
RTAX_INITRWND to _reduce_ the initial window.

In this case there are four ways out of this:

1) Keep it as proposed, that indeed requires some new value in
request_sock. (perhaps maybe it could be it smaller than u32)

2) Send the SYNACK with small/zero window, since we haven't done the
initrwnd lookup at this stage, but that would be at least
controversial, and also adds one more RTT to the common case. I don't
think this is acceptable.

3) Do two initrwnd lookups. One in the `tcp_openreq_init_rwin` to
figure out if the window is smaller than 64KiB, second one in
`tcp_create_openreq_child` to figure out if the suggested window is
larger than 64KiB.

4) Abort the whole approach and recycle Ivan's
bpf_setsockopt(TCP_BPF_RCV_SSTHRESH) approach [3]. But I prefer the route
attribute approach, seems easier to use and more flexible.

But, thinking about it, I don't think we could ever support reducing
initial receive window in the syncookie case. Only (3) - two initrwnd
lookups - could be made to work, but even that is controversial.

However the intention of RTAX_INITRWND as far as I understand was to
_increase_ rcv_ssthresh, back in the days when it started from 10MSS
(so I was told).

So, we could change the semantics of RTAX_INITRWND to allow only
*increasing* the window - and disallow reducing it. With such an
approach indeed we could make the code as you suggested, and move the
route attribute lookup away from minisocks into `tcp_create_openreq_child`.

Marek

[1] https://blog.cloudflare.com/when-the-window-is-not-fully-open-your-tcp-stack-is-doing-more-than-you-think/
[2] https://gist.github.com/majek/13848c050a3dc218ed295364ee717879
[3] https://lore.kernel.org/bpf/20220111192952.49040-1-ivan@cloudflare.com/t/
