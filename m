Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A074426C34
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241154AbhJHOAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhJHOAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E18B76101E;
        Fri,  8 Oct 2021 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633701503;
        bh=vHQBjzm63eYEwZdk+Hh3ouA4QScDuMrqTscGOr+oy00=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=JZzsgMirRN+GtgUjepdZCmCr5Pj+hNFm1bcNvDRFnM2X38r4UpW2NSx3jn7QCgsgG
         7PARKd9sZ+lMYPL73IzY1Pailssbox3IFjC73am4XdCvJcOfcV8EbCV032eCzbgmTt
         NKZJMxF+830e4ZvtpYRWouV2V9IyYa8LRruhLeMZBUDxwbTSp+mMcrjpaxElUSB66P
         soOYRqG0uxrXqKbmkN13Zxa758gGVVS88Gv8GlASrYNNTahuEu6IAgqTzu0tQFEgW8
         BAkiKrxe+kMplD55f2qd51CS0nC1NqqiZggitdoIruKkd75vzP/AB2jl+cBDcoqJj3
         y2YmIH/FeGs7A==
Date:   Fri, 8 Oct 2021 08:58:21 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        nic_swsd <nic_swsd@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH net-next v6 3/3] r8169: Implement dynamic ASPM
 mechanism
Message-ID: <20211008135821.GA1326355@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p4v+CmupCu2+3vY5N64WKkxcNvpk1M7+hhNoposx+aYCg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 02:18:55PM +0800, Kai-Heng Feng wrote:
> On Fri, Oct 8, 2021 at 3:11 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > On Fri, Oct 08, 2021 at 12:15:52AM +0800, Kai-Heng Feng wrote:
> > > r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> > > Same issue can be observed with older vendor drivers.
> > >
> > > The issue is however solved by the latest vendor driver. There's a new
> > > mechanism, which disables r8169's internal ASPM when the NIC traffic has
> > > more than 10 packets per second, and vice versa. The possible reason for
> > > this is likely because the buffer on the chip is too small for its ASPM
> > > exit latency.
> > > ...

> > I suppose that on the Intel system, if we enable ASPM, the link goes
> > to L1.2, and the NIC immediately receives 1000 packets in that second
> > before we can disable ASPM again, we probably drop a few packets?
> >
> > Whereas on the AMD system, we probably *never* drop any packets even
> > with L1.2 enabled all the time?
> 
> Yes and yes.

The fact that we drop some packets with dynamic ASPM on the Intel
system means we must be giving up some performance.

And I guess that on the AMD system, we should get full performance but
we must be using a little more power (probably unmeasurable) because
ASPM *could* be always enabled but dynamic ASPM disables it some of
the time.

> > And if we actually knew the root cause and could set the correct LTR
> > values or whatever is wrong on the Intel system, we probably wouldn't
> > need this dynamic scheme?
> 
> Because Realtek already implemented the dynamic ASPM workaround in
> their Windows and Linux driver, they never bother to find the root
> cause.
> So we'll never know what really happens here.

Looks like it.  Somebody with a PCIe analyzer could probably make
progress, but I agree, that doesn't seem likely.

Realtek no doubt has the equipment to do this, but apparently they
don't think it's worthwhile.  In their defense, the Linux ASPM code is
pretty impenetrable and there could be a problem there that causes or
contributes to this.

Bjorn
