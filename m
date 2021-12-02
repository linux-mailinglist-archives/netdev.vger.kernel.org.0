Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7245D466CFC
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 23:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349644AbhLBWlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 17:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349648AbhLBWlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 17:41:00 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55F9C06174A;
        Thu,  2 Dec 2021 14:37:36 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id q3so1770513wru.5;
        Thu, 02 Dec 2021 14:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kmcp57kL2SB6d/jhzWeEG601S67EDYKctUDcqu13bXM=;
        b=GQj3vRK5mnzvz5sRXm9g1NQTRSQRdFCqzH9f8tMDNUuTxxMGMjdWJ4geOfjxM9YhjX
         SUCs5K9J2Z1VFNVayPSLQrb60D/R6WZdfRzSW1NfZzPzCB54gP7ZHWcNJWFL02P1von5
         LFazIsKPDmZcGdI8XE3PqzBhup1jwmGmwslgJ0dJen+D4OyrZbq7VhZzn2Gm7kT0LipB
         2oJ7UaIGqWQ16nPFDz64E8p5jQb1mtCRGRheq1qtwG5KEW4xOCEJhvSJSC78udBUsfCe
         br9HJUOMtt/yUkGD8tYXOhP/PLK/uQGP6ni03jLIHefweQ1DVPAkpDCKdIWX6sz1ZkZd
         g1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kmcp57kL2SB6d/jhzWeEG601S67EDYKctUDcqu13bXM=;
        b=nBjMkwrsT3FAleJq264f3v3bTqR7lGKrTEPnJZSOT6FSf2/h82H1MMO15/pYtsBdta
         J1OIxTU+u88Zox230j/Mfi0sSVQ+hgPiYT30IqHnKwPtCNcoUpw2zMZc6pC9u0+B1vvB
         /ChzoEdt+4amGCdRiqlckZmWTlnl7BIMtE45+HvGykUUWIS+p7bWPDmzfvh18rvW/Van
         oYwDHf6YhMDS2i+dRURymxko+VJdpCwOb/SVHxojfW3AH2VozWGjP5nzmuIyVbbGhaAv
         r0aAxkAfjFIfHGPbiPIMnFdYCq6Zn06KKlEtz4h94Q+UATjQ2esVFge4I0UwGVftacii
         6QxA==
X-Gm-Message-State: AOAM533gbW8kSphpd16h1yOGL+jZiqJr0pvC5z3TiTtInZjhST207IC6
        FeQcp0ND9rhYSH3apwH0U4ml7YkcrGJpsQWV
X-Google-Smtp-Source: ABdhPJxS7b97mhiyH/MfSwV6mhLzAwqSZ8AmmyjSrZMm60rJO+4B8Ek/XhXNaSKLVunCZl2SzED0xQ==
X-Received: by 2002:a5d:42cc:: with SMTP id t12mr17389409wrr.129.1638484655295;
        Thu, 02 Dec 2021 14:37:35 -0800 (PST)
Received: from localhost.localdomain ([39.48.206.151])
        by smtp.gmail.com with ESMTPSA id m125sm3321222wmm.39.2021.12.02.14.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 14:37:34 -0800 (PST)
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     amhamza.mgc@gmail.com
Subject: [PATCH] net: stmmac: Fix possible division by zero
Date:   Fri,  3 Dec 2021 03:37:29 +0500
Message-Id: <20211202223729.134238-1-amhamza.mgc@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix for divide by zero error reported by Coverity.

Addresses-Coverity: 1494557 ("Division or modulo by zero")

Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index da8306f60730..f44400323407 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -863,7 +863,7 @@ int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
 	stmmac_config_sub_second_increment(priv, priv->ptpaddr,
 					   priv->plat->clk_ptp_rate,
 					   xmac, &sec_inc);
-	temp = div_u64(1000000000ULL, sec_inc);
+	temp = div_u64(1000000000ULL, (sec_inc > 0) ? sec_inc : 1);
 
 	/* Store sub second increment for later use */
 	priv->sub_second_inc = sec_inc;
-- 
2.25.1

