Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42A337744D
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhEHWK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhEHWKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:10:23 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D547C06175F;
        Sat,  8 May 2021 15:09:21 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id a18so9296767qtj.10;
        Sat, 08 May 2021 15:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3zBurI5w9nWmqgTlS8ZlPUjsf6vWN5Rp/hn9WFSBN8k=;
        b=Ogqo56PQLf08hCwkiFX/8uGXsIiitdm3srxZH//LeG1LiTrKCrzMQrBGgmoxkIeJ8n
         vaLQE1EayfEaOeZB83hNt+7P6orEH9IkuD5pl3J7YDF3r+LtRZV+DFRL2KSmXU8I0OsU
         JrQBw2abx2OkpjF3HN5n9vQ+P9Xf4iIEgpPS2szkvvKC4flU2SXpxlHcoOzvKuTghtG4
         ETugtjb4jVadWRiqw/7AAMo/qHKfxdXJiT8xe6Iw6UIHGPc4H/Jp1rXEJBKaFnhDS+tK
         zjYX/L5kKF0sfzqz8A0H0ISDO4n90//5CnpilZ94AdBNBHXS5ULeyU8OzuENaCdiIuC2
         OBaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3zBurI5w9nWmqgTlS8ZlPUjsf6vWN5Rp/hn9WFSBN8k=;
        b=p3NfBBDxdc0/30GQwc/qC6HR/5l2BptXJ8bSAWDzj7vy4hJII2Kq6P36zU9FKXWhNU
         LyT282R6+wKv8n4ECD16gNxZMZdsPrGFALMV3vl57Y3H8ztZPKDgx791p6QXGKpdazv/
         iJ4hicH5NXEK9cuNr1I2CIGoUSpai/8n3HjyaSlIKmjEgYSw4nLkcLDoGvl8pbXtTydf
         FTr5w9tczPQ72P9eGSfIs4+mvAtOh3VJUNzTBGdIjo+HmylIJ8nW/hOJd+/GS7i52FMY
         iGyNmAFkNGfkm4qUM+2mUEldrNF/pL3VQqixHUSUwUBUWv13cnFixzykwklaL1YQ0VbY
         fFug==
X-Gm-Message-State: AOAM531Mgvun4JXY8aMRi7QOOHEwbmDpRE0rqUnvAepOLUDYuA44qS9J
        YoL5KLm9De2o5HK08BD15/YvuyLHLG9zsQ==
X-Google-Smtp-Source: ABdhPJyMyMkrLI4a5DFFhYp8/wSAaqYY+D3oKgJbDOFXBIeQJcMUM/jNhEcjVkVJuJmuUNhEd4oFSQ==
X-Received: by 2002:ac8:71d4:: with SMTP id i20mr15956761qtp.286.1620511760680;
        Sat, 08 May 2021 15:09:20 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id 189sm8080797qkd.51.2021.05.08.15.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:09:20 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 10/12] selftests/bpf: factor out add_to_sockmap()
Date:   Sat,  8 May 2021 15:08:33 -0700
Message-Id: <20210508220835.53801-11-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
References: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
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

