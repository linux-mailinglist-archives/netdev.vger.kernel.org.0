Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD94320D52B
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgF2TPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:15:16 -0400
Received: from foss.arm.com ([217.140.110.172]:39030 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729378AbgF2TO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:14:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE9CA14F6;
        Mon, 29 Jun 2020 06:15:19 -0700 (PDT)
Received: from [10.57.21.32] (unknown [10.57.21.32])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1043F3F73C;
        Mon, 29 Jun 2020 06:15:18 -0700 (PDT)
Subject: Re: the XSK buffer pool needs be to reverted
To:     Christoph Hellwig <hch@lst.de>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
References: <20200626074725.GA21790@lst.de>
 <20200626205412.xfe4lywdbmh3kmri@bsd-mbp> <20200627070236.GA11854@lst.de>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <e43ab7b9-22f5-75c3-c9e6-f1eb18d57148@arm.com>
Date:   Mon, 29 Jun 2020 14:15:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200627070236.GA11854@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-27 08:02, Christoph Hellwig wrote:
> On Fri, Jun 26, 2020 at 01:54:12PM -0700, Jonathan Lemon wrote:
>> On Fri, Jun 26, 2020 at 09:47:25AM +0200, Christoph Hellwig wrote:
>>>
>>> Note that this is somewhat urgent, as various of the APIs that the code
>>> is abusing are slated to go away for Linux 5.9, so this addition comes
>>> at a really bad time.
>>
>> Could you elaborate on what is upcoming here?
> 
> Moving all these calls out of line, and adding a bypass flag to avoid
> the indirect function call for IOMMUs in direct mapped mode.
> 
>> Also, on a semi-related note, are there limitations on how many pages
>> can be left mapped by the iommu?  Some of the page pool work involves
>> leaving the pages mapped instead of constantly mapping/unmapping them.
> 
> There are, but I think for all modern IOMMUs they are so big that they
> don't matter.  Maintaines of the individual IOMMU drivers might know
> more.

Right - I don't know too much about older and more esoteric stuff like 
POWER TCE, but for modern pagetable-based stuff like Intel VT-d, AMD-Vi, 
and Arm SMMU, the only "limits" are such that legitimate DMA API use 
should never get anywhere near them (you'd run out of RAM for actual 
buffers long beforehand). The most vaguely-realistic concern might be a 
pathological system topology where some old 32-bit PCI device doesn't 
have ACS isolation from your high-performance NIC such that they have to 
share an address space, where the NIC might happen to steal all the low 
addresses and prevent the soundcard or whatever from being able to map a 
usable buffer.

With an IOMMU, you typically really *want* to keep a full working set's 
worth of pages mapped, since dma_map/unmap are expensive while dma_sync 
is somewhere between relatively cheap and free. With no IOMMU it makes 
no real difference from the DMA API perspective since map/unmap are 
effectively no more than the equivalent sync operations anyway (I'm 
assuming we're not talking about the kind of constrained hardware that 
might need SWIOTLB).

>> On a heavily loaded box with iommu enabled, it seems that quite often
>> there is contention on the iova_lock.  Are there known issues in this
>> area?
> 
> I'll have to defer to the IOMMU maintainers, and for that you'll need
> to say what code you are using.  Current mainlaine doesn't even have
> an iova_lock anywhere.

Again I can't speak for non-mainstream stuff outside drivers/iommu, but 
it's been over 4 years now since merging the initial scalability work 
for the generic IOVA allocator there that focused on minimising lock 
contention, and it's had considerable evaluation and tweaking since. But 
if we can achieve the goal of efficiently recycling mapped buffers then 
we shouldn't need to go anywhere near IOVA allocation either way except 
when expanding the pool.

Robin.
