Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DAC1D6666
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 09:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgEQHOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 03:14:02 -0400
Received: from bmailout3.hostsharing.net ([176.9.242.62]:45335 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbgEQHOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 03:14:01 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 7DFB9100A5F14;
        Sun, 17 May 2020 09:13:56 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id CB1AC1C100; Sun, 17 May 2020 09:13:55 +0200 (CEST)
Date:   Sun, 17 May 2020 09:13:55 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     David Miller <davem@davemloft.net>
Cc:     marex@denx.de, netdev@vger.kernel.org, ynezz@true.cz,
        yuehaibing@huawei.com
Subject: Re: [PATCH V6 00/20] net: ks8851: Unify KS8851 SPI and MLL drivers
Message-ID: <20200517071355.ww5xh7fgq7ymztac@wunner.de>
References: <20200517003354.233373-1-marex@denx.de>
 <20200516.190225.342589110126932388.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516.190225.342589110126932388.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 07:02:25PM -0700, David Miller wrote:
> > The KS8851SNL/SNLI and KS8851-16MLL/MLLI/MLLU are very much the same pieces
> > of silicon, except the former has an SPI interface, while the later has a
> > parallel bus interface. Thus far, Linux has two separate drivers for each
> > and they are diverging considerably.
> > 
> > This series unifies them into a single driver with small SPI and parallel
> > bus specific parts. The approach here is to first separate out the SPI
> > specific parts into a separate file, then add parallel bus accessors in
> > another separate file and then finally remove the old parallel bus driver.
> > The reason for replacing the old parallel bus driver is because the SPI
> > bus driver is much higher quality.
> 
> What strikes me in these changes is all of the new indirect jumps in
> the fast paths of TX and RX packet processing.  It's just too much for
> my eyes. :-)
> 
> Especially in the presence of Spectre mitigations, these costs are
> quite non-trivial.
> 
> Seriously, I would recommend that instead of having these small
> indirect helpers, just inline the differences into two instances of
> the RX interrupt and the TX handler.

I agree.

However in terms of performance there's a bigger problem:

Previously ks8851.c (SPI driver) had 8-bit and 32-bit register accessors.
The present series drops them and performs a 32-bit access as two 16-bit
accesses and an 8-bit access as one 16-bit access because that's what
ks8851_mll.c (16-bit parallel bus driver) does.  That has a real,
measurable performance impact because in the case of 8-bit accesses,
another 8 bits need to be transferred over the SPI bus, and in the case
of 32-bit accesses, *two* SPI transfers need to be performed.

The 8-bit and 32-bit accesses happen in ks8851_rx_pkts(), i.e. in the
RX hotpath.  I've provided numbers for the performance impact and even
a patch to solve them but it was dismissed and not included in the
present series:

https://lore.kernel.org/netdev/20200420140700.6632hztejwcgjwsf@wunner.de/

The reason given for the dismissal was that I had performed the measurements
on 4.19 which is allegedly "long dead" (in Andrew Lunn's words).
However I can assure you that performing two SPI transfers has not
magically become as fast as performing one SPI transfer since 4.19.
So the argument is nonsense.

Nevertheless I was going to repeat the performance measurements on a
recent kernel but haven't gotten around to that yet because the
measurements need to be performed with CONFIG_PREEMPT_RT_FULL to
be reliable (a vanilla kernel is too jittery), so I have to create
a new branch with RT patches on the test machine, which is fairly
involved and time consuming.

I think it's fair that the two drivers are unified, but the performance
for the SPI variant shouldn't be unnecessarily diminished in the process.

Thanks,

Lukas
