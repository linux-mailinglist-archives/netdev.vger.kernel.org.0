Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657F051D94A
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 15:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385790AbiEFNln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 09:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237300AbiEFNll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 09:41:41 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1105766FB7;
        Fri,  6 May 2022 06:37:58 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id fv2so7050563pjb.4;
        Fri, 06 May 2022 06:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xpUwgl4aDlBvgfFaUzZZ4RtkgUszldjbiZ0FW6duKQE=;
        b=F3k+r7LmfI5yB6/WMwrvPKq3VhYjXOXQut0WJRNSXP81M/iZDb1DGL1CyvccvuQCB4
         5RANE1wp92MuvyKP8bGC0C1b58jg5yzn0UE4uSkJKFruDXbq0mqbSZWd7+jFwRu3e0ft
         bt491lGqJjWy9O0LGB/LlogMfNrJtWJQZRltanTYu1dY1sq0ytMz2Jdta05DC2LzdCdY
         vXrjwgUo9FvfsIgC9f0vrk5qy+39a9MBQWSdcsVDQfoMbtQRVRpmSFrc9gzrjdGRX9VI
         jyEhT3SRILAqeP/IP0WFq5FYBObOPxE5GXesp+P14woeRhnQVaHg+PbtaWcyj+VYK+aS
         cdYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xpUwgl4aDlBvgfFaUzZZ4RtkgUszldjbiZ0FW6duKQE=;
        b=vD4UQdduII7qOyJWTicLrT7cyJrEOfvWY4fymrdYSTlGglrAHPrlgfllIYoJd7XBAD
         dTIbGgmHn5xhpxJvNSwNNYbnUq3ISXin1aneOG/tDYDdR8MPsL9hiMqLAUdwPV3bhGok
         8VNAhhmLi4Jg9A5d4c7B44ssfN1rU2fF1wsV8mwpVQ4/z3PGmugsGqc4y9zU9L5jMJDX
         4/U1imgx085n8wA2ruXxpSqIa6S6HwLf9DbpEl1iLNIIVYdn0MEoGfaObwWXIEyMgqrP
         2R4MgeXWYR9RoCve459dF1Hvm8HqtEabwi17LVOptZjV13f4qaKZjVdnSxVYK4ZbzBIh
         2kGQ==
X-Gm-Message-State: AOAM5316Y0JEM9YJJvmbHt09P2mU31JV5JC4cs2OUUFSZi2tShW76QTM
        uhUj4WSJsXciCcGDdfW7rdk=
X-Google-Smtp-Source: ABdhPJzIaN+YCVs9SoYiT+GtQpw5HvZZa9Zv3Cfx9JL1Nm9ck9LOBYoJmU07Ko3CitO4/pwiOaO8dA==
X-Received: by 2002:a17:903:22cb:b0:15e:d715:1bd8 with SMTP id y11-20020a17090322cb00b0015ed7151bd8mr3643431plg.159.1651844277633;
        Fri, 06 May 2022 06:37:57 -0700 (PDT)
Received: from localhost ([166.111.139.123])
        by smtp.gmail.com with ESMTPSA id ot16-20020a17090b3b5000b001dc4d22c0a7sm3643256pjb.10.2022.05.06.06.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 06:37:57 -0700 (PDT)
From:   Zixuan Fu <r33s3n6@gmail.com>
To:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, Zixuan Fu <r33s3n6@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] drivers: net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()
Date:   Fri,  6 May 2022 21:37:48 +0800
Message-Id: <20220506133748.2799853-1-r33s3n6@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vmxnet3_rq_create(), when dma_alloc_coherent() fails, 
vmxnet3_rq_destroy() is called. It sets rq->rx_ring[i].base to NULL. Then
vmxnet3_rq_create() returns an error to its callers mxnet3_rq_create_all()
-> vmxnet3_change_mtu(). Then vmxnet3_change_mtu() calls 
vmxnet3_force_close() -> dev_close() in error handling code. And the driver
calls vmxnet3_close() -> vmxnet3_quiesce_dev() -> vmxnet3_rq_cleanup_all()
-> vmxnet3_rq_cleanup(). In vmxnet3_rq_cleanup(), 
rq->rx_ring[ring_idx].base is accessed, but this variable is NULL, causing
a NULL pointer dereference.

