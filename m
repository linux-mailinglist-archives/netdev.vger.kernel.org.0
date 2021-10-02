Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE5841F8C4
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 02:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhJBAjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 20:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbhJBAjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 20:39:01 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803BEC061775;
        Fri,  1 Oct 2021 17:37:16 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id a17-20020a4a6851000000b002b59bfbf669so3373264oof.9;
        Fri, 01 Oct 2021 17:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ysNfuXl1HWktNtOSEF03F01sMlIv53eUMXjaR2LS9EI=;
        b=DLUXIVZoHqRRmgx/OCyrIhFldIBJDu3r0bEi1mzXJgs7nySRlUodI0cUe+56xnLmpk
         65WfAqecfWonvMWf5Xa4yyz73VCOGJHeFPw3PPNq5YBhK1DgNPrTJMbGHnuuDaHDLj9p
         ZLxGB0KRoEJaEhCPjADL+FokaArkuLqlKBRZ4qT1vI/krjZ5oyR8Yrj91zbGEV0C8Lbg
         Ryk2ElROgranMBBYZDMB+xe0mTtzxFhSVbBukMBbZkGR76/6KSfXiwMJzdvmq4p5yJLg
         7ek+b5mReVHdsp5oByPIWYUAxq3wOyqqRA6i8Sk1ch/rUHupQFuLzb3jmBWnLjYefKl4
         h9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ysNfuXl1HWktNtOSEF03F01sMlIv53eUMXjaR2LS9EI=;
        b=NVr1tP/B6/qvTEDI1E6zmFhs+EKQ3P1LyOxHjnd3sNb9e7SrnZmfj5wKScbkkOP8YS
         MspP4LiRB/vpgFRL7hmd6hn0ELd+B7ecHXvFzisFcRadN1a2Mew6s5o4gS76EhtuMbkK
         ex/5e0FLv46Bw9xeJPnJ6MVCkANqko+XXKEHpQJ94sRnwRRzIB168tL98uQQqPvSSfYv
         Tox/KfVuAlWWNqSFHep9F2DDcGpQsOCR5sEfgRein4meh9W0SxWU+tuKr/BQs8qQqjL/
         hgFmoUAQdaw/qOV8GHTizNeq2XRboxNzCxYfDrbjLrME+6tIGg7v16LHd/eXavwfkD0h
         f5JQ==
X-Gm-Message-State: AOAM531F5ANvjGP4/sppYhxhcREmRzY79EAzf+j6nEkR4SP+HsBJ5wrX
        v5yKsLUpmlBli7vfPDxcWHDhlbsGJ3o=
X-Google-Smtp-Source: ABdhPJwjDVbqVGIP3qCag+f+jSB+XZ0l+4KUTeYWR+lknVLquafXL88SDbccLalpY4nCg8Q//959eg==
X-Received: by 2002:a05:6820:28f:: with SMTP id q15mr797773ood.78.1633135035727;
        Fri, 01 Oct 2021 17:37:15 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a62e:a53d:c4bc:b137])
        by smtp.gmail.com with ESMTPSA id p18sm1545017otk.7.2021.10.01.17.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 17:37:15 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Yucong Sun <sunyucong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf v3 4/4] selftests/bpf: use recv_timeout() instead of retries
Date:   Fri,  1 Oct 2021 17:37:06 -0700
Message-Id: <20211002003706.11237-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
References: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yucong Sun <sunyucong@gmail.com>

We use non-blocking sockets in those tests, retrying for
EAGAIN is ugly because there is no upper bound for the packet
arrival time, at least in theory. After we fix poll() on
sockmap sockets, now we can switch to select()+recv().

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Yucong Sun <sunyucong@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 75 +++++--------------
 1 file changed, 20 insertions(+), 55 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 5c5979046523..d88bb65b74cc 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -949,7 +949,6 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 	int err, n;
 	u32 key;
 	char b;
-	int retries = 100;
 
 	zero_verdict_count(verd_mapfd);
 
@@ -1002,17 +1001,11 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 		goto close_peer1;
 	if (pass != 1)
 		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
-again:
-	n = read(c0, &b, 1);
-	if (n < 0) {
-		if (errno == EAGAIN && retries--) {
-			usleep(1000);
-			goto again;
-		}
-		FAIL_ERRNO("%s: read", log_prefix);
-	}
+	n = recv_timeout(c0, &b, 1, 0, IO_TIMEOUT_SEC);
+	if (n < 0)
+		FAIL_ERRNO("%s: recv_timeout", log_prefix);
 	if (n == 0)
-		FAIL("%s: incomplete read", log_prefix);
+		FAIL("%s: incomplete recv", log_prefix);
 
 close_peer1:
 	xclose(p1);
