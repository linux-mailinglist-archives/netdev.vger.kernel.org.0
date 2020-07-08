Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6D1219431
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 01:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgGHXQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 19:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgGHXQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 19:16:33 -0400
Received: from localhost (mobile-166-175-191-139.mycingular.net [166.175.191.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4214020708;
        Wed,  8 Jul 2020 23:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594250192;
        bh=XjaHKQeeyk3n1aGs3ThXONBU6dyJY4endnX1mwzVig4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=koQIcnjQD0TVT6sjk6JyjjArQsTycvEvRdOx/OrZ3hx/Z/xv35z4VT/CXebMuBimt
         ykxfhNK+y2whWdUSB3dJNXBwZBOWlJ39p7INL5AXbnx+mOeKSooMWS0bi7Xf3OVZqs
         Doj1GqrRymrMOtfUref1fhsIAMBzlpN79PtYeC28=
Date:   Wed, 8 Jul 2020 18:16:30 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Aya Levin <ayal@mellanox.com>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        saeedm@mellanox.com, mkubecek@suse.cz, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org, tariqt@mellanox.com,
        alexander.h.duyck@linux.intel.com, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
Message-ID: <20200708231630.GA472767@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0506f0aa-f35e-09c7-5ba0-b74cd9eb1384@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 08, 2040 at 11:22:12AM +0300, Aya Levin wrote:
> On 7/6/2020 10:49 PM, David Miller wrote:
> > From: Aya Levin <ayal@mellanox.com>
> > Date: Mon, 6 Jul 2020 16:00:59 +0300
> > 
> > > Assuming the discussions with Bjorn will conclude in a well-trusted
> > > API that ensures relaxed ordering in enabled, I'd still like a method
> > > to turn off relaxed ordering for performance debugging sake.
> > > Bjorn highlighted the fact that the PCIe sub system can only offer a
> > > query method. Even if theoretically a set API will be provided, this
> > > will not fit a netdev debugging - I wonder if CPU vendors even support
> > > relaxed ordering set/unset...
> > > On the driver's side relaxed ordering is an attribute of the mkey and
> > > should be available for configuration (similar to number of CPU
> > > vs. number of channels).
> > > Based on the above, and binding the driver's default relaxed ordering
> > > to the return value from pcie_relaxed_ordering_enabled(), may I
> > > continue with previous direction of a private-flag to control the
> > > client side (my driver) ?
> > 
> > I don't like this situation at all.
> > 
> > If RO is so dodgy that it potentially needs to be disabled, that is
> > going to be an issue not just with networking devices but also with
> > storage and other device types as well.
> > 
> > Will every device type have a custom way to disable RO, thus
> > inconsistently, in order to accomodate this?
> > 
> > That makes no sense and is a terrible user experience.
> > 
> > That's why the knob belongs generically in PCI or similar.
> > 
> Hi Bjorn,
> 
> Mellanox NIC supports relaxed ordering operation over DMA buffers.
> However for debug prepossess we must have a chicken bit to disable
> relaxed ordering on a specific system without effecting others in
> run-time. In order to meet this requirement, I added a netdev
> private-flag to ethtool for set RO API.
> 
> Dave raised a concern regarding embedding relaxed ordering set API
> per system (networking, storage and others). We need the ability to
> manage relaxed ordering in a unify manner. Could you please define a
> PCI sub-system solution to meet this requirement?

I agree, this is definitely a mess.  Let me just outline what I think
we have today and what we're missing.

  - On the hardware side, device use of Relaxed Ordering is controlled
    by the Enable Relaxed Ordering bit in the PCIe Device Control
    register (or the PCI-X Command register).  If set, the device is
    allowed but not required to set the Relaxed Ordering bit in
    transactions it initiates (PCIe r5.0, sec 7.5.3.4; PCI-X 2.0, sec
    7.2.3).

    I suspect there may be device-specific controls, too, because [1]
    claims to enable/disable Relaxed Ordering but doesn't touch the
    PCIe Device Control register.  Device-specific controls are
    certainly allowed, but of course it would be up to the driver, and
    the device cannot generate TLPs with Relaxed Ordering unless the
    architected PCIe Enable Relaxed Ordering bit is *also* set.

  - Platform firmware can enable Relaxed Ordering for a device either
    before handoff to the OS or via the _HPX ACPI method.

  - The PCI core never enables Relaxed Ordering itself except when
    applying _HPX.

  - At enumeration-time, the PCI core disables Relaxed Ordering in
    pci_configure_relaxed_ordering() if the device is below a Root
    Port that has a quirk indicating an erratum.  This quirk currently
    includes many Intel Root Ports, but not all, and is an ongoing
    maintenance problem.

  - The PCI core provides pcie_relaxed_ordering_enabled() which tells
    you whether Relaxed Ordering is enabled.  Only used by cxgb4 and
    csio, which use that information to fill in Ingress Queue
    Commands.

  - The PCI core does not provide a driver interface to enable or
    disable Relaxed Ordering.

  - Some drivers disable Relaxed Ordering themselves: mtip32xx,
    netup_unidvb, tg3, myri10ge (oddly, only if CONFIG_MYRI10GE_DCA),
    tsi721, kp2000_pcie.

  - Some drivers enable Relaxed Ordering themselves: niu, tegra.

What are we missing and what should the PCI core do?

  - Currently the Enable Relaxed Ordering bit depends on what firmware
    did.  Maybe the PCI core should always clear it during
    enumeration?

  - The PCI core should probably have a driver interface like
    pci_set_relaxed_ordering(dev, enable) that can set or clear the
    architected PCI-X or PCIe Enable Relaxed Ordering bit.

  - Maybe there should be a kernel command-line parameter like
    "pci=norelax" that disables Relaxed Ordering for every device and
    prevents pci_set_relaxed_ordering() from enabling it.

    I'm mixed on this because these tend to become folklore about how
    to "fix" problems and we end up with systems that don't work
    unless you happen to find the option on the web.  For debugging
    issues, it might be enough to disable Relaxed Ordering using
    setpci, e.g., "setpci -s02:00.0 CAP_EXP+8.w=0"

[1] https://lore.kernel.org/netdev/20200623195229.26411-11-saeedm@mellanox.com/
