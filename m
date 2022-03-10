Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0064D3E19
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbiCJA36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238989AbiCJA34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:29:56 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9096C123BE2
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:28:56 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id o26so3331572pgb.8
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 16:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KFD2Eu7ySwZixX0vecWolWD4u1kH+iPN2NO5nEy2DUo=;
        b=XI2YFpB9SJxDvX/WSsyj8K9ZtY2WKiTrbcibmhtH2Mjohj2dTpCOftXbi6ObbW/Q+v
         F1OIZRN3LL/8HgsQDBJuBdA1KX0hShqlUYSggrPa3k8yHcvjAIj5HdOh4VGWcm5K/zGO
         JwfIm9Oe3GRi5jvDdAPY4PiiSAVvn77eiLUuQq1Y3VMKYAcIGyZODGRdj8bToNPax7H2
         fGiSJzAlqYEErzJ3hsK9SxOsibdcU6fNw+RlVpBIp8veTN0FBE4apotdv8zGZ3vr0KSp
         XGZHVdt00fHpOV8XxC1G9KCJaJx7RPnWpffCkc2CeALLwOlOa+9CHYImPHWZS/a7V+xD
         VCtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KFD2Eu7ySwZixX0vecWolWD4u1kH+iPN2NO5nEy2DUo=;
        b=C6OMGSjafd1cLnMrTLUmyaAQkmcPAwdlnkb8eKpK9cldQooZcNflLzLsbUdwWFKBPE
         HyXDgrmlyGEJWQ/5m3pdA9NerKTrDxaLZyZSfUVk/SUKbMPBy0bWCsc7wvWrVfwOlRrN
         RUjhRui49hptfPf0xL8c8+P91zpA8ZY2GfRZiZJdEzaXaRB+GyMUBs93+qbGBKdubRPt
         e3z71hudiJgGaL1qG9bma/3e65vlNSDtSzxobYKuQvx3G6h15tWXxO58eERfMgLOSNZE
         Bv7EP2l430NZ9WBVNiBn9ZTtxrYIHwpaoayygdzg2/Yv09zYPh1RpiLc2cHzlfmq4Ywq
         bM9w==
X-Gm-Message-State: AOAM533c/HNG9fcvubz+n2WMc/p6htxdwEBZe/7fmrdYPrzv8AJOvbZ8
        XqC6GaVfiaQ5EE3V86YsRkg=
X-Google-Smtp-Source: ABdhPJymjFeD/FehjCBbpTDcWPeTlIk2vvadqvF7lmQl148UuFrZiNpreY6HwFZw//gI1TH3Ca/fWA==
X-Received: by 2002:a05:6a00:2352:b0:4f7:752d:dd09 with SMTP id j18-20020a056a00235200b004f7752ddd09mr353067pfj.22.1646872136137;
        Wed, 09 Mar 2022 16:28:56 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id nv4-20020a17090b1b4400b001bf64a39579sm7557660pjb.4.2022.03.09.16.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:28:55 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v3 net-next 03/14] tcp_cubic: make hystart_ack_delay() aware of BIG TCP
Date:   Wed,  9 Mar 2022 16:28:35 -0800
Message-Id: <20220310002846.460907-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310002846.460907-1-eric.dumazet@gmail.com>
References: <20220310002846.460907-1-eric.dumazet@gmail.com>
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

