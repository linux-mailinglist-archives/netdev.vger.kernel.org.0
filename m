Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2603D49C974
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241177AbiAZMSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:18:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:40001 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241163AbiAZMSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 07:18:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643199520; x=1674735520;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h21d21xAAT2Hg/qURf1VRhMla2qIBkbLMCX9YL7kGUQ=;
  b=XPFZ+nZIQUPYFi4DklT/sKNxi4UAP2Cxdp7W9HzraVdbdK5P4pkzbN8n
   2l/Ujf8sfimIoGWTgsC4kLZdd3UEwNSI/BJN9F07CpLJghpOkJxH8JD9q
   CQPCmfJioPBX9T7qsehtuNwZMU3DzERUbJVzbllFw3+2Ld+ndk1xDykhH
   TWLhQ4bXpJBxyzAhcx+/Df3k7+0AG4/evanKfsRaNHCqi0fo6oWrlcdle
   boHzHh9cyjBxVgMH/vqFKGZN+eqLivPJuFAf4IBZXKjkgvjzFM1dufvJ5
   2FeZfSi4F5RJL+m+Wm0sQOIlX4OheH7m+7GO7ixYBqSK99yPedXQ7W+zo
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="246315618"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="246315618"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:18:40 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="535159808"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.171.61]) ([10.249.171.61])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:18:39 -0800
Message-ID: <3a0b979d-9895-c003-7668-6492b4ad2402@intel.com>
Date:   Wed, 26 Jan 2022 20:18:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH V2 2/4] vDPA/ifcvf: implement device MSIX vector allocator
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20220125091744.115996-1-lingshan.zhu@intel.com>
 <20220125091744.115996-3-lingshan.zhu@intel.com>
 <20220125143254-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220125143254-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/26/2022 3:36 AM, Michael S. Tsirkin wrote:
> On Tue, Jan 25, 2022 at 05:17:42PM +0800, Zhu Lingshan wrote:
>> This commit implements a MSIX vector allocation helper
>> for vqs and config interrupts.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 30 ++++++++++++++++++++++++++++--
>>   1 file changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index d1a6b5ab543c..7e2af2d2aaf5 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -58,14 +58,40 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
>>   	ifcvf_free_irq_vectors(pdev);
>>   }
>>   
>> +static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
>
> So the helper returns an int...
can fix in V3, thanks for your help!
>
>> +{
>> +	struct pci_dev *pdev = adapter->pdev;
>> +	struct ifcvf_hw *vf = &adapter->vf;
>> +	u16 max_intr, ret;
>> +
>> +	/* all queues and config interrupt  */
>> +	max_intr = vf->nr_vring + 1;
>> +	ret = pci_alloc_irq_vectors(pdev, 1, max_intr, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
>> +
>> +	if (ret < 0) {
>> +		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
>> +		return ret;
>
> which is negative on error...
>
>> +	}
>> +
>> +	if (ret < max_intr)
>> +		IFCVF_INFO(pdev,
>> +			   "Requested %u vectors, however only %u allocated, lower performance\n",
>> +			   max_intr, ret);
>> +
>> +	return ret;
>> +}
>> +
>>   static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>>   {
>>   	struct pci_dev *pdev = adapter->pdev;
>>   	struct ifcvf_hw *vf = &adapter->vf;
>>   	int vector, i, ret, irq;
>> -	u16 max_intr;
>> +	u16 nvectors, max_intr;
>> +
>> +	nvectors = ifcvf_alloc_vectors(adapter);
> which you proceed to stash into an unsigned int ...
>
>> +	if (!(nvectors > 0))
> and then compare to zero ...
>
>> +		return nvectors;
>>
> correct error handling is unlikely as a result.
>
>    
>> -	/* all queues and config interrupt  */
>>   	max_intr = vf->nr_vring + 1;
>>   
>>   	ret = pci_alloc_irq_vectors(pdev, max_intr,
>
> As long as you are introducing a helper, document it's return
> type and behaviour and then use correctly.
>
>> -- 
>> 2.27.0

