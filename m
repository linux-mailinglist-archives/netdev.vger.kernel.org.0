Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDA8655681
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 01:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbiLXAHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 19:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236512AbiLXAGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 19:06:46 -0500
X-Greylist: delayed 1164 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 23 Dec 2022 16:05:21 PST
Received: from 7.mo547.mail-out.ovh.net (7.mo547.mail-out.ovh.net [46.105.53.191])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62521A20F
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 16:05:19 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.110.115.196])
        by mo547.mail-out.ovh.net (Postfix) with ESMTPS id E382E20E4E;
        Fri, 23 Dec 2022 23:45:53 +0000 (UTC)
Received: from dev-fedora-x86-64.naccy.de (37.65.8.229) by
 DAG10EX1.indiv4.local (172.16.2.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 00:45:52 +0100
From:   Quentin Deslandes <qde@naccy.de>
To:     <qde@naccy.de>
CC:     <kernel-team@meta.com>, Alexei Starovoitov <ast@kernel.org>,
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
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: [PATCH bpf-next v3 03/16] bpfilter: add logging facility
Date:   Sat, 24 Dec 2022 00:40:11 +0100
Message-ID: <20221223234127.474463-4-qde@naccy.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221223234127.474463-1-qde@naccy.de>
References: <20221223234127.474463-1-qde@naccy.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS6.indiv4.local (172.16.1.6) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 4445897259362283127
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrheefgddugecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpefsuhgvnhhtihhnucffvghslhgrnhguvghsuceoqhguvgesnhgrtggthidruggvqeenucggtffrrghtthgvrhhnpeduledugfeileetvdelieeujedttedtvedtgfetteevfeejhfffkeeujeetfffgudenucfkphepuddvjedrtddrtddruddpfeejrdeihedrkedrvddvleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehquggvsehnrggttgihrdguvgeqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephhgrohhluhhosehgohhoghhlvgdrtghomhdpsghpfhesvhhgvghrrdhkvghrnhgvlhdrohhrghdplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhmvgesuhgsihhquhgvrdhsphgsrdhruhdpshhhuhgrhheskhgvrhhnvghlrdhorhhgpdhmhihkohhlrghlsehfsgdrtghomhdpphgrsggvnhhisehrvgguhhgrthdrtghomhdpkhhusggrsehkvghrnhgvlhdrohhrghdpvgguuhhmrgiivghtsehgohhoghhlvgdrtghomh
 dpuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdpjhholhhsrgeskhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhsughfsehgohhoghhlvgdrtghomhdpkhhpshhinhhghheskhgvrhhnvghlrdhorhhgpdhjohhhnhdrfhgrshhtrggsvghnugesghhmrghilhdrtghomhdphihhshesfhgsrdgtohhmpdhsohhngheskhgvrhhnvghlrdhorhhgpdhmrghrthhinhdrlhgruheslhhinhhugidruggvvhdprghnughrihhisehkvghrnhgvlhdrohhrghdpuggrnhhivghlsehiohhgvggrrhgsohigrdhnvghtpdgrshhtsehkvghrnhgvlhdrohhrghdpkhgvrhhnvghlqdhtvggrmhesmhgvthgrrdgtohhmpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheegjedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpfilter will log to /dev/kmsg by default. Four different log levels are
available. LOG_EMERG() will exit the usermode helper after logging.

Signed-off-by: Quentin Deslandes <qde@naccy.de>
---
 net/bpfilter/Makefile |  2 +-
 net/bpfilter/logger.c | 52 ++++++++++++++++++++++++++++
 net/bpfilter/logger.h | 80 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 133 insertions(+), 1 deletion(-)
 create mode 100644 net/bpfilter/logger.c
 create mode 100644 net/bpfilter/logger.h

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index cdac82b8c53a..8d9c726ba1a5 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -4,7 +4,7 @@
 #
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o
+bpfilter_umh-objs := main.o logger.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
diff --git a/net/bpfilter/logger.c b/net/bpfilter/logger.c
new file mode 100644
index 000000000000..c256bfef7e6c
--- /dev/null
+++ b/net/bpfilter/logger.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
+#include "logger.h"
+
+#include <errno.h>
+
+static const char *log_file_path = "/dev/kmsg";
+static FILE *log_file;
+
+int logger_init(void)
+{
+	if (log_file)
+		return 0;
+
+	log_file = fopen(log_file_path, "w");
+	if (!log_file)
+		return -errno;
+
+	if (setvbuf(log_file, 0, _IOLBF, 0))
+		return -errno;
+
+	return 0;
+}
+
+void logger_set_file(FILE *file)
+{
+	log_file = file;
+}
+
+FILE *logger_get_file(void)
+{
+	return log_file;
+}
+
+int logger_clean(void)
+{
+	int r;
+
+	if (!log_file)
+		return 0;
+
+	r = fclose(log_file);
+	if (r == EOF)
+		return -errno;
+
+	log_file = NULL;
+
+	return 0;
+}
diff --git a/net/bpfilter/logger.h b/net/bpfilter/logger.h
new file mode 100644
index 000000000000..c44739ec0069
--- /dev/null
+++ b/net/bpfilter/logger.h
@@ -0,0 +1,80 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
+#ifndef NET_BPFILTER_LOGGER_H
+#define NET_BPFILTER_LOGGER_H
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <syslog.h>
+
+#define _BFLOG_IMPL(level, fmt, ...)					      \
+	do {								      \
+		typeof(level) __level = level;				      \
+		if (logger_get_file()) {				      \
+			fprintf(logger_get_file(), "<%d>bpfilter: " fmt "\n", \
+				(__level), ##__VA_ARGS__);		      \
+		}							      \
+		if ((__level) == LOG_EMERG)				      \
+			exit(EXIT_FAILURE);				      \
+	} while (0)
+
+#define BFLOG_EMERG(fmt, ...) \
+	_BFLOG_IMPL(LOG_KERN | LOG_EMERG, fmt, ##__VA_ARGS__)
+#define BFLOG_ERR(fmt, ...) \
+	_BFLOG_IMPL(LOG_KERN | LOG_ERR, fmt, ##__VA_ARGS__)
+#define BFLOG_NOTICE(fmt, ...) \
+	_BFLOG_IMPL(LOG_KERN | LOG_NOTICE, fmt, ##__VA_ARGS__)
+
+#ifdef DEBUG
+#define BFLOG_DBG(fmt, ...) BFLOG_IMPL(LOG_KERN | LOG_DEBUG, fmt, ##__VA_ARGS__)
+#else
+#define BFLOG_DBG(fmt, ...)
+#endif
+
+#define STRERR(v) strerror(abs(v))
+
+/**
+ * logger_init() - Initialise logging facility.
+ *
+ * This function is used to open a file to write logs to (see @log_file_path).
+ * It must be called before using any logging macro, otherwise log messages
+ * will be discarded.
+ *
+ * Return: 0 on success, negative errno value on error.
+ */
+int logger_init(void);
+
+/**
+ * logger_set_file() - Set the FILE pointer to use to log messages.
+ * @file: new FILE * to the log file.
+ *
+ * This function won't check whether the FILE pointer is valid, nor whether
+ * a file is already opened, this is the responsibility of the caller. Once
+ * logger_set_file() returns, all new log messages will be printed to the
+ * FILE * provided.
+ */
+void logger_set_file(FILE *file);
+
+/**
+ * logger_get_file() - Returns a FILE * pointer to the log file.
+ *
+ * Return: pointer to the file to log to (as a FILE *), or NULL if the file
+ *	is not valid.
+ */
+FILE *logger_get_file(void);
+
+/**
+ * logger_clean() - Close the log file.
+ *
+ * On success, the log file pointer will be NULL. If the function fails,
+ * the log file pointer remain unchanged and the file should be considered open.
+ *
+ * Return: 0 on success, negative errno value on error.
+ */
+int logger_clean(void);
+
+#endif // NET_BPFILTER_LOGGER_H
-- 
2.38.1

