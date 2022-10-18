Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4856027C4
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiJRJBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiJRJBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:01:05 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968FFA8CEC
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:00:53 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id o21so10798794ple.5
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=98TbBLWDOIP9iM561Q2o7phm/lwEe/LRJztlwtQ6oow=;
        b=ExDU5AF7y8Ljod9TeBX85oH8I8YhbhYsRiSHlDhLAaNBXhU207TyGnIOU1YFjue4xn
         YTULwM+Ng8TmwtpND720aRpXBzXrXzJS0HE6YytS6hUhYgB9iwOdEwBzcFXDJdx9n17C
         +QZmcuf3P9UD0LHt91EIjjKInqd1HdhFibKts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=98TbBLWDOIP9iM561Q2o7phm/lwEe/LRJztlwtQ6oow=;
        b=bG31RjXQ5dcXO/NarUj9G1wd23xP7Rz+arup22/0d8ZxgrxXVWnVQPWMqX4Bw0pl4e
         Gx8Bx3+mPLyH4t77qdBAKUsIn8zujrC3jBcTPybnm9QNWH2gF1e93sTsIzFFp02SuPPz
         1hmlVtq0edJTYkNIzeDq5mimJ/a70lJ2xEkuo8pjDqc+QLWF4oGLW8MoEpEUP25yrO6T
         23vJBFw1qdtS6LsCLcl4P08s5Bator3bRVCWmhmFjtcdzlCtVLym2JlImuxf+Q1VWuKj
         4oHdMVmcqo9kK1labzAtEPnslE/Nlbmr25M3yGm3/jtys+VH0W1WwhXyw0+E+KjoXJFk
         T80Q==
X-Gm-Message-State: ACrzQf3fXjVZJF6UEzESZ2xNkrtKl8wvyxCGXCfx3IgGV/dqzuxU+hIF
        rqqToggDB5q9v6tnq3Saov2GMQ==
X-Google-Smtp-Source: AMsMyM5su6GLmd3wVNJsyS2KxLEl2Sk6pk5VZJ9yUf8GGHfjD8HJ0MkSbQIwlxJwAqNg+d9TDzyy8Q==
X-Received: by 2002:a17:902:ef83:b0:17c:a2f:1e3 with SMTP id iz3-20020a170902ef8300b0017c0a2f01e3mr1992176plb.35.1666083651847;
        Tue, 18 Oct 2022 02:00:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h5-20020a628305000000b00562a90f9875sm8630912pfe.167.2022.10.18.02.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 02:00:50 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] qed: Track allocation size of qed_ll2_buffer
Date:   Tue, 18 Oct 2022 02:00:48 -0700
Message-Id: <20221018090027.never.700-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4379; h=from:subject:message-id; bh=UyyxwN+spSmWTLahrOtBvcs2kdSsrHvIxeq7xjgzxAc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjTms/afJfd6NFoOASWSA5BvOB/d/kv7yz76GU3kTy 96NR43eJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY05rPwAKCRCJcvTf3G3AJnyoD/ 96Puqc3mwbifAok8jYR51omfrSTOzcnIy+24Lc+hWCEUI0X9Mae3T32iaf3M6MQamz58gRkFhYh8ag OioYvgTc5Z9ZMhrOPN3kth8r6vWTl9siGhOgrfvzDaa4tfzS4zUVBzSjA1obL603yhgneYGv8+fsJ7 NDeYRcco36RkgG8hkh9qz5J/5HWV5CHXDxBojXtsRAHqdBM8FMWAMUk0MMoxv/VOCMrMirZaJS40Xx 4yxWMu3fpNx1xklAzwOOgC+knGVlSmoqtLFN0AWge2/nrrrf/IDbV4bCBQ51Zyo1L7F4MWDBxAyeks M3OU6g4maAYxUfomo7qg1AjGYmor+dmTBPL4u17+Y6GChIop+1At3TirvQBhZhmzw1MXsBEk1+MRN4 eMiFOsHxlRKM82T3mRyRNC/qnjfmAMYRzyKaDerE9tgYiB+IyUN1GidNYC+oi1POesNztp+USd09pM E9t0ITfKI8f3Rtqs4v4XOXn5DCbhfSVtug8Y5pt30uMEbqBvfrmCqsNGHcIpGgP0uAX/5t8ax7LyyF u/jQbTjXGgvsApnDWB2lPKpIlbYC6SRUDNpRSyv5DtC+9tTJs3zyIS5Rj+eTUJPWurmUwFCLF6Cvzu ampL8iyaIFIF4uoYM6Ki6dQqzPnM1npki4AYALAlwduLJ8zlQ1qrue1N6PfA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for requiring that build_skb() have a non-zero size
argument, track the qed_ll2_buffer data allocation size explicitly
and pass it into build_skb(). To retain the original result of using
the ksize() side-effect on the skb size, explicitly round up the size
during allocation.

