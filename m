Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B526E1F7C
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 11:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjDNJlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 05:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjDNJlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 05:41:01 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F1E5260
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 02:41:00 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PyWbK3ps6zKyY7;
        Fri, 14 Apr 2023 17:38:21 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 14 Apr
 2023 17:40:58 +0800
Subject: Re: [PATCH net-next v2 1/3] net: skb: plumb napi state thru skb
 freeing paths
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <alexander.duyck@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230413042605.895677-1-kuba@kernel.org>
 <20230413042605.895677-2-kuba@kernel.org>
 <4447f0d2-dd78-573a-6d89-aa1e478ea46b@huawei.com>
 <CANn89iJkg=B0D23q_evwqjRVvm0kcNA=xvSRHVxjgeR00HgEjA@mail.gmail.com>
 <dd743d1e-d8a1-58d5-5b1f-8583d0f23b9f@huawei.com>
 <20230413222001.78fdc9a4@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <f2d47b7a-40fe-d366-e1a2-a81842e43acf@huawei.com>
Date:   Fri, 14 Apr 2023 17:40:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230413222001.78fdc9a4@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/14 13:20, Jakub Kicinski wrote:
> On Fri, 14 Apr 2023 08:57:03 +0800 Yunsheng Lin wrote:
>>>> Does it break the single-producer single-consumer assumption of tx queue?  
>>>
>>> We do not think so.  
>>
>> Then I guess it is ok to do direct recycling for page pool case as it is
>> per napi?
> 
> We're talking about the tx queue or the pp cache?

> Those have different producers and consumers.

I was trying to confirm if there are more than one contexts that will call
napi->poll() concurrently, if no, then it seems we only have one consumer
for pp cache. And it does not really matter here too when napi->poll() from
netpoll only do tx completion now.

If we are able to limit the context of producer for pp cache to be
the same as consumer, then we might avoid the !!bugget checking.

I do ack that it is a bigger change considering when we might need to
hold a persisent and safe reference to the NAPI instance for this too,
so we might leave it for now like you mentioned in the cover letter.

> 
>> It is per cpu cache case we are using !!bugget to protect it from preemption
>> while netpoll_poll_dev() is running?
> 
> This is the scenario - We are feeding the page pool cache from the
> deferred pages. An IRQ comes and interrupts us half way thru. 
> netpoll then tries to also feed the page pool cache. Unhappiness.

I assume feeding the page pool cache means producer for pp cache?
If netpoll only do tx completion by using zero bugget, it does not
seem to have any direct relation with page pool yet.

> 
> Note that netpoll is activated extremely rarely (only when something
> writes to the console), and even more rarely does it actually poll
> for space in the Tx queue.

That is my point, we turn out to need a checking in the fast path in order
to handle the netpoll case, which is a extreme rare case.

> .
> 
