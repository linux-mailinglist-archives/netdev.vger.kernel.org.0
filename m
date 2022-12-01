Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CDB63F747
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiLASMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiLASMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:12:23 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C08B846E
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 10:12:10 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id y131so908141iof.9
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 10:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hAGk4MFjlfW7Mob6ujVIOlyczZbXb2RyPAqfUdaDlEo=;
        b=Gnqziq8xRmWSBCtI5LbkgYdL2sMBi4ijnnNDCjyb1I6NyYRb4wWQRfi1KeWDcV6woX
         2hBG2JA6tPkR84DL4X+rhLHSfSacd65MbGAg32TAPk9YlGxw9kcZgSYXFGNGCC0L5YgY
         +AuvkWHv/JFbbonRZzYiDMVHxoX9MAkrOh3UCZuIcqxQAktZruc/xq+PU1feO+g8bBS7
         DfS7IYpIU+ZQSkmZeoRLSQwzB/++gpslbtWACrtpE7SHmjRbQrhtK/+tRdg7UXMzqpQw
         Uh8ymHGPUCn+JbALqvUi8JNEliEEGmRAUlCbzIKJhVyPNtyMey7JusEhVCtcfubPIMbD
         /pfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hAGk4MFjlfW7Mob6ujVIOlyczZbXb2RyPAqfUdaDlEo=;
        b=f38f3/pK6td5LX+lFBYxim4Z8iE6egRoBLOM2wyR9O+ncxqNNF73O54V1EhWqlbFgU
         ga0l121oGX64ESsIxOL+cA2zvO7e0nyTRg100wQKyNXyOEhvxSJp6CA8anWTKJh0tpAA
         ihShn8DC4wMFnz4AOzEVBT7edXjTo04tJgv48WlHzUNt9GJMJAMZPpTUzr21fMuUpQ1t
         xI6oYuoDwyoIR7uNc9/YbEyslJxsCWdDqeEK1yAKIwiwMXse/MrurmV8XEArL9JFQteR
         77TAlTpfW6VFV4VhSvV2eeKVHJEVh4BPk6uwPVZyS03VjqOW3zdyRK5R2MmLbt+44/nV
         VNMA==
X-Gm-Message-State: ANoB5plGeIMdiFmsA6GML/1X6icja7iApTwbesmObjk6CzU4gM0Dbc54
        vTYNrHoOigRB+KcYQ37EmA6trNRheZYQFklv
X-Google-Smtp-Source: AA0mqf43cOjadjWzOUmOk1OU4HLtoIJvOE0jX9fTTnSB5KjGk2DM0Qq0yRWwkjs/cVASjL2efMOJVA==
X-Received: by 2002:a05:6638:4709:b0:389:e195:e8fb with SMTP id cs9-20020a056638470900b00389e195e8fbmr10218197jab.254.1669918330191;
        Thu, 01 Dec 2022 10:12:10 -0800 (PST)
Received: from m1max.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y21-20020a027315000000b00374fe4f0bc3sm1842028jab.158.2022.12.01.10.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 10:12:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     soheil@google.com, willemdebruijn.kernel@gmail.com,
        stefanha@redhat.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/7] eventpoll: add method for configuring minimum wait on epoll context
Date:   Thu,  1 Dec 2022 11:11:56 -0700
Message-Id: <20221201181156.848373-8-axboe@kernel.dk>
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

Add support for EPOLL_CTL_MIN_WAIT, which can be used to define a
minimum reap time for an epoll context.

Basic test case:

struct d {
        int p1, p2;
};

static void *fn(void *data)
{
        struct d *d = data;
        char b = 0x89;

	/* Generate 2 events 20 msec apart */
        usleep(10000);
        write(d->p1, &b, sizeof(b));
        usleep(10000);
        write(d->p2, &b, sizeof(b));

        return NULL;
}

int main(int argc, char *argv[])
{
        struct epoll_event ev, events[2];
        pthread_t thread;
        int p1[2], p2[2];
        struct d d;
        int efd, ret;

        efd = epoll_create1(0);
        if (efd < 0) {
                perror("epoll_create");
                return 1;
        }

        if (pipe(p1) < 0) {
                perror("pipe");
                return 1;
        }
        if (pipe(p2) < 0) {
                perror("pipe");
                return 1;
        }

        ev.events = EPOLLIN;
        ev.data.fd = p1[0];
        if (epoll_ctl(efd, EPOLL_CTL_ADD, p1[0], &ev) < 0) {
                perror("epoll add");
                return 1;
        }
        ev.events = EPOLLIN;
        ev.data.fd = p2[0];
        if (epoll_ctl(efd, EPOLL_CTL_ADD, p2[0], &ev) < 0) {
                perror("epoll add");
                return 1;
        }

	/* always wait 200 msec for events */
        ev.data.u64 = 200000;
        if (epoll_ctl(efd, EPOLL_CTL_MIN_WAIT, -1, &ev) < 0) {
                perror("epoll add set timeout");
                return 1;
        }

        d.p1 = p1[1];
        d.p2 = p2[1];
        pthread_create(&thread, NULL, fn, &d);

	/* expect to get 2 events here rather than just 1 */
        ret = epoll_wait(efd, events, 2, -1);
        printf("epoll_wait=%d\n", ret);

        return 0;
}

If EPOLL_CTL_MIN_WAIT is used with a timeout of 0, it is a no-op, and
acts the same as if it wasn't called to begin with. Only a non-zero
usec delay value will result in a wait time being applied for reaping
events.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c                 | 13 ++++++++++++-
 include/linux/eventpoll.h      |  2 +-
 include/uapi/linux/eventpoll.h |  1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index daa9885d9c2b..ec7ffce8265a 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2183,6 +2183,17 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 	 */
 	ep = f.file->private_data;
 
+	/*
+	 * Handle EPOLL_CTL_MIN_WAIT upfront as we don't need to care about
+	 * the fd being passed in.
+	 */
+	if (op == EPOLL_CTL_MIN_WAIT) {
+		/* return old value */
+		error = ep->min_wait_ts;
+		ep->min_wait_ts = epds->data;
+		goto error_fput;
+	}
+
 	/* Get the "struct file *" for the target file */
 	tf = fdget(fd);
 	if (!tf.file)
@@ -2315,7 +2326,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 {
 	struct epoll_event epds;
 
-	if (ep_op_has_event(op) &&
+	if ((ep_op_has_event(op) || op == EPOLL_CTL_MIN_WAIT) &&
 	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
 		return -EFAULT;
 
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 3337745d81bd..cbef635cb7e4 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -59,7 +59,7 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 /* Tells if the epoll_ctl(2) operation needs an event copy from userspace */
 static inline int ep_op_has_event(int op)
 {
-	return op != EPOLL_CTL_DEL;
+	return op != EPOLL_CTL_DEL && op != EPOLL_CTL_MIN_WAIT;
 }
 
 #else
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index 8a3432d0f0dc..81ecb1ca36e0 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -26,6 +26,7 @@
 #define EPOLL_CTL_ADD 1
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
+#define EPOLL_CTL_MIN_WAIT	4
 
 /* Epoll event masks */
 #define EPOLLIN		(__force __poll_t)0x00000001
-- 
2.35.1

