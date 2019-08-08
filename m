Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7676C85E34
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 11:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732206AbfHHJZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 05:25:24 -0400
Received: from foss.arm.com ([217.140.110.172]:58772 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730678AbfHHJZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 05:25:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7BE571596;
        Thu,  8 Aug 2019 02:25:23 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDCCF3F73D;
        Thu,  8 Aug 2019 02:25:22 -0700 (PDT)
Date:   Thu, 8 Aug 2019 10:25:21 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     Bjorn Helgaas <bjorn.helgaas@gmail.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] liquidio: Use pcie_flr() instead of reimplementing it
Message-ID: <20190808092520.GR56241@e119886-lin.cambridge.arm.com>
References: <20190808045753.5474-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808045753.5474-1-efremov@linux.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 07:57:53AM +0300, Denis Efremov wrote:
> octeon_mbox_process_cmd() directly writes the PCI_EXP_DEVCTL_BCR_FLR
> bit, which bypasses timing requirements imposed by the PCIe spec.
> This patch fixes the function to use the pcie_flr() interface instead.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c b/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c
> index 021d99cd1665..614d07be7181 100644
> --- a/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c
> +++ b/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c
> @@ -260,9 +260,7 @@ static int octeon_mbox_process_cmd(struct octeon_mbox *mbox,
>  		dev_info(&oct->pci_dev->dev,
>  			 "got a request for FLR from VF that owns DPI ring %u\n",
>  			 mbox->q_no);
> -		pcie_capability_set_word(
> -			oct->sriov_info.dpiring_to_vfpcidev_lut[mbox->q_no],
> -			PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_BCR_FLR);
> +		pcie_flr(oct->sriov_info.dpiring_to_vfpcidev_lut[mbox->q_no]);
>  		break;

It's possible for pcie_flr to fail if the device doesn't become ready soon
enough after reset in which case it returns ENOTTY. I think it's OK not to
test the return value here though, as pci_dev_wait will print a warning
anyway, and I'm not sure what you'd do with it anyway.

Reviewed-by: Andrew Murray <andrew.murray@arm.com>

>  
>  	case OCTEON_PF_CHANGED_VF_MACADDR:
> -- 
> 2.21.0
> 
