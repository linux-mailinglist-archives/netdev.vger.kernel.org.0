Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F4D292145
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 04:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731203AbgJSCy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 22:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728538AbgJSCy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 22:54:29 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382EEC061755;
        Sun, 18 Oct 2020 19:54:29 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gm14so4526164pjb.2;
        Sun, 18 Oct 2020 19:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rMa38J/rDkdAxwNf9rq6wQwYbSWtRvfUhMh1mG4UHRM=;
        b=LWRKDyuansl7M2rmAC+ZFUiy7fcD1e9ApOzcSn29Uqoh3nepomEzLtI3cGa4Wn1oOa
         zPZFnpMhXI9C0R2FKzy/3Va3/If/Gojo4S+2RreUvJyrTnpRR5IhGPVZ6ENdnF/2cIb2
         KNp35Mjr4Wvml5AYvhwJyvS3NEAQlf7I6hcmTxi6AEOosbY58ZVAnFCp0U3WmCOV8d3+
         b+BLr4dtgb/wdSHYTES6mwXdmka+20v/iefPVkQ0RI31GW6SftppPfY63Mje95fyREMX
         Qbo7/lvR196xn573UOSWRijQ6p/JoT49m64RgDNv2fcyo7Qvv7Man5YdGnEcM+9L/ZsU
         LxZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rMa38J/rDkdAxwNf9rq6wQwYbSWtRvfUhMh1mG4UHRM=;
        b=FJHvR7Lr3UP0dkm0bA7yPxGHflASkSUN53C5tE09ZAOGf1ZF/+nyGh4FaNYjkdsL+I
         po442ItVQILE9KBKS31DlM817Lpe+kmikuVCdv3wbJqmGH8MliOm3Zp6UI1l24wIAuu5
         26v7NX1ezD5Po+k3XW/fmEhH/B+9hG3de/XEPZz0jclTNzwSyIydBe6/rWdR0bvXmt7V
         bA1HimDhGht2eQB63kWIXxFZZIFfkFhdyj9YOPdUnZ+tYkEEQUdKLFX0kY8danE1SXiR
         xpcSx9ZIvO9JFsbbL/mnlxxIuRu8A5aRUMk52ZCqnPWEVqru8UArXs3vAMBvOyzfP3f3
         Ldow==
X-Gm-Message-State: AOAM530ZuaaO67zWfKOYNklPVrH1Waz0dXZ6KWFRilhfkHomv1kVdF8O
        //KC2PQNg8QKuKUXaOWLH9E=
X-Google-Smtp-Source: ABdhPJwg4+/vETt9rhMUCFGb+vyTJmyspNuNk3VpyvR5I8/AZ5+PViHF+kkcQYFvG3KKp2x8Ffntfw==
X-Received: by 2002:a17:902:8698:b029:d3:b362:7342 with SMTP id g24-20020a1709028698b02900d3b3627342mr15070350plo.50.1603076068663;
        Sun, 18 Oct 2020 19:54:28 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([166.111.139.137])
        by smtp.gmail.com with ESMTPSA id c17sm10275529pfj.220.2020.10.18.19.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 19:54:27 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        vaibhavgupta40@gmail.com, christophe.jaillet@wanadoo.fr
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] rtl8180: avoid accessing the data mapped to streaming DMA
Date:   Mon, 19 Oct 2020 10:54:20 +0800
Message-Id: <20201019025420.3789-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rtl8180_tx(), skb->data is mapped to streaming DMA on line 476:
  mapping = dma_map_single(..., skb->data, ...);

On line 459, skb->data is assigned to hdr after cast:
  struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;

Then hdr->seq_ctrl is accessed on lines 540 and 541:
  hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
  hdr->seq_ctrl |= cpu_to_le16(priv->seqno);

These DMA accesses may cause data inconsistency between CPU and hardwre.

To fix this problem, hdr->seq_ctrl is accessed before the DMA mapping.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index 2477e18c7cae..cc73014aa5f3 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -473,6 +473,13 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 	prio = skb_get_queue_mapping(skb);
 	ring = &priv->tx_ring[prio];
 
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+			priv->seqno += 0x10;
+		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
+	}
+
 	mapping = dma_map_single(&priv->pdev->dev, skb->data, skb->len,
 				 DMA_TO_DEVICE);
 
@@ -534,13 +541,6 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-			priv->seqno += 0x10;
-		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
-	}
-
 	idx = (ring->idx + skb_queue_len(&ring->queue)) % ring->entries;
 	entry = &ring->desc[idx];
 
-- 
2.17.1

