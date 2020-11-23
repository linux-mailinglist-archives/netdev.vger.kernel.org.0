Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A7D2C1459
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgKWTPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728930AbgKWTPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 14:15:33 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75F5C0613CF;
        Mon, 23 Nov 2020 11:15:33 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id u4so18036857qkk.10;
        Mon, 23 Nov 2020 11:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lsk3l50IUlnXuysK/qr0G1Jf7d6JfVUjA/eYi8O2geA=;
        b=ZjKCDWGIRLgKDvKwoAQ/Tdf9QWbi/RzXSaxEcWje+l/O3zHCmHqGQzwBMTv9KJ7SN0
         ai/WCMj5UgddZv0EKbGYTkv/nK1Mm45jOxZAKrlDkv0bdkd2EXiwxL6Cvba0Bsh9JEAZ
         Yidfd4HZKWnJYPps6+U7hmy5r29ofNIQVpqNsrnu7emVfw7++PxGUQsP57St7qLdTBYd
         OiS1qNRWLQRnN8dTL2yzYrPT8Lar9twVF1paL347DEIm3DVX2JT/UMuf600jgCfDsFrY
         NiHFk0tfiaXFNNZiyCcLD3mxNnMJ0LQI5R0TGePgCjPTb8Xwmew1eroPhr9FwIwWyrV1
         Zc4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lsk3l50IUlnXuysK/qr0G1Jf7d6JfVUjA/eYi8O2geA=;
        b=esE0CNY1R9RwXY7ANIKv62/mF+PDcNk1EbapbUJFn0p9SmGr/vkrtT1gBUI1+tHEXk
         HCjUNzbGIcXT15+xOm3U6U+gB2cMXktAba7XdyYyYZatpmCplnj8/WE5Euxe9yz9Neen
         ObN3u3ZZL5RKtlkHDuXOSdtOcI4xbQ+ToHEgupvSdxAubVPclj66EqlFJ+9QepjmD4OR
         j1EdtykE4Dv/LJvusnrvcZgxQnc16yMWW8/C9gYQ1zRaS6nGIJagaM5I9y1nCvGP4rmu
         0SeYI6Ud0STec05Am+q7+7eMHvPXg7ZT4OmQDPnrD6Lq2lt78M+iF5asQ/JrPo2u8a1Z
         hOGQ==
X-Gm-Message-State: AOAM530vt0WIrYSbCP7rsLlWZpMRnRq+eHCoCa/By1NB6SLUy9ZVKgD3
        8AKdM4JW9212ceIuCo+rAFI=
X-Google-Smtp-Source: ABdhPJyKiuEn0gESPmF4riPXg80tuJ6CvB027stRO5inddlu4fNnejf5dC2NY6pPZPd16f9AzQtiBw==
X-Received: by 2002:a37:bac7:: with SMTP id k190mr1009816qkf.464.1606158933051;
        Mon, 23 Nov 2020 11:15:33 -0800 (PST)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id r190sm10116348qkf.101.2020.11.23.11.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 11:15:32 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 1/2] lan743x: clean up software_isr function
Date:   Mon, 23 Nov 2020 14:15:28 -0500
Message-Id: <20201123191529.14908-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

For no apparent reason, this function reads the INT_STS register, and
checks if the software interrupt bit is set. These things have already
been carried out by this function's only caller.

Clean up by removing the redundant code.

Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git # f9e425e99b07

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: Jakub Kicinski <kuba@kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 87b6c59a1e03..bdc80098c240 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -140,18 +140,13 @@ static int lan743x_csr_init(struct lan743x_adapter *adapter)
 	return result;
 }
 
-static void lan743x_intr_software_isr(void *context)
+static void lan743x_intr_software_isr(struct lan743x_adapter *adapter)
 {
-	struct lan743x_adapter *adapter = context;
 	struct lan743x_intr *intr = &adapter->intr;
-	u32 int_sts;
 
-	int_sts = lan743x_csr_read(adapter, INT_STS);
-	if (int_sts & INT_BIT_SW_GP_) {
-		/* disable the interrupt to prevent repeated re-triggering */
-		lan743x_csr_write(adapter, INT_EN_CLR, INT_BIT_SW_GP_);
-		intr->software_isr_flag = 1;
-	}
+	/* disable the interrupt to prevent repeated re-triggering */
+	lan743x_csr_write(adapter, INT_EN_CLR, INT_BIT_SW_GP_);
+	intr->software_isr_flag = 1;
 }
 
 static void lan743x_tx_isr(void *context, u32 int_sts, u32 flags)
-- 
2.17.1

