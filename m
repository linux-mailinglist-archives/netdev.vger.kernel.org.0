Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119762D023D
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 10:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgLFJWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 04:22:23 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:48271 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgLFJWU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 04:22:20 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 0B69KfmJ010721;
        Sun, 6 Dec 2020 10:20:41 +0100
Date:   Sun, 6 Dec 2020 10:20:41 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Daniel Palmer <daniel@0x0f.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: macb: should we revert 0a4e9ce17ba7 ("macb: support the two tx
 descriptors on at91rm9200") ?
Message-ID: <20201206092041.GA10646@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.6.1 (2016-04-27)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Two months ago I implemented a small change in the macb driver to
support the two Tx descriptors that AT91RM9200 supports. I implemented
this using the only compatible device I had which is the MSC313E-based
Breadbee board. Since then I've met situations where the chip would stop
sending, mostly when doing bidirectional traffic. I've spent a few week-
ends on this already trying various things including blocking interrupts
on a larger place, switching to the 32-bit register access on the MSC313E
(previous code was using two 16-bit accesses and I thought it was the
cause), and tracing status registers along the various operations. Each
time the pattern looks similar, a write when the chips declares having
room results in an overrun, but the preceeding condition doesn't leave
any info suggesting this may happen.

Sadly we don't have the datasheet for this SoC, what is visible is that it
supports AT91RM9200's tx mode and that it works well when there's a single
descriptor in flight. In this case it complies with AT91RM9200's datasheet.
The chip reports other undocumented bits in its status registers, that
cannot even be correlated to the issue by the way. I couldn't spot anything
wrong there in my changes, even after doing heavy changes to progress on
debugging, and the SoC's behavior reporting an overrun after a single write
when there's room contradicts the RM9200's datasheet. In addition we know
the chip also supports other descriptor-based modes, so it's very possible
it doesn't perfectly implement the RM9200's 2-desc mode and that my change
is still fine.

Yesterday I hope to get my old AT91SAM9G20 board to execute this code and
test it, but it clearly does not work when I remap the init and tx functions,
which indicates that it really does not implement a hidden compatibility
mode with the old chip.

Thus at this point I have no way to make sure that the original SoC for
which I changed the code still works fine or if I broke it. As such, I'd
feel more comfortable if we'd revert my patch until someone has the
opportunity to test it on the original hardware (Alexandre suggested he
might, but later).

The commit in question is the following one:

  0a4e9ce17ba7 ("macb: support the two tx descriptors on at91rm9200")

If the maintainers prefer that we wait for an issue to be reported before
reverting it, that's fine for me as well. What's important to me is that
this potential issue is identified so as not to waste someone else's time
on it.

Thanks!
Willy
