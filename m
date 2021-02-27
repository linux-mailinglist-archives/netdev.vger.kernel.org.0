Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DCC326B22
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 03:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhB0CPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 21:15:33 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12210 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhB0CPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 21:15:30 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DnVRH27m5zlQRP;
        Sat, 27 Feb 2021 10:12:43 +0800 (CST)
Received: from [10.174.177.244] (10.174.177.244) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Feb 2021 10:14:43 +0800
Subject: Re: [PATCH] net: bridge: Fix jump_label config
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210224153803.91194-1-wangkefeng.wang@huawei.com>
 <CAM_iQpV0NCoJF-qS1KPB+VE3FSMfGBH_SL-OxhMO-k0pGUEhwA@mail.gmail.com>
 <1cf51ae7-3bce-3b9f-f6aa-c20499eedf7a@huawei.com>
 <CAM_iQpWArF_At1XAcviDnyXdth4cMeUSQh7RBW-JNCDUPYfA2A@mail.gmail.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <6482713d-2b02-4ebe-8963-912e79b3bc99@huawei.com>
Date:   Sat, 27 Feb 2021 10:14:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWArF_At1XAcviDnyXdth4cMeUSQh7RBW-JNCDUPYfA2A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.177.244]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/27 4:19, Cong Wang wrote:
> On Thu, Feb 25, 2021 at 5:39 PM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>>
>> On 2021/2/26 5:22, Cong Wang wrote:
>>> On Wed, Feb 24, 2021 at 8:03 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>>>> HAVE_JUMP_LABLE is removed by commit e9666d10a567 ("jump_label: move
>>>> 'asm goto' support test to Kconfig"), use CONFIG_JUMP_LABLE instead
>>>> of HAVE_JUMP_LABLE.
>>>>
>>>> Fixes: 971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge input path")
>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> Hmm, why do we have to use a macro here? static_key_false() is defined
>>> in both cases, CONFIG_JUMP_LABEL=y or CONFIG_JUMP_LABEL=n.
>> It seems that all nf_hooks_needed related are using the macro,
>>
>> see net/netfilter/core.c and include/linux/netfilter.h,
>>
>>     #ifdef CONFIG_JUMP_LABEL
>>     struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
>> EXPORT_SYMBOL(nf_hooks_needed);
>> #endif
>>
>>     nf_static_key_inc()/nf_static_key_dec()
> Same question: why? Clearly struct static_key is defined in both cases:

Ok,  I mean that I don't change the original logic, but that's no need 
this macro actually,

it could be built with or without CONFIG_JUMP_LABEL, only increased the 
size a little bit.


>
> #else
> struct static_key {
>          atomic_t enabled;
> };
> #endif  /* CONFIG_JUMP_LABEL */
>
> Thanks.
>
