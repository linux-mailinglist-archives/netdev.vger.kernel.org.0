Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68B43F6102
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 16:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237850AbhHXOy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 10:54:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237731AbhHXOyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 10:54:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3975C61214;
        Tue, 24 Aug 2021 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629816821;
        bh=rh1p1gFrunzlG6DSawKWhowszd42143/O+LK207GUac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=R5HbKzvwksHr+StiTygpU3AzPPiPRfHBrfoLaHCVDNssQ7Vuz4WVVBCB55Di19aGI
         RZKlYAsHliWGF71otIb2zgC2qdWlipkdowu2znzg47YeMoTpVx7BBbxllHgtgV5Pb2
         UdStoMfljREfqFfGanoKChU6M74ObIbIk95yudtxauAPLvRdVa0U8YfeuC5aOYXSuv
         KYI+YbINL/fRuvXlzzbl3O+IDU5RRIUhFqRcBvH/EeGVsjPDXOv559lB5G8CIi7R9S
         MDRuIrlvFUF7gvk7B0xxTMf0NrOlKrRcYF0ZqkgHInU71OetATW/GoZpJbeMCyOMt4
         79qDeD/dUKRPw==
Date:   Tue, 24 Aug 2021 09:53:39 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        nic_swsd <nic_swsd@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 1/3] r8169: Implement dynamic ASPM mechanism
Message-ID: <20210824145339.GA3453132@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p5KH69NPMejM93STx3J+0WNBuXzaheWJJoURM39=DLvxg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 03:39:35PM +0800, Kai-Heng Feng wrote:
> On Sat, Aug 21, 2021 at 5:03 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> >
> > On Thu, Aug 19, 2021 at 05:45:22PM +0200, Heiner Kallweit wrote:
> > > On 19.08.2021 13:42, Bjorn Helgaas wrote:
> > > > On Thu, Aug 19, 2021 at 01:45:40PM +0800, Kai-Heng Feng wrote:
> > > >> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> > > >> Same issue can be observed with older vendor drivers.
> > > >
> > > > On some platforms but not on others?  Maybe the PCIe topology is a
> > > > factor?  Do you have bug reports with data, e.g., "lspci -vv" output?
> > > >
> > > >> The issue is however solved by the latest vendor driver. There's a new
> > > >> mechanism, which disables r8169's internal ASPM when the NIC traffic has
> > > >> more than 10 packets, and vice versa.
> > > >
> > > > Presumably there's a time interval related to the 10 packets?  For
> > > > example, do you want to disable ASPM if 10 packets are received (or
> > > > sent?) in a certain amount of time?
> > > >
> > > >> The possible reason for this is
> > > >> likely because the buffer on the chip is too small for its ASPM exit
> > > >> latency.
> > > >
> > > > Maybe this means the chip advertises incorrect exit latencies?  If so,
> > > > maybe a quirk could override that?
> > > >
> > > >> Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
> > > >> use dynamic ASPM under Windows. So implement the same mechanism here to
> > > >> resolve the issue.
> > > >
> > > > What exactly is "dynamic ASPM"?
> > > >
> > > > I see Heiner's comment about this being intended only for a downstream
> > > > kernel.  But why?
> > > >
> > > We've seen various more or less obvious symptoms caused by the broken
> > > ASPM support on Realtek network chips. Unfortunately Realtek releases
> > > neither datasheets nor errata information.
> > > Last time we attempted to re-enable ASPM numerous problem reports came
> > > in. These Realtek chips are used on basically every consumer mainboard.
> > > The proposed workaround has potential side effects: In case of a
> > > congestion in the chip it may take up to a second until ASPM gets
> > > disabled, what may affect performance, especially in case of alternating
> > > traffic patterns. Also we can't expect support from Realtek.
> > > Having said that my decision was that it's too risky to re-enable ASPM
> > > in mainline even with this workaround in place. Kai-Heng weights the
> > > power saving higher and wants to take the risk in his downstream kernel.
> > > If there are no problems downstream after few months, then this
> > > workaround may make it to mainline.
> >
> > Since ASPM apparently works well on some platforms but not others, I'd
> > suspect some incorrect exit latencies.
> 
> Can be, but if their dynamic ASPM mechanism can workaround the issue,
> maybe their hardware is just designed that way?

Designed what way?  You mean the hardware uses the architected ASPM
control bits in the PCIe capability to control some ASPM functionality
that doesn't work like the spec says it should work?

> > Ideally we'd have some launchpad/bugzilla links, and a better
> > understanding of the problem, and maybe a quirk that makes this work
> > on all platforms without mucking up the driver with ASPM tweaks.
> 
> The tweaks is OS-agnostic and is also implemented in Windows.

I assume you mean these tweaks are also implemented in the Windows
*driver* from Realtek.  That's not a very convincing argument that
this is the way it should work.

If ASPM works well on some platforms, we should be able to make it
work well on other platforms, too.  The actual data ("lspci -vvxxx")
from working and problematic platforms might have hints.


> > But I'm a little out of turn here because the only direct impact to
> > the PCI core is the pcie_aspm_supported() interface.  It *looks* like
> > these patches don't actually touch the PCIe architected ASPM controls
> > in Link Control; all I see is mucking with Realtek-specific registers.
> 
> AFAICT, Realtek ethernet NIC and wireless NIC both have two layers of
> ASPM, one is the regular PCIe ASPM, and a Realtek specific internal
> ASPM.
> Both have to be enabled to really make ASPM work for them.

It's common for devices to have chicken bits.  But when a feature is
enabled, it should work as defined by the PCIe spec so it will work
with other spec-compliant devices.

Bjorn
