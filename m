Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10E32D1E86
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 00:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgLGXlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 18:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbgLGXlY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 18:41:24 -0500
Date:   Mon, 7 Dec 2020 15:40:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607384443;
        bh=MISPg/Jja4FNH7Qbb6RR2iNAaPDukmQaJ36QvPVNwtE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Asn7UCrMXuseTyPahOVPhpqTsVBWBRYaL0rHLUihG3/qcb3HgmkvRJp56XYQ1cbA/
         hzuQJ0S8uNiwH3WwvTyOeeQWULaamUjT/C8FXihfiVtiHxkjRkVfKqjl3fujuL0y9I
         XCp23xc7FXlY8Z8jJnreHJYA2SiVhB25ALfuCgNuErhqPNA3T7VAHYa67eEpNlo1o+
         khCsrpaB1nI1utQJtLuc4JcU3LpqwPxmw1YT1Ks0UKx53Ym6oE3BawvO2o4xxh/hbn
         8RDvLLLSqUcmiCcFExKEZpANDz4Obh+Wzi155Xi68N0+toUBfUMq+nQ78hYlYMMVyg
         /NKrX3Yoefd6Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Daniel Palmer <daniel@0x0f.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: macb: should we revert 0a4e9ce17ba7 ("macb: support the two tx
 descriptors on at91rm9200") ?
Message-ID: <20201207154042.46414640@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201206092041.GA10646@1wt.eu>
References: <20201206092041.GA10646@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Dec 2020 10:20:41 +0100 Willy Tarreau wrote:
> Hi Jakub,
> 
> Two months ago I implemented a small change in the macb driver to
> support the two Tx descriptors that AT91RM9200 supports. I implemented
> this using the only compatible device I had which is the MSC313E-based
> Breadbee board. Since then I've met situations where the chip would stop
> sending, mostly when doing bidirectional traffic. I've spent a few week-
> ends on this already trying various things including blocking interrupts
> on a larger place, switching to the 32-bit register access on the MSC313E
> (previous code was using two 16-bit accesses and I thought it was the
> cause), and tracing status registers along the various operations. Each
> time the pattern looks similar, a write when the chips declares having
> room results in an overrun, but the preceeding condition doesn't leave
> any info suggesting this may happen.
> 
> Sadly we don't have the datasheet for this SoC, what is visible is that it
> supports AT91RM9200's tx mode and that it works well when there's a single
> descriptor in flight. In this case it complies with AT91RM9200's datasheet.
> The chip reports other undocumented bits in its status registers, that
> cannot even be correlated to the issue by the way. I couldn't spot anything
> wrong there in my changes, even after doing heavy changes to progress on
> debugging, and the SoC's behavior reporting an overrun after a single write
> when there's room contradicts the RM9200's datasheet. In addition we know
> the chip also supports other descriptor-based modes, so it's very possible
> it doesn't perfectly implement the RM9200's 2-desc mode and that my change
> is still fine.
> 
> Yesterday I hope to get my old AT91SAM9G20 board to execute this code and
> test it, but it clearly does not work when I remap the init and tx functions,
> which indicates that it really does not implement a hidden compatibility
> mode with the old chip.
> 
> Thus at this point I have no way to make sure that the original SoC for
> which I changed the code still works fine or if I broke it. As such, I'd
> feel more comfortable if we'd revert my patch until someone has the
> opportunity to test it on the original hardware (Alexandre suggested he
> might, but later).
> 
> The commit in question is the following one:
> 
>   0a4e9ce17ba7 ("macb: support the two tx descriptors on at91rm9200")
> 
> If the maintainers prefer that we wait for an issue to be reported before
> reverting it, that's fine for me as well. What's important to me is that
> this potential issue is identified so as not to waste someone else's time
> on it.

Thanks for the report, I remember that one. In hindsight maybe we
should have punted it to 5.11...

Let's revert ASAP, 5.10 is going to be LTS, people will definitely
notice.

Would you mind sending a revert patch with the explanation in the
commit message?
