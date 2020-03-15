Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DDC185DC0
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 16:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgCOPDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 11:03:17 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35657 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728223AbgCOPDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 11:03:17 -0400
Received: by mail-pj1-f67.google.com with SMTP id mq3so7021217pjb.0;
        Sun, 15 Mar 2020 08:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Akk5s7VpQ8EMc3QKWawmMJ2LR47WbqMiE93Yj41PNp4=;
        b=EXVKyar0oLMU5KHLP0/MgDHqO3OiUnDESNs5UJzJ9S7k4L+/ZVkySEuCx/dQsAJgjn
         q55m/TgfP+pwRhJyzcVffNuDndrcKrBLJkDgIRjck9pG3QXOAiuPj1CLQJB/t4YABVtf
         Mdp06gQ2T9rjOyUBBPJiY3vW+kKqe5xGnZI9/RYwaozLNgskqApBbDCe3ur3lkxGDCQJ
         8xyK0OQhgRK+hB4pcClarUopyNQ3SVqU1x6Yl2Y/iYmbUI7XlD8j56JpwBgYZit8F833
         xMFCP3mi2p1jXS+LV9IWS8pEQcfFSgj5eVHp+4iZJTfPGqd9gfD4PMGCwe57khOZFYeU
         GADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Akk5s7VpQ8EMc3QKWawmMJ2LR47WbqMiE93Yj41PNp4=;
        b=oED/ZzLd7qS3cIoK6YgFq1D4DjyFQE1RlG8ufVUEZSz6FrEQLQyAE1WFDHlgY97B4i
         N5XWqpFuUm8hGTby9/mcDHBZe6Nz6ODeVPdxWrCj4HVZf//yk0q1vmdx1h4RTpe13lzO
         IP0beWh+yonddJQ2TyUR88gp+sExfwabIikaALJoospQY4zJ2mtKoA+BSrAsdoskFT5z
         U5+Sog927MI5jRYmnu2derHtlkpJp+1RkrQqSdAFAahw6dmOx5sfiH6P+wfcZq3a7hkh
         WeAl8ISqtEy12lBkAx7nJ6Jq4j+uVZ5+kmaBKSq3rS+SqfAFxoLY4E9pRbq2qzcYKmJA
         JAIQ==
X-Gm-Message-State: ANhLgQ2EqMII+2RifyIYXvMTom7CYRUcvq3wm5iT5X9OEkCW7B6MpC57
        p1k+/Dk4r5cLvIEnCX0s3dBvY91T
X-Google-Smtp-Source: ADFU+vuRkV82PozUwcHEZyF4En2HI40Sx1yE+v/Qbqok6rp0jWAkSiIAPTyMe9knTgb7aSiGk0Ofbw==
X-Received: by 2002:a17:90a:d80b:: with SMTP id a11mr20775016pjv.21.1584284596078;
        Sun, 15 Mar 2020 08:03:16 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id j21sm16849584pji.13.2020.03.15.08.03.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 15 Mar 2020 08:03:15 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v2 2/2] net: stmmac: use readl_poll_timeout() function in dwmac4_dma_reset()
Date:   Sun, 15 Mar 2020 23:03:01 +0800
Message-Id: <20200315150301.32129-3-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200315150301.32129-1-zhengdejin5@gmail.com>
References: <20200315150301.32129-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dwmac4_dma_reset() function use an open coded of readl_poll_timeout().
Replace the open coded handling with the proper function.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v1 -> v2:
	- no changed.

 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index 9becca280074..af68ef952cd6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/delay.h>
 #include "common.h"
 #include "dwmac4_dma.h"
@@ -14,19 +15,16 @@
 int dwmac4_dma_reset(void __iomem *ioaddr)
 {
 	u32 value = readl(ioaddr + DMA_BUS_MODE);
-	int limit;
+	int err;
 
 	/* DMA SW reset */
 	value |= DMA_BUS_MODE_SFT_RESET;
 	writel(value, ioaddr + DMA_BUS_MODE);
-	limit = 10;
-	while (limit--) {
-		if (!(readl(ioaddr + DMA_BUS_MODE) & DMA_BUS_MODE_SFT_RESET))
-			break;
-		mdelay(10);
-	}
 
-	if (limit < 0)
+	err = readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
+				 !(value & DMA_BUS_MODE_SFT_RESET),
+				 10000, 100000);
+	if (err)
 		return -EBUSY;
 
 	return 0;
-- 
2.25.0

