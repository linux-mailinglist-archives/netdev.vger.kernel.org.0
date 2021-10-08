Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50ACF427259
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 22:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242927AbhJHUfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 16:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242856AbhJHUfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 16:35:19 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C712C061570;
        Fri,  8 Oct 2021 13:33:24 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id o13so7167372qvm.4;
        Fri, 08 Oct 2021 13:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ysNfuXl1HWktNtOSEF03F01sMlIv53eUMXjaR2LS9EI=;
        b=AJnVX/Dn9IYIB0wCnMlDtfrso2E5XPJNmW/3HDfnruiUzKZ3lQsgeS4qq5vvKCll21
         3mqRcHREFFSLKhkkACmHGpaeodhLM7IPC+2I25nejcokZepJhggL0vhv452fJy1I81k4
         Uekb3Cwm8sYPVNZGq+O2Dn2xhBTLfhU/kOly9gTJWqwE7NexHIoggFT0tAC3g0/GVeeg
         hdHX18vJi0mwmWgmGZ385LvTaE8Vlli/atk+7wDtMZVvg5SviydqcLbW6AzGbL4RBCVQ
         6o4uqlI+5Nznx69t57Zt2Xw7i47hqC6vHsmBQGxHIN9H6ojQKeUpSs+W6gyQTtwg38AQ
         4SbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ysNfuXl1HWktNtOSEF03F01sMlIv53eUMXjaR2LS9EI=;
        b=5cEiGbH5/3dTFwMD2K0xCa2rtGaUBgN8M4CVMhgylif/lL4cJFkCvgwsed9VCH4tFa
         6ozHwIN2BgDMDb8H7SBI+NP2rjna1nc8Gfeb/ZS3Q93dVpgnxRzqDGZrtJ0WWWnTGmCO
         9qoZMtJ9LnS6gp1la/MUQiCxFdeO3iFMDHHwiIoMdEMXLiV0P25K1u5XVWXPk78xt9c3
         uzySH0llSJ6PGXC7PkKMJMlYmo36ixUvlTPQPTmSaE/bWu1CUEDnk2k07wiiwxBU1to5
         49HgFWlijIO6MX2GNPfsFo19ZmeWq1MKfImEFv+0CibkqqEg1Q/7+tWEt6DPqer/RQ6Q
         2wzw==
X-Gm-Message-State: AOAM532XYVpzwv4MrdFIBmnyD1hV0u+MXxAWCt5DtmlRBNzbMH2FQt5Q
        qnXSn5x61ZpyAlAHaMXCSS0469ANYfI=
X-Google-Smtp-Source: ABdhPJz2dHX7v8GUadyuk/rjP/VqwBho7FYSAVVJVSCv+dWjZN/nXz3zAWDI2i/KGWkWIY+QoieI4A==
X-Received: by 2002:a05:6214:a4d:: with SMTP id ee13mr12078196qvb.6.1633725202220;
        Fri, 08 Oct 2021 13:33:22 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:795f:367d:1f1e:4801])
        by smtp.gmail.com with ESMTPSA id c8sm381945qtb.9.2021.10.08.13.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:33:21 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Yucong Sun <sunyucong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf v4 4/4] selftests/bpf: use recv_timeout() instead of retries
Date:   Fri,  8 Oct 2021 13:33:06 -0700
Message-Id: <20211008203306.37525-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211008203306.37525-1-xiyou.wangcong@gmail.com>
References: <20211008203306.37525-1-xiyou.wangcong@gmail.com>
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

