Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90738652899
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 22:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbiLTV4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 16:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLTV4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 16:56:19 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A9A55B7;
        Tue, 20 Dec 2022 13:56:17 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id s10so13846478ljg.1;
        Tue, 20 Dec 2022 13:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v0xVs/r9KWaI+ewlIk57xR0sY/mryuT2CUKGEK/zybc=;
        b=UgsSvrjkg1vmOJud+d+53iHDjq9wvEGJqeZ9dSB2Nmwkblq9cOls1V6fBtgMuQfbHw
         6LabYPGSx7VgdkAWV0vEVavTv/BPSgOiIzLLWQeeK92iT0CdsCbPIwmVisxfFmL8GFqz
         4CX6Vdy89mVosIUGg/rbImiX/qHGe9ZcLL4sHL7auiAn/QOWubiamAOk44/VMolsFohJ
         aLreqH84tzZPnBmRAH297yt/2mMbdvNTMBAYiUK+mYSy0hs+qy9SgFIVtwWo2qbCioWA
         tAEaqKVmhdlNiVWmkVRtpQU3elvWxDKbyCDDeLe6oIQQLphRCCbdshBlV49oQQ07Wlxh
         tBqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v0xVs/r9KWaI+ewlIk57xR0sY/mryuT2CUKGEK/zybc=;
        b=q68hwAmAApKP/tN5r9YTUZxNwj29jDlIDY2KnXS4QCYK0GbnnVBwAfSyTrUeeFZ2Yd
         c5CnuT5c0Hm7yERoB6sX50eTy/iWMsCPrW4mfUxnWf2KDiyI3edGr07qeqEtRSW2F5/e
         MFbPp43BNJn3M303qKIiX3CbyeqGTFeFA48nJXO48HCTwb4zxOJDQ297kJTp+WWRk0af
         6RTexpWspYtvyUFRmORmVP06e6BydftCMi2MzOVfWyUQc/8xSKNVN71V3w9oBxfyZE1O
         s7P9/1/p3ZLPUDRr4lE2sd7nXxyTl3dW9JMuvfZpP/IyJ+2eWqDuMnjMNOMyaQWzYjEz
         grDA==
X-Gm-Message-State: ANoB5pnZsu86NRpDSIHioXsp9eKHu66N2zvzr3NC78M0LnxoUc889oII
        Ld3glLOIK0TGs8Vg3YCR1D5Egc0DJasylHhiQSs=
X-Google-Smtp-Source: AA0mqf4DncHCQDKCEo309O54Ct80+H7FJboCTHk/bcC16HfN5NgjgSfXuwDIxQtRq2JO+UlvUSLuSQzdotxjRNcyRsY=
X-Received: by 2002:a2e:bc0e:0:b0:27a:945:2192 with SMTP id
 b14-20020a2ebc0e000000b0027a09452192mr6959279ljf.398.1671573375586; Tue, 20
 Dec 2022 13:56:15 -0800 (PST)
MIME-Version: 1.0
References: <20221218234801.579114-1-jmaxwell37@gmail.com> <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
 <bf56c3aa-85df-734d-f419-835a35e66e03@kernel.org>
In-Reply-To: <bf56c3aa-85df-734d-f419-835a35e66e03@kernel.org>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Wed, 21 Dec 2022 08:55:38 +1100
Message-ID: <CAGHK07BehyHXoS+27=cfZoKz4XNTcJjyB5us33sNS7P+_fudHQ@mail.gmail.com>
Subject: Re: [net-next] ipv6: fix routing cache overflow for raw sockets
To:     David Ahern <dsahern@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
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

On Wed, Dec 21, 2022 at 2:10 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 12/20/22 5:35 AM, Paolo Abeni wrote:
> > On Mon, 2022-12-19 at 10:48 +1100, Jon Maxwell wrote:
> >> Sending Ipv6 packets in a loop via a raw socket triggers an issue where a
> >> route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly
> >> consumes the Ipv6 max_size threshold which defaults to 4096 resulting in
> >> these warnings:
> >>
> >> [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> >> [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> >> .
> >> .
> >> [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> >
> > If I read correctly, the maximum number of dst that the raw socket can
> > use this way is limited by the number of packets it allows via the
> > sndbuf limit, right?
> >
> > Are other FLOWI_FLAG_KNOWN_NH users affected, too? e.g. nf_dup_ipv6,
> > ipvs, seg6?
> >
> > @DavidA: why do we need to create RTF_CACHE clones for KNOWN_NH flows?
> >
> > Thanks,
> >
> > Paolo
> >
>
> If I recall the details correctly: that sysctl limit was added back when
> ipv6 routes were managed as dst_entries and there was a desire to allow
> an admin to limit the memory consumed. At this point in time, IPv6 is
> more inline with IPv4 - a separate struct for fib entries from dst
> entries. That "Route cache is full" message is now out of date since
> this is dst_entries which have a gc mechanism.
>
> IPv4 does not limit the number of dst_entries that can be allocated
> (ip_rt_max_size is the sysctl variable behind the ipv4 version of
> max_size and it is a no-op). IPv6 can probably do the same here?
>

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index dbc224023977..701aba7feaf5 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6470,7 +6470,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 #endif

        net->ipv6.sysctl.flush_delay = 0;
-       net->ipv6.sysctl.ip6_rt_max_size = 4096;
+       net->ipv6.sysctl.ip6_rt_max_size = INT_MAX;
        net->ipv6.sysctl.ip6_rt_gc_min_interval = HZ / 2;
        net->ipv6.sysctl.ip6_rt_gc_timeout = 60*HZ;
        net->ipv6.sysctl.ip6_rt_gc_interval = 30*HZ;

The above patch resolved it for the Ipv6 reproducer.

Would that be sufficient?

> I do not believe the suggested flag is the right change.

Regards

Jon