To fix this possible bug, an if statement is added to check whether 
rq->rx_ring[ring_idx].base is NULL in vmxnet3_rq_cleanup().

The error log in our fault-injection testing is shown as follows:

[   65.220135] BUG: kernel NULL pointer dereference, address: 0000000000000008
...
[   65.222633] RIP: 0010:vmxnet3_rq_cleanup_all+0x396/0x4e0 [vmxnet3]
...
[   65.227977] Call Trace:
...
[   65.228262]  vmxnet3_quiesce_dev+0x80f/0x8a0 [vmxnet3]
[   65.228580]  vmxnet3_close+0x2c4/0x3f0 [vmxnet3]
[   65.228866]  __dev_close_many+0x288/0x350
[   65.229607]  dev_close_many+0xa4/0x480
[   65.231124]  dev_close+0x138/0x230
[   65.231933]  vmxnet3_force_close+0x1f0/0x240 [vmxnet3]
[   65.232248]  vmxnet3_change_mtu+0x75d/0x920 [vmxnet3]
...


Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 42 ++++++++++++++++---------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index d9d90baac72a..247fbdfe834a 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1667,28 +1667,30 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
 	struct Vmxnet3_RxDesc *rxd;
 
 	for (ring_idx = 0; ring_idx < 2; ring_idx++) {
-		for (i = 0; i < rq->rx_ring[ring_idx].size; i++) {
-#ifdef __BIG_ENDIAN_BITFIELD
-			struct Vmxnet3_RxDesc rxDesc;
-#endif
-			vmxnet3_getRxDesc(rxd,
-				&rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
-
-			if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
-					rq->buf_info[ring_idx][i].skb) {
-				dma_unmap_single(&adapter->pdev->dev, rxd->addr,
-						 rxd->len, DMA_FROM_DEVICE);
-				dev_kfree_skb(rq->buf_info[ring_idx][i].skb);
-				rq->buf_info[ring_idx][i].skb = NULL;
-			} else if (rxd->btype == VMXNET3_RXD_BTYPE_BODY &&
-					rq->buf_info[ring_idx][i].page) {
-				dma_unmap_page(&adapter->pdev->dev, rxd->addr,
-					       rxd->len, DMA_FROM_DEVICE);
-				put_page(rq->buf_info[ring_idx][i].page);
-				rq->buf_info[ring_idx][i].page = NULL;
+		if (rq->rx_ring[ring_idx].base) {
+			for (i = 0; i < rq->rx_ring[ring_idx].size; i++) {
+	#ifdef __BIG_ENDIAN_BITFIELD
+				struct Vmxnet3_RxDesc rxDesc;
+	#endif
+				vmxnet3_getRxDesc(rxd,
+					&rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
+
+				if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
+						rq->buf_info[ring_idx][i].skb) {
+					dma_unmap_single(&adapter->pdev->dev, rxd->addr,
+							 rxd->len, DMA_FROM_DEVICE);
+					dev_kfree_skb(rq->buf_info[ring_idx][i].skb);
+					rq->buf_info[ring_idx][i].skb = NULL;
+				} else if (rxd->btype == VMXNET3_RXD_BTYPE_BODY &&
+						rq->buf_info[ring_idx][i].page) {
+					dma_unmap_page(&adapter->pdev->dev, rxd->addr,
+						       rxd->len, DMA_FROM_DEVICE);
+					put_page(rq->buf_info[ring_idx][i].page);
+					rq->buf_info[ring_idx][i].page = NULL;
+				}
 			}
 		}
-
+
 		rq->rx_ring[ring_idx].gen = VMXNET3_INIT_GEN;
 		rq->rx_ring[ring_idx].next2fill =
 					rq->rx_ring[ring_idx].next2comp = 0;
-- 
2.25.1

