Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92212B73EC
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgKRByR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKRByQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:54:16 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D84C061A48;
        Tue, 17 Nov 2020 17:54:14 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id j19so103240pgg.5;
        Tue, 17 Nov 2020 17:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kE2vWbri16fQXY9rpZDoR0E3WjS1MfyWuTMn6iwlvi0=;
        b=iiFu2ayhZnskDuDsAvBIsBT9XoHdbAP5FCqNxNZEshQQTBwoK57TUH7I4nwEPs3yiA
         YcZtjmYGNovytP0200S0c5iIfLjKAJzGDjJ3aFtU5WCrhxWDKfng1pO0Y0XnFLE2BWgZ
         /X44f7HDqpaQNkJBIXW/abwxdvuLcK4OYn3UHX33TpSDzhXhCvgRB6Mejbxiz3qHrHS6
         hwXWesxEaTxrHWMwtLOcOndeIjWPK09Qps74dBJxf7H9PyvpYA7wM7gCaluJJUDkBkmi
         t7DkpSYOlICkVc8llYIkf5R2aMZ8NtQwmOMZ6Gu70o80Im+Jsobss6+Bq4rLyUdb/dRd
         ifqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kE2vWbri16fQXY9rpZDoR0E3WjS1MfyWuTMn6iwlvi0=;
        b=HYKZgPxGYx3mDAQ1C76opSvZYVIihL2x4X8ZvTXyR7faOzDXMbZ8VXdCdkz7FTxlsf
         OvU0Nw4jkB5DEpaZ53H49BAugjgvxCNE+TH6efFN1u4xi/Hj2q8SBYIJi1f406NYyFh+
         K3e1qQ1Wax/aCE16hgcYkt2YwdhArIdBGNz7IauCqLfRh7dV/VCEKknEHK7Gf1IVeVVo
         EciDija3gQb9Mdn05T2REWCUf8lbagzb/q5B/DjPDqFfGXu8026rRa4A80VXaXfYMZtu
         eZM77bT25xBXU/JhNyHod3Mbt3+896bl2VV81ugx/HmzrwkUqoCE39+DLgN8N1gM+Gto
         QiyA==
X-Gm-Message-State: AOAM531pTPyE0VX7b1x0chr7LiaSriPdm/bahyssMvk+7vVhyLk/ee+G
        7ciGHXVLc7mqBGL4l471HXLBzEJPFJH27g==
X-Google-Smtp-Source: ABdhPJwS8sEN4T0K9UeLEWD5OYJsN/8uWi/+Ml/mDUWddf454R3fQuAuhsXE55kA3Homy5+gJvdjvg==
X-Received: by 2002:a05:6a00:8c4:b029:196:6931:2927 with SMTP id s4-20020a056a0008c4b029019669312927mr2233801pfu.56.1605664454506;
        Tue, 17 Nov 2020 17:54:14 -0800 (PST)
Received: from oslab.tsinghua.edu.cn ([166.111.139.137])
        by smtp.gmail.com with ESMTPSA id v23sm22617513pfn.141.2020.11.17.17.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 17:54:13 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2 2/4] rtlwifi: rtl8192ce: avoid accessing the data mapped to streaming DMA
Date:   Wed, 18 Nov 2020 09:54:06 +0800
Message-Id: <20201118015406.5063-1-baijiaju1990@gmail.com>
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

