Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C32A38E738
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 15:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhEXNQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 09:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbhEXNQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 09:16:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984B0C06138E
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:49 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w12so24140994edx.1
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xpBw2l1wZ2xtqrU1NJ1TQLOODlywWltqb+XI3hZmzDg=;
        b=gpTdnHCobebyqDgFXviNiVkZWejrlK8tPFnrbrkeSFnVKDOw6btLNUWjIr4zjWusyC
         Htr3O+va6i4wLNXlsBZakWkrZoY8udXUOEIqN6dYJIKFP//DkQMhkBjOECyiDwZ51OP8
         mN+eXKQLERNR8g3/Sw7WL4izfacD2goq0dAoFh0waZ+9rqJNXEj0w1MRLaW7cNbR7OWc
         8YZOOyk3OqQzkaXyy8K5xbsJPECLErcCd9n936Y0hwD2DT9ez4WsfINYoH7WVXNZmi8F
         SaADg7ayJ+2zTEM+DbOeVc9D8Kt5YwiMJ6aG54qcsJ93ET/hJSyDEwQKKn7RlcUjxdMl
         QIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xpBw2l1wZ2xtqrU1NJ1TQLOODlywWltqb+XI3hZmzDg=;
        b=WRwvwPm9f2eWwxqp4OLiJtK7iGsyRYbv+UWRyLaAzMGAtgRn1jihkTtoSMGAAvXpPG
         NjZG7Vly2ACz8YbAv8nPY7EK1UcoF/Y9aQDlz9EogqmvVcegGjf1qHNzrbQnBpuDNWwN
         F06P/aH0oziXP1vIVXKyyGBHpCSLibzt8kb4HuADtwG7N0PooPxuSTk35X6QRZHxmK80
         YJZprxmjqDLngl9hfNkHA/EPmNNwy2TrH7HvvLXOMUvISw8N8ugosEy6GvxDQodxGPl5
         CPOFHB7+wEoeVOURxPs6QrnklIw3et4dLqkmycC0IJt/o3NS/P+tEYg1PxbMzMWTcTye
         vHow==
X-Gm-Message-State: AOAM531PnRLPacF05ZE/Z3Z4gebnSzbladyVtiLhWGmV1Nw0wYs8t1D8
        5h7Av0kGsxKnoLehGRPQfDY=
X-Google-Smtp-Source: ABdhPJz3nK4DcQnm1jh0FnrVeM9L5Stawv3ubTQrEdj8MTAotUHctOT7HDvtkwOjT9Am564PoBYybg==
X-Received: by 2002:aa7:c24d:: with SMTP id y13mr25426444edo.155.1621862088177;
        Mon, 24 May 2021 06:14:48 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm8009139ejz.24.2021.05.24.06.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:14:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 7/9] net: dsa: sja1105: use sja1105_xfer_u32 for the reset procedure
Date:   Mon, 24 May 2021 16:14:19 +0300
Message-Id: <20210524131421.1030789-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524131421.1030789-1-olteanv@gmail.com>
References: <20210524131421.1030789-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Using sja1105_xfer_buf results in a higher overhead and is harder to
read.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_spi.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index c08aa6fbd85d..79ba86096a4b 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -7,8 +7,6 @@
 #include <linux/packing.h>
 #include "sja1105.h"
 
-#define SJA1105_SIZE_RESET_CMD		4
-
 struct sja1105_chunk {
 	u8	*buf;
 	size_t	len;
@@ -179,28 +177,20 @@ static int sja1105et_reset_cmd(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
 	const struct sja1105_regs *regs = priv->info->regs;
-	u8 packed_buf[SJA1105_SIZE_RESET_CMD] = {0};
-	const int size = SJA1105_SIZE_RESET_CMD;
-	u64 cold_rst = 1;
-
-	sja1105_pack(packed_buf, &cold_rst, 3, 3, size);
+	u32 cold_reset = BIT(3);
 
-	return sja1105_xfer_buf(priv, SPI_WRITE, regs->rgu, packed_buf,
-				SJA1105_SIZE_RESET_CMD);
+	/* Cold reset */
+	return sja1105_xfer_u32(priv, SPI_WRITE, regs->rgu, &cold_reset, NULL);
 }
 
 static int sja1105pqrs_reset_cmd(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
 	const struct sja1105_regs *regs = priv->info->regs;
-	u8 packed_buf[SJA1105_SIZE_RESET_CMD] = {0};
-	const int size = SJA1105_SIZE_RESET_CMD;
-	u64 cold_rst = 1;
-
-	sja1105_pack(packed_buf, &cold_rst, 2, 2, size);
+	u32 cold_reset = BIT(2);
 
-	return sja1105_xfer_buf(priv, SPI_WRITE, regs->rgu, packed_buf,
-				SJA1105_SIZE_RESET_CMD);
+	/* Cold reset */
+	return sja1105_xfer_u32(priv, SPI_WRITE, regs->rgu, &cold_reset, NULL);
 }
 
 int sja1105_inhibit_tx(const struct sja1105_private *priv,
-- 
2.25.1

