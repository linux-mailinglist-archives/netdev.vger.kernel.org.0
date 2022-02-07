Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED154AB3BA
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 06:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiBGFqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 00:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238664AbiBGDKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 22:10:32 -0500
X-Greylist: delayed 942 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 19:10:29 PST
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDB5C061A73
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 19:10:29 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JsVxm0Kc8zZfR5;
        Mon,  7 Feb 2022 10:50:36 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Feb 2022 10:54:40 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Mon, 7 Feb
 2022 10:54:40 +0800
Subject: Re: [PATCH net-next v2 4/4] net: hns3: support skb's frag page
 recycling based on page pool
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     <linuxarm@openeuler.org>, <ilias.apalodimas@linaro.org>,
        <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <moyufeng@huawei.com>, <alexanderduyck@fb.com>,
        <brouer@redhat.com>, <kuba@kernel.org>
References: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
 <1628217982-53533-5-git-send-email-linyunsheng@huawei.com>
 <YfFbDivUPbpWjh/m@myrica> <3315a093-582c-f464-d894-cb07522e5547@huawei.com>
 <YfO1q52G7GKl+P40@myrica> <ff54ec37-cb69-cc2f-7ee7-7974f244d843@huawei.com>
 <Yfuk11on6XiaB6Di@myrica>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e0795eee-26d8-1289-e241-b88c967027d7@huawei.com>
Date:   Mon, 7 Feb 2022 10:54:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <Yfuk11on6XiaB6Di@myrica>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/2/3 17:48, Jean-Philippe Brucker wrote:
> On Sat, Jan 29, 2022 at 04:44:34PM +0800, Yunsheng Lin wrote:
>>>> My initial thinking is to track if the reference counting or pp_frag_count of
>>>> the page is manipulated correctly.
>>>
>>> It looks like pp_frag_count is dropped too many times: after (1),
>>> pp_frag_count only has 1 ref, so (2) drops it to 0 and (3) results in
>>> underflow. I turned page_pool_atomic_sub_frag_count_return() into
>>> "atomic_long_sub_return(nr, &page->pp_frag_count)" to make sure (the
>>> atomic_long_read() bit normally hides this). Wasn't entirely sure if this
>>> is expected behavior, though.
>>
>> Are you true the above 1~3 step is happening for the same page?
> 
> Yes they happen on the same page. What I did was save the backtrace of
> each call to page_pool_atomic_sub_frag_count_return() and, when an
> underflow error happens on a page, print out the history of that page
> only.
> 
> My report was not right, though, I forgot to save the backtrace for
> pp_frag_count==0. There's actually two refs on the page. It goes like
> this:
> 
>   (1) T-1535, drop BIAS_MAX - 2, pp_frag_count now 2
>      page_pool_alloc_frag+0x128/0x240
>      hns3_alloc_and_map_buffer+0x30/0x170
>      hns3_nic_alloc_rx_buffers+0x9c/0x170
>      hns3_clean_rx_ring+0x864/0x960
>      hns3_nic_common_poll+0xa0/0x218
>      __napi_poll+0x38/0x188
>      net_rx_action+0xe8/0x248
>      __do_softirq+0x120/0x284
> 
>   (2) T-4, drop 1, pp_frag_count now 1
>      page_pool_put_page+0x98/0x338
>      page_pool_return_skb_page+0x48/0x60
>      skb_release_data+0x170/0x190
>      skb_release_all+0x28/0x38
>      kfree_skb_reason+0x30/0x90
>      packet_rcv+0x58/0x430
>      __netif_receive_skb_list_core+0x1f4/0x218
>      netif_receive_skb_list_internal+0x18c/0x2a8
>   
>   (3) T-1, drop 1, pp_frag_count now 0
>      page_pool_put_page+0x98/0x338
>      page_pool_return_skb_page+0x48/0x60
>      skb_release_data+0x170/0x190
>      skb_release_all+0x28/0x38
>      __kfree_skb+0x18/0x30
>      __sk_defer_free_flush+0x44/0x58
>      tcp_recvmsg+0x94/0x1b8
>      inet_recvmsg+0x50/0x128
>   
>   (4) T, drop 1, pp_frag_count now -1 (underflow)
>      page_pool_put_page+0x2d0/0x338
>      hns3_clean_rx_ring+0x74c/0x960
>      hns3_nic_common_poll+0xa0/0x218
>      __napi_poll+0x38/0x188
>      net_rx_action+0xe8/0x248
> 
>> If it is the same page, there must be something wrong here.
>>
>> Normally there are 1024 BD for a rx ring:
>>
>> BD_0 BD_1 BD_2 BD_3 BD_4 .... BD_1020 BD_1021  BD_1022  BD_1023
>>            ^         ^
>>          head       tail
>>
>> Suppose head is manipulated by driver, and tail is manipulated by
>> hw.
>>
>> driver allocates buffer for BD pointed by head, as the frag page
>> recycling is introduced in this patch, the BD_0 and BD_1's buffer
>> may point to the same page（4K page size, and each BD only need
>> 2k Buffer.
>> hw dma the data to the buffer pointed by tail when packet is received.
>>
>> so step 1 Normally happen for the BD pointed by head,
>> and step 2 & 3 Normally happen for the BD pointed by tail.
>> And Normally there are at least (1024 - RCB_NOF_ALLOC_RX_BUFF_ONCE) BD
>> between head and tail, so it is unlikely that head and tail's BD buffer
>> points to the same page.
> 
> I think a new page is allocated at step 1, no?  The driver calls
> page_pool_alloc_frag() when refilling the rx ring, and since the current
> pool->frag_page (P1) is still used by BD_0 and BD_1, then
> page_pool_drain_frag() drops (BIAS_MAX - 2) references and
> page_pool_alloc_frag() replaces frag_page with a new page, P2. Later, head
> points to BD_1, the driver can drop the remaining 2 references to P1 in
> steps 2 and 3, and P1 can be unmapped and freed/recycled

Yes.
For most of the case, there should be two steps of the 2/3/4 steps, when
there is extra step in the above calltrace, it may mean the page_count()
is 2 instead of 1, if that is the case, __skb_frag_ref() may be called
for a page from page pool((page->pp_magic & ~0x3UL) == PP_SIGNATURE)),
which is not supposed to happen.

> 
> What I don't get is which of steps 2, 3 and 4 is the wrong one. Could be
> 2 or 3 because the device is evidently still doing DMA to the page after
> it's released, but it could also be that the driver doesn't properly clear
> the BD in which case step 4 is wrong. I'll try to find out which fragment
> gets dropped twice.

When there are more than two steps for the freeing side, the only case I know
about the skb cloning and expanding case, which is fixed by the below commit:
2cc3aeb5eccc (skbuff: Fix a potential race while recycling page_pool packets)

Maybe there are other case we missed?


> 
> Thanks,
> Jean
> 
> .
> 
