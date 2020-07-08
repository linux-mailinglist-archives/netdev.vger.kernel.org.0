Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BED2188D2
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 15:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbgGHNSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 09:18:46 -0400
Received: from foss.arm.com ([217.140.110.172]:39838 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729145AbgGHNSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 09:18:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46CDB1FB;
        Wed,  8 Jul 2020 06:18:43 -0700 (PDT)
Received: from [10.57.21.32] (unknown [10.57.21.32])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5516A3F718;
        Wed,  8 Jul 2020 06:18:41 -0700 (PDT)
Subject: Re: [PATCH net] xsk: remove cheap_dma optimization
To:     Christoph Hellwig <hch@lst.de>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>, maximmi@mellanox.com,
        konrad.wilk@oracle.com, jonathan.lemon@gmail.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com
References: <20200626134358.90122-1-bjorn.topel@gmail.com>
 <c60dfb5a-2bf3-20bd-74b3-6b5e215f73f8@iogearbox.net>
 <20200627070406.GB11854@lst.de>
 <88d27e1b-dbda-301c-64ba-2391092e3236@intel.com>
 <878626a2-6663-0d75-6339-7b3608aa4e42@arm.com> <20200708065014.GA5694@lst.de>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <79926b59-0eb9-2b88-b1bb-1bd472b10370@arm.com>
Date:   Wed, 8 Jul 2020 14:18:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200708065014.GA5694@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-08 07:50, Christoph Hellwig wrote:
> On Mon, Jun 29, 2020 at 04:41:16PM +0100, Robin Murphy wrote:
>> On 2020-06-28 18:16, Bjï¿½rn Tï¿½pel wrote:
>>>
>>> On 2020-06-27 09:04, Christoph Hellwig wrote:
>>>> On Sat, Jun 27, 2020 at 01:00:19AM +0200, Daniel Borkmann wrote:
>>>>> Given there is roughly a ~5 weeks window at max where this removal could
>>>>> still be applied in the worst case, could we come up with a fix /
>>>>> proposal
>>>>> first that moves this into the DMA mapping core? If there is something
>>>>> that
>>>>> can be agreed upon by all parties, then we could avoid re-adding the 9%
>>>>> slowdown. :/
>>>>
>>>> I'd rather turn it upside down - this abuse of the internals blocks work
>>>> that has basically just missed the previous window and I'm not going
>>>> to wait weeks to sort out the API misuse.ï¿½ But we can add optimizations
>>>> back later if we find a sane way.
>>>>
>>>
>>> I'm not super excited about the performance loss, but I do get
>>> Christoph's frustration about gutting the DMA API making it harder for
>>> DMA people to get work done. Lets try to solve this properly using
>>> proper DMA APIs.
>>>
>>>
>>>> That being said I really can't see how this would make so much of a
>>>> difference.ï¿½ What architecture and what dma_ops are you using for
>>>> those measurements?ï¿½ What is the workload?
>>>>
>>>
>>> The 9% is for an AF_XDP (Fast raw Ethernet socket. Think AF_PACKET, but
>>> faster.) benchmark: receive the packet from the NIC, and drop it. The DMA
>>> syncs stand out in the perf top:
>>>
>>>   ï¿½ 28.63%ï¿½ [kernel]ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ [k] i40e_clean_rx_irq_zc
>>>   ï¿½ 17.12%ï¿½ [kernel]ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ [k] xp_alloc
>>>   ï¿½ï¿½ 8.80%ï¿½ [kernel]ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ [k] __xsk_rcv_zc
>>>   ï¿½ï¿½ 7.69%ï¿½ [kernel]ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ [k] xdp_do_redirect
>>>   ï¿½ï¿½ 5.35%ï¿½ bpf_prog_992d9ddc835e5629ï¿½ [k] bpf_prog_992d9ddc835e5629
>>>   ï¿½ï¿½ 4.77%ï¿½ [kernel]ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ [k] xsk_rcv.part.0
>>>   ï¿½ï¿½ 4.07%ï¿½ [kernel]ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ [k] __xsk_map_redirect
>>>   ï¿½ï¿½ 3.80%ï¿½ [kernel]ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ [k] dma_direct_sync_single_for_cpu
>>>   ï¿½ï¿½ 3.03%ï¿½ [kernel]ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ [k] dma_direct_sync_single_for_device
>>>   ï¿½ï¿½ 2.76%ï¿½ [kernel]ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ [k] i40e_alloc_rx_buffers_zc
>>>   ï¿½ï¿½ 1.83%ï¿½ [kernel]ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ [k] xsk_flush
>>> ...
>>>
>>> For this benchmark the dma_ops are NULL (dma_is_direct() == true), and
>>> the main issue is that SWIOTLB is now unconditionally enabled [1] for
>>> x86, and for each sync we have to check that if is_swiotlb_buffer()
>>> which involves a some costly indirection.
>>>
>>> That was pretty much what my hack avoided. Instead we did all the checks
>>> upfront, since AF_XDP has long-term DMA mappings, and just set a flag
>>> for that.
>>>
>>> Avoiding the whole "is this address swiotlb" in
>>> dma_direct_sync_single_for_{cpu, device]() per-packet
>>> would help a lot.
>>
>> I'm pretty sure that's one of the things we hope to achieve with the
>> generic bypass flag :)
>>
>>> Somewhat related to the DMA API; It would have performance benefits for
>>> AF_XDP if the DMA range of the mapped memory was linear, i.e. by IOMMU
>>> utilization. I've started hacking a thing a little bit, but it would be
>>> nice if such API was part of the mapping core.
>>>
>>> Input: array of pages Output: array of dma addrs (and obviously dev,
>>> flags and such)
>>>
>>> For non-IOMMU len(array of pages) == len(array of dma addrs)
>>> For best-case IOMMU len(array of dma addrs) == 1 (large linear space)
>>>
>>> But that's for later. :-)
>>
>> FWIW you will typically get that behaviour from IOMMU-based implementations
>> of dma_map_sg() right now, although it's not strictly guaranteed. If you
>> can weather some additional setup cost of calling
>> sg_alloc_table_from_pages() plus walking the list after mapping to test
>> whether you did get a contiguous result, you could start taking advantage
>> of it as some of the dma-buf code in DRM and v4l2 does already (although
>> those cases actually treat it as a strict dependency rather than an
>> optimisation).
> 
> Yikes.

