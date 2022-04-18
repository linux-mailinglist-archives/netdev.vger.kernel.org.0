Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA7D505308
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 14:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240127AbiDRMzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 08:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240237AbiDRMyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 08:54:47 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BC313DFC;
        Mon, 18 Apr 2022 05:35:01 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u5-20020a17090a6a8500b001d0b95031ebso6985564pjj.3;
        Mon, 18 Apr 2022 05:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BwBQWoszPE0WyBmS8eEzNdPIlmwnL6neVdJfMqZdeYs=;
        b=puV6g1yAwYY4foiMBzImH0StiMfyjOvPeJvoVgBw5FXrWP12gxeBSDewkBPPDL0UMP
         OnsiSeTUOtD2dt28KD7TjjUfMcvCct7teSPmd01Mi++avp/moQxkogI9938ZARZOvatB
         C4EScWnZgyPc73V+fzOmIWkXlnn8OLQTiVroOwHGt5yhPvFJkoyINAFS87YaVa3mGo38
         VEGR6u6xAArgzgf7QhRhwcvQ75y5W/MgnOYNyz4cJ+9uIeKR2I13+vuEW7Zr/EKeibDw
         shtLw3sOFM7PuhJQANQts3YHpCDaT3zWuqzqNXCIuetd6O1sjU+ogdCSvutPYNDmBp60
         ffKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BwBQWoszPE0WyBmS8eEzNdPIlmwnL6neVdJfMqZdeYs=;
        b=Xb8utgI4FArzRafGLJgLFuTd4xNzbFxyF3GkDn85H0HNmSTMcVbFTVeumyFDkBeDqX
         z4h78P2QFEzjjVW0zTkYWbbCpnWxI+6HGmebgQw8Yd8GavDG9UArZ65ixsgI8KrPWglo
         vRDlLuMGOrnugl5uYUj2ZPtuDEcwzKHuhpI+liiEF1GViP19Sstf7CmCRA0jXG3VL41S
         w4c5a/njDXV2GJXFVC9DZRhkl7QXcJXlCfX764R1EZbdribBq/6agKvlmjhjqJa3DH0W
         vWIgJrCgV+5Z7CJxvHHwQE734RR366P/jIR+9qnvfFmjWDdK+Q6ctS97tc5QKSwZwhvK
         ipdQ==
X-Gm-Message-State: AOAM533zzDQtTM6xXsKiJlKWNTduKJwwArHlLf3YTqM4TrdSJGTcHoo2
        E+IwuDTiqZR+eDYJpL7318U=
X-Google-Smtp-Source: ABdhPJzzDcDZsjDzFZEes1dI7IHd8sgP2uwsDyC+87JYg88yja6QtTIVb54SIoCzIBV43/NDyFAWCA==
X-Received: by 2002:a17:902:e9c4:b0:158:f77d:afb7 with SMTP id 4-20020a170902e9c400b00158f77dafb7mr6454683plk.143.1650285300765;
        Mon, 18 Apr 2022 05:35:00 -0700 (PDT)
Received: from localhost ([58.251.76.82])
        by smtp.gmail.com with ESMTPSA id y131-20020a626489000000b00505a8f36965sm12354645pfb.184.2022.04.18.05.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 05:35:00 -0700 (PDT)
From:   Yunbo Yu <yuyunbo519@gmail.com>
To:     oliver@neukum.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yunbo Yu <yuyunbo519@gmail.com>
Subject: [PATCH] net: cdc-ncm:  Move spin_lock_bh() to spin_lock()
Date:   Mon, 18 Apr 2022 20:34:38 +0800
Message-Id: <20220418123438.1240676-1-yuyunbo519@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is unnecessary to call spin_lock_bh() for you are already in a tasklet.

Signed-off-by: Yunbo Yu <yuyunbo519@gmail.com>
---
 drivers/net/usb/cdc_ncm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 15f91d691bba..cdca00c0dc1f 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1492,19 +1492,19 @@ static void cdc_ncm_txpath_bh(struct tasklet_struct *t)
 	struct cdc_ncm_ctx *ctx = from_tasklet(ctx, t, bh);
 	struct usbnet *dev = ctx->dev;
 
-	spin_lock_bh(&ctx->mtx);
+	spin_lock(&ctx->mtx);
 	if (ctx->tx_timer_pending != 0) {
 		ctx->tx_timer_pending--;
 		cdc_ncm_tx_timeout_start(ctx);
-		spin_unlock_bh(&ctx->mtx);
+		spin_unlock(&ctx->mtx);
 	} else if (dev->net != NULL) {
 		ctx->tx_reason_timeout++;	/* count reason for transmitting */
-		spin_unlock_bh(&ctx->mtx);
+		spin_unlock(&ctx->mtx);
 		netif_tx_lock_bh(dev->net);
 		usbnet_start_xmit(NULL, dev->net);
 		netif_tx_unlock_bh(dev->net);
 	} else {
-		spin_unlock_bh(&ctx->mtx);
+		spin_unlock(&ctx->mtx);
 	}
 }
 
-- 
2.25.1

