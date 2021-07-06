Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FD23BDE49
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 22:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhGFUPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 16:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhGFUPV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 16:15:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DA3861C30;
        Tue,  6 Jul 2021 20:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625602362;
        bh=dMozURTgCDtE/nqPAO74mQrk2jYpZIJHRjna9oZLlBU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Db9XAFhBa72OXFLdJe6GXAe/gZDR5QG+hGO3+xDnHonYYM+FlgwPWSvgSrm3bQusq
         osIxRYJYffsfg/KpY4b0tIRSr6pZqEjha6bo02sIuLPPIJBvj647EIJ+DXg0wl5v35
         qLWfmZPBhiuDvHy5bu8WAfzk1WV9DgRLVUGWwoHSLto66tapyWeaSr6hz7Fu+SK5VH
         GlqYDmEAtWv9gkTKACbrruIxwI01aGoGf17XGYPVMKysWaM2E+bcJdhXhL1iK/J0Ro
         W0UCW+oKJri7o2LOVn5bjsEo0uukvIzqnFCIPE6d1Kfvy8V5I1GeFZKiGxbXDdg/Hj
         sAiqAbLwoPEFQ==
Date:   Tue, 6 Jul 2021 15:12:41 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
Message-ID: <20210706201241.GA820992@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702045120.22855-1-aaron.ma@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 12:51:19PM +0800, Aaron Ma wrote:
> Check PCI state when rd/wr iomem.
> Implement wr32 function as rd32 too.
> 
> When unplug TBT dock with i225, rd/wr PCI iomem will cause error log:
> Trace:
> BUG: unable to handle page fault for address: 000000000000b604
> Oops: 0000 [#1] SMP NOPTI
> RIP: 0010:igc_rd32+0x1c/0x90 [igc]
> Call Trace:
> igc_ptp_suspend+0x6c/0xa0 [igc]
> igc_ptp_stop+0x12/0x50 [igc]
> igc_remove+0x7f/0x1c0 [igc]
> pci_device_remove+0x3e/0xb0
> __device_release_driver+0x181/0x240
> 
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c | 16 ++++++++++++++++
>  drivers/net/ethernet/intel/igc/igc_regs.h |  7 ++-----
>  2 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index f1adf154ec4a..606b72cb6193 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -5292,6 +5292,10 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
>  	u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
>  	u32 value = 0;
>  
> +	if (igc->pdev &&
> +		igc->pdev->error_state == pci_channel_io_perm_failure)
> +		return 0;

I don't think this solves the problem.

  - Driver calls igc_rd32().

  - "if (pci_channel_io_perm_failure)" evaluates to false (error_state
    does not indicate an error).

  - Device is unplugged.

  - igc_rd32() calls readl(), which performs MMIO read, which fails
    because the device is no longer present.  readl() returns ~0 on
    most platforms.

  - Same page fault occurs.

The only way is to check *after* the MMIO read to see whether an error
occurred.  On most platforms that means checking for ~0 data.  If you
see that, a PCI error *may* have occurred.

If you know that ~0 can never be valid, e.g., if you're reading a
register where ~0 is not a valid value, you know for sure that an
error has occurred.

If ~0 might be a valid value, e.g., if you're reading a buffer that
contains arbitrary data, you have to look harder.   You might read a
register than cannot contain ~0, and see if you get the data you
expect.  Or you might read the Vendor ID or something from config
space.

>  	value = readl(&hw_addr[reg]);
>  
>  	/* reads should not return all F's */
> @@ -5308,6 +5312,18 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
>  	return value;
>  }
>  
> +void igc_wr32(struct igc_hw *hw, u32 reg, u32 val)
> +{
> +	struct igc_adapter *igc = container_of(hw, struct igc_adapter, hw);
> +	u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
> +
> +	if (igc->pdev &&
> +		igc->pdev->error_state == pci_channel_io_perm_failure)
> +		return;
> +
> +	writel((val), &hw_addr[(reg)]);
> +}
> +
>  int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx)
>  {
>  	struct igc_mac_info *mac = &adapter->hw.mac;
> diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
> index cc174853554b..eb4be87d0e8b 100644
> --- a/drivers/net/ethernet/intel/igc/igc_regs.h
> +++ b/drivers/net/ethernet/intel/igc/igc_regs.h
> @@ -260,13 +260,10 @@ struct igc_hw;
>  u32 igc_rd32(struct igc_hw *hw, u32 reg);
>  
>  /* write operations, indexed using DWORDS */
> -#define wr32(reg, val) \
> -do { \
> -	u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
> -	writel((val), &hw_addr[(reg)]); \
> -} while (0)
> +void igc_wr32(struct igc_hw *hw, u32 reg, u32 val);
>  
>  #define rd32(reg) (igc_rd32(hw, reg))
> +#define wr32(reg, val) (igc_wr32(hw, reg, val))
>  
>  #define wrfl() ((void)rd32(IGC_STATUS))
>  
> -- 
> 2.30.2
> 
