Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D279935AB4F
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 08:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhDJGWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 02:22:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229992AbhDJGWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 02:22:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618035739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nv0p4RXdpoXEf7jqWszTL6fVOOyMMq+6cdW6F9BHRE8=;
        b=cDx2Kr02pDCs3CexD206x/O+ZbG6UBaC+1ppHR+0pnBNWVbzadgc24K/zMtt7o+pjBJ7SD
        bhxDPMuft3DcGg7WsAYmal07EFa618wGU6fFKya8BrZNE5WVbApxPh2EJqJTcCPYurfeQO
        d6zYBxc87mbw9eZzDdiadEH7Q6XsRtQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-H9vV9Gg_ME-THv76LsVBSA-1; Sat, 10 Apr 2021 02:22:12 -0400
X-MC-Unique: H9vV9Gg_ME-THv76LsVBSA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3FA4593C0;
        Sat, 10 Apr 2021 06:22:08 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD3276F968;
        Sat, 10 Apr 2021 06:21:59 +0000 (UTC)
Date:   Sat, 10 Apr 2021 08:21:58 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     kernel test robot <lkp@intel.com>, linux-mm@kvack.org,
        kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>, brouer@redhat.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Bogus struct page layout on 32-bit
Message-ID: <20210410082158.79ad09a6@carbon>
In-Reply-To: <20210410024313.GX2531743@casper.infradead.org>
References: <20210409185105.188284-3-willy@infradead.org>
        <202104100656.N7EVvkNZ-lkp@intel.com>
        <20210410024313.GX2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Apr 2021 03:43:13 +0100
Matthew Wilcox <willy@infradead.org> wrote:

> On Sat, Apr 10, 2021 at 06:45:35AM +0800, kernel test robot wrote:
> > >> include/linux/mm_types.h:274:1: error: static_assert failed due to requirement '__builtin_offsetof(struct page, lru) == __builtin_offsetof(struct folio, lru)' "offsetof(struct page, lru) == offsetof(struct folio, lru)"  
> >    FOLIO_MATCH(lru, lru);
> >    include/linux/mm_types.h:272:2: note: expanded from macro 'FOLIO_MATCH'
> >            static_assert(offsetof(struct page, pg) == offsetof(struct folio, fl))  
> 
> Well, this is interesting.  pahole reports:
> 
> struct page {
>         long unsigned int          flags;                /*     0     4 */
>         /* XXX 4 bytes hole, try to pack */
>         union {
>                 struct {
>                         struct list_head lru;            /*     8     8 */
> ...
> struct folio {
>         union {
>                 struct {
>                         long unsigned int flags;         /*     0     4 */
>                         struct list_head lru;            /*     4     8 */
> 
> so this assert has absolutely done its job.
> 
> But why has this assert triggered?  Why is struct page layout not what
> we thought it was?  Turns out it's the dma_addr added in 2019 by commit
> c25fff7171be ("mm: add dma_addr_t to struct page").  On this particular
> config, it's 64-bit, and ppc32 requires alignment to 64-bit.  So
> the whole union gets moved out by 4 bytes.

Argh, good that you are catching this!

> Unfortunately, we can't just fix this by putting an 'unsigned long pad'
> in front of it.  It still aligns the entire union to 8 bytes, and then
> it skips another 4 bytes after the pad.
> 
> We can fix it like this ...
> 
> +++ b/include/linux/mm_types.h
> @@ -96,11 +96,12 @@ struct page {
>                         unsigned long private;
>                 };
>                 struct {        /* page_pool used by netstack */
> +                       unsigned long _page_pool_pad;

I'm fine with this pad.  Matteo is currently proposing[1] to add a 32-bit
value after @dma_addr, and he could use this area instead.

[1] https://lore.kernel.org/netdev/20210409223801.104657-3-mcroce@linux.microsoft.com/

When adding/changing this, we need to make sure that it doesn't overlap
member @index, because network stack use/check page_is_pfmemalloc().
As far as my calculations this is safe to add.  I always try to keep an
eye out for this, but I wonder if we could have a build check like yours.


>                         /**
>                          * @dma_addr: might require a 64-bit value even on
>                          * 32-bit architectures.
>                          */
> -                       dma_addr_t dma_addr;
> +                       dma_addr_t dma_addr __packed;
>                 };
>                 struct {        /* slab, slob and slub */
>                         union {
> 
> but I don't know if GCC is smart enough to realise that dma_addr is now
> on an 8 byte boundary and it can use a normal instruction to access it,
> or whether it'll do something daft like use byte loads to access it.
> 
> We could also do:
> 
> +                       dma_addr_t dma_addr __packed __aligned(sizeof(void *));
> 
> and I see pahole, at least sees this correctly:
> 
>                 struct {
>                         long unsigned int _page_pool_pad; /*     4     4 */
>                         dma_addr_t dma_addr __attribute__((__aligned__(4))); /*     8     8 */
>                 } __attribute__((__packed__)) __attribute__((__aligned__(4)));  
> 
> This presumably affects any 32-bit architecture with a 64-bit phys_addr_t
> / dma_addr_t.  Advice, please?

I'm not sure that the 32-bit behavior is with 64-bit (dma) addrs.

I don't have any 32-bit boards with 64-bit DMA.  Cc. Ivan, wasn't your
board (572x ?) 32-bit with driver 'cpsw' this case (where Ivan added
XDP+page_pool) ?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

