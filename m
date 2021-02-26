Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83ADE326425
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 15:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhBZOgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 09:36:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57073 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhBZOgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 09:36:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614350085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lLxfh5W64Qm8bILSP59FC31GWqzCy9y4iw1b2YdlEyg=;
        b=aLrYvmtF25/fd+usFXDJoga97VNODGUua5mSHOQ0DGIYTMTnzo16aNNNNlsBc4kiB+RyBO
        BV2nKpADvcuX/mtzLv8x+Rv9+HoJOP0NY0j7PdkfyOhG0CU2K0TLuac3NBelCZLz57WPqp
        c2s75MLViofkRQIOLGI+UOq6Sg/a8rs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-aAu7JTolOyaHRWA2B0UJ-A-1; Fri, 26 Feb 2021 09:34:43 -0500
X-MC-Unique: aAu7JTolOyaHRWA2B0UJ-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7A046D4E3;
        Fri, 26 Feb 2021 14:34:41 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9DCB18AAB;
        Fri, 26 Feb 2021 14:34:36 +0000 (UTC)
Date:   Fri, 26 Feb 2021 15:34:35 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     linux-mm@kvack.org, chuck.lever@oracle.com, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH RFC net-next 3/3] mm: make zone->free_area[order] access
 faster
Message-ID: <20210226153435.6708d171@carbon>
In-Reply-To: <20210225153815.GN3697@techsingularity.net>
References: <161419296941.2718959.12575257358107256094.stgit@firesoul>
        <161419301128.2718959.4838557038019199822.stgit@firesoul>
        <20210225112849.GM3697@techsingularity.net>
        <20210225161633.53e5f910@carbon>
        <20210225153815.GN3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 15:38:15 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:

> On Thu, Feb 25, 2021 at 04:16:33PM +0100, Jesper Dangaard Brouer wrote:
> > > On Wed, Feb 24, 2021 at 07:56:51PM +0100, Jesper Dangaard Brouer wrote:  
> > > > Avoid multiplication (imul) operations when accessing:
> > > >  zone->free_area[order].nr_free
> > > > 
> > > > This was really tricky to find. I was puzzled why perf reported that
> > > > rmqueue_bulk was using 44% of the time in an imul operation:
> > > > 
> > > >        ???     del_page_from_free_list():
> > > >  44,54 ??? e2:   imul   $0x58,%rax,%rax
> > > > 
> > > > This operation was generated (by compiler) because the struct free_area have
> > > > size 88 bytes or 0x58 hex. The compiler cannot find a shift operation to use
> > > > and instead choose to use a more expensive imul, to find the offset into the
> > > > array free_area[].
> > > > 
> > > > The patch align struct free_area to a cache-line, which cause the
> > > > compiler avoid the imul operation. The imul operation is very fast on
> > > > modern Intel CPUs. To help fast-path that decrement 'nr_free' move the
> > > > member 'nr_free' to be first element, which saves one 'add' operation.
> > > > 
> > > > Looking up instruction latency this exchange a 3-cycle imul with a
> > > > 1-cycle shl, saving 2-cycles. It does trade some space to do this.
> > > > 
> > > > Used: gcc (GCC) 9.3.1 20200408 (Red Hat 9.3.1-2)
> > > >     
> > > 
> > > I'm having some trouble parsing this and matching it to the patch itself.
> > > 
> > > First off, on my system (x86-64), the size of struct free area is 72,
> > > not 88 bytes. For either size, cache-aligning the structure is a big
> > > increase in the struct size.  
> > 
> > Yes, the increase in size is big. For the struct free_area 40 bytes for
> > my case and 56 bytes for your case.  The real problem is that this is
> > multiplied by 11 (MAX_ORDER) and multiplied by number of zone structs
> > (is it 5?).  Thus, 56*11*5 = 3080 bytes.
> > 
> > Thus, I'm not sure it is worth it!  As I'm only saving 2-cycles, for
> > something that depends on the compiler generating specific code.  And
> > the compiler can easily change, and "fix" this on-its-own in a later
> > release, and then we are just wasting memory.
> > 
> > I did notice this imul happens 45 times in mm/page_alloc.o, with this
> > offset 0x58, but still this is likely not on hot-path.
> >   
> 
> Yeah, I'm not convinced it's worth it. The benefit of 2 cycles is small and
> it's config-dependant. While some configurations will benefit, others do
> not but the increased consumption is universal. I think there are better
> ways to save 2 cycles in the page allocator and this seems like a costly
> micro-optimisation.
> 
> > > <SNIP>
> > >
> > > With gcc-9, I'm also not seeing the imul instruction outputted like you
> > > described in rmqueue_pcplist which inlines rmqueue_bulk. At the point
> > > where it calls get_page_from_free_area, it's using shl for the page list
> > > operation. This might be a compiler glitch but given that free_area is a
> > > different size, I'm less certain and wonder if something else is going on.  
> > 
> > I think it is the size variation.
> >   
> 
> Yes.
> 
> > > Finally, moving nr_free to the end and cache aligning it will make the
> > > started of each free_list cache-aligned because of its location in the
> > > struct zone so what purpose does __pad_to_align_free_list serve?  
> > 
> > The purpose of purpose of __pad_to_align_free_list is because struct
> > list_head is 16 bytes, thus I wanted to align free_list to 16, given we
> > already have wasted the space.
> >   
> 
> Ok, that's fair enough but it's also somewhat of a micro-optimisation as
> whether it helps or not depends on the architecture.
> 
> I don't think I'll pick this up, certainly in the context of the bulk
> allocator but it's worth keeping in mind. It's an interesting corner case
> at least.

I fully agree. Lets drop this patch.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

