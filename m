Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54C32B89CB
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgKSBwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgKSBwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:52:02 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F608C0613D4;
        Wed, 18 Nov 2020 17:52:01 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w6so2931723pfu.1;
        Wed, 18 Nov 2020 17:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Lrkjv0IBlzMwL2dF9c7iw3uUdxBLddCoE9twLMsxPXo=;
        b=ajV/Z+fhiyNanIOxETfhfJLaJYHu+1oGRqUi3qlpaKI5gFOLbbEs72B5mWjPHClM0k
         OxRw427HObo7ge9kr1+jvq0gJQtADcoDfoadEalIpdqXTKU9dN7XCkWzPPQ74KrHjfq4
         loy/w3NvIUDCctLNfJ8WNmSVyi37D+9VUZBbUMg9kEp6bKt9m4HxiwFWE3oA2aW8xe3e
         WITAKDZAj1qsHC6N62QZWBOZzXAhR/gtkdT2AZM5CDlVlqbD2EzBgt2NDGpFi8GqnmEy
         LdCCAlSVTAvJHqiHbuMYr9ajlgL0zLMRscoVdBmeRDsWTPFSr1j2cTT85J3mSboDB5wu
         nAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Lrkjv0IBlzMwL2dF9c7iw3uUdxBLddCoE9twLMsxPXo=;
        b=R4xpkYnsjsO0m7hY0TW7zJnjyI9itC8UDrLbbCyG/K3WG8Orm91Z4/Sowyg3fb8Izg
         iFdhgbZ0Aaukqv711g7FdGC4ijLfpWgwlFhogSHpMeJcWHOivwDiKKEBCS4/t9ztEhVS
         x5HlIE8RdE1+h8SWDrczEvONv3ryN2P80p99DqiNns/h6rQwYRE6oTEyqqHyJvVnhKvV
         71Aph4u8YIQwETDOMh4wIM4Y8+BwdsbJeZm8MvegIP0P09PdJduc39L6OUlGxLDCzuxS
         7OYOhR60aHN6VJBCszVyjQfjtsQUigvw92wNHZOG6t1LeKKamVCPx9U/rpwMQ5ryjhib
         novw==
X-Gm-Message-State: AOAM531EIW0oB1LR2oPS5tSEHxClWxSq4pU/N+Ey8RpsX+eoeZy9nZdY
        nryvVRCqU5KN/PsJKqtM9LA=
X-Google-Smtp-Source: ABdhPJxO8eA5HqG71Zp8OEePb2qToBb3iQ+7QEwSvpJmyRzGwheiB6FSeLPerEjOpyAvQ3/G4hF74g==
X-Received: by 2002:a05:6a00:1684:b029:18b:665e:5211 with SMTP id k4-20020a056a001684b029018b665e5211mr6947014pfc.20.1605750720578;
        Wed, 18 Nov 2020 17:52:00 -0800 (PST)
Received: from localhost.localdomain ([45.56.153.149])
        by smtp.gmail.com with ESMTPSA id b1sm9799308pgg.74.2020.11.18.17.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 17:51:59 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2 2/4 resend] rtlwifi: rtl8192ce: avoid accessing the data mapped to streaming DMA
Date:   Thu, 19 Nov 2020 09:51:51 +0800
Message-Id: <20201119015151.12110-1-baijiaju1990@gmail.com>
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
v2:
* Use "rtlwifi" as subject prefix and have all rtlwifi patches in the
  same pathset.
  Thank Ping and Larry for good advice.

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

