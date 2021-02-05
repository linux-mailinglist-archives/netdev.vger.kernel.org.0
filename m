Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BE83113D9
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 22:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhBEVrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 16:47:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232525AbhBEVrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 16:47:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 519EC64DFD;
        Fri,  5 Feb 2021 21:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612561583;
        bh=2McPkCXon2pKG5PSuW3NFwUtwFl4XnvVTNdISzVq+ec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=sblQCqKN89uSvgcZpkK2V3fGqixjtx8dGk6Nx7fmuNBGd5Iz7ydfCGAe4nA3pMuKS
         o8nkZ65BL+4QLUQI1y9jQ8aNOBa672RMCyxRQBWbhMc6UoJxt53cyD0Swsy63iGghn
         3KJ5j7bWl19Pf09sxlAv8fx7VmGAh17m5XQMBBogo/ZMFX1JFmFY6EBZXkccZ3rwcb
         EAgj1AXeTq89xbBMvmpuMb6I3bOFSw5yHPuaxURSDZRy7a+X++gsg3KL15c4bAkRzW
         qvrFJ+QVDjuNHHgibJuOvUuhOH4DnRo9WQQXQtEMiPbA2w1ZvVVM0zqouSMd0zvKmi
         bvlU8JwTZzSXw==
Date:   Fri, 5 Feb 2021 15:46:21 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Casey Leedom <leedom@chelsio.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Subject: Re: [PATCH resend net-next v2 2/3] PCI/VPD: Change Chelsio T4 quirk
 to provide access to full virtual address space
Message-ID: <20210205214621.GA198699@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bf6319f-acaa-c114-d10b-cb9b7d469968@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Casey, Rahul]

On Fri, Feb 05, 2021 at 08:29:45PM +0100, Heiner Kallweit wrote:
> cxgb4 uses the full VPD address space for accessing its EEPROM (with some
> mapping, see t4_eeprom_ptov()). In cudbg_collect_vpd_data() it sets the
> VPD len to 32K (PCI_VPD_MAX_SIZE), and then back to 2K (CUDBG_VPD_PF_SIZE).
> Having official (structured) and inofficial (unstructured) VPD data
> violates the PCI spec, let's set VPD len according to all data that can be
> accessed via PCI VPD access, no matter of its structure.

s/inofficial/unofficial/

> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/pci/vpd.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
> index 7915d10f9..06a7954d0 100644
> --- a/drivers/pci/vpd.c
> +++ b/drivers/pci/vpd.c
> @@ -633,9 +633,8 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
>  	/*
>  	 * If this is a T3-based adapter, there's a 1KB VPD area at offset
>  	 * 0xc00 which contains the preferred VPD values.  If this is a T4 or
> -	 * later based adapter, the special VPD is at offset 0x400 for the
> -	 * Physical Functions (the SR-IOV Virtual Functions have no VPD
> -	 * Capabilities).  The PCI VPD Access core routines will normally
> +	 * later based adapter, provide access to the full virtual EEPROM
> +	 * address space. The PCI VPD Access core routines will normally
>  	 * compute the size of the VPD by parsing the VPD Data Structure at
>  	 * offset 0x000.  This will result in silent failures when attempting
>  	 * to accesses these other VPD areas which are beyond those computed
> @@ -644,7 +643,7 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
>  	if (chip == 0x0 && prod >= 0x20)
>  		pci_set_vpd_size(dev, 8192);
>  	else if (chip >= 0x4 && func < 0x8)
> -		pci_set_vpd_size(dev, 2048);
> +		pci_set_vpd_size(dev, PCI_VPD_MAX_SIZE);

This code was added by 7dcf688d4c78 ("PCI/cxgb4: Extend T3 PCI quirk
to T4+ devices") [1].  Unfortunately that commit doesn't really have
the details about what it fixes, other than the silent failures it
mentions in the comment.

Some devices hang if we try to read at the wrong VPD address, and this
can be done via the sysfs "vpd" file.  Can you expand the commit log
with an argument for why it is always safe to set the size to
PCI_VPD_MAX_SIZE for these devices?

The fact that cudbg_collect_vpd_data() fiddles around with
pci_set_vpd_size() suggests to me that there is *some* problem with
reading parts of the VPD.  Otherwise, why would they bother?

940c9c458866 ("cxgb4: collect vpd info directly from hardware") [2]
added the pci_set_vpd_size() usage, but doesn't say why it's needed.
Maybe Rahul will remember?

Bjorn

[1] https://git.kernel.org/linus/7dcf688d4c78
[2] https://git.kernel.org/linus/940c9c458866

>  }
>  
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
> -- 
> 2.30.0
> 
> 
> 
