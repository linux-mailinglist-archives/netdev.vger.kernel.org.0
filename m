Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6F84FF32D
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbiDMJSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiDMJSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:18:48 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88831527D8
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 02:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649841387; x=1681377387;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2qSpWtdv+CVCutFYdNG9tJUBmh/HyA0LfKAybjefNE8=;
  b=Yp1ef5Uw+VCYZyCfEn8pkcURuD2QPIj+1Rssj2thW+XJaEpkcg7UfsxI
   MNiGVPwB5Xva97kG/IAt/CxoYEXgh07h16DxfUzCxo4pbl95wHiBCKsSX
   W2sGAWM27DU3tpjqipCgaccjGBtYBjez38ecb7tB3Y2gJ/aJJPvxxPPz7
   MhpBzvcdw8nIs5UEtMjQ7R9q3xRTi+LqppnV9naeh8zlTPergO3TeUO7J
   dtrg5DHwK5IUeUou52ZVMEhmXmzQSNoKeG61udrub1Q9J3dtJ21jZFP+J
   r9ewLa1heZU6aWkeX71Q2te+1OUkczYwbE4h+aPEvwgkPpXWnosNPcixB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="262796058"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="262796058"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 02:16:11 -0700
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="526867294"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.173.225]) ([10.249.173.225])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 02:16:09 -0700
Message-ID: <09a3613f-514b-c769-b8a0-25899b3d3159@intel.com>
Date:   Wed, 13 Apr 2022 17:16:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.0
Subject: Re: [PATCH] vDPA/ifcvf: assign nr_vring to the MSI vector of
 config_intr by default
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20220408121013.54709-1-lingshan.zhu@intel.com>
 <f3f60d6e-a506-bd58-d763-848beb0e4c26@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <f3f60d6e-a506-bd58-d763-848beb0e4c26@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2022 4:14 PM, Jason Wang wrote:
>
> 在 2022/4/8 下午8:10, Zhu Lingshan 写道:
>> This commit assign struct ifcvf_hw.nr_vring to the MSIX vector of the
>> config interrupt by default in ifcvf_request_config_irq().
>> ifcvf_hw.nr_vring is the most likely and the ideal case for
>> the device config interrupt handling, means every virtqueue has
>> an individual MSIX vector(0 ~ nr_vring - 1), and the config interrupt 
>> has
>> its own MSIX vector(number nr_vring).
>>
>> This change can also make GCC W = 2 happy, silence the
>> "uninitialized" warning.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index 4366320fb68d..b500fb941dab 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -290,13 +290,13 @@ static int ifcvf_request_config_irq(struct 
>> ifcvf_adapter *adapter)
>>       struct ifcvf_hw *vf = &adapter->vf;
>>       int config_vector, ret;
>>   +    /* vector 0 ~ vf->nr_vring for vqs, num vf->nr_vring vector 
>> for config interrupt */
>
>
> The comment is right before this patch, but probably wrong for 
> MSIX_VECTOR_DEV_SHARED.
This comment is for the case when every vq and config interrupt has its 
own vector, how
about a better comment "The ideal the default case, vector 0 ~ 
vf->nr_vring for vqs, num vf->nr_vring vector for config interrupt"
>
>
>> +    config_vector = vf->nr_vring;
>> +
>> +    /* re-use the vqs vector */
>>       if (vf->msix_vector_status == MSIX_VECTOR_DEV_SHARED)
>>           return 0;
>>   -    if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
>> -        /* vector 0 ~ vf->nr_vring for vqs, num vf->nr_vring vector 
>> for config interrupt */
>> -        config_vector = vf->nr_vring;
>> -
>>       if (vf->msix_vector_status == MSIX_VECTOR_SHARED_VQ_AND_CONFIG)
>>           /* vector 0 for vqs and 1 for config interrupt */
>>           config_vector = 1;
>
>
> Actually, I prefer to use if ... else ... here.
IMHO, if else may lead to mistakes.

The code:
         /* The ideal the default case, vector 0 ~ vf->nr_vring for vqs, 
num vf->nr_vring vector for config interrupt */
         config_vector = vf->nr_vring;

         /* re-use the vqs vector */
         if (vf->msix_vector_status == MSIX_VECTOR_DEV_SHARED)
                 return 0;

         if (vf->msix_vector_status == MSIX_VECTOR_SHARED_VQ_AND_CONFIG)
                 /* vector 0 for vqs and 1 for config interrupt */
                 config_vector = 1;


here by default config_vector = vf->nr_vring;
If msix_vector_status == MSIX_VECTOR_DEV_SHARED, it will reuse the dev 
shared vector, means using the vector(value 0) for data-vqs.
If msix_vector_status == MSIX_VECTOR_SHARED_VQ_AND_CONFIG, it will use 
vector=1(vector 0 for data-vqs).

If we use if...else, it will be:

         /* re-use the vqs vector */
         if (vf->msix_vector_status == MSIX_VECTOR_DEV_SHARED)
                 return 0;
         else
                 config_vector = 1;

This looks like config_vector can only be 0(re-used vector for the 
data-vqs, which is 0) or 1. It shadows the ideal and default case
config_vector = vf->nr_vring

Thanks,
Zhu Lingshan

>
> Thanks
>
>

