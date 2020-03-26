Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5169C1938A1
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgCZGbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:31:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36061 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgCZGbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:31:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so6326313wrs.3;
        Wed, 25 Mar 2020 23:31:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QqQzMUgxcnTHOrD0KUGTeJCY78+g6phmEGdKcQdeVU4=;
        b=M1n32hvoIU3JFtoqKQxJQas97g22VwfhdROi/Jeb0DW+FIKjgsh9LAio5rDfXkqy8r
         IpIlpcOos72np5Z6rw5+BMHzeQkPTd64BKtzyZg1iae7YMDmGd6FXkAgeS65YPKY98nr
         6zktP66EHqHQ6Z8DNI/64vfUwd6TuEDFVz9ItAsSzgLWzj4A66cTxBFIZ8TyjN/s6GVj
         5jWpy6zrNTv0cKJPs6oXDka6pP8JoDVQusR0D/yG57s0dkdvDA/Fqmm9NdVQzpCA126I
         5ramzchRgWWxQmrN+JudFORfo9AjJq7C4TfQyFg3DJpystLuVjK91vPzzv3dZBJKxHXd
         f7gw==
X-Gm-Message-State: ANhLgQ3KiG2hJmX/c92vywz64NeLcp8TGir5V8ks5dtITBGvgQnKcNK4
        MTHg7zDAsPz6XbnGZ48/LCAWX6umbHlZm1Z/rBFSmg==
X-Google-Smtp-Source: ADFU+vvKSZVxawfDKy3F+AFDjy+2UWm3uaWY2DpXiJkP4BwMBRE3fKbTJ0rwD1snK8rEhB4AbQhtt0XcXi5JLHaSVok=
X-Received: by 2002:adf:e584:: with SMTP id l4mr3289443wrm.388.1585204294523;
 Wed, 25 Mar 2020 23:31:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-2-joe@wand.net.nz>
 <20200326062317.ofhr2o7azamwhaxf@kafai-mbp>
In-Reply-To: <20200326062317.ofhr2o7azamwhaxf@kafai-mbp>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Wed, 25 Mar 2020 23:31:23 -0700
Message-ID: <CAOftzPjhADm7Aq2d=Hcu12RYpHSpJZEojGCT_QZoqk+o6LHHpg@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 1/5] bpf: Add socket assign support
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 11:23 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Mar 24, 2020 at 10:57:41PM -0700, Joe Stringer wrote:
> > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> >
> > This helper requires the BPF program to discover the socket via a call
> > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> > helper takes its own reference to the socket in addition to any existing
> > reference that may or may not currently be obtained for the duration of
> > BPF processing. For the destination socket to receive the traffic, the
> > traffic must be routed towards that socket via local route. The
> > simplest example route is below, but in practice you may want to route
> > traffic more narrowly (eg by CIDR):
> >
> >   $ ip route add local default dev lo
> >
> > This patch avoids trying to introduce an extra bit into the skb->sk, as
> > that would require more invasive changes to all code interacting with
> > the socket to ensure that the bit is handled correctly, such as all
> > error-handling cases along the path from the helper in BPF through to
> > the orphan path in the input. Instead, we opt to use the destructor
> > variable to switch on the prefetch of the socket.
> >
> > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > ---
> > v2: Use skb->destructor to determine socket prefetch usage instead of
> >       introducing a new metadata_dst
> >     Restrict socket assign to same netns as TC device
> >     Restrict assigning reuseport sockets
> >     Adjust commit wording
> > v1: Initial version
> > ---
> >  include/net/sock.h             |  7 +++++++
> >  include/uapi/linux/bpf.h       | 25 ++++++++++++++++++++++++-
> >  net/core/filter.c              | 31 +++++++++++++++++++++++++++++++
> >  net/core/sock.c                |  9 +++++++++
> >  net/ipv4/ip_input.c            |  3 ++-
> >  net/ipv6/ip6_input.c           |  3 ++-
> >  net/sched/act_bpf.c            |  2 ++
> >  tools/include/uapi/linux/bpf.h | 25 ++++++++++++++++++++++++-
> >  8 files changed, 101 insertions(+), 4 deletions(-)
> >
>
> [ ... ]
>
> > diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
> > index 46f47e58b3be..6c7ed8fcc909 100644
> > --- a/net/sched/act_bpf.c
> > +++ b/net/sched/act_bpf.c
> > @@ -53,6 +53,8 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
> >               bpf_compute_data_pointers(skb);
> >               filter_res = BPF_PROG_RUN(filter, skb);
> >       }
> > +     if (filter_res != TC_ACT_OK)
> Should skb_sk_is_prefetched() be checked also?

Yes, thanks, will fix.
