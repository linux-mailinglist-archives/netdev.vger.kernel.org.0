Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2D32B73EF
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgKRBy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKRByZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:54:25 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD66C061A48;
        Tue, 17 Nov 2020 17:54:25 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id h12so214963pjv.2;
        Tue, 17 Nov 2020 17:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+XVQiLhPjTZQE7BJhiPhjmEEz4RW+ut2EJwMRL1LH18=;
        b=LYfvQ9lIzEjwOb1CVUstMO/UfVPBBhU9xlsaQopp0IGnfbV4Ns2JSr1z786oJYHYri
         bd/sQt7CeWlUhRUP2iuTNjA2q3DTgGNdu8K+Lr4WrnPhR6VooyuhmbQ8MjeKBwAXpP54
         sT7jT9QQFhWPUubPbQ4bzoIDw0tFntnsYMlmdxwxnmx5KWBfcPhr4j0a4KyJ5TpRLyGh
         pb4BP8ZUKMZnpzVjOrU/HoibDwgXmoAzg3z3k9oCENcDzGPLoSQ4B1KAbG8jU5AYoNcZ
         vxMEzjVQxkLNmFF31YrKaWebKf5bULIkoi4HTRcOnwXSBZWogjwc7a6+DVG5dljM2Xti
         GcTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+XVQiLhPjTZQE7BJhiPhjmEEz4RW+ut2EJwMRL1LH18=;
        b=Xf/X+CJ21ILwqjUC4pwWXW4XESU5O49LErf9l/XKcrGraxcRnQE3wNDzXbCL9R4SSH
         pvaSGvzyEIpppkpwJWwP0Ljv56qLj8mjRsXeRUUfVPicKWSuiSErQKbFqaqk0qi1aHhE
         4TQ5HfxVq8c9KKTDFXUsbyQGJ8JCIa7VybWJrdVHiSq8PkPMs9Bc9HMkWB/OCVMc3Hxx
         eVu2+rk1dw8yi2q6l+vm2+QO/hrhiY6yqTyAbsAOScrgIDoep0hsfBZwn5NEDaF8GoPS
         C3rYH/7Atk3VO3f7NlDbFJPxOrFwjECtpQNL1M7sM5c6ZHfo9Bff1ec/xOrbiKYD8OpX
         UH2A==
X-Gm-Message-State: AOAM532ujmU6k8k528o5XLX5wfKSRkBATYImZG9Y/2aJagHpZXks6XI8
        aReCFYOebBmvLTgttaXQ2Ag=
X-Google-Smtp-Source: ABdhPJyrs5SICFqofuIp7QcyHMO6bgLTzwDISjnQhdiB0ni+j5Egq/Zs1vhmZIq9KxyPBGyQVVw4Sw==
X-Received: by 2002:a17:90b:241:: with SMTP id fz1mr1835713pjb.172.1605664465091;
        Tue, 17 Nov 2020 17:54:25 -0800 (PST)
Received: from oslab.tsinghua.edu.cn ([166.111.139.137])
        by smtp.gmail.com with ESMTPSA id w70sm22402883pfc.11.2020.11.17.17.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 17:54:24 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2 3/4] rtlwifi: rtl8192de: avoid accessing the data mapped to streaming DMA
Date:   Wed, 18 Nov 2020 09:54:18 +0800
Message-Id: <20201118015418.5122-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rtl92de_tx_fill_cmddesc(), skb->data is mapped to streaming DMA on
line 667:
  dma_addr_t mapping = dma_map_single(..., skb->data, ...);

On line 669, skb->data is assigned to hdr after cast:
  struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);

Then hdr->frame_control is accessed on line 670:
  __le16 fc = hdr->frame_control;

This DMA access may cause data inconsistency between CPU and hardwre.

To fix this bug, hdr->frame_control is accessed before the DMA mapping.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
index 8944712274b5..c02813fba934 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
@@ -664,12 +664,14 @@ void rtl92de_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtlpriv);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 fw_queue = QSLT_BEACON;
-	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
-					    skb->len, DMA_TO_DEVICE);
+
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	__le16 fc = hdr->frame_control;
 	__le32 *pdesc = (__le32 *)pdesc8;
 
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
+
 	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		rtl_dbg(rtlpriv, COMP_SEND, DBG_TRACE,
 			"DMA mapping error\n");
-- 
2.17.1

