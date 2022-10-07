Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB75D5F7BDB
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 18:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiJGQ4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 12:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiJGQ4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 12:56:46 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB695FDFD
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 09:56:45 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id o65so4082420iof.4
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 09:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=268Ewj1SkBC8anSnii6XOQa/SAiq+mm/PdGL6GPMikM=;
        b=um2f4lAP90/5sPo8x7U02EbQNucStn9G1tMe/aYsv1/wSysgTPyhwAHdy3uyIZbO3I
         R12S393agNl2gl6/84qpfQwxUX3x333wI6RscwNaHiEOZHuZfjA8/+52qLIVb219+sdy
         q6VKkIsHKVSXARmljPQZoxd4ftfCeBmrHOQYKFhKVTFbuHOAlX2kyDD/GgtCDRJT9v6q
         QlbLUIWcFfRHG8DxYC84sN0izcQBncZ06z3HsRa/OZMQkGR/UwolfKYT6TjLHlP1aj9U
         d8X7hX7JoO1ZY/CUnu7TEeMcO95rb4rJVOsH9iWdvOfTZK3aJjYuxqDaeodo6W5cBhPh
         SO8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=268Ewj1SkBC8anSnii6XOQa/SAiq+mm/PdGL6GPMikM=;
        b=Q0t1hRGC8TqSDAphYyHohYkFkOlU5b1L2XdfVJ+0bV9XP/GsmN42Wfpcj0NZenbyEV
         FY5qvnJuOoBYOclJjXKqE40ei7YipmftIi+jnrWKG28SyHVma62xthOBw1q6myC95NP0
         bjtvhMhk97Fpqm7SPNtw8xhDtw9ODUXU6bPz87F6dUsfOxJM2JR8WmxO3H7QiGUDwWPL
         P6tuqbwWG5gzooiPE8PAlhf8C0N1AhBijwr1wyqAzC2+yljZRcK+bmt2oRJLSPKtKeKI
         RN8oxuwsDppytdCcj47oF8BMyGk7dZivzUwmXL0BZP/bsL0ot3A2Xi5+bKvXhX2ZulkG
         /O8Q==
X-Gm-Message-State: ACrzQf0xExxMfOAWFmjhV8B8AWB0F8mRDbNNn/f8IG+wvLvaWHTWkC0M
        f0xrTS0xIqx03ZcfuTJOFYRMkA==
X-Google-Smtp-Source: AMsMyM5cab4DrLGmE2R6/vLkQVAh+Bjf5n/flcaTschxphy9xhCDDpVwHtoi+2sscPY8PSz1btOb/g==
X-Received: by 2002:a05:6602:2cd3:b0:6a2:167d:1d1c with SMTP id j19-20020a0566022cd300b006a2167d1d1cmr2679773iow.18.1665161805095;
        Fri, 07 Oct 2022 09:56:45 -0700 (PDT)
Received: from m1max.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a6-20020a056e020e0600b002eb5eb4f8f9sm1055584ilk.77.2022.10.07.09.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 09:56:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] eventpoll: move expires to epoll_wq
Date:   Fri,  7 Oct 2022 10:56:36 -0600
Message-Id: <20221007165637.22374-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221007165637.22374-1-axboe@kernel.dk>
References: <20221007165637.22374-1-axboe@kernel.dk>
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
index 01b9dab2b68c..79aa61a951df 100644
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

