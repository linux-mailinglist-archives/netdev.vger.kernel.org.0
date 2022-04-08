Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957284F9081
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiDHIPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 04:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiDHIPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 04:15:02 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C404B57B0D;
        Fri,  8 Apr 2022 01:12:58 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id j6so4212687qkp.9;
        Fri, 08 Apr 2022 01:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A1kYgClPNkXttcnpJuxPc0b6ZRe4IN7sg6hgxvxZY2I=;
        b=kyEjHYb+mQEqY7tdjXMs0+hof/gNfwAwz9dja0FAcYnl7Kn2yZMySrQKi8P9cC9n1c
         CrtjN1tyIdNUF+51+SrlLfuU7ya2y0WJG246oGGjod0iZExbZVBbxz+lGF1Db4h/s2qA
         i6Id7+u85d6f6SJ9fRU8zrC9Iy8Rw9JXIieXMCRdohRYua+ZYihU6UkNdqGlGYDPoQ8u
         5r+d1x+aw1ZgnjTyjkG17EDh5N7rJJ8+Of6ms6W/m0OflU8zKwhmz2dJXJXf4PQjJZIr
         ASahsPzrYQ3mTyOjiwbFaQSNl8+tdhB1PhF7L3BP8uSvcE5CKutKj9nyn8Gv569dZdOJ
         ICEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A1kYgClPNkXttcnpJuxPc0b6ZRe4IN7sg6hgxvxZY2I=;
        b=w0UE7Uwx5KM0P6teHFMe/RkzEZJRDDvCRAQApPft5ov+eJ59uWPkTOjfdiQ7omjTPo
         lySpc0cDkUEUbwQbBxbBsGmCOCFpd4oiIeaZM8TmP5g8kUGiKekURtsXWEqA3AbYv5f6
         TAbznEuU4g5lM9F6Qmh6NQKX2+ts6iLG76Tff/dqTI2eR1y3IOnjzvV0KqV9DKSBC353
         RtT/Gyv9gDW/R3YEay+F9Z64ppETppLsk6QgAbDA3JTVJjxx1gHE+9BuWn/fhJFSEP3l
         9fLFs20Wr99JrOWz4rTqyPx9eSdWlo9Q5H+GQ+VI09fmdqIAH0dlvgmb9hiKeuS114p2
         6HsA==
X-Gm-Message-State: AOAM532sIIrjJb8c3r6bpGLg1mzRc42oTv0emySLeBhnmm0ty7Kkbtq2
        /LsRpNjZxHSk8dFSh0Cw68M=
X-Google-Smtp-Source: ABdhPJxW/8z2WJJs+ZAhz+Xmzvh9kcBG41vVI4/HDjmZkkMAhj9pbXxrlb1zk92Dm7AY+6aJROjPYA==
X-Received: by 2002:a37:787:0:b0:69a:854:caae with SMTP id 129-20020a370787000000b0069a0854caaemr4189817qkh.20.1649405578000;
        Fri, 08 Apr 2022 01:12:58 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h11-20020a05622a170b00b002ebc9d47207sm4985436qtk.91.2022.04.08.01.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 01:12:57 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     peppe.cavallaro@st.com
Cc:     alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: stmmac: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Fri,  8 Apr 2022 08:12:50 +0000
Message-Id: <20220408081250.2494588-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Using pm_runtime_resume_and_get is more appropriate
for simplifing code

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 24 +++++++------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index a5d150c5f3d8..9bc625fccca0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -88,11 +88,9 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	u32 tmp, addr, value = MII_XGMAC_BUSY;
 	int ret;
 
-	ret = pm_runtime_get_sync(priv->device);
-	if (ret < 0) {
-		pm_runtime_put_noidle(priv->device);
+	ret = pm_runtime_resume_and_get(priv->device);
+	if (ret < 0)
 		return ret;
-	}
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
@@ -156,11 +154,9 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 	u32 addr, tmp, value = MII_XGMAC_BUSY;
 	int ret;
 
-	ret = pm_runtime_get_sync(priv->device);
-	if (ret < 0) {
-		pm_runtime_put_noidle(priv->device);
+	ret = pm_runtime_resume_and_get(priv->device);
+	if (ret < 0)
 		return ret;
-	}
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
@@ -229,11 +225,9 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	int data = 0;
 	u32 v;
 
-	data = pm_runtime_get_sync(priv->device);
-	if (data < 0) {
-		pm_runtime_put_noidle(priv->device);
+	data = pm_runtime_resume_and_get(priv->device);
+	if (data < 0)
 		return data;
-	}
 
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
@@ -297,11 +291,9 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 	u32 value = MII_BUSY;
 	u32 v;
 
-	ret = pm_runtime_get_sync(priv->device);
-	if (ret < 0) {
-		pm_runtime_put_noidle(priv->device);
+	ret = pm_runtime_resume_and_get(priv->device);
+	if (ret < 0)
 		return ret;
-	}
 
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
-- 
2.25.1

