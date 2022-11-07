Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60F961E986
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 04:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiKGDWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 22:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKGDWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 22:22:43 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC8C18D;
        Sun,  6 Nov 2022 19:22:42 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N5GkZ4XBRzmVFC;
        Mon,  7 Nov 2022 11:22:30 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 11:22:40 +0800
Received: from [10.67.108.67] (10.67.108.67) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 7 Nov
 2022 11:22:40 +0800
Message-ID: <917fab11-ae57-07b9-ae67-7c290c7c6723@huawei.com>
Date:   Mon, 7 Nov 2022 11:22:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH net] xfrm: Fix ignored return value in xfrm6_init()
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mkubecek@suse.cz>
References: <20221103090713.188740-1-chenzhongjin@huawei.com>
 <Y2gGIuwY368X8Won@unreal>
From:   Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <Y2gGIuwY368X8Won@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/11/7 3:08, Leon Romanovsky wrote:
> On Thu, Nov 03, 2022 at 05:07:13PM +0800, Chen Zhongjin wrote:
>> When IPv6 module initializing in xfrm6_init(), register_pernet_subsys()
>> is possible to fail but its return value is ignored.
>>
>> If IPv6 initialization fails later and xfrm6_fini() is called,
>> removing uninitialized list in xfrm6_net_ops will cause null-ptr-deref:
>>
>> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
>> CPU: 1 PID: 330 Comm: insmod
>> RIP: 0010:unregister_pernet_operations+0xc9/0x450
>> Call Trace:
>>   <TASK>
>>   unregister_pernet_subsys+0x31/0x3e
>>   xfrm6_fini+0x16/0x30 [ipv6]
>>   ip6_route_init+0xcd/0x128 [ipv6]
>>   inet6_init+0x29c/0x602 [ipv6]
>>   ...
>>
>> Fix it by catching the error return value of register_pernet_subsys().
>>
>> Fixes: 8d068875caca ("xfrm: make gc_thresh configurable in all namespaces")
>> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
>> ---
>>   net/ipv6/xfrm6_policy.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
> I see same error in net/ipv4/xfrm4_policy.c which introduced by same
> commit mentioned in Fixes line.

It's true that in xfrm4_init() the ops->init is possible to fail as well.

However there is no error handling or exit path for ipv4, so IIUC the 
ops won't be unregistered anyway.

Considering that ipv4 don't handle most of error in initialization, 
maybe it's better to keep it as it is?


Best,

Chen

> Thanks
>
