Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFB1183D71
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCLXhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:37:08 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42051 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbgCLXhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:37:01 -0400
Received: by mail-pf1-f193.google.com with SMTP id x2so3683882pfn.9;
        Thu, 12 Mar 2020 16:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZqvU3iR8LseT5SJn9pOSnOH26FC08L++zPQlCj0mZhE=;
        b=KkQpsqI0ByNlzedPjWpqlbvlKpXCMI+p9Ya8LD7CrXWFWTQ+sYKB2lv3toEc3HCWV7
         NLHUUExT62YgAEeWJYEMFGnTr52O1zTSolM03c4lNDMZ0VnCQdyq+523XgiqAWiLTb5h
         XOTIlGTOkahdAXFk8z8iULslIs4ErrNgjIt2zTLevOglfVnHlPiOeive2Jdrm4Wn540K
         SfLXi1OpHy3RmxvobpepMfQA4FIJoSA+kSHqBdt5uM69P89yJkbhu2EnoWiGLJjEZ/TF
         BCtpjFNCvf8bHVV2AHHDt1CjpUTrukobkie+iEmoitTWy0qTALAKIpE8r7By1cZWFtbz
         iu7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ZqvU3iR8LseT5SJn9pOSnOH26FC08L++zPQlCj0mZhE=;
        b=pmvQwGv7rw20bf7pUN98GKpUzCBHiPrFvaGv2Lu/4jmxXl+Y6sY8xjEHKzMjlgLNRK
         nXGWdeB4OItevC+cKp2Kc7anRBikak/TvYZxWPY7b+b3UOcsU7PfOyB15umZJ0B3RZx/
         A+m9hCwngluzBfwsjFhKaXcAqUjge0Iz7Xlye5e0+TTwC7/aWpBQr1mFyev5xQxZuWi9
         83eNAxKz4BHy1BI1ou+JZy8mgdJAOuA7WvHstM5Qx1GxrBrIt/wO3drGxhGwSuvSiXvk
         KYVYDOkWRp2YkQMhh3Ap9Qd9eNSw5v7/XAfw6MVX9HwjS/36WaIQbb80oDHHx3BZouo4
         SFww==
X-Gm-Message-State: ANhLgQ2bkRUGn5JVJ6EzgSrvVMj5mEhii3/VWpkE3/GLdL6xTef6foa/
        gZM3xzSZAVCUyd2yLPMfZ0xDvVWo
X-Google-Smtp-Source: ADFU+vtyVhzFNrqzRpKPYuG9qDnpkjaysGRu1LlD6QE3W5NfQeW2bRX6TCaNWgNtBf5v2elgDm7dxA==
X-Received: by 2002:a63:9c4:: with SMTP id 187mr9905794pgj.389.1584056219920;
        Thu, 12 Mar 2020 16:36:59 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id d6sm5075225pfn.214.2020.03.12.16.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 16:36:59 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com
Subject: [PATCH bpf-next 7/7] selftests: bpf: Improve debuggability of sk_assign
Date:   Thu, 12 Mar 2020 16:36:48 -0700
Message-Id: <20200312233648.1767-8-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312233648.1767-1-joe@wand.net.nz>
References: <20200312233648.1767-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test was a bit obtuse before, add a shorter timeout when
connectivity doesn't work and a '-d' debug flag for extra output.

Signed-off-by: Joe Stringer <joe@wand.net.nz>
---
 tools/testing/selftests/bpf/test_sk_assign.c  | 42 +++++++++++++++++++
 tools/testing/selftests/bpf/test_sk_assign.sh |  2 +-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sk_assign.c b/tools/testing/selftests/bpf/test_sk_assign.c
index 4b7b9bbe7859..51d3d01d5476 100644
--- a/tools/testing/selftests/bpf/test_sk_assign.c
+++ b/tools/testing/selftests/bpf/test_sk_assign.c
@@ -3,6 +3,8 @@
 // Copyright (c) 2019 Cloudflare
 // Copyright (c) 2020 Isovalent. Inc.
 
+#include <fcntl.h>
+#include <signal.h>
 #include <string.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -20,6 +22,14 @@
 
 #define TEST_DADDR (0xC0A80203)
 
+static bool debug;
+
+#define debugf(format, ...)				\
+do {							\
+	if (debug)					\
+		printf(format, ##__VA_ARGS__);		\
+} while (0)
+
 static int start_server(const struct sockaddr *addr, socklen_t len)
 {
 	int fd;
@@ -49,6 +59,17 @@ static int start_server(const struct sockaddr *addr, socklen_t len)
 	return fd;
 }
 
+static void handle_timeout(int signum)
+{
+	if (signum == SIGALRM)
+		log_err("Timed out while connecting to server");
+	kill(0, SIGKILL);
+}
+
+static struct sigaction timeout_action = {
+	.sa_handler = handle_timeout,
+};
+
 static int connect_to_server(const struct sockaddr *addr, socklen_t len)
 {
 	int fd = -1;
@@ -59,6 +80,12 @@ static int connect_to_server(const struct sockaddr *addr, socklen_t len)
 		goto out;
 	}
 
+	if (sigaction(SIGALRM, &timeout_action, NULL)) {
+		log_err("Failed to configure timeout signal");
+		goto out;
+	}
+
+	alarm(3);
 	if (connect(fd, addr, len) == -1) {
 		log_err("Fail to connect to server");
 		goto close_out;
@@ -141,6 +168,17 @@ int main(int argc, char **argv)
 	int server_v6 = -1;
 	int err = 1;
 
+	if (argc > 1) {
+		if (!memcmp(argv[1], "-h", 2)) {
+			printf("usage: %s.sh [FLAGS]\n", argv[0]);
+			printf("  -d\tEnable debug logs\n");
+			printf("  -h\tPrint help message\n");
+			exit(1);
+		}
+		if (!memcmp(argv[1], "-d", 2))
+			debug = true;
+	}
+
 	memset(&addr4, 0, sizeof(addr4));
 	addr4.sin_family = AF_INET;
 	addr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
@@ -166,9 +204,11 @@ int main(int argc, char **argv)
 
 	if (run_test(server, (const struct sockaddr *)&addr4, sizeof(addr4)))
 		goto out;
+	debugf("ipv4 port: ok\n");
 
 	if (run_test(server_v6, (const struct sockaddr *)&addr6, sizeof(addr6)))
 		goto out;
+	debugf("ipv6 port: ok\n");
 
 	/* Connect to unbound addresses */
 	addr4.sin_addr.s_addr = htonl(TEST_DADDR);
@@ -176,9 +216,11 @@ int main(int argc, char **argv)
 
 	if (run_test(server, (const struct sockaddr *)&addr4, sizeof(addr4)))
 		goto out;
+	debugf("ipv4 addr: ok\n");
 
 	if (run_test(server_v6, (const struct sockaddr *)&addr6, sizeof(addr6)))
 		goto out;
+	debugf("ipv6 addr: ok\n");
 
 	printf("ok\n");
 	err = 0;
diff --git a/tools/testing/selftests/bpf/test_sk_assign.sh b/tools/testing/selftests/bpf/test_sk_assign.sh
index de1df4e438de..5a84ad18f85a 100755
--- a/tools/testing/selftests/bpf/test_sk_assign.sh
+++ b/tools/testing/selftests/bpf/test_sk_assign.sh
@@ -19,4 +19,4 @@ tc qdisc add dev lo clsact
 tc filter add dev lo ingress bpf direct-action object-file ./test_sk_assign.o \
 	section "sk_assign_test"
 
-exec ./test_sk_assign
+exec ./test_sk_assign "$@"
-- 
2.20.1