Cc: Ariel Elior <aelior@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 37 ++++++++++++-----------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index ed274f033626..750391e4d80a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -62,6 +62,7 @@ struct qed_cb_ll2_info {
 struct qed_ll2_buffer {
 	struct list_head list;
 	void *data;
+	u32 len;
 	dma_addr_t phys_addr;
 };
 
@@ -111,20 +112,23 @@ static void qed_ll2b_complete_tx_packet(void *cxt,
 }
 
 static int qed_ll2_alloc_buffer(struct qed_dev *cdev,
-				u8 **data, dma_addr_t *phys_addr)
+				struct qed_ll2_buffer *buffer)
 {
-	*data = kmalloc(cdev->ll2->rx_size, GFP_ATOMIC);
-	if (!(*data)) {
+	buffer->len = kmalloc_size_roundup(cdev->ll2->rx_size);
+	buffer->data = kmalloc(buffer->len, GFP_ATOMIC);
+	if (!buffer->data) {
 		DP_INFO(cdev, "Failed to allocate LL2 buffer data\n");
+		buffer->len = 0;
 		return -ENOMEM;
 	}
 
-	*phys_addr = dma_map_single(&cdev->pdev->dev,
-				    ((*data) + NET_SKB_PAD),
-				    cdev->ll2->rx_size, DMA_FROM_DEVICE);
-	if (dma_mapping_error(&cdev->pdev->dev, *phys_addr)) {
+	buffer->phys_addr = dma_map_single(&cdev->pdev->dev,
+					   buffer->data + NET_SKB_PAD,
+					   buffer->len, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&cdev->pdev->dev, buffer->phys_addr)) {
 		DP_INFO(cdev, "Failed to map LL2 buffer data\n");
-		kfree((*data));
+		kfree(buffer->data);
+		buffer->len = 0;
 		return -ENOMEM;
 	}
 
@@ -139,6 +143,7 @@ static int qed_ll2_dealloc_buffer(struct qed_dev *cdev,
 	dma_unmap_single(&cdev->pdev->dev, buffer->phys_addr,
 			 cdev->ll2->rx_size, DMA_FROM_DEVICE);
 	kfree(buffer->data);
+	buffer->len = 0;
 	list_del(&buffer->list);
 
 	cdev->ll2->rx_cnt--;
@@ -164,11 +169,10 @@ static void qed_ll2b_complete_rx_packet(void *cxt,
 	struct qed_hwfn *p_hwfn = cxt;
 	struct qed_ll2_buffer *buffer = data->cookie;
 	struct qed_dev *cdev = p_hwfn->cdev;
-	dma_addr_t new_phys_addr;
+	struct qed_ll2_buffer new_buffer = { };
 	struct sk_buff *skb;
 	bool reuse = false;
 	int rc = -EINVAL;
-	u8 *new_data;
 
 	DP_VERBOSE(p_hwfn,
 		   (NETIF_MSG_RX_STATUS | QED_MSG_STORAGE | NETIF_MSG_PKTDATA),
@@ -191,8 +195,7 @@ static void qed_ll2b_complete_rx_packet(void *cxt,
 
 	/* Allocate a replacement for buffer; Reuse upon failure */
 	if (!reuse)
-		rc = qed_ll2_alloc_buffer(p_hwfn->cdev, &new_data,
-					  &new_phys_addr);
+		rc = qed_ll2_alloc_buffer(p_hwfn->cdev, &new_buffer);
 
 	/* If need to reuse or there's no replacement buffer, repost this */
 	if (rc)
@@ -200,7 +203,7 @@ static void qed_ll2b_complete_rx_packet(void *cxt,
 	dma_unmap_single(&cdev->pdev->dev, buffer->phys_addr,
 			 cdev->ll2->rx_size, DMA_FROM_DEVICE);
 
-	skb = build_skb(buffer->data, 0);
+	skb = build_skb(buffer->data, buffer->len);
 	if (!skb) {
 		DP_INFO(cdev, "Failed to build SKB\n");
 		kfree(buffer->data);
@@ -235,8 +238,9 @@ static void qed_ll2b_complete_rx_packet(void *cxt,
 
 out_post1:
 	/* Update Buffer information and update FW producer */
-	buffer->data = new_data;
-	buffer->phys_addr = new_phys_addr;
+	buffer->data = new_buffer.data;
+	buffer->len = new_buffer.len;
+	buffer->phys_addr = new_buffer.phys_addr;
 
 out_post:
 	rc = qed_ll2_post_rx_buffer(p_hwfn, cdev->ll2->handle,
@@ -2608,8 +2612,7 @@ static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
 			goto err0;
 		}
 
-		rc = qed_ll2_alloc_buffer(cdev, (u8 **)&buffer->data,
-					  &buffer->phys_addr);
+		rc = qed_ll2_alloc_buffer(cdev, buffer);
 		if (rc) {
 			kfree(buffer);
 			goto err0;
-- 
2.34.1

