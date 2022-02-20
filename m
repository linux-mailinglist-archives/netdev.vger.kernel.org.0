Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFE84BCBA0
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 03:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243339AbiBTCGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 21:06:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiBTCGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 21:06:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62B7832998
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 18:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645322781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u35piiWPohqcpYYdwIsCVmh/d8XqMR6334fza7B3jzM=;
        b=QjjNLtHi3XTzQjZYRTK/WZFCUScVsnt5kemo9aKf15k2SAkhevAm4q0lSWCe4+UFFU42j1
        BErNx+HcHNXi4LJS+sN3gqUl4KEJB7jlHTelwQX72/jO29wJs1FpKL+M3BtW1OljWMESt7
        0rniHZpGWMT0mo9R4JGdm3cEZPGGJnU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-ZCsigVPTOsm5Z-VVgbZzmw-1; Sat, 19 Feb 2022 21:06:19 -0500
X-MC-Unique: ZCsigVPTOsm5Z-VVgbZzmw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A145E1898290;
        Sun, 20 Feb 2022 02:06:16 +0000 (UTC)
Received: from localhost (ovpn-12-31.pek2.redhat.com [10.72.12.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DDD21971B;
        Sun, 20 Feb 2022 02:06:05 +0000 (UTC)
Date:   Sun, 20 Feb 2022 10:06:01 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hch@lst.de, cl@linux.com,
        42.hyeyoo@gmail.com, penberg@kernel.org, rientjes@google.com,
        iamjoonsoo.kim@lge.com, vbabka@suse.cz, David.Laight@aculab.com,
        david@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: Re: [PATCH 17/22] net: marvell: prestera: Don't use GFP_DMA when
 calling dma_pool_alloc()
Message-ID: <20220220020601.GB93179@MiWiFi-R3L-srv>
References: <20220219005221.634-1-bhe@redhat.com>
 <20220219005221.634-18-bhe@redhat.com>
 <20220218205408.45d1085e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218205408.45d1085e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/18/22 at 08:54pm, Jakub Kicinski wrote:
> On Sat, 19 Feb 2022 08:52:16 +0800 Baoquan He wrote:
> > dma_pool_alloc() uses dma_alloc_coherent() to pre-allocate DMA buffer,
> > so it's redundent to specify GFP_DMA when calling.
> > 
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> 
> This and the other two netdev patches in the series are perfectly
> cleanups reasonable even outside of the larger context.
> 
> Please repost those separately and make sure you CC the maintainers
> of the drivers.

Thanks for reviewing. I am not familiar with netdev and network patch
posting rule. There are 4 patches altogether related to netdev as below,
Will repost them to the relevant netdev mailinglist and maintainers.

[PATCH 19/22] ethernet: rocker: Use dma_alloc_noncoherent() for dma buffer
[PATCH 18/22] net: ethernet: mtk-star-emac: Don't use GFP_DMA when calling dmam_alloc_coherent()
[PATCH 17/22] net: marvell: prestera: Don't use GFP_DMA when calling dma_pool_alloc()
[PATCH 02/22] net: moxa: Don't use GFP_DMA when calling dma_alloc_coherent()

