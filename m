Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD693F9F6E
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 21:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhH0TD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 15:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230365AbhH0TD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 15:03:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAAAC60F25;
        Fri, 27 Aug 2021 19:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630090957;
        bh=NzSwgKgn3cMFs00vJFkDHQ4CGur+xCzPrHqpLXwNq4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XaduGQD9sUqmYwfR9FRRI5gYz2UeMk7rlL/66/M2L09pd1RjBvvFuOoftfkX2awGS
         UW9JYvEo4s7cvNfDoxTEUok7iBPpUu2tGGZL/qDwmkESXc+1WP9ftdjf6IRdPx5d9r
         0bWQIgm5l3m+eaMiji+qgk6eCdYZU3PuKXkC+zwPbzSvHmJOsYFa0z6WT93MnCh3a2
         VllCKm9W3471ibsSB00fb7wExZ9UIWTtbZ8TUlOr3oyA6L2HD8fkXLKbc+8l7fdW/g
         IrCpVDUCDW4de9oxj4BO7cZw5NnJdIDkOloDTmofJKJbNJ6drE3IYXQQwKdDQA9JX9
         k/Uqp9bA18uKQ==
Received: by pali.im (Postfix)
        id 63999617; Fri, 27 Aug 2021 21:02:34 +0200 (CEST)
Date:   Fri, 27 Aug 2021 21:02:34 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh@kernel.org>, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] phy: marvell: phy-mvebu-a3700-comphy: Remove
 unsupported modes
Message-ID: <20210827190234.72eakdvbgojscpkm@pali>
References: <20210827092753.2359-1-pali@kernel.org>
 <20210827092753.2359-3-pali@kernel.org>
 <20210827132713.61ef86f0@thinkpad>
 <20210827182502.vdapjcqimq4ulkg2@pali>
 <20210827183355.GV22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210827183355.GV22278@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 27 August 2021 19:33:55 Russell King (Oracle) wrote:
> On Fri, Aug 27, 2021 at 08:25:02PM +0200, Pali Rohár wrote:
> > cp110-comphy and a3700-comphy are just RPC drivers which calls SMC and
> > relay on firmware support which implements real work. And both uses same
> > RPC / SMC API. So merging drivers into one is possible.
> > 
> > But I do not think that it is a good idea that Linux kernel depends on
> > some external firmware which implements RPC API for configuring HW.
> > 
> > Rather kernel should implements its native drivers without dependency on
> > external firmware.
> > 
> > We know from history that kernel tried to avoid using x86 BIOS/firmware
> > due to bugs and all functionality (re)-implemented itself without using
> > firmware RPC functionality.
> 
> Not really an argument in this case. We're not talking about closed
> source firmware.
> 
> > Kernel has already "hacks" in other drivers which are using these comphy
> > drivers, just because older versions of firmware do not support all
> > necessary functionality and upgrading this firmware is not easy step
> > (and sometimes even not possible; e.g. when is cryptographically
> > signed).
> 
> The kernel used to (and probably still does) contain code to configure
> the comphys.

Kernel does not have code for A3700. Hence reason why there are hacks in
other drivers, like libata/ahci or usb/xhci.

> Having worked on trying to get the 10G lanes stable on
> Macchiatobin, I much prefer the existing solution where it's in the
> ATF firmware. I've rebuilt the firmware several times during the course
> of that.

In some cases rebuilt of firmware does not have to be possible (e.g.
when it it signed).

> The advantage is that fixing the setup of the COMPHY is done in one
> place, and it fixes it not only for the kernel, but also for u-boot

U-Boot for A3720 has its own implementation and does not use firmware
implementation (yet). So currently the only consumer of firmware
implementation is just Linux kernel.

> and UEFI too. So rather than having to maintain three different
> places for a particular board, we can maintain the parameters in one
> place - in the ATF firmware.

Same argument can be used for any other driver which is implemented in
both bootloader and kernel... But I understand also your argument.

> The problem with the past has been that stuff gets accepted into the
> kernel without the "full system" view and without regard for "should
> this actually be done in the firmware". Then, when it's decided that
> it really should be done in the firmware, we end up needing to keep
> the old stuff in the kernel for compatibility with older firmware,
> which incidentally may not be up to date.
> 
> If we were to drop the comphy setup from firmware, then we will need
> a lot of additional properties in the kernel's DT and u-boot DT for
> the comphy to configure it appropriately. And ACPI. I don't think
> that scales very well, and is a recipe for things getting out of
> step.

I think that whatever is used (firmware code, kernel code, ...), DT
should always contains full HW description with all nodes, and not only
some "subset". DT should be independent of current driver / firmware
implementation.
