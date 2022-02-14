Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA58A4B4218
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 07:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240859AbiBNGqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 01:46:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238360AbiBNGqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 01:46:47 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DF050459
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 22:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644821200; x=1676357200;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZGj9voo8I7sXbIYBeJ46GSRktKG2MGshoNrofLO6uZQ=;
  b=MkXaOdl9tzV4f7BYlqusrpKGIpJgC9VumkKYvnNNkurpB9s68ereXm1E
   zXOEauojPUPuyrpXR+Mg+grkHCh6P2Q1KEzqE2jAz1uwRGhgFqjc0vw4L
   ljdJ8P8w5Ulu6uT58VK69xTiowohSZhunvyFYBKNun1EnCqvDKYTATS7H
   oza6oghBMVpjBBziE95Km/Kg91nAJnTQiMooAd7C9S3MOxL5umvOzGIsM
   mbuMNwRcJ399HkE1DJU8WPGEe3tjo74KaoSzZHFatUfhMwOKaKg59/JZ1
   DCwiExm1rAmKMkF5StxPEwZTB0bDnKnITY8NDuYp2AQIRRDd7pNBFR3bD
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="237437641"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="237437641"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 22:46:40 -0800
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="543241381"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.175.112]) ([10.249.175.112])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 22:46:38 -0800
Message-ID: <ed86c924-f53e-4ae0-bc8a-0d44c675ab07@intel.com>
Date:   Mon, 14 Feb 2022 14:46:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.1
Subject: Re: [PATCH V4 2/4] vDPA/ifcvf: implement device MSIX vector allocator
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220203072735.189716-1-lingshan.zhu@intel.com>
 <20220203072735.189716-3-lingshan.zhu@intel.com>
 <8dc502ae-848d-565e-bdef-88bdd6b8053f@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <8dc502ae-848d-565e-bdef-88bdd6b8053f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/2022 2:26 PM, Jason Wang wrote:
>
> 在 2022/2/3 下午3:27, Zhu Lingshan 写道:
>> This commit implements a MSIX vector allocation helper
>> for vqs and config interrupts.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 35 +++++++++++++++++++++++++++++++--
>>   1 file changed, 33 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index d1a6b5ab543c..44c89ab0b6da 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -58,14 +58,45 @@ static void ifcvf_free_irq(struct ifcvf_adapter 
>> *adapter, int queues)
>>       ifcvf_free_irq_vectors(pdev);
>>   }
>>   +/* ifcvf MSIX vectors allocator, this helper tries to allocate
>> + * vectors for all virtqueues and the config interrupt.
>> + * It returns the number of allocated vectors, negative
>> + * return value when fails.
>> + */
>> +static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
>> +{
>> +    struct pci_dev *pdev = adapter->pdev;
>> +    struct ifcvf_hw *vf = &adapter->vf;
>> +    int max_intr, ret;
>> +
>> +    /* all queues and config interrupt  */
>> +    max_intr = vf->nr_vring + 1;
>> +    ret = pci_alloc_irq_vectors(pdev, 1, max_intr, PCI_IRQ_MSIX | 
>> PCI_IRQ_AFFINITY);
>> +
>> +    if (ret < 0) {
>> +        IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
>> +        return ret;
>> +    }
>> +
>> +    if (ret < max_intr)
>> +        IFCVF_INFO(pdev,
>> +               "Requested %u vectors, however only %u allocated, 
>> lower performance\n",
>> +               max_intr, ret);
>> +
>> +    return ret;
>> +}
>> +
>>   static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>>   {
>>       struct pci_dev *pdev = adapter->pdev;
>>       struct ifcvf_hw *vf = &adapter->vf;
>> -    int vector, i, ret, irq;
>> +    int vector, nvectors, i, ret, irq;
>>       u16 max_intr;
>>   -    /* all queues and config interrupt  */
>> +    nvectors = ifcvf_alloc_vectors(adapter);
>> +    if (!(nvectors > 0))
>> +        return nvectors;
>
>
> Why not simply checking by using nvectors <= 0? If ifcvf_alloc_vectors 
> can return 0 this breaks the ifcvf_request_irq() caller's assumption.
It can return zero if no vectors allocated, then ifcvf_request_irq 
fails. For sure I can use <=0

Thanks!
>
>
>> +
>>       max_intr = vf->nr_vring + 1;
>>         ret = pci_alloc_irq_vectors(pdev, max_intr,
>
>
> So irq is allocated twice here?
Oh, it is a rebasing problem, I should move the deleting line here from 
the next patch.

Thanks
>
> Thanks
>
>

