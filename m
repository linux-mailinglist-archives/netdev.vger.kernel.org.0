Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3002F4FF3B9
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbiDMJlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbiDMJlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:41:02 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B8F546B8;
        Wed, 13 Apr 2022 02:38:40 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id bd13so806812pfb.7;
        Wed, 13 Apr 2022 02:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o66bR84svG1Vv/PCgfD86hSotmaG/IulOEB6qjFphHY=;
        b=O1ailLv5n/IpRssNt70UTBjt2MWMuJh+5g5eO2Px3oyGgm6pqhnrM1ywI0skHauiES
         V1/F8akwE9Hg8YxYr6/KeX4uBjrejQDEKiHQ5f1/AvoLPPVVMOmrK3e+F6JkGS8xkr7z
         JWlmiOIesk/dQlqK6xC3zdIz2YMrRtFM5zE7bzBbb428GbltQ9elKDNvJi52Fz8Mrk8D
         gi5Z/iZMdXzYK0XooL0JqYt6meIj5mU+lMFDTMgggOlzmxcNdEjZzA+6daXdD0S2PICb
         XCKBPiHdZqAZOwSjZewuY+nd139MaqzHSx0i5Yz5SKi6rVJ2ymKtujobKVWK2rspDRBI
         AFvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o66bR84svG1Vv/PCgfD86hSotmaG/IulOEB6qjFphHY=;
        b=JKC/zkq6F8wSTj6pDQaKb+DO//jgGOneSV9ROj5aGb2dMU1Oy9aJo66jJf0sCu39lg
         ylUzoPw9bqPJUVqAWIlFiAqTznIp3l0D4Z9CCiS1XRpRu0SSvwUO3e/bPL0uv0romjn6
         PHr05BBY1TqJVpRlfZ3j6nB89ZI0Vi7QDrrdaLIBjXDh4SK5h2J7e+dpXYo/lHnIDEP/
         GINiBQ2qfgJpLmlhZlxtJa/XB6cA09nWcE7GIX4MRDasQF4VL4Y1NRcMKZRg+C8LhKDm
         e++akDgmqUwWK2U2ir+KOzl4D3UuaNTcHIeVUA/RvGnH9y9brOrpvRmkvj30Lt3n7AO/
         jPNg==
X-Gm-Message-State: AOAM530ued1tq7VFV6/Sz+xa8rHtgkw1Q9G/HfnL24/fAgFD+mtCrmG0
        RLK1Y9cQ+bCBkFtpwhwwO/ePebBQr68=
X-Google-Smtp-Source: ABdhPJwshtt4nObDmt+mbtxGd8W6tobEaRlCzmGKzNLIduo/LNB7dNOxvy4E9xAoo/42buWrjCK0Sg==
X-Received: by 2002:a65:4787:0:b0:39d:96b7:bfaa with SMTP id e7-20020a654787000000b0039d96b7bfaamr6395784pgs.495.1649842720322;
        Wed, 13 Apr 2022 02:38:40 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id n24-20020aa79058000000b0050612d0fe01sm2242318pfo.2.2022.04.13.02.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:38:40 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     grygorii.strashko@ti.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        toke@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: ethernet: ti: cpsw_priv: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Wed, 13 Apr 2022 09:38:36 +0000
Message-Id: <20220413093836.2538690-1-chi.minghao@zte.com.cn>
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
 drivers/net/ethernet/ti/cpsw_priv.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 8f6817f346ba..917e0392cfe8 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -754,11 +754,9 @@ int cpsw_ndo_set_tx_maxrate(struct net_device *ndev, int queue, u32 rate)
 		return -EINVAL;
 	}
 
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
+	ret = pm_runtime_resume_and_get(cpsw->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	ret = cpdma_chan_set_rate(cpsw->txv[queue].ch, ch_rate);
 	pm_runtime_put(cpsw->dev);
@@ -970,11 +968,9 @@ static int cpsw_set_cbs(struct net_device *ndev,
 		return -1;
 	}
 
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
+	ret = pm_runtime_resume_and_get(cpsw->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	bw = qopt->enable ? qopt->idleslope : 0;
 	ret = cpsw_set_fifo_rlimit(priv, fifo, bw);
@@ -1008,11 +1004,9 @@ static int cpsw_set_mqprio(struct net_device *ndev, void *type_data)
 	if (mqprio->mode != TC_MQPRIO_MODE_DCB)
 		return -EINVAL;
 
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
+	ret = pm_runtime_resume_and_get(cpsw->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	if (num_tc) {
 		for (i = 0; i < 8; i++) {
-- 
2.25.1


