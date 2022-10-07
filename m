Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF7F5F7BD7
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 18:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiJGQ4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 12:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJGQ4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 12:56:44 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2545F113
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 09:56:43 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id q18so26416ils.12
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 09:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4UKLX7j9DF0b0nVBHqCcizEjwTs/7OhMEZz7ThiWmPU=;
        b=4XlkKsLZxCrt+c9fmGB5bq2MTyFakYDlhyvSOt757T7suNWNTtXfhxzaLcHiqtH5yD
         /J6qS/O2YJPeWXDF/LOzsCLN3i9uKcAyuvDvLzX6z9+F4k7G5bikxOcHzaS+b2BAPc14
         NMKcjMkjJ7eplGMRtkarPXexSfQUOo1BMenVGhCL9/IdP7OJqW4W5MW2uDzaN0iwWm3H
         Exnsa3Nkdn9g7WVMgmFtbAxQr1OKWGz9dZi4YgDKRSgXAn98OHwfw4Lm2kz3Rjj1HfpA
         CgTJbpLBY/zARLGF7FlJM2gjujUuUsLZnuBxAyw50Je2StP4d2HAn7rUXZ5MZvBnS8lv
         dNRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4UKLX7j9DF0b0nVBHqCcizEjwTs/7OhMEZz7ThiWmPU=;
        b=n/+4LAUswfq+pGoMokGEJY8MKKs+uFD9Tnwy6m4llLgxHdCyfPMXRpwIJFXcdBudcE
         OBaD1nD1OCTF2rs3CC/g83/daDl10x/m/jxZUDKukeq7iS2I4tpeP5/JCK8Us2+Cayka
         MYQ6HcpRt6WrpPSCAYar3ywUoVcmAnSxA1mYED+RGyUkiWpE7TfMCd+g6fImqo/mtyq5
         zoAwy6Zo0QvaiAM3etTPQWJyzUQQeCPOA5v+aXKFaozgnNByJO0bx50b7NdAO22jjmuf
         V+xpQs3IGIhm0OOk4zW8ljk4TXfNiQFg5mZqYtCohZJKbGj3D2xNGABg1it/x6Qarzt3
         7YZA==
X-Gm-Message-State: ACrzQf2tNCEQMtq1ORbXJ5ozBJ4MQ1oIHFSGR9N8VaAi5MrST0ZXsaxs
        xhLrT2qrwlJBqOUVR7u4aGG7QWyLoNpTVQ==
X-Google-Smtp-Source: AMsMyM4OvaNbHc5o7fDN2kfr0Oa71t2vvJjYaC8Pb78cW2Rj1iHSsk0tf7UB7bsSc96VGdKdM1lWdw==
X-Received: by 2002:a92:6912:0:b0:2ea:fa2e:462d with SMTP id e18-20020a926912000000b002eafa2e462dmr2830314ilc.155.1665161803214;
        Fri, 07 Oct 2022 09:56:43 -0700 (PDT)
Received: from m1max.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a6-20020a056e020e0600b002eb5eb4f8f9sm1055584ilk.77.2022.10.07.09.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 09:56:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] eventpoll: cleanup branches around sleeping for events
Date:   Fri,  7 Oct 2022 10:56:34 -0600
Message-Id: <20221007165637.22374-2-axboe@kernel.dk>
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

Rather than have two separate branches here, collapse them into a single
one instead. No functional changes here, just a cleanup in preparation
for changes in this area.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8b56b94e2f56..8a75ae70e312 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1869,14 +1869,15 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		 * important.
 		 */
 		eavail = ep_events_available(ep);
-		if (!eavail)
+		if (!eavail) {
 			__add_wait_queue_exclusive(&ep->wq, &wait);
-
-		write_unlock_irq(&ep->lock);
-
-		if (!eavail)
+			write_unlock_irq(&ep->lock);
 			timed_out = !schedule_hrtimeout_range(to, slack,
 							      HRTIMER_MODE_ABS);
+		} else {
+			write_unlock_irq(&ep->lock);
+		}
+
 		__set_current_state(TASK_RUNNING);
 
 		/*
-- 
2.35.1

