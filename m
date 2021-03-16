Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651AD33D810
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbhCPPsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:48:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13550 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbhCPPsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:48:24 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F0Hgp52WZzNnjl;
        Tue, 16 Mar 2021 23:45:58 +0800 (CST)
Received: from [10.174.177.244] (10.174.177.244) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Tue, 16 Mar 2021 23:48:18 +0800
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
Message-ID: <2a9d5d65-bf6c-7c41-113c-6297e3826b91@huawei.com>
Date:   Tue, 16 Mar 2021 23:48:18 +0800
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

Hi Cong,  the nf_hooks_needed is wrapped up by this macro, so this place 
should use it,

or we will meet the build issue,  thanks.

../net/bridge/br_input.c: In function ‘nf_hook_bridge_pre’:
../net/bridge/br_input.c:211:25: error: ‘nf_hooks_needed’ undeclared 
(first use in this function)
   211 |  if 
(!static_key_false(&nf_hooks_needed[NFPROTO_BRIDGE][NF_BR_PRE_ROUTING]))


>
> #else
> struct static_key {
>          atomic_t enabled;
> };
> #endif  /* CONFIG_JUMP_LABEL */
>
> Thanks.
>
