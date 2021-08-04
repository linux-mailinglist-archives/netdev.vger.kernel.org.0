Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AE13E0509
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239424AbhHDP44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:56:56 -0400
Received: from ale.deltatee.com ([204.191.154.188]:54882 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239291AbhHDP4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:56:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:content-disposition;
        bh=edLu6Cm2waevaViy4+e8H4kzIcFfUqU7QKk3jRoHfWw=; b=RNkI5kEaav06zIgb28HYuGFDfu
        qfd84fdvFiobqN8bVox87BtjHmp4M8Jsm27fGYI3LjwLQ2IikEPSer8XmWxeYzpVUTlIeJXn1lJfP
        bDvexzPkOyvsF4inBNzddBBe79A5L4cbBzSYvuTywptSRUKWTIOIG0M5PPW9yg7Cl6FUXVFFIucrp
        5C4omuvrlK6EQG39pexRrr2Cqd22huUMkL8qrb6XLfgnYcR9521oXtK0sX+UgFvqYfVaH/oZ9jeJy
        TsvF81+X4tzfYKCdZvfIPRQQZWUuy75ZEYDHg3eTRdwkOIExc4V2gIenwmqgzcxt1Sg24h78/HLg3
        ttV24WVw==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1mBJG3-0003ET-Hj; Wed, 04 Aug 2021 09:56:40 -0600
To:     Dongdong Liu <liudongdong3@huawei.com>, helgaas@kernel.org,
        hch@infradead.org, kw@linux.com, leon@kernel.org,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org, netdev@vger.kernel.org
References: <1628084828-119542-1-git-send-email-liudongdong3@huawei.com>
 <1628084828-119542-10-git-send-email-liudongdong3@huawei.com>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <640662ff-e464-2cb5-318b-aa75d1ece1eb@deltatee.com>
Date:   Wed, 4 Aug 2021 09:56:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628084828-119542-10-git-send-email-liudongdong3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, linux-media@vger.kernel.org, hverkuil-cisco@xs4all.nl, rajur@chelsio.com, linux-pci@vger.kernel.org, leon@kernel.org, kw@linux.com, hch@infradead.org, helgaas@kernel.org, liudongdong3@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH V7 9/9] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-08-04 7:47 a.m., Dongdong Liu wrote:
> Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
> 10-Bit Tag Requester doesn't interact with a device that does not
> support 10-BIT Tag Completer. Before that happens, the kernel should
> emit a warning. "echo 0 > /sys/bus/pci/devices/.../10bit_tag" to
> disable 10-BIT Tag Requester for PF device.
> "echo 0 > /sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl" to disable
> 10-BIT Tag Requester for VF device.
> 
> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> ---
>  drivers/pci/p2pdma.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 50cdde3..948f2be 100644
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
> @@ -410,6 +411,41 @@ static unsigned long map_types_idx(struct pci_dev *client)
>  		(client->bus->number << 8) | client->devfn;
>  }
>  
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

I think the brackets around !comp are unnecessary.

> +		if (verbose) {
> +			pci_warn(a, "cannot be used for peer-to-peer DMA as 10-Bit Tag Requester enable is set in device (%s), but peer device (%s) does not support the 10-Bit Tag Completer\n",
> +				 pci_name(a), pci_name(b));
> +			if (a->is_virtfn)
> +				pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/sriov_vf_10bit_tag_ctl\n",
> +					 pci_name(a));
> +			else
> +				pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/10bit_tag\n",
> +					 pci_name(a));

Can we not simplify this slightly by having a const char * set to the
tag in the above if (a->is_virtfn)?

pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 >
/sys/bus/pci/devices/%s/%s\n", pci_name(a), tag);

> +		}
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  /*
>   * Calculate the P2PDMA mapping type and distance between two PCI devices.
>   *
> @@ -532,6 +568,10 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
>  	}
>  done:
> +	if (!check_10bit_tags_vaild(client, provider, verbose) ||
> +	    !check_10bit_tags_vaild(provider, client, verbose))
> +		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
> +
>  	rcu_read_lock();
>  	p2pdma = rcu_dereference(provider->p2pdma);
>  	if (p2pdma)
> 
