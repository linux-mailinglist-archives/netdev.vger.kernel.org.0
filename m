Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE7E4A2D38
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 09:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352474AbiA2Ioi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 03:44:38 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:35884 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352487AbiA2Ioi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 03:44:38 -0500
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Jm7CL2SpGzcckV;
        Sat, 29 Jan 2022 16:43:42 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 29 Jan 2022 16:44:34 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Sat, 29 Jan
 2022 16:44:34 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
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
 <YfO1q52G7GKl+P40@myrica>
Message-ID: <ff54ec37-cb69-cc2f-7ee7-7974f244d843@huawei.com>
Date:   Sat, 29 Jan 2022 16:44:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YfO1q52G7GKl+P40@myrica>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme705-chm.china.huawei.com (10.1.199.101) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/1/28 17:21, Jean-Philippe Brucker wrote:
> On Fri, Jan 28, 2022 at 12:00:35PM +0800, Yunsheng Lin wrote:
>> On 2022/1/26 22:30, Jean-Philippe Brucker wrote:
>>> Hi,
>>>
>>> On Fri, Aug 06, 2021 at 10:46:22AM +0800, Yunsheng Lin wrote:
>>>> This patch adds skb's frag page recycling support based on
>>>> the frag page support in page pool.
>>>>
>>>> The performance improves above 10~20% for single thread iperf
>>>> TCP flow with IOMMU disabled when iperf server and irq/NAPI
>>>> have a different CPU.
>>>>
>>>> The performance improves about 135%(14Gbit to 33Gbit) for single
>>>> thread iperf TCP flow when IOMMU is in strict mode and iperf
>>>> server shares the same cpu with irq/NAPI.
>>>>
>>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>>
>>> This commit is giving me some trouble, but I haven't managed to pinpoint
>>> the exact problem.
>>
>> Hi,
>> Thanks for reporting the problem.
>>
>> We also hit a similiar problem during internal CI testing, but was not
>> able to trigger it manually, so was not able to find the root case yet.
>>
>> Is your test case more likely to trigger the problem?
> 
> The problem shows up shortly after boot for me, when I'm not doing
> anything special, just ssh'ing into the server. I did manage to trigger it
> faster with a "netperf -T TCP_MAERTS" job. Maybe I have something enabled
> in my config that makes it easier to trigger?  Attached the .config to
> this reply, but I think it corresponds pretty much to debian's config.

I tried the above config, unfortunately I was still not able to trigger
the problem.

> 
>>> Symptoms are:
>>> * A page gets unmapped twice from page_pool_release_page(). The second
>>>   time, dma-iommu.c warns about the empty PTE [1]
>>> * The rx ring still accesses the page after the first unmap, causing SMMU
>>>   translation faults [2]
>>> * That leads to APEI errors and reset of the device, at which time
>>>   page_pool_inflight() complains about "Negative(-x) inflight packet-pages".
>>>
>>> After some debugging, it looks like the page gets released three times
>>> instead of two:
>>>
>>> (1) first in page_pool_drain_frag():
>>>
>>>         page_pool_alloc_frag+0x1fc/0x248
>>>         hns3_alloc_and_map_buffer+0x30/0x170
>>>         hns3_nic_alloc_rx_buffers+0x9c/0x170
>>>         hns3_clean_rx_ring+0x854/0x950
>>>         hns3_nic_common_poll+0xa0/0x218
>>>         __napi_poll+0x38/0x1b0
>>>         net_rx_action+0xe8/0x248
>>>         __do_softirq+0x120/0x284
>>>
>>> (2) Then later by page_pool_return_skb_page(), which (I guess) unmaps the
>>>     page:
>>>
>>>         page_pool_put_page+0x214/0x308
>>>         page_pool_return_skb_page+0x48/0x60
>>>         skb_release_data+0x168/0x188
>>>         skb_release_all+0x28/0x38
>>>         kfree_skb+0x30/0x90
>>>         packet_rcv+0x4c/0x410
>>>         __netif_receive_skb_list_core+0x1f4/0x218
>>>         netif_receive_skb_list_internal+0x18c/0x2a8
>>>
>>> (3) And finally, soon after, by clean_rx_ring() which causes pp_frag_count
>>>     underflow (seen after removing the optimization in
>>>     page_pool_atomic_sub_frag_count_return):
>>>
>>>         page_pool_put_page+0x2a0/0x308
>>>           page_pool_put_full_page
>>>           hns3_alloc_skb
>>>           hns3_handle_rx_bd
>>>         hns3_clean_rx_ring+0x744/0x950
>>>         hns3_nic_common_poll+0xa0/0x218
>>>         __napi_poll+0x38/0x1b0
>>>         net_rx_action+0xe8/0x248
>>>
>>> So I'm guessing (2) happens too early while the RX ring is still using the
>>> page, but I don't know more. I'd be happy to add more debug and to test
>>
>> If the reference counting or pp_frag_count of the page is manipulated correctly,
>> I think step 2&3 does not have any dependency between each other.
>>
>>> fixes if you have any suggestions.
>>
>> My initial thinking is to track if the reference counting or pp_frag_count of
>> the page is manipulated correctly.
> 
> It looks like pp_frag_count is dropped too many times: after (1),
> pp_frag_count only has 1 ref, so (2) drops it to 0 and (3) results in
> underflow. I turned page_pool_atomic_sub_frag_count_return() into
> "atomic_long_sub_return(nr, &page->pp_frag_count)" to make sure (the
> atomic_long_read() bit normally hides this). Wasn't entirely sure if this
> is expected behavior, though.

