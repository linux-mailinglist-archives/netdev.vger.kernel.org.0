Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D87506963
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350859AbiDSLHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350843AbiDSLHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:07:35 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9268389A;
        Tue, 19 Apr 2022 04:04:52 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id x20so12789887qvl.10;
        Tue, 19 Apr 2022 04:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DCNR+/F74etbtCBmnF9QIqM89DL1ghFGXifYK5unJVc=;
        b=SuK8mBKr8Zf8HTL8qkWt1/06qCL2O6xDjHBIg1D/dmybxFEkE/RJxCsycn18gZteVy
         OIEKcm/wl3giyjdAY9tyWxN0LRSa9wiuvzoD6Fdyklr3ysOGmP7KSL4q/0g9S7qbqg5J
         Jakg+ZuuRefcGrwMSktOaRU526DK+aQ6XIYqN/bqMl5W5q/sr5jLG6QFmeKujK3tFSJ/
         9tblyx8Ewvr/Cur+feV4/7xWsfiJbryfLj0PPGEz9qWjNB7to/ImCgE6Hn7ktlQi3IM5
         wLTXvLOljINjm2BCgwQtvdVqWIOl5ozMBbtO2LCw5uEqaVQWeJbRQaA3GThCOZLl7SuW
         CW2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DCNR+/F74etbtCBmnF9QIqM89DL1ghFGXifYK5unJVc=;
        b=3sDP2DsuIW2EhUWsMzTHENPVgfzciqOqs5LGnPZsimkoztujetGDnwuQvJSJgxIIe7
         Cl0KloHjqRchehtitCUHraSLw0i1VBUyCnCAla+Fp98KyqaufIXXBIVJdtJ97Ow72eYq
         OZ8X3LbCKJ//pvKqiit/aG+ol7ZYf3OoCT297oIXSf64aY+ybKv6xIdCxY2DeWNuq0wQ
         m296QBPYAtHhieGawVN09reRlIB47mIr3ZySEs96tcKZHjML4h1B1SXbBxbMQX76qt+2
         FkSh4bMDSVGxUM1NwQbAznqEBYH7Se01IJgByGX/1xWf9IosK3Bwmwdne/VIknGFeGy7
         LMSA==
X-Gm-Message-State: AOAM53308PaZY+DNYr0JHIrYq+CmTmfztzDgAi8A/x/BtyzKigdtn4q5
        AgDJAEb14dDf7zCq6+o9sO/XmvwDjPk=
X-Google-Smtp-Source: ABdhPJzvhcJt6gdWoYIkOvVP6VSp2FlLPiO0C6J1xRfXAD2pd9Axcaoz9Q9ADjCzcxpKW015KkGXzA==
X-Received: by 2002:a05:6214:2a8e:b0:443:c82b:4ba7 with SMTP id jr14-20020a0562142a8e00b00443c82b4ba7mr11353915qvb.74.1650366291811;
        Tue, 19 Apr 2022 04:04:51 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id d126-20020a37b484000000b0067e60283d08sm7809211qkf.40.2022.04.19.04.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 04:04:51 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] wlcore: sdio: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Tue, 19 Apr 2022 11:04:45 +0000
Message-Id: <20220419110445.2574424-1-chi.minghao@zte.com.cn>
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

Using pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
pm_runtime_put_noidle. This change is just to simplify the code, no
actual functional changes.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 72fc41ac83c0..7b4e8cc36b49 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -132,9 +132,8 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
 	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 	struct mmc_card *card = func->card;
 
-	ret = pm_runtime_get_sync(&card->dev);
+	ret = pm_runtime_resume_and_get(&card->dev);
 	if (ret < 0) {
-		pm_runtime_put_noidle(&card->dev);
 		dev_err(glue->dev, "%s: failed to get_sync(%d)\n",
 			__func__, ret);
 
-- 
2.25.1


