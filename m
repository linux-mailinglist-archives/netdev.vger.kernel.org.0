Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B296558F9
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 08:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiLXHik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 02:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLXHij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 02:38:39 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E171E15F22;
        Fri, 23 Dec 2022 23:38:37 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id s22so7143176ljp.5;
        Fri, 23 Dec 2022 23:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PEIbv2GFycGfkOrB6KG3qHEk5qaPBRjT/j4MyPFbif0=;
        b=E8W67IhC7OkRrpnhj7Qq8fVxhwp8zOnW5G4smr4zyvYRJAPkpf/vGsl4Nf0WcoMMQm
         dWHSHaQiWqz9s9DbfDLsEMPtIzyUjZhGWMX3Y7ZefggFsFOP7ywfT4SqxpOogC0owt6w
         gJEGtqkF1a7LCYkm0Q9woCiZzRXSPMbuAKxO8cezymxjMMqQ09f7C5wL2Qq6kZJg0VW6
         rCMP95gFXwRJg28ybVtQAJfTPW8QPhKibYJGwKYnLwo7b4ABoHZW3ZbwcIbsH8V4IACN
         QtmlfBpYcEO6M8kPaKE42/CI0WO2U7jZPPDS5TgCyszeixZ8Y/1moY2HUFi5oa1scfkh
         osVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PEIbv2GFycGfkOrB6KG3qHEk5qaPBRjT/j4MyPFbif0=;
        b=DPSHHDiocGHZcxZehukzSZw3MPC69xwU03xyUQDuqeK+1uO0VMXZ4zbv7mKh9tT6do
         657lVK146cc9VWrP63X2Rugm8Ffdh0/TovegSc0IFEZ1/afHnyISVNsBo7wKFWA4tFoK
         E+7cMX5xDx5Jcxl+ofcPxeMUwDK7VICBtIU15+Rm2VMug/RY2OZXbrikBhY58vhtmdow
         YwrNqdSSo8Hg9rH32qvF/7buNz1VZIr1h945zmmb/K9HDUQN9fO3Tj7F13OYpf0CwJVR
         SxEV+Pj/FgOB/7m8r4M7vLc1k64hCrZoc4kRD53WEBv+IFZu1iSSgc/l4ddC9+b6isJd
         1IVQ==
X-Gm-Message-State: AFqh2krZ3AWOEcAm5pTF4v8S3nDHXjJsDOrRdUdi0RdIw5qfRYyXX7u+
        jQxgxkA6uc7qMrJEYegVQlDpwjsHPWA2Kw0EVKQ=
X-Google-Smtp-Source: AMrXdXv92wa5Ynlm13M5pEnAuryXrNWu0fdMQ1eZsBhokZ6rYEvPfHFonBUkxqSQgDcnkdZ+71J+WEW1719IoYdWlZ0=
X-Received: by 2002:a2e:9b53:0:b0:277:155d:28c4 with SMTP id
 o19-20020a2e9b53000000b00277155d28c4mr760979ljj.123.1671867516121; Fri, 23
 Dec 2022 23:38:36 -0800 (PST)
MIME-Version: 1.0
References: <20221218234801.579114-1-jmaxwell37@gmail.com> <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
 <CAGHK07ALtLTjRP-XOepqoc8xzWcT8=0v5ccL-98f4+SU9vwfsg@mail.gmail.com> <20221223212835.eb9d03f3f7db22360e34341d@uniroma2.it>
In-Reply-To: <20221223212835.eb9d03f3f7db22360e34341d@uniroma2.it>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Sat, 24 Dec 2022 18:38:01 +1100
Message-ID: <CAGHK07APOwLvhs73WKkQfZuEy2FoKEWJusSyejKVcth4D47g=w@mail.gmail.com>
Subject: Re: [net-next] ipv6: fix routing cache overflow for raw sockets
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 24, 2022 at 7:28 AM Andrea Mayer <andrea.mayer@uniroma2.it> wrote:
>
> Hi Jon,
> please see below, thanks.
>
> On Wed, 21 Dec 2022 08:48:11 +1100
> Jonathan Maxwell <jmaxwell37@gmail.com> wrote:
>
> > On Tue, Dec 20, 2022 at 11:35 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > >
> > > On Mon, 2022-12-19 at 10:48 +1100, Jon Maxwell wrote:
> > > > Sending Ipv6 packets in a loop via a raw socket triggers an issue where a
> > > > route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly
> > > > consumes the Ipv6 max_size threshold which defaults to 4096 resulting in
> > > > these warnings:
> > > >
> > > > [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> > > > [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > > .
> > > > .
> > > > [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > >
> > > If I read correctly, the maximum number of dst that the raw socket can
> > > use this way is limited by the number of packets it allows via the
> > > sndbuf limit, right?
> > >
> >
> > Yes, but in my test sndbuf limit is never hit so it clones a route for
> > every packet.
> >
> > e.g:
> >
> > output from C program sending 5000000 packets via a raw socket.
> >
> > ip raw: total num pkts 5000000
> >
> > # bpftrace -e 'kprobe:dst_alloc {@count[comm] = count()}'
> > Attaching 1 probe...
> >
> > @count[a.out]: 5000009
> >
> > > Are other FLOWI_FLAG_KNOWN_NH users affected, too? e.g. nf_dup_ipv6,
> > > ipvs, seg6?
> > >
> >
> > Any call to ip6_pol_route(s) where no res.nh->fib_nh_gw_family is 0 can do it.
> > But we have only seen this for raw sockets so far.
> >
>
> In the SRv6 subsystem, the seg6_lookup_nexthop() is used by some
> cross-connecting behaviors such as End.X and End.DX6 to forward traffic to a
> specified nexthop. SRv6 End.X/DX6 can specify an IPv6 DA (i.e., a nexthop)
> different from the one carried by the IPv6 header. For this purpose,
> seg6_lookup_nexthop() sets the FLOWI_FLAG_KNOWN_NH.
>
Hi Andrea,

Thanks for pointing that datapath out. The more generic approach we are
taking bringing Ipv6 closer to Ipv4 in this regard should fix all instances
of this.

> > > > [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> > > > [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > > .
> > > > .
> > > > [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
>
> I can reproduce the same warning messages reported by you, by instantiating an
> End.X behavior whose nexthop is handled by a route for which there is no "via".
> In this configuration, the ip6_pol_route() (called by seg6_lookup_nexthop())
> triggers ip6_rt_cache_alloc() because i) the FLOWI_FLAG_KNOWN_NH is present ii)
> and the res.nh->fib_nh_gw_family is 0 (as already pointed out).
>

Nice, when I get back after the holiday break I'll submit the next patch. It
would be great if you could test the new patch and let me know how it works in
your tests at that juncture. I'll keep you posted.

Regards

Jon

> > Regards
> >
> > Jon
>
> Ciao,
> Andrea
