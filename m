Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62A24C1563
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241544AbiBWO02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236643AbiBWO02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:26:28 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CDCB2382;
        Wed, 23 Feb 2022 06:26:00 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8BB3D68AA6; Wed, 23 Feb 2022 15:25:55 +0100 (CET)
Date:   Wed, 23 Feb 2022 15:25:55 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Baoquan He <bhe@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, cl@linux.com,
        42.hyeyoo@gmail.com, penberg@kernel.org, rientjes@google.com,
        iamjoonsoo.kim@lge.com, vbabka@suse.cz, David.Laight@aculab.com,
        david@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: Re: [PATCH 1/2] dma-mapping: check dma_mask for streaming mapping
 allocs
Message-ID: <20220223142555.GA5986@lst.de>
References: <20220219005221.634-1-bhe@redhat.com> <20220219005221.634-22-bhe@redhat.com> <20220219071730.GG26711@lst.de> <20220220084044.GC93179@MiWiFi-R3L-srv> <20220222084530.GA6210@lst.de> <YhSpaGfiQV8Nmxr+@MiWiFi-R3L-srv> <20220222131120.GB10093@lst.de> <YhToFzlSufrliUsi@MiWiFi-R3L-srv> <20220222155904.GA13323@lst.de> <YhV/nabDa5zdNL/4@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhV/nabDa5zdNL/4@MiWiFi-R3L-srv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 08:28:13AM +0800, Baoquan He wrote:
> Could you tell more why this is wrong? According to
> Documentation/core-api/dma-api.rst and DMA code, __dma_alloc_pages() is
> the core function of dma_alloc_pages()/dma_alloc_noncoherent() which are
> obviously streaming mapping,

Why are they "obviously" streaming mappings?

> why do we need to check
> dev->coherent_dma_mask here? Because dev->coherent_dma_mask is the subset
> of dev->dma_mask, it's safer to use dev->coherent_dma_mask in these
> places? This is confusing, I talked to Hyeonggon in private mail, he has
> the same feeling.

Think of th coherent_dma_mask as dma_alloc_mask.  It is the mask for the
DMA memory allocator.  dma_mask is the mask for the dma_map_* routines.
