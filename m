Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529E14FF3A3
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiDMJha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiDMJh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:37:28 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFA631204;
        Wed, 13 Apr 2022 02:35:07 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c23so1517036plo.0;
        Wed, 13 Apr 2022 02:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g8bxk6TEEm2E4o6Pbnd9rhcp6xDjb41DTe9/87BNTLo=;
        b=JZp5Hsljcm5VODYRCefVlERxtrwbMN/LlqYjsY9aehOsYfTRooM0dffeuovLITcMpa
         t+jLjYNrGEtMRhwrgwT2BysFowAmmBOr0FU6zVCUa+z3DV7LgxziTGs0j7buO6IFvma2
         DUpc5v19rO3MTWgZTwg3fujt3L/WU9EST7MUOQqFS19JHXJTek3cJzrW04U2zCTDooeA
         cR8x3X0mjGiDHOTPwSWI5jKLuxaKULhc0/DSmB8qDJN6/L0VVpyuI1ois0AYFu+2K36M
         xcLUU3YCm0fbXvG/x+TtoxZV30tsAJribr7soOiY0ZmIO8FXCwy1UyM405dOqsAKkUh8
         jXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g8bxk6TEEm2E4o6Pbnd9rhcp6xDjb41DTe9/87BNTLo=;
        b=GbRDLK42vyF5bSb7h9Tk+cUkp+xLX/JlYbaExgC248KCT19YAzG+QJKRqtZdCHAqCR
         1UpLTTtKrxi7PEZ/4wvod/pFxR1ly1rwygHJx+YMI3G08R60Fx+xSezZLZsKiRWbz+ks
         hC/+2X9xhZTteYoFOnr39Z4pKqsGfNIxVWaVG5Whk61My3NJy2aGAunLc5mwFCpstum8
         Ls0cVFRPDuSar5h5DHiwRPqHBY7cVBlcA/Q9980WxQOKXte/j5/JvUO0jX+6qEKjl/0Z
         TB63VYesdhvhNZ2mk2BF7zgTPZMsvFGEb3bcPYbVjlsdFPjBnLxD6X7QrD32l/fMG92M
         yWcw==
X-Gm-Message-State: AOAM530tFKUPnIg2UZz5N7WmQ5a1RZ2WRNzTkPm3ajJ178n6rhhCWOeV
        QP8lDGHz8dNxkmG24h+0YYE=
X-Google-Smtp-Source: ABdhPJw45U2NXOywU+IuPRm5iLbjbC1jplGTrrmeq9htOE9PfollGG0Q1anN3JrXMq7WI+IagnJpBg==
X-Received: by 2002:a17:90b:3144:b0:1cd:37de:3bbc with SMTP id ip4-20020a17090b314400b001cd37de3bbcmr6458307pjb.110.1649842506902;
        Wed, 13 Apr 2022 02:35:06 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id q15-20020a056a00150f00b004fb28ea8d9fsm44168349pfu.171.2022.04.13.02.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:35:06 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] wlcore: testmode: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
Date:   Wed, 13 Apr 2022 09:35:02 +0000
Message-Id: <20220413093502.2538316-1-chi.minghao@zte.com.cn>
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
 drivers/net/wireless/ti/wlcore/testmode.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
index 3a17b9a8207e..3f338b8096c7 100644
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -83,11 +83,9 @@ static int wl1271_tm_cmd_test(struct wl1271 *wl, struct nlattr *tb[])
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wl1271_cmd_test(wl, buf, buf_len, answer);
 	if (ret < 0) {
@@ -158,11 +156,9 @@ static int wl1271_tm_cmd_interrogate(struct wl1271 *wl, struct nlattr *tb[])
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
-- 
2.25.1


