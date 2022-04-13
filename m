Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE9E4FF397
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbiDMJg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiDMJg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:36:56 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1FB2982A;
        Wed, 13 Apr 2022 02:34:35 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id k29so1267482pgm.12;
        Wed, 13 Apr 2022 02:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=axI++bZTorQ68RnKFapFMdbYs+LY5lkUw6gGd52Eyz8=;
        b=cG6JNZsqnPDnDHf65cTMzO06fY3BZVt95tmTDOTEbDypnGdlXqrjjuhsowlVW2SAx0
         SyVhudL999+nXLkrt9O7yLZDBrilaAoiLTDk/kVuIrGJlqJ4hWNaSa/D4bAPS9Twosb6
         BFB6FHoM3nTDwHbix20Yd7D4ocDTT5ojTYFhWoBGVUctGMpqKK90HI5Dn6xIRUbfl0vr
         rVTYL3ZwTQ/pH7TqAj45wpo5Bll8exw1ed3ZTeyLhasHD+ZMgb6I0YEnHs8nQAHiMPdR
         21HKpgUfg++Sc+my42o/bSWTCj5Suji3Urwh8zXORC3HIvV4zp21w0l9VJmn4DSVvwrR
         cppQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=axI++bZTorQ68RnKFapFMdbYs+LY5lkUw6gGd52Eyz8=;
        b=pf+cXZA9Hn6nPJ0bwE19UO2r5sHxY46m3M+d84+kU+hBn2TElvWLeTiq9u7QHj7pdR
         tnWAfpDDtKtmOpDDTCXpQ42a6v2qSJfvUYssPfWfWIHWN1U9CbxJamY6mkvRZB640CCO
         StjpfFXcTntfd34p0U7IBLW4mfOHfCVPYkH8GC7Ddf9aaqz85jY74o1Z5xiOVDBZt/QJ
         Ulq8w0mbadVh3jnVwangWmCbCrmJMjq5RBpluCR2qpw2B/0w3IKm2hovmiOs36WMbrsL
         PEcv16UvBw5F3eTyLEa3RvrWm6yr7UsGOM4r9cVH1UkVHjkehuDJ8ixZ/8uvom3M+FPY
         mjhw==
X-Gm-Message-State: AOAM532LXRLz9RrbTQQIPY4n768Wi3lr69IQJaPuXCYVj3Y/Q5S1KCNr
        Jyx8gUc/ERNtWIsw1w+bZJQ=
X-Google-Smtp-Source: ABdhPJySintkJ0CWzNZxWwn0APLgz+gwzZlIbWcJC4Z/Tc4HQLRMdeZZe56eiTVrAidtbgIxTtyHSw==
X-Received: by 2002:a05:6a00:198a:b0:505:91ad:782f with SMTP id d10-20020a056a00198a00b0050591ad782fmr23763413pfl.20.1649842475237;
        Wed, 13 Apr 2022 02:34:35 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id kb13-20020a17090ae7cd00b001c7de069bacsm2375434pjb.42.2022.04.13.02.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:34:35 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] wlcore: sysfs: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
Date:   Wed, 13 Apr 2022 09:34:31 +0000
Message-Id: <20220413093431.2538254-1-chi.minghao@zte.com.cn>
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
 drivers/net/wireless/ti/wlcore/sysfs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sysfs.c b/drivers/net/wireless/ti/wlcore/sysfs.c
index 35b535c125b6..f0c7e09b314d 100644
--- a/drivers/net/wireless/ti/wlcore/sysfs.c
+++ b/drivers/net/wireless/ti/wlcore/sysfs.c
@@ -56,11 +56,9 @@ static ssize_t bt_coex_state_store(struct device *dev,
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	wl1271_acx_sg_enable(wl, wl->sg_enabled);
 	pm_runtime_mark_last_busy(wl->dev);
-- 
2.25.1


