Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C00720C928
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 19:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgF1RQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 13:16:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:15923 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgF1RQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jun 2020 13:16:40 -0400
IronPort-SDR: Tc5u38z0Rg0j4+DX+3gFuSTzd5U6V9JP54N5FQEAG/70xmUqDw67VZyEIF49FSxZgLXLrdKOpy
 Epyqpz9iB+2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="134173291"
X-IronPort-AV: E=Sophos;i="5.75,291,1589266800"; 
   d="scan'208";a="134173291"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2020 10:16:38 -0700
IronPort-SDR: s/CaFswzkV9uLr+zFxqweD+BHz4N478o0Avg93xSnrVl+Mvwb54GAnFPN8KiQhUTMFnXdTGpBB
 1JKO8wlMnqdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,291,1589266800"; 
   d="scan'208";a="453934416"
Received: from unknown (HELO btopel-mobl.ger.intel.com) ([10.252.54.42])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2020 10:16:34 -0700
Subject: Re: [PATCH net] xsk: remove cheap_dma optimization
To:     Christoph Hellwig <hch@lst.de>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        konrad.wilk@oracle.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        maximmi@mellanox.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
References: <20200626134358.90122-1-bjorn.topel@gmail.com>
 <c60dfb5a-2bf3-20bd-74b3-6b5e215f73f8@iogearbox.net>
 <20200627070406.GB11854@lst.de>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <88d27e1b-dbda-301c-64ba-2391092e3236@intel.com>
Date:   Sun, 28 Jun 2020 19:16:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200627070406.GB11854@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-06-27 09:04, Christoph Hellwig wrote:
> On Sat, Jun 27, 2020 at 01:00:19AM +0200, Daniel Borkmann wrote:
>> Given there is roughly a ~5 weeks window at max where this removal could
>> still be applied in the worst case, could we come up with a fix / proposal
>> first that moves this into the DMA mapping core? If there is something that
>> can be agreed upon by all parties, then we could avoid re-adding the 9%
>> slowdown. :/
> 
> I'd rather turn it upside down - this abuse of the internals blocks work
> that has basically just missed the previous window and I'm not going
> to wait weeks to sort out the API misuse.  But we can add optimizations
> back later if we find a sane way.
>

I'm not super excited about the performance loss, but I do get
Christoph's frustration about gutting the DMA API making it harder for
DMA people to get work done. Lets try to solve this properly using
proper DMA APIs.


> That being said I really can't see how this would make so much of a
> difference.  What architecture and what dma_ops are you using for
> those measurements?  What is the workload?
> 

The 9% is for an AF_XDP (Fast raw Ethernet socket. Think AF_PACKET, but 
faster.) benchmark: receive the packet from the NIC, and drop it. The 
DMA syncs stand out in the perf top:

   28.63%  [kernel]                   [k] i40e_clean_rx_irq_zc
   17.12%  [kernel]                   [k] xp_alloc
    8.80%  [kernel]                   [k] __xsk_rcv_zc
    7.69%  [kernel]                   [k] xdp_do_redirect
    5.35%  bpf_prog_992d9ddc835e5629  [k] bpf_prog_992d9ddc835e5629
    4.77%  [kernel]                   [k] xsk_rcv.part.0
    4.07%  [kernel]                   [k] __xsk_map_redirect
    3.80%  [kernel]                   [k] dma_direct_sync_single_for_cpu
    3.03%  [kernel]                   [k] dma_direct_sync_single_for_device
    2.76%  [kernel]                   [k] i40e_alloc_rx_buffers_zc
    1.83%  [kernel]                   [k] xsk_flush
...

For this benchmark the dma_ops are NULL (dma_is_direct() == true), and
the main issue is that SWIOTLB is now unconditionally enabled [1] for
x86, and for each sync we have to check that if is_swiotlb_buffer()
which involves a some costly indirection.

That was pretty much what my hack avoided. Instead we did all the checks
upfront, since AF_XDP has long-term DMA mappings, and just set a flag
for that.

Avoiding the whole "is this address swiotlb" in
dma_direct_sync_single_for_{cpu, device]() per-packet
would help a lot.

Somewhat related to the DMA API; It would have performance benefits for
AF_XDP if the DMA range of the mapped memory was linear, i.e. by IOMMU
utilization. I've started hacking a thing a little bit, but it would be
nice if such API was part of the mapping core.

Input: array of pages Output: array of dma addrs (and obviously dev,
flags and such)

For non-IOMMU len(array of pages) == len(array of dma addrs)
For best-case IOMMU len(array of dma addrs) == 1 (large linear space)

But that's for later. :-)


Björn


[1] commit: 09230cbc1bab ("swiotlb: move the SWIOTLB config symbol to 
lib/Kconfig")

