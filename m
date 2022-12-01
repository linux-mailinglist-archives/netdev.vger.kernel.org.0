Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494C363F73B
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiLASMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiLASMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:12:07 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBBEA1C0A
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 10:12:06 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id n188so1569994iof.8
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 10:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TCMSGu8wCAuxi+YEaeqt2Nm6ljarPNoUCebXSLfB1Fw=;
        b=7rToxcBAjNQi+teOR/HtEPsnLOYMOnWUeha2jHX+ubOPphUUlFzGLJ4Fe1IYPdO1VW
         enEBIs7LitVgRCKTuHrjuThBnVfxtBFEMCju3P6P9WcCV1t9LWJhlo3mkRwr6SrAwO1D
         yoqZbuamMTV2WlHMUkepdyL5Xqor2YcYSaaTktTtZNAFOZhGhF4FUnPijBD3hwA7DvNH
         RHAlKTRVQqxVvJvcBxfqIqMWd6mNhSUYAzvuqN6ViWqrv4BAvQm18wBgyzIwfR7zpR7X
         1mkSD3MYCxFWbk4qT1FMG9SddowhtGk3HGi6pPUSrixd5nXBqwQXeQ8hhBpKqqvpGASM
         IBMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TCMSGu8wCAuxi+YEaeqt2Nm6ljarPNoUCebXSLfB1Fw=;
        b=MSbWpyVVxbd7jSa0SLrtI5UeKgUtUYwa+R82YqN5vvSyggb6zeZx0Vbn3+iQd62cKp
         fGGgG3jUGLdNvpqt3HwCX73VGpBg0yz/kNcXoXQe1W/Kna5bptVi7243c8Jj42AFHw2G
         RuqBokr0AhWiO8gqi2pwxJLe0fytuu4Tc+EBBQNzHs9EWUMMZNZ4bH9eRCO1pB+LdyX6
         +fmINHAVI9IzUlzlS3OWnPrF3cXEGYfid1A+yZic6whAWSTgM8ba2YtQI6VMlAGeMSnm
         FGoWd5pFXWtyUPwvNt1yGqBnY6X85Rpn102JeodwiOfnBEQyfo07SSODS7gGep4QtqZr
         BJzg==
X-Gm-Message-State: ANoB5pl09vfwFSczxFsMYwJHALA4WKSsP1HZQ+IGIQApy6WpXf7ZJAmK
        cxFWjrbuISHHgv5YPLxEuFAMqg==
X-Google-Smtp-Source: AA0mqf6rBwwB4nUZFcqG3+zWfl/ciQn5NxuTGH2Wmrrxs/wUaiO8rXztJ5U/q7t0p/9YbpFDxZwY4A==
X-Received: by 2002:a05:6638:15cc:b0:389:e983:dfd1 with SMTP id i12-20020a05663815cc00b00389e983dfd1mr8192666jat.306.1669918325874;
        Thu, 01 Dec 2022 10:12:05 -0800 (PST)
Received: from m1max.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y21-20020a027315000000b00374fe4f0bc3sm1842028jab.158.2022.12.01.10.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 10:12:05 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     soheil@google.com, willemdebruijn.kernel@gmail.com,
        stefanha@redhat.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/7] eventpoll: don't pass in 'timed_out' to ep_busy_loop()
Date:   Thu,  1 Dec 2022 11:11:51 -0700
Message-Id: <20221201181156.848373-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221201181156.848373-1-axboe@kernel.dk>
References: <20221201181156.848373-1-axboe@kernel.dk>
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

