Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAA2612D2F
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 23:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJ3WCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 18:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiJ3WCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 18:02:20 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54646AE72
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 15:02:13 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d10so9167929pfh.6
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 15:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2Hzb+xxyKnPzMsKtR+WvmF1ywGYO4tzf59V+gc/0/s=;
        b=4SbYyN02zU3+59sahg+YLvVvWkSd64+1XsaqdsPV7wLhPizJiL1ZOSfFWLEXqALNYa
         6W6QeSVCcOzhNwakNJ4zPTTE1Kep4cZIA88KTO2RA+MLTQn/knPn/uclsfs5FWpp2r6X
         MBwpK2jSIc9AuGhnLLcYN95HkF+kptFd0w5wvA/YtE9N5+9YKHf7bcTuPECr48LAKx0C
         7ea3GPXX5Pek4eIhJCfGxGLaMzcEtWvp/NBeUf5cfL4o2WKF375Mdt8o3+ozsisYNfV4
         LlCBO/tvvMnw7IofiBWylGe7Pp676nxsruegSlfD1fNjwlCGunhC8UcSHHnfzrI6bgv5
         Dicw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T2Hzb+xxyKnPzMsKtR+WvmF1ywGYO4tzf59V+gc/0/s=;
        b=vmnDW3nKZQpuHRq1N9u75eBvsvX1Mt35gYODOVEelyWMe8FQezzTnToJz27mdCBfYB
         nsXONybPGSFhCN1B3g/RDfMtVPYWhSlDk74k/+ZULly3TKGBQoFZGn63u5UV6LUeXfPx
         6DrUFIB8yiUYdOB4DGvEaD9SozLR5Sb8rBrMsC9LkFORFK2k5BmXTlGUglB45tD5mATR
         Is3mZhOTyhjro/KAXARiOOi1cuEtF2aJMJEkb4HHU9+/WLESxJmJcVtwR5C95lgnPRPd
         Isu2BDXv/spzsVfMaGpfUwnBNbZm1f09hNG3kHfLpZf7eFDZD9UFsfHfj4wlw8+IVAMD
         ntcg==
X-Gm-Message-State: ACrzQf3duDfx00UMZikcAlsLj4QJSiY/GqdD1FOsp1LW+DrA01RcJi4y
        mD5Be3lPhIa9QSkDCYRsjgthNg==
X-Google-Smtp-Source: AMsMyM6rC0HxreFF+0nLCbPFZujbettJ72v6ARDfIlBCp4K0TWosk65ubJlAUaD1LH+Z4thDNhlCxg==
X-Received: by 2002:a63:f103:0:b0:439:398f:80f8 with SMTP id f3-20020a63f103000000b00439398f80f8mr9698925pgi.494.1667167332660;
        Sun, 30 Oct 2022 15:02:12 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y3-20020aa79e03000000b0056d73ef41fdsm562852pfq.75.2022.10.30.15.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 15:02:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] eventpoll: move file checking earlier for epoll_ctl()
Date:   Sun, 30 Oct 2022 16:02:02 -0600
Message-Id: <20221030220203.31210-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221030220203.31210-1-axboe@kernel.dk>
References: <20221030220203.31210-1-axboe@kernel.dk>
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

