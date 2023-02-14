Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E09A695530
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 01:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjBNAHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 19:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjBNAHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 19:07:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A841A5E4;
        Mon, 13 Feb 2023 16:07:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16C7061365;
        Tue, 14 Feb 2023 00:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51379C433EF;
        Tue, 14 Feb 2023 00:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676333232;
        bh=pRj2BVU2v4OZ18AUkeMZ3IM4RtotAlg62LcBLHl11Hg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=GGycTkDWHs6urJl+VdQKWa9DY6hK4oF+ZON6KngYZCJfUshHsYUdobNWCAz0Xg+/6
         yRSDBfsTsE+mybZiPwRI8XEOVbxibiMUwXbEbe8B1mgPUn3M0RExg5Dc6E0zAhjBWv
         0FevWDWTgrsTyd/3tA/TR1Tg0kpCheXFYHIwt99p3zMk/vO25pGg2rgvabFmoq8CId
         uY3RmYs8lqR+OLIX8ihr+DtaYE/MGWtYLMXhsRx1Jg7I1DGFz2yYCxDGF2legLcSYA
         ffTwonHugnMTutqn+c+2GkPClm4V74Xg1XrxWynsGnsHggrLsQqrXad030QTrQU/ho
         HaCXVs30ZrpnQ==
Date:   Mon, 13 Feb 2023 18:07:10 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: Add ACS quirk for Wangxun NICs
Message-ID: <20230214000710.GA2951479@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207102419.44326-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 06:24:19PM +0800, Mengyuan Lou wrote:
> Wangxun has verified there is no peer-to-peer between functions for the
> below selection of SFxxx, RP1000 and RP2000 NICS.
> They may be multi-function device, but the hardware does not advertise
> ACS capability.
> 
> Add an ACS quirk for these devices so the functions can be in
> independent IOMMU groups.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>

Applied to pci/virtualization for v6.3, thanks!

> ---
>  drivers/pci/quirks.c    | 22 ++++++++++++++++++++++
>  include/linux/pci_ids.h |  2 ++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 285acc4aaccc..13290048beda 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -4835,6 +4835,26 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
>  		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
>  }
>  
> +/*
> + * Wangxun 10G/1G NICs have no ACS capability, and on multi-function
> + * devices, peer-to-peer transactions are not be used between the functions.
> + * So add an ACS quirk for below devices to isolate functions.
> + * SFxxx 1G NICs(em).
> + * RP1000/RP2000 10G NICs(sp).
> + */
> +static int  pci_quirk_wangxun_nic_acs(struct pci_dev *dev, u16 acs_flags)
> +{
> +	switch (dev->device) {
> +	case 0x0100 ... 0x010F:
> +	case 0x1001:
> +	case 0x2001:
> +		return pci_acs_ctrl_enabled(acs_flags,
> +			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
> +	}
> +
> +	return false;
> +}
> +
>  static const struct pci_dev_acs_enabled {
>  	u16 vendor;
>  	u16 device;
> @@ -4980,6 +5000,8 @@ static const struct pci_dev_acs_enabled {
>  	{ PCI_VENDOR_ID_NXP, 0x8d9b, pci_quirk_nxp_rp_acs },
>  	/* Zhaoxin Root/Downstream Ports */
>  	{ PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
> +	/* Wangxun nics */
> +	{ PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID, pci_quirk_wangxun_nic_acs },
>  	{ 0 }
>  };
>  
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index b362d90eb9b0..bc8f484cdcf3 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -3012,6 +3012,8 @@
>  #define PCI_DEVICE_ID_INTEL_VMD_9A0B	0x9a0b
>  #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
>  
> +#define PCI_VENDOR_ID_WANGXUN		0x8088
> +
>  #define PCI_VENDOR_ID_SCALEMP		0x8686
>  #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL	0x1010
>  
> -- 
> 2.39.1
> 
