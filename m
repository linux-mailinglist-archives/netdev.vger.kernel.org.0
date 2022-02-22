Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051A64BF3EC
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiBVIqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiBVIp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:45:59 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E95159298;
        Tue, 22 Feb 2022 00:45:34 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id BE08D68B05; Tue, 22 Feb 2022 09:45:30 +0100 (CET)
Date:   Tue, 22 Feb 2022 09:45:30 +0100
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
Subject: Re: [PATCH 21/22] mmc: wbsd: Use dma_alloc_noncoherent() for dma
 buffer
Message-ID: <20220222084530.GA6210@lst.de>
References: <20220219005221.634-1-bhe@redhat.com> <20220219005221.634-22-bhe@redhat.com> <20220219071730.GG26711@lst.de> <20220220084044.GC93179@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220220084044.GC93179@MiWiFi-R3L-srv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 20, 2022 at 04:40:44PM +0800, Baoquan He wrote:
> On 02/19/22 at 08:17am, Christoph Hellwig wrote:
> > On Sat, Feb 19, 2022 at 08:52:20AM +0800, Baoquan He wrote:
> > >  	if (request_dma(dma, DRIVER_NAME))
> > >  		goto err;
> > >  
> > > +	dma_set_mask_and_coherent(mmc_dev(host->mmc), DMA_BIT_MASK(24));
> > 
> > This also sets the streaming mask, but the driver doesn't seem to make
> > use of that.  Please document it in the commit log.
> 
> Thanks for reviewing. I will change it to dma_set_mask(), and describe
> this change in patch log.

No, if you change it, it should be dma_set_coherent_mask only as it is
not using streaming mappings.  I suspect dma_set_mask_and_coherent is
the right thing if the driver ever wants to use streaming mapping,
it would just need to be documented in the commit message.
