Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710A2508458
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 11:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348138AbiDTJEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 05:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351139AbiDTJEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 05:04:39 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C020C12756;
        Wed, 20 Apr 2022 02:01:48 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id d198so728333qkc.12;
        Wed, 20 Apr 2022 02:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hGpgGqkHcdyYKyd8HOmBwK1cpw1YxdHoP0pFB6zHjkg=;
        b=pVEkGxi6h2nmICgJgoR79mDqxowppJ3VXTo3nVQDx8sMYJpAwuJi+LPCuVREbAK3kn
         8To6+q0FkDbgTCKlR0kccCNKV77Ja+IaMin7Q/eYVFDXzY31mrXV1g7vYDsxTuewVX1A
         fwLcRt9x7APgnuZzkuJgHUsMF417ZzdyL4Ok0F8y7nnjjpbq9+ryjUfUaC7Je5FvRGwk
         z5miwrmYDecxQiA4Jd5eyU7TZ3/DbIkrOjYM6w3yUE0hppitp4PncvmG++3ytx1eNlv9
         aQVhhxtMjPDYVO/29hfTOVL7h08GmiDvEaYTcycVDVZly1ZTncEsWrOksyj4zq8+yau+
         ZQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hGpgGqkHcdyYKyd8HOmBwK1cpw1YxdHoP0pFB6zHjkg=;
        b=J1Je/aTK5qljoWw/rjoc1uzHDAW9aqIh8SJcurh2e58VtFxGTXWthEx8no8uZtTeQg
         SswANpY38iN5zyObi4HRw6qNAuGqO53UL0EVrbLrO3fPQdHCZgkJPOBAOMTeM+KRayTn
         ZkQ2QWb63JgWmMDwDelR63bQpBpMk0kQsnj+cQyqkX2WuaqeCyVmJm5USE7a0uX9EJD8
         Uck08U19gQjVmp2+NyAnF3zL/LQRXXJPsmBkCAVIuwb/inD1Lbd8yBbPaAZvrPZsf3Zj
         4JIkE+uPGoULrb2nUFcL4dLnXShocJvkfPRutC7tEII9Dsrgnurr6lIjA6Ybtio7AWZj
         pW7Q==
X-Gm-Message-State: AOAM532zuZZvx40hqh9BXyxXldXA3SRGQYaGS6s/5f3re4wS6EYc0ECQ
        BnMH85Qc69Hnawz45I2UK0Y=
X-Google-Smtp-Source: ABdhPJwkg90FaMOEudr8iEJErW99F68tIaBJQ4sxkfLwMrsGvtkAjfLqKxiWytteaD5BmNqjrUUFnw==
X-Received: by 2002:a05:620a:13a5:b0:69e:e3b1:91a0 with SMTP id m5-20020a05620a13a500b0069ee3b191a0mr237791qki.5.1650445307873;
        Wed, 20 Apr 2022 02:01:47 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id e126-20020a376984000000b0069c86b28524sm1288810qkc.19.2022.04.20.02.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 02:01:47 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] wlcore: cmd: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Wed, 20 Apr 2022 09:01:41 +0000
Message-Id: <20220420090141.2588553-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/net/wireless/ti/wlcore/cmd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 8b798b5fcaf5..62388ee8febc 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -178,11 +178,9 @@ int wlcore_cmd_wait_for_event_or_timeout(struct wl1271 *wl,
 
 	timeout_time = jiffies + msecs_to_jiffies(WL1271_EVENT_TIMEOUT);
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto free_vector;
-	}
 
 	do {
 		if (time_after(jiffies, timeout_time)) {
-- 
2.25.1


