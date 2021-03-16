Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9BA33CB78
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 03:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbhCPCcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 22:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhCPCcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 22:32:00 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F0EC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 19:31:50 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f8so2728562plg.10
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 19:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fc9j82bUmoIt25oGNXmDahnI+4tMb7EVHwyfDKYoviY=;
        b=kVGkGKkJtrn8EdcBN8VscFhyKaZfpYalbfZirb1+O+K88Gv6YbyWXNmNK1TDM2xDiI
         2Vz+IPQPvo9CNd1m6f9gPt1T6oLWr7imTy5vGgjRwQ3eQhicmSij4GJ+8X0WmeJtT9WI
         84nKYdcVIR8sxjufMzhT5QHhz9nDl8wZMVcwKNqCT0P657g0eeta/BjKOQ0wafDAnGbA
         lDK5VlYP3GdsLvw2AfcjIdpCSx5/BrFG51hy/Owe3LBMxVq9vbzu4sjeZTvFlm9mS2HS
         MgIob/TMGc5M3GcW4XIohDoxPCMryCqeIZYtDvI8ok7GS7xK8xTDwG7P53DSaf62hDJI
         dwRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fc9j82bUmoIt25oGNXmDahnI+4tMb7EVHwyfDKYoviY=;
        b=rgtwBNRgU7mc9fcAA33Pn01n4j6JPfonfQxeCKbxpxznR3jv/x0NrlsEvjXBnAAl0I
         6iM61h3bIRKN0hc8I1RJx79RhIg3UdYbOShoZZnz+za9wLXh9Fo1U9UMNgwUxs6aUOY/
         DipnVUnBpdo1OKrPi2dwTBnCyozRXORg9VivvVM+CC3A8lCa5gOMrvRp0nGiCBW8jkMy
         SVM+sXjssPsP347lH4bmTb81GPpCqq5u0TG0eNKPJk5tL7kwqB45TpYTB87XE/edVc0k
         qVcMr3sCUQMokZ49BHQP+zAjDW68/snEjJd6EpWFEhhF7bpvedTpc60L+kBX5HhTnDd1
         MWLg==
X-Gm-Message-State: AOAM530Lvo6hJQ5nyJSINxwCjlPTThkB0szErMjIJ7UhRvnPLgtKGNTD
        VZcvKKz9VnWD2jvd1euxpcqAuD/GfL7ubw==
X-Google-Smtp-Source: ABdhPJxQRIByJ//CdL+MnG3RSdKl7UYhhaxkxAY3rxZtneTuPan1pZRIgoyCYBnkUlP/kQ++sfTikg==
X-Received: by 2002:a17:90a:d497:: with SMTP id s23mr2274670pju.148.1615861909522;
        Mon, 15 Mar 2021 19:31:49 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t18sm8687743pgg.33.2021.03.15.19.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 19:31:49 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/4] ionic: simplify tx clean
Date:   Mon, 15 Mar 2021 19:31:35 -0700
Message-Id: <20210316023136.22702-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210316023136.22702-1-snelson@pensando.io>
References: <20210316023136.22702-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The descriptor mappings are set up the same way whether
or not it is a TSO, so we don't need separate logic for
the two cases.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 30 +++++--------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 1d27d6cad504..f841ccb5adfd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -654,35 +654,19 @@ static void ionic_tx_clean(struct ionic_queue *q,
 			   struct ionic_cq_info *cq_info,
 			   void *cb_arg)
 {
-	struct ionic_txq_sg_desc *sg_desc = desc_info->sg_desc;
 	struct ionic_buf_info *buf_info = desc_info->bufs;
-	struct ionic_txq_sg_elem *elem = sg_desc->elems;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct ionic_txq_desc *desc = desc_info->desc;
 	struct device *dev = q->dev;
-	u8 opcode, flags, nsge;
 	u16 queue_index;
 	unsigned int i;
-	u64 addr;
-
-	decode_txq_desc_cmd(le64_to_cpu(desc->cmd),
-			    &opcode, &flags, &nsge, &addr);
 
-	if (opcode != IONIC_TXQ_DESC_OPCODE_TSO) {
-		dma_unmap_single(dev, (dma_addr_t)addr,
-				 le16_to_cpu(desc->len), DMA_TO_DEVICE);
-		for (i = 0; i < nsge; i++, elem++)
-			dma_unmap_page(dev, (dma_addr_t)le64_to_cpu(elem->addr),
-				       le16_to_cpu(elem->len), DMA_TO_DEVICE);
-	} else {
-		if (flags & IONIC_TXQ_DESC_FLAG_TSO_EOT) {
-			dma_unmap_single(dev, (dma_addr_t)buf_info->dma_addr,
-					 buf_info->len, DMA_TO_DEVICE);
-			buf_info++;
-			for (i = 1; i < desc_info->nbufs; i++, buf_info++)
-				dma_unmap_page(dev, (dma_addr_t)buf_info->dma_addr,
-					       buf_info->len, DMA_TO_DEVICE);
-		}
+	if (desc_info->nbufs) {
+		dma_unmap_single(dev, (dma_addr_t)buf_info->dma_addr,
+				 buf_info->len, DMA_TO_DEVICE);
+		buf_info++;
+		for (i = 1; i < desc_info->nbufs; i++, buf_info++)
+			dma_unmap_page(dev, (dma_addr_t)buf_info->dma_addr,
+				       buf_info->len, DMA_TO_DEVICE);
 	}
 
 	if (cb_arg) {
-- 
2.17.1

