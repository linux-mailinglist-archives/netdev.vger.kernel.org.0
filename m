Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C497320FC73
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgF3TIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:08:39 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:57871 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgF3TIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:08:39 -0400
Received: (qmail 94587 invoked by uid 89); 30 Jun 2020 19:08:35 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 30 Jun 2020 19:08:35 -0000
Date:   Tue, 30 Jun 2020 12:08:32 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: Re: the XSK buffer pool needs be to reverted
Message-ID: <20200630190832.vvirrpkmyev2inlh@bsd-mbp.dhcp.thefacebook.com>
References: <20200626074725.GA21790@lst.de>
 <20200626205412.xfe4lywdbmh3kmri@bsd-mbp>
 <20200627070236.GA11854@lst.de>
 <e43ab7b9-22f5-75c3-c9e6-f1eb18d57148@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e43ab7b9-22f5-75c3-c9e6-f1eb18d57148@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 02:15:16PM +0100, Robin Murphy wrote:
> On 2020-06-27 08:02, Christoph Hellwig wrote:
> > On Fri, Jun 26, 2020 at 01:54:12PM -0700, Jonathan Lemon wrote:
> > > On Fri, Jun 26, 2020 at 09:47:25AM +0200, Christoph Hellwig wrote:
> > > > 
> > > > Note that this is somewhat urgent, as various of the APIs that the code
> > > > is abusing are slated to go away for Linux 5.9, so this addition comes
> > > > at a really bad time.
> > > 
> > > Could you elaborate on what is upcoming here?
> > 
> > Moving all these calls out of line, and adding a bypass flag to avoid
> > the indirect function call for IOMMUs in direct mapped mode.
> > 
> > > Also, on a semi-related note, are there limitations on how many pages
> > > can be left mapped by the iommu?  Some of the page pool work involves
> > > leaving the pages mapped instead of constantly mapping/unmapping them.
> > 
> > There are, but I think for all modern IOMMUs they are so big that they
> > don't matter.  Maintaines of the individual IOMMU drivers might know
> > more.
> 
> Right - I don't know too much about older and more esoteric stuff like POWER
> TCE, but for modern pagetable-based stuff like Intel VT-d, AMD-Vi, and Arm
> SMMU, the only "limits" are such that legitimate DMA API use should never
> get anywhere near them (you'd run out of RAM for actual buffers long
> beforehand). The most vaguely-realistic concern might be a pathological
> system topology where some old 32-bit PCI device doesn't have ACS isolation
> from your high-performance NIC such that they have to share an address
> space, where the NIC might happen to steal all the low addresses and prevent
> the soundcard or whatever from being able to map a usable buffer.
> 
> With an IOMMU, you typically really *want* to keep a full working set's
> worth of pages mapped, since dma_map/unmap are expensive while dma_sync is
> somewhere between relatively cheap and free. With no IOMMU it makes no real
> difference from the DMA API perspective since map/unmap are effectively no
> more than the equivalent sync operations anyway (I'm assuming we're not
> talking about the kind of constrained hardware that might need SWIOTLB).
> 
> > > On a heavily loaded box with iommu enabled, it seems that quite often
> > > there is contention on the iova_lock.  Are there known issues in this
> > > area?
> > 
> > I'll have to defer to the IOMMU maintainers, and for that you'll need
> > to say what code you are using.  Current mainlaine doesn't even have
> > an iova_lock anywhere.
> 
> Again I can't speak for non-mainstream stuff outside drivers/iommu, but it's
> been over 4 years now since merging the initial scalability work for the
> generic IOVA allocator there that focused on minimising lock contention, and
> it's had considerable evaluation and tweaking since. But if we can achieve
> the goal of efficiently recycling mapped buffers then we shouldn't need to
> go anywhere near IOVA allocation either way except when expanding the pool.


I'm running a set of patches which uses the page pool to try and keep
all the RX buffers mapped as the skb goes up the stack, returning the
pages to the pool when the skb is freed.

On a dual-socket 12-core Intel machine (48 processors), and 256G of
memory, when iommu is enabled, I see the following from 'perf top -U',
as the hottest function being run:

