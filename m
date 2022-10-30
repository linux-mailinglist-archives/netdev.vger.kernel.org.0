Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21BD612D2B
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 23:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiJ3WCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 18:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiJ3WCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 18:02:16 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EABCBCBC
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 15:02:12 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id 4so9270028pli.0
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 15:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7XieXpcJrzhapQHtWCNoW0rQy5yiKhkq34SDOyw0xw=;
        b=Z2rp9mxaTzm5Kh46RSwGk7G6rZY/KQhbeDA2IAjzJGp/KbgOvSg7hhvjOqyULqd566
         //TWc8mDkHbQ+DYXM0UrXa1OFHB+kcFlfhSr5EpBPAZ4BenGOAV8UQytYF1B2Zu15GZW
         5wSN+m6knpruLvqwjn/CbyS0LcSLGDOxBx2XJBPBYD36NcCOwgnf8PE0K83/qoHEWITB
         CoB+1QFBWq2K9ejFNlUmTFH4z4jR/GN1EKDtyv0QkZWRvmvLrhnWvunYux57608rO2K1
         NyfP1zPcMuWKUItcpD6jYYjGRh9hLNQQpDbfHBw2vNSNUUlLYIpcgwApfo0fwBwOZ87a
         d44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+7XieXpcJrzhapQHtWCNoW0rQy5yiKhkq34SDOyw0xw=;
        b=erveMNtisTm6ZiZo3JKvipcYY6GPK8oR2XdSoAneRsba8TBTDiuJQoPSks8ABHd2bq
         5sKAqpIvdajldO6bsrMefIRfb6NG2M+rZSxamfAaJaSgstjv8rGzOYxFN7E8CQhxTLM4
         whWXQ9X7mDyr+3kYIEZtN+s0FfgsjgTkOwyKKUrMxnNTYTH/leUjku/EVgSJQM8xPjYw
         fspx/nOEU0fnXpSBOxzPLSrKHq7ytkxIblb6HCM4EB15wXTVPVBumEP6ZsZ+IN71uvcH
         RoRoXIWXTwsi4FShMSGs/+8948kBpzeTbn0HocX9VGwIu5hbEr0q2aYzZPZdxw0ahvDC
         J2ig==
X-Gm-Message-State: ACrzQf0ydcEeI4JCDbL5P/35Aovui4PTENf3F1ljQO3DQkrGLc8FJhQ4
        03eLwVCzE55yCaNI9MRR5ngKIyfth0hy5Ixk
X-Google-Smtp-Source: AMsMyM4tMCu7URYFgaAQZgnaRiMY0iyFuLab70utjXxpA0cL2CeaZK4UGziOCx2oR15XKHFOeUNPiQ==
X-Received: by 2002:a17:903:258b:b0:186:8bb2:de32 with SMTP id jb11-20020a170903258b00b001868bb2de32mr11380804plb.63.1667167331690;
        Sun, 30 Oct 2022 15:02:11 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y3-20020aa79e03000000b0056d73ef41fdsm562852pfq.75.2022.10.30.15.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 15:02:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] eventpoll: move expires to epoll_wq
Date:   Sun, 30 Oct 2022 16:02:01 -0600
Message-Id: <20221030220203.31210-5-axboe@kernel.dk>
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

This makes the expiration available to the wakeup handler. No functional
changes expected in this patch, purely in preparation for being able to
use the timeout on the wakeup side.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 888f565d0c5f..0994f2eb6adc 100644
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

