Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D65F3D3D89
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhGWPpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:45:22 -0400
Received: from ale.deltatee.com ([204.191.154.188]:48514 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhGWPpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:45:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:content-disposition;
        bh=gnwjVSuqsjlehjAwMxxPG5BYBaf6ZJv7V08qy9lOWWE=; b=TDMMZTqYytUvc4t1ahiJ/Ilp9O
        8Ep10S3tiHtsLIfH8m9IFzIR6LEAjHPUrX0VwbWtA1Efv1NWlOyXwSiGu+U0AvAZ8Mfeje/GXxBgs
        eEFVyfHr8Z3yFuCHI8SjeXGBSS695i2KDOd1DbQjJO2NwaTaRq2/1QzXD9xa8p7xOYByw223k5nou
        sHd/KCEBdyBHQPzAEJmmzRP57IwrTLKJVZpl9n4s0EM7jq1tFPxvhKauIiCQRSyQJ9E1esOhq5/Ix
        2wD5T923ngHCMZTuWf+t36QgqOYRF1DN2oWEXBzCIqtm5TGhEX+XWPMQA3Ah1D8fg3tbbDlPQ+fgD
        IsQ+tJvA==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1m6xzj-00049R-Li; Fri, 23 Jul 2021 10:25:52 -0600
To:     Dongdong Liu <liudongdong3@huawei.com>, helgaas@kernel.org,
        hch@infradead.org, kw@linux.com, linux-pci@vger.kernel.org,
        rajur@chelsio.com, hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org, netdev@vger.kernel.org
References: <1627038402-114183-1-git-send-email-liudongdong3@huawei.com>
 <1627038402-114183-9-git-send-email-liudongdong3@huawei.com>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <24bc5deb-1fa3-8e81-2d9d-18836dc3aec9@deltatee.com>
Date:   Fri, 23 Jul 2021 10:25:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1627038402-114183-9-git-send-email-liudongdong3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, linux-media@vger.kernel.org, hverkuil-cisco@xs4all.nl, rajur@chelsio.com, linux-pci@vger.kernel.org, kw@linux.com, hch@infradead.org, helgaas@kernel.org, liudongdong3@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH V6 8/8] PCI/P2PDMA: Add a 10-bit tag check in P2PDMA
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On 2021-07-23 5:06 a.m., Dongdong Liu wrote:
> Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
> 10-Bit Tag Requester doesn't interact with a device that does not
> support 10-BIT tag Completer. Before that happens, the kernel should
> emit a warning saying to enable a ”pci=disable_10bit_tag=“ kernel
> parameter.
> 
> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> ---
>  drivers/pci/p2pdma.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 50cdde3..bd93840 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -19,6 +19,7 @@
>  #include <linux/random.h>
>  #include <linux/seq_buf.h>
>  #include <linux/xarray.h>
> +#include "pci.h"
>  
>  enum pci_p2pdma_map_type {
>  	PCI_P2PDMA_MAP_UNKNOWN = 0,
> @@ -541,6 +542,39 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  	return map_type;
>  }
>  
> +
> +static bool check_10bit_tags_vaild(struct pci_dev *a, struct pci_dev *b,
> +				   bool verbose)
> +{
> +	bool req;
> +	bool comp;
> +	u16 ctl2;
> +
> +	if (a->is_virtfn) {
> +#ifdef CONFIG_PCI_IOV
> +		req = !!(a->physfn->sriov->ctrl &
> +			 PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN);
> +#endif
> +	} else {
> +		pcie_capability_read_word(a, PCI_EXP_DEVCTL2, &ctl2);
> +		req = !!(ctl2 & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
> +	}
> +
> +	comp = !!(b->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP);
> +	if (req && (!comp)) {
> +		if (verbose) {
> +			pci_warn(a, "cannot be used for peer-to-peer DMA as 10-Bit Tag Requester enable is set in device (%s), but peer device (%s) does not support the 10-Bit Tag Completer\n",
> +				 pci_name(a), pci_name(b));
> +
> +			pci_warn(a, "to disable 10-Bit Tag Requester for this device, add the kernel parameter: pci=disable_10bit_tag=%s\n",
> +				 pci_name(a));
> +		}
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  /**
>   * pci_p2pdma_distance_many - Determine the cumulative distance between
>   *	a p2pdma provider and the clients in use.
> @@ -579,6 +613,10 @@ int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
>  			return -1;
>  		}
>  
> +		if (!check_10bit_tags_vaild(pci_client, provider, verbose) ||
> +		    !check_10bit_tags_vaild(provider, pci_client, verbose))
> +			not_supported = true;
> +

This check needs to be done in calc_map_type_and_dist(). The mapping
type needs to be correctly stored in the xarray cache as other functions
rely on the cached value (and upcoming work will be calling
calc_map_type_and_dist() without pci_p2pdma_distance_many()).

Logan
