Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D21E32528F
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhBYPj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 10:39:27 -0500
Received: from outbound-smtp44.blacknight.com ([46.22.136.52]:44883 "EHLO
        outbound-smtp44.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232823AbhBYPjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 10:39:14 -0500
Received: from mail.blacknight.com (pemlinmail03.blacknight.ie [81.17.254.16])
        by outbound-smtp44.blacknight.com (Postfix) with ESMTPS id 0ACC2F804B
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:38:16 +0000 (GMT)
Received: (qmail 7514 invoked from network); 25 Feb 2021 15:38:16 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 25 Feb 2021 15:38:16 -0000
Date:   Thu, 25 Feb 2021 15:38:15 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     linux-mm@kvack.org, chuck.lever@oracle.com, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 3/3] mm: make zone->free_area[order] access
 faster
Message-ID: <20210225153815.GN3697@techsingularity.net>
References: <161419296941.2718959.12575257358107256094.stgit@firesoul>
 <161419301128.2718959.4838557038019199822.stgit@firesoul>
 <20210225112849.GM3697@techsingularity.net>
 <20210225161633.53e5f910@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210225161633.53e5f910@carbon>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 04:16:33PM +0100, Jesper Dangaard Brouer wrote:
> > On Wed, Feb 24, 2021 at 07:56:51PM +0100, Jesper Dangaard Brouer wrote:
> > > Avoid multiplication (imul) operations when accessing:
> > >  zone->free_area[order].nr_free
> > > 
> > > This was really tricky to find. I was puzzled why perf reported that
> > > rmqueue_bulk was using 44% of the time in an imul operation:
> > > 
> > >        ???     del_page_from_free_list():
> > >  44,54 ??? e2:   imul   $0x58,%rax,%rax
> > > 
> > > This operation was generated (by compiler) because the struct free_area have
> > > size 88 bytes or 0x58 hex. The compiler cannot find a shift operation to use
> > > and instead choose to use a more expensive imul, to find the offset into the
> > > array free_area[].
> > > 
> > > The patch align struct free_area to a cache-line, which cause the
> > > compiler avoid the imul operation. The imul operation is very fast on
> > > modern Intel CPUs. To help fast-path that decrement 'nr_free' move the
> > > member 'nr_free' to be first element, which saves one 'add' operation.
> > > 
> > > Looking up instruction latency this exchange a 3-cycle imul with a
> > > 1-cycle shl, saving 2-cycles. It does trade some space to do this.
> > > 
> > > Used: gcc (GCC) 9.3.1 20200408 (Red Hat 9.3.1-2)
> > >   
> > 
> > I'm having some trouble parsing this and matching it to the patch itself.
> > 
> > First off, on my system (x86-64), the size of struct free area is 72,
> > not 88 bytes. For either size, cache-aligning the structure is a big
> > increase in the struct size.
> 
> Yes, the increase in size is big. For the struct free_area 40 bytes for
> my case and 56 bytes for your case.  The real problem is that this is
> multiplied by 11 (MAX_ORDER) and multiplied by number of zone structs
> (is it 5?).  Thus, 56*11*5 = 3080 bytes.
> 
> Thus, I'm not sure it is worth it!  As I'm only saving 2-cycles, for
> something that depends on the compiler generating specific code.  And
> the compiler can easily change, and "fix" this on-its-own in a later
> release, and then we are just wasting memory.
> 
> I did notice this imul happens 45 times in mm/page_alloc.o, with this
> offset 0x58, but still this is likely not on hot-path.
> 

Yeah, I'm not convinced it's worth it. The benefit of 2 cycles is small and
it's config-dependant. While some configurations will benefit, others do
not but the increased consumption is universal. I think there are better
ways to save 2 cycles in the page allocator and this seems like a costly
micro-optimisation.

> > <SNIP>
> >
> > With gcc-9, I'm also not seeing the imul instruction outputted like you
> > described in rmqueue_pcplist which inlines rmqueue_bulk. At the point
> > where it calls get_page_from_free_area, it's using shl for the page list
> > operation. This might be a compiler glitch but given that free_area is a
> > different size, I'm less certain and wonder if something else is going on.
> 
> I think it is the size variation.
> 

Yes.

> > Finally, moving nr_free to the end and cache aligning it will make the
> > started of each free_list cache-aligned because of its location in the
> > struct zone so what purpose does __pad_to_align_free_list serve?
> 
> The purpose of purpose of __pad_to_align_free_list is because struct
> list_head is 16 bytes, thus I wanted to align free_list to 16, given we
> already have wasted the space.
> 

Ok, that's fair enough but it's also somewhat of a micro-optimisation as
whether it helps or not depends on the architecture.

I don't think I'll pick this up, certainly in the context of the bulk
allocator but it's worth keeping in mind. It's an interesting corner case
at least.

-- 
Mel Gorman
SUSE Labs
