Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 231F715460B
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 15:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgBFOYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 09:24:41 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39848 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBFOYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 09:24:41 -0500
Received: by mail-pf1-f196.google.com with SMTP id 84so3205749pfy.6;
        Thu, 06 Feb 2020 06:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wQjSqjPnCsGymzsifLNmUAkPPkBxHXDH/G5MVJ/Zpj4=;
        b=kSGiazQopCo0sSM9TFubaUcSJ9VVWKx13crgeyVQCTvzSjYif/Wb8scZXxOpvzP3R8
         5lMbn0lWbpXhTYcfPDnCMO1jWlHa1cBXW0/UCYvX51l+0XuXRq3A2hv8Z+zLQa6CRoPf
         ElPVZGAAZyez6DheqHu+MOderzBYHe6YQ1utfO/z+J3KZKUK53ogL8WEnBScEOoCzyNE
         dTPoTD/etB51NoXMilmYL09pmcWdqOgUzOhFveK0FQeTwsWo7grckVxpMc9xc8UIk302
         ITl4W1Jy+9/xq9kT7tqRM/KZJ7cpr5D5gOOqNMJTUiW5tGXSUYKX79iNjHIj8t7f5ewX
         mkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wQjSqjPnCsGymzsifLNmUAkPPkBxHXDH/G5MVJ/Zpj4=;
        b=LuU1qA3UppmcP119z4kUUOZpjgM+AaoFEzftrdAate0jeiUCFSSRWMA7h+8ytnhf+9
         ViG3QNqyAMLsC1Tyn3s4uZZOsgsZsCtO45nklhziKwJFlGz5or3g+mHwsF/jPng27SRx
         0FFJb5wfaWJbJCRB6Jb0xTnukPuI/m/Nm6iuP5t4vhgWHlLwMrnYox1Xr7fkJTOFVeT8
         4UjejUWDs4N0LE1EsZnQZfczpoNwSnsFeuzbein7NnRKpaK4cD/87tHMtKLHl8gdUgDG
         78ELMuEWNXaP4jhgBiwDf5ucOv6aZT+37Ea/jrHshvmYrFCsLEQRKtlxG1HcsPrWGRg9
         jomA==
X-Gm-Message-State: APjAAAWSW+2BlfKsw7xqJjEYX/OOGDlUZsVLbRZ5/U+WKoJfMGAViW+8
        7SCuOjNHtgOYWGgwrk4DDcY=
X-Google-Smtp-Source: APXvYqxIpANX4/2P10i3M0tJgchopDXvDHoETQqvb5iNVXRpjk0EH55o246IT+xkuYsVLXZtkB+X+A==
X-Received: by 2002:a63:5157:: with SMTP id r23mr3723390pgl.81.1580999080676;
        Thu, 06 Feb 2020 06:24:40 -0800 (PST)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id m101sm3416844pje.13.2020.02.06.06.24.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Feb 2020 06:24:40 -0800 (PST)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org
Cc:     linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH 2/2] net: stmmac: use readl_poll_timeout() function in dwmac4_dma_reset()
Date:   Thu,  6 Feb 2020 22:24:04 +0800
Message-Id: <20200206142404.24980-3-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200206142404.24980-1-zhengdejin5@gmail.com>
References: <20200206142404.24980-1-zhengdejin5@gmail.com>
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
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index f2a29a90e085..6b911e360e27 100644
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

