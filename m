Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20BD32FB35
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 15:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhCFOgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 09:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhCFOgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 09:36:22 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34697C06174A;
        Sat,  6 Mar 2021 06:36:22 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id a24so2820183plm.11;
        Sat, 06 Mar 2021 06:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vbxBb1VntFFI7FSKRpOYUkTr4/HoHjjU/Z5hhVEtQFE=;
        b=cjkQJVy+FYktOJFohMnmpFSPGc3v7kAV0WDTRg5uT6zQllagRtWk9uM8U8ZE1oZjrU
         e/qcIh3BaL69TyN8HgPS9yNmfaZkvRfy9of0h41Gm+tMm2Tj8U4qzpNN/CStYLWBmFgX
         M9qUVqpfO49Er1ZMDEDvHxK+k/f3Ug+kR7+7UVGevKkAZ18tfCQSLcSOGE22uhE2VLL1
         C8b/pERd2XogTgvyyX+3x5dCIiNEPYwk3v1s4AmW5nNzGQMrbZoHj3528OsX3CvtEoYz
         V9xWrxt1A9isYt5qYM3aPGvGvdT/xt0UBMXWNNC+kKqWyywKonHouvT2KaJSw3AhjmaM
         5xTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vbxBb1VntFFI7FSKRpOYUkTr4/HoHjjU/Z5hhVEtQFE=;
        b=jOK4gwFwDNSDPDNktCF/Fr3oHBERvXxQC4Z14tYI7k/4DRZ2UJcJVmJjgnjSKudrmy
         y+dlHV0D8cYrmLY76CX8VQHhQQWOfMBft8znimN/iYUCSyVPNGQl7vZ14werEWjf67LD
         XkQ82WZs4Upbuk/q7vNvscGoF/kCVrQhBIh1g92mnM6ZNh8PpojRbT6kvS1IrTRsPmmY
         SRruXXVAfq8cuSN5zqB9U1csBY7hj7BgrLmzznQoO1PgQwtASuFTrh/lJDXc0c2BybkC
         e1KV5mZDHBjCy2KDeMscNtKfURCO8glUFh/o1D4yUl9eCMV66LdeWBrvtasN55l0YOlQ
         ud/g==
X-Gm-Message-State: AOAM5323xyVl7zEJkXgelGhY/RtpgpgOpppFSA0HLmURYUqgpQy/hjv7
        kBG6NcKq0PBpNnSSG8LODMnlEx70WpWpHk9L
X-Google-Smtp-Source: ABdhPJzyIpewWRTqpI+d9ullPTBl25ToGQxDSiZE4CR22oZ3r7BN1zUIVM7PInWq1bXe1JMPPMO9Og==
X-Received: by 2002:a17:90b:1296:: with SMTP id fw22mr15497235pjb.93.1615041381665;
        Sat, 06 Mar 2021 06:36:21 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.79])
        by smtp.gmail.com with ESMTPSA id a73sm4858842pfd.212.2021.03.06.06.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 06:36:21 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] ti: wlcore: fix error return code of wl1271_suspend()
Date:   Sat,  6 Mar 2021 06:36:00 -0800
Message-Id: <20210306143600.19676-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When wl is NULL, no error return code of wl1271_suspend() is assigned.
To fix this bug, ret is assigned with -EINVAL in this case.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 9fd8cf2d270c..a040d595a43a 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -390,6 +390,7 @@ static int wl1271_suspend(struct device *dev)
 
 	if (!wl) {
 		dev_err(dev, "no wilink module was probed\n");
+		ret = -EINVAL;
 		goto out;
 	}
 
-- 
2.17.1

