Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D6929218D
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 06:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgJSEBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 00:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgJSEBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 00:01:34 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89400C061755;
        Sun, 18 Oct 2020 21:01:34 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w21so5209245pfc.7;
        Sun, 18 Oct 2020 21:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4a7zDL5lInqafK1HE5+sC1LmnDT92uD20FAhjTWB/2c=;
        b=RvEzsoLrMfPyOdrlyYzVhc5jxIJ82HKocYt5yBF5R+opSXGiwTWfIYzSwfXc172XQJ
         jmpbSl4/RPWfBf5qTWxJpYlj/gpfnSE7BkVPwR/8uVMmfARhUSqlK4xdE1WwkWg0RDDQ
         khOkaauhEB3zlk01eH9SvIP8F7OY395QKiPLgf5QufBvHcAh0Z45cqqFK49zGxtpuO0j
         t1aobSAJq8WxGWN/lkS5f9wocSqZMEJoJxp6AnigJgjrHmjbKMcVAQqxBPi3aR6Ftaju
         h0AKWESOzFehc6R/PVhCrgYmgdvvGTk0iBrnXDZAkHpJKwcv0ucEZNtyfBTqlz3o5k4i
         7V8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4a7zDL5lInqafK1HE5+sC1LmnDT92uD20FAhjTWB/2c=;
        b=APBsQRQBmp5H8UTF5A+pRZkZicberL9A6ELdgVm53TQ57/nFscvwoUL32mc/nW5Wq4
         /P+oTGGyMfwZBHZJ7wLDaajWLA1SnJcUQF4csloGXeLjv3urnyHdmKTwA8F80yUGxT/0
         aIbDGUUyljezyVQItJH3tV20jcGMOeXK+aTAGQ/CAz2C6uCmwIhpTNzODXWbRBEbFgBa
         BvKaXhH3PDaCjKHpurtVN3Zed/OI+Z+86AxB2l5G1zRlLBZzMlS/ic9zFiVBi73uxaH7
         M2bq6rXwdcNJhIUrIf/1XbVN0yPFHFdXg1m9aKeUu6kPFnO1MDNpFN3HLWtAzklvm3Tx
         sa8Q==
X-Gm-Message-State: AOAM532dFzKLiM+fnP2sGysVaKzZVzvRJXaIc3sq+KhH0e5+hzkURbOV
        onbx3SYW+gt38i8ZEKoqI/w=
X-Google-Smtp-Source: ABdhPJztDuVlMAnRcVxSdRk+FuiekKjqKUVpF7mJfP8K8jNq4BgbaRbn1Ptdy3yHvVoUUmfzQKqNrw==
X-Received: by 2002:aa7:9245:0:b029:156:552a:1275 with SMTP id 5-20020aa792450000b0290156552a1275mr15111588pfp.12.1603080094167;
        Sun, 18 Oct 2020 21:01:34 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([166.111.139.137])
        by smtp.gmail.com with ESMTPSA id o15sm10385457pfd.16.2020.10.18.21.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 21:01:33 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net,
        christophe.jaillet@wanadoo.fr, zhengbin13@huawei.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] rtl8723ae: avoid accessing the data mapped to streaming DMA
Date:   Mon, 19 Oct 2020 12:01:25 +0800
Message-Id: <20201019040125.6892-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rtl8723e_tx_fill_cmddesc(), skb->data is mapped to streaming DMA on
line 531:
  dma_addr_t mapping = dma_map_single(..., skb->data, ...);

On line 534, skb->data is assigned to hdr after cast:
  struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);

Then hdr->frame_control is accessed on line 535:
  __le16 fc = hdr->frame_control;

This DMA access may cause data inconsistency between CPU and hardwre.

To fix this bug, hdr->frame_control is accessed before the DMA mapping.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index e3ee91b7ea8d..340b3d68a54e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
@@ -528,12 +528,12 @@ void rtl8723e_tx_fill_cmddesc(struct ieee80211_hw *hw,
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

