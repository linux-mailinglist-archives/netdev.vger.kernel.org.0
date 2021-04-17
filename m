Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA917362F3D
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 12:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbhDQKcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 06:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230510AbhDQKcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 06:32:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D813A61209;
        Sat, 17 Apr 2021 10:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618655513;
        bh=bKkHYDWEnUxH4+NZsQzc9XdOBx/eAasVlApeofpvQ3M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=F8vK55v7UAeYClMXwewtQLHQ0TzAI75Gda/Ijyqb1bmDwdQP0a9qNJCXMN7YbFjAS
         dG8/5lw8Oh/K1rCPVqp5z1w7J4kKWAX0DkrnhWpkRSTuwOC7TPzuxif0+RqWn8cqRX
         pZUZxJgGN2u31XYsKolc/RRqCot3uzixXu+xCEwO9gitdkvxQC6D/X0UdL/QXE36np
         iD8Zr5qX8eqgiDJ8foVPlr+kPJNA1ItqyDhMGuNuBHDo9yh0U368iVOPkCABjyVsAC
         C3JEgc3qOIsozYto2rSELYyYwBSIA8CHj7yzKeDCuHRrrcWelfXpNbZ8dp+qY4qF47
         TbQLKsvP+wzrw==
Received: by mail-wr1-f51.google.com with SMTP id c15so20076620wro.13;
        Sat, 17 Apr 2021 03:31:53 -0700 (PDT)
X-Gm-Message-State: AOAM531A/Ralkr5Ef+2lVwSBGEoVJlcbZhxe/rCXiWY/fIFgKSBFosAk
        et490+SZLCHJFTU6LoY0sitPb1R++jCrTuUTobE=
X-Google-Smtp-Source: ABdhPJycE8LG0z9YxCgms5+k71EBmr9DkHzd41Oc6z9ytag0KDWOSXF5lk8cL6Kn2M30kai4QRK7X3xc1d9fGPyxl30=
X-Received: by 2002:adf:db4f:: with SMTP id f15mr3734418wrj.99.1618655512568;
 Sat, 17 Apr 2021 03:31:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210410205246.507048-2-willy@infradead.org> <20210411114307.5087f958@carbon>
 <20210411103318.GC2531743@casper.infradead.org> <20210412011532.GG2531743@casper.infradead.org>
 <20210414101044.19da09df@carbon> <20210414115052.GS2531743@casper.infradead.org>
 <20210414211322.3799afd4@carbon> <20210414213556.GY2531743@casper.infradead.org>
 <a50c3156fe8943ef964db4345344862f@AcuMS.aculab.com> <20210415200832.32796445@carbon>
 <20210416152755.GL2531743@casper.infradead.org>
In-Reply-To: <20210416152755.GL2531743@casper.infradead.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sat, 17 Apr 2021 12:31:37 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2dekzohOrHpLq6yyuaoyC4UOxxucu6kX2oddeq5Jdqfg@mail.gmail.com>
Message-ID: <CAK8P3a2dekzohOrHpLq6yyuaoyC4UOxxucu6kX2oddeq5Jdqfg@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        David Laight <David.Laight@aculab.com>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 5:27 PM Matthew Wilcox <willy@infradead.org> wrote:
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index b5b195305346..db7c7020746a 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -198,7 +198,17 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>
>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  {
> -       return page->dma_addr;
> +       dma_addr_t ret = page->dma_addr[0];
> +       if (sizeof(dma_addr_t) > sizeof(unsigned long))
> +               ret |= (dma_addr_t)page->dma_addr[1] << 32;
> +       return ret;
> +}

Have you considered using a PFN type address here? I suspect you
can prove that shifting the DMA address by PAGE_BITS would
make it fit into an 'unsigned long' on all 32-bit architectures with
64-bit dma_addr_t. This requires that page->dma_addr to be
page aligned, as well as fit into 44 bits. I recently went through the
maximum address space per architecture to define a
MAX_POSSIBLE_PHYSMEM_BITS, and none of them have more than
40 here, presumably the same is true for dma address space.

        Arnd
