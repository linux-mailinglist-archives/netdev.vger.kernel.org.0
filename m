Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA7A365360
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbhDTHkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 03:40:49 -0400
Received: from mail-vk1-f178.google.com ([209.85.221.178]:36690 "EHLO
        mail-vk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhDTHkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 03:40:45 -0400
Received: by mail-vk1-f178.google.com with SMTP id u200so5549944vku.3;
        Tue, 20 Apr 2021 00:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H6eQzhTjkJ0rVc7HEe9OWdxxcp9k4JKL+wOyVTTn6UM=;
        b=t4S8B/JxmNduSY2iZ5/BlHi8j5UNEm+OSIpwJoBG2WrrJK87wPGT5CtTEWWWISVvBf
         Iy5GTXrO7cetqOmKe2FpVQj+KbHzWelmOMrZMb6ofzjXMkJFavhyVKEVUQoPtiDqT4W4
         t5AseKxl+grP3aGWBHtvm1YrsyZIVuhSgWIA90o3sRCGxf4Ku6amNb2M4ZJBtBAWkegC
         pPXPDAwryggoH11HgzLe4CGIlceGLi/fMkG3OovqTW9r3jIedWa02fe1YGFKIuFh98Hw
         48fw/ClTeaRgZ+Lg1GqkMi5Ef0dBarY7LsPzFZW6gPTgin9m3GjtpfOC+J577WlUBZ+5
         HS5Q==
X-Gm-Message-State: AOAM531E299BqPbfbluuNrt7IYkwPMgFPZ8wwzRVwrTT2DOPazXqQ7XV
        f5Bs469v5ip3I1RuUZOnMtokqVnek1UK68kh7lk=
X-Google-Smtp-Source: ABdhPJyQrVlZDIuzz0IXIFr61zWg3jELX2WXl+k/TdsCheRdiMxsjqJCL3H7m7n2s4eAxB2N41JJBdYT1MQaqIXF0Cc=
X-Received: by 2002:a1f:2504:: with SMTP id l4mr15813452vkl.5.1618904406471;
 Tue, 20 Apr 2021 00:40:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210416230724.2519198-1-willy@infradead.org> <20210416230724.2519198-2-willy@infradead.org>
 <20210417024522.GP2531743@casper.infradead.org>
In-Reply-To: <20210417024522.GP2531743@casper.infradead.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 20 Apr 2021 09:39:54 +0200
Message-ID: <CAMuHMdXm1Zg=Wm-=tn5jUJwqVGUvCi5yDaW0PXWC2DEDYGcy5A@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        mcroce@linux.microsoft.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        arcml <linux-snps-arc@lists.infradead.org>,
        Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willy,

On Sat, Apr 17, 2021 at 4:49 AM Matthew Wilcox <willy@infradead.org> wrote:
> Replacement patch to fix compiler warning.
>
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Date: Fri, 16 Apr 2021 16:34:55 -0400
> Subject: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
> To: brouer@redhat.com
> Cc: linux-kernel@vger.kernel.org,
>     linux-mm@kvack.org,
>     netdev@vger.kernel.org,
>     linuxppc-dev@lists.ozlabs.org,
>     linux-arm-kernel@lists.infradead.org,
>     linux-mips@vger.kernel.org,
>     ilias.apalodimas@linaro.org,
>     mcroce@linux.microsoft.com,
>     grygorii.strashko@ti.com,
>     arnd@kernel.org,
>     hch@lst.de,
>     linux-snps-arc@lists.infradead.org,
>     mhocko@kernel.org,
>     mgorman@suse.de
>
> 32-bit architectures which expect 8-byte alignment for 8-byte integers
> and need 64-bit DMA addresses (arc, arm, mips, ppc) had their struct
> page inadvertently expanded in 2019.  When the dma_addr_t was added,
> it forced the alignment of the union to 8 bytes, which inserted a 4 byte
> gap between 'flags' and the union.
>
> Fix this by storing the dma_addr_t in one or two adjacent unsigned longs.
> This restores the alignment to that of an unsigned long, and also fixes a
> potential problem where (on a big endian platform), the bit used to denote
> PageTail could inadvertently get set, and a racing get_user_pages_fast()
> could dereference a bogus compound_head().
>
> Fixes: c25fff7171be ("mm: add dma_addr_t to struct page")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Thanks for your patch!

> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -97,10 +97,10 @@ struct page {
>                 };
>                 struct {        /* page_pool used by netstack */
>                         /**
> -                        * @dma_addr: might require a 64-bit value even on
> +                        * @dma_addr: might require a 64-bit value on
>                          * 32-bit architectures.
>                          */
> -                       dma_addr_t dma_addr;
> +                       unsigned long dma_addr[2];

So we get two 64-bit words on 64-bit platforms, while only one is
needed?

Would

    unsigned long _dma_addr[sizeof(dma_addr_t) / sizeof(unsigned long)];

work?

Or will the compiler become too overzealous, and warn about the use
of ...[1] below, even when unreachable?
I wouldn't mind an #ifdef instead of an if () in the code below, though.

>                 };
>                 struct {        /* slab, slob and slub */
>                         union {
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index b5b195305346..ad6154dc206c 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -198,7 +198,17 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>
>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  {
> -       return page->dma_addr;
> +       dma_addr_t ret = page->dma_addr[0];
> +       if (sizeof(dma_addr_t) > sizeof(unsigned long))
> +               ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;

We don't seem to have a handy macro for a 32-bit left shift yet...

But you can also avoid the warning using

    ret |= (u64)page->dma_addr[1] << 32;

> +       return ret;
> +}
> +
> +static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
> +{
> +       page->dma_addr[0] = addr;
> +       if (sizeof(dma_addr_t) > sizeof(unsigned long))
> +               page->dma_addr[1] = addr >> 16 >> 16;

... but we do have upper_32_bits() for a 32-bit right shift.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
