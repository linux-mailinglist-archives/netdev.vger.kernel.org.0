Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EFC3BB7BD
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 09:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhGEH0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 03:26:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46851 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhGEH0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 03:26:08 -0400
Received: from [222.129.38.159] (helo=[192.168.1.18])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <aaron.ma@canonical.com>)
        id 1m0Iwy-0000jS-Ew; Mon, 05 Jul 2021 07:23:28 +0000
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
References: <20210702045120.22855-1-aaron.ma@canonical.com>
 <20210704142808.f43jbcufk37hundo@pali>
From:   Aaron Ma <aaron.ma@canonical.com>
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
Message-ID: <3bc507f7-3eb9-1bef-d47d-cad42fcb1c48@canonical.com>
Date:   Mon, 5 Jul 2021 15:23:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210704142808.f43jbcufk37hundo@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/4/21 10:28 PM, Pali Rohár wrote:
> + Bjorn, Krzysztof and linux-pci
> 
> On Friday 02 July 2021 12:51:19 Aaron Ma wrote:
>> Check PCI state when rd/wr iomem.
>> Implement wr32 function as rd32 too.
>>
>> When unplug TBT dock with i225, rd/wr PCI iomem will cause error log:
>> Trace:
>> BUG: unable to handle page fault for address: 000000000000b604
>> Oops: 0000 [#1] SMP NOPTI
>> RIP: 0010:igc_rd32+0x1c/0x90 [igc]
>> Call Trace:
>> igc_ptp_suspend+0x6c/0xa0 [igc]
>> igc_ptp_stop+0x12/0x50 [igc]
>> igc_remove+0x7f/0x1c0 [igc]
>> pci_device_remove+0x3e/0xb0
>> __device_release_driver+0x181/0x240
>>
>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
>> ---
>>   drivers/net/ethernet/intel/igc/igc_main.c | 16 ++++++++++++++++
>>   drivers/net/ethernet/intel/igc/igc_regs.h |  7 ++-----
>>   2 files changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
>> index f1adf154ec4a..606b72cb6193 100644
>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>> @@ -5292,6 +5292,10 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
>>   	u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
>>   	u32 value = 0;
>>   
>> +	if (igc->pdev &&
>> +		igc->pdev->error_state == pci_channel_io_perm_failure)
> 
> Hello! This code pattern and commit message looks like that we could use
> pci_dev_is_disconnected() helper function for checking if device is
> still connected or was disconnected.
> 
> Apparently pci_dev_is_disconnected() is defined only in private header
> file drivers/pci/pci.h and not in public include/linux/pci.h.
> 
> Aaron: can you check if pci_dev_is_disconnected() is really something
> which should be used and it helps you?
> 

Hi Pali,

How about using pci_channel_offline instead?
It's ready and also safe for frozen state, and verified on hw.

> Bjorn, Krzysztof: what do you think about lifting helper function
> pci_dev_is_disconnected() to be available to all drivers and not only in
> PCI subsystem?
> 
> I think that such helper function makes driver code more readable and
> can be useful also for other drivers which are checking if return value
> is all F's.
> 
>> +		return 0;
> 
> Aaron: should not you return all F's on error? Because few lines below
> in this function is returned value with all F's when PCIe link lost.
> 

If you agree with the above change, I can fix it to "return -1" in v2.

Thanks for your comments,
Aaron


>> +
>>   	value = readl(&hw_addr[reg]);
> 
> Anyway, this code looks to be racy. When pci_channel_io_perm_failure is
> set (e.g. by hotplug interrupt) after checking for pdev->error_state and
> prior executing above readl() then mentioned fatal error still occurs.
> 
>>   
>>   	/* reads should not return all F's */
>> @@ -5308,6 +5312,18 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
>>   	return value;
>>   }
>>   
>> +void igc_wr32(struct igc_hw *hw, u32 reg, u32 val)
>> +{
>> +	struct igc_adapter *igc = container_of(hw, struct igc_adapter, hw);
>> +	u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
>> +
>> +	if (igc->pdev &&
>> +		igc->pdev->error_state == pci_channel_io_perm_failure)
>> +		return;
>> +
>> +	writel((val), &hw_addr[(reg)]);
>> +}
>> +
>>   int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx)
>>   {
>>   	struct igc_mac_info *mac = &adapter->hw.mac;
>> diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
>> index cc174853554b..eb4be87d0e8b 100644
>> --- a/drivers/net/ethernet/intel/igc/igc_regs.h
>> +++ b/drivers/net/ethernet/intel/igc/igc_regs.h
>> @@ -260,13 +260,10 @@ struct igc_hw;
>>   u32 igc_rd32(struct igc_hw *hw, u32 reg);
>>   
>>   /* write operations, indexed using DWORDS */
>> -#define wr32(reg, val) \
>> -do { \
>> -	u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
>> -	writel((val), &hw_addr[(reg)]); \
>> -} while (0)
>> +void igc_wr32(struct igc_hw *hw, u32 reg, u32 val);
>>   
>>   #define rd32(reg) (igc_rd32(hw, reg))
>> +#define wr32(reg, val) (igc_wr32(hw, reg, val))
>>   
>>   #define wrfl() ((void)rd32(IGC_STATUS))
>>   
>> -- 
>> 2.30.2
>>
