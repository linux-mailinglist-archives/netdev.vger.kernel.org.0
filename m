Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998E1612D29
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 23:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiJ3WCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 18:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJ3WCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 18:02:12 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FD0A452
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 15:02:10 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id p21so5363226plr.7
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 15:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TCMSGu8wCAuxi+YEaeqt2Nm6ljarPNoUCebXSLfB1Fw=;
        b=H1OQbWeLIKTClEI0Y18BCREEaUPyB4u9aov6gnRCwP3FMlWoDhoOyrQj9dTUw8f7Rl
         Lnc+rX7GLGtNIG7+mOPq5mJ218zFKXipmPROig7C1ec18KZ542PUt0JccxGsjh5HO1a0
         /z8kUmiSoWowwx6pl7CmnUz6U/WQmRT/NWSJGgn5Kjr93Rcz9iCWvN5ozoSLbcjCLLaW
         vQSLjW+N399VOHIFg9wUxuq3+NKkDgXzX84jiBotca1ufvXrHs73a7xFaaZLJbSrPgpF
         kI9+im4ilsx5ns6Kwr6KHXhyinzcJ9zfi1ofygZp48zSk618zFDCdZssNjQg3mnekR5P
         YICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TCMSGu8wCAuxi+YEaeqt2Nm6ljarPNoUCebXSLfB1Fw=;
        b=xDpqbhP5OniDH5iThTc2PzxgZ3KjveYUveXkr8vj/44CnXKPh5zOnRRY2QscXR8ig9
         Jf8x0vi507Aeh+cl1XWeB5R3gergfq+GqK7YwJ/3w4LziQenOBsthiJzDY/kHni8Dyr2
         qSs5neNVHfIzT4ZA52pqqnUUK3vX0NXzT/bCrZkopAm3EmoU3ymaZhhefiL28KxC0poq
         R9kEBg8cussNGSioSiPrAYlSdQzOaHncU1J1okxR+VDyR+W83HaA7HxWom6ZhRjap2lb
         rYd27uG8HxTAUtpC9F8PgSjCoCfbNtsQB+hNKwDN2+/44TO7oqmeHkn15jRlfQescg++
         fdnQ==
X-Gm-Message-State: ACrzQf0bwfjatuIx4knnJnFm0SphairjtYiq+QKOc42JiBRrB0wFrva9
        TutJ1wcErKixur8GuBbQ6aeIVA==
X-Google-Smtp-Source: AMsMyM4GdWVVzQsWPsWQHA0TiR71X3uUndA1mHuoEfLgekOPxznEf3CE25HyycOiKuLhhOXIat/5mw==
X-Received: by 2002:a17:90a:ca87:b0:212:d2bd:82f5 with SMTP id y7-20020a17090aca8700b00212d2bd82f5mr11677337pjt.203.1667167329708;
        Sun, 30 Oct 2022 15:02:09 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y3-20020aa79e03000000b0056d73ef41fdsm562852pfq.75.2022.10.30.15.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 15:02:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] eventpoll: don't pass in 'timed_out' to ep_busy_loop()
Date:   Sun, 30 Oct 2022 16:01:59 -0600
Message-Id: <20221030220203.31210-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221030220203.31210-1-axboe@kernel.dk>
References: <20221030220203.31210-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's known to be 'false' from the one call site we have, as we break
out of the loop if it's not.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 3061bdde6cba..64d7331353dd 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -396,12 +396,12 @@ static bool ep_busy_loop_end(void *p, unsigned long start_time)
  *
  * we must do our busy polling with irqs enabled
  */
-static bool ep_busy_loop(struct eventpoll *ep, int nonblock)
+static bool ep_busy_loop(struct eventpoll *ep)
 {
 	unsigned int napi_id = READ_ONCE(ep->napi_id);
 
 	if ((napi_id >= MIN_NAPI_ID) && net_busy_loop_on()) {
-		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep, false,
+		napi_busy_loop(napi_id, ep_busy_loop_end, ep, false,
 			       BUSY_POLL_BUDGET);
 		if (ep_events_available(ep))
 			return true;
@@ -453,7 +453,7 @@ static inline void ep_set_busy_poll_napi_id(struct epitem *epi)
 
 #else
 
-static inline bool ep_busy_loop(struct eventpoll *ep, int nonblock)
+static inline bool ep_busy_loop(struct eventpoll *ep)
 {
 	return false;
 }
@@ -1826,7 +1826,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		if (timed_out)
 			return 0;
 
-		eavail = ep_busy_loop(ep, timed_out);
+		eavail = ep_busy_loop(ep);
 		if (eavail)
 			continue;
 
-- 
2.35.1

