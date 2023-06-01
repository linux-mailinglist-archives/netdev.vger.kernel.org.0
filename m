Return-Path: <netdev+bounces-7208-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6402C71F11E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:51:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0EF01C210CE
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30CF648224;
	Thu,  1 Jun 2023 17:51:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BD442501
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF39EC433EF;
	Thu,  1 Jun 2023 17:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685641901;
	bh=BcWxCff8oE/YsPUBsGehbmDrmj07BGqbxcPNn2h5cJo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=fFOrDkoM5rEkTdvjobzjwFbt16t1TBCYRLHVs2FgKO0FNOup2ioKLZbM5zrZf9xak
	 WGUtTaA/vfr+RxrHZaPG0gYQL1hysfuDJLZwaJc1kw8VIpokGhHTqgv0VXoxc6UkK6
	 k+E0oIe67nW4oCNfSqovYVQBQ69fg3MZ1qEwxtDw4qgpSWbUBtI2F3hBABZm+Kosc1
	 kmXTqQDHdt6+IkThycrGkE1ozdgKYGGuVdEc4zqUV6lLYhiMoMX8TGu+HBBtl6snIn
	 Z4lw3dpapAL/USDYjHkdtz1hYQ8eI0mcJ2SOBXKSGklvaAzflv49btHF6Lk+3gfnnD
	 k+cvKU0pO7zIQ==
Date: Thu, 1 Jun 2023 12:51:39 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
	Liu Peibao <liupeibao@loongson.cn>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
Message-ID: <ZHjaq+TDW/RFcoxW@bhelgaas>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601163335.6zw4ojbqxz2ws6vx@skbuf>

