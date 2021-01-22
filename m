Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF382FFACA
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 04:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbhAVDDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 22:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbhAVDDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 22:03:33 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F50BC061756;
        Thu, 21 Jan 2021 19:02:47 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id a1so2015487qvd.13;
        Thu, 21 Jan 2021 19:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OehH2QKmRJNHAmt3gOc5mz6jP/YImBd8NtE4WLbUWic=;
        b=dDSOhBnvs+xcEGhCJpIO/hGokDo6IikafhOUy3pbnXOIjcYBnj8E3MSho8eqqG7tAg
         n00B6moEXSff0t8/BiAzsmO8xpu5JVIr2d5IoFd+Dq2Efr1j6xSP9tj2Xf14eEptPgJc
         DQ/4AsI7n/FhehiVE6p1F3Iz5MNvH7HE1e1T26lWDiFuXMrDfIe7rLOCmtBhLXSU4b10
         Fa/pFJofaxwnjeh63hcpU8DQEZgZ1cGKnMNH6Q9ysS0bw4QLjll57wUQKawrBfcxmvVz
         MicMCM2CNKrQhqbxQDt9pTyJ+Lw2SDHyiSL+k74iseE+2Wwl2Wul/w9o9d604BFrp0Dc
         2SXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OehH2QKmRJNHAmt3gOc5mz6jP/YImBd8NtE4WLbUWic=;
        b=GnvOc19NewKBHvfVlOaiIVR+bN4LjvB6WrpcWFUj6HVCtOt7GeL7dv4B/9GkEbv6M/
         pF6bFOW1Rnxz9ZQnygLBLgTuZXEy/k65aeiSqrvdQjC94AD47JI5t/RBfKIR+VVgRIVx
         CiW6tfSUyehnHdPxRc5ba4txjsXn5LEo0qXKYUpxky/AGfhB8WffaHjCMrrtU5MCzOQa
         Cb5BXLVDLneajrJEPP6Tuiej68e+xWcVpCbkznsebeaSKtp7qYbTMqBz6yEXQ3eTwRVp
         VNffGQ6lX6ruOAVtjhAoBVMMCyfT3Kc6fL2AkFqhRNorcR1P9maS2IDUocbGrL4yUM+k
         AJlA==
X-Gm-Message-State: AOAM531FT+9WqdJEl/OYILI1J1LudvChSNBlaa2zdtBGpB0f/MZvCzRA
        aV3B5ncwjRpfHTHRH4USETI=
X-Google-Smtp-Source: ABdhPJxXSSJhACYtd7M1tbXNfZ6g3yBXjudqdIZj5JaP+kx404qqQI6uXEDIkNVT1mcee3gq6pmqpQ==
X-Received: by 2002:a0c:fe04:: with SMTP id x4mr2783856qvr.13.1611284566681;
        Thu, 21 Jan 2021 19:02:46 -0800 (PST)
Received: from localhost.localdomain ([45.32.7.59])
        by smtp.gmail.com with ESMTPSA id y17sm5123721qki.48.2021.01.21.19.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 19:02:46 -0800 (PST)
From:   Su Yanjun <suyanjun218@gmail.com>
To:     mkl@pengutronix.de, manivannan.sadhasivam@linaro.org,
        thomas.kopp@microchip.com, wg@grandegger.com, davem@davemloft.net,
        kuba@kernel.org, lgirdwood@gmail.com, broonie@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Su Yanjun <suyanjun218@gmail.com>
Subject: [PATCH v1] can: mcp251xfd: use regmap_bulk_write for compatibility
Date:   Fri, 22 Jan 2021 11:02:14 +0800
Message-Id: <20210122030214.166334-1-suyanjun218@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently i use mcp2518fd on 4.x kernel which multiple write is not
backported, regmap_raw_write will cause old kernel crash because the
tx buffer in driver is smaller then 2K. Use regmap_bulk_write instead
for compatibility.

Signed-off-by: Su Yanjun <suyanjun218@gmail.com>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 3dde52669343..ab8aad0a7594 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -932,6 +932,7 @@ static int mcp251xfd_chip_ecc_init(struct mcp251xfd_priv *priv)
 	void *ram;
 	u32 val = 0;
 	int err;
+	int val_bytes = regmap_get_val_bytes(priv->map_reg);
 
 	ecc->ecc_stat = 0;
 
@@ -947,8 +948,8 @@ static int mcp251xfd_chip_ecc_init(struct mcp251xfd_priv *priv)
 	if (!ram)
 		return -ENOMEM;
 
-	err = regmap_raw_write(priv->map_reg, MCP251XFD_RAM_START, ram,
-			       MCP251XFD_RAM_SIZE);
+	err = regmap_bulk_write(priv->map_reg, MCP251XFD_RAM_START, ram,
+			       MCP251XFD_RAM_SIZE / val_bytes);
 	kfree(ram);
 
 	return err;
-- 
2.25.1

