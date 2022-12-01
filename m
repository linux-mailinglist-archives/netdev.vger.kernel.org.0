Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D4C63F743
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiLASM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiLASMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:12:18 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B47B844B
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 10:12:09 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id 135so1570679iou.7
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 10:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2Hzb+xxyKnPzMsKtR+WvmF1ywGYO4tzf59V+gc/0/s=;
        b=2atU+qY8N6U1TWuEjoXo0Ek+wKx6gWrLYp8D9cZz1SEd++H+eWVuXdr3WUmYAaBF3h
         CXDqX2fX2YFDXbnYSeIWfgeuJyAoP/MnjAsqnXzRedinp+W7XDc7ppleItMH3Ati2r1r
         pWU+OXSKGhu/TbrMFfI7gUobNXqYO3tuC+SBghlInhOM9GAdacLA5zPErWxgwlToLDPk
         VLBDRdh/ETAMA76uckSDzQRnLzivJQnR0ZzmDxBpX9FrTbWFBuexQuphd37ILJwWHd0E
         /cfJYCD7LwtgUHaWTI2vY2Waup5fInS5DVQuUsNCxIiaNr7qjw7Sm35SjXYyN9jMkbTq
         pfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T2Hzb+xxyKnPzMsKtR+WvmF1ywGYO4tzf59V+gc/0/s=;
        b=b03dDmg3A1UQB6fquEilNAaLIMA10Ja9Sg9aZUcRQO8m+97ixpDxhgQo9Eo3Ps6lK4
         vIcnBuKaCi6u9F8mKLE4PGCGijj/1LpRvUfx2y213lhswlHcwjqUEweFRRPCRXeYbMaT
         JqmlJwcBAyNUGvZeZu7iYIK/LtKYVJ52ZPcIe8wAHABrhrVKQIEYK1falm76+PXDAHMF
         FgBc2FjMtkBaNKfhTvJ1br/4uwbmi3c+pZoCVxK8wb6kZ2LZc4AtJHCTnByztxNwqQXa
         tAKPiOVp1a+zCnfjd8w+C+IR4fiGISed4ai5lJHW3FgLyEsPj+QD4ztcvnwUibrXMiRT
         gPzQ==
X-Gm-Message-State: ANoB5pl8mXTzFOrNglUvEVFbpUfssSz9QdOSB1Cgxg2q+Novq2j0S4Jk
        r4NQlVpNPO1Tn/8KqhEJ+xl05Q==
X-Google-Smtp-Source: AA0mqf71c/tcCYkCrnJEPuvS6YTKCor+CO40ni3Rrsmti3mZrEckPPOVEKukp2kBF215wOaXLqH5OQ==
X-Received: by 2002:a02:16c8:0:b0:38a:c4d:931f with SMTP id a191-20020a0216c8000000b0038a0c4d931fmr3207615jaa.176.1669918328499;
        Thu, 01 Dec 2022 10:12:08 -0800 (PST)
Received: from m1max.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y21-20020a027315000000b00374fe4f0bc3sm1842028jab.158.2022.12.01.10.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 10:12:08 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     soheil@google.com, willemdebruijn.kernel@gmail.com,
        stefanha@redhat.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/7] eventpoll: move file checking earlier for epoll_ctl()
Date:   Thu,  1 Dec 2022 11:11:54 -0700
Message-Id: <20221201181156.848373-6-axboe@kernel.dk>
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

This just cleans up the checking a bit, in preparation for a change
that will need access to 'ep' earlier.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 0994f2eb6adc..962d897bbfc6 100644
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

