Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2479B3321E6
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 10:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCIJYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 04:24:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229904AbhCIJYL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 04:24:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5CD365220;
        Tue,  9 Mar 2021 09:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615281851;
        bh=zqYsWNc7GUSYDncYfdIBCR1QYoEiiN+BQfzc8mgWg38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dz5HG0btJh4fDa/9raLK7lOr+0mR5yOtLtZuNQW1EJtxEXHG5LGRFopOiG2nVYWsH
         YZlC/SJkuCHSrlN9cdyjkJI+ZOAmXaUzCfpncblh5lA7oHzk+/JnxHhuyyxBt9sTfq
         bY0IzDzhwzeN61n3p5oVEJO4QjCbXHiUHTDsBEW0=
Date:   Tue, 9 Mar 2021 10:24:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: Re: [PATCH v10 03/20] dlb: add resource and device initialization
Message-ID: <YEc+uL3SSf/T+EuG@kroah.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-4-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210175423.1873-4-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 11:54:06AM -0600, Mike Ximing Chen wrote:
> --- a/drivers/misc/dlb/dlb_hw_types.h
> +++ b/drivers/misc/dlb/dlb_hw_types.h
> @@ -5,6 +5,13 @@
>  #define __DLB_HW_TYPES_H
>  
>  #include <linux/io.h>
> +#include <linux/types.h>
> +
> +#include "dlb_bitmap.h"
> +
> +#define BITS_SET(x, val, mask)	(x = ((x) & ~(mask))     \
> +				 | (((val) << (mask##_LOC)) & (mask)))
> +#define BITS_GET(x, mask)       (((x) & (mask)) >> (mask##_LOC))

Why not use the built-in kernel functions for this?  Why are you
creating your own?



> -static void
> -dlb_pf_unmap_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)
> +static void dlb_pf_unmap_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)

Why reformat code here, and not do it right the first time around?

>  {
>  	pcim_iounmap(pdev, dlb->hw.csr_kva);
>  	pcim_iounmap(pdev, dlb->hw.func_kva);
>  }
>  
> -static int
> -dlb_pf_map_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)
> +static int dlb_pf_map_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)

Same here.

>  {
>  	dlb->hw.func_kva = pcim_iomap_table(pdev)[DLB_FUNC_BAR];
>  	dlb->hw.func_phys_addr = pci_resource_start(pdev, DLB_FUNC_BAR);
> @@ -40,6 +42,59 @@ dlb_pf_map_pci_bar_space(struct dlb *dlb, struct pci_dev *pdev)
>  	return 0;
>  }
>  
> +/*******************************/
> +/****** Driver management ******/
> +/*******************************/
> +
> +static int dlb_pf_init_driver_state(struct dlb *dlb)
> +{
> +	mutex_init(&dlb->resource_mutex);
> +
> +	return 0;

If this can not fail, why is this not just void?

> diff --git a/drivers/misc/dlb/dlb_resource.h b/drivers/misc/dlb/dlb_resource.h
> new file mode 100644
> index 000000000000..2229813d9c45
> --- /dev/null
> +++ b/drivers/misc/dlb/dlb_resource.h

Why do you have lots of little .h files and not just one simple .h file
for the driver?  That makes it much easier to maintain over time, right?

thanks,

greg k-h
