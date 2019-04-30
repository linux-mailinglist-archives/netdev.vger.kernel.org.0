Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E1CFE2F
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 18:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbfD3QyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 12:54:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfD3QyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 12:54:19 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 94EAA30832CC;
        Tue, 30 Apr 2019 16:54:19 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC0F36248E;
        Tue, 30 Apr 2019 16:54:18 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2-next v2] tc: add support for plug qdisc
Date:   Tue, 30 Apr 2019 18:53:57 +0200
Message-Id: <fe5c248b0eb19a2dd42bb1bff8a0c40c1e9e969f.1556640913.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 30 Apr 2019 16:54:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sch_plug can be used to perform functional qdisc unit tests
controlling explicitly the queuing behaviour from user-space.

Plug support lacks since its introduction in 2012. This change
introduces basic support, to control the tc status.

v1 -> v2:
 - use the SPDX identifier

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tc/Makefile |  1 +
 tc/q_plug.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)
 create mode 100644 tc/q_plug.c

diff --git a/tc/Makefile b/tc/Makefile
index 2edaf2c8..1a305cf4 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -75,6 +75,7 @@ TCMODULES += f_matchall.o
 TCMODULES += q_cbs.o
 TCMODULES += q_etf.o
 TCMODULES += q_taprio.o
+TCMODULES += q_plug.o
 
 TCSO :=
 ifeq ($(TC_CONFIG_ATM),y)
diff --git a/tc/q_plug.c b/tc/q_plug.c
new file mode 100644
index 00000000..2c1c1a0b
--- /dev/null
+++ b/tc/q_plug.c
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * q_log.c		plug scheduler
+ *
+ * Copyright (C) 2019	Paolo Abeni <pabeni@redhat.com>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <string.h>
+
+#include "utils.h"
+#include "tc_util.h"
+
+static void explain(void)
+{
+	fprintf(stderr, "Usage: ... plug [block | release | release_indefinite | limit NUMBER]\n");
+}
+
+static int plug_parse_opt(struct qdisc_util *qu, int argc, char **argv,
+			  struct nlmsghdr *n, const char *dev)
+{
+	struct tc_plug_qopt opt = {};
+	int ok = 0;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "block") == 0) {
+			opt.action = TCQ_PLUG_BUFFER;
+			ok++;
+		} else if (strcmp(*argv, "release") == 0) {
+			opt.action = TCQ_PLUG_RELEASE_ONE;
+			ok++;
+		} else if (strcmp(*argv, "release_indefinite") == 0) {
+			opt.action = TCQ_PLUG_RELEASE_INDEFINITE;
+			ok++;
+		} else if (strcmp(*argv, "limit") == 0) {
+			opt.action = TCQ_PLUG_LIMIT;
+			NEXT_ARG();
+			if (get_size(&opt.limit, *argv)) {
+				fprintf(stderr, "Illegal value for \"limit\": \"%s\"\n", *argv);
+				return -1;
+			}
+			ok++;
+		} else if (strcmp(*argv, "help") == 0) {
+			explain();
+			return -1;
+		} else {
+			fprintf(stderr, "%s: unknown parameter \"%s\"\n", qu->id, *argv);
+			explain();
+			return -1;
+		}
+		argc--; argv++;
+	}
+
+	if (ok)
+		addattr_l(n, 1024, TCA_OPTIONS, &opt, sizeof(opt));
+	return 0;
+}
+
+static int plug_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
+{
+	/* dummy implementation as sch_plug does not implement a dump op */
+	return 0;
+}
+
+
+struct qdisc_util plug_qdisc_util = {
+	.id = "plug",
+	.parse_qopt = plug_parse_opt,
+	.print_qopt = plug_print_opt,
+};
-- 
2.20.1

