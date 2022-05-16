Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54979527CB4
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 06:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbiEPEZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 00:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbiEPEZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 00:25:08 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57AB183B0
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:25:06 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id v11so12976760pff.6
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4bDXGPqNCgyo9mP5knI0TyDmWOF8dGUajlMnVc+U4g4=;
        b=bouKb/gu2bbCkHZHuHopuKf9I/KU9jPt9ntnIQH5i9Xe/KtxT5rOs+29IciTwIn0Gq
         s6ciJ37jJETgwIjb+7PTZ7bKUIE3Pq9ruAPjP+XjDRQ9lEcH9kuN+NH9jNe4XLVGd00K
         5DTCq/2O4KL0O7LYyoBd/qmdcsWaGgCdEWQDzkFqvuesfVmStinPJf3LpWgRqapB7skJ
         1XCh2Famdh45TKOPi7fW2SnI2Fx1YXxH15Jum8ysAiunup0mE7Yc5J3U+CUdnLoX/uYg
         KnOktOv54AHPkp2IzYN9mv99kgkWleQ4ZG4FnPpUzBLlbTedFfQV8WR57Tw29b4g3y9D
         HKoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4bDXGPqNCgyo9mP5knI0TyDmWOF8dGUajlMnVc+U4g4=;
        b=IX1zpZl3ZQc3q/vOV5MojgdFIiMG/5zwGGjZZ5XVdThnA8ltywCfQBEmHcRIv2XIqg
         7Ib3oLLY7Wxp1WejSx/7raVe2u0idyOXiV1xGXWXhyV6XHuWu4VMRgZzD0KC0KYvZUFk
         BGlJM2NRo3uWvDPsmjVFFa9IOwcRS0d8YJtpuxlofzF2KE+W0TQkTMMjLsuhPQzNd+y8
         +vHRaJqh/HV//GWjmE9NsljeMy1Xe3T+RMpdYewBrABV9XGEaqzBcZuSyVeclWKeqUrJ
         Jl/G8hWqgRxP7m7zmjGZHEdBSojWokwFu0A2yCCRnWn1LaJzutoazFlHuJ8lrGESClwo
         /K3g==
X-Gm-Message-State: AOAM530Op7/2NRyoBndP/mWy7xqhuYKYFLNrNUwRs7fd4+jwPdDdnmGw
        bP20xWFyjWBCg6NzXcWC4nw=
X-Google-Smtp-Source: ABdhPJyD18422OxobYz3WW/pHQ1oOS8QOK8PvD3H3RiCbNNyN6gIsCPONra2gJWofUGlKumb2JPy3g==
X-Received: by 2002:a05:6a00:2444:b0:4fd:db81:cbdd with SMTP id d4-20020a056a00244400b004fddb81cbddmr15956040pfj.32.1652675106426;
        Sun, 15 May 2022 21:25:06 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:983e:a432:c95c:71c2])
        by smtp.gmail.com with ESMTPSA id w16-20020a634910000000b003f27adead72sm308403pga.90.2022.05.15.21.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 21:25:06 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/4] net: call skb_defer_free_flush() before each napi_poll()
Date:   Sun, 15 May 2022 21:24:56 -0700
Message-Id: <20220516042456.3014395-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220516042456.3014395-1-eric.dumazet@gmail.com>
References: <20220516042456.3014395-1-eric.dumazet@gmail.com>
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

skb_defer_free_flush() can consume cpu cycles,
it seems better to call it in the inner loop:

- Potentially frees page/skb that will be reallocated while hot.

- Account for the cpu cycles in the @time_limit determination.

- Keep softnet_data.defer_count small to reduce chances for
  skb_attempt_defer_free() to send an IPI.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ac22fedfeaf72dc0d46f4793bbd9b2d5dd301730..aabb695e25f35402bbc85602e1bb9c86d2fa209e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6654,6 +6654,8 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 	for (;;) {
 		struct napi_struct *n;
 
+		skb_defer_free_flush(sd);
+
 		if (list_empty(&list)) {
 			if (!sd_has_rps_ipi_waiting(sd) && list_empty(&repoll))
 				goto end;
@@ -6683,8 +6685,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 		__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 
 	net_rps_action_and_irq_enable(sd);
-end:
-	skb_defer_free_flush(sd);
+end:;
 }
 
 struct netdev_adjacent {
-- 
2.36.0.550.gb090851708-goog

