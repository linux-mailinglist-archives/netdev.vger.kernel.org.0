Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69969508465
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 11:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351341AbiDTJFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 05:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbiDTJFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 05:05:40 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBD71CFD7;
        Wed, 20 Apr 2022 02:02:54 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id b189so733319qkf.11;
        Wed, 20 Apr 2022 02:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7vkbjr0KsMnyoLFY4TxzFtnA38MiyiwfdDW2hTdx3F0=;
        b=RlRagmqTZiLIP38XTW4bcnrQWAodzYi9SfXvUF4tfXHpakpxAXQUxjaEYtQMI/RvhI
         MMFxluFkgQiRX/k6+TZOgsPoKH5kVdRZVPQUeWXjhRDJ8G5VUI9ShkUQRyT2Y5nRgdmb
         zceZyZNj3+GH+8R4LjKEgaf5zyt3d4Rl8DK6gQ5heEKIQV067EXFDEqCtlDP/NP9qOVX
         t8LnSff6nuHapDQywycWsW/DNKPK5/jRkgxVoB5jIDggDDMd26SsAiAyYMPAbC8bVmIm
         XM1SWrZXiQjSsx71vxhHfHFYEYLu2PGawYXzTYtMXn+2tpMZdwSTXbO0zJO+mRSGqDYi
         1OLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7vkbjr0KsMnyoLFY4TxzFtnA38MiyiwfdDW2hTdx3F0=;
        b=qY3Etp5m4MmMSBBESm4i8IVVW+MWYkwhY9H6sgQ8hfUrckBfySbz5j3LLZvo4Zu6mW
         Y5AMbqRDWaE7vo4kU3ZweZSp96I2Kh5Ms293zo0qIQfm6DLjKRikDOquc9etmJSvT9p0
         IYdjjm5wJk4IUQRmXVkaZZtMZCCXzKK30sblkDLMnUoVPh0o2MC+/VS2nj96I4cBhJRg
         53x87D7sDOXkM0zTYLJsWa6f8PoAXY9+b2vZO1EYSwNI72ewBYbvBzKu/FsLAzbpJEbh
         imnDpDgU5Lfy8Bk5Bk8t5uulXLzFrfRM43ljcoTBJbes+m7oWMJfEuusMQ0oyLUrd6eY
         6mkw==
X-Gm-Message-State: AOAM531fRyA5KRZnyHAk25IaxRPlcAjjMPIxvtdB4bJTbByX7CA/kOZP
        3wEz60iO88bUMoZqNpimbx0=
X-Google-Smtp-Source: ABdhPJwEdrKOFX+icFTFSsUd4MMDKCmj3gGNeSQjB45kob95CuAbUaZJ13FIjLEYNABilnIb/deNpg==
X-Received: by 2002:a05:620a:4621:b0:67e:cc42:42f0 with SMTP id br33-20020a05620a462100b0067ecc4242f0mr12099772qkb.131.1650445373960;
        Wed, 20 Apr 2022 02:02:53 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id a76-20020ae9e84f000000b0069e80daa17asm1276731qkg.113.2022.04.20.02.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 02:02:53 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] wl12xx: scan: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Wed, 20 Apr 2022 09:02:47 +0000
Message-Id: <20220420090247.2588680-1-chi.minghao@zte.com.cn>
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
 drivers/net/wireless/ti/wlcore/scan.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index 29fa51c37e88..b414305acc32 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -53,11 +53,9 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	wl->scan.req = NULL;
 	wl->scan_wlvif = NULL;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
 		/* restore hardware connection monitoring template */
-- 
2.25.1


