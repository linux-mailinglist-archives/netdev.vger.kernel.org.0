Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6781C61FD
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgEEU1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729037AbgEEU1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:27:37 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174CAC061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 13:27:37 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b6so3921211ybo.8
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 13:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+E1I84pnBiogXJ7OhzwoGGANKqMvG8H7kQ9I6DXtIwk=;
        b=oEkrfcBRZUaJIsSVP/MhAOHEbbMeXXGlQD4F7s7i4T7hQll3J/i8g28ywsueDCFKmW
         Y4jnVr95lRIvzbcc3X6KPtadXZKNeReC4fj++f/XJmr+rcEv5oNOrBMbVLw+gpN7qUy8
         Gc0nZE/DN26nhXuFo+1BULpdm+XXoSj8p4MliyCJlIOaNN40E2E3UhzRReejqxPr3kJy
         fYjstfFV5nVtMnOBBWKuAGVzXj4sq03HbPIieLKOjZY4oA/3a0OZesd/FpwilUM6fiuT
         fXoYJ76ZoxkjKd6GJYUY6bKe6i2mVIqQNaxGPZgSAKvo/DkY99xLZ46rQpn+kXMf5w0s
         vhmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+E1I84pnBiogXJ7OhzwoGGANKqMvG8H7kQ9I6DXtIwk=;
        b=iXYvb8LRPt1rlNq/hcGr7KT2yIR6o0lD2HgCw4r/1xnNfQ+ZGuj373iyukT6P03Ytt
         ZNwMt4tKETRS+jgBevHDH+8Wcgsob4IQefkB/fZh98zFVXBEXaqvWNAYJKb0r4siUWDz
         1wTIyTy3x+DdMqG9puvUi8GHIed28nxm9FjUl7JSlGuHTqwTJs0qAsdViRcAAmvtnJm6
         rRbr12Rf7rtP+fDEqpgFxUgesq0+929AbOCfL1Ypl9At3TM0gO3Ff+m91Irn8/jd3nXO
         R9l3fPDdkQvrevgCELj5R83ZE+Kk9LAIU3aOXfFSczGVJqNNvm71XadqHEQT6pZRb+/l
         KS5A==
X-Gm-Message-State: AGi0PuY88rnmQ6Xjx3fbJuAAGTBKlOf+xC1oncBNd+zlUNA4KNY6/BAV
        JgCMH4rVCuGP6yTZ/letI3wRJfUYHaN+8yy6SAyV/Ra/3k+Ya1nLiKlyfZvf0cop+BAw041dz3G
        pG8oM33eATqxlUV3YKBVIPr1oSDEaTCQiLKHgPYT5BCEkRPwb6u8Gjw==
X-Google-Smtp-Source: APiQypKq0cGsECMunZRtqCbvyY7hIxTruXrjKRIpUKzJmZvgu1BYnBy/JWd/JIix94smNgdQ4OAXwJY=
X-Received: by 2002:a25:cc48:: with SMTP id l69mr7750179ybf.130.1588710456212;
 Tue, 05 May 2020 13:27:36 -0700 (PDT)
Date:   Tue,  5 May 2020 13:27:27 -0700
In-Reply-To: <20200505202730.70489-1-sdf@google.com>
Message-Id: <20200505202730.70489-3-sdf@google.com>
Mime-Version: 1.0
References: <20200505202730.70489-1-sdf@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH bpf-next v2 2/5] selftests/bpf: adopt accept_timeout from sockmap_listen
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move accept_timeout and recv_timeout to the common place so they
can be reused by the other tests. Switch to accept_timeout() in
test_progs instead of doing while loop around accept().

This prevents the tests that use start_server_thread/stop_server_thread
from being stuck when the error occurs.

Cc: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/network_helpers.c | 43 +++++++++++++++----
 tools/testing/selftests/bpf/network_helpers.h |  4 ++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 35 +--------------
 3 files changed, 40 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index ee9386b033ed..30ef0c7edebf 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -82,14 +82,7 @@ static void *server_thread(void *arg)
 		return ERR_PTR(err);
 	}
 
-	while (true) {
-		client_fd = accept(fd, (struct sockaddr *)&addr, &len);
-		if (client_fd == -1 && errno == EAGAIN) {
-			usleep(50);
-			continue;
-		}
-		break;
-	}
+	client_fd = accept_timeout(fd, (struct sockaddr *)&addr, &len, 3);
 	if (CHECK_FAIL(client_fd < 0)) {
 		perror("Failed to accept client");
 		return ERR_PTR(err);
@@ -162,3 +155,37 @@ int connect_to_fd(int family, int server_fd)
 	close(fd);
 	return -1;
 }
+
+static int poll_read(int fd, unsigned int timeout_sec)
+{
+	struct timeval timeout = { .tv_sec = timeout_sec };
+	fd_set rfds;
+	int r;
+
+	FD_ZERO(&rfds);
+	FD_SET(fd, &rfds);
+
+	r = select(fd + 1, &rfds, NULL, NULL, &timeout);
+	if (r == 0)
+		errno = ETIME;
+
+	return r == 1 ? 0 : -1;
+}
+
+int accept_timeout(int fd, struct sockaddr *addr, socklen_t *len,
+		   unsigned int timeout_sec)
+{
+	if (poll_read(fd, timeout_sec))
+		return -1;
+
+	return accept(fd, addr, len);
+}
+
+int recv_timeout(int fd, void *buf, size_t len, int flags,
+		 unsigned int timeout_sec)
+{
+	if (poll_read(fd, timeout_sec))
+		return -1;
+
+	return recv(fd, buf, len, flags);
+}
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
index 1f3942160287..74e2c40667a2 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -7,5 +7,9 @@
 int start_server_thread(int family);
 void stop_server_thread(int fd);
 int connect_to_fd(int family, int server_fd);
+int accept_timeout(int fd, struct sockaddr *addr, socklen_t *len,
+		   unsigned int timeout_sec);
+int recv_timeout(int fd, void *buf, size_t len, int flags,
+		 unsigned int timeout_sec);
 
 #endif
diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index d7d65a700799..c2a78d8a110e 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -24,6 +24,7 @@
 
 #include "bpf_util.h"
 #include "test_progs.h"
+#include "network_helpers.h"
 #include "test_sockmap_listen.skel.h"
 
 #define IO_TIMEOUT_SEC 30
@@ -195,40 +196,6 @@
 		__ret;                                                         \
 	})
 
-static int poll_read(int fd, unsigned int timeout_sec)
-{
-	struct timeval timeout = { .tv_sec = timeout_sec };
-	fd_set rfds;
-	int r;
-
-	FD_ZERO(&rfds);
-	FD_SET(fd, &rfds);
-
-	r = select(fd + 1, &rfds, NULL, NULL, &timeout);
-	if (r == 0)
-		errno = ETIME;
-
-	return r == 1 ? 0 : -1;
-}
-
-static int accept_timeout(int fd, struct sockaddr *addr, socklen_t *len,
-			  unsigned int timeout_sec)
-{
-	if (poll_read(fd, timeout_sec))
-		return -1;
-
-	return accept(fd, addr, len);
-}
-
-static int recv_timeout(int fd, void *buf, size_t len, int flags,
-			unsigned int timeout_sec)
-{
-	if (poll_read(fd, timeout_sec))
-		return -1;
-
-	return recv(fd, buf, len, flags);
-}
-
 static void init_addr_loopback4(struct sockaddr_storage *ss, socklen_t *len)
 {
 	struct sockaddr_in *addr4 = memset(ss, 0, sizeof(*ss));
-- 
2.26.2.526.g744177e7f7-goog

