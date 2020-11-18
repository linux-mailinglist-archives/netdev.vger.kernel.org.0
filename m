Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CD62B73E8
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgKRBxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKRBxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:53:53 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C634C061A48;
        Tue, 17 Nov 2020 17:53:51 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id js21so219902pjb.0;
        Tue, 17 Nov 2020 17:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=t5eReXO4wqmdOiCBF4R3AZcbfxasgeFRgSN87jtfTOA=;
        b=iOOTgarBSRRV3nOEIu7RPO2lJzpE7H0bWf/Qkv32Dwl6ecP2lZqAw7+9hfCztF88lC
         His2eJEuigwDBhcb9hfT6xTOzQiZwORJCx67+WrAQGLSwIqpWOuZ/VX6Gh6/HkC+2aRq
         KEf67tHBbfprzTe+J1pEJQbnO6bdDHVf8SoIy2krfHhWsaZ31xIe7HbqPdAt534yxBIe
         DbP/bXXy27S9bOantElC6qzqEDgBXRGKel3B4MOdILOz7TODEmn06lLxC4+eOiJz3JR9
         y/M1GrVNQgxFTVtVuQAs7lfPhQVHTUlB8GTpqHKICauG/J6euAUjJMSbS1Jg1NS//FiR
         Y9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=t5eReXO4wqmdOiCBF4R3AZcbfxasgeFRgSN87jtfTOA=;
        b=c3Sd/NzeGJwMwNE5NgxeHweviNkDG1Mz7ejc1gHyTzlIBa92mpQ5EG5WUeM3X78fPm
         Trn1lSpZj4fWJ5ZYWxUk8AZKhDZ6ZjNJfDNSjps8pwZD0FYaH8t3TE6ComU4ppeExNFe
         72yKU/v/ZkWmU73TDs9s+ocOhE3ouXa0M+sB8EMtKoXAg6zdk9DNOtmEnwX1Euka4kp0
         ReWD08ym3PLE2jvjCDITvKYxk+4WMMNx7GyjF2MkWGre9ykCAcdPaHljSuJ+3AqaBZMX
         i91p3NV9YPq90+diHdP3jtPm2vZzTTBnmhrlsNmy1omoxjWvTU5MM/9J9tR0eefdZphR
         BqTw==
X-Gm-Message-State: AOAM530FjbTsVYtaLZkXp+p5O4a3skc5JhJzoakufqJ0pM8dp8d8z3Fj
        IiO3zw1jQGBofqNFJfSr4i8=
X-Google-Smtp-Source: ABdhPJxTtKOhfudWJ+Y1l0w8jEU3rSWDhUb1E21+wQSdIi35mopiq4+sofDFLHqLhSuaxds8II+/Lg==
X-Received: by 2002:a17:90a:f0c7:: with SMTP id fa7mr1876767pjb.3.1605664430920;
        Tue, 17 Nov 2020 17:53:50 -0800 (PST)
Received: from oslab.tsinghua.edu.cn ([166.111.139.137])
        by smtp.gmail.com with ESMTPSA id t32sm21430494pgl.0.2020.11.17.17.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 17:53:50 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2 1/4] rtlwifi: rtl8188ee: avoid accessing the data mapped to streaming DMA
Date:   Wed, 18 Nov 2020 09:53:14 +0800
Message-Id: <20201118015314.4979-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rtl88ee_tx_fill_cmddesc(), skb->data is mapped to streaming DMA on
line 677:
  dma_addr_t mapping = dma_map_single(..., skb->data, ...);

On line 680, skb->data is assigned to hdr after cast:
  struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);

Then hdr->frame_control is accessed on line 681:
  __le16 fc = hdr->frame_control;

This DMA access may cause data inconsistency between CPU and hardwre.

To fix this bug, hdr->frame_control is accessed before the DMA mapping.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index b9775eec4c54..c948dafa0c80 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -674,12 +674,12 @@ void rtl88ee_tx_fill_cmddesc(struct ieee80211_hw *hw,
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

