Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536284BC3D3
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 01:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240568AbiBSAxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:53:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240581AbiBSAxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:53:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 964BF279905
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645231998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=1aAgMpwStNlcYKTvxIIYOe7gqT8/S9pjkqPo7BOpV0E=;
        b=ENEq86ExkwvCZNwMVfWHPxg1i1ouPvkpFRv8BENuGeBtU7m94VBWNyb8pqGPH00RbUW04C
        VMjKcjWlItfH7XNVoyAQUTLt163kuhBiNxDpND5PMm7ZAD6unOQMwM0BmsJ/uktvJOlSfq
        0rrgj/PVqyFQ/Cxibjr0ys8FMz7a/PY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-F1pOwS_JM2ejnP-s-8PL5g-1; Fri, 18 Feb 2022 19:53:15 -0500
X-MC-Unique: F1pOwS_JM2ejnP-s-8PL5g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E9F0801ADA;
        Sat, 19 Feb 2022 00:53:12 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AD4762D5B;
        Sat, 19 Feb 2022 00:53:02 +0000 (UTC)
From:   Baoquan He <bhe@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, 42.hyeyoo@gmail.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        David.Laight@ACULAB.COM, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: [PATCH 03/22] gpu: ipu-v3: Don't use GFP_DMA when calling dma_alloc_coherent()
Date:   Sat, 19 Feb 2022 08:52:02 +0800
Message-Id: <20220219005221.634-4-bhe@redhat.com>
In-Reply-To: <20220219005221.634-1-bhe@redhat.com>
References: <20220219005221.634-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_alloc_coherent() allocates dma buffer with device's addressing
limitation in mind. It's redundent to specify GFP_DMA when calling
dma_alloc_coherent().

[ 42.hyeyoo@gmail.com: Update changelog ]

Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index aa1d4b6d278f..1bd3eff2cf47 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -382,7 +382,7 @@ static int alloc_dma_buf(struct ipu_image_convert_priv *priv,
 {
 	buf->len = PAGE_ALIGN(size);
 	buf->virt = dma_alloc_coherent(priv->ipu->dev, buf->len, &buf->phys,
-				       GFP_DMA | GFP_KERNEL);
+				       GFP_KERNEL);
 	if (!buf->virt) {
 		dev_err(priv->ipu->dev, "failed to alloc dma buffer\n");
 		return -ENOMEM;
-- 
2.17.2

