Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16486456A54
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 07:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhKSGlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 01:41:03 -0500
Received: from mga12.intel.com ([192.55.52.136]:25273 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhKSGlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 01:41:02 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="214396636"
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="214396636"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 22:36:34 -0800
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="594105827"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.190.52]) ([10.212.190.52])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 22:36:32 -0800
Message-ID: <30a536cc-5343-c719-0122-cbedcd7cd03f@linux.intel.com>
Date:   Thu, 18 Nov 2021 22:36:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 02/14] net: wwan: t7xx: Add control DMA interface
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-3-ricardo.martinez@linux.intel.com>
 <YX/zmY81A9d0nIlO@smile.fi.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <YX/zmY81A9d0nIlO@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/1/2021 7:03 AM, Andy Shevchenko wrote:
> On Sun, Oct 31, 2021 at 08:56:23PM -0700, Ricardo Martinez wrote:
>> From: Haijun Lio <haijun.liu@mediatek.com>
>>
>> Cross Layer DMA (CLDMA) Hardware interface (HIF) enables the control
>> path of Host-Modem data transfers. CLDMA HIF layer provides a common
>> interface to the Port Layer.
>>
>> CLDMA manages 8 independent RX/TX physical channels with data flow
>> control in HW queues. CLDMA uses ring buffers of General Packet
>> Descriptors (GPD) for TX/RX. GPDs can represent multiple or single
>> data buffers (DB).
>>
>> CLDMA HIF initializes GPD rings, registers ISR handlers for CLDMA
>> interrupts, and initializes CLDMA HW registers.
>>
>> CLDMA TX flow:
>> 1. Port Layer write
>> 2. Get DB address
>> 3. Configure GPD
>> 4. Triggering processing via HW register write
>>
>> CLDMA RX flow:
>> 1. CLDMA HW sends a RX "done" to host
>> 2. Driver starts thread to safely read GPD
>> 3. DB is sent to Port layer
>> 4. Create a new buffer for GPD ring
...
>
>> +void cldma_hw_reset(void __iomem *ao_base)
>> +{
>> +	iowrite32(ioread32(ao_base + REG_INFRA_RST4_SET) | RST4_CLDMA1_SW_RST_SET,
>> +		  ao_base + REG_INFRA_RST4_SET);
>> +	iowrite32(ioread32(ao_base + REG_INFRA_RST2_SET) | RST2_CLDMA1_AO_SW_RST_SET,
>> +		  ao_base + REG_INFRA_RST2_SET);
>> +	udelay(1);
>> +	iowrite32(ioread32(ao_base + REG_INFRA_RST4_CLR) | RST4_CLDMA1_SW_RST_CLR,
>> +		  ao_base + REG_INFRA_RST4_CLR);
>> +	iowrite32(ioread32(ao_base + REG_INFRA_RST2_CLR) | RST2_CLDMA1_AO_SW_RST_CLR,
>> +		  ao_base + REG_INFRA_RST2_CLR);
> Setting and clearing are in the same order, is it okay?
> Can we do it rather symmetrical?
In this case, order does not matter.

This will be symmetrical in the next iteration.

>> +}
> ...
>
>> +	mb(); /* prevents outstanding GPD updates */
> Is there any counterpart of this barrier?

This is not needed, removing it.

...

>
>> +		ret = cldma_gpd_rx_from_queue(queue, budget, &over_budget);
>> +		if (ret == -ENODATA)
>> +			return 0;
>> +
>> +		if (ret)
>> +			return ret;
> Drop redundant blank line

The style followed is to keep a blank line after 'if' blocks.

Is that acceptable as long as it is consistent across the driver?
>
>> +			/* greedy mode */
>> +			l2_rx_int = cldma_hw_int_status(hw_info, BIT(queue->index), true);
...
>
>> +exit:
> Seems useless.

This tag is used when the PM patch is introduced later in the same series.

> +	return ret;
...
