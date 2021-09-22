Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791E7414BDA
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 16:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbhIVO27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 10:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232401AbhIVO27 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 10:28:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFC7C6115A;
        Wed, 22 Sep 2021 14:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632320849;
        bh=MI1Hxxt1PKNl805MXTEJBDy5ctnXY0oGXIIdLmke1Cs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PUrIy4Wn0Ga/a+KMqN6Ulc89rup5WGb4IwIRSHGtCYjkvK+fuBPTz+4hGYfzg42Vq
         HK7rfR27HCcqjpuULHFSSQsQ8KkVxFP5pBhcoEODA58CzuiwMpIaeD2jSXX//6ByDy
         Ms+8cSvSwapGlP1E018F8RMrWI4/53rd94KP0RWz1TrBp5ABcyemgnAcTmDK+4s5lm
         LbsLNemGh5LrNdDNyRosvhfDXTBUaPA9HHxuueNx2oNS3qNAYkzcYyg+tRFMIvUhRo
         KZ7vRqTFq4SaReIxWKE5eyRRK3vOlc2eSN2oJT52NbMh6K96SF9lF+8O0vOgDs22UU
         s/fhr6dgKgLww==
Received: by pali.im (Postfix)
        id 75D7179F; Wed, 22 Sep 2021 16:27:26 +0200 (CEST)
Date:   Wed, 22 Sep 2021 16:27:26 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Jonas =?utf-8?B?RHJlw59sZXIn?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] mwifiex: Use non-posted PCI write when setting TX
 ring write pointer
Message-ID: <20210922142726.guviqler5k7wnm52@pali>
References: <20210914114813.15404-1-verdre@v0yd.nl>
 <20210914114813.15404-2-verdre@v0yd.nl>
 <8f65f41a807c46d496bf1b45816077e4@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f65f41a807c46d496bf1b45816077e4@AcuMS.aculab.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 22 September 2021 14:03:25 David Laight wrote:
> From: Jonas Dreßler
> > Sent: 14 September 2021 12:48
> > 
> > On the 88W8897 card it's very important the TX ring write pointer is
> > updated correctly to its new value before setting the TX ready
> > interrupt, otherwise the firmware appears to crash (probably because
> > it's trying to DMA-read from the wrong place). The issue is present in
> > the latest firmware version 15.68.19.p21 of the pcie+usb card.
> > 
> > Since PCI uses "posted writes" when writing to a register, it's not
> > guaranteed that a write will happen immediately. That means the pointer
> > might be outdated when setting the TX ready interrupt, leading to
> > firmware crashes especially when ASPM L1 and L1 substates are enabled
> > (because of the higher link latency, the write will probably take
> > longer).
> > 
> > So fix those firmware crashes by always using a non-posted write for
> > this specific register write. We do that by simply reading back the
> > register after writing it, just as a few other PCI drivers do.
> > 
> > This fixes a bug where during rx/tx traffic and with ASPM L1 substates
> > enabled (the enabled substates are platform dependent), the firmware
> > crashes and eventually a command timeout appears in the logs.
> 
> I think you need to change your terminology.
> PCIe does have some non-posted write transactions - but I can't
> remember when they are used.

In PCIe are all memory write requests as posted.

Non-posted writes in PCIe are used only for IO and config requests. But
this is not case for proposed patch change as it access only card's
memory space.

Technically this patch does not use non-posted memory write (as PCIe
does not support / provide it), just adds something like a barrier and
I'm not sure if it is really correct (you already wrote more details
about it, so I will let it be).

I'm not sure what is the correct terminology, I do not know how this
kind of write-followed-by-read "trick" is correctly called.
