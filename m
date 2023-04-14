Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5AFE6E195E
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 02:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjDNA5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 20:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDNA5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 20:57:07 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D887426B8
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 17:57:05 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PyHxg4x5Gz17MT7;
        Fri, 14 Apr 2023 08:53:27 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 14 Apr
 2023 08:57:03 +0800
Subject: Re: [PATCH net-next v2 1/3] net: skb: plumb napi state thru skb
 freeing paths
To:     Eric Dumazet <edumazet@google.com>
CC:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <alexander.duyck@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230413042605.895677-1-kuba@kernel.org>
 <20230413042605.895677-2-kuba@kernel.org>
 <4447f0d2-dd78-573a-6d89-aa1e478ea46b@huawei.com>
 <CANn89iJkg=B0D23q_evwqjRVvm0kcNA=xvSRHVxjgeR00HgEjA@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <dd743d1e-d8a1-58d5-5b1f-8583d0f23b9f@huawei.com>
Date:   Fri, 14 Apr 2023 08:57:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJkg=B0D23q_evwqjRVvm0kcNA=xvSRHVxjgeR00HgEjA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/13 16:51, Eric Dumazet wrote:
> On Thu, Apr 13, 2023 at 9:49 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> Maybe I missed something obvious about netpoll here.
>> Does that mean the "normal NAPI context" and "not normal NAPI context"
>> will call napi->poll() concurrently with different budget? Doesn't
>> that mean two different contexts may do the tx completion concurrently?
> 
> Please take a look at netpoll code:
> netpoll_poll_lock, poll_napi() and poll_one_napi()
> 
>> Does it break the single-producer single-consumer assumption of tx queue?
> 
> We do not think so.

Then I guess it is ok to do direct recycling for page pool case as it is
per napi?

It is per cpu cache case we are using !!bugget to protect it from preemption
while netpoll_poll_dev() is running?


> .
> 
