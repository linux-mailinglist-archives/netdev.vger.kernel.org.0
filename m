Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8BE6ECBAF
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 13:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjDXL6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 07:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjDXL6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 07:58:12 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11C2F1;
        Mon, 24 Apr 2023 04:58:10 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q4k7Y3Hv1znbcx;
        Mon, 24 Apr 2023 19:54:17 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 24 Apr
 2023 19:58:07 +0800
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
 <3c78f045-aa8e-22a5-4b38-ab271122a79e@huawei.com>
 <ZEZJHCRsBVQwd9ie@localhost.localdomain>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <0c1790dc-dbeb-8664-64ca-1f71e6c4f3a9@huawei.com>
Date:   Mon, 24 Apr 2023 19:58:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <ZEZJHCRsBVQwd9ie@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/24 17:17, Lorenzo Bianconi wrote:
>> On 2023/4/23 22:20, Lorenzo Bianconi wrote:
>>>> On 2023/4/23 2:54, Lorenzo Bianconi wrote:
>>>>>  struct veth_priv {
>>>>> @@ -727,17 +729,20 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>>>>>  			goto drop;
>>>>>  
>>>>>  		/* Allocate skb head */
>>>>> -		page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
>>>>> +		page = page_pool_dev_alloc_pages(rq->page_pool);
>>>>>  		if (!page)
>>>>>  			goto drop;
>>>>>  
>>>>>  		nskb = build_skb(page_address(page), PAGE_SIZE);
>>>>
>>>> If page pool is used with PP_FLAG_PAGE_FRAG, maybe there is some additional
>>>> improvement for the MTU 1500B case, it seem a 4K page is able to hold two skb.
>>>> And we can reduce the memory usage too, which is a significant saving if page
>>>> size is 64K.
>>>
>>> please correct if I am wrong but I think the 1500B MTU case does not fit in the
>>> half-page buffer size since we need to take into account VETH_XDP_HEADROOM.
>>> In particular:
>>>
>>> - VETH_BUF_SIZE = 2048
>>> - VETH_XDP_HEADROOM = 256 + 2 = 258
>>
>> On some arch the NET_IP_ALIGN is zero.
>>
>> I suppose XDP_PACKET_HEADROOM are for xdp_frame and data_meta, it seems
>> xdp_frame is only 40 bytes for 64 bit arch and max size of metalen is 32
>> as xdp_metalen_invalid() suggest, is there any other reason why we need
>> 256 bytes here?
> 
> XDP_PACKET_HEADROOM must be greater than (40 + 32)B because you may want push
> new data at the beginning of the xdp_buffer/xdp_frame running
> bpf_xdp_adjust_head() helper.
> I think 256B has been selected for XDP_PACKET_HEADROOM since it is 4 cachelines
> (but I can be wrong).
> There was a discussion in the past to reduce XDP_PACKET_HEADROOM to 192B but
> this is not merged yet and it is not related to this series. We can address
> your comments in a follow-up patch when XDP_PACKET_HEADROOM series is merged.

It worth mentioning that the performance gain in this patch is at the cost of
more memory usage, at most of VETH_RING_SIZE(256) + PP_ALLOC_CACHE_SIZE(128)
pages is used.

IMHO, it seems better to limit the memory usage as much as possible, or provide a
way to disable/enable page pool for user.
