Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F11641A42B
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 02:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238345AbhI1AYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 20:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238338AbhI1AYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 20:24:12 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E70C061575;
        Mon, 27 Sep 2021 17:22:33 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id a14so12356867qvb.6;
        Mon, 27 Sep 2021 17:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ysNfuXl1HWktNtOSEF03F01sMlIv53eUMXjaR2LS9EI=;
        b=mfbvn6Qxb6H5yu9MBKFaH1blJHXyyl+qYEPAg/celuM9VfEGhGJ4m/qvS3DwYDqMQL
         ejS+hVvVEgRFEPlpGr+Q/YTCHgXNfBv++uKaoa0RiyKK/Rzdt5s5kCBgQeAktpeAIO27
         eWu7kd5fUCRkz4SAzZGR8N/d/gIO+d88L+T/Mhz2iIkopQeSXeHuv+f8v28XrFzBnW2X
         s2NS4W6D71O+GE90VXGwmsQJKyqk2BKohRXPjnOmqRMsyY0Pv2FPMDJI8QvN/gq38EVj
         ljn19XZCG794sldFHmsi9hTH8r1hyMm9ylbB3OwRaRhR/6VSGxhMBNqdXc+S+o6r3UKe
         JxtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ysNfuXl1HWktNtOSEF03F01sMlIv53eUMXjaR2LS9EI=;
        b=tFNlhNbK2X8H5hSmwGdt/O138rDhw1Am+IlDmCh2ccRW6+pU3Lzr9L1cagkOEZFNe+
         BiBmdez8jJM7buujx5rJTBpru2F2wgGh47bf9XGCAZxs2wKTyQeb+KzKPzLYxWfO3fcR
         gOdezfEcFwJlIbNk8SLd6ps4YK76nSjjT3up7qhqDt8qfngPHEFiWaxPwpAhSTN3B6Dg
         hP9r7A/ajLLdbwmhYlcdkZNPKEwa3nObGtGdr8hr71yz0n1LDbIRAnlPYXFW2VzgIzF/
         P0An4cw2IdyjHrHIPgBL/HWrM9fZ3wo0EI3pIS6UYMQAk4g9VNSF7oz2IRmQgqtZ+OxC
         fLfw==
X-Gm-Message-State: AOAM5305rLFZhaKmwuKPm/18Snx2fyQ6JtRIrjeCc6u0keJBNHTNLiQW
        cRNAdseEqewDG2/EyAJCVpaYdbpqQtk=
X-Google-Smtp-Source: ABdhPJym2LnHEd0GiuOeqwhiDRZsx3z9TI7/b3Dza6Owd2Zidjuvp+sEWx+V9mNAlY7NSLLxpA+Iaw==
X-Received: by 2002:a0c:914f:: with SMTP id q73mr2935533qvq.39.1632788552978;
        Mon, 27 Sep 2021 17:22:32 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1ce2:35c5:917e:20d7])
        by smtp.gmail.com with ESMTPSA id 31sm5672308qtb.85.2021.09.27.17.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 17:22:32 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Yucong Sun <sunyucong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf v2 4/4] selftests/bpf: use recv_timeout() instead of retries
Date:   Mon, 27 Sep 2021 17:22:12 -0700
Message-Id: <20210928002212.14498-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210928002212.14498-1-xiyou.wangcong@gmail.com>
References: <20210928002212.14498-1-xiyou.wangcong@gmail.com>
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

