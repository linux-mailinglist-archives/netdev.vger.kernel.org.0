Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFFB504CA2
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbiDRGcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiDRGcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:32:07 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7F418E0E;
        Sun, 17 Apr 2022 23:29:29 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id b189so10562089qkf.11;
        Sun, 17 Apr 2022 23:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4ZNxKkB1heXshxCdkEbaHOZ1fBK6TexM+Jzjx/u/3mE=;
        b=agKys+0f9B8+rSNrGPubzZYwAMOCNPp+KyH39Uo+8JOadAlMbwSceqA4BguldvGJWm
         vCYjn0TUYIY5iTCMob2vo5gEz4aIH56qNPNa5gJjqGkYRI5DdPudaQC9ZSSGLVhvUAYa
         iwEtiK9Up1VbT3mhVV9uRM28/gIfPra2kPkYhT1xA4MQXAtj3Y1nJ2F89LYtjGWW1e8F
         dJuV5aG+dxoTH7f5n8IvyS6li71+/ufGEJeg2lITo0qho7RJ0VDWUg9NXi6ETKvG5jC1
         I5HWD4VIVavBK5ljSscJD1c88bRlFKMcDy9xIZuCytAt+w+x2F2HcprvFCDnphXMlq11
         KVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4ZNxKkB1heXshxCdkEbaHOZ1fBK6TexM+Jzjx/u/3mE=;
        b=V0OgXb/xEuXcXGxoWP04owSEr0QSyY/RZd1iwB/dBAyij8CqU7LZfajlgEp6qXZupo
         YgaQy+wDK6TUK/flTETRVWzyNKixyDByMvYiaxyIwCiTEXW1/AgIobay1M0k88g2uh+8
         vfS5NmSnjOJDGXhvRaZ33gQAlRTPvDQKIAznabq5TTxVheCdrnO+RTUSRWerIjWYBbWb
         weUZYnXc4y1S/DJYIgmbtwoNjkqIm2Y9e4EyPXconTcvMMB9F2zdRqqdqvUzyAQYFyke
         1qbu/u3UEQMhG+YFE9i1q9vNUxxl1K+d1V2aOTM9EUFAJXVW+f13LDlrivraizBxkuC5
         5HQg==
X-Gm-Message-State: AOAM532vJpm9aMkW0uhJxMnxgM+F1zYBIJN/qzSXUDOEtA7e8fIZqej8
        B5hrn2v3oC/kaqpm7wUj/y094Nr0QxU=
X-Google-Smtp-Source: ABdhPJyVwl94lwStyIiTsrgoJZ1Q8p4COL0lQihBGHuXyhMvdWo+5AO0tzliP/ZkPPgeHaILIw0Q2g==
X-Received: by 2002:a05:620a:2681:b0:67e:933e:54b6 with SMTP id c1-20020a05620a268100b0067e933e54b6mr5861271qkp.428.1650263368206;
        Sun, 17 Apr 2022 23:29:28 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t198-20020a3746cf000000b0069c51337badsm6238458qka.45.2022.04.17.23.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 23:29:27 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     grygorii.strashko@ti.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] drivers: net: davinci_mdio: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Mon, 18 Apr 2022 06:29:21 +0000
Message-Id: <20220418062921.2557884-1-chi.minghao@zte.com.cn>
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
 drivers/net/ethernet/ti/davinci_mdio.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index fce2626e34fa..ea3772618043 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -134,11 +134,9 @@ static int davinci_mdio_reset(struct mii_bus *bus)
 	u32 phy_mask, ver;
 	int ret;
 
-	ret = pm_runtime_get_sync(data->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(data->dev);
+	ret = pm_runtime_resume_and_get(data->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	/* wait for scan logic to settle */
 	msleep(PHY_MAX_ADDR * data->access_time);
@@ -232,11 +230,9 @@ static int davinci_mdio_read(struct mii_bus *bus, int phy_id, int phy_reg)
 	if (phy_reg & ~PHY_REG_MASK || phy_id & ~PHY_ID_MASK)
 		return -EINVAL;
 
-	ret = pm_runtime_get_sync(data->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(data->dev);
+	ret = pm_runtime_resume_and_get(data->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	reg = (USERACCESS_GO | USERACCESS_READ | (phy_reg << 21) |
 	       (phy_id << 16));
@@ -276,11 +272,9 @@ static int davinci_mdio_write(struct mii_bus *bus, int phy_id,
 	if (phy_reg & ~PHY_REG_MASK || phy_id & ~PHY_ID_MASK)
 		return -EINVAL;
 
-	ret = pm_runtime_get_sync(data->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(data->dev);
+	ret = pm_runtime_resume_and_get(data->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	reg = (USERACCESS_GO | USERACCESS_WRITE | (phy_reg << 21) |
 		   (phy_id << 16) | (phy_data & USERACCESS_DATA));
-- 
2.25.1


