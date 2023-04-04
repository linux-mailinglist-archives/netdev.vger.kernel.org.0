Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D8A6D571E
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 05:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbjDDDSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 23:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbjDDDS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 23:18:28 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673F1191
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 20:18:27 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PrCZj1zPVzKvny;
        Tue,  4 Apr 2023 11:15:57 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 4 Apr
 2023 11:18:25 +0800
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely localized
 NAPI
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>
References: <20230331043906.3015706-1-kuba@kernel.org>
 <1f9cf03e-94cf-9787-44ce-23f6a8dd0a7a@huawei.com>
 <20230403184545.3eeb6e83@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <3384c99b-de8d-15d5-b470-b1b56e4b4770@huawei.com>
Date:   Tue, 4 Apr 2023 11:18:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230403184545.3eeb6e83@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.6 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/4 9:45, Jakub Kicinski wrote:
> On Tue, 4 Apr 2023 08:53:36 +0800 Yunsheng Lin wrote:
>> I wonder if we can make this more generic by adding the skb to per napi
>> list instead of sd->defer_list, so that we can always use NAPI kicking to
>> flush skb as net_tx_action() done for sd->completion_queue instead of
>> softirq kicking?
>>
>> And it seems we know which napi binds to a specific socket through
>> busypoll mechanism, we can reuse that to release a skb to the napi
>> bound to that socket?
> 
> Seems doable. My thinking was to first see how well the simpler scheme
> performs with production workloads because it should have no downsides.
Look forwording to some performs data with production workloads:)

> Tracking real NAPI pointers per socket and extra RCU sync to manage
> per-NAPI defer queues may have perf cost.

I suppose the extra RCU sync only happen on the napi add/del process,
not in the data path?

> .
> 
