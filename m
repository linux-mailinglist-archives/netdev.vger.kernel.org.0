Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039A24BA6BD
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 18:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242153AbiBQRIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 12:08:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243575AbiBQRIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 12:08:09 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F110171852;
        Thu, 17 Feb 2022 09:07:51 -0800 (PST)
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K01TB1dVmz682vL;
        Fri, 18 Feb 2022 01:06:54 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Feb 2022 18:07:49 +0100
Received: from [10.47.81.42] (10.47.81.42) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 17 Feb
 2022 17:07:48 +0000
Message-ID: <bdfe935b-6ee0-b588-e1e8-776d85f91813@huawei.com>
Date:   Thu, 17 Feb 2022 17:07:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 1/2] genirq: Extract irq_set_affinity_masks() from
 devm_platform_get_irqs_affinity()
To:     Marc Zyngier <maz@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, <kernel-team@android.com>
References: <20220216090845.1278114-1-maz@kernel.org>
 <20220216090845.1278114-2-maz@kernel.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220216090845.1278114-2-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.81.42]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/02/2022 09:08, Marc Zyngier wrote:

Hi Marc,

> In order to better support drivers that deal with interrupts in a more
> "hands-on" way, extract the core of devm_platform_get_irqs_affinity()
> and expose it as irq_set_affinity_masks().
> 
> This helper allows a driver to provide a set of wired interrupts that
> are to be configured as managed interrupts. As with the original helper,
> this is exported as EXPORT_SYMBOL_GPL.

I know you mentioned it in 2/2, but it would be interesting to see how 
network controller drivers can handle the problem of missing in-flight 
IO completions for managed irq shutdown. For storage controllers this is 
all now safely handled in the block layer.

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Just a small comment, below.

Tested-by: John Garry <john.garry@huawei.com> #D05

Thanks,
John

> ---
>   drivers/base/platform.c   | 20 +++-----------------
>   include/linux/interrupt.h |  8 ++++++++
>   kernel/irq/affinity.c     | 27 +++++++++++++++++++++++++++
>   3 files changed, 38 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 6cb04ac48bf0..b363cf6ce5be 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -335,7 +335,6 @@ int devm_platform_get_irqs_affinity(struct platform_device *dev,
>   				    int **irqs)
>   {
>   	struct irq_affinity_devres *ptr;
> -	struct irq_affinity_desc *desc;
>   	size_t size;
>   	int i, ret, nvec;
>   
> @@ -376,31 +375,18 @@ int devm_platform_get_irqs_affinity(struct platform_device *dev,
>   		ptr->irq[i] = irq;
>   	}
>   
> -	desc = irq_create_affinity_masks(nvec, affd);
> -	if (!desc) {
> -		ret = -ENOMEM;
> +	ret = irq_set_affinity_masks(affd, ptr->irq, nvec);
> +	if (ret) {
> +		dev_err(&dev->dev, "failed to update affinity descriptors (%d)\n", ret);
>   		goto err_free_devres;
>   	}
>   
> -	for (i = 0; i < nvec; i++) {
> -		ret = irq_update_affinity_desc(ptr->irq[i], &desc[i]);
> -		if (ret) {
> -			dev_err(&dev->dev, "failed to update irq%d affinity descriptor (%d)\n",
> -				ptr->irq[i], ret);
> -			goto err_free_desc;
> -		}
> -	}
> -
>   	devres_add(&dev->dev, ptr);
>   
> -	kfree(desc);
> -
>   	*irqs = ptr->irq;
>   
>   	return nvec;
>   
> -err_free_desc:
> -	kfree(desc);
>   err_free_devres:
>   	devres_free(ptr);
>   	return ret;
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 9367f1cb2e3c..6bfce96206f8 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -381,6 +381,8 @@ irq_create_affinity_masks(unsigned int nvec, struct irq_affinity *affd);
>   unsigned int irq_calc_affinity_vectors(unsigned int minvec, unsigned int maxvec,
>   				       const struct irq_affinity *affd);
>   
> +int irq_set_affinity_masks(struct irq_affinity *affd, int *irqs, int nvec);
> +
>   #else /* CONFIG_SMP */
>   
>   static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
> @@ -443,6 +445,12 @@ irq_calc_affinity_vectors(unsigned int minvec, unsigned int maxvec,
>   	return maxvec;
>   }
>   
> +static inline int
> +irq_set_affinity_masks(struct irq_affinity *affd, int *irqs, int nvec)
> +{
> +	return -EINVAL;
> +}
> +
>   #endif /* CONFIG_SMP */
>   
>   /*
> diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
> index f7ff8919dc9b..c0f868cd5b87 100644
> --- a/kernel/irq/affinity.c
> +++ b/kernel/irq/affinity.c
> @@ -512,3 +512,30 @@ unsigned int irq_calc_affinity_vectors(unsigned int minvec, unsigned int maxvec,
>   
>   	return resv + min(set_vecs, maxvec - resv);
>   }
> +
> +/*
> + * irq_set_affinity_masks - Set the affinity masks of a number of interrupts
> + *                          for multiqueue spreading
> + * @affd:	Description of the affinity requirements
> + * @irqs:	An array of interrupt numbers
> + * @nvec:	The total number of interrupts
> + */
> +int irq_set_affinity_masks(struct irq_affinity *affd, int *irqs, int nvec)
> +{
> +	struct irq_affinity_desc *desc;
> +	int i, err = 0;

nit: it might be worth doing something similar to how 
pci_alloc_irq_vectors_affinity() handles sets with no pre- and 
post-vectors with msi_default_affd

> +
> +	desc = irq_create_affinity_masks(nvec, affd);
> +	if (!desc)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < nvec; i++) {
> +		err = irq_update_affinity_desc(irqs[i], desc + i);
> +		if (err)
> +			break;
> +	}
> +
> +	kfree(desc);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(irq_set_affinity_masks);

