Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2AF466D1F
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 23:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377454AbhLBWqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 17:46:09 -0500
Received: from mga04.intel.com ([192.55.52.120]:51276 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377333AbhLBWqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 17:46:09 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="235595164"
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="235595164"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 14:42:45 -0800
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="541405470"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.114.198]) ([10.209.114.198])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 14:42:44 -0800
Message-ID: <7ed54978-5a64-f932-e1dc-dd8b47b67d63@linux.intel.com>
Date:   Thu, 2 Dec 2021 14:42:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 03/14] net: wwan: t7xx: Add core components
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-4-ricardo.martinez@linux.intel.com>
 <CAHNKnsTd0-AwXwmPmXy_oKjYJA5vGDHo7VJbn5NqTngmhSpmfw@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsTd0-AwXwmPmXy_oKjYJA5vGDHo7VJbn5NqTngmhSpmfw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/6/2021 11:05 AM, Sergey Ryazanov wrote:
> On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez
> <ricardo.martinez@linux.intel.com> wrote:
>> Registers the t7xx device driver with the kernel. Setup all the core
>> components: PCIe layer, Modem Host Cross Core Interface (MHCCIF),
>> modem control operations, modem state machine, and build
>> infrastructure.
>>
>> * PCIe layer code implements driver probe and removal.
>> * MHCCIF provides interrupt channels to communicate events
>>    such as handshake, PM and port enumeration.
>> * Modem control implements the entry point for modem init,
>>    reset and exit.
>> * The modem status monitor is a state machine used by modem control
>>    to complete initialization and stop. It is used also to propagate
>>    exception events reported by other components.
> [skipped]
>
>>   drivers/net/wwan/t7xx/t7xx_monitor.h       | 144 +++++
>> ...
>>   drivers/net/wwan/t7xx/t7xx_state_monitor.c | 598 +++++++++++++++++++++
> Out of curiosity, why is this file called t7xx_state_monitor.c, while
> the corresponding header file is called simply t7xx_monitor.h? Are any
> other monitors planed?
>
> [skipped]

No other monitors, I'll rename it to make it consistent.

[skipped]

>
>> diff --git a/drivers/net/wwan/t7xx/t7xx_skb_util.c b/drivers/net/wwan/t7xx/t7xx_skb_util.c
>> ...
>> +static struct sk_buff *alloc_skb_from_pool(struct skb_pools *pools, size_t size)
>> +{
>> +       if (size > MTK_SKB_4K)
>> +               return ccci_skb_dequeue(pools->reload_work_queue, &pools->skb_pool_64k);
>> +       else if (size > MTK_SKB_16)
>> +               return ccci_skb_dequeue(pools->reload_work_queue, &pools->skb_pool_4k);
>> +       else if (size > 0)
>> +               return ccci_skb_dequeue(pools->reload_work_queue, &pools->skb_pool_16);
>> +
>> +       return NULL;
>> +}
>> +
>> +static struct sk_buff *alloc_skb_from_kernel(size_t size, gfp_t gfp_mask)
>> +{
>> +       if (size > MTK_SKB_4K)
>> +               return __dev_alloc_skb(MTK_SKB_64K, gfp_mask);
>> +       else if (size > MTK_SKB_1_5K)
>> +               return __dev_alloc_skb(MTK_SKB_4K, gfp_mask);
>> +       else if (size > MTK_SKB_16)
>> +               return __dev_alloc_skb(MTK_SKB_1_5K, gfp_mask);
>> +       else if (size > 0)
>> +               return __dev_alloc_skb(MTK_SKB_16, gfp_mask);
>> +
>> +       return NULL;
>> +}
> I am wondering what performance gains have you achieved with these skb
> pools? Can we see any numbers?
>
> I do not think the control path performance is worth the complexity of
> the multilayer skb allocation. In the data packet Rx path, you need to
> allocate skb anyway as soon as the driver passes them to the stack. So
> what is the gain?
>
> [skipped]

Agree, we are removing the skb pools for the control path.

Regarding Rx data path, we'll get some numbers to see if the pool is 
worth it,

otherwise remove it too.

[skipped]