On Thu, Jun 01, 2023 at 07:33:35PM +0300, Vladimir Oltean wrote:
> On Thu, Jun 01, 2023 at 10:44:45AM -0500, Bjorn Helgaas wrote:
> > To make sure I understand you, I think you're saying that if Function
> > 0 has DT status "disabled", 6fffbc7ae137 ("PCI: Honor firmware's
> > device disabled status") breaks things because we don't enumerate
> > Function 0 and the driver can't temporarily claim it to zero out its
> > piece of the shared memory.
> > 
> > With just 6fffbc7ae137, we don't enumerate Function 0, which means we
> > don't see that it's a multi-function device, so we don't enumerate
> > Functions 1, 2, etc, either.
> > 
> > With both 6fffbc7ae137 and your current patch, we would enumerate
> > Functions 1, 2, etc, but we still skip Function 0, so its piece of the
> > shared memory still doesn't get zeroed.
> 
> I'm saying that as long as commit 6fffbc7ae137 ("PCI: Honor firmware's
> device disabled status") exists in the form where the pci_driver :: probe()
> is completely skipped for disabled functions, the NXP ENETC PCIe device
> has a problem no matter what the function number is.

Yep.

> That problem is:
> the device drivers of all PCIe functions need to clear some memory
> before they ultimately fail to probe (as they should), because of some
> hardware design oversight. That is no longer possible if the driver has
> no hook to execute code for those devices that are disabled.

Yep.  If there's no pci_dev, there's no nice way to do anything to the
device.

> On top of that, function 0 having status = "disabled" is extra
> problematic, because the PCI core will now just assume that functions 1 .. N
> don't exist at all, which is simply false, because the usefulness of
> ENETC port 0 (PCIe function 0) from a networking perspective is
> independent from the usefulness of ENETC port 1 (PCIe function 1), ENETC
> port 2 etc.

Yes.

> > > The ENETC is not a hot-pluggable PCIe device. It uses Enhanced Allocation
> > > to essentially describe on-chip memory spaces, which are always present.
> > > So presumably, a different system-level solution to initialize those
> > > shared memories (U-Boot?) may be chosen, if implementing this workaround
> > > in Linux puts too much pressure on the PCIe core and the way in which it
> > > does things. Initially I didn't want to do this in prior boot stages
> > > because we only enable the RCEC in Linux, nothing is broken other than
> > > the spurious AER messages, and, you know.. the kernel may still run
> > > indefinitely on top of bootloaders which don't have the workaround applied.
> > > So working around it in Linux avoids one dependency.
> > 
> > If I understand correctly, something (bootloader or Linux) needs to do
> > something to Function 0 (e.g., clear memory).
> 
> To more than just function 0 (also 1, 2 and 6).

Yes.

> There are 2 confounding
> problems, the latter being something that was exposed by your question:
> what will happen that's bad with the current mainline code structure,
> *notwithstanding* the fact that function 0 may have status = "disabled"
> (which currently will skip enumeration for the rest of the functions
> which don't have status = "disabled").
> 
> > Doing it in Linux would minimize dependences on the bootloader, so
> > that seems desirable to me. That means Linux needs to enumerate
> > Function 0 so it is visible to a driver or possibly a quirk.
> 
> Uhm... no, that wouldn't be enough. Only a straight revert would satisfy
> the workaround that we currently have for NXP ENETC in Linux.

I guess you mean a revert of 6fffbc7ae137?  This whole conversation is
about whether we can rework 6fffbc7ae137 to work both for Loongson and
for you, so nothing is decided yet.

The point is, I assume you agree that it's preferable if we don't have
to depend on a bootloader to clear the memory.

> Also, I'm not sure if it was completely reasonable of me in the first
> place to exploit this quirk of the Linux PCI bus - that the probe
> function is called even if a device is disabled in the device tree.
> I would understand if I was forced to rethink that.

After 6fffbc7ae137, the probe function is not called if the device is
disabled in DT because there's no pci_dev for it at all.

> > I think we could contemplate implementing 6fffbc7ae137 in a different
> > way.  Checking DT status at driver probe-time would probably work for
> > Loongson, but wouldn't quite solve the NXP problem because the driver
> > wouldn't be able to claim Function 0 even temporarily.
> 
> Not sure what you mean by "checking DT status at driver probe-time".
> Does enetc_pf_probe() -> of_device_is_available() qualify? You probably
> mean earlier than that.

I was thinking about something in pci_device_probe(), e.g., by
extending pci_device_can_probe().  But again, we're just exploring the
solution space; I'm not saying this is the best or only path.

> My problem is that I don't really understand what was the functional
> need for commit 6fffbc7ae137 ("PCI: Honor firmware's device disabled
> status") in the first place, considering that any device driver can
> already fail to probe based on the same condition at its own will.

In general, PCI drivers shouldn't rely on DT.  If the bus driver (PCI
in this case) calls a driver's probe function, the driver can assume
the device exists.  But enetc is not a general-purpose driver, and if
DT is the only way to discover this property, I guess you're stuck
doing that.

> > Is DT the only way to learn the NXP SERDES configuration?  I think it
> > would be much better if there were a way to programmatically learn it,
> > because then you wouldn't have to worry about syncing the DT with the
> > platform configuration, and it would decouple this from the Loongson
> > situation.
> 
> Syncing the DT with the platform configuration will always be necessary,
> because for networking we will also need extra information which is
> completely non-discoverable, like a phy-handle or such, and that depends
> on the wiring and static pinmuxing of the SoC. So it is practically
> reasonable to expect that what is usable has status = "okay", and what
> isn't has status = "disabled". Not to mention, there are already device
> trees in circulation which are written that way, and those need to
> continue to work.

Just because we need DT for non-discoverable info A doesn't mean we
should depend on it for B if B *is* discoverable.

This question of disabling a device via DT but still needing to do
things to the device is ... kind of a sticky wicket.

Maybe this should be a different DT property (not "status").  Then PCI
enumeration could work normally and 6fffbc7ae137 wouldn't be in the
way.

> > (If there were a way to actually discover the Loongson situation
> > instead of relying on DT, e.g., by keying off a Device ID or
> > something, that would be much better, too.  I assume we explored that,
> > but I don't remember the details.)
> 
> What is it that's special about the Loongson situation?

