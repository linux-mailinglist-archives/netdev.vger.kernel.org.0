Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A0720D66D
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731253AbgF2TUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:20:00 -0400
Received: from foss.arm.com ([217.140.110.172]:39574 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbgF2TT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:19:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3E111516;
        Mon, 29 Jun 2020 08:41:20 -0700 (PDT)
Received: from [10.57.21.32] (unknown [10.57.21.32])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD4A13F73C;
        Mon, 29 Jun 2020 08:41:18 -0700 (PDT)
Subject: Re: [PATCH net] xsk: remove cheap_dma optimization
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     maximmi@mellanox.com, konrad.wilk@oracle.com,
        jonathan.lemon@gmail.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, magnus.karlsson@intel.com
References: <20200626134358.90122-1-bjorn.topel@gmail.com>
 <c60dfb5a-2bf3-20bd-74b3-6b5e215f73f8@iogearbox.net>
 <20200627070406.GB11854@lst.de>
 <88d27e1b-dbda-301c-64ba-2391092e3236@intel.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <878626a2-6663-0d75-6339-7b3608aa4e42@arm.com>
Date:   Mon, 29 Jun 2020 16:41:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <88d27e1b-dbda-301c-64ba-2391092e3236@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-28 18:16, Björn Töpel wrote:
> 
> On 2020-06-27 09:04, Christoph Hellwig wrote:
>> On Sat, Jun 27, 2020 at 01:00:19AM +0200, Daniel Borkmann wrote:
>>> Given there is roughly a ~5 weeks window at max where this removal could
>>> still be applied in the worst case, could we come up with a fix / 
>>> proposal
>>> first that moves this into the DMA mapping core? If there is 
>>> something that
>>> can be agreed upon by all parties, then we could avoid re-adding the 9%
>>> slowdown. :/
>>
>> I'd rather turn it upside down - this abuse of the internals blocks work
>> that has basically just missed the previous window and I'm not going
>> to wait weeks to sort out the API misuse.  But we can add optimizations
>> back later if we find a sane way.
>>
> 
> I'm not super excited about the performance loss, but I do get
> Christoph's frustration about gutting the DMA API making it harder for
> DMA people to get work done. Lets try to solve this properly using
> proper DMA APIs.
> 
> 
>> That being said I really can't see how this would make so much of a
>> difference.  What architecture and what dma_ops are you using for
>> those measurements?  What is the workload?
>>
> 
> The 9% is for an AF_XDP (Fast raw Ethernet socket. Think AF_PACKET, but 
> faster.) benchmark: receive the packet from the NIC, and drop it. The 
> DMA syncs stand out in the perf top:
> 
>    28.63%  [kernel]                   [k] i40e_clean_rx_irq_zc
>    17.12%  [kernel]                   [k] xp_alloc
>     8.80%  [kernel]                   [k] __xsk_rcv_zc
>     7.69%  [kernel]                   [k] xdp_do_redirect
>     5.35%  bpf_prog_992d9ddc835e5629  [k] bpf_prog_992d9ddc835e5629
>     4.77%  [kernel]                   [k] xsk_rcv.part.0
>     4.07%  [kernel]                   [k] __xsk_map_redirect
>     3.80%  [kernel]                   [k] dma_direct_sync_single_for_cpu
>     3.03%  [kernel]                   [k] dma_direct_sync_single_for_device
>     2.76%  [kernel]                   [k] i40e_alloc_rx_buffers_zc
>     1.83%  [kernel]                   [k] xsk_flush
> ...
> 
> For this benchmark the dma_ops are NULL (dma_is_direct() == true), and
> the main issue is that SWIOTLB is now unconditionally enabled [1] for
> x86, and for each sync we have to check that if is_swiotlb_buffer()
> which involves a some costly indirection.
> 
> That was pretty much what my hack avoided. Instead we did all the checks
> upfront, since AF_XDP has long-term DMA mappings, and just set a flag
> for that.
> 
> Avoiding the whole "is this address swiotlb" in
> dma_direct_sync_single_for_{cpu, device]() per-packet
> would help a lot.

I'm pretty sure that's one of the things we hope to achieve with the 
generic bypass flag :)

> Somewhat related to the DMA API; It would have performance benefits for
> AF_XDP if the DMA range of the mapped memory was linear, i.e. by IOMMU
> utilization. I've started hacking a thing a little bit, but it would be
> nice if such API was part of the mapping core.
> 
> Input: array of pages Output: array of dma addrs (and obviously dev,
> flags and such)
> 
> For non-IOMMU len(array of pages) == len(array of dma addrs)
> For best-case IOMMU len(array of dma addrs) == 1 (large linear space)
> 
> But that's for later. :-)

FWIW you will typically get that behaviour from IOMMU-based 
implementations of dma_map_sg() right now, although it's not strictly 
guaranteed. If you can weather some additional setup cost of calling 
sg_alloc_table_from_pages() plus walking the list after mapping to test 
whether you did get a contiguous result, you could start taking 
advantage of it as some of the dma-buf code in DRM and v4l2 does already 
(although those cases actually treat it as a strict dependency rather 
than an optimisation).

I'm inclined to agree that if we're going to see more of these cases, a 
new API call that did formally guarantee a DMA-contiguous mapping 
(either via IOMMU or bounce buffering) or failure might indeed be handy.

Robin.
