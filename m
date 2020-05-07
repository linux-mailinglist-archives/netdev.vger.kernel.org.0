Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE84D1C9489
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgEGPN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727945AbgEGPN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 11:13:29 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055EBC05BD09;
        Thu,  7 May 2020 08:13:29 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a5so2759972pjh.2;
        Thu, 07 May 2020 08:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yiQVRmgp68ZxdiqvhT5ZYHUwpUlX6w91CPHLUh7nmBg=;
        b=pN6IJddrdMCePMv1pI1BDBoa0F276DfKumJlIhN92BfEjCfkgb9/MsOMSDHejXopqf
         ucnuX1K9/ZKZZDF86o4brCuH3Y7XaY/axqfiF1yS2eonYLcFVB5VJatK5d/b/4O+ZEzU
         kqRSjzXIn3CmbhhUaRxrK6/b8x7nbL+SHBwjXlX9ztneg3GW9DwmtwkLn8iWdXP2jiTM
         3k2x6lv2Zdal7LW1hKTegJGT8gYRQHwieHCbLTehqCBaLDRzd0lPgh1PHDm5oaV2Ss/B
         HE4trkhopv1dU2xvipduIRBvtdPYN01tMTh0lf2ehXRlFxKApdkr7JsOXPFIzq0xRQzG
         m1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yiQVRmgp68ZxdiqvhT5ZYHUwpUlX6w91CPHLUh7nmBg=;
        b=T4Vg0rDX7UAfJXS4yIBOljNDbzWLbt8YWtkIcav5RCuJD0AzQ/5alZeQ1nC81mbPKY
         AreVsrI27wR1cLCVJ1f6xbfQb2HSaV3R3MzhBytfj1lwRcJEKw3F4am21EvC4kRxm19B
         gBwkqDhVMAzYV9KxYZ9m3L3TSPzk0qGbAfhOYtaydb1a+td8yegl/qvKS9rUG51ayyJ4
         1evNeZL7eGCrLKiQznRP9mj6WYmgeoDgjf9a3oFHpzKgtLZ20GUkFhyUvG6eZo1HJZ2m
         O/dSLc/hyoQU32my1ZLN5kHD8a75J/AIQkVEjMwpd5q3JpMs/ZJ0DUOZ8PBQr4hD/Tbc
         lRYA==
X-Gm-Message-State: AGi0PuYeUj3iBM5E+EQbV2KTWLudabufqPrK3m8Qz7E0VMtvi9qpONv6
        V56S97CVbVLtd7QwYy6R39A=
X-Google-Smtp-Source: APiQypKFZJEGtv+7FjTJJO7j8FyFw9dJ/N0Kv8o2MoO68KoAp7Upx1lEnDahwA4pfht1tw9xQLKung==
X-Received: by 2002:a17:90a:c7c8:: with SMTP id gf8mr607996pjb.226.1588864408655;
        Thu, 07 May 2020 08:13:28 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id f76sm5094969pfa.167.2020.05.07.08.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 08:13:28 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net: microchip: encx24j600: add missed kthread_stop
Date:   Thu,  7 May 2020 23:13:20 +0800
Message-Id: <20200507151320.792759-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver calls kthread_run() in probe, but forgets to call
kthread_stop() in probe failure and remove.
Add the missed kthread_stop() to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/microchip/encx24j600.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
index 39925e4bf2ec..b25a13da900a 100644
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -1070,7 +1070,7 @@ static int encx24j600_spi_probe(struct spi_device *spi)
 	if (unlikely(ret)) {
 		netif_err(priv, probe, ndev, "Error %d initializing card encx24j600 card\n",
 			  ret);
-		goto out_free;
+		goto out_stop;
 	}
 
 	eidled = encx24j600_read_reg(priv, EIDLED);
@@ -1088,6 +1088,8 @@ static int encx24j600_spi_probe(struct spi_device *spi)
 
 out_unregister:
 	unregister_netdev(priv->ndev);
+out_stop:
+	kthread_stop(priv->kworker_task);
 out_free:
 	free_netdev(ndev);
 
@@ -1100,6 +1102,7 @@ static int encx24j600_spi_remove(struct spi_device *spi)
 	struct encx24j600_priv *priv = dev_get_drvdata(&spi->dev);
 
 	unregister_netdev(priv->ndev);
+	kthread_stop(priv->kworker_task);
 
 	free_netdev(priv->ndev);
 
-- 
2.26.2

