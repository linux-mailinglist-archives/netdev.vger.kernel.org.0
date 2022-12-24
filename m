Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBBD65567B
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 01:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236215AbiLXAGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 19:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbiLXAFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 19:05:44 -0500
X-Greylist: delayed 745 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 23 Dec 2022 16:04:48 PST
Received: from 7.mo545.mail-out.ovh.net (7.mo545.mail-out.ovh.net [46.105.63.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4F71A800
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 16:04:47 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.109.143.149])
        by mo545.mail-out.ovh.net (Postfix) with ESMTPS id 5D3B725F9C;
        Sat, 24 Dec 2022 00:04:45 +0000 (UTC)
Received: from dev-fedora-x86-64.naccy.de (37.65.8.229) by
 DAG10EX1.indiv4.local (172.16.2.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 01:04:44 +0100
From:   Quentin Deslandes <qde@naccy.de>
To:     <qde@naccy.de>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Dmitrii Banshchikov <me@ubique.spb.ru>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@meta.com>
Subject: [PATCH bpf-next v3 16/16] bpfilter: handle setsockopt() calls
Date:   Sat, 24 Dec 2022 01:04:02 +0100
Message-ID: <20221224000402.476079-17-qde@naccy.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221224000402.476079-1-qde@naccy.de>
References: <20221224000402.476079-1-qde@naccy.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS6.indiv4.local (172.16.1.6) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 4763963984512609911
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrheefgddujecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpefsuhgvnhhtihhnucffvghslhgrnhguvghsuceoqhguvgesnhgrtggthidruggvqeenucggtffrrghtthgvrhhnpeduledugfeileetvdelieeujedttedtvedtgfetteevfeejhfffkeeujeetfffgudenucfkphepuddvjedrtddrtddruddpfeejrdeihedrkedrvddvleenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehquggvsehnrggttgihrdguvgeqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepjhholhhsrgeskhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpmhgvsehusghiqhhuvgdrshhpsgdrrhhupdhshhhurghhsehkvghrnhgvlhdrohhrghdpmhihkhholhgrlhesfhgsrdgtohhmpdhprggsvghnihesrhgvughhrghtrdgtohhmpdhkuhgsrg
 eskhgvrhhnvghlrdhorhhgpdgvughumhgriigvthesghhoohhglhgvrdgtohhmpdgurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdphhgrohhluhhosehgohhoghhlvgdrtghomhdpshgufhesghhoohhglhgvrdgtohhmpdhkphhsihhnghhhsehkvghrnhgvlhdrohhrghdpjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhmpdihhhhssehfsgdrtghomhdpshhonhhgsehkvghrnhgvlhdrohhrghdpmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghvpdgrnhgurhhiiheskhgvrhhnvghlrdhorhhgpdgurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprghstheskhgvrhhnvghlrdhorhhgpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheeghedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use earlier introduced infrastructure and handle setsockopt(2) calls.

Co-developed-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Quentin Deslandes <qde@naccy.de>
---
 net/bpfilter/main.c | 132 ++++++++++++++++++++++++++++++--------------
 1 file changed, 90 insertions(+), 42 deletions(-)

diff --git a/net/bpfilter/main.c b/net/bpfilter/main.c
index 291a92546246..c157277c48b5 100644
--- a/net/bpfilter/main.c
+++ b/net/bpfilter/main.c
@@ -1,64 +1,112 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
 #define _GNU_SOURCE
-#include <sys/uio.h>
+
 #include <errno.h>
 #include <stdio.h>
-#include <sys/socket.h>
-#include <fcntl.h>
+#include <stdlib.h>
+#include <sys/types.h>
 #include <unistd.h>
-#include "../../include/uapi/linux/bpf.h"
-#include <asm/unistd.h>
+
+#include "context.h"
+#include "filter-table.h"
+#include "logger.h"
 #include "msgfmt.h"
+#include "sockopt.h"
 
-FILE *debug_f;
+#define do_exact(fd, op, buffer, count)							  \
+	({										  \
+		typeof(count) __count = count;						  \
+		size_t total = 0;							  \
+		int r = 0;								  \
+											  \
+		do {									  \
+			const ssize_t part = op(fd, (buffer) + total, (__count) - total); \
+			if (part > 0) {							  \
+				total += part;						  \
+			} else if (part == 0 && (__count) > 0) {			  \
+				r = -EIO;						  \
+				break;							  \
+			} else if (part == -1) {					  \
+				if (errno == EINTR)					  \
+					continue;					  \
+				r = -errno;						  \
+				break;							  \
+			}								  \
+		} while (total < (__count));						  \
+											  \
+		r;									  \
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
+}
+
+static int write_exact(int fd, const void *buffer, size_t count)
+{
+	return do_exact(fd, write, buffer, count);
 }
 
-static int handle_set_cmd(struct mbox_request *cmd)
+static int setup_context(struct context *ctx)
 {
-	return -ENOPROTOOPT;
+	int r;
+
+	r = logger_init();
+	if (r < 0)
+		return r;
+
+	BFLOG_DBG("log file opened and ready to use");
+
+	r = create_filter_table(ctx);
+	if (r < 0)
+		BFLOG_ERR("failed to created filter table: %s", STRERR(r));
+
+	return r;
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
+	int r;
+
+	for (;;) {
+		r = read_exact(STDIN_FILENO, &req, sizeof(req));
+		if (r)
+			BFLOG_EMERG("cannot read request: %s", STRERR(r));
+
+		reply.status = handle_sockopt_request(ctx, &req);
+
+		r = write_exact(STDOUT_FILENO, &reply, sizeof(reply));
+		if (r)
+			BFLOG_EMERG("cannot write reply: %s", STRERR(r));
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
+	int r;
+
+	r = create_context(&ctx);
+	if (r)
+		return r;
+
+	r = setup_context(&ctx);
+	if (r) {
+		free_context(&ctx);
+		return r;
+	}
+
+	loop(&ctx);
+
+	// Disregard return value, the application is closed anyway.
+	(void)logger_clean();
+
 	return 0;
 }
-- 
2.38.1

