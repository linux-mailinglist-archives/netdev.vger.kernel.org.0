Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734A12B89CF
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgKSBwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgKSBwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:52:13 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8681CC0617A7;
        Wed, 18 Nov 2020 17:52:13 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id m9so2762939pgb.4;
        Wed, 18 Nov 2020 17:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9025Wc1+t1+Asl4+HE2JiiCcXuZsf9kAEp5Y/mjiQ7I=;
        b=at1kCgQJTObwy+2jmdlGcjwCXnikQgSV4v9IToVIQLPzLOrm5dSm8lc9gDsISjJpoy
         kq4DbGbvQ0xnuRXX6nyMsAGyPuEpuUyewplrqz1fSuPaKofSELvTLTw6E+g1SjQbXPac
         CzOxnVHGN/IUkgzigWpAVtQ2SQaPNHzsudK009LbTx9t+BaoD3E2FR3GvjLjqbRLGUDr
         EF91MyNDe5Te8ikU5YxBWPft5RiojerqB934+BjIuPUNh2L2I1kfIlwJUN+xSs3bS+Ze
         R9lqmbFLPCGqHVr7uSpUzku4tRxQOkPIMwdCZUnD194tCquZ9l5UwwaR+BU2nJErxn1J
         E1YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9025Wc1+t1+Asl4+HE2JiiCcXuZsf9kAEp5Y/mjiQ7I=;
        b=D43soLDih5auf9lmFmGJXMtsHZkiB2+oqDAuDonFa8meLnz4siP/HBvFglra16zZgZ
         e108XCol5Uu2osq/eW5SUtcDt+NY+bEy8CYoWx5rWmWSJ4o2L2uTawYv6DwlG9NE4LL0
         CdCDhWIjjUegkfBP5KhYjtvw2euEsOZbpVETiI8P0rmjJ7x0ceD+XQjb2Jc7vjxBDE5p
         RSDhbDVgbuZ6d0bb16KfjyX9vez5YegBLLv1dbxnFd0DkJOz9KA04qz95usG8PBz5ssZ
         es0Ei8Lrh4jqHphCtnNmhaaDf6tGtfaZzrTR4PCIRVpiPV2UJquGqRk/qdct8oD7AXZ6
         sAPA==
X-Gm-Message-State: AOAM530oVuMTGBctJf5AKGWRgweSY1IcFJwHIbSfp1UUWSRqpVYbSX+a
        M9p6T+DwUObof+I9mn1wYYw=
X-Google-Smtp-Source: ABdhPJzICtfYjpI2GQXdBLTyYUvqqtGVGQDEQFhVQmIYp6gzD2kN/3XYB3VuQyBHlPbYZo6seRxoXg==
X-Received: by 2002:a17:90a:fa04:: with SMTP id cm4mr1815855pjb.24.1605750733194;
        Wed, 18 Nov 2020 17:52:13 -0800 (PST)
Received: from localhost.localdomain ([45.56.153.149])
        by smtp.gmail.com with ESMTPSA id o62sm4038168pjo.7.2020.11.18.17.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 17:52:12 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2 3/4 resend] rtlwifi: rtl8192de: avoid accessing the data mapped to streaming DMA
Date:   Thu, 19 Nov 2020 09:52:05 +0800
Message-Id: <20201119015205.12162-1-baijiaju1990@gmail.com>
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
v2:
* Use "rtlwifi" as subject prefix and have all rtlwifi patches in the
  same pathset.
  Thank Ping and Larry for good advice.

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

