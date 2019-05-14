Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 891611C2DA
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 08:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfENGMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 02:12:44 -0400
Received: from mail-it1-f179.google.com ([209.85.166.179]:55818 "EHLO
        mail-it1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfENGMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 02:12:44 -0400
Received: by mail-it1-f179.google.com with SMTP id q132so3037544itc.5
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 23:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xnw1iV8ZqN4Kd9CmWcXfMF7LhA77hZc0Y/HrDuqtO9Y=;
        b=s04kzuOFQ610XOtg3ZNx3FTnNBcRUkBvjrpxDqyk8a8unA9cA+CV4sYalQMXhV0KRh
         O8zh/wK8ZB84h7quPNwW4+Z0bkkJEGLChHQ3sxRgeUDFtogHgLeI/doYy5v0M5gj+D0r
         OseFj21+7/ygcKQ/qDdF3qSycpqffG6r1wp6FEwO2bMt4z+ZNdht4E+mYzGOY4/o7cyC
         5yyNrP44I0XQeq88pjAJxSkizr35jdQUsbFCa0H7Xge/twWFIKQp6iDHwBAClkcJdLgV
         Ka4BKbzRk8ADtetuG7n/E6KwyvxhOYeaXKJ4CylgLgAqtEBlh5wbL3f7Pk6/gwcSY9yK
         6drw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xnw1iV8ZqN4Kd9CmWcXfMF7LhA77hZc0Y/HrDuqtO9Y=;
        b=WEjh9vVpNbAPwUR1x5c5awUeHlSjh5vB01Dc2d3SLnW61MPXW7uK82uNg6fSpcdaHH
         I42I91NzDS/0bspPcDA2hjsBnAUufxHCKugbltT4jIbO7ix1Y+i0G0aI4izLGjG5iG/g
         2gFHFGnqUmpmHNv2p40z5aetPaFDNi6CEqZkpMab/itIT4CnlBvlVqibaNEkwv0cIz7j
         wCnmvpyQ2FKe1BqKkw60lxJynHmOnOnR2keD2CBrEYjZ3BOCaMCD1DJdt2K+RS2zBLk/
         6xiTYQDk7Vtldn7XW0V789flNZLg42XHwWMiFECBbeVeLFTaBtPxs7z7I7StZthn0o3y
         TAjA==
X-Gm-Message-State: APjAAAWnz2t0GViJCTJldTGLNaw9qPSK0gTGvir+XlDlOKh2vtoT4aF8
        xrqDHsp98Zu2pMP7M1fpBr3kzNVpjLmHOMm8odhjlw==
X-Google-Smtp-Source: APXvYqxfOnghVOewngiLIbaRTq+LI5LJprMzP3uxEErVpeqx1g4JEi0xm2OMGI+V9vpfbdS+huWR52tpzHdoLFH1GIw=
X-Received: by 2002:a24:eb09:: with SMTP id h9mr2471279itj.14.1557814362770;
 Mon, 13 May 2019 23:12:42 -0700 (PDT)
MIME-Version: 1.0
References: <71e7331f-d528-430e-f880-e995ff53d362@lists.m7n.se> <2667a075-7a51-d1e0-c4e7-cf0d011784b9@gmail.com>
In-Reply-To: <2667a075-7a51-d1e0-c4e7-cf0d011784b9@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 13 May 2019 23:12:31 -0700
Message-ID: <CAEA6p_AddQqy+v+LUT6gsqOC31RhMkVnZPLja8a4n9XQmK8TRA@mail.gmail.com>
Subject: Re: IPv6 PMTU discovery fails with source-specific routing
To:     David Ahern <dsahern@gmail.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Mikael for reporting this issue. And thanks David for the bisection.
Let me spend some time to reproduce it and see what is going on.

From: David Ahern <dsahern@gmail.com>
Date: Mon, May 13, 2019 at 8:35 PM
To: Mikael Magnusson, <netdev@vger.kernel.org>, Martin KaFai Lau, Wei Wang

> On 5/13/19 1:22 PM, Mikael Magnusson wrote:
> > Hello list,
> >
> > I think I have found a regression in 4.15+ kernels. IPv6 PMTU discovery
> > doesn't seem to work with source-specific routing (AKA source-address
> > dependent routing, SADR).
> >
> > I made a test script (see attachment). It sets up a test environment
> > with three network namespaces (a, b and c) using SADR. The link between
> > b and c is configured with MTU 1280. It then runs a ping test with large
> > packets.
> >
> > I have tested a couple of kernels on Ubuntu 19.04 with the following
> > results.
> >
> > mainline 4.14.117-0414117-generic SUCCESS
> > ubuntu   4.15.0-1036-oem          FAIL
> > mainline 5.1.0-050100-generic     FAIL
> >
>
> git bisect shows
>
> good: 38fbeeeeccdb38d0635398e8e344d245f6d8dc52
> bad:  2b760fcf5cfb34e8610df56d83745b2b74ae1379
>
> Those are back to back commits so
>     2b760fcf5cfb ipv6: hook up exception table to store dst cache
>
> has to be the bad commit.
>
> Your patch may work, but does not seem logical relative to code at the
> time of 4.15 and the commit that caused the failure. cc'ing authors of
> the changes referenced above.
