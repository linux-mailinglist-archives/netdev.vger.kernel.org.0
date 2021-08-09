Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98463E3D6D
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 03:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhHIBOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 21:14:11 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8377 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhHIBOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 21:14:10 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GjdKZ30zQz85Ps;
        Mon,  9 Aug 2021 09:09:54 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 09:13:49 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 09:13:47 +0800
Subject: Re: [PATCH v2] once: Fix panic when module unload
To:     Hannes Frederic Sowa <hannes@stressinduktion.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Minmin chen <chenmingmin@huawei.com>
References: <20210806082124.96607-1-wangkefeng.wang@huawei.com>
 <7ae60193-0114-46d2-9770-697a2f88b85b@www.fastmail.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <25dd38c6-39e7-8fb8-dff3-5062acf959c4@huawei.com>
Date:   Mon, 9 Aug 2021 09:13:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <7ae60193-0114-46d2-9770-697a2f88b85b@www.fastmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/8/6 23:22, Hannes Frederic Sowa wrote:
> On Fri, Aug 6, 2021, at 10:21, Kefeng Wang wrote:
>> DO_ONCE
>> DEFINE_STATIC_KEY_TRUE(___once_key);
>> __do_once_done
>>    once_disable_jump(once_key);
>>      INIT_WORK(&w->work, once_deferred);
>>      struct once_work *w;
>>      w->key = key;
>>      schedule_work(&w->work);                     module unload
>>                                                     //*the key is
>> destroy*
>> process_one_work
>>    once_deferred
>>      BUG_ON(!static_key_enabled(work->key));
>>         static_key_count((struct static_key *)x)    //*access key, crash*
>>
>> When module uses DO_ONCE mechanism, it could crash due to the above
>> concurrency problem, we could reproduce it with link[1].
>>
>> Fix it by add/put module refcount in the once work process.
>>
>> [1]
>> https://lore.kernel.org/netdev/eaa6c371-465e-57eb-6be9-f4b16b9d7cbf@huawei.com/
>>
>> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Reported-by: Minmin chen <chenmingmin@huawei.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Thanks.
>
> Thanks,
> Hannes
> .
>
