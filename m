Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1F14C4944
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 16:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242245AbiBYPkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 10:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241387AbiBYPj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 10:39:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5775E17CC6F
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 07:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645803566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PKwIaA6vJQ86hsYmx90S5GHPLZ3QnL0/6rDtNGfZPd8=;
        b=TbGpEsToCmR6NIPZ8S6Rl5aG1GEm6rf6XAVHcQa6Zy4yIuHqmmn6a0Myi3v8ZlxxmdB2v0
        NzrOaryyK43wQHBhL0mQ54rAIjOS53gKQ++Nv9MF+lJHNO583smCZ3F0TmdpWfTA12RVAk
        kmlHmtNTpmvzaKjd+wA5mmJeQlV6Atc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-e41bORCJP4O_0wUA4GSfZw-1; Fri, 25 Feb 2022 10:39:23 -0500
X-MC-Unique: e41bORCJP4O_0wUA4GSfZw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4391C1091DA0;
        Fri, 25 Feb 2022 15:39:19 +0000 (UTC)
Received: from localhost (ovpn-12-89.pek2.redhat.com [10.72.12.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 507087F0DB;
        Fri, 25 Feb 2022 15:39:05 +0000 (UTC)
Date:   Fri, 25 Feb 2022 23:39:02 +0800
From:   'Baoquan He' <bhe@redhat.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>,
        "42.hyeyoo@gmail.com" <42.hyeyoo@gmail.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "iamjoonsoo.kim@lge.com" <iamjoonsoo.kim@lge.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "david@redhat.com" <david@redhat.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "michael@walle.cc" <michael@walle.cc>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "wsa@kernel.org" <wsa@kernel.org>
Subject: Re: [PATCH 1/2] dma-mapping: check dma_mask for streaming mapping
 allocs
Message-ID: <20220225153902.GA148875@MiWiFi-R3L-srv>
References: <20220220084044.GC93179@MiWiFi-R3L-srv>
 <20220222084530.GA6210@lst.de>
 <YhSpaGfiQV8Nmxr+@MiWiFi-R3L-srv>
 <20220222131120.GB10093@lst.de>
 <YhToFzlSufrliUsi@MiWiFi-R3L-srv>
 <20220222155904.GA13323@lst.de>
 <YhV/nabDa5zdNL/4@MiWiFi-R3L-srv>
 <20220223142555.GA5986@lst.de>
 <YheSBTJY216m6izG@MiWiFi-R3L-srv>
 <1fead34bceda468cbe34077a28c4a4b1@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fead34bceda468cbe34077a28c4a4b1@AcuMS.aculab.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/24/22 at 02:27pm, David Laight wrote:
> From: Baoquan He
> > Sent: 24 February 2022 14:11
> ...
> > With my understanding, there are two kinds of DMA mapping, coherent
> > mapping (which is also persistent mapping), and streaming mapping. The
> > coherent mapping will be handled during driver init, and released during
> > driver de-init. While streaming mapping will be done when needed at any
> > time, and released after usage.
> 
> The lifetime has absolutely nothing to do with it.
> 
> It is all about how the DMA cycles (from the device) interact with
> (or more don't interact with) the cpu memory cache.
> 
> For coherent mapping the cpu and device can write to (different)
> words in the same cache line at the same time, and both will see
> both updates.
> On some systems this can only be achieved by making the memory
> uncached - which significantly slows down cpu access.
> 
> For non-coherent (streaming) mapping the cpu writes back and/or
> invalidates the data cache so that the dma read cycles from memory
> read the correct data and the cpu re-reads the cache line after
> the dma has completed.
> They are only really suitable for data buffers.

Thanks for valuable input, I agree the lifetime is not stuff we can rely
on to judge. But how do we explain dma_alloc_noncoherent() is not streaming
mapping? Then which kind of dma mapping is it?

I could miss something important to understand this which is obvious to
other people, I will make time to check.