Heh, consider it as iommu_dma_alloc_remap() and 
vb2_dc_get_contiguous_size() having a beautiful baby ;)

>> I'm inclined to agree that if we're going to see more of these cases, a new
>> API call that did formally guarantee a DMA-contiguous mapping (either via
>> IOMMU or bounce buffering) or failure might indeed be handy.
> 
> I was planning on adding a dma-level API to add more pages to an
> IOMMU batch, but was waiting for at least the intel IOMMU driver to be
> converted to the dma-iommu code (and preferably arm32 and s390 as well).

FWIW I did finally get round to having an initial crack at arm32 
recently[1] - of course it needs significant rework already for all the 
IOMMU API motion, and I still need to attempt to test any of it (at 
least I do have a couple of 32-bit boards here), but with any luck I 
hope I'll be able to pick it up again next cycle.

> Here is my old pseudo-code sketch for what I was aiming for from the
> block/nvme perspective.  I haven't even implemented it yet, so there might
> be some holes in the design:
> 
> 
> /*
>   * Returns 0 if batching is possible, postitive number of segments required
>   * if batching is not possible, or negatie values on error.
>   */
> int dma_map_batch_start(struct device *dev, size_t rounded_len,
> 	enum dma_data_direction dir, unsigned long attrs, dma_addr_t *addr);
> int dma_map_batch_add(struct device *dev, dma_addr_t *addr, struct page *page,
> 		unsigned long offset, size_t size);
> int dma_map_batch_end(struct device *dev, int ret, dma_addr_t start_addr);

Just as an initial thought, it's probably nicer to have some kind of 
encapsulated state structure to pass around between these calls rather 
than a menagerie of bare address pointers, similar to what we did with 
iommu_iotlb_gather. An IOMMU-based backend might not want to commit 
batch_add() calls immediately, but look for physically-sequential pages 
and merge them into larger mappings if it can, and keeping track of 
things based only on next_addr, when multiple batch requests could be 
happening in parallel for the same device, would get messy fast.

I also don't entirely see how the backend can be expected to determine 
the number of segments required in advance - e.g. bounce-buffering could 
join two half-page segments into one while an IOMMU typically couldn't, 
yet the opposite might also be true of larger multi-page segments.

Robin.

[1] 
http://www.linux-arm.org/git?p=linux-rm.git;a=shortlog;h=refs/heads/arm/dma

> int blk_dma_map_rq(struct device *dev, struct request *rq,
> 		enum dma_data_direction dir, unsigned long attrs,
> 		dma_addr_t *start_addr, size_t *len)
> {
> 	struct req_iterator iter;
> 	struct bio_vec bvec;
> 	dma_addr_t next_addr;
> 	int ret;
> 
> 	if (number_of_segments(req) == 1) {
> 		// plain old dma_map_page();
> 		return 0;
> 	}
> 
> 	// XXX: block helper for rounded_len?
> 	*len = length_of_request(req);
> 	ret = dma_map_batch_start(dev, *len, dir, attrs, start_addr);
> 	if (ret)
> 		return ret;
> 
> 	next_addr = *start_addr;
> 	rq_for_each_segment(bvec, rq, iter) {
> 		ret = dma_map_batch_add(dev, &next_addr, bvec.bv_page,
> 				bvec.bv_offset, bvev.bv_len);
> 		if (ret)
> 			break;
> 	}
> 
> 	return dma_map_batch_end(dev, ret, *start_addr);
> }
> 
> dma_addr_t blk_dma_map_bvec(struct device *dev, struct bio_vec *bvec,
> 		enum dma_data_direction dir, unsigned long attrs)
> {
> 	return dma_map_page_attrs(dev, bv_page, bvec.bv_offset, bvev.bv_len,
> 			dir, attrs);
> }
> 
> int queue_rq()
> {
> 	dma_addr_t addr;
> 	int ret;
> 
> 	ret = blk_dma_map_rq(dev, rq, dir, attrs. &addr, &len);
> 	if (ret < 0)
> 		return ret;
> 
> 	if (ret == 0) {
> 		if (use_sgl()) {
> 			nvme_pci_sgl_set_data(&cmd->dptr.sgl, addr, len);
> 		} else {
> 			set_prps();
> 		}
> 		return;
> 	}
> 
> 	if (use_sgl()) {
> 		alloc_one_sgl_per_segment();
> 
> 		rq_for_each_segment(bvec, rq, iter) {
> 			addr = blk_dma_map_bvec(dev, &bdev, dir, 0);
> 			set_one_sgl();
> 		}
> 	} else {
> 		alloc_one_prp_per_page();
> 
> 		rq_for_each_segment(bvec, rq, iter) {
> 			ret = blk_dma_map_bvec(dev, &bdev, dir, 0);
> 			if (ret)
> 				break;
> 			set_prps();
> 	}
> }
> 
