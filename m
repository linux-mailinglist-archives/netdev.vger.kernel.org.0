Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670CD4A007F
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 19:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344153AbiA1SzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 13:55:19 -0500
Received: from air.basealt.ru ([194.107.17.39]:37180 "EHLO air.basealt.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350727AbiA1SzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 13:55:18 -0500
Received: by air.basealt.ru (Postfix, from userid 490)
        id EE5E158958B; Fri, 28 Jan 2022 18:55:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on
        sa.local.altlinux.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.1
Received: from localhost (unknown [193.43.9.4])
        by air.basealt.ru (Postfix) with ESMTPSA id C572C589436;
        Fri, 28 Jan 2022 18:55:13 +0000 (UTC)
Date:   Fri, 28 Jan 2022 22:55:09 +0400
From:   Alexey Sheplyakov <asheplyakov@basealt.ru>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Evgeny Sinelnikov <sin@basealt.ru>
Subject: Re: [PATCH 1/2] net: stmmac: added Baikal-T1/M SoCs glue layer
Message-ID: <YfQ8De5OMLDLKF6g@asheplyakov-rocket>
References: <20220126084456.1122873-1-asheplyakov@basealt.ru>
 <20220128150642.qidckst5mzkpuyr3@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128150642.qidckst5mzkpuyr3@mobilestation>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Serge,

On Fri, Jan 28, 2022 at 06:06:42PM +0300, Serge Semin wrote:
> Hello Alexey and network folks
> 
> First of all thanks for sharing this patchset with the community. The
> changes indeed provide a limited support for the DW GMAC embedded into
> the Baikal-T1/M1 SoCs. But the problem is that they don't cover all
> the IP-blocks/Platform-setup peculiarities

In general quite a number of Linux drivers (GPUs, WiFi chips, foreign
filesystems, you name it) provide a limited support for the corresponding
hardware (filesystem, protocol, etc) and don't cover all peculiarities.
Yet having such a limited support in the mainline kernel is much more
useful than no support at all (or having to use out-of-tree drivers,
obosolete vendor kernels, binary blobs, etc).

Therefore "does not cover all peculiarities" does not sound like a valid
reason for rejecting this driver. That said it's definitely up to stmmac
maintainers to decide if the code meets the quality standards, does not
cause excessive maintanence burden, etc.

> (believe me there are more
> than just 2*Tx-clock and embedded GPIO features), moreover giving a
> false impression of a full and stable Baikal-T1/M1 GMAC interface
> support.

Such an impression is not intended. Perhaps the commit message should
be improved. What about this:

8<---

net: stmmac: initial support of Baikal-T1/M SoCs GMAC

The gigabit Ethernet controller available in Baikal-T1 and Baikal-M
SoCs is a Synopsys DesignWare MAC IP core, already supported by
the stmmac driver.

This patch implements some SoC specific operations (DMA reset and
speed fixup) necessary (but in general not enough) for Baikal-T1/M
variants.

Note that this driver does NOT cover all the IP-blocks/Platform-setup
peculiarities. It's known to work just fine on some Baikal-T1 boards
(including BFK3.1 reference board) and some Baikal-M based boards
(TF307 revision D, LGP-16), however it might or might not work with
other boards.

8<---

> There are good reasons why we haven't submitted the GMAC/xGBE
> drivers so far. I've been working on the STMMAC code refactoring for
> more than six months now so the driver would be better structured and
> would support all of the required features including the DW XGMAC
> interface embedded into the SoCs. So please don't rush with this
> patchset including into the kernel. We are going to submit a more
> comprehensive and thoroughly structured series of patchsets including
> a bunch of STMMAC driver Fixes very soon. After that everyone will be
> happy ;)

Don't get me wrong, but I've heard the very same thing back in 2020.
It's 2022 now. So I decided it's time to mainline this primitive driver
(which is definitely far from perfect) so people can use the mainline
kernel on (some of) their Baikal-M/T1 based boards.

And this simple driver can be easily removed/replaced if/when a more
advanced version is ready.

> Also, Alexey, next time you submit something Baikal-related could you
> please Cc someone from our team?

Sure. Hopefully I'll get some useful feedback (that is, other than
"don't bother, use the kernel from SDK", or "we are working on it,
please wait").

> (I am sure you know Alexey' email or
> have seen my patches in the mailing lists.) Dmitry Dunaev hasn't been
> working for Baikal Electronics for more than four years now so his
> email address is disabled (you must have already noticed that by
> getting a bounce back email). Moreover you can't add someone'
> signed-off tag without getting a permission from one.

Yep. Hence the question: what is the proper way to mention that the code
I post is based on work of other people (if those people ignore my emails,
or or their addresses are not valid any more, etc)?

Best regards,
	Alexey

