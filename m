Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B7A4BF3F8
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiBVIrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiBVIrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:47:20 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9504CD53;
        Tue, 22 Feb 2022 00:46:55 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B8BE368AA6; Tue, 22 Feb 2022 09:46:52 +0100 (CET)
Date:   Tue, 22 Feb 2022 09:46:52 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Baoquan He <bhe@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        David.Laight@aculab.com, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: Re: [PATCH 22/22] mtd: rawnand: Use dma_alloc_noncoherent() for
 dma buffer
Message-ID: <20220222084652.GB6210@lst.de>
References: <20220219005221.634-1-bhe@redhat.com> <20220219005221.634-23-bhe@redhat.com> <20220219071900.GH26711@lst.de> <YhDSAJG+LksZSnLP@ip-172-31-19-208.ap-northeast-1.compute.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhDSAJG+LksZSnLP@ip-172-31-19-208.ap-northeast-1.compute.internal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 19, 2022 at 11:18:24AM +0000, Hyeonggon Yoo wrote:
> > I think it would be better to still allocate the buffer at allocation
> > time and then just transfer ownership using dma_sync_single* in the I/O
> > path to avoid the GFP_ATOMIC allocation.
> 
> This driver allocates the buffer at initialization step and maps the buffer
> for DMA_TO_DEVICE and DMA_FROM_DEVICE when processing IO.
> 
> But after making this driver to use dma_alloc_noncoherent(), remapping
> dma_alloc_noncoherent()-ed buffer is strange So I just made it to allocate
> the buffer in IO path.

You should not remap it.  Just use dma_sync_single* to transfer ownership.

> Hmm.. for this specific case, What about allocating two buffers
> for DMA_TO_DEVICE and DMA_FROM_DEVICE at initialization time?

That will work, but I don't see the benefit as you'd still need to call
dma_sync_single* before and after each data transfer.
