Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C7C285CEE
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgJGKd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgJGKd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:33:29 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF8AC061755;
        Wed,  7 Oct 2020 03:33:27 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id u3so827688pjr.3;
        Wed, 07 Oct 2020 03:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yopkVMiRl0JzTsUJbYFwoQcRM3hdbNjVcOO4o06jw/c=;
        b=lH6h7BbOyF/zl8kPRNyqwm2e3r/7iU3ffvEzAWfVGmwnB8OWm7QQjHrXAPsXpiuk2t
         XKzeC4ccawxF5faQ81tsXUxSrOdEBMsBDE5WzlIZmOn9XDf3TjjCtJc8xduzUt6MlY0q
         x8y6LgMY6QmQxpgGM+GKzPz7yiU70OJEzAovEi+SYhhKhfRTW1/ckII/ULExNZriurmU
         kHkleH1s4/Gh0p9FRN6r0O+hVnRJEVNZvAnX+9t2GeVht24K40LBN4KslS+KwYcM9kXw
         dVYoSXbbLNvi/UAMSwEGQEyHQsbRp371j0REnhKVAMSE4gH6ZQlpg1KfCDz9k1Pj1Wvl
         xDeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yopkVMiRl0JzTsUJbYFwoQcRM3hdbNjVcOO4o06jw/c=;
        b=jBNkc80xDuvECawwKq09QEe6IBe2FZqAfhgdNrdwkz3Bc+UP/4exscZBh1DQSIIfJJ
         JrMrc4/dTBoYNJbubNTy6YV+/9Cf5TpQrQOr1RmTA14ZgmFsBmLaEbLtJGtyNTjz0xmL
         a4J/bfGQvMbNxkNjQIu36+QcoV4Hw+LbsZv+dA4z3w6eyWhHX1aI86lkXBG0kdwL39zR
         mzVQwTVvlRiC2bPi27GXLR35rZoaj/7VOmNzCz9rEbw6mdURAuQnwJPl3VY5HtxxTiU/
         vutvIm1Sg88ZCN6csRK23G3kG/eTb3hnNs85MVzJfW82fba488C3Ef0AVeGbRpTRg8zA
         S6jg==
X-Gm-Message-State: AOAM531/SlSnExl9O1rK4xacpQreARhgFQMncIz18RhhkiNbcqSG1bqc
        IktDGhqKD11lxKmShFDohp0=
X-Google-Smtp-Source: ABdhPJwVlGCYBw7JNMhbASV+Ji+WfANWd8GPRE+7SevSgBbqnD2OiOnPlxxBmZgCvkEyxcb+Z/nc7g==
X-Received: by 2002:a17:90b:1b0f:: with SMTP id nu15mr2273222pjb.231.1602066807230;
        Wed, 07 Oct 2020 03:33:27 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.22])
        by smtp.gmail.com with ESMTPSA id v129sm2705327pfc.76.2020.10.07.03.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:33:26 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, nbd@nbd.name, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, kuba@kernel.org, matthias.bgg@gmail.com,
        ath11k@lists.infradead.org, linux-mediatek@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 2/3] wireless: mt7601u: convert tasklets to use new tasklet_setup() API
Date:   Wed,  7 Oct 2020 16:03:08 +0530
Message-Id: <20201007103309.363737-3-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201007103309.363737-1-allen.lkml@gmail.com>
References: <20201007103309.363737-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/wireless/mediatek/mt7601u/dma.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index 09f931d45..5f99054f5 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -212,9 +212,9 @@ static void mt7601u_complete_rx(struct urb *urb)
 	spin_unlock_irqrestore(&dev->rx_lock, flags);
 }
 
-static void mt7601u_rx_tasklet(unsigned long data)
+static void mt7601u_rx_tasklet(struct tasklet_struct *t)
 {
-	struct mt7601u_dev *dev = (struct mt7601u_dev *) data;
+	struct mt7601u_dev *dev = from_tasklet(dev, t, rx_tasklet);
 	struct mt7601u_dma_buf_rx *e;
 
 	while ((e = mt7601u_rx_get_pending_entry(dev))) {
@@ -266,9 +266,9 @@ static void mt7601u_complete_tx(struct urb *urb)
 	spin_unlock_irqrestore(&dev->tx_lock, flags);
 }
 
-static void mt7601u_tx_tasklet(unsigned long data)
+static void mt7601u_tx_tasklet(struct tasklet_struct *t)
 {
-	struct mt7601u_dev *dev = (struct mt7601u_dev *) data;
+	struct mt7601u_dev *dev = from_tasklet(dev, t, tx_tasklet);
 	struct sk_buff_head skbs;
 	unsigned long flags;
 
@@ -507,8 +507,8 @@ int mt7601u_dma_init(struct mt7601u_dev *dev)
 {
 	int ret = -ENOMEM;
 
-	tasklet_init(&dev->tx_tasklet, mt7601u_tx_tasklet, (unsigned long) dev);
-	tasklet_init(&dev->rx_tasklet, mt7601u_rx_tasklet, (unsigned long) dev);
+	tasklet_setup(&dev->tx_tasklet, mt7601u_tx_tasklet);
+	tasklet_setup(&dev->rx_tasklet, mt7601u_rx_tasklet);
 
 	ret = mt7601u_alloc_tx(dev);
 	if (ret)
-- 
2.25.1

