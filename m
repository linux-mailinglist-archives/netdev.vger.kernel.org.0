Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6534E8E3B
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 08:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiC1GjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 02:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238377AbiC1GjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 02:39:12 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427E348E7F;
        Sun, 27 Mar 2022 23:37:28 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6558068B05; Mon, 28 Mar 2022 08:37:23 +0200 (CEST)
Date:   Mon, 28 Mar 2022 08:37:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Christoph Hellwig <hch@lst.de>,
        Halil Pasic <pasic@linux.ibm.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Message-ID: <20220328063723.GA29405@lst.de>
References: <1812355.tdWV9SEqCh@natalenko.name> <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com> <27b5a287-7a33-9a8b-ad6d-04746735fb0c@arm.com> <CAHk-=wip7TCD_+2STTepuEZvGMg6wcz+o=kyFUvHjuKziTMixw@mail.gmail.com> <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com> <20220324190216.0efa067f.pasic@linux.ibm.com> <20220325163204.GB16426@lst.de> <87y20x7vaz.fsf@toke.dk> <e077b229-c92b-c9a6-3581-61329c4b4a4b@arm.com> <CAHk-=wgKF5GfLXyVGDQDifh0MpMccDdmBvJBG3dt2+idCa5DzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgKF5GfLXyVGDQDifh0MpMccDdmBvJBG3dt2+idCa5DzQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 11:46:09AM -0700, Linus Torvalds wrote:
> I think my list of three different sync cases (not just two! It's not
> just about whether to sync for the CPU or the device, it's also about
> what direction the data itself is taking) is correct.
> 
> But maybe I'm wrong.

At the high level you are correct.  It is all about which direction
the data is taking.  That is the direction argument that all the
map/unmap/sync call take.  The sync calls then just toggle the ownership.
You seem to hate that ownership concept, but I don't see how things
could work without that ownership concept as we're going to be in
trouble without having that.  And yes, a peek operation could work in
some cases, but it would have to be at the cache line granularity.

arch/arc/mm/dma.c has a really good comment how these transfers relate
to actual cache operations btw>

 *
 *          |   map          ==  for_device     |   unmap     ==  for_cpu
 *          |----------------------------------------------------------------
 * TO_DEV   |   writeback        writeback      |   none          none
 * FROM_DEV |   invalidate       invalidate     |   invalidate*	  invalidate*
 * BIDIR    |   writeback+inv    writeback+inv  |   invalidate    invalidate
 *
 *     [*] needed for CPU speculative prefetches
