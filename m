Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F11304A9D7
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbfFRS2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:28:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:49042 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729642AbfFRS2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 14:28:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5D800AE5D;
        Tue, 18 Jun 2019 18:28:49 +0000 (UTC)
Date:   Tue, 18 Jun 2019 20:28:48 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     akpm@linux-foundation.org, vbabka@suse.cz,
        mgorman@techsingularity.net, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] mm: mempolicy: handle vma with unmovable pages mapped
 correctly in mbind
Message-ID: <20190618182848.GJ3318@dhcp22.suse.cz>
References: <1560797290-42267-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190618130253.GH3318@dhcp22.suse.cz>
 <cf33b724-fdd5-58e3-c06a-1bc563525311@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf33b724-fdd5-58e3-c06a-1bc563525311@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 18-06-19 10:06:54, Yang Shi wrote:
> 
> 
> On 6/18/19 6:02 AM, Michal Hocko wrote:
> > [Cc networking people - see a question about setsockopt below]
> > 
> > On Tue 18-06-19 02:48:10, Yang Shi wrote:
> > > When running syzkaller internally, we ran into the below bug on 4.9.x
> > > kernel:
> > > 
> > > kernel BUG at mm/huge_memory.c:2124!
> > What is the BUG_ON because I do not see any BUG_ON neither in v4.9 nor
> > the latest stable/linux-4.9.y
> 
> The line number might be not exactly same with upstream 4.9 since there
> might be some our internal patches.
> 
> It is line 2096 at mm/huge_memory.c in 4.9.182.

So it is 
	VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
that is later mentioned that has been removed. Good. Thanks for the
clarification!

> > > invalid opcode: 0000 [#1] SMP KASAN
> > [...]
> > > Code: c7 80 1c 02 00 e8 26 0a 76 01 <0f> 0b 48 c7 c7 40 46 45 84 e8 4c
> > > RIP  [<ffffffff81895d6b>] split_huge_page_to_list+0x8fb/0x1030 mm/huge_memory.c:2124
> > >   RSP <ffff88006899f980>
> > > 
> > > with the below test:
> > > 
> > > ---8<---
> > > 
> > > uint64_t r[1] = {0xffffffffffffffff};
> > > 
> > > int main(void)
> > > {
> > > 	syscall(__NR_mmap, 0x20000000, 0x1000000, 3, 0x32, -1, 0);
> > > 				intptr_t res = 0;
> > > 	res = syscall(__NR_socket, 0x11, 3, 0x300);
> > > 	if (res != -1)
> > > 		r[0] = res;
> > > *(uint32_t*)0x20000040 = 0x10000;
> > > *(uint32_t*)0x20000044 = 1;
> > > *(uint32_t*)0x20000048 = 0xc520;
> > > *(uint32_t*)0x2000004c = 1;
> > > 	syscall(__NR_setsockopt, r[0], 0x107, 0xd, 0x20000040, 0x10);
> > > 	syscall(__NR_mmap, 0x20fed000, 0x10000, 0, 0x8811, r[0], 0);
> > > *(uint64_t*)0x20000340 = 2;
> > > 	syscall(__NR_mbind, 0x20ff9000, 0x4000, 0x4002, 0x20000340,
> > > 0x45d4, 3);
> > > 	return 0;
> > > }
> > > 
> > > ---8<---
> > > 
> > > Actually the test does:
> > > 
> > > mmap(0x20000000, 16777216, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x20000000
> > > socket(AF_PACKET, SOCK_RAW, 768)        = 3
> > > setsockopt(3, SOL_PACKET, PACKET_TX_RING, {block_size=65536, block_nr=1, frame_size=50464, frame_nr=1}, 16) = 0
> > > mmap(0x20fed000, 65536, PROT_NONE, MAP_SHARED|MAP_FIXED|MAP_POPULATE|MAP_DENYWRITE, 3, 0) = 0x20fed000
> > > mbind(..., MPOL_MF_STRICT|MPOL_MF_MOVE) = 0
> > Ughh. Do I get it right that that this setsockopt allows an arbitrary
> > contiguous memory allocation size to be requested by a unpriviledged
> > user? Or am I missing something that restricts there any restriction?
> 
> It needs CAP_NET_RAW to call socket() to set socket type to RAW. The test is
> run by root user.

OK, good. That is much better. I just didn't see the capability check. I
can see one in packet_create but I do not see any in setsockopt. Maybe I
just got lost in indirection or implied security model.
 
[...]
> > > Change migrate_page_add() to check if the page is movable or not, if it
> > > is unmovable, just return -EIO.  We don't have to check non-LRU movable
> > > pages since just zsmalloc and virtio-baloon support this.  And, they
> > > should be not able to reach here.
> > You are not checking whether the page is movable, right? You only rely
> > on PageLRU check which is not really an equivalent thing. There are
> > movable pages which are not LRU and also pages might be off LRU
> > temporarily for many reasons so this could lead to false positives.
> 
> I'm supposed non-LRU movable pages could not reach here. Since most of them
> are not mmapable, i.e. virtio-balloon, zsmalloc. zram device is mmapable,
> but the page fault to that vma would end up allocating user space pages
> which are on LRU. If I miss something please let me know.

That might be true right now but it is a very subtle assumption that
might break easily in the future. The point is still that even LRU pages
might be isolated from the LRU list temporarily and you do not want this
to cause the failure easily.

-- 
Michal Hocko
SUSE Labs
