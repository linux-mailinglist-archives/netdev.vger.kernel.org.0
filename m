Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C5D36AAD6
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhDZCvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbhDZCvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:51:04 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB97C061761;
        Sun, 25 Apr 2021 19:50:22 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id z2so18267993qkb.9;
        Sun, 25 Apr 2021 19:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZLt69FAUdQ5bTjcW1qMZRDUzZdTqyuja2OTZzrCIJKA=;
        b=odGv/gLpOobU4dSVOTLEg7AXxfl9qLEsDhNXLyb/oSDqJtjUp7v71PPXP7eVSAkbKW
         oGlzdOIfEeZ3CMeISognNd2UfWDqQiaRlOnXpLqP3h2nh38nf8IwbMVfY5dgGVcOrEX5
         ZDTb6mH+v6dNJUNJlX2WwVhDZMKpf2FH/QKtj3xMu5sriuMZ70RFhNW0VkKfAqATQ1g6
         RqnaLVL+MeceSKMs3D3ZnxOaOxOXmrzgMdOVvtyCwCH6J0TRWmE1gKY4yfbhWx8ubcbj
         Lxy+04A7qqFAiB0ZHY34rWKUG1x/ikaMczM6xSrMA1Y7MsVCnvVW0qxJ9ePe9Gv/yqO0
         L9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLt69FAUdQ5bTjcW1qMZRDUzZdTqyuja2OTZzrCIJKA=;
        b=uWUEGV0tV5S/IJO0FOTwr+j96U9bSvKyuq9EIPOnIndXH5ZQu3As475YcK1tOCtN93
         7ybQqH+cXPQhSlaBI3yyA+DmpI8EKSN+aek6LKYdr8/N/53w4Q5RuU7KBBbPFlLzH6rQ
         jLIZCr/e4pViJkDiS6QpgFaxgerDBg2mhHSIr/WAkeqfdWELkLwpp4/vBHd3Mb1xqcfx
         hX/y7ci7znL30qtyO55tiTPcMN1zWb61S4YGjCbECzzx47q0f7bwlGI9c5ceeMhh+KHM
         UokkUn3ulBK7XrwQCbjfi5OOsoigjLiCUjieeQnD7kIP2OT8FEe639yKpMw8fYm43TJa
         FQ5Q==
X-Gm-Message-State: AOAM531o6EYL3va8EknwYuJ9p58MTzmak4Pqg9H+zU8hGmwO0ouUnjOA
        1UjiKUjQDqxq0hBcyqsTa1WqG+1TzAMPOA==
X-Google-Smtp-Source: ABdhPJw+bDo1qvYnYuELepnzRxRFsKuJwvy1YWH+BJseyLcMmLKVAqmAUfOl/4OtOgAAXDWNN37lMA==
X-Received: by 2002:a05:620a:6ce:: with SMTP id 14mr15534201qky.423.1619405421595;
        Sun, 25 Apr 2021 19:50:21 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:9050:63f8:875d:8edf])
        by smtp.gmail.com with ESMTPSA id e15sm9632969qkm.129.2021.04.25.19.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 19:50:21 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 07/10] selftests/bpf: factor out udp_socketpair()
Date:   Sun, 25 Apr 2021 19:49:58 -0700
Message-Id: <20210426025001.7899-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
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
 .../selftests/bpf/prog_tests/sockmap_listen.c | 76 ++++++++++---------
 1 file changed, 39 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 648d9ae898d2..3d9907bcf132 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1603,32 +1603,27 @@ static void test_reuseport(struct test_sockmap_listen *skel,
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
@@ -1639,25 +1634,36 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
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
@@ -1694,11 +1700,9 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
 
 close_cli1:
 	xclose(c1);
-close_peer1:
 	xclose(p1);
 close_cli0:
 	xclose(c0);
-close_peer0:
 	xclose(p0);
 }
 
@@ -1715,11 +1719,9 @@ static void udp_skb_redir_to_connected(struct test_sockmap_listen *skel,
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
2.25.1

