Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF10655436
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 21:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbiLWUdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 15:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiLWUdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 15:33:17 -0500
X-Greylist: delayed 236 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 23 Dec 2022 12:33:15 PST
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987C8D2CC
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 12:33:14 -0800 (PST)
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 2BNKSdGa001410;
        Fri, 23 Dec 2022 21:28:45 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 717B312092C;
        Fri, 23 Dec 2022 21:28:35 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1671827315; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Py36qjrgcICiChkOdOG3s4z5m+sypuiLz/tKO0u1foc=;
        b=MCqfTBclSQDbii99wNA4iy6VJ+Bfv6ZTglHJ2eVPX5WcHmycZbV6qX2W1Y6rKHQgsiQeO4
        IvmKM6CJgxyuxGBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1671827315; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Py36qjrgcICiChkOdOG3s4z5m+sypuiLz/tKO0u1foc=;
        b=xjm2JE+UwHvnIcmIDxovG3376hhK2tFvmA5IukSfNKFGfbEUEZFmu9BaR9bQDLRWml5o+p
        lSXvyrSobSIQAm9XGJHOHoXpxdB7hPAKL+tvEZ2bRQWojuUGZOUdMTOlELB3uRRaSo25qz
        Ra7vTLik4+vGrBxzVTPuGBaeM/QratyIpo0u7z3GBEB1aWzY2wv0Qe9ApV5DI5U2+4PYb3
        IkD7o0b3AS2vLiQjZDGuqe2EBMAmfnl/xUPhZQYcwxVXoF0Z6nvTShnw7bEWM4+NYjB8KH
        zHFESbkgUzmuR7mxFP2EpJRy6ubbwDdbJk4zntADP6N1AqnTdjQTuuNFWeyUaw==
Date:   Fri, 23 Dec 2022 21:28:35 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Jonathan Maxwell <jmaxwell37@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next] ipv6: fix routing cache overflow for raw sockets
Message-Id: <20221223212835.eb9d03f3f7db22360e34341d@uniroma2.it>
In-Reply-To: <CAGHK07ALtLTjRP-XOepqoc8xzWcT8=0v5ccL-98f4+SU9vwfsg@mail.gmail.com>
References: <20221218234801.579114-1-jmaxwell37@gmail.com>
        <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
        <CAGHK07ALtLTjRP-XOepqoc8xzWcT8=0v5ccL-98f4+SU9vwfsg@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jon,
please see below, thanks.

On Wed, 21 Dec 2022 08:48:11 +1100
Jonathan Maxwell <jmaxwell37@gmail.com> wrote:

> On Tue, Dec 20, 2022 at 11:35 PM Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > On Mon, 2022-12-19 at 10:48 +1100, Jon Maxwell wrote:
> > > Sending Ipv6 packets in a loop via a raw socket triggers an issue where a
> > > route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly
> > > consumes the Ipv6 max_size threshold which defaults to 4096 resulting in
> > > these warnings:
> > >
> > > [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> > > [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > .
> > > .
> > > [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> >
> > If I read correctly, the maximum number of dst that the raw socket can
> > use this way is limited by the number of packets it allows via the
> > sndbuf limit, right?
> >
> 
> Yes, but in my test sndbuf limit is never hit so it clones a route for
> every packet.
> 
> e.g:
> 
> output from C program sending 5000000 packets via a raw socket.
> 
> ip raw: total num pkts 5000000
> 
> # bpftrace -e 'kprobe:dst_alloc {@count[comm] = count()}'
> Attaching 1 probe...
> 
> @count[a.out]: 5000009
> 
> > Are other FLOWI_FLAG_KNOWN_NH users affected, too? e.g. nf_dup_ipv6,
> > ipvs, seg6?
> >
> 
> Any call to ip6_pol_route(s) where no res.nh->fib_nh_gw_family is 0 can do it.
> But we have only seen this for raw sockets so far.
> 

In the SRv6 subsystem, the seg6_lookup_nexthop() is used by some
cross-connecting behaviors such as End.X and End.DX6 to forward traffic to a
specified nexthop. SRv6 End.X/DX6 can specify an IPv6 DA (i.e., a nexthop)
different from the one carried by the IPv6 header. For this purpose,
seg6_lookup_nexthop() sets the FLOWI_FLAG_KNOWN_NH.

> > > [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> > > [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > .
> > > .
> > > [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.

I can reproduce the same warning messages reported by you, by instantiating an
End.X behavior whose nexthop is handled by a route for which there is no "via".
In this configuration, the ip6_pol_route() (called by seg6_lookup_nexthop())
triggers ip6_rt_cache_alloc() because i) the FLOWI_FLAG_KNOWN_NH is present ii)
and the res.nh->fib_nh_gw_family is 0 (as already pointed out).

> Regards
> 
> Jon

Ciao,
Andrea
