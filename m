Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231E86192BC
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 09:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiKDIaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 04:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiKDIaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 04:30:09 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EF9275FC
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 01:30:08 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id kt23so11376225ejc.7
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 01:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J0WWDPjFFiB5FkqfAdkJr8kHG7tGk0wrcMV56w0EsG4=;
        b=io9r1oscZpSSorDwWffkeSVLwWaxKhBdOA8oHFnKzyms3Tu9/GHZ+y5kkr+SNxbxnz
         FxrQVrq2wOxmdMFLrCsI00zYdSEF23biFhxbj/bl8ISM3fVUw61gZMvo/1cmH5G/2Ivu
         FLz0Xuiw5RyRILnUExDVTfN+uGp7F1vi5bSTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J0WWDPjFFiB5FkqfAdkJr8kHG7tGk0wrcMV56w0EsG4=;
        b=151ACc5lbyDMyFTpv9HG8pFLiMQuNVJhKJlucL7vNMLH1DyW1dJYp4i+4UINn4P9qv
         /RCa6Ps15EkgDkTTgyGsnevROxbsofU1i8jxeVuwnR5KSQ7kK1sbzBihi8qKleNvcCJ4
         uzfmUIa+D5bVLafoK7BEYrLCsIP8v8pUglPgi2JR6p6cKy7knxF8gaJBf4Bdhte/ooID
         GOPZ/XIolv5oLzAkFPKE4pU9FDq4/7IUqx2iFawZnafEe1C6bZA7o7dr2+fVAEl7+lO+
         BoL2bySEfJ1YHuwBEeEWatCg73UHMQYNuaJgFYxDDNG1+wj9Ny7o3/Ul00MO0iUoqLxN
         B1Bw==
X-Gm-Message-State: ACrzQf2TGyvv7OACgZLg9BEc1+hWdyA+dkg2gvtNVTr5yrfrkXA6AHVT
        Z3QzJ93FVMzKfJ83KzX8Gdb3rw==
X-Google-Smtp-Source: AMsMyM7BrUNV7InYCf/NzvNGYzXPv55tEbDE6bSYY59zpAi2DC7Pl4Yvuo4+URe4mVy+0aN8e8+hSw==
X-Received: by 2002:a17:907:97ca:b0:791:644c:491e with SMTP id js10-20020a17090797ca00b00791644c491emr33081519ejc.555.1667550607180;
        Fri, 04 Nov 2022 01:30:07 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id d8-20020a170906344800b0073dc5bb7c32sm1505870ejb.64.2022.11.04.01.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 01:30:06 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] net: stmmac: dwmac-meson8b: fix meson8b_devm_clk_prepare_enable()
Date:   Fri,  4 Nov 2022 09:30:04 +0100
Message-Id: <20221104083004.2212520-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
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

There are two problems with meson8b_devm_clk_prepare_enable(),
introduced in a54dc4a49045 (net: stmmac: dwmac-meson8b: Make the clock
enabling code re-usable):

- It doesn't pass the clk argument, but instead always the
  rgmii_tx_clk of the device.

- It silently ignores the return value of devm_add_action_or_reset().

The former didn't become an actual bug until another user showed up in
the next commit, 9308c47640d5 (net: stmmac: dwmac-meson8b: add support
for the RX delay configuration). The latter means the callers could
end up with the clock not actually prepared/enabled.

Fixes: a54dc4a49045 (net: stmmac: dwmac-meson8b: Make the clock enabling code re-usable)
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
Not tested in any way, just stumbled on this which didn't seem right.

It seems that the timing_adj_clk could be changed (with a bit of
refactoring) to use devm_clk_get_enabled() - i.e. don't make it
optional, but only get/prepare/enable it in the (delay_config &
PRG_ETH0_ADJ_ENABLE) branch where the code actually requires it.

But since there's no official devm_clk_prepare_enable, and the
rgmii_tx_clk isn't obtained via a clk_get, I don't see a simple way to
avoid this private implmentation of devm_clk_prepare_enable().

drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index c7a6588d9398..e8b507f88fbc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -272,11 +272,9 @@ static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
 	if (ret)
 		return ret;
 
-	devm_add_action_or_reset(dwmac->dev,
-				 (void(*)(void *))clk_disable_unprepare,
-				 dwmac->rgmii_tx_clk);
-
-	return 0;
+	return devm_add_action_or_reset(dwmac->dev,
+					(void(*)(void *))clk_disable_unprepare,
+					clk);
 }
 
 static int meson8b_init_rgmii_delays(struct meson8b_dwmac *dwmac)
-- 
2.37.2

