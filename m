Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60161399553
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhFBVU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFBVU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 17:20:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCB7E613AE;
        Wed,  2 Jun 2021 21:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622668725;
        bh=vLm9f4OJBRNnhlAYOC2+3CT7atKENDAXA3VtloijboQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=RslOVZb2UlQcLUqTmxFpYVoYkApRddiRHyY7u517bi9raKXKDRwG8g43rKCE6kCL3
         Ut05i8OkP71G2IqHDDuCUnn+ksJsklfbNY6SgSLIelvAp/A+w8Fh3zEKFkbZ+lkfE4
         7SKvTy8SLvAZi6WWlWlH8Enmpcs2svUx7vRAAEF7YsueyW6aKYHGqMxZIunWVIgoNY
         zTAqN04o1TGo/gGgiXI9VWTa42qZrbeF3/RGal6gBzuXVsP9brc56nzG2ZGKW86Leh
         Rd6LmLpmx/yHT1sWIvy8qBkMFfb8gFogNtM+KmLJqriWH419v5t6anE87ZYysIxYJ1
         rLP+OlMP0Fuww==
Date:   Wed, 2 Jun 2021 16:18:42 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, bhelgaas@google.com, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: Re: [PATCH] pci: Add ACS quirk for Broadcom NIC.
Message-ID: <20210602211842.GA2048572@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621645997-16251-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 09:13:17PM -0400, Michael Chan wrote:
> From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
> 
> Some Broadcom NICs such as the BCM57414 do not advertise PCI-ACS
> capability. All functions on such devices are placed under the same
> IOMMU group. Attaching a single PF to a userspace application like
> OVS-DPDK using VFIO is not possible, since not all functions in the
> IOMMU group are bound to VFIO.
> 
> Since peer-to-peer transactions are not possible between PFs on these
> devices, it is safe to treat them as fully isolated even though the ACS
> capability is not advertised. Fix this issue by adding a PCI quirk for
> this chip.
> 
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Applied to pci/virtualization for v5.14, thanks!

I adjusted the subject and commit message to follow the typical style:

    PCI: Add ACS quirk for Broadcom BCM57414 NIC

    The Broadcom BCM57414 NIC may be a multi-function device.  While it does
    not advertise an ACS capability, peer-to-peer transactions are not possible
    between the individual functions, so it is safe to treat them as fully
    isolated.

    Add an ACS quirk for this device so the functions can be in independent
    IOMMU groups and attached individually to userspace applications using
    VFIO.

> ---
>  drivers/pci/quirks.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index dcb229de1acb..cb1628e222df 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -4753,6 +4753,8 @@ static const struct pci_dev_acs_enabled {
>  	{ PCI_VENDOR_ID_AMPERE, 0xE00A, pci_quirk_xgene_acs },
>  	{ PCI_VENDOR_ID_AMPERE, 0xE00B, pci_quirk_xgene_acs },
>  	{ PCI_VENDOR_ID_AMPERE, 0xE00C, pci_quirk_xgene_acs },
> +	/* Broadcom multi-function device */
> +	{ PCI_VENDOR_ID_BROADCOM, 0x16D7, pci_quirk_mf_endpoint_acs },
>  	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
>  	/* Amazon Annapurna Labs */
>  	{ PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS, 0x0031, pci_quirk_al_acs },
> -- 
> 2.18.1
> 
