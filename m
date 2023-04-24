Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFADD6EC396
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 04:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjDXCaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 22:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjDXCaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 22:30:02 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C73D1BE6;
        Sun, 23 Apr 2023 19:30:01 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q4TWY1zW6zSswL;
        Mon, 24 Apr 2023 10:25:45 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 24 Apr
 2023 10:29:58 +0800
Subject: Re: [PATCH v2 net-next 1/2] net: veth: add page_pool for page
 recycling
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC:     Lorenzo Bianconi <lorenzo@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>
References: <cover.1682188837.git.lorenzo@kernel.org>
 <6298f73f7cc7391c7c4a52a6a89b1ae21488bda1.1682188837.git.lorenzo@kernel.org>
 <4f008243-49d0-77aa-0e7f-d20be3a68f3c@huawei.com>
 <ZEU+vospFdm08IeE@localhost.localdomain>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <3c78f045-aa8e-22a5-4b38-ab271122a79e@huawei.com>
Date:   Mon, 24 Apr 2023 10:29:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <ZEU+vospFdm08IeE@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/23 22:20, Lorenzo Bianconi wrote:
>> On 2023/4/23 2:54, Lorenzo Bianconi wrote:
>>>  struct veth_priv {
>>> @@ -727,17 +729,20 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>>>  			goto drop;
>>>  
>>>  		/* Allocate skb head */
>>> -		page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
>>> +		page = page_pool_dev_alloc_pages(rq->page_pool);
>>>  		if (!page)
>>>  			goto drop;
>>>  
>>>  		nskb = build_skb(page_address(page), PAGE_SIZE);
>>
>> If page pool is used with PP_FLAG_PAGE_FRAG, maybe there is some additional
>> improvement for the MTU 1500B case, it seem a 4K page is able to hold two skb.
>> And we can reduce the memory usage too, which is a significant saving if page
>> size is 64K.
> 
> please correct if I am wrong but I think the 1500B MTU case does not fit in the
> half-page buffer size since we need to take into account VETH_XDP_HEADROOM.
> In particular:
> 
> - VETH_BUF_SIZE = 2048
> - VETH_XDP_HEADROOM = 256 + 2 = 258

On some arch the NET_IP_ALIGN is zero.

I suppose XDP_PACKET_HEADROOM are for xdp_frame and data_meta, it seems
xdp_frame is only 40 bytes for 64 bit arch and max size of metalen is 32
as xdp_metalen_invalid() suggest, is there any other reason why we need
256 bytes here?

> - max_headsize = SKB_WITH_OVERHEAD(VETH_BUF_SIZE - VETH_XDP_HEADROOM) = 1470
> 
> Even in this case we will need the consume a full page. In fact, performances
> are a little bit worse:
> 
> MTU 1500: tcp throughput ~ 8.3Gbps
> 
> Do you agree or am I missing something?
> 
> Regards,
> Lorenzo
