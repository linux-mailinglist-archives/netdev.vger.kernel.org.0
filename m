Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BDE399EB1
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFCKSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:18:04 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:33280 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhFCKSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:18:01 -0400
Received: by mail-wr1-f52.google.com with SMTP id a20so5305049wrc.0
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 03:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DfMkpPCPjdgbpWmKQnrpYpCDmXhDFmEEf/aT0PcTt60=;
        b=DtrMHmWsg+r4cLaW8247DPMNoo/AUnlsm+VbiZREnKvR8tWuraAPeShAcEq3CDXrtY
         XDrV81nzfcjQCB3VBT1jNvV5nk2Tl2I+WpOwRW3X/n946caBk58YKy+wuQ5bSRIKrY2d
         jPbsWk4mO/iwCflRRBtfs5N9Hji1IrclmnxjCNP4pkUj1IfYUT35QC4uvf0JKzZNac4n
         pm5RXQgdf2KVwHFJguydR4kv/fiOmgFsr+lnOFFfuDV/G9/3Qxz0110AVU5qKuaEeAHN
         s/8PtMai0A1A/Q9NZzq3xgqDoscwewv4A1F/MEoMhy604AZbzGnQpodFbl+204pdkVvj
         iWAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DfMkpPCPjdgbpWmKQnrpYpCDmXhDFmEEf/aT0PcTt60=;
        b=STBKAUUQSxqPNcmtZTA37UaIfFQqGp78aRHPPzTGr9NfpzX0kbpuTrCO8Qn6+fouPN
         mQnIuzAAJ4sr3Yg+ZURsHaYk+pBI+KmprtzfgGXPa7JDfYxqBWxzqA19MAqPG4J+VBWi
         If7wModQkNyYFdG5LZbTg2c98eqU44iegtuHtq1qZNWTjrbUszvHVhwFRBegghz9h+T4
         hU5rIpwTPs6x7xgK0FKjjGznVeVFdX0N+FmTDhSw0+po0INs60iPMM3BFdskGUnvyo43
         2qoWah4OF6zRcgY93IrBMz53p78Oimi9JzYaUCxgtZqm0AnLmQw9+VJSyKEGkyX455y0
         lZgA==
X-Gm-Message-State: AOAM5337krYCUgk0d6TTiiRd3IFxaarmICkL6d8DYlLGPBGDxZpcQou2
        yAuI1ZiNcNrQpoQNPAoxFdYsEg==
X-Google-Smtp-Source: ABdhPJwgK/HcAnen5Jd7wxKBlwBeLtfiOE90l69RDATRfoai0y2BnDFDuZVyn+CbCPvYa+Ym1UoTtw==
X-Received: by 2002:a5d:628d:: with SMTP id k13mr12050340wru.410.1622715316029;
        Thu, 03 Jun 2021 03:15:16 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id q5sm2296228wmc.0.2021.06.03.03.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 03:15:15 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v1 10/10] bpfilter: Handle setsockopts
Date:   Thu,  3 Jun 2021 14:14:25 +0400
Message-Id: <20210603101425.560384-11-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210603101425.560384-1-me@ubique.spb.ru>
References: <20210603101425.560384-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use earlier introduced infrastructure for and handle setsockopt(2)
calls.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/main.c | 123 +++++++++++++++++++++++++++++---------------
 1 file changed, 81 insertions(+), 42 deletions(-)

diff --git a/net/bpfilter/main.c b/net/bpfilter/main.c
index 05e1cfc1e5cd..4c04898530cf 100644
--- a/net/bpfilter/main.c
+++ b/net/bpfilter/main.c
@@ -1,64 +1,103 @@
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
 #include "msgfmt.h"
+#include "sockopt.h"
 
-FILE *debug_f;
+#define do_exact(fd, op, buffer, count)                                                            \
+	({                                                                                         \
+		size_t total = 0;                                                                  \
+		int err = 0;                                                                       \
+												   \
+		do {                                                                               \
+			const ssize_t part = op(fd, (buffer) + total, (count) - total);            \
+			if (part > 0) {                                                            \
+				total += part;                                                     \
+			} else if (part == 0 && (count) > 0) {                                     \
+				err = -EIO;                                                        \
+				break;                                                             \
+			} else if (part == -1) {                                                   \
+				if (errno == EINTR)                                                \
+					continue;                                                  \
+				err = -errno;                                                      \
+				break;                                                             \
+			}                                                                          \
+		} while (total < (count));                                                         \
+												   \
+		err;                                                                               \
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
+}
+
+static int setup_context(struct context *ctx)
+{
+	ctx->log_file = fopen("/dev/kmsg", "w");
+	if (!ctx->log_file)
+		return -errno;
+
+	setvbuf(ctx->log_file, 0, _IOLBF, 0);
+
+	return 0;
 }
 
-static void loop(void)
+static void loop(struct context *ctx)
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
-	fprintf(debug_f, "Started bpfilter\n");
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

