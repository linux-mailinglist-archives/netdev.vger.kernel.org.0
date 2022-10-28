Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95378611C92
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 23:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiJ1Vnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 17:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiJ1Vnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 17:43:33 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5487424BA83
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 14:43:33 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l6so5765648pjj.0
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 14:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MWMQ1OOnzvPZ3+daCqGm09tO9BG/1DEjXdpVAErFn0Q=;
        b=TXcQvK4YM0rjh/gPGX+lSDLs/Ke3EOgKgIbxYBPbl5Bwlrr02MTRdmLdtc8qwoAkJM
         ZnTfMgGMHMSCWpxIVjkrwLMxMq7Aa5+X1Pw5Y0mYN4QS4pzHAUEb9rTS6GVTIGd9dnBw
         IEsmLKUjSwfELvRFwzBYFYfvUtbWTA7owJNYHUiYBArJRyJkWoP5yZp0qWjYQnpqE72K
         iIstp90EbFOvVeQZqEjtyiCUPVnAoOcZI/gUcdUuldBpo/+sb4MubpdLhHuez1mWbXOy
         e8nwkXwTzG56g5jJQZTktuB6nSknxKEWVF1c4LUCvz1ZBmeyPV3XQR7dc5pBLSjfIamR
         QWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MWMQ1OOnzvPZ3+daCqGm09tO9BG/1DEjXdpVAErFn0Q=;
        b=TTZl4IKCW+giGivN3Rw4dxoTAFLfcfdRfRmgYUUltW0ZzUQb1BU8OPzUplVlxZJysU
         LrithKVPWi+VX8jBSyjMqVH6l6s8hKrZE1L1V2fsMCTBpNP+7x5CIPgXX02PUSiofRJD
         8DKZx0pUN2dWD5SPuJVX6i9GiKJs08gkN1V+j+yXFjc8pDrs1+Abpedb0FnDQ/st3ImV
         m514SpJrTMR8O3EUh3NjuGs/FxvEIkrir10uxz/StV22ZX0DvtgILFXHJz8mZ8JNu8UY
         dYSChEaWxYdNTrrwcx/uDKPmzUj9BAlvI8jaR/IOa6UIjMvA+5EcRNJh7IgVp3DAAzja
         q9lQ==
X-Gm-Message-State: ACrzQf2YpTXv3hpQNEZ8STHBrsqo70yKfuCD/NZ+v7ITgrTKkly0N60u
        ExIck880Y02VNqdOmdHpLnkekA==
X-Google-Smtp-Source: AMsMyM4ALHXXyzTJZdtflatKsE5PnlDraTKb+GtfJUTBAvTNJQYFGW14m4j9O7FYbExuhd9Q4TUU6Q==
X-Received: by 2002:a17:902:e54b:b0:186:5fba:13a5 with SMTP id n11-20020a170902e54b00b001865fba13a5mr1073947plf.173.1666993412746;
        Fri, 28 Oct 2022 14:43:32 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090a1d4600b002130c269b6fsm2993855pju.1.2022.10.28.14.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:43:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] eventpoll: move expires to epoll_wq
Date:   Fri, 28 Oct 2022 15:43:23 -0600
Message-Id: <20221028214325.13496-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221028214325.13496-1-axboe@kernel.dk>
References: <20221028214325.13496-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes the expiration available to the wakeup handler. No functional
changes expected in this patch, purely in preparation for being able to
use the timeout on the wakeup side.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f53bb4ec9e91..8b3c94ab7762 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1765,6 +1765,7 @@ static int ep_autoremove_wake_function(struct wait_queue_entry *wq_entry,
 struct epoll_wq {
 	wait_queue_entry_t wait;
 	struct hrtimer timer;
+	ktime_t timeout_ts;
 	bool timed_out;
 };
 
@@ -1825,7 +1826,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 {
 	int res, eavail;
 	u64 slack = 0;
-	ktime_t expires, *to = NULL;
+	ktime_t *to = NULL;
 	struct epoll_wq ewq;
 
 	lockdep_assert_irqs_enabled();
@@ -1834,7 +1835,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 
 	if (timeout && (timeout->tv_sec | timeout->tv_nsec)) {
 		slack = select_estimate_accuracy(timeout);
-		to = &expires;
+		to = &ewq.timeout_ts;
 		*to = timespec64_to_ktime(*timeout);
 	} else if (timeout) {
 		/*
-- 
2.35.1

