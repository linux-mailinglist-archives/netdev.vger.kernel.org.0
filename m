Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1576282D1
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 15:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbiKNOiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 09:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236835AbiKNOih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 09:38:37 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972BF1E3F8
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 06:38:36 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id k5so10477930pjo.5
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 06:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88tOeLPsWCVekBUY0oEIMvHJFlQGAI2IcuZIBKwXMgk=;
        b=cSV6Gr7b2MwgMZ5mgCOCmJJyIZErCkrsz/BFy/2m0+D3Sky1+qBmcK0ltijMxQeNcv
         4wsKq9lHRw06XLIJuB8xWPf2ETTeVgDSy5CznlCsrqaa/rugKPav43PWKZZFRxMwZfrK
         anc+Mk6kMobrr4zZ/8DDuB7zgyszP5E+sHWe7rn9QSuH4ZbcoYILLtFZMprlqtHXaRRh
         Jcof1Pg6f2gMmkkQDBI/AGoyBcus3cQmkRWb9yC63Nvn9Lu/ef00J+e1tWD1XFWAnNNt
         44zRbYT0+veOdnsILIbLxJT9pA0WdoRfKXXQPeggV5njGuMTcljs4gEM9OpbhGcfAUah
         PmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=88tOeLPsWCVekBUY0oEIMvHJFlQGAI2IcuZIBKwXMgk=;
        b=q3KGVgmXABVdAl/C1WPLGLitT26kXbypipPTNQk6yh3CHmYn5EJShPgpEWqVFLRy73
         0aCp+RkJ3Nb500CYPsTsyhy6r9BZvsMKhtVoln7mlveXF3oGPdwWuVPwBLDPBKQZdP1p
         /pFaR0RmujZqf+uMYrRBWkb66oJPhaJUk5IE427DrtUfTs6Cj2Ice3hzRasCl/+fUfZM
         pwPDBxHI6fJyRV0dPsiNMc8vEC1+7EJ8I7rvE8JCZ7dtjYeuXvB0AeTczpLVomTOckgV
         IU8gNb+oYBAgR79Uef/Tc0SZIVGaNBxieDLvrlT1hCpgPC5dRDfPCpy3YmEJSu/gIsuQ
         96aA==
X-Gm-Message-State: ANoB5pmJiHFGBYXw3fxvUnOvGmgvYNicCb/wd+++8fju5VvK7n7n/Bz+
        YHV+ZixCZaic2BXoQ4CGycv9lg==
X-Google-Smtp-Source: AA0mqf5Sb2LE8n7PGiKvZLrUZo0hzT47aha6jcaOzpi0tLPxpQjSxSA1aBxlKKHpHeBDtxVMp61qKQ==
X-Received: by 2002:a17:90a:24d:b0:212:e2e9:4b1f with SMTP id t13-20020a17090a024d00b00212e2e94b1fmr13625492pje.20.1668436716155;
        Mon, 14 Nov 2022 06:38:36 -0800 (PST)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00000c00b0056bc742d21esm6977381pfk.176.2022.11.14.06.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 06:38:35 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v3 RESEND net-next 1/3] net: axienet: Unexport and remove unused mdio functions
Date:   Mon, 14 Nov 2022 22:37:53 +0800
Message-Id: <20221114143755.1241466-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221114143755.1241466-1-andy.chiu@sifive.com>
References: <20221114143755.1241466-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both axienet_mdio_enable functions are no longer used in
xilinx_axienet_main.c due to 253761a0e61b7. And axienet_mdio_disable is
not even used in the mdio.c. So unexport and remove them.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  2 --
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 13 +------------
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 6370c447ac5c..575ff9de8985 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -611,8 +611,6 @@ static inline void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
 #endif /* CONFIG_64BIT */
 
 /* Function prototypes visible in xilinx_axienet_mdio.c for other files */
-int axienet_mdio_enable(struct axienet_local *lp);
-void axienet_mdio_disable(struct axienet_local *lp);
 int axienet_mdio_setup(struct axienet_local *lp);
 void axienet_mdio_teardown(struct axienet_local *lp);
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 0b3b6935c558..e1f51a071888 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -153,7 +153,7 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
  * Sets up the MDIO interface by initializing the MDIO clock and enabling the
  * MDIO interface in hardware.
  **/
-int axienet_mdio_enable(struct axienet_local *lp)
+static int axienet_mdio_enable(struct axienet_local *lp)
 {
 	u32 host_clock;
 
@@ -226,17 +226,6 @@ int axienet_mdio_enable(struct axienet_local *lp)
 	return axienet_mdio_wait_until_ready(lp);
 }
 
-/**
- * axienet_mdio_disable - MDIO hardware disable function
- * @lp:		Pointer to axienet local data structure.
- *
- * Disable the MDIO interface in hardware.
- **/
-void axienet_mdio_disable(struct axienet_local *lp)
-{
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET, 0);
-}
-
 /**
  * axienet_mdio_setup - MDIO setup function
  * @lp:		Pointer to axienet local data structure.
-- 
2.36.0

