Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F211611C95
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 23:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiJ1Vnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 17:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJ1Vnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 17:43:35 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEF123B692
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 14:43:34 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f193so5962755pgc.0
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 14:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oO43xlLma+tv8tmMXvsUkJytaNEXn7co0M840UITGjM=;
        b=acHh5cwgkAmQ3dtoHxW9mLeYEZVag9qz5bdERqpVL2WrAMRtFTbFR4LDwgRwGSBlIQ
         5CjocgoZo+dqh/Kn1Gdf/IIsiyaMWIaedyvrwHGQnNYO+Boy5qfbvJJKmEoxO/GOR8/S
         wOHqfc4E0Q47fcdWM9poaiM9muj6DDd5I3qsbcUkrF5oL7CbaEgCZU2bWpRU/2OHKv7k
         UiYt0WpcrTEUbi9+89xe3KRybHGilPnNUEDqTL7C9nlv0GTP/eE41KOyezm2dNi93MZP
         hZgJcWKCT41ljDihKIHqSsW2tbgVuJrYN/0ceMa68ovP+M7Q+Z9AgCda4s7+zAV0nAVW
         +OPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oO43xlLma+tv8tmMXvsUkJytaNEXn7co0M840UITGjM=;
        b=tzRfDw9o0QbKOevCCOzDycZGu8MXg717LQjrsSyQIERXHqPQiDSZ5uZhmpSJXmyhIC
         3O9tYHrw2Hj4NBSNo3aYqm7LWN4BRKs6BgYuelWSQP+sC2WJUAWWq23a+RIJMuG6vvXa
         jseH8tt/JamGzXO+LTeYlejhFVbDy/14z973jABQkhIWDZiFUhv+IJHLFl9tP54e2035
         d5O5IpScegh8jOGvPhFx9bKWUwD2tzHo6lF2/TkvBGJsyCW06B5GEIj9VPYpIOpyYwFp
         eNLBv33rIW4V0zhdehtwV46Ty5476C7hRv0nSFF1i6K6sxmHhU0DtXtTxrB5SQnIGm/W
         ek0w==
X-Gm-Message-State: ACrzQf2x9YaWOJ6etODeKups/cY59iZ+0mjMKY21BNwgYi0V7WYRQwm6
        S1kTkhEFQWtEwyhfCzeA1SInLevVhRbV1Eje
X-Google-Smtp-Source: AMsMyM6CSUMPOxAJEYIPNNzyIm9hIvlLDsy8NVe/negKifXte+R0ocElGTnFWZm7ke/e8wf1p32wJg==
X-Received: by 2002:a63:d241:0:b0:43c:474c:c6c6 with SMTP id t1-20020a63d241000000b0043c474cc6c6mr1342605pgi.523.1666993413875;
        Fri, 28 Oct 2022 14:43:33 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090a1d4600b002130c269b6fsm2993855pju.1.2022.10.28.14.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:43:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] eventpoll: move file checking earlier for epoll_ctl()
Date:   Fri, 28 Oct 2022 15:43:24 -0600
Message-Id: <20221028214325.13496-5-axboe@kernel.dk>
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

This just cleans up the checking a bit, in preparation for a change
that will need access to 'ep' earlier.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8b3c94ab7762..cd2138d02bda 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2111,6 +2111,20 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 	if (!f.file)
 		goto error_return;
 
+	/*
+	 * We have to check that the file structure underneath the file
+	 * descriptor the user passed to us _is_ an eventpoll file.
+	 */
+	error = -EINVAL;
+	if (!is_file_epoll(f.file))
+		goto error_fput;
+
+	/*
+	 * At this point it is safe to assume that the "private_data" contains
+	 * our own data structure.
+	 */
+	ep = f.file->private_data;
+
 	/* Get the "struct file *" for the target file */
 	tf = fdget(fd);
 	if (!tf.file)
@@ -2126,12 +2140,10 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 		ep_take_care_of_epollwakeup(epds);
 
 	/*
-	 * We have to check that the file structure underneath the file descriptor
-	 * the user passed to us _is_ an eventpoll file. And also we do not permit
-	 * adding an epoll file descriptor inside itself.
+	 * We do not permit adding an epoll file descriptor inside itself.
 	 */
 	error = -EINVAL;
-	if (f.file == tf.file || !is_file_epoll(f.file))
+	if (f.file == tf.file)
 		goto error_tgt_fput;
 
 	/*
@@ -2147,12 +2159,6 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 			goto error_tgt_fput;
 	}
 
-	/*
-	 * At this point it is safe to assume that the "private_data" contains
-	 * our own data structure.
-	 */
-	ep = f.file->private_data;
-
 	/*
 	 * When we insert an epoll file descriptor inside another epoll file
 	 * descriptor, there is the chance of creating closed loops, which are
-- 
2.35.1

