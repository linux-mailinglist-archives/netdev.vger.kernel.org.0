Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECBB4BCD45
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 09:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiBTIlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 03:41:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiBTIlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 03:41:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CD8E50B25
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 00:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645346484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rtANzgbU227sGJWD6YEoeMtzkQAILI2Pi3z0wKXXOmY=;
        b=esT3i3Tp6gxA19e85gal9aArFIdKqV2fLdaHA8uztHQIM3HyluhYf5c0lurgnJdwCiXaQc
        wKebiXALO1uy945bHrBho3QGLIqy65v3wZMdhXk+vrDgv9CDwYqu7RwlnKrgpce786NYfU
        /CGCGDKA1/QefvOOZEsMuPykl85lKfA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-gop_Iyv3PYiVdI3VtWtraA-1; Sun, 20 Feb 2022 03:41:21 -0500
X-MC-Unique: gop_Iyv3PYiVdI3VtWtraA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B0861091DA1;
        Sun, 20 Feb 2022 08:41:14 +0000 (UTC)
Received: from localhost (ovpn-12-31.pek2.redhat.com [10.72.12.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EC885418E;
        Sun, 20 Feb 2022 08:40:49 +0000 (UTC)
Date:   Sun, 20 Feb 2022 16:40:44 +0800
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
Subject: Re: [PATCH 21/22] mmc: wbsd: Use dma_alloc_noncoherent() for dma
 buffer
Message-ID: <20220220084044.GC93179@MiWiFi-R3L-srv>
References: <20220219005221.634-1-bhe@redhat.com>
 <20220219005221.634-22-bhe@redhat.com>
 <20220219071730.GG26711@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220219071730.GG26711@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/19/22 at 08:17am, Christoph Hellwig wrote:
> On Sat, Feb 19, 2022 at 08:52:20AM +0800, Baoquan He wrote:
> >  	if (request_dma(dma, DRIVER_NAME))
> >  		goto err;
> >  
> > +	dma_set_mask_and_coherent(mmc_dev(host->mmc), DMA_BIT_MASK(24));
> 
> This also sets the streaming mask, but the driver doesn't seem to make
> use of that.  Please document it in the commit log.

Thanks for reviewing. I will change it to dma_set_mask(), and describe
this change in patch log.

> 
> Also setting smaller than 32 bit masks can fail, so this should have
> error handling.

OK, will check and add error handling.

