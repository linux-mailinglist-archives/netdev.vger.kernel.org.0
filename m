Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC86E4FB16F
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 03:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242231AbiDKBkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 21:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiDKBkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 21:40:32 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B9944A03;
        Sun, 10 Apr 2022 18:38:20 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id q6so4211763qtn.4;
        Sun, 10 Apr 2022 18:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WqzdQ/gWc4cM8zDuvt8qnP7TS4UyEHxRHkUc5zYRYUM=;
        b=OTT04MM23HwXOpeGOpFXnh3fsftCcVfqxJxbPwNMv4w03057ztto5xcJIN6451aId6
         QIaxV+YJe8CYfAJIJt0ojQQFjH5WMEf1baoK1rvIpDsPuLeTjBYK5ajsGl1y6KEbknlC
         ITYTuP3AkgB0rb/Cp+3ot5mAOvXNjJu5+hPUnN0N+zswqTSc3hpQu9EpG4ksOGgx/SQ/
         BcodUIeSlU8iX5cnE0XIfSX62Z3gAObz+v22m8wPNyeWaHNQqQrkNAnIGczu6p3vIeWP
         ji0CzKD5y8zfvEZdU2tSc0z/CEXV6j6OqSzDWow/l33X3LO7UuwvBIvMbTuL5WbYWh6z
         98HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WqzdQ/gWc4cM8zDuvt8qnP7TS4UyEHxRHkUc5zYRYUM=;
        b=otiI/sWFUb+gQtQjKNTiFkZ7bqMAAmkjVp+FbfYRDWUBX2N+iJF+E8zUl4ud8yejK+
         by7ZMZq7Xqqdxm5NfeM1+kB7mB18Zbol9MNaBWCkWRaL8DZDKNGGClZkDjchApVbyQbU
         PkI8riJS1PU0iWi3GlUTD3tRRa9YfsECamW1TO5KwYpbiWNxaD7TUmh+8olzVmBMivff
         ovIwJxID0WvJQDizy9VYFD5BwUh/hVyoKeUNhMTZRDqOyaG+4D65qqy8ajpOrs+S2MWH
         kPSUh1psbhVJbe7oOeOgDcyTuRWUXJNKShIFPSUp1YUblE5Qt5P8P214sIhQHbpUj34I
         qC+Q==
X-Gm-Message-State: AOAM532cEgURpqoG5ckpCp2YiI7w2qEwu1USfGJkOAnFjU47jT7Xk2AA
        yDOiYCA33J9pRLCvVTASUJMPi/Y8Ycc=
X-Google-Smtp-Source: ABdhPJzNu4H4YKfUVPy80YNTAt719F2lmQ/ohbWnacIZ9s7Iyxmy9oW6WBAG3+ppKQxOoiW4e+w4Ww==
X-Received: by 2002:ac8:5045:0:b0:2ed:974c:5a97 with SMTP id h5-20020ac85045000000b002ed974c5a97mr3375765qtm.199.1649641099239;
        Sun, 10 Apr 2022 18:38:19 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 64-20020a370743000000b0069a0cb6e4d5sm6989346qkh.81.2022.04.10.18.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 18:38:18 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     nicolas.ferre@microchip.com
Cc:     claudiu.beznea@microchip.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net/cadence: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Mon, 11 Apr 2022 01:38:12 +0000
Message-Id: <20220411013812.2517212-1-chi.minghao@zte.com.cn>
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
 drivers/net/ethernet/cadence/macb_main.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 800d5ced5800..5555daee6f13 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -337,11 +337,9 @@ static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	struct macb *bp = bus->priv;
 	int status;
 
-	status = pm_runtime_get_sync(&bp->pdev->dev);
-	if (status < 0) {
-		pm_runtime_put_noidle(&bp->pdev->dev);
+	status = pm_runtime_resume_and_get(&bp->pdev->dev);
+	if (status < 0)
 		goto mdio_pm_exit;
-	}
 
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
@@ -391,11 +389,9 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	struct macb *bp = bus->priv;
 	int status;
 
-	status = pm_runtime_get_sync(&bp->pdev->dev);
-	if (status < 0) {
-		pm_runtime_put_noidle(&bp->pdev->dev);
+	status = pm_runtime_resume_and_get(&bp->pdev->dev);
+	if (status < 0)
 		goto mdio_pm_exit;
-	}
 
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
@@ -2745,9 +2741,9 @@ static int macb_open(struct net_device *dev)
 
 	netdev_dbg(bp->dev, "open\n");
 
-	err = pm_runtime_get_sync(&bp->pdev->dev);
+	err = pm_runtime_resume_and_get(&bp->pdev->dev);
 	if (err < 0)
-		goto pm_exit;
+		return err;
 
 	/* RX buffers initialization */
 	macb_init_rx_buffer_size(bp, bufsz);
@@ -4134,11 +4130,9 @@ static int at91ether_open(struct net_device *dev)
 	u32 ctl;
 	int ret;
 
-	ret = pm_runtime_get_sync(&lp->pdev->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(&lp->pdev->dev);
+	ret = pm_runtime_resume_and_get(&lp->pdev->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	/* Clear internal statistics */
 	ctl = macb_readl(lp, NCR);
-- 
2.25.1

