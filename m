Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A2C6C60A0
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 08:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjCWHZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 03:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjCWHZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 03:25:00 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7645EDBCA;
        Thu, 23 Mar 2023 00:24:41 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Phxfl6ByNzKmrP;
        Thu, 23 Mar 2023 15:24:15 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Thu, 23 Mar
 2023 15:24:38 +0800
Subject: Re: [PATCH net-next 2/8] virtio_net: mergeable xdp: introduce
 mergeable_xdp_prepare
To:     Jason Wang <jasowang@redhat.com>
CC:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20230322030308.16046-1-xuanzhuo@linux.alibaba.com>
 <20230322030308.16046-3-xuanzhuo@linux.alibaba.com>
 <c7749936-c154-da51-ccfb-f16150d19c62@huawei.com>
 <1679535924.6219428-2-xuanzhuo@linux.alibaba.com>
 <215e791d-1802-2419-ff59-49476bcdcd02@huawei.com>
 <CACGkMEv=0gt6LS0HSgKELQqnWfQ2UdFgAKdvh=CLaAPLeNytww@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <00509559-f3b6-2914-76f4-39e9e96f37c1@huawei.com>
Date:   Thu, 23 Mar 2023 15:24:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CACGkMEv=0gt6LS0HSgKELQqnWfQ2UdFgAKdvh=CLaAPLeNytww@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/23 13:40, Jason Wang wrote:
>>>
>>>>
>>>> Also, it seems better to split the xdp_linearize_page() to two functions
>>>> as pskb_expand_head() and __skb_linearize() do, one to expand the headroom,
>>>> the other one to do the linearizing.
>>>
>>> No skb here.
>>
>> I means following the semantics of pskb_expand_head() and __skb_linearize(),
>> not to combine the headroom expanding and linearizing into one function as
>> xdp_linearize_page() does now if we want a better refoctor result.
> 
> Not sure it's worth it, since the use is very specific unless we could
> find a case that wants only one of them.

It seems receive_small() only need the headroom expanding one.
For receive_mergeable(), it seems we can split into the below cases:
1. " (!xdp_prog->aux->xdp_has_frags && (num_buf > 1 || headroom < virtnet_get_headroom(vi)))"
   case only need linearizing.
2. other cases only need headroom/tailroom expanding.

Anyway, it is your call to decide if you want to take this
opportunity do a better refoctoring to virtio_net.

> 
> Thanks
> 
>>
>>>
>>>
>>>>
>>
> 
> 
> .
> 
