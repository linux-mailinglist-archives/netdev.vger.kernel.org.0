Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8276D4BC435
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 02:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239277AbiBSA6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:58:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241025AbiBSA5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:57:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1744C27792B
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645232230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Gw/NJK8fpoJAAgLoy5A/sOEoEXpxXVtHErMcNbgZLPI=;
        b=UAuzkxcJoeLT69J+P2p5K5wXDb086xACuLhSX10UIQ05Pln8g1eBB7OL7e90z+yU1GRYr+
        w/yhpg2ZI3AQK72bDCFCILbKWl2ikbuuzdjFuIcygfadyGOeVw7gOx46nhwcdslQ5isvB0
        E7jVr85oc5CyysUgs6VHf06AOuhEjwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-xetRNHCfO521Ql8W4vgBdQ-1; Fri, 18 Feb 2022 19:57:07 -0500
X-MC-Unique: xetRNHCfO521Ql8W4vgBdQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 096CD1091DA0;
        Sat, 19 Feb 2022 00:57:04 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA67A62D4E;
        Sat, 19 Feb 2022 00:56:52 +0000 (UTC)
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
Subject: [PATCH 20/22] HID: intel-ish-hid: Use dma_alloc_noncoherent() for dma buffer
Date:   Sat, 19 Feb 2022 08:52:19 +0800
Message-Id: <20220219005221.634-21-bhe@redhat.com>
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

GFP_DMA32 is an illegal flag to pass when calling kmalloc(), please see
GFP_SLAB_BUG_MASK definition.

Allocating dma buffer using kmalloc() is not recommended. Use
dma_alloc_noncoherent() instead. DMA API will assume the device has
32 bit addressing limitation when allocating buffer.

[ 42.hyeyoo@gmail.com: Use dma_alloc_noncoherent() instead of
  __get_free_pages ]

Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: christian.koenig@amd.com
Cc: linux-input@vger.kernel.org
---
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c | 23 +++++++--------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
index e24988586710..3be1e3329962 100644
--- a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
+++ b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
@@ -661,21 +661,15 @@ static int ish_fw_xfer_direct_dma(struct ishtp_cl_data *client_data,
 	 */
 	payload_max_size &= ~(L1_CACHE_BYTES - 1);
 
-	dma_buf = kmalloc(payload_max_size, GFP_KERNEL | GFP_DMA32);
+	dma_buf = dma_alloc_noncoherent(devc, get_order(payload_max_size),
+				        &dma_buf_phy, DMA_TO_DEVICE,
+					GFP_KERNEL);
 	if (!dma_buf) {
+		dev_err(cl_data_to_dev(client_data), "DMA alloc failed\n");
 		client_data->flag_retry = true;
 		return -ENOMEM;
 	}
 
-	dma_buf_phy = dma_map_single(devc, dma_buf, payload_max_size,
-				     DMA_TO_DEVICE);
-	if (dma_mapping_error(devc, dma_buf_phy)) {
-		dev_err(cl_data_to_dev(client_data), "DMA map failed\n");
-		client_data->flag_retry = true;
-		rv = -ENOMEM;
-		goto end_err_dma_buf_release;
-	}
-
 	ldr_xfer_dma_frag.fragment.hdr.command = LOADER_CMD_XFER_FRAGMENT;
 	ldr_xfer_dma_frag.fragment.xfer_mode = LOADER_XFER_MODE_DIRECT_DMA;
 	ldr_xfer_dma_frag.ddr_phys_addr = (u64)dma_buf_phy;
@@ -725,15 +719,14 @@ static int ish_fw_xfer_direct_dma(struct ishtp_cl_data *client_data,
 		fragment_offset += fragment_size;
 	}
 
-	dma_unmap_single(devc, dma_buf_phy, payload_max_size, DMA_TO_DEVICE);
-	kfree(dma_buf);
+	dma_free_noncoherent(devc, get_order(payload_max_size), dma_buf,
+			     dma_buf_phy, DMA_TO_DEVICE);
 	return 0;
 
 end_err_resp_buf_release:
 	/* Free ISH buffer if not done already, in error case */
-	dma_unmap_single(devc, dma_buf_phy, payload_max_size, DMA_TO_DEVICE);
-end_err_dma_buf_release:
-	kfree(dma_buf);
+	dma_free_noncoherent(devc, get_order(payload_max_size), dma_buf,
+			     dma_buf_phy, DMA_TO_DEVICE);
 	return rv;
 }
 
-- 
2.17.2