@@ -1571,7 +1564,6 @@ static void unix_redir_to_connected(int sotype, int sock_mapfd,
 	const char *log_prefix = redir_mode_str(mode);
 	int c0, c1, p0, p1;
 	unsigned int pass;
-	int retries = 100;
 	int err, n;
 	int sfd[2];
 	u32 key;
@@ -1606,17 +1598,11 @@ static void unix_redir_to_connected(int sotype, int sock_mapfd,
 	if (pass != 1)
 		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
 
-again:
-	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
-	if (n < 0) {
-		if (errno == EAGAIN && retries--) {
-			usleep(1000);
-			goto again;
-		}
-		FAIL_ERRNO("%s: read", log_prefix);
-	}
+	n = recv_timeout(mode == REDIR_INGRESS ? p0 : c0, &b, 1, 0, IO_TIMEOUT_SEC);
+	if (n < 0)
+		FAIL_ERRNO("%s: recv_timeout", log_prefix);
 	if (n == 0)
-		FAIL("%s: incomplete read", log_prefix);
+		FAIL("%s: incomplete recv", log_prefix);
 
 close:
 	xclose(c1);
@@ -1748,7 +1734,6 @@ static void udp_redir_to_connected(int family, int sock_mapfd, int verd_mapfd,
 	const char *log_prefix = redir_mode_str(mode);
 	int c0, c1, p0, p1;
 	unsigned int pass;
-	int retries = 100;
 	int err, n;
 	u32 key;
 	char b;
@@ -1781,17 +1766,11 @@ static void udp_redir_to_connected(int family, int sock_mapfd, int verd_mapfd,
 	if (pass != 1)
 		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
 
-again:
-	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
-	if (n < 0) {
-		if (errno == EAGAIN && retries--) {
-			usleep(1000);
-			goto again;
-		}
-		FAIL_ERRNO("%s: read", log_prefix);
-	}
+	n = recv_timeout(mode == REDIR_INGRESS ? p0 : c0, &b, 1, 0, IO_TIMEOUT_SEC);
+	if (n < 0)
+		FAIL_ERRNO("%s: recv_timeout", log_prefix);
 	if (n == 0)
-		FAIL("%s: incomplete read", log_prefix);
+		FAIL("%s: incomplete recv", log_prefix);
 
 close_cli1:
 	xclose(c1);
@@ -1841,7 +1820,6 @@ static void inet_unix_redir_to_connected(int family, int type, int sock_mapfd,
 	const char *log_prefix = redir_mode_str(mode);
 	int c0, c1, p0, p1;
 	unsigned int pass;
-	int retries = 100;
 	int err, n;
 	int sfd[2];
 	u32 key;
@@ -1876,17 +1854,11 @@ static void inet_unix_redir_to_connected(int family, int type, int sock_mapfd,
 	if (pass != 1)
 		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
 
-again:
-	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
-	if (n < 0) {
-		if (errno == EAGAIN && retries--) {
-			usleep(1000);
-			goto again;
-		}
-		FAIL_ERRNO("%s: read", log_prefix);
-	}
+	n = recv_timeout(mode == REDIR_INGRESS ? p0 : c0, &b, 1, 0, IO_TIMEOUT_SEC);
+	if (n < 0)
+		FAIL_ERRNO("%s: recv_timeout", log_prefix);
 	if (n == 0)
-		FAIL("%s: incomplete read", log_prefix);
+		FAIL("%s: incomplete recv", log_prefix);
 
 close_cli1:
 	xclose(c1);
@@ -1932,7 +1904,6 @@ static void unix_inet_redir_to_connected(int family, int type, int sock_mapfd,
 	int sfd[2];
 	u32 key;
 	char b;
-	int retries = 100;
 
 	zero_verdict_count(verd_mapfd);
 
@@ -1963,17 +1934,11 @@ static void unix_inet_redir_to_connected(int family, int type, int sock_mapfd,
 	if (pass != 1)
 		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
 
-again:
-	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
-	if (n < 0) {
-		if (errno == EAGAIN && retries--) {
-			usleep(1000);
-			goto again;
-		}
-		FAIL_ERRNO("%s: read", log_prefix);
-	}
+	n = recv_timeout(mode == REDIR_INGRESS ? p0 : c0, &b, 1, 0, IO_TIMEOUT_SEC);
+	if (n < 0)
+		FAIL_ERRNO("%s: recv_timeout", log_prefix);
 	if (n == 0)
-		FAIL("%s: incomplete read", log_prefix);
+		FAIL("%s: incomplete recv", log_prefix);
 
 close:
 	xclose(c1);
-- 
2.30.2

