Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2970C4D40DF
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238622AbiCJFsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239633AbiCJFsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:48:15 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6499312D080
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:47:14 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so4282718pjl.4
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KFD2Eu7ySwZixX0vecWolWD4u1kH+iPN2NO5nEy2DUo=;
        b=kX8Uz1h+qJ7YQxiHFEjIu9tofBKnPDZEn0fFxXex5jMsx3frJSrhIDiqn/hSPpU8V2
         ZPUMtcCSIH/UVrGwnLLOsu5yiz9PwpK9IaCFuB/HZmEGBOskVDvf84LAhyWAp9AWB444
         Qx+Bu9mKrx0vEDcW2vZIqFJ3Aj5s7i6aUgcTREEjoJp9QQU0rQaLFct+ISFdxYWF3j63
         ilER4BU73oSYS2JZqrVZj250Q9wJzHTFdoY1nc/B8iHYADMfiTkcT+4YgoLBTMrr60hy
         cVDmyY/thuwI9x0tNYl1d8hZyTfD2D6uOpjajzCdmYZExVrAyTOV2ZUmebdotFwsfq3j
         QflQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KFD2Eu7ySwZixX0vecWolWD4u1kH+iPN2NO5nEy2DUo=;
        b=UbjzVzMd8u4srSJlIH923g1mhtaymSSI3arhV0e2s9FqWwAPzvcgvvs6SZP85oXb3W
         dJfZvyaQd2QuCCvQtrXAWW0fCOYcMLRetAutTb6x/HmLae9Dx3+wI2kHlFzJ+oSzjSRR
         INKrma/nM6pp/ZGcVsDaNfTPNo6l74MVGbUtMK9Qo9efKLIHaCyhS6/uCdnVNbexAkF6
         m8dgtqmvWWTzqvsfOT5pxb7YK9Mh//nfEYPox8TGCSzT/snyjrBHoymLB9Hdw4UzFr9b
         ArzrJTQEmGaJq3P2ymW/p9HgoeyH0CwPjwiBndSY3xFLvmar5zEccbLMHKR4tYgWak3J
         ffXg==
X-Gm-Message-State: AOAM533afhfDKD551fk8gsI5k/M0euPGcCkNHhSBh92w91iv7GTCEr4S
        pDlFf26DRhsmmfVTOG8X10o=
X-Google-Smtp-Source: ABdhPJxOMB79QKOHWSCyjW5SD3gpX3AIh5p0Fd61HQrg15zleuc4DbBgfTRA0TgclHZuqx6HuDelIg==
X-Received: by 2002:a17:90a:e614:b0:1bf:53e6:46a5 with SMTP id j20-20020a17090ae61400b001bf53e646a5mr14450907pjy.161.1646891233923;
        Wed, 09 Mar 2022 21:47:13 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5270779pfm.200.2022.03.09.21.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:47:13 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 03/14] tcp_cubic: make hystart_ack_delay() aware of BIG TCP
Date:   Wed,  9 Mar 2022 21:46:52 -0800
Message-Id: <20220310054703.849899-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310054703.849899-1-eric.dumazet@gmail.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

hystart_ack_delay() had the assumption that a TSO packet
would not be bigger than GSO_MAX_SIZE.

This will no longer be true.

We should use sk->sk_gso_max_size instead.

This reduces chances of spurious Hystart ACK train detections.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_cubic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 24d562dd62254d6e50dd08236f8967400d81e1ea..dfc9dc951b7404776b2246c38273fbadf03c39fd 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -372,7 +372,7 @@ static void cubictcp_state(struct sock *sk, u8 new_state)
  * We apply another 100% factor because @rate is doubled at this point.
  * We cap the cushion to 1ms.
  */
-static u32 hystart_ack_delay(struct sock *sk)
+static u32 hystart_ack_delay(const struct sock *sk)
 {
 	unsigned long rate;
 
@@ -380,7 +380,7 @@ static u32 hystart_ack_delay(struct sock *sk)
 	if (!rate)
 		return 0;
 	return min_t(u64, USEC_PER_MSEC,
-		     div64_ul((u64)GSO_MAX_SIZE * 4 * USEC_PER_SEC, rate));
+		     div64_ul((u64)sk->sk_gso_max_size * 4 * USEC_PER_SEC, rate));
 }
 
 static void hystart_update(struct sock *sk, u32 delay)
-- 
2.35.1.616.g0bdcbb4464-goog

