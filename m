Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F83292191
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 06:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727713AbgJSECE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 00:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgJSECE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 00:02:04 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32953C061755;
        Sun, 18 Oct 2020 21:02:04 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id e7so5202305pfn.12;
        Sun, 18 Oct 2020 21:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=t5eReXO4wqmdOiCBF4R3AZcbfxasgeFRgSN87jtfTOA=;
        b=YyEN54Pkrupuqjn9CbeFnnwes1U/Mn6o6wmsKwP185/yOGqAfJhYtkg9B+z7AUsyOp
         RJhD9kYdaA20LVoBfFs+Ph3F8iKmf0JpCsHJEYpnhQG1oCW0BpoQXiqJ6tjVdblLhPRv
         aaZYSix85W/sdmkEepbRWLkaMLVQpxuScCBGSVvNKPjspj8dMRXleyLwbmdM930sGGVb
         IUnRo0LaMd4HYCEYhP1wHRz7AH4/inlITmMo5LeuW/ctq44w8XKgyIAYzhPmsFHpXg08
         hJFhERNTJoEcIUiwMWWZpDXsmkvmb+0494dgikhQgSQWlhrvOa20KCWfXt4TZXUs2mvp
         EWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=t5eReXO4wqmdOiCBF4R3AZcbfxasgeFRgSN87jtfTOA=;
        b=qLAgCuPpWZ3YUj1mI6OTUCSRiEb9RvPDc6l+MMhqdEcDB2DqyUaKUatlO2qHKwV6cd
         vXEmTojqMTahi4s+8bAl+A7gaFVlBqTNE0UqWZFm2cHStkkcMg2hkdCarM9DkRWUFVyf
         ALJfR5ngd0MRzosf03tCEOHS+EoECQsHw5atNnesJlMrH5fRw4CoJ+FYfB4ZrnLKGZFC
         OO0+RnhNgkBqgDEe0tCHkrBqldqyCyjtvGDh4KzDgrRtjCGAKnSNks7Mdi+xU+JB4Owi
         ctJY6G672zf6v77uehqBB3r0Q+rjNCVI8KmXxM/m1JcdYiuSscZM8jA+kaGPJKhiAiN1
         GggA==
X-Gm-Message-State: AOAM533mvBBMA/FtrYjNwZ4YBvt6ZMe38aJrkL5njXUxWp1Id7lH26FK
        mZrELy7+turckmv1ZrJgLTk=
X-Google-Smtp-Source: ABdhPJyLFv/LumZgFNS+GjxPxAL9mhR+bbYTIhpaEfPmkIeokoUVjXAIeResNXwq22ZD6hsk9yjq7w==
X-Received: by 2002:a63:2145:: with SMTP id s5mr11947483pgm.288.1603080123790;
        Sun, 18 Oct 2020 21:02:03 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([166.111.139.137])
        by smtp.gmail.com with ESMTPSA id y8sm10096359pfg.104.2020.10.18.21.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 21:02:03 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net,
        christophe.jaillet@wanadoo.fr, zhengbin13@huawei.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] rtl8188ee: avoid accessing the data mapped to streaming DMA
Date:   Mon, 19 Oct 2020 12:01:55 +0800
Message-Id: <20201019040155.6961-1-baijiaju1990@gmail.com>
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

