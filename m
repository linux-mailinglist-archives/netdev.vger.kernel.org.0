Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9232BBBB4
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 02:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgKUB4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 20:56:13 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7963 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgKUB4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 20:56:13 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CdGj92yymzhdwG;
        Sat, 21 Nov 2020 09:55:57 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Sat, 21 Nov 2020
 09:56:03 +0800
Subject: Re: [RFC net-next 1/2] ethtool: add support for controling the type
 of adaptive coalescing
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <kuba@kernel.org>
References: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
 <1605758050-21061-2-git-send-email-tanhuazhong@huawei.com>
 <20201119041557.GR1804098@lunn.ch>
 <e43890d1-5596-3439-f4a7-d704c069a035@huawei.com>
 <20201119220203.fv2uluoeekyoyxrv@lion.mk-sys.cz>
 <8e9ba4c4-3ef4-f8bc-ab2f-92d695f62f12@huawei.com>
 <20201120072322.slrpgqydcupm63ep@lion.mk-sys.cz>
 <20201120133938.GG1804098@lunn.ch>
 <20201120212243.n7vnwo3ldzisr4hl@lion.mk-sys.cz>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <4451853d-bcbe-5de0-6a44-a3e87b211f6b@huawei.com>
Date:   Sat, 21 Nov 2020 09:56:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201120212243.n7vnwo3ldzisr4hl@lion.mk-sys.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/21 5:22, Michal Kubecek wrote:
> On Fri, Nov 20, 2020 at 02:39:38PM +0100, Andrew Lunn wrote:
>> On Fri, Nov 20, 2020 at 08:23:22AM +0100, Michal Kubecek wrote:
>>> On Fri, Nov 20, 2020 at 10:59:59AM +0800, tanhuazhong wrote:
>>>> On 2020/11/20 6:02, Michal Kubecek wrote:
>>>>> We could use a similar approach as struct ethtool_link_ksettings, e.g.
>>>>>
>>>>> 	struct kernel_ethtool_coalesce {
>>>>> 		struct ethtool_coalesce base;
>>>>> 		/* new members which are not part of UAPI */
>>>>> 	}
>>>>>
>>>>> get_coalesce() and set_coalesce() would get pointer to struct
>>>>> kernel_ethtool_coalesce and ioctl code would be modified to only touch
>>>>> the base (legacy?) part.
>>>>>   > While already changing the ops arguments, we could also add extack
>>>>> pointer, either as a separate argument or as struct member (I slightly
>>>>> prefer the former).
>>>> If changing the ops arguments, each driver who implement
>>>> set_coalesce/get_coalesce of ethtool_ops need to be updated. Is it
>>>> acceptable adding two new ops to get/set ext_coalesce info (like
>>>> ecc31c60240b ("ethtool: Add link extended state") does)? Maybe i can send V2
>>>> in this way, and then could you help to see which one is more suitable?
>>> If it were just this one case, adding an extra op would be perfectly
>>> fine. But from long term point of view, we should expect extending also
>>> other existing ethtool requests and going this way for all of them would
>>> essentially double the number of callbacks in struct ethtool_ops.
>> coccinella might be useful here.
> I played with spatch a bit and it with the spatch and patch below, I got
> only three build failures (with allmodconfig) that would need to be
> addressed manually - these drivers call the set_coalesce() callback on
> device initialization.
> 
> I also tried to make the structure argument const in ->set_coalesce()
> but that was more tricky as adjusting other functions that the structure
> is passed to required either running the spatch three times or repeating
> the same two rules three times in the spatch (or perhaps there is
> a cleaner way but I'm missing relevant knowledge of coccinelle). Then
> there was one more problem in i40e driver which modifies the structure
> before passing it on to its helpers. It could be worked around but I'm
> not sure if constifying the argument is worth these extra complications.
> 
> Michal

will implement it like this in V3.

Regards,
Huazhong.

