Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8AA2B9B67
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgKSTTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:19:10 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:17752 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgKSTTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 14:19:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1605813549; x=1637349549;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=DpC7Q+VFkKd0jqeZWuWKpTGuYHvvdIvf6UnBOskzc9c=;
  b=feIQU90+/LA2swdHTw1QK+IMzh0QPBSiV6Zit6bstNpLJ1ps7S3GXQ70
   1BE+9YN2Fv85zAzg9v1OVy6vbfbHkEVhwU2K5t26JaqCYuQMl+lSTEmiI
   KHshWQG2Uu7wIDIEZuwdbGk+9vSVF3idGFuegl+37LRW1cq1xMwjYG2D8
   I=;
X-IronPort-AV: E=Sophos;i="5.78,354,1599523200"; 
   d="scan'208";a="64975817"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 19 Nov 2020 19:19:00 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 8975CA123B;
        Thu, 19 Nov 2020 19:18:58 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.162.146) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 19:18:49 +0000
References: <20201118215947.8970-1-shayagr@amazon.com>
 <20201118215947.8970-3-shayagr@amazon.com>
 <8bbad77f-03ad-b066-4715-0976141a687b@gmail.com>
 <c477aae1-31f0-8139-28b0-950d01abd182@gmail.com>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>, Mike Cui <mikecui@amazon.com>
Subject: Re: [PATCH V1 net 2/4] net: ena: set initial DMA width to avoid
 intel iommu issue
In-Reply-To: <c477aae1-31f0-8139-28b0-950d01abd182@gmail.com>
Date:   Thu, 19 Nov 2020 21:18:30 +0200
Message-ID: <pj41zltutlnojd.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D41UWB003.ant.amazon.com (10.43.161.243) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Heiner Kallweit <hkallweit1@gmail.com> writes:

> Am 18.11.2020 um 23:35 schrieb Heiner Kallweit:
>> Am 18.11.2020 um 22:59 schrieb Shay Agroskin:
>>> The ENA driver uses the readless mechanism, which uses DMA, to 
>>> find
>>> out what the DMA mask is supposed to be.
>>>
>>> If DMA is used without setting the dma_mask first, it causes 
>>> the
>>> Intel IOMMU driver to think that ENA is a 32-bit device and 
>>> therefore
>>> disables IOMMU passthrough permanently.
>>>
>>> This patch sets the dma_mask to be 
>>> ENA_MAX_PHYS_ADDR_SIZE_BITS=48
>>> before readless initialization in
>>> ena_device_init()->ena_com_mmio_reg_read_request_init(),
>>> which is large enough to workaround the intel_iommu issue.
>>>
>>> DMA mask is set again to the correct value after it's received 
>>> from the
>>> device after readless is initialized.
>>>
>>> Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon 
>>> Elastic Network Adapters (ENA)")
>>> Signed-off-by: Mike Cui <mikecui@amazon.com>
>>> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
>>> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
>>> ---
>>>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 13 
>>>  +++++++++++++
>>>  1 file changed, 13 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
>>> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>> index 574c2b5ba21e..854a22e692bf 100644
>>> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>> @@ -4146,6 +4146,19 @@ static int ena_probe(struct pci_dev 
>>> *pdev, const struct pci_device_id *ent)
>>>  		return rc;
>>>  	}
>>>  
>>> +	rc = pci_set_dma_mask(pdev, 
>>> DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
>>> +	if (rc) {
>>> +		dev_err(&pdev->dev, "pci_set_dma_mask failed 
>>> %d\n", rc);
>>> +		goto err_disable_device;
>>> +	}
>>> +
>>> +	rc = pci_set_consistent_dma_mask(pdev, 
>>> DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
>>> +	if (rc) {
>>> +		dev_err(&pdev->dev, 
>>> "err_pci_set_consistent_dma_mask failed %d\n",
>>> +			rc);
>>> +		goto err_disable_device;
>>> +	}
>>> +
>>>  	pci_set_master(pdev);
>>>  
>>>  	ena_dev = vzalloc(sizeof(*ena_dev));
>>>
>> 
>> The old pci_ dma wrappers are being phased out and shouldn't be 
>> used in
>> new code. See e.g. e059c6f340f6 ("tulip: switch from 'pci_' to 
>> 'dma_' API").
>> So better use:
>> dma_set_mask_and_coherent(&pdev->dev, 
>> DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));

Thank you for reviewing these patches. We will switch to using 
dma_set_...() instead

>> 
>
> However instead of dev_err(&pdev->dev, ..) you could use 
> pci_err(pdev, ..).

I see that pci_err evaluates to dev_err. While I see how using 
pci_* log function helps code readability, I prefer using
dev_err here to keep the code consistent with the rest of the 
driver. We'll discuss changing all log functions in future patches 
to net-next if that's okay.

