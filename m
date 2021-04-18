Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4BC363390
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 06:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhDREka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 00:40:30 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:51849 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229671AbhDREka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 00:40:30 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 13I4dXL6019049;
        Sun, 18 Apr 2021 06:39:33 +0200
Date:   Sun, 18 Apr 2021 06:39:33 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Matt Corallo <netdev-list@mattcorallo.com>
Cc:     Keyu Man <kman001@ucr.edu>, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>
Subject: Re: PROBLEM: DoS Attack on Fragment Cache
Message-ID: <20210418043933.GB18896@1wt.eu>
References: <02917697-4CE2-4BBE-BF47-31F58BC89025@hxcore.ol>
 <52098fa9-2feb-08ae-c24f-1e696076c3b9@gmail.com>
 <CANn89iL_V0WbeA-Zr29cLSp9pCsthkX9ze4W46gx=8-UeK2qMg@mail.gmail.com>
 <20210417072744.GB14109@1wt.eu>
 <CAMqUL6bkp2Dy3AMFZeNLjE1f-sAwnuBWpXH_FSYTSh8=Ac3RKg@mail.gmail.com>
 <20210417075030.GA14265@1wt.eu>
 <c6467c1c-54f5-8681-6e7d-aa1d9fc2ff32@bluematt.me>
 <CAMqUL6bAVE9p=XEnH4HdBmBfThaY3FDosqyr8yrQo6N_9+Jf3w@mail.gmail.com>
 <78d776a9-4299-ff4e-8ca2-096ec5c02d05@bluematt.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78d776a9-4299-ff4e-8ca2-096ec5c02d05@bluematt.me>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 10:26:30PM -0400, Matt Corallo wrote:
> Sure, there are better ways to handle the reassembly cache overflowing, but
> that is pretty unrelated to the fact that waiting 30 full seconds for a
> fragment to come in doesn't really make sense in today's networks (the 30
> second delay that is used today appears to even be higher than RFC 791
> suggested in 1981!).

Not exactly actually, because you forget the TTL here. With most hosts
sending an initial TTL around 64, after crossing 10-15 hops it's still
around 50 so that would result in ~50 seconds by default, even according
to the 40 years old RFC791. The 15s there was the absolute minimum. While
I do agree that we shouldn't keep them that long nowadays, we can't go
too low without risking to break some slow transmission stacks (SLIP/PPP
over modems for example). In addition even cutting that in 3 will remain
trivially DoSable.

> You get a lot more bang for your buck if you don't wait
> around so long (or we could restructure things to kick out the oldest
> fragments, but that is a lot more work, and probably extra indexes that just
> aren't worth it).

Kicking out oldest ones is a bad approach in a system made only of
independent elements, because it tends to result in a lot of damage once
all of them behave similarly. I.e. if you need to kick out an old entry
in valid traffic, it's because you do need to wait that long, and if all
datagrams need to wait that long, then new datagrams systematically
prevent the oldest one from being reassembled, and none gest reassembled.
With a random approach at least your success ratio converges towards 1/e
(i.e. 36%) which is better.

Willy
