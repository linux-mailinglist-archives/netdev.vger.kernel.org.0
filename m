Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611DF6DC504
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 11:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjDJJVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 05:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJJV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 05:21:29 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243F83A85
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 02:21:29 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Pw3Kb5ykfz17Rrw;
        Mon, 10 Apr 2023 17:17:55 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 10 Apr
 2023 17:20:52 +0800
Subject: Re: [RFC net-next v2 1/3] net: skb: plumb napi state thru skb freeing
 paths
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <brouer@redhat.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>
References: <20230405232100.103392-1-kuba@kernel.org>
 <20230405232100.103392-2-kuba@kernel.org>
 <2628d71f-ef66-6ea9-61da-6d01c04fbda9@huawei.com>
 <20230407071402.09fa792f@kernel.org> <20230407082818.1aefb90f@kernel.org>
 <51926b9f-80f5-9b52-3377-0807b6340662@redhat.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <473dee27-1012-b9da-2353-bb1c814f38ba@huawei.com>
Date:   Mon, 10 Apr 2023 17:20:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <51926b9f-80f5-9b52-3377-0807b6340662@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.5 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/10 1:28, Jesper Dangaard Brouer wrote:
> 
> 
> On 07/04/2023 17.28, Jakub Kicinski wrote:
>> On Fri, 7 Apr 2023 07:14:02 -0700 Jakub Kicinski wrote:
>>>>> -static bool skb_pp_recycle(struct sk_buff *skb, void *data)
>>>>> +static bool skb_pp_recycle(struct sk_buff *skb, void *data, bool in_normal_napi)
>>>>
>>>> What does *normal* means in 'in_normal_napi'?
>>>> can we just use in_napi?
>>>
>>> Technically netpoll also calls NAPI, that's why I threw in the
>>> "normal". If folks prefer in_napi or some other name I'm more
>>> than happy to change. Naming is hard.
>>
>> Maybe I should rename it to in_softirq ? Or napi_safe ?
>> Because __kfree_skb_defer() gets called from the Tx side.
>> And even the Rx deferred free isn't really *in* NAPI.
>>
> 
> I like the name "napi_safe".

+1.

> 
> --Jesper
> 
> .
> 
