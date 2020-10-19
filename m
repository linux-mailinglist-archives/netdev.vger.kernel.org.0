Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E19292163
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 05:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbgJSDKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 23:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731344AbgJSDKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 23:10:03 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17580C061755;
        Sun, 18 Oct 2020 20:10:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 144so5158060pfb.4;
        Sun, 18 Oct 2020 20:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+XVQiLhPjTZQE7BJhiPhjmEEz4RW+ut2EJwMRL1LH18=;
        b=ivzxwItr1V0tMdevDRrDJxFaJ0h4GBlAQjOS7Tleht1F+SPg0L0ZmyN9gygf/HRL9A
         UsIgI/d8St19CFdYfqWOcHlp95B+GBjdgE+P+V2F/JoFNud7wHjtKLpvAnlIR90lqW+U
         XCFZw7K4w+gbb04VuuLFXeb/yMzQDAOmgE2XkGSCKvDVn4fgT1YfGznOW9LcAZ0pXVt1
         53d1t5ZSfbvxVBFET4OoE2AOBdg9YL/mUTioN0o0FLpQfsIZqlwPW2r/dIo5tOnfn1W5
         x5wwmM5Glsco8lDt8tx2kcmrfoPVaGno+aQ6C4C+5/UERoIz5zCRmID+TJHclnsRDiMG
         jOzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+XVQiLhPjTZQE7BJhiPhjmEEz4RW+ut2EJwMRL1LH18=;
        b=t1f4FgmsZh+r9uKL+DPxIdfkhrAFlqkmrI34fvjqUyDEdWQ+mEHsVIX0FGLFXLf4Xl
         UvgSDESuMqHLasJZjz+xAzi648a/vkrvKGQo7JE/ws0eMAKQJS0WwJiVO6SMeGRez+Br
         6eb4w4FzZQJCnAphV2QiY6vQ4fJaj2PcSMQ7hipxj0WHdy+CEIFUtulf+BCYNpldC8jV
         dzD+5DH40ZygFpFPDsiPST0O+En3aSCWQI4YpO2ZMm3of62OadAznvBKZoUMGW87gd81
         ++q2ta10meoJ237blMMFTEzVyzpjXycsp4dh7YZQu8NUbIDcsGLQ2FX57CS1YTxMpRhs
         gkaQ==
X-Gm-Message-State: AOAM532C4lWdOWYRqycjol5rPHILZFsRcG+ZyEizL5FUPsLlZ6eUpt6S
        3rSZPJ+Z/dkSN3LS74Sy9LA=
X-Google-Smtp-Source: ABdhPJwZT3nkD/m1wrsgA0SYjoDx3q72J6JaWfNUMpv7VDRxu23FQ5fSYPf/HCmITnpAwIcFKa+2KQ==
X-Received: by 2002:a62:1d57:0:b029:152:47a7:e04b with SMTP id d84-20020a621d570000b029015247a7e04bmr15073297pfd.48.1603077002656;
        Sun, 18 Oct 2020 20:10:02 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([166.111.139.137])
        by smtp.gmail.com with ESMTPSA id ch21sm9863395pjb.24.2020.10.18.20.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 20:10:02 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net,
        straube.linux@gmail.com, christophe.jaillet@wanadoo.fr
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] rtl8192de: avoid accessing the data mapped to streaming DMA
Date:   Mon, 19 Oct 2020 11:09:52 +0800
Message-Id: <20201019030952.4851-1-baijiaju1990@gmail.com>
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

