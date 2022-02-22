Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481B24BF993
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbiBVNkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbiBVNkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:40:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 669F41070A3
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645537214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o3qMPtkC/qo99+h1iqyfl3+oMWo1LnY54TQ9Ewz2XuQ=;
        b=T42OibNJybItFbqgE3HTf+s/ZtqDd2N+P4M9qy0zjVWoamCb2Rnx+I5bFcORnvV+e5TyiS
        /1oySzzTdM0oiEto6l1fWoGez4KNciAHZzxxNqnvLQpHKCSokYzLoptx52gH8cPb/PVlcY
        jw0Dv/mWaIqYTcj2MulO9QCDVpw8tMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-UBvkw2TJOGKNzMbJDJWqEg-1; Tue, 22 Feb 2022 08:40:11 -0500
X-MC-Unique: UBvkw2TJOGKNzMbJDJWqEg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBD97835DE0;
        Tue, 22 Feb 2022 13:40:06 +0000 (UTC)
Received: from localhost (ovpn-12-122.pek2.redhat.com [10.72.12.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E984684007;
        Tue, 22 Feb 2022 13:40:04 +0000 (UTC)
Date:   Tue, 22 Feb 2022 21:40:02 +0800
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
Message-ID: <YhTnsvvLEoiMs8AK@MiWiFi-R3L-srv>
References: <20220219005221.634-1-bhe@redhat.com>
 <20220219005221.634-22-bhe@redhat.com>
 <20220219071730.GG26711@lst.de>
 <20220220084044.GC93179@MiWiFi-R3L-srv>
 <20220222084530.GA6210@lst.de>
 <YhSpaGfiQV8Nmxr+@MiWiFi-R3L-srv>
 <20220222131120.GB10093@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222131120.GB10093@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/22/22 at 02:11pm, Christoph Hellwig wrote:
> On Tue, Feb 22, 2022 at 05:14:16PM +0800, Baoquan He wrote:
> > > No, if you change it, it should be dma_set_coherent_mask only as it is
> > > not using streaming mappings.  I suspect dma_set_mask_and_coherent is
> > > the right thing if the driver ever wants to use streaming mapping,
> > > it would just need to be documented in the commit message.
> > 
> > It will serve dma_alloc_noncoherent() calling later, should be streaming
> > mapping?
> 
> No, that also looks at the coherent mask.  Which is a bit misnamed these
> days, it really should be the alloc mask.

I noticed the misnamed code and have made two draft patches, please help
check if it's necessary.

