Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2660A29215D
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 05:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731349AbgJSDJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 23:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728660AbgJSDJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 23:09:39 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6884C061755;
        Sun, 18 Oct 2020 20:09:39 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id p11so4260207pld.5;
        Sun, 18 Oct 2020 20:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kE2vWbri16fQXY9rpZDoR0E3WjS1MfyWuTMn6iwlvi0=;
        b=WHAkofSvpxnAin+a9XCsOwK2Kt2QArHkMpNTywDyT48/doTUs6TsMfp8QLuFzxr814
         cW2JZKU19OpbwuFvdTO0kjhi6hERXdaCG7K12NitdIBzYel5C2gHd+zDh4oEHfhRdVza
         FArR5+4VGLXlIrfQDEIsOosDsVLbHOJYH6PZzdeRQl0dk9GtWFAOSFGSRnc2ekMY/1Lu
         RuK8TdbjZn7xJzobRfAmuzSjtoqF79rauFg8Xg4on30STPUqA6Z0reTBVMEzYmCDPSgf
         wrwW+iUyWzmpwfwjrqsF6y8NvpOkc/juQCVn3krDz/+BuxtuEt/wfQVwA+LvnocDjy+s
         nF2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kE2vWbri16fQXY9rpZDoR0E3WjS1MfyWuTMn6iwlvi0=;
        b=DHYkMH+5JPcelPa95J0HP0unK5YQ6gOk9vgFZAeQ9of9OAMtfSc8fi1cH2Q843FzwH
         qy97dfMghrMJGtK2MmAPcyRiN9DxmIxeL26fbpKunOGwOQywT/UWnNIIMwYdot3D0VLT
         BrVU0TqmUM6c/wfZpPpzKnTt6dzoey++pMBvR2hT+Kb9tagewZs0nG77goJpaLNrgrr0
         XbVWpJMjVW8mibuWsUR/hmjdOusU9wKetn7X5eZHFHQT7ACEBUAA1F4sqXMJGzObJg+m
         y/svJ4c30u1FtdrEzifq8K6I+/pQgXh10uX86B6WbsZ+vKE1xjsFG2lASQ5f5bWS+lv7
         +K0w==
X-Gm-Message-State: AOAM530WwsGVHZspTBexm8InAs3U87x+m2Yg7X2jNFfw6hH9q4xdCT/p
        1dRRKmjf0Ot+FONbTjGZL3gmpc8BPSo=
X-Google-Smtp-Source: ABdhPJxyYMBR74lbDEbV+AxXZvOe9e8MKN+LBscIC266xnv+tOqvAZyr7iQcLPmHV4pm91sdxQjYGw==
X-Received: by 2002:a17:90b:2389:: with SMTP id mr9mr15267215pjb.146.1603076979251;
        Sun, 18 Oct 2020 20:09:39 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([166.111.139.137])
        by smtp.gmail.com with ESMTPSA id y65sm9796864pfy.57.2020.10.18.20.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 20:09:38 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, straube.linux@gmail.com,
        Larry.Finger@lwfinger.net, christophe.jaillet@wanadoo.fr
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] rtl8192ce: avoid accessing the data mapped to streaming DMA
Date:   Mon, 19 Oct 2020 11:09:31 +0800
Message-Id: <20201019030931.4796-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rtl92ce_tx_fill_cmddesc(), skb->data is mapped to streaming DMA on
line 530:
  dma_addr_t mapping = dma_map_single(..., skb->data, ...);

On line 533, skb->data is assigned to hdr after cast:
  struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);

Then hdr->frame_control is accessed on line 534:
  __le16 fc = hdr->frame_control;

This DMA access may cause data inconsistency between CPU and hardwre.

To fix this bug, hdr->frame_control is accessed before the DMA mapping.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
index c0635309a92d..4165175cf5c0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
@@ -527,12 +527,12 @@ void rtl92ce_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	u8 fw_queue = QSLT_BEACON;
 	__le32 *pdesc = (__le32 *)pdesc8;
 
-	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
-					    skb->len, DMA_TO_DEVICE);
-
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	__le16 fc = hdr->frame_control;
 
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
+
 	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		rtl_dbg(rtlpriv, COMP_SEND, DBG_TRACE,
 			"DMA mapping error\n");
-- 
2.17.1

