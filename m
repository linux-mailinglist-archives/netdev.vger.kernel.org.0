Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4C13A03C9
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbhFHTWA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Jun 2021 15:22:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:9374 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237278AbhFHTRu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 15:17:50 -0400
IronPort-SDR: Ltzn004XI6wrZ6+GrdN0D2COJL2CF4NMNCOr4ppsRZ0ax+a2TP1sXBxiiBR9CBbyFxWV2851Np
 +pTrtUbvdhAA==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="204940750"
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; 
   d="scan'208";a="204940750"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 12:02:34 -0700
IronPort-SDR: MEcxlr6/6PVTW2YAwcxOPeu42eX2NYsaitOlR9ybJVyqHprVqOIu0NTddsR5T4YB1mhJLcoElb
 bpW6T5sD0jHg==
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; 
   d="scan'208";a="402177037"
Received: from vgoornav-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.249.197])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 12:02:31 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-pci@vger.kernel.org, richardcochran@gmail.com,
        hch@infradead.org, netdev@vger.kernel.org, bhelgaas@google.com,
        helgaas@kernel.org
Subject: Re: [Intel-wired-lan] [PATCH next-queue v5 3/4] igc: Enable PCIe PTM
In-Reply-To: <70d32740-eb4b-f7bf-146e-8dc06199d6c9@molgen.mpg.de>
References: <20210605002356.3996853-1-vinicius.gomes@intel.com>
 <20210605002356.3996853-4-vinicius.gomes@intel.com>
 <70d32740-eb4b-f7bf-146e-8dc06199d6c9@molgen.mpg.de>
Date:   Tue, 08 Jun 2021 12:02:30 -0700
Message-ID: <87sg1sw56h.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

Paul Menzel <pmenzel@molgen.mpg.de> writes:

> Dear Vinicius,
>
>
> Am 05.06.21 um 02:23 schrieb Vinicius Costa Gomes:
>> Enables PCIe PTM (Precision Time Measurement) support in the igc
>> driver. Notifies the PCI devices that PCIe PTM should be enabled.
>> 
>> PCIe PTM is similar protocol to PTP (Precision Time Protocol) running
>> in the PCIe fabric, it allows devices to report time measurements from
>> their internal clocks and the correlation with the PCIe root clock.
>> 
>> The i225 NIC exposes some registers that expose those time
>> measurements, those registers will be used, in later patches, to
>> implement the PTP_SYS_OFFSET_PRECISE ioctl().
>> 
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> ---
>>   drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>> 
>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
>> index a05e6d8ec660..f23d0303e53b 100644
>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>> @@ -12,6 +12,8 @@
>>   #include <net/pkt_sched.h>
>>   #include <linux/bpf_trace.h>
>>   #include <net/xdp_sock_drv.h>
>> +#include <linux/pci.h>
>> +
>>   #include <net/ipv6.h>
>>   
>>   #include "igc.h"
>> @@ -5864,6 +5866,10 @@ static int igc_probe(struct pci_dev *pdev,
>>   
>>   	pci_enable_pcie_error_reporting(pdev);
>>   
>> +	err = pci_enable_ptm(pdev, NULL);
>> +	if (err < 0)
>> +		dev_err(&pdev->dev, "PTM not supported\n");
>> +
>
> Sorry, if I am missing something, but do all devices supported by this 
> driver support PTM or only the i225 NIC? In that case, it wouldn’t be an 
> error for a device not supporting PTM, would it?

That was a very good question. I had to talk with the hardware folks.
All the devices supported by the igc driver should support PTM.

And just to be clear, the reason that I am not returning an error here
is that PTM could not be supported by the host system (think PCI
controller).

>
>>   	pci_set_master(pdev);
>>   
>>   	err = -ENOMEM;
>> 
>
>
> Kind regards,
>
> Paul


Cheers,
-- 
Vinicius
