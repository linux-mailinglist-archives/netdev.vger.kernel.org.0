Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7894B4FF3C0
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbiDMJmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiDMJmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:42:05 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBD416599;
        Wed, 13 Apr 2022 02:39:44 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n18so1484673plg.5;
        Wed, 13 Apr 2022 02:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rhegUgjc/7VHRLP2gdtsnZm8adnS3l3cX73PyLsMGRk=;
        b=ARKI66sAkLyVzLdo1WE8DshrLMWmBCs9E7n6aGgK9cqB3oVkTySrW8TkAyxoxGms2E
         K222tpdE9a+sxA+q7V2nGmIgu6FiZLQbx73ITRSU4APR9gpUKY7K4QwXHsb8AEXB59I8
         c9HCyDrm4OCF7UY8jFeY5F0a3R81n5Otjd4WQ+7JHwOzk037mlwL8bzmej5bxTbg42qm
         HJFt9TyjX+pqdQhAgKAlEpz3dUiz18+cdiGIn3YlBFanQ8mfci5Cczvpb5RruJALPqS7
         C8GfyeZbQz/gjftS0XKefkLgK2Gy2i/3XoJwbbGu0QvOD+swJ2YsugwaCqhPoUPr255t
         mjYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rhegUgjc/7VHRLP2gdtsnZm8adnS3l3cX73PyLsMGRk=;
        b=51JdK1VVLATZDhIIPcw4IUvtiJi6xb8YZtzkeGhA1J0lAN9b843gGS/R9L+AbMG8GS
         LYIY0+w91NA12i4HmE0+v1fWwoW26TgRSyP5YKYinuVzva5bt2pmhIVQggUYtQn9jtO0
         LgyBjGSVvJ7TPaJQk22i/kRYOFPeL33qGlYx9HAFAHoDbsSUBqRISV4FsgZP6Vt31rl4
         pYt6bmCaTv1V9tSm0iU9K0Kv8W1/C3uUXD1YpIJqjUrimX4RvI4r/aFdtMzte8jrvVcf
         oP8De8oD99En6KkGzW3jTpyPogI4AMUwKyfOd5Q5aVuGGtc6bk4e/SFZarL2AluKmEqJ
         dFwQ==
X-Gm-Message-State: AOAM532JgIQl13v/Uq+nJJzTvQK8fYEr/XigKwow3xt7QzWZVKX/lVze
        qHK325qM7tocftxtL8pOLjQ=
X-Google-Smtp-Source: ABdhPJwkgg7b/12aUFRK5iwhxMcz1c2QyYp9PhA6rSpY/3uzhaFb3dcLDGd0TQxSU3Ady4kqsgP1Jw==
X-Received: by 2002:a17:902:cf0d:b0:156:1cc:f08f with SMTP id i13-20020a170902cf0d00b0015601ccf08fmr41362048plg.42.1649842784486;
        Wed, 13 Apr 2022 02:39:44 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id r35-20020a635163000000b0039d2213ca6csm5522616pgl.45.2022.04.13.02.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:39:44 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] wlcore: vendor_cmd: use pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Wed, 13 Apr 2022 09:39:39 +0000
Message-Id: <20220413093939.2538825-1-chi.minghao@zte.com.cn>
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
 drivers/net/wireless/ti/wlcore/vendor_cmd.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/vendor_cmd.c b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
index e1bd344c4ebc..e4269e2b0098 100644
--- a/drivers/net/wireless/ti/wlcore/vendor_cmd.c
+++ b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
@@ -53,11 +53,9 @@ wlcore_vendor_cmd_smart_config_start(struct wiphy *wiphy,
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wlcore_smart_config_start(wl,
 			nla_get_u32(tb[WLCORE_VENDOR_ATTR_GROUP_ID]));
@@ -88,11 +86,9 @@ wlcore_vendor_cmd_smart_config_stop(struct wiphy *wiphy,
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wlcore_smart_config_stop(wl);
 
@@ -135,11 +131,9 @@ wlcore_vendor_cmd_smart_config_set_group_key(struct wiphy *wiphy,
 		goto out;
 	}
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wlcore_smart_config_set_group_key(wl,
 			nla_get_u32(tb[WLCORE_VENDOR_ATTR_GROUP_ID]),
-- 
2.25.1


