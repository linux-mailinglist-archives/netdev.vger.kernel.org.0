Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9A963606
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 14:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfGIMf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 08:35:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52300 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfGIMf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 08:35:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so2917323wms.2
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 05:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=cLgXQ4kz2dIIInzZKQ9JoVEizjoV+oBvSabrsaRVFvQ=;
        b=UF/HkYnSl/LrtSfLcjlrvK7QlsOCcr/wOAEJx3KOtmi2Nl1RKUoDcKmPpig/e3WQSx
         x+OaS+Fnc0BgVa18oYN/7vqYoEpSH0a1riOgeoURHx5vOxGuZcch/b/4Z4fg4VPpFkF5
         7GBsZACSjUnSneS0E4npN2PVnNM0H3X8c7kQ2jTKXLoIOkYsghu8DD67V7P2s4n0nBxo
         +YBODOxMoBlrh/BNTxPsr9BXrDp2qn38ROxqXXk7nEcWBz6v6NciE5lu87TLIAscJDvc
         Lj1h5sXFZMok1bkvRnqTEaOMcytoAYksoKX86o82rOWU14t4I0mhWu2KbPpZLo6sSXkq
         lG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cLgXQ4kz2dIIInzZKQ9JoVEizjoV+oBvSabrsaRVFvQ=;
        b=N3EIXvvP0cPRUzyTTXWqPexes5LWb/75TKd0EcRPSoHvI1PP1O86NZzVOUXzR/KDa2
         WaoYVdxIMEsZh0/KSQJR7SauQeZ0RZ8p8hQIJavpLI1Fh4kepRVqpTjRCfGXhRTlVJF1
         LPONYb95QMTHw4iJSZm6JHTw+Z1pVPmGtlovG2ZyuRGBWayYGg769/SkQd9FVCjyrvfB
         xR//cTTIf0gJCrdw9IkDzNJCZXwfBc9N6CkkTbFL4f4RyfYg+J3eSaveXktoGKtHWTsL
         Un8HQivaGCSkLHSMpMiggt3duPMaSRg8eok/xHfT6pWMJFRxA+8t20lvHnAgje9kGuIB
         gzLQ==
X-Gm-Message-State: APjAAAWZgFdE3KdNrl9JjnuMFrxvvazbNIA4eWuzdextzkU2Ie8+ScB0
        anMTg7YYDgHrT6yeESWjc2FA6cYl8FM=
X-Google-Smtp-Source: APXvYqxcMyyQUQj4WEsjo42Aommg6AaAI9hbLA3X/lHrHUjQXTFlAWN7Po09LjVxkfp4y9L/qYDBsA==
X-Received: by 2002:a1c:968c:: with SMTP id y134mr22104916wmd.75.1562675756837;
        Tue, 09 Jul 2019 05:35:56 -0700 (PDT)
Received: from apalos.lan (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id 15sm1956131wmk.34.2019.07.09.05.35.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 09 Jul 2019 05:35:56 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        davem@davemloft.net
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH] net: netsec: start using buffers if page_pool registration succeeded
Date:   Tue,  9 Jul 2019 15:35:53 +0300
Message-Id: <1562675753-26160-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current driver starts using page_pool buffers before calling
xdp_rxq_info_reg_mem_model(). Start using the buffers after the
registration succeeded, so we won't have to call
page_pool_request_shutdown() in case of failure

Fixes: 5c67bf0ec4d0 ("net: netsec: Use page_pool API")
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 drivers/net/ethernet/socionext/netsec.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index d7307ab90d74..c3a4f86f56ee 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1309,6 +1309,15 @@ static int netsec_setup_rx_dring(struct netsec_priv *priv)
 		goto err_out;
 	}
 
+	err = xdp_rxq_info_reg(&dring->xdp_rxq, priv->ndev, 0);
+	if (err)
+		goto err_out;
+
+	err = xdp_rxq_info_reg_mem_model(&dring->xdp_rxq, MEM_TYPE_PAGE_POOL,
+					 dring->page_pool);
+	if (err)
+		goto err_out;
+
 	for (i = 0; i < DESC_NUM; i++) {
 		struct netsec_desc *desc = &dring->desc[i];
 		dma_addr_t dma_handle;
@@ -1327,14 +1336,6 @@ static int netsec_setup_rx_dring(struct netsec_priv *priv)
 	}
 
 	netsec_rx_fill(priv, 0, DESC_NUM);
-	err = xdp_rxq_info_reg(&dring->xdp_rxq, priv->ndev, 0);
-	if (err)
-		goto err_out;
-
-	err = xdp_rxq_info_reg_mem_model(&dring->xdp_rxq, MEM_TYPE_PAGE_POOL,
-					 dring->page_pool);
-	if (err)
-		goto err_out;
 
 	return 0;
 
-- 
2.20.1

