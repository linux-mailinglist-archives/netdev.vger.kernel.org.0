Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0963E31F6D8
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 10:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhBSJy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 04:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhBSJx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 04:53:58 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A5AC061793
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 01:52:16 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m1so6936363wml.2
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 01:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cI+4Q9B2K94JT+5DcTEoKVkp9ZKpdCHdFbImC42RINU=;
        b=sOjSX4XLxkhRgKrDWLPNLVFyYL2nxwz8wDFyy9n47iTLgx+oAFtTXLXx5GyakWUSuk
         JY+c0/KXN3bSzzzgdn03/tLhVOs1D6SD5JK7tPOzkxkCcupzAYqxNlo3Q/cqUv/crvPT
         /YUxHd1vwi5NKyxkr4x0WC0O4u1pJG6WBlXO0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cI+4Q9B2K94JT+5DcTEoKVkp9ZKpdCHdFbImC42RINU=;
        b=WmdQYO8ksbzOy8/dWqa1dwDjSDfiZGc4GG7/ZMDEsw/K727QTrcW3zP8FhvjxsQq3r
         UkPLjR/+7quUHef23BsVKMnst5a97KR6IOnS+ozSlFBRTm739Yd/r0IrOv3Nx+Dy5PKM
         5eyObPS5FhGAIi/03aWcrXSCYFE0vIAfC130s9c8KJjiwr5u7vBdm4ULabBQ72Rkk2N/
         WzhLHdpi+G0fOglg4wpoJFFJhailTFrIBrXN/ZFStluyIfKIs3j7Y20/xJlet2R0K+LP
         c+30tl0Y2YzQneOrEaIEzBOBR4tn5ZB0PWnu3wy4Pr8Q2O5Dqwq3vXTm/KZ18aWgQaiN
         cuuw==
X-Gm-Message-State: AOAM533EOGYZbVu+ao3OpIdszlsyMG2iJvbxsZjlPiy6bVSxWsbwg5SR
        dewd5FXucoKDNpo9fZ+LXpkYZw==
X-Google-Smtp-Source: ABdhPJz2buEuxtL4Cu0yPivg2+t1fFlai5FSk7Pn7XapoLj7gwquVDbZrvzPXiPIcKciflar2OuubA==
X-Received: by 2002:a05:600c:3551:: with SMTP id i17mr7318051wmq.92.1613728335326;
        Fri, 19 Feb 2021 01:52:15 -0800 (PST)
Received: from antares.lan (b.3.5.8.9.a.e.c.e.a.6.2.c.1.9.b.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:b91c:26ae:cea9:853b])
        by smtp.gmail.com with ESMTPSA id a21sm13174910wmb.5.2021.02.19.01.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 01:52:15 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v2 3/4] tools/testing: add test for NS_GET_COOKIE
Date:   Fri, 19 Feb 2021 09:51:48 +0000
Message-Id: <20210219095149.50346-4-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210219095149.50346-1-lmb@cloudflare.com>
References: <20210219095149.50346-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check that NS_GET_COOKIE returns a non-zero value, and that distinct
network namespaces have different cookies.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/nsfs/.gitignore |  1 +
 tools/testing/selftests/nsfs/Makefile   |  2 +-
 tools/testing/selftests/nsfs/config     |  1 +
 tools/testing/selftests/nsfs/netns.c    | 57 +++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/nsfs/netns.c

diff --git a/tools/testing/selftests/nsfs/.gitignore b/tools/testing/selftests/nsfs/.gitignore
index ed79ebdf286e..ca31b216215b 100644
--- a/tools/testing/selftests/nsfs/.gitignore
+++ b/tools/testing/selftests/nsfs/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 owner
 pidns
+netns
diff --git a/tools/testing/selftests/nsfs/Makefile b/tools/testing/selftests/nsfs/Makefile
index dd9bd50b7b93..93793cdb5a7c 100644
--- a/tools/testing/selftests/nsfs/Makefile
+++ b/tools/testing/selftests/nsfs/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-TEST_GEN_PROGS := owner pidns
+TEST_GEN_PROGS := owner pidns netns
 
 CFLAGS := -Wall -Werror
 
diff --git a/tools/testing/selftests/nsfs/config b/tools/testing/selftests/nsfs/config
index 598d0a225fc9..ea654f6a4cd9 100644
--- a/tools/testing/selftests/nsfs/config
+++ b/tools/testing/selftests/nsfs/config
@@ -1,3 +1,4 @@
 CONFIG_USER_NS=y
 CONFIG_UTS_NS=y
 CONFIG_PID_NS=y
+CONFIG_NET_NS=y
diff --git a/tools/testing/selftests/nsfs/netns.c b/tools/testing/selftests/nsfs/netns.c
new file mode 100644
index 000000000000..8ab862667b45
--- /dev/null
+++ b/tools/testing/selftests/nsfs/netns.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <sched.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+
+#define NSIO    0xb7
+#define NS_GET_COOKIE   _IO(NSIO, 0x5)
+
+#define pr_err(fmt, ...) \
+		({ \
+			fprintf(stderr, "%s:%d:" fmt ": %m\n", \
+				__func__, __LINE__, ##__VA_ARGS__); \
+			1; \
+		})
+
+int main(int argc, char *argvp[])
+{
+	uint64_t cookie1, cookie2;
+	char path[128];
+	int ns;
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/net", getpid());
+	ns = open(path, O_RDONLY);
+	if (ns < 0)
+		return pr_err("Unable to open %s", path);
+
+	if (ioctl(ns, NS_GET_COOKIE, &cookie1))
+		return pr_err("Unable to get first namespace cookie");
+
+	if (!cookie1)
+		return pr_err("NS_GET_COOKIE returned zero first cookie");
+
+	close(ns);
+	if (unshare(CLONE_NEWNET))
+		return pr_err("unshare");
+
+	ns = open(path, O_RDONLY);
+	if (ns < 0)
+		return pr_err("Unable to open %s", path);
+
+	if (ioctl(ns, NS_GET_COOKIE, &cookie2))
+		return pr_err("Unable to get second namespace cookie");
+
+	if (!cookie2)
+		return pr_err("NS_GET_COOKIE returned zero second cookie");
+
+	if (cookie1 == cookie2)
+		return pr_err("NS_GET_COOKIE returned identical cookies for distinct ns");
+
+	close(ns);
+	return 0;
+}
-- 
2.27.0

