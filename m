Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8676F4BA6DE
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 18:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243622AbiBQRR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 12:17:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243623AbiBQRRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 12:17:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43706E364;
        Thu, 17 Feb 2022 09:17:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6060D616CB;
        Thu, 17 Feb 2022 17:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE57BC340E8;
        Thu, 17 Feb 2022 17:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645118228;
        bh=LKs9Cab54oNbBx1eoHnPqkl7xwmuTx9HwsajuytsITM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ml7XZ6y1q47yafLRWlx8Fhac3ysMBnc28QMcWPPps1ReBu9za68WN+foQub4XLarp
         qjkWiE3kWuTavFV1jqIwtk2k8F6MhLd2lSnQ3Isr5MfEt9xKt/JTcRM0JHnAKA8pyY
         Xl8bGLK0heH2zHgEuiIZ4h5Tl5/SnMTVJzGXn/xjsNml8Bqeqw4Ptv2OfSK3tlCPIX
         kA8LUm3Mc8S6TNYRXlQwRIE3ZLrYYFtkYeqo+4VvFhDpDaTazA53zZgAeCqGkKXsI+
         67RVkkey0JTMkcF6fc0pln2KIAoU9tPPGBlAjPnEXwULJLbRB+g/srB0KXzCWsf2kv
         35LiW6hhwvDPQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nKkOw-008dvO-KN; Thu, 17 Feb 2022 17:17:06 +0000
MIME-Version: 1.0
Date:   Thu, 17 Feb 2022 17:17:06 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     John Garry <john.garry@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com
Subject: Re: [PATCH 1/2] genirq: Extract irq_set_affinity_masks() from
 devm_platform_get_irqs_affinity()
In-Reply-To: <bdfe935b-6ee0-b588-e1e8-776d85f91813@huawei.com>
References: <20220216090845.1278114-1-maz@kernel.org>
 <20220216090845.1278114-2-maz@kernel.org>
 <bdfe935b-6ee0-b588-e1e8-776d85f91813@huawei.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <b502141b201a68eb4896c1653b67663a@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: john.garry@huawei.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gregkh@linuxfoundation.org, mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org, tglx@linutronix.de, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

On 2022-02-17 17:07, John Garry wrote:
> On 16/02/2022 09:08, Marc Zyngier wrote:
> 
> Hi Marc,
> 
>> In order to better support drivers that deal with interrupts in a more
>> "hands-on" way, extract the core of devm_platform_get_irqs_affinity()
>> and expose it as irq_set_affinity_masks().
>> 
>> This helper allows a driver to provide a set of wired interrupts that
>> are to be configured as managed interrupts. As with the original 
>> helper,
>> this is exported as EXPORT_SYMBOL_GPL.
> 
> I know you mentioned it in 2/2, but it would be interesting to see how
> network controller drivers can handle the problem of missing in-flight
> IO completions for managed irq shutdown. For storage controllers this
> is all now safely handled in the block layer.

Do you have a pointer to this? It'd be interesting to see if there is
a common pattern.

> 
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Just a small comment, below.
> 
> Tested-by: John Garry <john.garry@huawei.com> #D05
> 
> Thanks,
> John
> 
>> ---
>>   drivers/base/platform.c   | 20 +++-----------------
>>   include/linux/interrupt.h |  8 ++++++++
>>   kernel/irq/affinity.c     | 27 +++++++++++++++++++++++++++
>>   3 files changed, 38 insertions(+), 17 deletions(-)
>> 
>> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
>> index 6cb04ac48bf0..b363cf6ce5be 100644
>> --- a/drivers/base/platform.c
>> +++ b/drivers/base/platform.c
>> @@ -335,7 +335,6 @@ int devm_platform_get_irqs_affinity(struct 
>> platform_device *dev,
>>   				    int **irqs)
>>   {
>>   	struct irq_affinity_devres *ptr;
>> -	struct irq_affinity_desc *desc;
>>   	size_t size;
>>   	int i, ret, nvec;
>>   @@ -376,31 +375,18 @@ int devm_platform_get_irqs_affinity(struct 
>> platform_device *dev,
>>   		ptr->irq[i] = irq;
>>   	}
>>   -	desc = irq_create_affinity_masks(nvec, affd);
>> -	if (!desc) {
>> -		ret = -ENOMEM;
>> +	ret = irq_set_affinity_masks(affd, ptr->irq, nvec);
>> +	if (ret) {
>> +		dev_err(&dev->dev, "failed to update affinity descriptors (%d)\n", 
>> ret);
>>   		goto err_free_devres;
>>   	}
>>   -	for (i = 0; i < nvec; i++) {
>> -		ret = irq_update_affinity_desc(ptr->irq[i], &desc[i]);
>> -		if (ret) {
>> -			dev_err(&dev->dev, "failed to update irq%d affinity descriptor 
>> (%d)\n",
>> -				ptr->irq[i], ret);
>> -			goto err_free_desc;
>> -		}
>> -	}
>> -
>>   	devres_add(&dev->dev, ptr);
>>   -	kfree(desc);
>> -
>>   	*irqs = ptr->irq;
>>     	return nvec;
>>   -err_free_desc:
>> -	kfree(desc);
>>   err_free_devres:
>>   	devres_free(ptr);
>>   	return ret;
>> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
>> index 9367f1cb2e3c..6bfce96206f8 100644
>> --- a/include/linux/interrupt.h
>> +++ b/include/linux/interrupt.h
>> @@ -381,6 +381,8 @@ irq_create_affinity_masks(unsigned int nvec, 
>> struct irq_affinity *affd);
>>   unsigned int irq_calc_affinity_vectors(unsigned int minvec, unsigned 
>> int maxvec,
>>   				       const struct irq_affinity *affd);
>>   +int irq_set_affinity_masks(struct irq_affinity *affd, int *irqs, 
>> int nvec);
>> +
>>   #else /* CONFIG_SMP */
>>     static inline int irq_set_affinity(unsigned int irq, const struct 
>> cpumask *m)
>> @@ -443,6 +445,12 @@ irq_calc_affinity_vectors(unsigned int minvec, 
>> unsigned int maxvec,
>>   	return maxvec;
>>   }
>>   +static inline int
>> +irq_set_affinity_masks(struct irq_affinity *affd, int *irqs, int 
>> nvec)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>>   #endif /* CONFIG_SMP */
>>     /*
>> diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
>> index f7ff8919dc9b..c0f868cd5b87 100644
>> --- a/kernel/irq/affinity.c
>> +++ b/kernel/irq/affinity.c
>> @@ -512,3 +512,30 @@ unsigned int irq_calc_affinity_vectors(unsigned 
>> int minvec, unsigned int maxvec,
>>     	return resv + min(set_vecs, maxvec - resv);
>>   }
>> +
>> +/*
>> + * irq_set_affinity_masks - Set the affinity masks of a number of 
>> interrupts
>> + *                          for multiqueue spreading
>> + * @affd:	Description of the affinity requirements
>> + * @irqs:	An array of interrupt numbers
>> + * @nvec:	The total number of interrupts
>> + */
>> +int irq_set_affinity_masks(struct irq_affinity *affd, int *irqs, int 
>> nvec)
>> +{
>> +	struct irq_affinity_desc *desc;
>> +	int i, err = 0;
> 
> nit: it might be worth doing something similar to how
> pci_alloc_irq_vectors_affinity() handles sets with no pre- and
> post-vectors with msi_default_affd

Yes, good point. This would probably simplify most callers of this code.

Thanks,

           M.
-- 
Jazz is not dead. It just smells funny...
