Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FEC4BFDE7
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 16:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbiBVP7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 10:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiBVP7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 10:59:34 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524B95FF3;
        Tue, 22 Feb 2022 07:59:09 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6721B68AFE; Tue, 22 Feb 2022 16:59:04 +0100 (CET)
Date:   Tue, 22 Feb 2022 16:59:04 +0100
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
Message-ID: <20220222155904.GA13323@lst.de>
References: <20220219005221.634-1-bhe@redhat.com> <20220219005221.634-22-bhe@redhat.com> <20220219071730.GG26711@lst.de> <20220220084044.GC93179@MiWiFi-R3L-srv> <20220222084530.GA6210@lst.de> <YhSpaGfiQV8Nmxr+@MiWiFi-R3L-srv> <20220222131120.GB10093@lst.de> <YhToFzlSufrliUsi@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhToFzlSufrliUsi@MiWiFi-R3L-srv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 09:41:43PM +0800, Baoquan He wrote:
> For newly added streaming mapping APIs, the internal core function
> __dma_alloc_pages() should check dev->dma_mask, but not
> ev->coherent_dma_mask which is for coherent mapping.

No, this is wrong.  dev->coherent_dma_mask is and should be used here.

>
> 
> Meanwhile, just filter out gfp flags if they are any of
> __GFP_DMA, __GFP_DMA32 and __GFP_HIGHMEM, but not fail it. This change
> makes it  consistent with coherent mapping allocs.

This is wrong as well.  We want to eventually fail dma_alloc_coherent
for these, too.  It just needs more work.