Are you true the above 1~3 step is happening for the same page?
If it is the same page, there must be something wrong here.

Normally there are 1024 BD for a rx ring:

BD_0 BD_1 BD_2 BD_3 BD_4 .... BD_1020 BD_1021  BD_1022  BD_1023
           ^         ^
         head       tail

Suppose head is manipulated by driver, and tail is manipulated by
hw.

driver allocates buffer for BD pointed by head, as the frag page
recycling is introduced in this patch, the BD_0 and BD_1's buffer
may point to the same page（4K page size, and each BD only need
2k Buffer.
hw dma the data to the buffer pointed by tail when packet is received.

so step 1 Normally happen for the BD pointed by head,
and step 2 & 3 Normally happen for the BD pointed by tail.
And Normally there are at least (1024 - RCB_NOF_ALLOC_RX_BUFF_ONCE) BD
between head and tail, so it is unlikely that head and tail's BD buffer
points to the same page.


> 
> Thanks,
> Jean
> 
>>
>> Perhaps using the newly added reference counting tracking infrastructure?
>> Will look into how to use the reference counting tracking infrastructure
>> for the above problem.
>>
>>>
>>> Thanks,
>>> Jean
>>>
>>>
>>> [1] ------------[ cut here ]------------
>>>      WARNING: CPU: 71 PID: 0 at drivers/iommu/dma-iommu.c:848 iommu_dma_unmap_page+0xbc/0xd8
>>>      Modules linked in: fuse overlay ipmi_si hisi_hpre hisi_zip ecdh_generic hisi_trng_v2 ecc ipmi_d>
>>>      CPU: 71 PID: 0 Comm: swapper/71 Not tainted 5.16.0-g3813c61fbaad #22
>>>      Hardware name: Huawei TaiShan 2280 V2/BC82AMDC, BIOS 2280-V2 CS V5.B133.01 03/25/2021
>>>      pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>>>      pc : iommu_dma_unmap_page+0xbc/0xd8
>>>      lr : iommu_dma_unmap_page+0x38/0xd8
>>>      sp : ffff800010abb8d0
>>>      x29: ffff800010abb8d0 x28: ffff20200ee80000 x27: 0000000000000042
>>>      x26: ffff20201a7ed800 x25: ffff20200be7a5c0 x24: 0000000000000002
>>>      x23: 0000000000000020 x22: 0000000000001000 x21: 0000000000000000
>>>      x20: 0000000000000002 x19: ffff002086b730c8 x18: 0000000000000001
>>>      x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
>>>      x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000008
>>>      x11: 000000000000ffff x10: 0000000000000001 x9 : 0000000000000004
>>>      x8 : 0000000000000000 x7 : 0000000000000000 x6 : ffff202006274800
>>>      x5 : 0000000000000009 x4 : 0000000000000001 x3 : 000000000000001e
>>>      x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
>>>      Call trace:
>>>       iommu_dma_unmap_page+0xbc/0xd8
>>>       dma_unmap_page_attrs+0x30/0x1d0
>>>       page_pool_release_page+0x40/0x88
>>>       page_pool_return_page+0x18/0x80
>>>       page_pool_put_page+0x248/0x288
>>>       hns3_clean_rx_ring+0x744/0x950
>>>       hns3_nic_common_poll+0xa0/0x218
>>>       __napi_poll+0x38/0x1b0
>>>       net_rx_action+0xe8/0x248
>>>       __do_softirq+0x120/0x284
>>>       irq_exit_rcu+0xe0/0x100
>>>       el1_interrupt+0x3c/0x88
>>>       el1h_64_irq_handler+0x18/0x28
>>>       el1h_64_irq+0x78/0x7c
>>>       arch_cpu_idle+0x18/0x28
>>>       default_idle_call+0x20/0x68
>>>       do_idle+0x214/0x260
>>>       cpu_startup_entry+0x28/0x70
>>>       secondary_start_kernel+0x160/0x170
>>>       __secondary_switched+0x90/0x94
>>>      ---[ end trace 432d1737b4b96ed9 ]---
>>>
>>>     (please ignore the kernel version, I can reproduce this with v5.14 and
>>>     v5.17-rc1, and bisected to this commit.)
>>>
>>> [2] arm-smmu-v3 arm-smmu-v3.6.auto: event 0x10 received:
>>>     arm-smmu-v3 arm-smmu-v3.6.auto: 	0x0000bd0000000010
>>>     arm-smmu-v3 arm-smmu-v3.6.auto: 	0x000012000000007c
>>>     arm-smmu-v3 arm-smmu-v3.6.auto: 	0x00000000ff905800
>>>     arm-smmu-v3 arm-smmu-v3.6.auto: 	0x00000000ff905000
> 