-   43.42%  worker      [k] queued_spin_lock_slowpath
   - 43.42% queued_spin_lock_slowpath
      - 41.69% _raw_spin_lock_irqsave
         + 41.39% alloc_iova 
         + 0.28% iova_magazine_free_pfns
      + 1.07% lock_sock_nested

Which likely is heavy contention on the iovad->iova_rbtree_lock.
(This is on a 5.6 based system, BTW).  More scripts and data are below.
Is there a way to reduce the contention here?



The following quick and dirty [and possibly wrong] .bpf script was used
to try and find the time spent in __alloc_and_insert_iova_range():

kprobe:alloc_iova_fast
{
        @fast = count();
}

kprobe:alloc_iova
{
        @iova_start[tid] = nsecs;
        @iova = count();
}

kretprobe:alloc_iova / @iova_start[tid] /
{
        @alloc_h = hist(nsecs - @iova_start[tid] - @mem_delta[tid]);
        delete(@iova_start[tid]);
        delete(@mem_delta[tid]);
}

kprobe:alloc_iova_mem / @iova_start[tid] /
{
        @mem_start[tid] = nsecs;
}

kretprobe:alloc_iova_mem / @mem_start[tid] /
{
        @mem_delta[tid] = nsecs - @mem_start[tid];
        delete(@mem_start[tid]);
}

kprobe:iova_insert_rbtree / @iova_start[tid] /
{
        @rb_start[tid] = nsecs;
        @rbtree = count();
}

kretprobe:iova_insert_rbtree / @rb_start[tid] /
{
        @insert_h = hist(nsecs - @rb_start[tid]);
        delete(@rb_start[tid]);
}

interval:s:2
{
        print(@fast);
        print(@iova);
        print(@rbtree);
        print(@alloc_h);
        print(@insert_h);
        printf("--------\n");
}

I see the following results.

@fast: 1989223
@iova: 725269
@rbtree: 689306

@alloc_h:
[64, 128)              2 |                                                    |
[128, 256)           118 |                                                    |
[256, 512)           983 |                                                    |
[512, 1K)           3816 |@@                                                  |
[1K, 2K)           10557 |@@@@@@                                              |
[2K, 4K)           19540 |@@@@@@@@@@@@                                        |
[4K, 8K)           31294 |@@@@@@@@@@@@@@@@@@@                                 |
[8K, 16K)          38112 |@@@@@@@@@@@@@@@@@@@@@@@                             |
[16K, 32K)         46948 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@                        |
[32K, 64K)         69728 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         |
[64K, 128K)        83797 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ |
[128K, 256K)       84317 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[256K, 512K)       82962 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ |
[512K, 1M)         72751 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        |
[1M, 2M)           49191 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      |
[2M, 4M)           26591 |@@@@@@@@@@@@@@@@                                    |
[4M, 8M)           15559 |@@@@@@@@@                                           |
[8M, 16M)          12283 |@@@@@@@                                             |
[16M, 32M)         18266 |@@@@@@@@@@@                                         |
[32M, 64M)         22539 |@@@@@@@@@@@@@                                       |
[64M, 128M)         3005 |@                                                   |
[128M, 256M)          41 |                                                    |
[256M, 512M)           0 |                                                    |
[512M, 1G)             0 |                                                    |
[1G, 2G)               0 |                                                    |
[2G, 4G)             101 |                                                    |

@insert_h:
[128, 256)          2380 |                                                    |
[256, 512)         70043 |@@@@@@@@                                            |
[512, 1K)         431263 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[1K, 2K)          182804 |@@@@@@@@@@@@@@@@@@@@@@                              |
[2K, 4K)            2742 |                                                    |
[4K, 8K)              43 |                                                    |
[8K, 16K)             25 |                                                    |
[16K, 32K)             0 |                                                    |
[32K, 64K)             0 |                                                    |
[64K, 128K)            0 |                                                    |
[128K, 256K)           6 |                                                    |


-- 
Jonathan
