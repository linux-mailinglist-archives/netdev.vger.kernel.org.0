Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DBD3DF960
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 03:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhHDBuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 21:50:08 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16039 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbhHDBuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 21:50:07 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GfZMw2TxXzZxHs;
        Wed,  4 Aug 2021 09:46:20 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 09:49:53 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 09:49:53 +0800
Subject: Re: [PATCH] once: Fix panic when module unload
To:     Hannes Frederic Sowa <hannes@stressinduktion.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Minmin chen <chenmingmin@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20210622022138.23048-1-wangkefeng.wang@huawei.com>
 <6b4b7165-5438-df65-3a43-7dcb576dab93@huawei.com>
 <3017d4a6-8f1b-4f8b-9c73-1121f0251fde@www.fastmail.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <09551b30-f73a-f248-5030-5c57c8457547@huawei.com>
Date:   Wed, 4 Aug 2021 09:49:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <3017d4a6-8f1b-4f8b-9c73-1121f0251fde@www.fastmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/8/3 17:59, Hannes Frederic Sowa wrote:
> Hello,
>
> On Tue, Aug 3, 2021, at 04:11, Kefeng Wang wrote:
>> Hi ALL, I don't know who maintain the lib/once.c, add Greg and Andrew too,
>>
>> Hi David, I check the history, the lib/once.c is from net/core/utils.c
>> since
>>
>> commit 46234253b9363894a254844a6550b4cc5f3edfe8
>> Author: Hannes Frederic Sowa <hannes@stressinduktion.org>
>> Date:   Thu Oct 8 01:20:35 2015 +0200
>>
>>       net: move net_get_random_once to lib
>>
>> This bug is found in our product test, we want to make sure that whether
>> this solution
>>
>> is correct or not, so could David or any others help to review this patch.
>>
>> Many thinks.
> Thanks for the patch.
>
> I see that it got marked as not applicable for the net trees:
> <https://patchwork.kernel.org/project/netdevbpf/patch/20210622022138.23048-1-wangkefeng.wang@huawei.com/>
>
> Back then I added this code via the net/ tree thus I think it should get
> picked up nonetheless hopefully.
>
> Regarding your patch, I think it mostly looks fine:
>
> It might be worthwhile to increment the reference counter inside the
> preempt disabled bracket in find_module_by_key (and thus also rename
> that function to make this fact more clear).
>
> The other option would be to use the macro DO_ONCE and always pass in
> THIS_MODULE from there, increment its ref counter in once_disable_jump.
> This might be more canonical.

Thanks for your replay.

Yes, that was my first thought, add THIS_MODULE to __do_once_done(),

I will change to this way to fix the issue.


>
> Thanks and sorry for the delay,
> Hannes
> .
>
