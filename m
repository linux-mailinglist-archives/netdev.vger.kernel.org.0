Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C384FB169
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 03:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239728AbiDKBiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 21:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiDKBiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 21:38:23 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF2543EEB;
        Sun, 10 Apr 2022 18:36:10 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id e22so12133277qvf.9;
        Sun, 10 Apr 2022 18:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e4GkgwH8Cf5+Xk57d8WjJ96d7p3KRonjzQ3FCZd7W90=;
        b=H3H6brXvjJkdtmxaq5yq+JtfipPNGEp5xhxyLrzDZGHtfM2M4F0x//PiDTwU1MFYg8
         GyoSYDU69O5c0DQivLQr7QUUdlTKqC0COELV0NJdlSMXzKyF3Psc6fbXio6hsPezCBZT
         DbtTe6BvGE6l0VdHKc9T9FlQ1TjBQ5c0B6uGudeiz6bPHB+CBd8TAIEzLw1eTgxEiVdW
         FiHweF+vmHx5UAOd48Gg/OwW4UY6/7qm01ArhPS6V9XQSc9HcpFKnVgbfgz0tPOgQcr2
         gFXKFfafhbCjRl0iEIrjPhimGeT2IaSsjewEmHsYLBkrfmfdVfxZRfQVOoR/+5E1XOpf
         fa5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e4GkgwH8Cf5+Xk57d8WjJ96d7p3KRonjzQ3FCZd7W90=;
        b=HVnTN/XMbYliZP/HsnFbxKnmFNJfHMKUhJzsUW4yoSVUUzLpI9b4/8kESGBB6mdUNW
         19oVQG8OdkzGV5G3Ndibumf5XION3yS1ITkrJ3/mE+GJXctDBcQHkRtVoI9FWShgt/6i
         zQLEg2ZthTh0Dz6/dHyKUcBMyaNzrTmZGiYVDKOJ30VeqWdsoSTxaczCOkQEv6zpi7TW
         mBfjV/BWChg4G2r9qNWkkw+oO85q6bFzQJAucNlZsVCJ919wb3/0gQRo2W5AieGwB4jj
         jp57tqYl+bE0kQ90C3+M8IqMo7XRXT9524N5UCdvFL12F2XnPBYk7oNlBjBs6ychAxIA
         YT1Q==
X-Gm-Message-State: AOAM533PpQrk6CPvqyUeu+D9sA12pOzwwGd2uDuqM24p37YATMCFRKf2
        cgSPRG6w4WwUBzHnoD2hH6iCKlih3js=
X-Google-Smtp-Source: ABdhPJybI46Cuunj2Qqdpk7JajdoBLPu6o8OSbbeo/0MMW1NkzzSrVFw18O8k532OEnnoZUYXh9WNA==
X-Received: by 2002:a05:6214:e4a:b0:444:28a7:9fb7 with SMTP id o10-20020a0562140e4a00b0044428a79fb7mr10580217qvc.30.1649640969374;
        Sun, 10 Apr 2022 18:36:09 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id u5-20020a05622a198500b002ee933faf83sm1101121qtc.73.2022.04.10.18.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 18:36:08 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     merez@codeaurora.org
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] wil6210: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Mon, 11 Apr 2022 01:36:02 +0000
Message-Id: <20220411013602.2517086-1-chi.minghao@zte.com.cn>
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
 drivers/net/wireless/ath/wil6210/pm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
index ed4df561e5c5..f521af575e9b 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -445,10 +445,9 @@ int wil_pm_runtime_get(struct wil6210_priv *wil)
 	int rc;
 	struct device *dev = wil_to_dev(wil);
 
-	rc = pm_runtime_get_sync(dev);
+	rc = pm_runtime_resume_and_get(dev);
 	if (rc < 0) {
-		wil_err(wil, "pm_runtime_get_sync() failed, rc = %d\n", rc);
-		pm_runtime_put_noidle(dev);
+		wil_err(wil, "pm_runtime_resume_and_get() failed, rc = %d\n", rc);
 		return rc;
 	}
 
-- 
2.25.1

