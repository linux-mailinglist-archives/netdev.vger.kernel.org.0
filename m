Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0A46E19D2
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 03:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjDNBlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 21:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDNBlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 21:41:07 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD37E1707
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 18:41:05 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PyJw103JJzSrXM;
        Fri, 14 Apr 2023 09:37:05 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 14 Apr
 2023 09:41:03 +0800
Subject: Re: [PATCH v5] skbuff: Fix a race between coalescing and releasing
 SKBs
To:     Eric Dumazet <edumazet@google.com>
CC:     Liang Chen <liangchen.linux@gmail.com>, <kuba@kernel.org>,
        <ilias.apalodimas@linaro.org>, <hawk@kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <alexander.duyck@gmail.com>
References: <20230413090353.14448-1-liangchen.linux@gmail.com>
 <d7cd5acd-141f-32c4-6d7b-3563d67318e9@huawei.com>
 <CANn89iKqYawM9ren=_Tus3NMOKBM3f-5pXaHcZiMsK7rDgYXZg@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <0e990a33-0c74-a400-ee23-c4d430230702@huawei.com>
Date:   Fri, 14 Apr 2023 09:41:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKqYawM9ren=_Tus3NMOKBM3f-5pXaHcZiMsK7rDgYXZg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/13 21:45, Eric Dumazet wrote:
> On Thu, Apr 13, 2023 at 1:42 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2023/4/13 17:03, Liang Chen wrote:
> 
>>> Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
>>
>> I am not quite sure the above is right Fixes tag.
>> As 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment recycling") has tried
>> to fix it, and it missed the case this patch is fixing, so we need another fix here.
> 
> The Fixes: tag is more about pointing to stable teams how to deal with
> backports.
> There is no point giving the full chain, because this 'blamed' commit is enough.
> 
> If an old kernel does not contain this commit, there is no point trying harder.

In that case, it may be better to point to
6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling") too.

As even without fragment support, for below case:
to->pp_recycle    --> true
from->pp_recycle  --> true
skb_cloned(from)  --> true

It seems some page may be called with page_pool_release_page() twice if 'to' and
cloned skb of 'from' are freed concurrently, as there is data race between checking
page->pp_magic and clearing page->pp_magic.

Anyway, as it is merged already, I guess it is not really matter anymore.


> .
> 
