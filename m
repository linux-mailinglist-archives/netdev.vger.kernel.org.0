Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7251325239
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhBYPSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 10:18:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231248AbhBYPSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 10:18:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614266203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ozeQTDLaZ00GZ1fdAE68ODxlqYJtYZh4rnRKYlI0+3s=;
        b=H9igGBapCMqZ3kKqkBKPrfosXRsBWufO2KBAX8Fhq/mEf93d8RcvX5mZRrlyOzjnZTn3dn
        lXAFQZOwv+oxQKmp+Pk8fGTdWpjkvpL/AfTUUmb0AQm1skwamxx19RuSkFo606mwmVX/tC
        5YNDjwYVMk/ixvVEH+wsnne6/XXawxw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-kD9_EiBkOqyof0Bqi5sK5Q-1; Thu, 25 Feb 2021 10:16:40 -0500
X-MC-Unique: kD9_EiBkOqyof0Bqi5sK5Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3352E84E243;
        Thu, 25 Feb 2021 15:16:39 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 937945D9C2;
        Thu, 25 Feb 2021 15:16:34 +0000 (UTC)
Date:   Thu, 25 Feb 2021 16:16:33 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     linux-mm@kvack.org, chuck.lever@oracle.com, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH RFC net-next 3/3] mm: make zone->free_area[order] access
 faster
Message-ID: <20210225161633.53e5f910@carbon>
In-Reply-To: <20210225112849.GM3697@techsingularity.net>
References: <161419296941.2718959.12575257358107256094.stgit@firesoul>
        <161419301128.2718959.4838557038019199822.stgit@firesoul>
        <20210225112849.GM3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 11:28:49 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:

> As a side-node, I didn't pick up the other patches as there is review
> feedback and I didn't have strong opinions either way. Patch 3 is curious
> though, it probably should be split out and sent separetly but still;
> 
> On Wed, Feb 24, 2021 at 07:56:51PM +0100, Jesper Dangaard Brouer wrote:
> > Avoid multiplication (imul) operations when accessing:
> >  zone->free_area[order].nr_free
> > 
> > This was really tricky to find. I was puzzled why perf reported that
> > rmqueue_bulk was using 44% of the time in an imul operation:
> > 
> >        ???     del_page_from_free_list():
> >  44,54 ??? e2:   imul   $0x58,%rax,%rax
> > 
> > This operation was generated (by compiler) because the struct free_area have
> > size 88 bytes or 0x58 hex. The compiler cannot find a shift operation to use
> > and instead choose to use a more expensive imul, to find the offset into the
> > array free_area[].
> > 
> > The patch align struct free_area to a cache-line, which cause the
> > compiler avoid the imul operation. The imul operation is very fast on
> > modern Intel CPUs. To help fast-path that decrement 'nr_free' move the
> > member 'nr_free' to be first element, which saves one 'add' operation.
> > 
> > Looking up instruction latency this exchange a 3-cycle imul with a
> > 1-cycle shl, saving 2-cycles. It does trade some space to do this.
> > 
> > Used: gcc (GCC) 9.3.1 20200408 (Red Hat 9.3.1-2)
> >   
> 
> I'm having some trouble parsing this and matching it to the patch itself.
> 
> First off, on my system (x86-64), the size of struct free area is 72,
> not 88 bytes. For either size, cache-aligning the structure is a big
> increase in the struct size.

Yes, the increase in size is big. For the struct free_area 40 bytes for
my case and 56 bytes for your case.  The real problem is that this is
multiplied by 11 (MAX_ORDER) and multiplied by number of zone structs
(is it 5?).  Thus, 56*11*5 = 3080 bytes.

Thus, I'm not sure it is worth it!  As I'm only saving 2-cycles, for
something that depends on the compiler generating specific code.  And
the compiler can easily change, and "fix" this on-its-own in a later
release, and then we are just wasting memory.

I did notice this imul happens 45 times in mm/page_alloc.o, with this
offset 0x58, but still this is likely not on hot-path.

> struct free_area {
>         struct list_head           free_list[4];         /*     0    64 */
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         long unsigned int          nr_free;              /*    64     8 */
> 
>         /* size: 72, cachelines: 2, members: 2 */
>         /* last cacheline: 8 bytes */
> };
> 
> Are there other patches in the tree? What does pahole say?

The size of size of struct free_area varies based on some CONFIG
setting, as free_list[] array size is determined by MIGRATE_TYPES,
which on my system is 5, and not 4 as on your system.

  struct list_head	free_list[MIGRATE_TYPES];

CONFIG_CMA and CONFIG_MEMORY_ISOLATION both increase MIGRATE_TYPES with one.
Thus, the array size can vary from 4 to 6.


> With gcc-9, I'm also not seeing the imul instruction outputted like you
> described in rmqueue_pcplist which inlines rmqueue_bulk. At the point
> where it calls get_page_from_free_area, it's using shl for the page list
> operation. This might be a compiler glitch but given that free_area is a
> different size, I'm less certain and wonder if something else is going on.

I think it is the size variation.

> Finally, moving nr_free to the end and cache aligning it will make the
> started of each free_list cache-aligned because of its location in the
> struct zone so what purpose does __pad_to_align_free_list serve?

The purpose of purpose of __pad_to_align_free_list is because struct
list_head is 16 bytes, thus I wanted to align free_list to 16, given we
already have wasted the space.

Notice I added some more detailed notes in[1]:

 [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org#micro-optimisations

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

