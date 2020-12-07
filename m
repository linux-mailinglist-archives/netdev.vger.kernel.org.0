Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A4C2D1E95
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 00:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgLGXww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 18:52:52 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:57813 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbgLGXwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 18:52:51 -0500
Received: from localhost (lfbn-lyo-1-997-19.w86-194.abo.wanadoo.fr [86.194.74.19])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 70888200009;
        Mon,  7 Dec 2020 23:52:08 +0000 (UTC)
Date:   Tue, 8 Dec 2020 00:52:08 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Willy Tarreau <w@1wt.eu>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Daniel Palmer <daniel@0x0f.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: macb: should we revert 0a4e9ce17ba7 ("macb: support the two tx
 descriptors on at91rm9200") ?
Message-ID: <20201207235208.GI431442@piout.net>
References: <20201206092041.GA10646@1wt.eu>
 <20201207154042.46414640@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207154042.46414640@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 07/12/2020 15:40:42-0800, Jakub Kicinski wrote:
> On Sun, 6 Dec 2020 10:20:41 +0100 Willy Tarreau wrote:
> > Hi Jakub,
> > 
> > Two months ago I implemented a small change in the macb driver to
> > support the two Tx descriptors that AT91RM9200 supports. I implemented
> > this using the only compatible device I had which is the MSC313E-based
> > Breadbee board. Since then I've met situations where the chip would stop
> > sending, mostly when doing bidirectional traffic. I've spent a few week-
> > ends on this already trying various things including blocking interrupts
> > on a larger place, switching to the 32-bit register access on the MSC313E
> > (previous code was using two 16-bit accesses and I thought it was the
> > cause), and tracing status registers along the various operations. Each
> > time the pattern looks similar, a write when the chips declares having
> > room results in an overrun, but the preceeding condition doesn't leave
> > any info suggesting this may happen.
> > 
> > Sadly we don't have the datasheet for this SoC, what is visible is that it
> > supports AT91RM9200's tx mode and that it works well when there's a single
> > descriptor in flight. In this case it complies with AT91RM9200's datasheet.
> > The chip reports other undocumented bits in its status registers, that
> > cannot even be correlated to the issue by the way. I couldn't spot anything
> > wrong there in my changes, even after doing heavy changes to progress on
> > debugging, and the SoC's behavior reporting an overrun after a single write
> > when there's room contradicts the RM9200's datasheet. In addition we know
> > the chip also supports other descriptor-based modes, so it's very possible
> > it doesn't perfectly implement the RM9200's 2-desc mode and that my change
> > is still fine.
> > 
> > Yesterday I hope to get my old AT91SAM9G20 board to execute this code and
> > test it, but it clearly does not work when I remap the init and tx functions,
> > which indicates that it really does not implement a hidden compatibility
> > mode with the old chip.
> > 
> > Thus at this point I have no way to make sure that the original SoC for
> > which I changed the code still works fine or if I broke it. As such, I'd
> > feel more comfortable if we'd revert my patch until someone has the
> > opportunity to test it on the original hardware (Alexandre suggested he
> > might, but later).
> > 
> > The commit in question is the following one:
> > 
> >   0a4e9ce17ba7 ("macb: support the two tx descriptors on at91rm9200")
> > 
> > If the maintainers prefer that we wait for an issue to be reported before
> > reverting it, that's fine for me as well. What's important to me is that
> > this potential issue is identified so as not to waste someone else's time
> > on it.
> 
> Thanks for the report, I remember that one. In hindsight maybe we
> should have punted it to 5.11...
> 
> Let's revert ASAP, 5.10 is going to be LTS, people will definitely
> notice.
> 
> Would you mind sending a revert patch with the explanation in the
> commit message?

FWIW, I went to the office and brought back my rm9200 today. I didn't
have the time to set up a test yet though. I'm not sure it will even
boot v5.10 so don't bet anyone apart me would notice Ethernet being
broken on this SoC.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
