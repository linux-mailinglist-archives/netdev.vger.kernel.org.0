Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0AD6D5E0C
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbjDDKvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234691AbjDDKuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:50:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F23F1FD3
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 03:50:37 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PrPbG66WDzZfp5;
        Tue,  4 Apr 2023 18:47:06 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 4 Apr
 2023 18:50:30 +0800
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely localized
 NAPI
To:     Eric Dumazet <edumazet@google.com>
CC:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>
References: <20230331043906.3015706-1-kuba@kernel.org>
 <1f9cf03e-94cf-9787-44ce-23f6a8dd0a7a@huawei.com>
 <CANn89iKsNYizAvoFisrFBSb-vXnn6BjkR7fuR1S5vQLggcLCdA@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <263c9940-ecd6-eba1-c971-2fd743671905@huawei.com>
Date:   Tue, 4 Apr 2023 18:50:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKsNYizAvoFisrFBSb-vXnn6BjkR7fuR1S5vQLggcLCdA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/4 12:21, Eric Dumazet wrote:
> On Tue, Apr 4, 2023 at 2:53 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> 
>> Interesting.
>> I wonder if we can make this more generic by adding the skb to per napi
>> list instead of sd->defer_list, so that we can always use NAPI kicking to
>> flush skb as net_tx_action() done for sd->completion_queue instead of
>> softirq kicking?
> 
> We do not have direct skb  -> napi association yet, but using an
> expensive hash lookup.
> 
> I had the intent of adding per-cpu caches in this infrastructure,
> to not acquire the remote-cpu defer_lock for one skb at a time.
> (This is I think causing some regressions for small packets, with no frags)

Is there any reason not to introduce back the per socket defer_list to
not acquire the defer_lock for one skb at a time instead of adding
per-cpu caches?

> 
>>
>> And it seems we know which napi binds to a specific socket through
>> busypoll mechanism, we can reuse that to release a skb to the napi
>> bound to that socket?
> 
> busypoll is not often used, and we usually burn (spinning) cycles there,
> not sure we want to optimize it?

How about only optimize napi_by_id()?
To be honest, I am not sure how to optimize it exactly, maybe add a callback
to notify the deletion of napi to the socket?

> 
>>
>>>
>>> The main case we'll miss out on is when application runs on the same
>>> CPU as NAPI. In that case we don't use the deferred skb free path.
>>> We could disable softirq one that path, too... maybe?
>>>
> .
> 
