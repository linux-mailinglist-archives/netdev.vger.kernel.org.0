Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF08D439C07
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhJYQu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbhJYQu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:50:56 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF75C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:34 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id r28so7183162pga.0
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=653wW3nxLwDc1GqFAR6Umq7l0o7whuAkrBQPp700DBU=;
        b=mnN25bki8goIr12D5uRIkW40mhYYrMTCu97J5Gei1yE4fCGG/zlzIIlazOWMjoXlUx
         FfCXWP5lqYRm3tnJ7B8Ig5SMqtGUjIukxNj+wW8kZObNNCexuYrqYuGA2LwPTPj2apL0
         MmARvWmMTErAg/YWe69P6+3O96BLz/gG5CxzS+dM3ryEHvS7/t9A7aigGfJmUlsYMq/L
         seyA7kLZiyGK1IGOtiHp+A96n2k8CGWeBBJ++y+zE1IH8jU3+dNaLF/tZyV6yQbCRJJh
         LOvp/j7taLQ77x5I7xlxDYF8MMp7nTHAv8ez9X+CFt/sbSCwf3FE9Ve8mK1DzcaaZqe1
         moPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=653wW3nxLwDc1GqFAR6Umq7l0o7whuAkrBQPp700DBU=;
        b=xbWyx6CUmvPB8lfGtqIWVyOfAf9nWGThVQBSLywc27/IxaenQBmJeJmJxqB6LjQZJx
         doyXKpr8yUyZxCfktyjhvaMeX0leDb5y59/DilV6gcSPfBYBZ1/NGRK2ufs4CQZEcvf+
         QMG6IXAUV43nOdcJQawVp9Qq8X/iXQSJouT0jSlluOvpt8IoEy7TnraQHuNvnwq7nYIV
         CvMVozGHmYfKFYABW1YoM9B+0jYWS4TiEhaabeRDoAm/o59HKSAn383+utWzr3/VaKkE
         3eyh1YHyJT9qnpchaQw3NpQfqIrxXVZWVrv8Ks5NfiTd4kyyhPSlnKWx6aEX8Sl3oOKq
         ztsA==
X-Gm-Message-State: AOAM5310dNbD2IyfvI5ldjbQ/rngJLgrVuwDjDW1j83XyHS3LbwOsTA4
        LfemMO063OcVbm3RDEkRTGY=
X-Google-Smtp-Source: ABdhPJy0VQi0aTaWTkEr9RgNG//F4TZPWr+foXONB33NyuVM3xnKyJWdF3kvnKqNRGy/pDcaFdivWQ==
X-Received: by 2002:a63:7542:: with SMTP id f2mr14562623pgn.147.1635180513689;
        Mon, 25 Oct 2021 09:48:33 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id b3sm17052582pfm.54.2021.10.25.09.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:48:33 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v2 net-next 04/10] net: avoid dirtying sk->sk_rx_queue_mapping
Date:   Mon, 25 Oct 2021 09:48:19 -0700
Message-Id: <20211025164825.259415-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211025164825.259415-1-eric.dumazet@gmail.com>
References: <20211025164825.259415-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sk_rx_queue_mapping is located in a cache line that should be kept read mostly.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 include/net/sock.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 99c4194cb61add848e3a35db0f952c4193f5ea1f..b4d3744b188ad869b4ec55f78e04236b710898de 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1916,10 +1916,8 @@ static inline void sk_rx_queue_set(struct sock *sk, const struct sk_buff *skb)
 	if (skb_rx_queue_recorded(skb)) {
 		u16 rx_queue = skb_get_rx_queue(skb);
 
-		if (WARN_ON_ONCE(rx_queue == NO_QUEUE_MAPPING))
-			return;
-
-		sk->sk_rx_queue_mapping = rx_queue;
+		if (unlikely(READ_ONCE(sk->sk_rx_queue_mapping) != rx_queue))
+			WRITE_ONCE(sk->sk_rx_queue_mapping, rx_queue);
 	}
 #endif
 }
-- 
2.33.0.1079.g6e70778dc9-goog

