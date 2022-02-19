Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C210B4BC3CC
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 01:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240679AbiBSAy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:54:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240628AbiBSAyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:54:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8286A2782AE
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645232071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=V8JpX32qMDcHw+sG2r5d1Aclzssu5Nunlxd6Q2UdrcU=;
        b=DJ52TcmS06/0nsV8vTkwbG+udS5vsEs73Nq/OADa++fpq2JjWAjdNTq64LJekwbAizGD79
        C3LACAP1LNAIdS0DDttt3fHolooRVSfNlw38+nb5/kuRYd3rABJYi4Q0HvZCxq3+bq0vYf
        p0jQ6m3bhU7rn6NZU22x4Non7bMqZiE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-83stk923PIuc_lur_mT1GA-1; Fri, 18 Feb 2022 19:54:28 -0500
X-MC-Unique: 83stk923PIuc_lur_mT1GA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D3811006AA0;
        Sat, 19 Feb 2022 00:54:25 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC9FA62D4E;
        Sat, 19 Feb 2022 00:54:15 +0000 (UTC)
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
Subject: [PATCH 09/22] usb: cdns3: Don't use GFP_DMA when calling dma_alloc_coherent()
Date:   Sat, 19 Feb 2022 08:52:08 +0800
Message-Id: <20220219005221.634-10-bhe@redhat.com>
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
dma_alloc_coherent(). replace it with GFP_KERNEL.

[ 42.hyeyoo@gmail.com: Update changelog ]

Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 drivers/usb/cdns3/cdns3-gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index f9af7ebe003d..c0937d3d663f 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -3203,7 +3203,7 @@ static int cdns3_gadget_start(struct cdns *cdns)
 
 	/* allocate memory for setup packet buffer */
 	priv_dev->setup_buf = dma_alloc_coherent(priv_dev->sysdev, 8,
-						 &priv_dev->setup_dma, GFP_DMA);
+						 &priv_dev->setup_dma, GFP_KERNEL);
 	if (!priv_dev->setup_buf) {
 		ret = -ENOMEM;
 		goto err2;
-- 
2.17.2

