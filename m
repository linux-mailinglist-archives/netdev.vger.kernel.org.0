Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E40A2B89D3
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgKSBw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbgKSBw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:52:27 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37874C0613D4;
        Wed, 18 Nov 2020 17:52:27 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id s2so2061435plr.9;
        Wed, 18 Nov 2020 17:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=O3ThiUwvLYqwNqLXRXRAUrUNjVW2CgIY+DR5znXz6Ck=;
        b=hiJ1JsBn/XfhJvTqOg5P+dJhfHx+stklBu/B2NHegIqQsB9wnc2pQk/h8lYQ3NIOvW
         vqDpbL1dF+2kaESBd2miRG232EAgJVT/BK8ptTrePs0lONFzRfewbt7f00PxujiLtyOn
         bd2Pf9vSrr0gOfcxO+Em7ut9u1ViFzrw0uD8f9iPqIHAujRTg9Yh0tj4kEosj2u1N8t1
         3pxhHQymoAb6XZd1xtrAsBkr5KkYQZuJZVz8cFSVl/dqLYMwai+jP/hHZ5GtosnwTdpx
         HACeMLml3N4jCBSZ5JDlFBQ63CZgB6io2axKP9tI5XDIeAqx6R808vVdLQ8Pyj1JuN++
         +J4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O3ThiUwvLYqwNqLXRXRAUrUNjVW2CgIY+DR5znXz6Ck=;
        b=MunXofqeX16ntKLI8lsyBd2L/btu3auFAcNpOKCUVqmsnxkKdem+k0L8T8GX7sBxJH
         8uR/U7RFOGVnbE1OV4J6mj6Ghi2hQqDycw9x7wDI4Fvw9L3It22nY/VPtWkc4IH5/q7f
         8ltArNjFBTNh20O6ynhUHQ/A5vFh6QopTfgAjCnswT7dH5id6ZHyrLGP0/BNqQEpzmFG
         tTFNaBrfyqrgNyfITQAwwNM08WLZ26+njSeT7OPH7MyAYzN07nRCuB99dRxaroujR8L2
         2zus+bMd77aT+AWmnbC23L9YKAAiJklpXSdvT8QA9a79x7e3/7wrHh7UxR2XIXp3ngmL
         0QZQ==
X-Gm-Message-State: AOAM533TnfFgdiX4lfYDMWTopjpLuNpvpTS6WWWapBDaemouoRSp0tfk
        CaL5UYQ6U8EdjCw4f0ehoEz9oXDbfyxfrQ==
X-Google-Smtp-Source: ABdhPJywqIvy+2ZVL/7mOsL29r7EzB+mlhB406Ko6cPrwXDRr0gTX3vUKy9dCGxgO3W2gaNBUi1BVw==
X-Received: by 2002:a17:902:9f90:b029:d9:da48:6021 with SMTP id g16-20020a1709029f90b02900d9da486021mr600256plq.81.1605750746645;
        Wed, 18 Nov 2020 17:52:26 -0800 (PST)
Received: from localhost.localdomain ([45.56.153.149])
        by smtp.gmail.com with ESMTPSA id r3sm3976638pjl.23.2020.11.18.17.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 17:52:25 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2 4/4 resend] rtlwifi: rtl8723ae: avoid accessing the data mapped to streaming DMA
Date:   Thu, 19 Nov 2020 09:52:18 +0800
Message-Id: <20201119015218.12220-1-baijiaju1990@gmail.com>
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
v2:
* Use "rtlwifi" as subject prefix and have all rtlwifi patches in the
  same pathset.
  Thank Ping and Larry for good advice.

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

