Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B7D444532
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbhKCQFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232680AbhKCQFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 12:05:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DFE960E05;
        Wed,  3 Nov 2021 16:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635955376;
        bh=tEGgvNz6cxzVUhJzFow/0yapB19/ypbw7LaC/6uVyE4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=bjW9qM9wEiLtJMPpjhsbwkH7p4lpeKeQ8HOOTkXvw8KTOOheJs+rm1re5qkg8FPig
         7yP9KlATTOHI8OZhr5KVq0il9NeBNBAcMRsRQRNliqn4Ag/zVahaEDh9Y1HBZo9gfm
         ydZHuPb1z62piFnzRwL95OhWc5/Ww7YYSPrIl/3qPJ7YdIrUttQljcEC2V0fCkR8e7
         TTPy+kdFRiHAhlGjPN36IpZTHajpgnutKSMUtd+pqk2NPBKDXRShih7JHMRhxRpNGI
         aLX5pz1DWeNyKvRh44JZu4Ykw91YgDgbwHytwzVFAMSq7QgfgX/tgrT64A3iokwdn6
         P4s8dKZykRW4w==
Date:   Wed, 3 Nov 2021 11:02:55 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, logang@deltatee.com, leon@kernel.org,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V11 7/8] PCI: Enable 10-Bit Tag support for PCIe Endpoint
 device
Message-ID: <20211103160255.GA687132@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26f8758e-c85d-291b-1c34-5184aa6862aa@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 06:05:34PM +0800, Dongdong Liu wrote:
> On 2021/11/2 6:33, Bjorn Helgaas wrote:
> > On Mon, Nov 01, 2021 at 05:02:41PM -0500, Bjorn Helgaas wrote:
> > > On Sat, Oct 30, 2021 at 09:53:47PM +0800, Dongdong Liu wrote:
> > > > 10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
> > > > field size from 8 bits to 10 bits.
> > > > 
> > > > PCIe spec 5.0 r1.0 section 2.2.6.2 "Considerations for Implementing
> > > > 10-Bit Tag Capabilities" Implementation Note:
> > > > 
> > > >   For platforms where the RC supports 10-Bit Tag Completer capability,
> > > >   it is highly recommended for platform firmware or operating software
> > > >   that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
> > > >   bit automatically in Endpoints with 10-Bit Tag Requester capability.
> > > >   This enables the important class of 10-Bit Tag capable adapters that
> > > >   send Memory Read Requests only to host memory.
> > > > 
> > > > It's safe to enable 10-bit tags for all devices below a Root Port that
> > > > supports them. Switches that lack 10-Bit Tag Completer capability are
> > > > still able to forward NPRs and Completions carrying 10-Bit Tags correctly,
> > > > since the two new Tag bits are in TLP Header bits that were formerly
> > > > Reserved.
> > > 
> > > Side note: the reason we want to do this to increase performance by
> > > allowing more outstanding requests.  Do you have any benchmarking that
> > > we can mention here to show that this is actually a benefit?  I don't
> > > doubt that it is, but I assume you've measured it and it would be nice
> > > to advertise it.
> > 
> > Hmmm.  I did a quick Google search looking for "nvme pcie 10-bit tags"
> > hoping to find some performance info, but what I *actually* found was
> > several reports of 10-bit tags causing breakage:
> > 
> >   https://www.reddit.com/r/MSI_Gaming/comments/exjvzg/x570_apro_7c37vh72beta_version_has_anyone_tryed_it/
> >   https://rog.asus.com/forum/showthread.php?115064-Beware-of-agesa-1-0-0-4B-bios-not-good!/page2
> >   https://forum-en.msi.com/index.php?threads/sound-blaster-z-has-weird-behaviour-after-updating-bios-x570-gaming-edge-wifi.325223/page-2
> >   https://gearspace.com/board/electronic-music-instruments-and-electronic-music-production/1317189-h8000fw-firewire-facts-2020-must-read.html
> >   https://www.soundonsound.com/forum/viewtopic.php?t=69651&start=12
> >   https://forum.rme-audio.de/viewtopic.php?id=30307
> > 
> > This is a big problem for me.
> > 
> > Some of these might be a broken BIOS that turns on 10-bit tags
> > when the completer doesn't support them.  I didn't try to debug
> > them to that level.  But the last thing I want is to enable 10-bit
> > by default and cause boot issues or sound card issues or whatever.
>
> It seems a BIOS software bug, as it turned on (as default) a 10-Bit
> Tag Field for RP, but the card (non-Gen4 card) does not support
> 10-Bit Completer.

It doesn't matter *where* the problem is.  If we change Linux to
*expose* a BIOS bug, that's just as much of a problem as if the bug
were in Linux.  Users are not equipped to diagnose or fix problems
like that.

> This patch we enable 10-Bit Tag Requester for EP when RC supports
> 10-Bit Tag Completer capability. So it shuld be worked ok.

That's true as long as the RC supports 10-bit tags correctly when it
advertises support for them.  It "should" work :)

But it does remind me that if the RC doesn't support 10-bit tags, but
we use sysfs to enable 10-bit tags for a reqester that intends to use
P2PDMA to a peer that *does* support them, I don't think there's
any check in the DMA API that prevents the driver from setting up DMA
to the RC in addition to the peer.

> But I still think default to "on" will be better,
> Current we enable 10-Bit Tag, in the future PCIe 6.0 maybe need to use
> 14-Bit tags to get good performance.

Maybe we can default to "on" based on BIOS date or something.  Older
systems that want the benefit can use the param to enable it, and if
there's a problem, the cause will be obvious ("we booted with
'pci=tag-bits=10' and things broke").

If we enable 10-bit tags by default on systems from 2022 or newer, we
shouldn't break any existing systems, and we have a chance to discover
any problems and add quirk if necessary.

> > In any case, we (by which I'm afraid I mean "you" :)) need to
> > investigate the problem reports, figure out whether we will see
> > similar problems, and fix them before merging if we can.
>
> We have tested a PCIe 5.0 network card on FPGA with 10-Bit tag worked
> ok. I have not got the performance data as FPGA is slow.

10-bit tag support appeared in the spec four years ago (PCIe r4.0, in
September, 2017).  Surely there is production hardware that supports
this and could demonstrate a benefit from this.

We need a commit log that says "enabling 10-bit tags allows more
outstanding transactions, which improves performance of adapters like
X by Y% on these workloads," not a log that says "we think enabling
10-bit tags is safe, but users with non-compliant hardware may see new
PCIe errors or even non-bootable systems, and they should use boot
param X to work around this."

> Current we enable 10-Bit Tag Requester for EP when RC supports
> 10-Bit Tag Completer capability. It should be worked ok except
> hardware bugs, we also provide boot param to disable 10-Bit Tag if
> the hardware really have a bug or can do some quirks as 8-bit tag
> has done if we have known the hardware.

The problem is that turning it on by default means systems with
hardware defects *used* to work but now they mysteriously *stop*
working.  Yes, a boot param can work around that, but it's just
not an acceptable user experience.  Maybe there are no such defects.
I dunno.

Bjorn
