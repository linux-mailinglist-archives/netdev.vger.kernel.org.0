Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0A186908
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 20:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390238AbfHHSs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 14:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733248AbfHHSs4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 14:48:56 -0400
Received: from localhost (unknown [150.199.191.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D96D217F4;
        Thu,  8 Aug 2019 18:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565290135;
        bh=8saPOc9eF4MfKRJj2H7a2FyxhNAS4xTWvf9A/IC17zI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BEJz+YCS2bReXtThO1QXjZZE7dKI+AnkKEU0wOKFhWEqkvitW4tu6UZSWyzJNzSNv
         5s4viP69j1DQtdXPnnB/lhPgvKdg0HP93srCM2rd5OHjTHaJ7dwnY6hdb3BgokxYXS
         4os1ynwrHWsXf0H0MZyRl7R7UfSWilbDwpkR+x/w=
Date:   Thu, 8 Aug 2019 13:48:54 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Denis Efremov <efremov@linux.com>
Cc:     Bjorn Helgaas <bjorn.helgaas@gmail.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] liquidio: Use pcie_flr() instead of reimplementing it
Message-ID: <20190808184854.GH151852@google.com>
References: <20190808045753.5474-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808045753.5474-1-efremov@linux.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

Thanks for doing this, Denis.  When possible it's better to use a PCI
core interface than to fiddle with PCI config space directly from a
driver.

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
>  
>  	case OCTEON_PF_CHANGED_VF_MACADDR:
> -- 
> 2.21.0
> 
