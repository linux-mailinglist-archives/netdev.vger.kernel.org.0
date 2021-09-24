Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD40417D7B
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344827AbhIXWHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344814AbhIXWHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:07:02 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD29C061571;
        Fri, 24 Sep 2021 15:05:29 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id t13so4968057qtc.7;
        Fri, 24 Sep 2021 15:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D8GRaF+Cd4vVYumfiCzzhE1rcgBnfSGVXamJ55BCvaM=;
        b=OZZLSyaqSJDyoWyRJjpJrBy6jcssEJuXeaxFzTDn519cyxpiuy4lzA1h+bDQbKuTVM
         0Xh2k4k4dlG4DNZkXMdMFZskop+8id58l5dNWQrPI0MnpbrdmRXa9hxl3Dx74GIIXwdd
         JEkYYJSBMiNciofawt2YghY3CgSN48xl835ZGR1H12QWfXC4ehp/KfaNfOpq7Qifd6nT
         aKcj42pNnEtTNZmHR0mU0tX9kntB4KHLuTMBqcxbFOH55BERaFkqpx/MTSaneQbbfX9E
         R7Szh5DGsvG+X2Uoo9iFTa1Mo6cN4zyneCqS1NGcYQAr0yaRcsp8fPKJ1TDxVZSf1SSk
         3+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D8GRaF+Cd4vVYumfiCzzhE1rcgBnfSGVXamJ55BCvaM=;
        b=dTcdHIkzN7B0y9UBtJKmi82OTIIKMV2UHh2GVm5Nrsyc8longipXYL82qiyZTpGVXy
         mZ3n3TfuesCKOC84kDvWbYEXBC/R2DjP7PoOfd0Bmo7cuv/keKxlHUpZaRGrg1JV68Gy
         8ddMAVUMHvwV/4XLMgTMddHeF5bd4eWhG7URj+/AZ3FPGY7T5kVXmFBTobyhfwvnmzh9
         0vstCByXlycqTr1EL2xllrRPn2Y3Ur1ab94/Lf0yPWDFbPaevpxkA3NQXgIjVTywOT1V
         fxUqHHO0K9t/j1hUIGcdHcn8SgeTJPX+TUR85d1oaylMDrheE7Fy9OTbfdV9uuX+xUFp
         fm0A==
X-Gm-Message-State: AOAM532s2KRbymdctU9MN7uNDoufty1Qo45F8VSV1HPyZQXuDPwGee5z
        B6DvqQIv65PoRelmoYRkEPiJndHFqvQ=
X-Google-Smtp-Source: ABdhPJxFQOSpXr1uOAYl59s+XdY5R0Osn1u0EyhkocvSlUiwJuDXmBUWfkk8J1ckJHJ2rqcyI7IDqQ==
X-Received: by 2002:ac8:6b98:: with SMTP id z24mr6895443qts.107.1632521128454;
        Fri, 24 Sep 2021 15:05:28 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c4dc:647c:f35b:bfc4])
        by smtp.gmail.com with ESMTPSA id h2sm7895683qkf.106.2021.09.24.15.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 15:05:28 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Yucong Sun <sunyucong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf 3/3] selftests/bpf: use recv_timeout() instead of retries
Date:   Fri, 24 Sep 2021 15:05:07 -0700
Message-Id: <20210924220507.24543-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924220507.24543-1-xiyou.wangcong@gmail.com>
References: <20210924220507.24543-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yucong Sun <sunyucong@gmail.com>

We use non-blocking sockets in those tests, retrying for
EAGAIN is ugly because there is no upper bound for the packet
arrival time, at least in theory. After we fix ->poll() for
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

