Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC09654202B
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbiFHASe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588650AbiFGXyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:54:53 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972081B1768
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 16:36:30 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r71so17350438pgr.0
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 16:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TzqlTG+dkbGRgcDOdoMCanYm9tvWN+0OWga3Lc1Z7EE=;
        b=aAW+P99cNuy37R5+XjtK7wBExFrt003gJFmglwdw9jJyQP5WzwmPNL4O+ukPFC8squ
         KdYDR/vtIYjKpHpsDh5Q8lV/Ww7D+sA/BLlQ5EPmoDzgXOIWBJWSWAd5SkOLhk9SF63h
         Zy3nS8lSj1YeNkqYKWuuay6ELQKtes6Ol0J/oJfm9WbrgbaPn/pfeb/6jsrRAt/dTilY
         XWf5JvzlvRYu1wdumVdHNy4icCjb+ZNauwTd9WTW+Jai0tSVg+FoPCI9rJbHvLjPeYTx
         O01D6n1kNb+0QF3CyxVi5mlZA/I2MzN51HKR/+/4Pf9gLO/M43e+jWxmh/xAI/NSTz0A
         HgCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TzqlTG+dkbGRgcDOdoMCanYm9tvWN+0OWga3Lc1Z7EE=;
        b=Ay5KQvoiL/d9SVWsibmbZQdHSuY4eCrhvKvIOaKx1P9orThwmTLkkwp3AzLeBEN8K7
         WkgvCCDYsssHIUjWUzvXH2l+B7ISUQRggFWNkvG6zsdFCoTgBlMWi4dQfCFa24/nnlnR
         AaEP324XPpIzFrD0Md7s8T6ukylsVUcTFvS1FDGGpT+ma9/mfFkc1FtxAHMS5dRSjNsT
         s+rQ++F3Jkip/tBe8jgE7fG0N5QzQfeIWoeOlPW9QbDeWZpYbJT+jPzuvdDnte/KUxtO
         gyuSrHtP5Ftj1om0+TbtYUjoxCgxfGkoflwuAlYxiSENaL9iTeH/h1wCLY7Dszdmbt9h
         4AMQ==
X-Gm-Message-State: AOAM532eXqCsnSQNsfkSntKPOtEwMRW4JKXzWa+Zwe3xxNxqxFsRQDUc
        L1o8GGm6T+PE4Byv/0AWav7jO3+mrE8=
X-Google-Smtp-Source: ABdhPJwhJ7pMKpFnuhPV2jNJdD/JnI1k2sUUEYgzHYSNJigCMtegDzOe/6cybchx9MeZA9tFQoPENQ==
X-Received: by 2002:a05:6a00:2386:b0:51c:3ca7:b185 with SMTP id f6-20020a056a00238600b0051c3ca7b185mr5556519pfc.8.1654644989995;
        Tue, 07 Jun 2022 16:36:29 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id u79-20020a627952000000b0051ba7515e0dsm13550947pfc.54.2022.06.07.16.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 16:36:29 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 5/9] wireguard: use dev_sw_netstats_rx_add()
Date:   Tue,  7 Jun 2022 16:36:10 -0700
Message-Id: <20220607233614.1133902-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220607233614.1133902-1-eric.dumazet@gmail.com>
References: <20220607233614.1133902-1-eric.dumazet@gmail.com>
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

We have a convenient helper, let's use it.
This will make the following patch easier to review and smaller.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/receive.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 7b8df406c7737398f0270361afcb196af4b6a76e..7135d51d2d872edb66c856379ce2923b214289e9 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -19,15 +19,8 @@
 /* Must be called with bh disabled. */
 static void update_rx_stats(struct wg_peer *peer, size_t len)
 {
-	struct pcpu_sw_netstats *tstats =
-		get_cpu_ptr(peer->device->dev->tstats);
-
-	u64_stats_update_begin(&tstats->syncp);
-	++tstats->rx_packets;
-	tstats->rx_bytes += len;
+	dev_sw_netstats_rx_add(peer->device->dev, len);
 	peer->rx_bytes += len;
-	u64_stats_update_end(&tstats->syncp);
-	put_cpu_ptr(tstats);
 }
 
 #define SKB_TYPE_LE32(skb) (((struct message_header *)(skb)->data)->type)
-- 
2.36.1.255.ge46751e96f-goog

