Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95268269B54
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIOBlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:41:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12280 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbgIOBlV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 21:41:21 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 622865FBFC3D407F7873;
        Tue, 15 Sep 2020 09:41:19 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Tue, 15 Sep 2020 09:41:13 +0800
Subject: Re: [PATCH net-next 5/6] net: hns3: use writel() to optimize the
 barrier operation
To:     Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
 <1600085217-26245-6-git-send-email-tanhuazhong@huawei.com>
 <20200914144522.02d469a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <4141ed72-c359-ca49-d4a5-57a810888083@huawei.com>
Date:   Tue, 15 Sep 2020 09:41:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20200914144522.02d469a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/15 5:45, Jakub Kicinski wrote:
> On Mon, 14 Sep 2020 20:06:56 +0800 Huazhong Tan wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>
>> writel() can be used to order I/O vs memory by default when
>> writing portable drivers. Use writel() to replace wmb() +
>> writel_relaxed(), and writel() is dma_wmb() + writel_relaxed()
>> for ARM64, so there is an optimization here because dma_wmb()
>> is a lighter barrier than wmb().
> 
> Cool, although lots of drivers will need a change like this now. 
> 
> And looks like memory-barriers.txt is slightly, eh, not coherent there,
> between the documentation of writeX() and dma_wmb() :S
> 
> 	3. A writeX() by a CPU thread to the peripheral will first wait for the
> 	   completion of all prior writes to memory either issued by, or

"wait for the completion of all prior writes to memory" seems to match the semantics
of writel() here?

> 	   propagated to, the same thread. This ensures that writes by the CPU
> 	   to an outbound DMA buffer allocated by dma_alloc_coherent() will be

"outbound DMA buffer" mapped by the streaming API can also be ordered by the
writel(), Is that what you meant by "not coherent"?


> 	   visible to a DMA engine when the CPU writes to its MMIO control
> 	   register to trigger the transfer.
> 
> 
> 
>  (*) dma_wmb();
>  (*) dma_rmb();
> 
>      These are for use with consistent memory to guarantee the ordering
>      of writes or reads of shared memory accessible to both the CPU and a
>      DMA capable device.
> 
>      For example, consider a device driver that shares memory with a device
>      and uses a descriptor status value to indicate if the descriptor belongs
>      to the device or the CPU, and a doorbell to notify it when new
>      descriptors are available:
> 
> 	if (desc->status != DEVICE_OWN) {
> 		/* do not read data until we own descriptor */
> 		dma_rmb();
> 
> 		/* read/modify data */
> 		read_data = desc->data;
> 		desc->data = write_data;
> 
> 		/* flush modifications before status update */
> 		dma_wmb();
> 
> 		/* assign ownership */
> 		desc->status = DEVICE_OWN;
> 
> 		/* notify device of new descriptors */
> 		writel(DESC_NOTIFY, doorbell);
> 	}
> 
>      The dma_rmb() allows us guarantee the device has released ownership
>      before we read the data from the descriptor, and the dma_wmb() allows
>      us to guarantee the data is written to the descriptor before the device
>      can see it now has ownership.  Note that, when using writel(), a prior
>      wmb() is not needed to guarantee that the cache coherent memory writes
>      have completed before writing to the MMIO region.  The cheaper
>      writel_relaxed() does not provide this guarantee and must not be used
>      here.

I am not sure writel() has any implication here. My interpretation to the above
doc is that dma_wmb() is more appropriate when only coherent/consistent memory
need to be ordered.

If writel() is used, then dma_wmb() or wmb() is unnecessary, see:

commit: 5846581e3563 ("locking/memory-barriers.txt: Fix broken DMA vs. MMIO ordering example")


> .
> 
