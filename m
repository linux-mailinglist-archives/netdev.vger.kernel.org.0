Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9772B89C8
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgKSBvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgKSBvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:51:40 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762F1C0613D4;
        Wed, 18 Nov 2020 17:51:38 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id y7so2890137pfq.11;
        Wed, 18 Nov 2020 17:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3r5FZrPv+WHArPH9yqncOxdfTiMaYsbEsDIytgtTf2k=;
        b=B68UiTUZfXssmJtMqOe1VvpB4J8RMb+KXeHqyINfBPaG9OGRrl9a3ALtiPByvZFTcy
         R7CUYBAq4tmfgEzDBc8Sc0JnIe1obvw622jeEDHSuh8E6FNqVWB0kXo9ABMY6XRZ707R
         XOflQwYUMSm2U9uiJelSrw1Q22h+ZCRUb4dyWx8jGQ++bdQ1fM2io0rgxAIGCvdNhgLV
         cYxu4ZZIi++mocXnbuOvRUMq+h1/YQn5x6fErsAqbXnFonqwQVnlgPtVQEsQ4qJSs7SS
         I0b6i5jXM7IZ0TSbzDAbNOtMboVrUSuJbeMeU3CDB3aqexqtCxhUGz3w72suGnqZ8HBB
         M41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3r5FZrPv+WHArPH9yqncOxdfTiMaYsbEsDIytgtTf2k=;
        b=ldYXqNNeM51KB0tzQwVoaAOkdlg5lv4U3YV+lDydwon+6n1KlP4FgEJmUJHVrTmsHJ
         PuJpaAH9rYhGGUQwgc88zS66geVBvNG9wVW640tyIjToMeZ65kM9/ikgI8K03RUJevDy
         UKSHAs8taMI1agbswFDKhfxsUl8ZY4L9gL1s7y5Cbp+NHXg0Qg7zqxQ2XdhqM8AZ11U5
         5NP4Exlrhfixp/n9S9pb7sbQlFFu6JGDaEcuyrrEVCO9AGvTHUVabjXnisxfS8IZwnjY
         MF0YYDMD+pNd+6kDpj9ouCRZu6Lvn6CqS/YFPXHNcSlSoTYYQ0JrjoWe3uED2v2mgUa0
         F5HA==
X-Gm-Message-State: AOAM5317B0en3eD3l/0pWR+MLMP+37Uu7s6V//zEc/WlUDh3DPSm3AWo
        WYC7MIGBZ8FHG17zUnOAlcs=
X-Google-Smtp-Source: ABdhPJxn1hPFjguU/lx7e1TERyJiuCSd2U9KvvRdrHXrqmCBn6zNigbbZIltJmjpFG3kOv7JBO0UDw==
X-Received: by 2002:aa7:981a:0:b029:18b:490f:77d9 with SMTP id e26-20020aa7981a0000b029018b490f77d9mr7033443pfl.46.1605750697927;
        Wed, 18 Nov 2020 17:51:37 -0800 (PST)
Received: from localhost.localdomain ([45.56.153.149])
        by smtp.gmail.com with ESMTPSA id e201sm27003636pfh.73.2020.11.18.17.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 17:51:37 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2 1/4 resend] rtlwifi: rtl8188ee: avoid accessing the data mapped to streaming DMA
Date:   Thu, 19 Nov 2020 09:51:27 +0800
Message-Id: <20201119015127.12033-1-baijiaju1990@gmail.com>
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
v2: 
* Use "rtlwifi" as subject prefix and have all rtlwifi patches in the
  same pathset.
  Thank Ping and Larry for good advice.

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

