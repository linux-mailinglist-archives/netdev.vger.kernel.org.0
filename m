Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C983356739
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 10:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345644AbhDGIwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 04:52:53 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:51482 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349746AbhDGItz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 04:49:55 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 1378g7RX022960;
        Wed, 7 Apr 2021 10:42:07 +0200
Date:   Wed, 7 Apr 2021 10:42:07 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Daniel Palmer <daniel@0x0f.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH] Revert "macb: support the two tx descriptors on
 at91rm9200"
Message-ID: <20210407084207.GD22418@1wt.eu>
References: <20201209184740.16473-1-w@1wt.eu>
 <CAFr9PX=Ky2QuXNH09DmegFV=e-4+ChdypSsJfV8svqxP7U-cpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFr9PX=Ky2QuXNH09DmegFV=e-4+ChdypSsJfV8svqxP7U-cpg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Tue, Apr 06, 2021 at 07:04:58PM +0900, Daniel Palmer wrote:
> Hi Willy,
> 
> I've been messing with the SSD202D (sibling of the MSC313E) recently
> and the ethernet performance was awful.
> I remembered this revert and reverted it and it makes the ethernet
> work pretty well.

OK, that's reassuring, at least they use the same IP blocks.

> [   15.213358] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   15.245235] pre0 41001fb8, post0 30001fb0 -> IDLETSR clear
> [   15.249291] pre1 30001f90, post1 20001d90 -> FIFOIDLE1 clear
> [   15.253331] pre2 20001d90, post2 10001990 -> FIFOIDLE2 clear
> [   15.257385] pre3 10001990, post3 00001190 -> FIFOIDLE3 clear
> [   15.261435] pre4 00001190, post4 f0000191 -> FIFOIDLE4 clear, OVR set
> [   15.265485] pre5 f0000190, post5 f0000191 -> OVR set
> [   15.269535] pre6 f0000190, post6 e0000181 -> OVR set, BNQ clear
> 
> There seems to be a FIFO empty counter in the top of the register but
> this is totally undocumented.

Yes that's extremely visible. I did notice some apparently random
values at the top of the register as well without being able to
determine what they were for, because I was pretty much convinced I
was facing a 2-deep queue only. You had a good idea to force it to
duplicate packets :-)

> There are two new status bits TBNQ and FBNQ at bits 7 and 8. I have no
> idea what they mean.

Maybe they're related to tx queue empty / tx queue full. Just guessing.
Since all these bits tend not to be reset until written to, I got confused
a few times trying to understand what they indicated.

> Bits 9 through 12 are some new status bits that seem to show if a FIFO
> slot is inuse.

Maybe indeed.

> I can't find any mention of these bits anywhere except the header of
> the vendor driver so I think these are specific to MStar's macb.
> The interesting part though is that BNQ does not get cleared until
> multiple frames have been pushed in and after OVR is set.
> I think this is what breaks your code when it runs on the MSC313E
> version of MACB.

Yes that's very possible, because the behavior was inconsistent with
what was documented for older chips. Also BNQ changed its meaning on
more recent chips, so it may very well have yet another one here.

> Anyhow. I'm working on a version of your patch that should work with
> both the at91rm9200 and the MSC313E.

Cool! Thanks for letting me know. If you need me to run some test, let
me know (just don't expect too short latency these days but I definitely
will test).

Cheers,
Willy
