Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BF52F5823
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbhANCOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729087AbhAMV1N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 16:27:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08C8720DD4;
        Wed, 13 Jan 2021 21:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610573125;
        bh=CnNxb+8yGGrLBAdxm2EQDAH/OEkEdMsqk9sG6FYEJhM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=eLUDRnQEWM7PadLAq9Mxy0LQgQSTTIRG2PFDBR1vmeo59UTtBYUPPzA+x5daVASKK
         QebCIIOTKjo3xCN5j3hjYDqlvtT4JCvJ6U8deVhBK+/F/AlZZR4tLIWraC0ALEDx19
         o1Xw6SVLODjDiefwPnbD9yKWmpoF5jyQfSDOnIeTJX16brh7nZjzZ0KtagDMMvf+ru
         IpOLmHL2eOVgqvIKpWF4tiJzuHCKNK4LnD7vVpd5aLHaWyfnrhHQw35WjqW648Pw4C
         8fMjICRch3UpWJzLjx4eWAZKjF/oQYLZg490gUlbHgioBxaabEzeLCWjii3rsLlAbb
         k8DS5SP1imY7g==
Date:   Wed, 13 Jan 2021 15:25:23 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Lennert Buytenhek <kernel@wantstofly.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] PCI: Disable parity checking if broken_parity is
 set
Message-ID: <20210113212523.GA1933362@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e9c5b3a-f239-8d8d-08e5-015ec38dd3a0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 09:52:23PM +0100, Heiner Kallweit wrote:
> On 06.01.2021 20:34, Heiner Kallweit wrote:
> > On 06.01.2021 20:22, Bjorn Helgaas wrote:
> >> On Wed, Jan 06, 2021 at 06:50:22PM +0100, Heiner Kallweit wrote:
> >>> If we know that a device has broken parity checking, then disable it.
> >>> This avoids quirks like in r8169 where on the first parity error
> >>> interrupt parity checking will be disabled if broken_parity_status
> >>> is set. Make pci_quirk_broken_parity() public so that it can be used
> >>> by platform code, e.g. for Thecus N2100.
> >>>
> >>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >>> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> >>
> >> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> >>
> >> This series should all go together.  Let me know if you want me to do
> >> anything more (would require acks for arm and r8169, of course).
> >>
> > Right. For r8169 I'm the maintainer myself and agreed with Jakub that
> > the r8169 patch will go through the PCI tree.
> > 
> > Regarding the arm/iop32x part:
> > MAINTAINERS file lists Lennert as maintainer, let me add him.
> > Strange thing is that the MAINTAINERS entry for arm/iop32x has no
> > F entry, therefore the get_maintainers scripts will never list him
> > as addressee. The script lists Russell as "odd fixer".
> > @Lennert: Please provide a patch to add the missing F entry.
> > 
> > ARM/INTEL IOP32X ARM ARCHITECTURE
> > M:	Lennert Buytenhek <kernel@wantstofly.org>
> > L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > S:	Maintained
> 
> Bjorn, I saw that you set the series to "not applicable". Is this because
> of the missing ack for the arm part?

No, it's because I screwed up.  I use "not applicable" when I expect
patches to go via another tree.  I just missed your note about merging
via the PCI tree.  I'll take a look soon.

> I checked and Lennert's last kernel contribution is from 2015. Having said
> that the maintainer's entry may be outdated. Not sure who else would be
> entitled to ack this patch. The change is simple enough, could you take
> it w/o an ack? 
> Alternatively, IIRC Russell has got such a device. Russell, would it
> be possible that you test that there's still no false-positive parity
> errors with this series?
> 
> 
> > 
> >>> ---
> >>>  drivers/pci/quirks.c | 17 +++++++++++------
> >>>  include/linux/pci.h  |  2 ++
> >>>  2 files changed, 13 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> >>> index 653660e3b..ab54e26b8 100644
> >>> --- a/drivers/pci/quirks.c
> >>> +++ b/drivers/pci/quirks.c
> >>> @@ -205,17 +205,22 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
> >>>  DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
> >>>  				PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
> >>>  
> >>> +void pci_quirk_broken_parity(struct pci_dev *dev)
> >>> +{
> >>> +	u16 cmd;
> >>> +
> >>> +	dev->broken_parity_status = 1;	/* This device gives false positives */
> >>> +	pci_read_config_word(dev, PCI_COMMAND, &cmd);
> >>> +	pci_write_config_word(dev, PCI_COMMAND, cmd & ~PCI_COMMAND_PARITY);
> >>> +}
> >>> +
> >>>  /*
> >>>   * The Mellanox Tavor device gives false positive parity errors.  Mark this
> >>>   * device with a broken_parity_status to allow PCI scanning code to "skip"
> >>>   * this now blacklisted device.
> >>>   */
> >>> -static void quirk_mellanox_tavor(struct pci_dev *dev)
> >>> -{
> >>> -	dev->broken_parity_status = 1;	/* This device gives false positives */
> >>> -}
> >>> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR, quirk_mellanox_tavor);
> >>> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE, quirk_mellanox_tavor);
> >>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR, pci_quirk_broken_parity);
> >>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE, pci_quirk_broken_parity);
> >>>  
> >>>  /*
> >>>   * Deal with broken BIOSes that neglect to enable passive release,
> >>> diff --git a/include/linux/pci.h b/include/linux/pci.h
> >>> index b32126d26..161dcc474 100644
> >>> --- a/include/linux/pci.h
> >>> +++ b/include/linux/pci.h
> >>> @@ -1916,6 +1916,8 @@ enum pci_fixup_pass {
> >>>  	pci_fixup_suspend_late,	/* pci_device_suspend_late() */
> >>>  };
> >>>  
> >>> +void pci_quirk_broken_parity(struct pci_dev *dev);
> >>> +
> >>>  #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
> >>>  #define __DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
> >>>  				    class_shift, hook)			\
> >>> -- 
> >>> 2.30.0
> >>>
> >>>
> >>>
> > 
> 
