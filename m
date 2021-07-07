Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7753BF1C0
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 23:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhGGV4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 17:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229956AbhGGV4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 17:56:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10E9061C4C;
        Wed,  7 Jul 2021 21:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625694820;
        bh=SRyl5rmdUfEQ79LEFS6va/JigKcnVTWbjo2bhIpKt1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qkZu98xNlmRzERNN+IFPr76xkkexzYkcT8Lq4tuoAYu/EH1XnqyqCOVuZeAx3p3XY
         U9qffVq324H68aLE3TzWucZyoqGw25TIFzsfjNLk7UrVTRLAd68q0i5VQvHbRI/xmI
         xN/tx1Z/759Mhmd522krp6wulhv5YJq5tkpt4I/2RK3VybZ8fEXak/A03oSZxn2s4n
         ValKFPLLzWH/ncxqXQNx+D5WSYQrjU05HkYWWulynD0V6EoGeovvblOBOIvWtP6IGn
         bNvP69gURmlld0rTrfCVLGGrzvfz7C4YqLHB0aChXok84cvNKeGLieXbJ78vy58e/P
         jQr6UdZ9JrlSw==
Received: by pali.im (Postfix)
        id AEC7E673; Wed,  7 Jul 2021 23:53:37 +0200 (CEST)
Date:   Wed, 7 Jul 2021 23:53:37 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Aaron Ma <aaron.ma@canonical.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
Message-ID: <20210707215337.lwbgvb6lxs3gmsbb@pali>
References: <20210702045120.22855-1-aaron.ma@canonical.com>
 <20210706201241.GA820992@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706201241.GA820992@bjorn-Precision-5520>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 06 July 2021 15:12:41 Bjorn Helgaas wrote:
> On Fri, Jul 02, 2021 at 12:51:19PM +0800, Aaron Ma wrote:
> > Check PCI state when rd/wr iomem.
> > Implement wr32 function as rd32 too.
> > 
> > When unplug TBT dock with i225, rd/wr PCI iomem will cause error log:
> > Trace:
> > BUG: unable to handle page fault for address: 000000000000b604
> > Oops: 0000 [#1] SMP NOPTI
> > RIP: 0010:igc_rd32+0x1c/0x90 [igc]
> > Call Trace:
> > igc_ptp_suspend+0x6c/0xa0 [igc]
> > igc_ptp_stop+0x12/0x50 [igc]
> > igc_remove+0x7f/0x1c0 [igc]
> > pci_device_remove+0x3e/0xb0
> > __device_release_driver+0x181/0x240
> > 
> > Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> > ---
> >  drivers/net/ethernet/intel/igc/igc_main.c | 16 ++++++++++++++++
> >  drivers/net/ethernet/intel/igc/igc_regs.h |  7 ++-----
> >  2 files changed, 18 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> > index f1adf154ec4a..606b72cb6193 100644
> > --- a/drivers/net/ethernet/intel/igc/igc_main.c
> > +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> > @@ -5292,6 +5292,10 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
> >  	u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
> >  	u32 value = 0;
> >  
> > +	if (igc->pdev &&
> > +		igc->pdev->error_state == pci_channel_io_perm_failure)
> > +		return 0;
> 
> I don't think this solves the problem.
> 
>   - Driver calls igc_rd32().
> 
>   - "if (pci_channel_io_perm_failure)" evaluates to false (error_state
>     does not indicate an error).
> 
>   - Device is unplugged.
> 
>   - igc_rd32() calls readl(), which performs MMIO read, which fails
>     because the device is no longer present.  readl() returns ~0 on
>     most platforms.
> 
>   - Same page fault occurs.

Hi Bjorn! I think that backtrace show that this error happens when PCIe
hotplug get interrupt that device was unplugged and PCIe hotplug code
calls remove/unbind procedure to stop unplugged driver.

And in this case really does not make sense to try issuing MMIO read,
device is already unplugged.

I looked that PCIe hotplug driver calls pci_dev_set_disconnected() when
this unplug interrupt happens and pci_dev_set_disconnected() just sets
pci_channel_io_perm_failure flag.

drivers/pci/pci.h provides function pci_dev_is_disconnected() which
checks if that flag pci_channel_io_perm_failure is set.

So I think that pci_dev_is_disconnected() is useful and could be
exported also to drivers (like this one) so they can check if
pci_dev_set_disconnected() was called in past and PCI driver is now in
unbind/cleanup/remove state because PCIe device is already disconnected
and not accessible anymore.

But maybe this check should be on other place in driver unbound
procedure and not in general MMIO read function?

> The only way is to check *after* the MMIO read to see whether an error
> occurred.  On most platforms that means checking for ~0 data.  If you
> see that, a PCI error *may* have occurred.
> 
> If you know that ~0 can never be valid, e.g., if you're reading a
> register where ~0 is not a valid value, you know for sure that an
> error has occurred.
> 
> If ~0 might be a valid value, e.g., if you're reading a buffer that
> contains arbitrary data, you have to look harder.   You might read a
> register than cannot contain ~0, and see if you get the data you
> expect.  Or you might read the Vendor ID or something from config
> space.
> 
> >  	value = readl(&hw_addr[reg]);
> >  
> >  	/* reads should not return all F's */
> > @@ -5308,6 +5312,18 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
> >  	return value;
> >  }
> >  
> > +void igc_wr32(struct igc_hw *hw, u32 reg, u32 val)
> > +{
> > +	struct igc_adapter *igc = container_of(hw, struct igc_adapter, hw);
> > +	u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
> > +
> > +	if (igc->pdev &&
> > +		igc->pdev->error_state == pci_channel_io_perm_failure)
> > +		return;
> > +
> > +	writel((val), &hw_addr[(reg)]);
> > +}
> > +
> >  int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx)
> >  {
> >  	struct igc_mac_info *mac = &adapter->hw.mac;
> > diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
> > index cc174853554b..eb4be87d0e8b 100644
> > --- a/drivers/net/ethernet/intel/igc/igc_regs.h
> > +++ b/drivers/net/ethernet/intel/igc/igc_regs.h
> > @@ -260,13 +260,10 @@ struct igc_hw;
> >  u32 igc_rd32(struct igc_hw *hw, u32 reg);
> >  
> >  /* write operations, indexed using DWORDS */
> > -#define wr32(reg, val) \
> > -do { \
> > -	u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
> > -	writel((val), &hw_addr[(reg)]); \
> > -} while (0)
> > +void igc_wr32(struct igc_hw *hw, u32 reg, u32 val);
> >  
> >  #define rd32(reg) (igc_rd32(hw, reg))
> > +#define wr32(reg, val) (igc_wr32(hw, reg, val))
> >  
> >  #define wrfl() ((void)rd32(IGC_STATUS))
> >  
> > -- 
> > 2.30.2
> > 
