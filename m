Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227E136AAD9
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhDZCvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbhDZCvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:51:05 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5EDC061574;
        Sun, 25 Apr 2021 19:50:23 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id q4so12280331qtn.5;
        Sun, 25 Apr 2021 19:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3zBurI5w9nWmqgTlS8ZlPUjsf6vWN5Rp/hn9WFSBN8k=;
        b=R9pfFkkhT02yf40b4IpUf0VAeZoFzKR0FBQKG2ZBLtwRrz5YrePJa9gian7FsxLule
         s5uRqzMYid1ET7OTt9vKTyOTC3HzV03FO1jt47y6oLFfKoktUiDbUdleFRfFC6gK0khH
         9YYScFciqysvCLpkS7VgfCLIsj+eQbJmNWqrOJlZ1frR9IAqeV/BJxww/Ok9xbPdb3Ex
         tqUefrQ0vGRSnqd2vARFJYNg2cMuCIC53b8WJ/iNxdjyvh55bBUHNKR1vrDbO/oLNMHC
         Gv/jO9wy49FEpgLJPklH6GH2qP8jDQXkS/frKk4TS6IEuQCC+cHhjDZvt30pVknwQq20
         x5hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3zBurI5w9nWmqgTlS8ZlPUjsf6vWN5Rp/hn9WFSBN8k=;
        b=dUhuuj3/yyyLaJ6BCCBGYvuFnKQdQ7uv/tWUJyO2bwtDe20cgRA4FOARrYJzrFHPFY
         Gj9qTQUHyZEsBiXL09H/kDtVOPJTdWH+hRxdQX+xfcrfTtNsouE5pfbLaRH2s5RnJ1Vn
         XKanhLI9cNzunNFCAABzwmOSLjxOZC2K7nYrjO+r7nREkUvEJr+BqpwmWZdElCQqypHN
         35NkyyPOPxch3/t5NLqaKKfB+2Dib6sSC7+vc0dLnCYLXWVGmurdEj55PU+EXL8ZB4rk
         YvzY/SCmx5IMDsiXnyi29WI08nBF4gK3AWbmcnRxyCAcO2JpeNwBssPT6EpeqUsdmbnL
         31qw==
X-Gm-Message-State: AOAM533mrwsbQKilGSvfObmNkHtpn2OC9tlPFan6Ml3BBIY90Ssc3R+7
        kin6/65YOZrcdDNOxMjjf/CIT2/Kd9zRfw==
X-Google-Smtp-Source: ABdhPJzxOZ9HRb/PJcPbTSOahT7uATxGjdaDavz82n6K3YDiYvTdB/7FKuza+WCO4Tx32T0ejD4N8g==
X-Received: by 2002:ac8:5a16:: with SMTP id n22mr2545833qta.103.1619405423007;
        Sun, 25 Apr 2021 19:50:23 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:9050:63f8:875d:8edf])
        by smtp.gmail.com with ESMTPSA id e15sm9632969qkm.129.2021.04.25.19.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 19:50:22 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 08/10] selftests/bpf: factor out add_to_sockmap()
Date:   Sun, 25 Apr 2021 19:49:59 -0700
Message-Id: <20210426025001.7899-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
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

