Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F79C527CB7
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 06:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbiEPEZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 00:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiEPEZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 00:25:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB2C1839D
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:25:04 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n10so13316361pjh.5
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j1na0dbzzw4voQbMWC5mAjFj7mR/JqvFVI07U9sF25w=;
        b=ERuzkeSF/O3LNVloKe6bT9MNG9O69IcAOejN0UbCFG2f8z4umfb/z4Mzcqyy72niXA
         vF3m64x1SEEkHixuwBf5/0tXl8sy2BH0id5XJ8pQfFXcCZujeim0Lx5sT4taxCORsyf2
         ojdmxrZAF7kWVCcJAMxtflpvIpUEAiVXpIMO6xfx62ZfE0FL/dU7nD9DcFYktOmHK2XM
         GbST5Cr16jNo7CfWK9nq3y7ZUt21yxZVjZEXesLCIBQFodwbpSksJw1KysDB+LhznQYU
         aqZ1U8E3AfgdXCKWf+YjSViO4wz34Ho0i8pipw/clTngpB5TXsoEu5DbWIjx6DqAE+Gz
         bQpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j1na0dbzzw4voQbMWC5mAjFj7mR/JqvFVI07U9sF25w=;
        b=nGo8DBMSEI0yCODoit/LpOemcTHY/Lf41pzZXSXROHjf7B52hpF8o8VJ7TKS65TKPk
         AVSiWaUjMBCmgbKe9WI22UP9DFJ2rqIZPD7i82kIrNUINlDool9H+vZrV6jpvUNIjXyL
         9xk0YksiJb4I/FOnD5+ZV8GnfQDByuwApIxPYtiFlDThWjHLhuu2wLwf5Fuhc02yVHUa
         OpXaQiZzBNaZzJGw/TWc4EEPE3ff4tnFBJY5DzYcFIOFQB7IuLlmcExooTDw+DDqoY/e
         HRUPauyXhFuR9zrU3B57/6AzzzlRlo/y9RsGmYgsA506NhcI84UauRpdi+al14Wa4L0h
         iflQ==
X-Gm-Message-State: AOAM532XZvOVteW5JtjjM0FCKNufNEqOw+HMkPIPydkfCR+OlB3CCj6Z
        PGuxmQ1M0CFiwgWSTGOoNXmYNp1+Dhc=
X-Google-Smtp-Source: ABdhPJzqaGU6dqzJOsTyKlRMuQHnFyveU19iZ6NbPrE5byQQBIEMbiUlFkeF8EC/OgpkQZjX2dsKTw==
X-Received: by 2002:a17:902:f789:b0:14e:ebbc:264b with SMTP id q9-20020a170902f78900b0014eebbc264bmr15417031pln.169.1652675103625;
        Sun, 15 May 2022 21:25:03 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:983e:a432:c95c:71c2])
        by smtp.gmail.com with ESMTPSA id w16-20020a634910000000b003f27adead72sm308403pga.90.2022.05.15.21.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 21:25:03 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/4] net: use napi_consume_skb() in skb_defer_free_flush()
Date:   Sun, 15 May 2022 21:24:54 -0700
Message-Id: <20220516042456.3014395-3-eric.dumazet@gmail.com>
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

skb_defer_free_flush() runs from softirq context,
we have the opportunity to refill the napi_alloc_cache,
and/or use kmem_cache_free_bulk() when this cache is full.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d708f95356e0b03a61e8211adcf6d272dfa322b5..35b6d79b0c51412534dc3b3374b8d797d212f2d8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6632,7 +6632,7 @@ static void skb_defer_free_flush(struct softnet_data *sd)
 
 	while (skb != NULL) {
 		next = skb->next;
-		__kfree_skb(skb);
+		napi_consume_skb(skb, 1);
 		skb = next;
 	}
 }
-- 
2.36.0.550.gb090851708-goog

