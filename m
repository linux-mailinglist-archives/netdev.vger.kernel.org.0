Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72361220AD9
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 13:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbgGOLJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 07:09:48 -0400
Received: from mga07.intel.com ([134.134.136.100]:54688 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729753AbgGOLJq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 07:09:46 -0400
IronPort-SDR: hUOgvInoQP8gOncddUuWhTsv5JYXMX55tSaxFqKt+1uBobdq4UjP7JY1KNQLwV5232zYTfSjoB
 qhqAJTku+tUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="213892388"
X-IronPort-AV: E=Sophos;i="5.75,355,1589266800"; 
   d="scan'208";a="213892388"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 04:09:44 -0700
IronPort-SDR: vyIzfxABF2JZozj3NkPVkbsDQ9v5cWQME0YNx/JftiFau+YbLeUTuoyCECLdrYVseKp+eX+sXo
 Siml5zwJzFww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,355,1589266800"; 
   d="scan'208";a="460032361"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.172.100]) ([10.249.172.100])
  by orsmga005.jf.intel.com with ESMTP; 15 Jul 2020 04:09:42 -0700
Subject: Re: [PATCH 3/7] vhost_vdpa: implement IRQ offloading functions in
 vhost_vdpa
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com
References: <1594565366-3195-1-git-send-email-lingshan.zhu@intel.com>
 <1594565366-3195-3-git-send-email-lingshan.zhu@intel.com>
 <3fb9ecfc-a325-69b5-f5b7-476a5683a324@redhat.com>
 <e06f9706-441f-0d7a-c8c0-cd43a26c5296@intel.com>
 <f352a1d1-6732-3237-c85e-ffca085195ff@redhat.com>
 <8f52ee3a-7a08-db14-9194-8085432481a4@intel.com>
 <2bd946e3-1524-efa5-df2b-3f6da66d2069@redhat.com>
 <61c1753a-43dc-e448-6ece-13a19058e621@intel.com>
 <c9f2ffb0-adc0-8846-9578-1f75a4374df1@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <35b0ed89-588a-81e1-2dac-b98629d4398c@intel.com>
Date:   Wed, 15 Jul 2020 19:09:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <c9f2ffb0-adc0-8846-9578-1f75a4374df1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/15/2020 5:42 PM, Jason Wang wrote:
>
> On 2020/7/15 下午5:20, Zhu, Lingshan wrote:
>>>>>
>>>>> I meant something like:
>>>>>
>>>>> unregister();
>>>>> vq->call_ctx.producer.token = ctx;
>>>>> register();
>>>> This is what we are doing now, or I must missed somethig:
>>>> if (ctx && ctx != token) {
>>>>     irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>>>     vq->call_ctx.producer.token = ctx;
>>>>     irq_bypass_register_producer(&vq->call_ctx.producer);
>>>>
>>>> }
>>>>
>>>> It just unregister and register.
>>>
>>>
>>> I meant there's probably no need for the check and another check and 
>>> unregister before. The whole function is as simple as I suggested 
>>> above.
>>>
>>> Thanks
>> IMHO we still need the checks, this function handles three cases:
>> (1)if the ctx == token, we do nothing. For this unregister and 
>> register can work, but waste of time.
>
>
> But we have a more simple code and we don't care about the performance 
> here since the operations is rare.
>
>
>> (2)if token exists but ctx is NULL, this means user space issued an 
>> unbind, so we need to only unregister the producer.
>
>
> Note that the register/unregister have a graceful check of whether or 
> not there's a token.
>
>
>> (3)if ctx exists and ctx!=token, this means there is a new ctx, we 
>> need to update producer by unregister and register.
>>
>> I think we can not simply handle all these cases by "unregister and 
>> register".
>
>
> So it looks to me the functions are equivalent.
>
> Thanks
Sounds reasonable, thanks!
>
>
>>
>> Thanks,
>> BR
>> Zhu Lingshan
>
