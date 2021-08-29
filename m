Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019FC3FADE4
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 20:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbhH2Sh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 14:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236011AbhH2Shp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 14:37:45 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D03C0613D9
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:52 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id x11so26357027ejv.0
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zlHvhtHeko9hSmaAAfesUNj7/A7YCvEoJ39Eryv7jaU=;
        b=UTNeA2Vgku4Jwk0ZYLxOhqoCibaeKLC0eDXJDDmzHfxox2bVTlDwyUhGy7GK17IhAC
         6zQnZylk+5utdWYcBHMJ89yDE6EiWUNPe6H15dl3Z6NvvLQExo105LyXBZQKIX49wciV
         bbbryjDzqbp23ZfGVGJkmOENXWjOFA/ET5dmSff/zaMlUJXrSli//KkRxj4aHTpQDd2q
         pXMzqdjdIOwXLpotgehOHXwwFq98W4kc6Qj2y+bdp+SBuNHHZdvhL3DhJIpvrWwSXFsi
         EEYBGp4x+0EILKEQwN0R/BE7ZBMoaQjd42GlZIMw3n4q65/HM5Qb4nQpXBpfL/Zex1lR
         uItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zlHvhtHeko9hSmaAAfesUNj7/A7YCvEoJ39Eryv7jaU=;
        b=GtY24foYvSuBlGP38bZQDLvZ9FA8ZXLVKwqbdOJdRG6p4c9fH1lqh5u9RrQUl+g/CF
         mZjb4o+PcttHTs0ivj2TPuLmzYTtPfz/zRjORjLDvV+8q4sKvcvJgwv01u5yNIPTLpe5
         8S57WyOab5pD+B88IsS8sRE7Twu5loVN1k6/29HrzKgPRa39v26glg++Nq+nGsikgRTg
         I/+ExWFmlooxps3+BORrLKqbxRedDWPQPY+5bYu9xn3jbk2J4thGyHPB8EdPbwtI9JsB
         gVsUMaOpPRUDhTVJyat7IkCi7mrENeLeWHuwFBhLhpZm+QNjfEfpy5Z6TxKbHs3SaRAr
         OHPA==
X-Gm-Message-State: AOAM5309jQ5ggmt6cOXxYowgCUuTvAJA46A9E9oaexKiFLXStYW7/DIp
        b8rX7PXljimMxJseLM4ChurlMQ==
X-Google-Smtp-Source: ABdhPJwn+KMqYF+RIIRpSXT1nQz5hcKIizFVfB0g41Fv5hVL0/Aqz9/o0FtovDY14VSHS5tm3ReVew==
X-Received: by 2002:a17:906:138d:: with SMTP id f13mr3212896ejc.180.1630262211305;
        Sun, 29 Aug 2021 11:36:51 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id p5sm5639946eju.30.2021.08.29.11.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 11:36:51 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v2 13/13] bpfilter: Handle setsockopts
Date:   Sun, 29 Aug 2021 22:36:08 +0400
Message-Id: <20210829183608.2297877-14-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210829183608.2297877-1-me@ubique.spb.ru>
References: <20210829183608.2297877-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use earlier introduced infrastructure and handle setsockopt(2) calls.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/main.c | 126 +++++++++++++++++++++++++++++---------------
 1 file changed, 84 insertions(+), 42 deletions(-)

diff --git a/net/bpfilter/main.c b/net/bpfilter/main.c
index 291a92546246..1010e4c49716 100644
--- a/net/bpfilter/main.c
+++ b/net/bpfilter/main.c
@@ -1,64 +1,106 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
 #define _GNU_SOURCE
-#include <sys/uio.h>
+
+#include <unistd.h>
+#include <errno.h>
+
 #include <errno.h>
 #include <stdio.h>
-#include <sys/socket.h>
-#include <fcntl.h>
+#include <string.h>
 #include <unistd.h>
-#include "../../include/uapi/linux/bpf.h"
-#include <asm/unistd.h>
+
+#include "context.h"
+#include "filter-table.h"
 #include "msgfmt.h"
+#include "sockopt.h"
 
-FILE *debug_f;
+#define do_exact(fd, op, buffer, count)								\
+	({											\
+		size_t total = 0;                                                               \
+		int err = 0;									\
+												\
+		do {										\
+			const ssize_t part = op(fd, (buffer) + total, (count) - total);		\
+			if (part > 0) {								\
+				total += part;							\
+			} else if (part == 0 && (count) > 0) {					\
+				err = -EIO;							\
+				break;								\
+			} else if (part == -1) {						\
+				if (errno == EINTR)						\
+					continue;						\
+				err = -errno;							\
+				break;								\
+			}									\
+		} while (total < (count));							\
+												\
+		err;										\
+	})
 
-static int handle_get_cmd(struct mbox_request *cmd)
+static int read_exact(int fd, void *buffer, size_t count)
 {
-	switch (cmd->cmd) {
-	case 0:
-		return 0;
-	default:
-		break;
-	}
-	return -ENOPROTOOPT;
+	return do_exact(fd, read, buffer, count);
 }
 
-static int handle_set_cmd(struct mbox_request *cmd)
+static int write_exact(int fd, const void *buffer, size_t count)
 {
-	return -ENOPROTOOPT;
+	return do_exact(fd, write, buffer, count);
 }
 
-static void loop(void)
+static int setup_context(struct context *ctx)
 {
-	while (1) {
-		struct mbox_request req;
-		struct mbox_reply reply;
-		int n;
-
-		n = read(0, &req, sizeof(req));
-		if (n != sizeof(req)) {
-			fprintf(debug_f, "invalid request %d\n", n);
-			return;
-		}
-
-		reply.status = req.is_set ?
-			handle_set_cmd(&req) :
-			handle_get_cmd(&req);
-
-		n = write(1, &reply, sizeof(reply));
-		if (n != sizeof(reply)) {
-			fprintf(debug_f, "reply failed %d\n", n);
-			return;
-		}
+	ctx->log_file = fopen("/dev/kmsg", "w");
+	if (!ctx->log_file)
+		return -errno;
+
+	errno = 0;
+	if (setvbuf(ctx->log_file, 0, _IOLBF, 0))
+		return errno ? -errno : -EINVAL;
+
+	return create_filter_table(ctx);
+}
+
+static void loop(struct context *ctx)
+{
+	struct mbox_request req;
+	struct mbox_reply reply;
+	int err;
+
+	for (;;) {
+		err = read_exact(STDIN_FILENO, &req, sizeof(req));
+		if (err)
+			BFLOG_EMERG(ctx, "cannot read request: %s\n", strerror(-err));
+
+		reply.status = handle_sockopt_request(ctx, &req);
+
+		err = write_exact(STDOUT_FILENO, &reply, sizeof(reply));
+		if (err)
+			BFLOG_EMERG(ctx, "cannot write reply: %s\n", strerror(-err));
 	}
 }
 
 int main(void)
 {
-	debug_f = fopen("/dev/kmsg", "w");
-	setvbuf(debug_f, 0, _IOLBF, 0);
-	fprintf(debug_f, "<5>Started bpfilter\n");
-	loop();
-	fclose(debug_f);
+	struct context ctx;
+	int err;
+
+	err = create_context(&ctx);
+	if (err)
+		return err;
+
+	err = setup_context(&ctx);
+	if (err) {
+		free_context(&ctx);
+		return err;
+	}
+
+	BFLOG_NOTICE(&ctx, "started\n");
+
+	loop(&ctx);
+
 	return 0;
 }
-- 
2.25.1

