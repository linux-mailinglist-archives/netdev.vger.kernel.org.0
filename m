Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA46364957
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240409AbhDSR5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240300AbhDSR5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 13:57:14 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F742C061761;
        Mon, 19 Apr 2021 10:56:44 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id w6so9169328pfc.8;
        Mon, 19 Apr 2021 10:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZLt69FAUdQ5bTjcW1qMZRDUzZdTqyuja2OTZzrCIJKA=;
        b=KqStVPu7kGUp3igF/rrr/zEa/fQ+FeLsboaSWYSEgZITr07bGEFP1s/JzimOY1BVs2
         gxlkws416k8Wks7vWJy4vLQDGWF3+M1Ve7BuwaVGdCVyKL5Fl3WbBBU7d1krf/3eqwr+
         bQ/pTwM0cN1V5BsSvfHmTM1t2gSaMdDJdqXMWO+us48I4XCj7r6yAyn3Hag5tl+c9pYf
         qympZz/Nuk8xFueXXklH3Q50obpmWAlrS5JafjYFaslqQkdB6X7w09JAfbvsyCP9oYmE
         TucBJXoYE16pA5P+emtp12qd1FHjwqEbo7y4bw5s4Ahu3QcrvuqHCr+tkZjI4IRtyLRu
         B9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLt69FAUdQ5bTjcW1qMZRDUzZdTqyuja2OTZzrCIJKA=;
        b=gu2jSOKLAPl7ysQ2QIzZAuVzKd6kd2CmitUN0tL+nqfSIslKLIXG84ePN/LjbTQkp3
         50WSS9XAE0aYNvKzefVZg7Qz/Qan41nUjezO2kuqzngIPks73ojncE4ctXeysDAN4Faw
         +ovg3UEE1wzzeo+WJXIrtJr79sdbobVpXHK+XuxEAWYFpzybSM0dO1PaAe2wQkwK7lPy
         ec3E79omuO6Jtua7O4z2XJ6mqFd5hcUgq7wZo/63ReD5A/VivKQkJexTbddJpmXGIEF2
         pNd9k3tsdwIM5MlJxslLhPDOI8Nv/DvJiwW4ygNh21VUGVgXxEegSQr/dBLh004gODU2
         u37w==
X-Gm-Message-State: AOAM531tjon+6s+QiCHC9n2sWE4X5uMuB+XsSsjnn+5pqWU5cMBvTpG3
        r0eSpRm1npnKL5Oz0pnfHVabwQnUal23+A==
X-Google-Smtp-Source: ABdhPJwZLEczsuXh/AZU9XHgKLVayuxtbPiifjkkXswB24EPwrVwh2n8RMFh+66QYf1nqgAO2KBwPA==
X-Received: by 2002:a65:5b85:: with SMTP id i5mr12563275pgr.269.1618855003771;
        Mon, 19 Apr 2021 10:56:43 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9c9:f92c:88fa:755e])
        by smtp.gmail.com with ESMTPSA id g2sm119660pju.18.2021.04.19.10.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 10:56:43 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 6/9] selftests/bpf: factor out udp_socketpair()
Date:   Mon, 19 Apr 2021 10:56:00 -0700
Message-Id: <20210419175603.19378-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210419175603.19378-1-xiyou.wangcong@gmail.com>
References: <20210419175603.19378-1-xiyou.wangcong@gmail.com>
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

