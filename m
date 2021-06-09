Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052573A1EF8
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhFIV2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:28:07 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:37177 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229536AbhFIV2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 17:28:06 -0400
Received: from [192.168.0.2] (ip5f5ae88d.dynamic.kabel-deutschland.de [95.90.232.141])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7651261E646D4;
        Wed,  9 Jun 2021 23:26:09 +0200 (CEST)
Subject: Re: [Intel-wired-lan] [PATCH next-queue v5 3/4] igc: Enable PCIe PTM
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     linux-pci@vger.kernel.org, richardcochran@gmail.com,
        hch@infradead.org, netdev@vger.kernel.org, bhelgaas@google.com,
        helgaas@kernel.org, intel-wired-lan@lists.osuosl.org
References: <20210605002356.3996853-1-vinicius.gomes@intel.com>
 <20210605002356.3996853-4-vinicius.gomes@intel.com>
 <70d32740-eb4b-f7bf-146e-8dc06199d6c9@molgen.mpg.de>
 <87sg1sw56h.fsf@vcostago-mobl2.amr.corp.intel.com>
 <939b8042-a313-47db-43d9-ea37e95b724b@molgen.mpg.de>
 <87r1havm15.fsf@vcostago-mobl2.amr.corp.intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <d8740484-3879-1c13-65ce-82d3e71cb96c@molgen.mpg.de>
Date:   Wed, 9 Jun 2021 23:26:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87r1havm15.fsf@vcostago-mobl2.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Vinicius,


Am 09.06.21 um 22:08 schrieb Vinicius Costa Gomes:
> Paul Menzel writes:

>> Am 08.06.21 um 21:02 schrieb Vinicius Costa Gomes:
>>
>>> Paul Menzel writes:
>>
>>>> Am 05.06.21 um 02:23 schrieb Vinicius Costa Gomes:
>>>>> Enables PCIe PTM (Precision Time Measurement) support in the igc
>>>>> driver. Notifies the PCI devices that PCIe PTM should be enabled.
>>>>>
>>>>> PCIe PTM is similar protocol to PTP (Precision Time Protocol) running
>>>>> in the PCIe fabric, it allows devices to report time measurements from
>>>>> their internal clocks and the correlation with the PCIe root clock.
>>>>>
>>>>> The i225 NIC exposes some registers that expose those time
>>>>> measurements, those registers will be used, in later patches, to
>>>>> implement the PTP_SYS_OFFSET_PRECISE ioctl().
>>>>>
>>>>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>>>>> ---
>>>>>     drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
>>>>>     1 file changed, 6 insertions(+)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
>>>>> index a05e6d8ec660..f23d0303e53b 100644
>>>>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>>>>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>>>>> @@ -12,6 +12,8 @@
>>>>>     #include <net/pkt_sched.h>
>>>>>     #include <linux/bpf_trace.h>
>>>>>     #include <net/xdp_sock_drv.h>
>>>>> +#include <linux/pci.h>
>>>>> +
>>>>>     #include <net/ipv6.h>
>>>>>     
>>>>>     #include "igc.h"
>>>>> @@ -5864,6 +5866,10 @@ static int igc_probe(struct pci_dev *pdev,
>>>>>     
>>>>>     	pci_enable_pcie_error_reporting(pdev);
>>>>>     
>>>>> +	err = pci_enable_ptm(pdev, NULL);
>>>>> +	if (err < 0)
>>>>> +		dev_err(&pdev->dev, "PTM not supported\n");
>>>>> +
>>>>
>>>> Sorry, if I am missing something, but do all devices supported by this
>>>> driver support PTM or only the i225 NIC? In that case, it wouldn’t be an
>>>> error for a device not supporting PTM, would it?
>>>
>>> That was a very good question. I had to talk with the hardware folks.
>>> All the devices supported by the igc driver should support PTM.
>>
>> Thank you for checking that, that is valuable information.
>>
>>> And just to be clear, the reason that I am not returning an error here
>>> is that PTM could not be supported by the host system (think PCI
>>> controller).
>>
>> I just checked `pci_enable_ptm()` and on success it calls
>> `pci_ptm_info()` logging a message:
>>
>> 	pci_info(dev, "PTM enabled%s, %s granularity\n",
>> 		 dev->ptm_root ? " (root)" : "", clock_desc);
>>
>> Was that present on your system with your patch? Please add that to the
>> commit message.
> 
> Yes, with my patches applied I can see this message on my systems.
> 
> Sure, will add this to the commit message.
> 
>> Regarding my comment, I did not mean returning an error but the log
>> *level* of the message. So, `dmesg --level err` would show that message.
>> But if there are PCI controllers not supporting that, it’s not an error,
>> but a warning at most. So, I’d use:
>>
>> 	dev_warn(&pdev->dev, "PTM not supported by PCI bus/controller
>> (pci_enable_ptm() failed)\n");
> 
> I will use you suggestion for the message, but I think that warn is a
> bit too much, info or notice seem to be better.

I do not know, if modern PCI(e)(?) controllers normally support PTM or 
not. If recent controllers should support it, then a warning would be 
warranted, otherwise a notice.


Kind regards,

Paul
