Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEB35347F7
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 03:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345568AbiEZBRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 21:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344426AbiEZBQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 21:16:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4177B4FC5F;
        Wed, 25 May 2022 18:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qYg8IKyL/r8f2Vg1ESuYjuOnE5g2jafpU06hhSyNUpw=; b=FU/B4l/86GX2mfAVzdnOZlet7o
        4YIMhkZpbCoSmgTvSZ+0srZ6BwOG40pWCCMj19qhaZ7LyhuSaw2+YdDV5a6+88avQFq2cWdQHfPWr
        byuXc0vT/MGU7fDuPvzVefIP3U6jrYIpaAmCNdJioEzp88SsKae4gtRxxjsbwJwKjR30fWyrk6jS+
        6N+w+qBIVJaEKMA2SIN/QJXQZdAFNIwoALKz9JWYzo9WKGMkqQ+rWdT359dIGkZ8Sy1ZcS2tNgQxZ
        uFqnsZqHJyvAVlUVWnv0GfWFHqg8A7Yfpa485ULCi1tDMGcQd2T2bgnhjP4//0FFa8Q9P8q43x6cS
        bXqNJBtA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nu278-000pxs-VA; Thu, 26 May 2022 01:16:35 +0000
Date:   Thu, 26 May 2022 02:16:34 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jessica Clarke <jrtc27@jrtc27.com>,
        kernel test robot <lkp@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-riscv@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-parport@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mm@kvack.org, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, alsa-devel@alsa-project.org
Subject: Re: [linux-next:master] BUILD REGRESSION
 8cb8311e95e3bb58bd84d6350365f14a718faa6d
Message-ID: <Yo7U8kglHlcvQ0Ri@casper.infradead.org>
References: <628ea118.wJYf60YnZco0hs9o%lkp@intel.com>
 <20220525145056.953631743a4c494aabf000dc@linux-foundation.org>
 <F0E25DFF-8256-48FF-8B88-C0E3730A3E5E@jrtc27.com>
 <20220525152006.e87d3fa50aca58fdc1b43b6a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525152006.e87d3fa50aca58fdc1b43b6a@linux-foundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 03:20:06PM -0700, Andrew Morton wrote:
> On Wed, 25 May 2022 23:07:35 +0100 Jessica Clarke <jrtc27@jrtc27.com> wrote:
> 
> > This is i386, so an unsigned long is 32-bit, but i_blocks is a blkcnt_t
> > i.e. a u64, which makes the shift without a cast of the LHS fishy.
> 
> Ah, of course, thanks.  I remember 32 bits ;)
> 
> --- a/mm/shmem.c~mm-shmemc-suppress-shift-warning
> +++ a/mm/shmem.c
> @@ -1945,7 +1945,7 @@ alloc_nohuge:
>  
>  	spin_lock_irq(&info->lock);
>  	info->alloced += folio_nr_pages(folio);
> -	inode->i_blocks += BLOCKS_PER_PAGE << folio_order(folio);
> +	inode->i_blocks += (blkcnt_t)BLOCKS_PER_PAGE << folio_order(folio);

Bizarre this started showing up now.  The recent patch was:

-       info->alloced += compound_nr(page);
-       inode->i_blocks += BLOCKS_PER_PAGE << compound_order(page);
+       info->alloced += folio_nr_pages(folio);
+       inode->i_blocks += BLOCKS_PER_PAGE << folio_order(folio);

so it could tell that compound_order() was small, but folio_order()
might be large?

Silencing the warning is a good thing, but folio_order() can (at the
moment) be at most 9 on i386, so it isn't actually going to be
larger than 4096.
