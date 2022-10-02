Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC955F2138
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 05:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiJBDmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 23:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJBDmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 23:42:03 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B9043E7F
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 20:42:02 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id b2so2217423plc.7
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 20:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gaul.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=ZeXdtwy3Yv/zxts7snaA6HbOFxTLg7KLB5BOsTPDQlY=;
        b=bnxv3zmOL8V1Wkqownu5zi82FiSpJOCNNuVktBdGGvv0XTPAv+Na6QwG8kz+Jo02Ox
         3pAys57iORcYqub+WU1TiiwlQbZk+SRA3fjKDB95+rw339i4ErHFuv64ULyMEnJ+KFoy
         BWAQr3jdZr3CNJ0BLpJLqXZMZLLp4+dgWqaFSX5d/WRGlQzBW+LV4Xsp6tuN2lm6TJHt
         LYp/rlrVI96GmbJaN2biFpZHPpp4zADLqioQ8vtfIaLIkTUlvUmKwCsGhOaQ/ZUJgBZJ
         f0JG8xSEF/fmSOARfAd5Dgb2N+A31pytLcH2sl9RIVbvo8MVuvjXYA4P/+0bSiK/NpKu
         CZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=ZeXdtwy3Yv/zxts7snaA6HbOFxTLg7KLB5BOsTPDQlY=;
        b=mpt7TxWkfgTSa72rYqSJytKMAdIs0vSe2C2JXBFMn0Ef/fQAOUZfCMWjV0IsdQOx3K
         F2Krvg0yvivntcYNbhEwYXzkZb3TaZqfclYwBBlg5EtduJBFs+cmZBaoMxTt/cK/1x1b
         7aGjkAUswWX6VUqIMbnrqrLerxI3TxmqIv4V1X4OfoO/pT4OeFI1YHIYqKMv3w1dQp/M
         zvp38jDuyt8k6JvZsKhoeDUfcfIPPfjdEfgNnu68tZW64HAbAw0QNVDh1fnQpzN8y6tw
         iCa4VnsBlJAeNJFOLssmEurXTCSMJ5yVBKkgP7cnzhlGw98k7L81HVsuOmGDWd3YdltI
         voVg==
X-Gm-Message-State: ACrzQf36OjAeX38VQFU6dKA5Hx1+WUIH6GgqAVwaVBXJgNl168pRvvMq
        AC0I5DeZEKSTxOiEsbiSmqY2fP5RhenVy7p9
X-Google-Smtp-Source: AMsMyM5jug1n8IbaHNoeJLbyRJCA+TgHWkR5/6h7KmYybBajQ7J9cPGSCy2j5SjQanyNggmg/2IwLA==
X-Received: by 2002:a17:90a:f991:b0:20a:6ec9:8d7e with SMTP id cq17-20020a17090af99100b0020a6ec98d7emr5961752pjb.67.1664682121670;
        Sat, 01 Oct 2022 20:42:01 -0700 (PDT)
Received: from watson.. (58x5x227x72.ap58.ftth.ucom.ne.jp. [58.5.227.72])
        by smtp.googlemail.com with ESMTPSA id e12-20020a170902d38c00b0017b5e1f486asm4576699pld.211.2022.10.01.20.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 20:42:00 -0700 (PDT)
From:   Andrew Gaul <gaul@gaul.org>
X-Google-Original-From: Andrew Gaul <gaul@google.com>
Cc:     netdev@vger.kernel.org, hayeswang@realtek.com,
        Andrew Gaul <gaul@google.com>
Subject: [PATCH] r8152: Rate limit overflow messages
Date:   Sun,  2 Oct 2022 12:41:28 +0900
Message-Id: <20221002034128.2026653-1-gaul@google.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My system shows almost 10 million of these messages over a 24-hour
period which pollutes my logs.

Signed-off-by: Andrew Gaul <gaul@google.com>
---
 drivers/net/usb/r8152.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 688905ea0a6d..e7b0b59e2bc8 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1874,7 +1874,9 @@ static void intr_callback(struct urb *urb)
 			   "Stop submitting intr, status %d\n", status);
 		return;
 	case -EOVERFLOW:
-		netif_info(tp, intr, tp->netdev, "intr status -EOVERFLOW\n");
+		if (net_ratelimit())
+			netif_info(tp, intr, tp->netdev,
+				   "intr status -EOVERFLOW\n");
 		goto resubmit;
 	/* -EPIPE:  should clear the halt */
 	default:
-- 
2.37.3

