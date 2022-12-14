Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BA264D1C5
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 22:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiLNV1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 16:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiLNV0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 16:26:24 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B97B442E3;
        Wed, 14 Dec 2022 13:25:52 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3ECA5FEC;
        Wed, 14 Dec 2022 13:26:33 -0800 (PST)
Received: from [10.57.88.237] (unknown [10.57.88.237])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F106F3F71E;
        Wed, 14 Dec 2022 13:25:50 -0800 (PST)
Message-ID: <a3a034b5-9493-e345-bcb4-8c5eef7f9a65@arm.com>
Date:   Wed, 14 Dec 2022 21:25:45 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] iommu/arm-smmu: don't unregister on shutdown
Content-Language: en-GB
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     iommu@lists.linux.dev, Will Deacon <will@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org
References: <20221208165350.3895136-1-vladimir.oltean@nxp.com>
 <d3517811-232c-592d-f973-2870bb5ec3ac@arm.com>
 <20221214173418.iwovyxlbogkspjxy@skbuf>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20221214173418.iwovyxlbogkspjxy@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-12-14 17:34, Vladimir Oltean wrote:
> On Fri, Dec 09, 2022 at 11:24:32AM +0000, Robin Murphy wrote:
>>> Fixes: b06c076ea962 ("Revert "iommu/arm-smmu: Make arm-smmu explicitly non-modular"")
>>
>> I think that's semantically correct, but I'm pretty sure at that point it
>> would have been benign in practice - the observable splat will be a much
>> more recent fallout from me changing the iommu_device_unregister() behaviour
>> in 57365a04c921 ("iommu: Move bus setup to IOMMU device registration"). The
>> assumption therein is that unregister would only happen on probe failure,
>> before the IOMMU instance is in use, or on module unload, which would not be
>> allowed while active devices still hold module references. I overlooked that
>> the SMMU drivers were doing what they do, sorry about that.
> 
> Ok, I'll change the Fixes: tag, I didn't notice that iommu_device_unregister()
> changed in behavior only later, I just looked at current trees and tried
> to infer what went wrong.
> 
>> The change itself looks sensible. The point of this shutdown hook is simply
>> not to leave active translations in place that might confuse future software
>> after reboot/kexec; any housekeeping in the current kernel state is a waste
>> of time anyway. Fancy doing the same for SMMUv3 as well?
> 
> I can try, but I won't have hardware to test.
> 
> Basically the only thing truly relevant for shutdown from arm_smmu_device_remove()
> is arm_smmu_device_disable(), would you agree to a patch which changes
> things as below?
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 6d5df91c5c46..d4d8bfee9feb 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3854,7 +3854,9 @@ static int arm_smmu_device_remove(struct platform_device *pdev)
>   
>   static void arm_smmu_device_shutdown(struct platform_device *pdev)
>   {
> -	arm_smmu_device_remove(pdev);
> +	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
> +
> +	arm_smmu_device_disable(smmu);
>   }
>   
>   static const struct of_device_id arm_smmu_of_match[] = {


Looks fine to me! I'll let Will decide if he'd still prefer to do the 
full remove-calls-shutdown reversal here as well for complete 
consistency, but I reckon the minimal diff is no bad thing :)

Cheers,
Robin.
