Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E7E652887
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 22:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiLTVsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 16:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLTVsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 16:48:50 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EB1B867;
        Tue, 20 Dec 2022 13:48:50 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id v11so13774957ljk.12;
        Tue, 20 Dec 2022 13:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zKdby5jz1dpXnJrBgCDeZHqY7CetYnf+rddUGWikGd8=;
        b=LtuYYUO4y4anNRiDR9VxdCz9svNTEEzoi2IJE7Pr+nOG55Vtu0ZImP/8W71R3G5n94
         6ozdzrhj7jctdQj2v4Ucy669R8l0R7/KczTwZApy/tPj9ZTA522l5zf5tcm8zBnKC54q
         2xIkgk1eLVV5cJ7x+nAGwO/T4GE15a7iVQR7ucjoc5bj4nwKJmUqlKvxBZSoGuv9Nezt
         11MLvkjgYLbs0pXj5DxXffqWFp6FzFRHdWmxseyR0VtbVBfq+/QyU7pbljX8Xb/dqfCv
         BhOCYdlQcT5lnoBdobE08OsEHvQkfZyxgaZMNDolTHTEDZoTJ+TF0X/Xim8TXz+5HUkd
         n6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zKdby5jz1dpXnJrBgCDeZHqY7CetYnf+rddUGWikGd8=;
        b=jm5o7aJEs6qxjotVNjC9SoFHlDWyMH5tmmdJ8M54p0XkTy0KAUs4MMLs8bwG/tc08Q
         3F6gWCvYb7zgYF77ntB9vNqizLfzuT9uFEZbYNoz5i5hPEi54vrsaqDut/kwsaGQWH1p
         kTI877KDRwtvMjC3hScV2gZhSFFW5oqeh1xp3EUcVcDWdIpchEefcjGYhTEvTR+xdPkU
         q/N6hv5R2k1turPJS5lJ3rPj8tGcvpNi7Pg2YMKltnCjcpzk8O/GwZ2RGaqHVjqW/9y3
         tQxkQLzZkAj7MAGJq7yjhJPnhvs+bg42YTS6oGanXpbB6fm5stXuWtpdRk7lQxUJCk9R
         Elbg==
X-Gm-Message-State: ANoB5pkrWDfqqBPgB73SKMfl6C2ifHNQetz6g2GDnIkpD3Xf1ETsC5Z9
        0Ts9NWTat8TeJcBijtqaQzD2fT+oXjZMESGaPqs=
X-Google-Smtp-Source: AA0mqf6Ot5BbhKa9nqhoWKc7zCkXPZaY9j/Fc/XYicCvofHnkGVqSHdeU+JJZ+8iSuF8Ln3O6mpM2CqNTNOEIE9VQf4=
X-Received: by 2002:a2e:bc0b:0:b0:27b:5a9f:3bf5 with SMTP id
 b11-20020a2ebc0b000000b0027b5a9f3bf5mr1880153ljf.320.1671572928246; Tue, 20
 Dec 2022 13:48:48 -0800 (PST)
MIME-Version: 1.0
References: <20221218234801.579114-1-jmaxwell37@gmail.com> <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
In-Reply-To: <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Wed, 21 Dec 2022 08:48:11 +1100
Message-ID: <CAGHK07ALtLTjRP-XOepqoc8xzWcT8=0v5ccL-98f4+SU9vwfsg@mail.gmail.com>
Subject: Re: [net-next] ipv6: fix routing cache overflow for raw sockets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Tue, Dec 20, 2022 at 11:35 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2022-12-19 at 10:48 +1100, Jon Maxwell wrote:
> > Sending Ipv6 packets in a loop via a raw socket triggers an issue where a
> > route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly
> > consumes the Ipv6 max_size threshold which defaults to 4096 resulting in
> > these warnings:
> >
> > [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> > [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > .
> > .
> > [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
>
> If I read correctly, the maximum number of dst that the raw socket can
> use this way is limited by the number of packets it allows via the
> sndbuf limit, right?
>

Yes, but in my test sndbuf limit is never hit so it clones a route for
every packet.

e.g:

output from C program sending 5000000 packets via a raw socket.

ip raw: total num pkts 5000000

# bpftrace -e 'kprobe:dst_alloc {@count[comm] = count()}'
Attaching 1 probe...

@count[a.out]: 5000009

> Are other FLOWI_FLAG_KNOWN_NH users affected, too? e.g. nf_dup_ipv6,
> ipvs, seg6?
>

Any call to ip6_pol_route(s) where no res.nh->fib_nh_gw_family is 0 can do it.
But we have only seen this for raw sockets so far.

Regards

Jon

> @DavidA: why do we need to create RTF_CACHE clones for KNOWN_NH flows?
>
> Thanks,
>
> Paolo
>
