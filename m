Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313EE2EB71B
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbhAFAv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbhAFAv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:51:58 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12693C061574;
        Tue,  5 Jan 2021 16:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2VuGgG2Y0oR6VaHF+A2Tlk5qtM6i8jJ0JeuAdLPEIVg=; b=YtyM+2Ss06xrA0JR7dBINeoXw
        4jdKkyHo49FRvf/FV/c3qm5xE4AyVEtItlodEp1L2+RNlD1SeuFL2mWp3wLydV/ULsYxTgYAzHXxG
        EAJhIpgHroWFEyvqN+YGlnsYm1O3ER2MNM/6RVqxmy0hsz8+oZ7s344+yfEgfLE7cbL/h084Xr+B9
        g7gAMS+C6zIBs+i0eRXW1jMAMi3sgRZf3QAwztWXuo4F7eF3FhoQAF0ofEl0sBZF828Xs/grfWXLV
        RFRiuDI7T+xrYg2m4Mz1gqb0lfw3xVPkGdFy3KLZmtosxjq61B/rXHHJI3bLqS1JbceneNZlPU6E2
        ff046hNcA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45162)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kwx2N-0001D4-K8; Wed, 06 Jan 2021 00:50:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kwx2L-0008Az-I1; Wed, 06 Jan 2021 00:50:53 +0000
Date:   Wed, 6 Jan 2021 00:50:53 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: iop32x: improve N2100 PCI broken parity quirk
Message-ID: <20210106005053.GG1551@shell.armlinux.org.uk>
References: <d53b6377-ff2a-3bba-612f-d052ffa81d09@gmail.com>
 <20210106002833.GA1286114@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106002833.GA1286114@bjorn-Precision-5520>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 06:28:33PM -0600, Bjorn Helgaas wrote:
> On Tue, Jan 05, 2021 at 10:42:31AM +0100, Heiner Kallweit wrote:
> >  {
> > -	if (dev->bus->number == 0 &&
> > -	    (dev->devfn == PCI_DEVFN(1, 0) ||
> > -	     dev->devfn == PCI_DEVFN(2, 0)))
> > -		dev->broken_parity_status = 1;
> > +	if (machine_is_n2100())
> > +		pci_quirk_broken_parity(dev);
> 
> Whatever "machine_is_n2100()" is (I can't find the definition), it is
> surely not equivalent to "00:01.0 || 00:02.0".  That change probably
> should be a separate patch with some explanation.

It isn't equivalent. It says "if this machine is N2100" which is a
completely different thing from matching the bus/devfn numbers.

You won't find a definition for machine_is_n2100() in the kernel;
it is generated from the machine table by scripts, along with lots
of similar definitions for each machine type:

/* The type of machine we're running on */
extern unsigned int __machine_arch_type;

#ifdef CONFIG_MACH_N2100
# ifdef machine_arch_type
#  undef machine_arch_type
#  define machine_arch_type     __machine_arch_type
# else
#  define machine_arch_type     MACH_TYPE_N2100
# endif
# define machine_is_n2100()     (machine_arch_type == MACH_TYPE_N2100)
#else
# define machine_is_n2100()     (0)
#endif

The upshot of the above is that machine_is_n2100() is constant zero
if the platform is not configured (thereby allowing the compiler to
eliminate the code.) If it is the _only_ platform selected, then it
evaluates to an always-true expression. Otherwise, it becomes a
run-time evaluated conditional.

We may have better ways to do this in modern kernels, but this was
invented decades ago, and works with zero runtime overhead.

> If this makes the quirk safe to use in a generic kernel, that sounds
> like a good thing.
> 
> I guess a parity problem could be the result of a defect in either the
> device (e.g., 0x8169), which would be an issue in *all* platforms, or
> a platform-specific issue in the way it's wired up.  I assume it's the
> latter because the quirk is not in drivers/pci/quirks.c.
> 
> Why is it safe to restrict this to device ID 0x8169?  If this is
> platform issue, it might affect any device in the slot.

You assume the platform has multiple PCI slots - it doesn't. It's an
embedded platform (it's sold as a NAS) and it has a single mini-PCI
slot for a WiFi card. Without that populated, lspci -n looks like
this:

00:01.0 0200: 10ec:8169 (rev 10)
00:02.0 0200: 10ec:8169 (rev 10)
00:03.0 0180: 1095:3512 (rev 01)
00:04.0 0c03: 1106:3038 (rev 61)
00:04.1 0c03: 1106:3038 (rev 61)
00:04.2 0c03: 1106:3104 (rev 63)

Where all those devices are soldered to the board.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
