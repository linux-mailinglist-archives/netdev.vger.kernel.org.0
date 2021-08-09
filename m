Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04193E3D71
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 03:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhHIBPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 21:15:51 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16995 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhHIBPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 21:15:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GjdMr1gwJzZyth;
        Mon,  9 Aug 2021 09:11:52 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 09:15:10 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 09:15:09 +0800
Subject: Re: [PATCH v2] once: Fix panic when module unload
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <hannes@stressinduktion.org>, <davem@davemloft.net>,
        <akpm@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Minmin chen <chenmingmin@huawei.com>
References: <20210806082124.96607-1-wangkefeng.wang@huawei.com>
 <20210806064328.1b54a7f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YQ0+Yz+cWC0nh4uB@kroah.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <a783f15a-5657-787e-fdbd-88f9e3645571@huawei.com>
Date:   Mon, 9 Aug 2021 09:15:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YQ0+Yz+cWC0nh4uB@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/8/6 21:51, Greg KH wrote:
> On Fri, Aug 06, 2021 at 06:43:28AM -0700, Jakub Kicinski wrote:
>> On Fri, 6 Aug 2021 16:21:24 +0800 Kefeng Wang wrote:
>>> DO_ONCE
>>> DEFINE_STATIC_KEY_TRUE(___once_key);
>>> __do_once_done
>>>    once_disable_jump(once_key);
>>>      INIT_WORK(&w->work, once_deferred);
>>>      struct once_work *w;
>>>      w->key = key;
>>>      schedule_work(&w->work);                     module unload
>>>                                                     //*the key is
>>> destroy*
>>> process_one_work
>>>    once_deferred
>>>      BUG_ON(!static_key_enabled(work->key));
>>>         static_key_count((struct static_key *)x)    //*access key, crash*
>>>
>>> When module uses DO_ONCE mechanism, it could crash due to the above
>>> concurrency problem, we could reproduce it with link[1].
>>>
>>> Fix it by add/put module refcount in the once work process.
>>>
>>> [1] https://lore.kernel.org/netdev/eaa6c371-465e-57eb-6be9-f4b16b9d7cbf@huawei.com/
>> Seems reasonable. Greg does it look good to you?
> Me?  I was not paying attention to this at all, sorry...
>
>> I think we can take it thru networking since nobody cared to pick up v1.
Thanks all ;)
> Sure, I trust you :)
> .
>
