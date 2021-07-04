Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B643BAE91
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhGDTGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhGDTFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 15:05:51 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE1AC061574;
        Sun,  4 Jul 2021 12:03:15 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id s17so18366633oij.0;
        Sun, 04 Jul 2021 12:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cp4VxDxB9rrejKy6GGAD+d9G2pOcc1VFv5V7Kz5Tl3A=;
        b=kNYVWv+uUDciJpZLMxbsgLYqL38QmhK/uecrys8tVjkWyLVvPSWp8hpjRoQHnW+QZ0
         DRT9DtQZgkBiB1Wozmsp+oiqGj3AzXI10cCJIIb6ukJzwkdSe6ZKC7afzYeQCfN5XMWc
         ZmQyisL839kn2JiC5hXwpmfvJLUWh/3SZx3r2Vth2p7WtSC3mxsf/uaCd0pxGrSwtNYL
         200E4gX4yF1CbVlIpXkvwXUaAWSOGEKaG9oXpjy3A1Ki0e8/UDCoFvmYhsMTCffHjqBD
         DetqxAFdQhD9xI36iskMiDmuxlusBNAxOQunSaTcbF391EVPFJBVG1kkVFjhzikL4bEr
         nSkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cp4VxDxB9rrejKy6GGAD+d9G2pOcc1VFv5V7Kz5Tl3A=;
        b=Cj82Zqpj9A5yEA7mGEw47DWw7/YKfwfT8kkphtlyt+dU5j8c+OtCTCv46V2njGj1TK
         OGWmutMYJbxe9dMGCU2IoWo+a3Rfuvo6MXGJYVZSITGXCGYHge56PndcuFTzVjLUB0NH
         dsqoDVY7xmTUkaSR46PxvYsdmDOL/o1DCfo+80I4nRnPfnQkYchQp8rUFufzsqdHYl1E
         KGFf/Cyaq7n3XMLaevHZhgkP66PVEshfrZqRhJaJz4gfAKsfX0nKNmsxyIUaD6gymMyw
         8Vjr6IQBCAxQ6jdH0DhmUOT9WD8Zkz9muIXDuARK16qZP+7KWnN8UoPeG30WUAk1q5Jt
         BPlw==
X-Gm-Message-State: AOAM5319zswqsMiQVjBR6KVp0CvhB0lnRd2U60kA3v4zwwEBm3/7miZr
        x2hWIkRLj8P8mFqAGiOcWe/CbP2mgkc=
X-Google-Smtp-Source: ABdhPJwX9ewQ4dVLeS4qbgP+3qEFtTLhiY/vj/etOikmCLfq9mJveGNx74gCEFNIYZlE0tUoWPsgcw==
X-Received: by 2002:aca:cf8f:: with SMTP id f137mr7783699oig.38.1625425394407;
        Sun, 04 Jul 2021 12:03:14 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id 186sm1865848ooe.28.2021.07.04.12.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 12:03:14 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v5 08/11] selftests/bpf: factor out udp_socketpair()
Date:   Sun,  4 Jul 2021 12:02:49 -0700
Message-Id: <20210704190252.11866-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Factor out a common helper udp_socketpair() which creates
a pair of connected UDP sockets.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 78 ++++++++++---------
 1 file changed, 40 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index b8934ae694e5..52d11959e05b 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1605,33 +1605,27 @@ static void test_reuseport(struct test_sockmap_listen *skel,
 	}
 }
 
-static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
-				   int verd_mapfd, enum redir_mode mode)
+static int udp_socketpair(int family, int *s, int *c)
 {
-	const char *log_prefix = redir_mode_str(mode);
 	struct sockaddr_storage addr;
-	int c0, c1, p0, p1;
-	unsigned int pass;
-	int retries = 100;
 	socklen_t len;
-	int err, n;
-	u64 value;
-	u32 key;
-	char b;
-
-	zero_verdict_count(verd_mapfd);
+	int p0, c0;
+	int err;
 
-	p0 = socket_loopback(family, sotype | SOCK_NONBLOCK);
+	p0 = socket_loopback(family, SOCK_DGRAM | SOCK_NONBLOCK);
 	if (p0 < 0)
-		return;
+		return p0;
+
 	len = sizeof(addr);
 	err = xgetsockname(p0, sockaddr(&addr), &len);
 	if (err)
 		goto close_peer0;
 
-	c0 = xsocket(family, sotype | SOCK_NONBLOCK, 0);
-	if (c0 < 0)
+	c0 = xsocket(family, SOCK_DGRAM | SOCK_NONBLOCK, 0);
+	if (c0 < 0) {
+		err = c0;
 		goto close_peer0;
+	}
 	err = xconnect(c0, sockaddr(&addr), len);
 	if (err)
 		goto close_cli0;
@@ -1642,25 +1636,37 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
 	if (err)
 		goto close_cli0;
 
-	p1 = socket_loopback(family, sotype | SOCK_NONBLOCK);
-	if (p1 < 0)
-		goto close_cli0;
-	err = xgetsockname(p1, sockaddr(&addr), &len);
-	if (err)
-		goto close_cli0;
+	*s = p0;
+	*c = c0;
+	return 0;
 
-	c1 = xsocket(family, sotype | SOCK_NONBLOCK, 0);
-	if (c1 < 0)
-		goto close_peer1;
-	err = xconnect(c1, sockaddr(&addr), len);
-	if (err)
-		goto close_cli1;
-	err = xgetsockname(c1, sockaddr(&addr), &len);
+close_cli0:
+	xclose(c0);
+close_peer0:
+	xclose(p0);
+	return err;
+}
+
+static void udp_redir_to_connected(int family, int sock_mapfd, int verd_mapfd,
+				   enum redir_mode mode)
+{
+	const char *log_prefix = redir_mode_str(mode);
+	int c0, c1, p0, p1;
+	unsigned int pass;
+	int retries = 100;
+	int err, n;
+	u64 value;
+	u32 key;
+	char b;
+
+	zero_verdict_count(verd_mapfd);
+
+	err = udp_socketpair(family, &p0, &c0);
 	if (err)
-		goto close_cli1;
-	err = xconnect(p1, sockaddr(&addr), len);
+		return;
+	err = udp_socketpair(family, &p1, &c1);
 	if (err)
-		goto close_cli1;
+		goto close_cli0;
 
 	key = 0;
 	value = p0;
@@ -1701,11 +1707,9 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
 
 close_cli1:
 	xclose(c1);
-close_peer1:
 	xclose(p1);
 close_cli0:
 	xclose(c0);
-close_peer0:
 	xclose(p0);
 }
 
@@ -1722,11 +1726,9 @@ static void udp_skb_redir_to_connected(struct test_sockmap_listen *skel,
 		return;
 
 	skel->bss->test_ingress = false;
-	udp_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
-			       REDIR_EGRESS);
+	udp_redir_to_connected(family, sock_map, verdict_map, REDIR_EGRESS);
 	skel->bss->test_ingress = true;
-	udp_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
-			       REDIR_INGRESS);
+	udp_redir_to_connected(family, sock_map, verdict_map, REDIR_INGRESS);
 
 	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
 }
-- 
2.27.0

