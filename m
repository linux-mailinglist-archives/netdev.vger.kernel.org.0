Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9333463F741
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiLASMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiLASMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:12:09 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60339B7DDD
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 10:12:08 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id i80so1605960ioa.0
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 10:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7XieXpcJrzhapQHtWCNoW0rQy5yiKhkq34SDOyw0xw=;
        b=rCV2KahuRSA2UomgHjcLL2MPSHWQzvEOZHnqXl9CNih1pE+gZRpjzdYg3AGoNxGtH/
         lrwbTserdKCot3tq/5ePqPYHCEDByLsr5EJeyAa3WUpPRYldyDwDb72H4U+e7EULEDfX
         YOz044AliNTRJSeVBbissUP76TH1dDpAxrwe5pgd94G4wvCJ4IeVnDfJhMx47sKWeWPs
         0C7kWE1xTeT+Dx73CkQ/oLdCov1SSDwhGCyL0CKWRohvyTJvqo4qo5nur82aLKeNrnxf
         rQRbX7ukSMrqtcrZIvRHBe9oddDEKsDHVoB5vCoS6H8vIAXT8EF6vPM5WVzceR1ifqHH
         kwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+7XieXpcJrzhapQHtWCNoW0rQy5yiKhkq34SDOyw0xw=;
        b=vehopNYXYxUh3wzI1Ye6BjwDy9RrO+8dpZXtczPrY5/z9HwsT/jr6hdRgSAPjiKGOj
         IgEuO5MM6EFj8kiuPIQWT4aJIUCWoTVbuqBtBcjKGBTbGwVdPt+4YCgT0OnB8B4cBSmH
         DcPDMf8a142ZOHIejlm5vbkAxII3vIlU7eXDrPHw7c/5h3lCMGSI6kli80LosKIQLeWG
         gq+QhEgGAK67MubYsmIkcWHfSiQGGCe/WBaCPm95F7ZMoVup36s1yxU8HRqfx71CJioN
         QvZLMJigqAxgvAv/9xu7NIUNF5g8Y09C7R3i95DMIbfhShie6cjMTratCwnfZJULk6ra
         X5FA==
X-Gm-Message-State: ANoB5pmUBuwD8a+fJfCIPChKBPzns822usgl8AcDSIQHrER6kYvyFH/t
        /DRWvxb7D+s+f9VsEVkd3zPPNg==
X-Google-Smtp-Source: AA0mqf74WtcWLOBknC51Eqq2LhOOyGElfDAy+jSdzXDD60HRlSEZEkNsL3iTmtYnZTNrl5XL3BCV9A==
X-Received: by 2002:a02:a710:0:b0:389:d089:4233 with SMTP id k16-20020a02a710000000b00389d0894233mr12448957jam.18.1669918327697;
        Thu, 01 Dec 2022 10:12:07 -0800 (PST)
Received: from m1max.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y21-20020a027315000000b00374fe4f0bc3sm1842028jab.158.2022.12.01.10.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 10:12:07 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     soheil@google.com, willemdebruijn.kernel@gmail.com,
        stefanha@redhat.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/7] eventpoll: move expires to epoll_wq
Date:   Thu,  1 Dec 2022 11:11:53 -0700
Message-Id: <20221201181156.848373-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221201181156.848373-1-axboe@kernel.dk>
References: <20221201181156.848373-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

