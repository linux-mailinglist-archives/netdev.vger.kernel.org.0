Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC09742A34B
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbhJLLbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236149AbhJLLbh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:31:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F04A61040;
        Tue, 12 Oct 2021 11:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634038175;
        bh=U3HP5QIpD7LIdnqxGqxBn+ZxL4oXuDRgiGQEgFAeD9I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=gzkWeCj3+rCgN3HeS32XpHTxPTGe22Omg/sVDC6hrexHcJIxGdbXEsGL8tq7ItDzD
         k1KOydqi4TSCumBjoxJhO7O3JG1VOr7ATNYT3ud9143Kt7G0RTtZWZL8Sohpf7MhWC
         7b8nST/WVImgTG/MpeJBCSTXtO79DC53/v5ZzWm9I2Qit4DW8APooapQGdT9wN+z4m
         mUREPGwnVpC8mvaCGLe76eUPBldhm1Opmh+dMAoDMjVv/082gDCNeGw8YbxWmTvagv
         BBvNsJE00j5RwpOKDSkzVA38DevTdvadLWuJqBEDAHYROOGQsu7Bryg2sLLChBCl76
         9FrJIvtJlD/cg==
Date:   Tue, 12 Oct 2021 06:29:32 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] mwifiex: Add quirk resetting the PCI bridge on MS
 Surface devices
Message-ID: <20211012112932.GA1735699@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fee8b431-617f-3890-3ad2-67a61d3ffca2@v0yd.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 10:48:49AM +0200, Jonas Dreßler wrote:
> On 10/11/21 18:53, Bjorn Helgaas wrote:
> > On Mon, Oct 11, 2021 at 03:42:38PM +0200, Jonas Dreßler wrote:
> > > The most recent firmware (15.68.19.p21) of the 88W8897 PCIe+USB card
> > > reports a hardcoded LTR value to the system during initialization,
> > > probably as an (unsuccessful) attempt of the developers to fix firmware
> > > crashes. This LTR value prevents most of the Microsoft Surface devices
> > > from entering deep powersaving states (either platform C-State 10 or
> > > S0ix state), because the exit latency of that state would be higher than
> > > what the card can tolerate.
> > 
> > S0ix and C-State 10 are ACPI concepts that don't mean anything in a
> > PCIe context.
> > 
> > I think LTR is only involved in deciding whether to enter the ASPM
> > L1.2 substate.  Maybe the system will only enter C-State 10 or S0ix
> > when the link is in L1.2?
> 
> Yup, this is indeed the case, see https://01.org/blogs/qwang59/2020/linux-s0ix-troubleshooting
> (ctrl+f "IP LINK PM STATE").

I think it would be helpful if the commit log included this missing
link, e.g., the LTR value prevents the link from going to L1.2, which
in turn prevents use of C-State 10/S0ix.

> There's two alternatives I can think of to deal with this issue:
> 
> 1) Revert the cards firmware in linux-firmware back to the second-latest
> version. That firmware didn't report a fixed LTR value and also doesn't
> have any other obvious issues I know of compared to the latest one.

You've mentioned "fixed LTR value" more than once.  My weak
understanding of LTR and L1.2 is that the latencies a device reports
via LTR messages are essentially a function of buffering in the device
and electrical characteristics of the link.  I expect them to be set
once and not changed.

But did the previous firmware report different latencies at different
times?  Or did it just not advertise L1.2 support at all?  Or do you
mean the new firmware reports a "corrected" LTR value that doesn't
work as well?

> 2) Somehow interact with the PMC Core driver to make it ignore the LTR
> values reported by the card (I doubt that's possible from mwifiex).
> It can be done manually via debugfs by writing to
> /sys/kernel/debug/pmc_core/ltr_ignore.

Interesting; I wasn't aware of that, thanks.  This still feels like a
configuration issue.  If we ignore the reported LTR values, I guess
you mean the root port assumes it's *always* safe to enter L1.2, i.e.,
the device has enough buffering to deal with the exit latency?

I would think there would be a way to program the LTR capability to
have the device itself report that, so we wouldn't have to fiddle with
the upstream end.

> > > +	 * We need to do it here because it must happen after firmware
> > > +	 * initialization and this function is called right after that is done.
> > > +	 */

> > > +	if (card->quirks & QUIRK_DO_FLR_ON_BRIDGE)
> > > +		pci_reset_function(parent_pdev);
> > 
> > PCIe r5.0, sec 7.5.3.3, says Function Level Reset can only be
> > supported by endpoints, so I guess this will actually do some other
> > kind of reset.
> 
> Interesting, I briefly searched and it doesn't seem like think
> there's public documentation available by Intel that goes into
> the specifics here, maybe someone working at Intel knows more?

"lspci -vv" will tell you whether the root port advertises FLR
support.  The spec says it shouldn't, but I think pci_reset_function()
relies on what DevCap says.  You could instrument pci_reset_function()
to see exactly what kind of reset we do.  

Bjorn
