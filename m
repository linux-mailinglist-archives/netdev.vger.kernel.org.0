Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6EB4C0620
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbiBWA3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBWA3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:29:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5713C5574B
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 16:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645576114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WOLDx8q1ngYrAj19wfdGLpJNSm/WPzUt/IOVhlw/tjA=;
        b=KmexOTEj1OcDfzevziCPNNxLOTcf7fbvqz0907Tm97HL0dXG/amBghk5fSvLJZxv3YFp8S
        W2nsZ06BgLA47nIqwcWFaiUPJz1qfQqeOx53DpJQoifXL0Pwluf3X5tHtv2kPZqrzPP0DF
        kDg+vtmzWHUWaYPh9B/Ewn2nVsm9/7s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-3C3JWSdoPTmefmpUs0S2UQ-1; Tue, 22 Feb 2022 19:28:31 -0500
X-MC-Unique: 3C3JWSdoPTmefmpUs0S2UQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2AE81006AA7;
        Wed, 23 Feb 2022 00:28:26 +0000 (UTC)
Received: from localhost (ovpn-12-31.pek2.redhat.com [10.72.12.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AAE174EC77;
        Wed, 23 Feb 2022 00:28:15 +0000 (UTC)
Date:   Wed, 23 Feb 2022 08:28:13 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com, 42.hyeyoo@gmail.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        vbabka@suse.cz, David.Laight@aculab.com, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: Re: [PATCH 1/2] dma-mapping: check dma_mask for streaming mapping
 allocs
Message-ID: <YhV/nabDa5zdNL/4@MiWiFi-R3L-srv>
References: <20220219005221.634-1-bhe@redhat.com>
 <20220219005221.634-22-bhe@redhat.com>
 <20220219071730.GG26711@lst.de>
 <20220220084044.GC93179@MiWiFi-R3L-srv>
 <20220222084530.GA6210@lst.de>
 <YhSpaGfiQV8Nmxr+@MiWiFi-R3L-srv>
 <20220222131120.GB10093@lst.de>
 <YhToFzlSufrliUsi@MiWiFi-R3L-srv>
 <20220222155904.GA13323@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155904.GA13323@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/22/22 at 04:59pm, Christoph Hellwig wrote:
> On Tue, Feb 22, 2022 at 09:41:43PM +0800, Baoquan He wrote:
> > For newly added streaming mapping APIs, the internal core function
> > __dma_alloc_pages() should check dev->dma_mask, but not
> > ev->coherent_dma_mask which is for coherent mapping.
> 
> No, this is wrong.  dev->coherent_dma_mask is and should be used here.

Could you tell more why this is wrong? According to
Documentation/core-api/dma-api.rst and DMA code, __dma_alloc_pages() is
the core function of dma_alloc_pages()/dma_alloc_noncoherent() which are
obviously streaming mapping, why do we need to check
dev->coherent_dma_mask here? Because dev->coherent_dma_mask is the subset
of dev->dma_mask, it's safer to use dev->coherent_dma_mask in these
places? This is confusing, I talked to Hyeonggon in private mail, he has
the same feeling.

> 
> >
> > 
> > Meanwhile, just filter out gfp flags if they are any of
> > __GFP_DMA, __GFP_DMA32 and __GFP_HIGHMEM, but not fail it. This change
> > makes it  consistent with coherent mapping allocs.
> 
> This is wrong as well.  We want to eventually fail dma_alloc_coherent
> for these, too.  It just needs more work.
> 

