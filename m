Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20E4313FE4
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbhBHUGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:06:03 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:58541 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbhBHUFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:05:50 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 118K4nZm018979;
        Mon, 8 Feb 2021 12:04:50 -0800
Date:   Tue, 9 Feb 2021 01:17:41 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Casey Leedom <leedom@chelsio.com>
Subject: Re: [PATCH resend net-next v2 2/3] PCI/VPD: Change Chelsio T4 quirk
 to provide access to full virtual address space
Message-ID: <20210208194740.GA24818@chelsio.com>
References: <20210205214621.GA198699@bjorn-Precision-5520>
 <6d05f72b-9a61-6da8-e70e-d4b3cdf3ca28@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d05f72b-9a61-6da8-e70e-d4b3cdf3ca28@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, February 02/05/21, 2021 at 23:31:24 +0100, Heiner Kallweit wrote:
> On 05.02.2021 22:46, Bjorn Helgaas wrote:
> > [+cc Casey, Rahul]
> > 
> > On Fri, Feb 05, 2021 at 08:29:45PM +0100, Heiner Kallweit wrote:
> >> cxgb4 uses the full VPD address space for accessing its EEPROM (with some
> >> mapping, see t4_eeprom_ptov()). In cudbg_collect_vpd_data() it sets the
> >> VPD len to 32K (PCI_VPD_MAX_SIZE), and then back to 2K (CUDBG_VPD_PF_SIZE).
> >> Having official (structured) and inofficial (unstructured) VPD data
> >> violates the PCI spec, let's set VPD len according to all data that can be
> >> accessed via PCI VPD access, no matter of its structure.
> > 
> > s/inofficial/unofficial/
> > 
> >> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >> ---
> >>  drivers/pci/vpd.c | 7 +++----
> >>  1 file changed, 3 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
> >> index 7915d10f9..06a7954d0 100644
> >> --- a/drivers/pci/vpd.c
> >> +++ b/drivers/pci/vpd.c
> >> @@ -633,9 +633,8 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
> >>  	/*
> >>  	 * If this is a T3-based adapter, there's a 1KB VPD area at offset
> >>  	 * 0xc00 which contains the preferred VPD values.  If this is a T4 or
> >> -	 * later based adapter, the special VPD is at offset 0x400 for the
> >> -	 * Physical Functions (the SR-IOV Virtual Functions have no VPD
> >> -	 * Capabilities).  The PCI VPD Access core routines will normally
> >> +	 * later based adapter, provide access to the full virtual EEPROM
> >> +	 * address space. The PCI VPD Access core routines will normally
> >>  	 * compute the size of the VPD by parsing the VPD Data Structure at
> >>  	 * offset 0x000.  This will result in silent failures when attempting
> >>  	 * to accesses these other VPD areas which are beyond those computed
> >> @@ -644,7 +643,7 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
> >>  	if (chip == 0x0 && prod >= 0x20)
> >>  		pci_set_vpd_size(dev, 8192);
> >>  	else if (chip >= 0x4 && func < 0x8)
> >> -		pci_set_vpd_size(dev, 2048);
> >> +		pci_set_vpd_size(dev, PCI_VPD_MAX_SIZE);
> > 
> > This code was added by 7dcf688d4c78 ("PCI/cxgb4: Extend T3 PCI quirk
> > to T4+ devices") [1].  Unfortunately that commit doesn't really have
> > the details about what it fixes, other than the silent failures it
> > mentions in the comment.
> > 
> > Some devices hang if we try to read at the wrong VPD address, and this
> > can be done via the sysfs "vpd" file.  Can you expand the commit log
> > with an argument for why it is always safe to set the size to
> > PCI_VPD_MAX_SIZE for these devices?
> > 
> 
> Seeing t4_eeprom_ptov() there is data at the end of the VPD address
> space, but there may be gaps in between. I don't have test hw,
> therefore it would be good if Chelsio could confirm that accessing
> any address in the VPD address space (32K) is ok. If a VPD address
> isn't backed by EEPROM, it should return 0x00 or 0xff, and not hang
> the device.
> 

We've tested the patches on T5 adapter. Although there are no crashes
seen, the 32K VPD read from sysfs at certain chunks are getting wrapped
around and overwritten. We're still analyzing this.

> > The fact that cudbg_collect_vpd_data() fiddles around with
> > pci_set_vpd_size() suggests to me that there is *some* problem with
> > reading parts of the VPD.  Otherwise, why would they bother?
> > 
> > 940c9c458866 ("cxgb4: collect vpd info directly from hardware") [2]
> > added the pci_set_vpd_size() usage, but doesn't say why it's needed.
> > Maybe Rahul will remember?
> > 

If firmware has crashed, then it's not possible to collect the VPD info
from firmware. So, the VPD info is fetched from EEPROM instead, which
is unfortunately outside the VPD size of the PF.

> 
> In addition we have cb92148b58a4 ("PCI: Add pci_set_vpd_size() to set
> VPD size"). To me it seems the VPD size quirks and this commit
> try to achieve the same: allow to override the autodetected VPD len
> 
> The quirk mechanism is well established, and if possible I'd like
> to get rid of pci_set_vpd_size(). I don't like the idea that the
> PCI core exposes API calls for accessing a proprietary VPD data
> format of one specific vendor (cxgb4 is the only user of
> pci_set_vpd_size()).
> 

There seems to be a way to get the Serial Configuration Version from
some internal registers. I will send the patch soon. It should remove
the call to pci_set_vpd_size() from cudbg_lib.c.

Thanks,
Rahul

> > Bjorn
> > 
> > [1] https://git.kernel.org/linus/7dcf688d4c78
> > [2] https://git.kernel.org/linus/940c9c458866
> > 
> >>  }
> >>  
> >>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
> >> -- 
> >> 2.30.0
> >>
> >>
> >>
> 
