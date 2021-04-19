Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE21364958
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240420AbhDSR5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240241AbhDSR5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 13:57:15 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1567C06138A;
        Mon, 19 Apr 2021 10:56:44 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c3so4909391pfo.3;
        Mon, 19 Apr 2021 10:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3zBurI5w9nWmqgTlS8ZlPUjsf6vWN5Rp/hn9WFSBN8k=;
        b=lu6domuYkslLddbgRhjwQ4yvhxbOGbHMj5hlBxkdT+UXBOgdBadlaFGyd8EMZxPAda
         UZJCGdTF/j3MGGMG0kt288/MChUmnss+wenOgIcvqEZitHu0E2oCGBHrqGoNMA/yvrfS
         FA56iL+47+EmRGfjjc8XlTEvNTrqb9uEHOxpDz93eV7aVyPeWh/qEecipCgQLSAg8+uy
         /+w0GzHp3C5AKFxqOtEZvXZaEtiUMpNXP5DKuxyiLN1xEbX7PLpmTUEiz4sLr8ll8YOy
         DnceXlf1ZBlifaJfmiXRjzHb4m7enxw5K0V5gVDD+mnuLTSCqAE4c46nAjMBf5n5xcEU
         urUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3zBurI5w9nWmqgTlS8ZlPUjsf6vWN5Rp/hn9WFSBN8k=;
        b=Sy4DevW2K7sWBo9dzkojIAVrg3xF2FxsoIYRBDPWbE8mmAf5YpAnq4gns8oBAdWIOl
         bwqPCkdd7ZG4XA8uYsKZKQH66H45djCzwRNFVicZ85YyNfIrv+JdaUf4C1kX+17B7pcN
         m1P8ayf4twyo/gbYaEHvM5JR7xGZijzWTvpDeCddAGr217HwfHzUt1vM2CxVV9A1HnVX
         HyHRQnG1eD52IyZ1DIsX04Vupi+ZdXXGuno7ZuvXZAiuRhckN85sYGPnJ637U3lU9Yfi
         JndTRtNuORpZmZEOZArDzB5BG7HYp/xI4L+HlvywE/B1pOgWqVQG3jkotcw3zcaseOzE
         ROVQ==
X-Gm-Message-State: AOAM532yNGiCwOLLGw8MJVxdVmU4aHl4dJhz8j7WiwGp73R+mvyiULVQ
        9OCARYzru/BP8aF4UYujlkQ/7Gi01qVuMQ==
X-Google-Smtp-Source: ABdhPJz+9Ph77yuZoQ5/SL3jxnUvNhroqLeug089H9S6riKMWxXVyuqtu1tY/79Jxb31YvTrNSL7WA==
X-Received: by 2002:a63:4763:: with SMTP id w35mr12979491pgk.226.1618855004418;
        Mon, 19 Apr 2021 10:56:44 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9c9:f92c:88fa:755e])
        by smtp.gmail.com with ESMTPSA id g2sm119660pju.18.2021.04.19.10.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 10:56:44 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 7/9] selftests/bpf: factor out add_to_sockmap()
Date:   Mon, 19 Apr 2021 10:56:01 -0700
Message-Id: <20210419175603.19378-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210419175603.19378-1-xiyou.wangcong@gmail.com>
References: <20210419175603.19378-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Factor out a common helper add_to_sockmap() which adds two
sockets into a sockmap.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 59 +++++++------------
 1 file changed, 21 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 3d9907bcf132..ee017278fae4 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -919,6 +919,23 @@ static const char *redir_mode_str(enum redir_mode mode)
 	}
 }
 
+static int add_to_sockmap(int sock_mapfd, int fd1, int fd2)
+{
+	u64 value;
+	u32 key;
+	int err;
+
+	key = 0;
+	value = fd1;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		return err;
+
+	key = 1;
+	value = fd2;
+	return xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+}
+
 static void redir_to_connected(int family, int sotype, int sock_mapfd,
 			       int verd_mapfd, enum redir_mode mode)
 {
@@ -928,7 +945,6 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 	unsigned int pass;
 	socklen_t len;
 	int err, n;
-	u64 value;
 	u32 key;
 	char b;
 
@@ -965,15 +981,7 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 	if (p1 < 0)
 		goto close_cli1;
 
-	key = 0;
-	value = p0;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
-	if (err)
-		goto close_peer1;
-
-	key = 1;
-	value = p1;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	err = add_to_sockmap(sock_mapfd, p0, p1);
 	if (err)
 		goto close_peer1;
 
@@ -1061,7 +1069,6 @@ static void redir_to_listening(int family, int sotype, int sock_mapfd,
 	int s, c, p, err, n;
 	unsigned int drop;
 	socklen_t len;
-	u64 value;
 	u32 key;
 
 	zero_verdict_count(verd_mapfd);
@@ -1086,15 +1093,7 @@ static void redir_to_listening(int family, int sotype, int sock_mapfd,
 	if (p < 0)
 		goto close_cli;
 
-	key = 0;
-	value = s;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
-	if (err)
-		goto close_peer;
-
-	key = 1;
-	value = p;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	err = add_to_sockmap(sock_mapfd, s, p);
 	if (err)
 		goto close_peer;
 
@@ -1346,7 +1345,6 @@ static void test_reuseport_mixed_groups(int family, int sotype, int sock_map,
 	int s1, s2, c, err;
 	unsigned int drop;
 	socklen_t len;
-	u64 value;
 	u32 key;
 
 	zero_verdict_count(verd_map);
@@ -1360,16 +1358,10 @@ static void test_reuseport_mixed_groups(int family, int sotype, int sock_map,
 	if (s2 < 0)
 		goto close_srv1;
 
-	key = 0;
-	value = s1;
-	err = xbpf_map_update_elem(sock_map, &key, &value, BPF_NOEXIST);
+	err = add_to_sockmap(sock_map, s1, s2);
 	if (err)
 		goto close_srv2;
 
-	key = 1;
-	value = s2;
-	err = xbpf_map_update_elem(sock_map, &key, &value, BPF_NOEXIST);
-
 	/* Connect to s2, reuseport BPF selects s1 via sock_map[0] */
 	len = sizeof(addr);
 	err = xgetsockname(s2, sockaddr(&addr), &len);
@@ -1652,7 +1644,6 @@ static void udp_redir_to_connected(int family, int sock_mapfd, int verd_mapfd,
 	int c0, c1, p0, p1;
 	unsigned int pass;
 	int err, n;
-	u64 value;
 	u32 key;
 	char b;
 
@@ -1665,15 +1656,7 @@ static void udp_redir_to_connected(int family, int sock_mapfd, int verd_mapfd,
 	if (err)
 		goto close_cli0;
 
-	key = 0;
-	value = p0;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
-	if (err)
-		goto close_cli1;
-
-	key = 1;
-	value = p1;
-	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	err = add_to_sockmap(sock_mapfd, p0, p1);
 	if (err)
 		goto close_cli1;
 
-- 
2.25.1

