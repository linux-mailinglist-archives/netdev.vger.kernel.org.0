Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4B44BC44C
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 02:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240903AbiBSA5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:57:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240963AbiBSA50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:57:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A634C27F2A6
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645232194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=FO0qQ5sZB2PmWKfJvF7iXis0tLeqxwcvnj2fdvRQ2t8=;
        b=blorrR9vsj/GG4JlSih3XtxAf0XMB7YnwOsqtftuNlnj227AM6/6huKkFO5DvPMcYY11dV
        8Rgc2qAuNoxU6uz84VaUHSmSIb1geKuWQpcQ8L1cPGtszfOOEkK4jMVe5eHrwRNO6DCVxU
        f3Qa/mMY0lC0aCo3wr5WBx0cd7bFK1o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-HEfMI6qUOHavu7krOgDO2w-1; Fri, 18 Feb 2022 19:56:31 -0500
X-MC-Unique: HEfMI6qUOHavu7krOgDO2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53BD01091DA1;
        Sat, 19 Feb 2022 00:56:28 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E14D062D4E;
        Sat, 19 Feb 2022 00:56:16 +0000 (UTC)
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
Subject: [PATCH 17/22] net: marvell: prestera: Don't use GFP_DMA when calling dma_pool_alloc()
Date:   Sat, 19 Feb 2022 08:52:16 +0800
Message-Id: <20220219005221.634-18-bhe@redhat.com>
In-Reply-To: <20220219005221.634-1-bhe@redhat.com>
References: <20220219005221.634-1-bhe@redhat.com>
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

dma_pool_alloc() uses dma_alloc_coherent() to pre-allocate DMA buffer,
so it's redundent to specify GFP_DMA when calling.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
index e452cdeaf703..9f32dcabefb9 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
@@ -116,7 +116,7 @@ static int prestera_sdma_buf_init(struct prestera_sdma *sdma,
 	struct prestera_sdma_desc *desc;
 	dma_addr_t dma;
 
-	desc = dma_pool_alloc(sdma->desc_pool, GFP_DMA | GFP_KERNEL, &dma);
+	desc = dma_pool_alloc(sdma->desc_pool, GFP_KERNEL, &dma);
 	if (!desc)
 		return -ENOMEM;
 
-- 
2.17.2

