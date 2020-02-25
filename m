Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D202716C2EC
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbgBYN44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:56:56 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40096 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730480AbgBYN4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:56:49 -0500
Received: by mail-wr1-f66.google.com with SMTP id t3so14824100wru.7
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 05:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qgZ3nu/Bbfdwe+GDZ451yJiCX8ETGH9pPjG5oF9BPog=;
        b=x6O/9aXUU05oL3dc4nKNs8zNtN8koSz9cOra3Csbb7Sch7rCCBxHiRlKZ9m7Kb+4y1
         RFtjkjmqeXClHkVQk9WP+aPoDIX0OQjYhDgRn6EbYTmL5acnNuKkBSeDjwtSu21sTsd4
         ZkPt+DIu6GwQKP9F8DX59Qw12dlKjZohhp3z8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qgZ3nu/Bbfdwe+GDZ451yJiCX8ETGH9pPjG5oF9BPog=;
        b=EM1BmDUvU5pmn5mWLRZyMfVZ8aFDVwJyf0rT8LnmidJzxz8M0wjfnXpkc4h6P9Lfn+
         yPDHcaFT0DHVkxPU0yCXwXGiIPpd+N0Fj1Ob4AhK9IF2kaALg+Jr60U28LmHLF3WqTSm
         hyStCmurDaBUBzRhtoVkwBnjdMCnf+/YcipYNjIETVRyZJJMwHs44ErhQxWl5Sa9JWAE
         3ACEt4/mJg2NJWy4Mko4U6XXXWxWMNsKz+gLl8gXBOV6ORo7rG/hX8SYkHZ9Sachn0l6
         FyEPlsQ9FoOJTDRg2T0FPFOwvr6EJjALvHoUQu0CwT511ad2NbvCYGFxXuJB6OzvFPyo
         UPjg==
X-Gm-Message-State: APjAAAUJNZBPUCirHQg4Nw64stwNCvjPqcktUk8IpMqHoXm9Zx3OrfC3
        P/f+ES+bVNVr50J0Sx45m/fqTg==
X-Google-Smtp-Source: APXvYqwHmyyRUk3vIYhYbkETSsdfnRNKlwdruvH4vxIu9zuczLmgZcnvpYxsdMndcEHYvD277UP+wQ==
X-Received: by 2002:a5d:45d1:: with SMTP id b17mr4423208wrs.59.1582639006633;
        Tue, 25 Feb 2020 05:56:46 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8800:3dea:15ba:1870:8e94])
        by smtp.gmail.com with ESMTPSA id t128sm4463580wmf.28.2020.02.25.05.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:56:45 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 5/7] selftests: bpf: don't listen() on UDP sockets
Date:   Tue, 25 Feb 2020 13:56:34 +0000
Message-Id: <20200225135636.5768-6-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225135636.5768-1-lmb@cloudflare.com>
References: <20200225135636.5768-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most tests for TCP sockmap can be adapted to UDP sockmap if the
listen call is skipped. Rename listen_loopback, etc. to socket_loopback
and skip listen() for SOCK_DGRAM.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 47 ++++++++++---------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index b1b2acea0638..4ba41dd26d6b 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -230,7 +230,7 @@ static int enable_reuseport(int s, int progfd)
 	return 0;
 }
 
-static int listen_loopback_reuseport(int family, int sotype, int progfd)
+static int socket_loopback_reuseport(int family, int sotype, int progfd)
 {
 	struct sockaddr_storage addr;
 	socklen_t len;
@@ -249,6 +249,9 @@ static int listen_loopback_reuseport(int family, int sotype, int progfd)
 	if (err)
 		goto close;
 
+	if (sotype == SOCK_DGRAM)
+		return s;
+
 	err = xlisten(s, SOMAXCONN);
 	if (err)
 		goto close;
@@ -259,9 +262,9 @@ static int listen_loopback_reuseport(int family, int sotype, int progfd)
 	return -1;
 }
 
-static int listen_loopback(int family, int sotype)
+static int socket_loopback(int family, int sotype)
 {
-	return listen_loopback_reuseport(family, sotype, -1);
+	return socket_loopback_reuseport(family, sotype, -1);
 }
 
 static void test_insert_invalid(int family, int sotype, int mapfd)
@@ -333,7 +336,7 @@ static void test_insert_listening(int family, int sotype, int mapfd)
 	u32 key;
 	int s;
 
-	s = listen_loopback(family, sotype);
+	s = socket_loopback(family, sotype);
 	if (s < 0)
 		return;
 
@@ -349,7 +352,7 @@ static void test_delete_after_insert(int family, int sotype, int mapfd)
 	u32 key;
 	int s;
 
-	s = listen_loopback(family, sotype);
+	s = socket_loopback(family, sotype);
 	if (s < 0)
 		return;
 
@@ -366,7 +369,7 @@ static void test_delete_after_close(int family, int sotype, int mapfd)
 	u64 value;
 	u32 key;
 
-	s = listen_loopback(family, sotype);
+	s = socket_loopback(family, sotype);
 	if (s < 0)
 		return;
 
@@ -390,7 +393,7 @@ static void test_lookup_after_insert(int family, int sotype, int mapfd)
 	u32 key;
 	int s;
 
-	s = listen_loopback(family, sotype);
+	s = socket_loopback(family, sotype);
 	if (s < 0)
 		return;
 
@@ -417,7 +420,7 @@ static void test_lookup_after_delete(int family, int sotype, int mapfd)
 	u64 value;
 	u32 key;
 
-	s = listen_loopback(family, sotype);
+	s = socket_loopback(family, sotype);
 	if (s < 0)
 		return;
 
@@ -439,7 +442,7 @@ static void test_lookup_32_bit_value(int family, int sotype, int mapfd)
 	u32 key, value32;
 	int err, s;
 
-	s = listen_loopback(family, sotype);
+	s = socket_loopback(family, sotype);
 	if (s < 0)
 		return;
 
@@ -470,11 +473,11 @@ static void test_update_listening(int family, int sotype, int mapfd)
 	u64 value;
 	u32 key;
 
-	s1 = listen_loopback(family, sotype);
+	s1 = socket_loopback(family, sotype);
 	if (s1 < 0)
 		return;
 
-	s2 = listen_loopback(family, sotype);
+	s2 = socket_loopback(family, sotype);
 	if (s2 < 0)
 		goto close_s1;
 
@@ -500,7 +503,7 @@ static void test_destroy_orphan_child(int family, int sotype, int mapfd)
 	u64 value;
 	u32 key;
 
-	s = listen_loopback(family, sotype);
+	s = socket_loopback(family, sotype);
 	if (s < 0)
 		return;
 
@@ -534,7 +537,7 @@ static void test_clone_after_delete(int family, int sotype, int mapfd)
 	u64 value;
 	u32 key;
 
-	s = listen_loopback(family, sotype);
+	s = socket_loopback(family, sotype);
 	if (s < 0)
 		return;
 
@@ -570,7 +573,7 @@ static void test_accept_after_delete(int family, int sotype, int mapfd)
 	socklen_t len;
 	u64 value;
 
-	s = listen_loopback(family, sotype);
+	s = socket_loopback(family, sotype);
 	if (s == -1)
 		return;
 
@@ -624,7 +627,7 @@ static void test_accept_before_delete(int family, int sotype, int mapfd)
 	socklen_t len;
 	u64 value;
 
-	s = listen_loopback(family, sotype);
+	s = socket_loopback(family, sotype);
 	if (s == -1)
 		return;
 
@@ -735,7 +738,7 @@ static void test_syn_recv_insert_delete(int family, int sotype, int mapfd)
 	int err, s;
 	u64 value;
 
-	s = listen_loopback(family, sotype | SOCK_NONBLOCK);
+	s = socket_loopback(family, sotype | SOCK_NONBLOCK);
 	if (s < 0)
 		return;
 
@@ -877,7 +880,7 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 
 	zero_verdict_count(verd_mapfd);
 
-	s = listen_loopback(family, sotype | SOCK_NONBLOCK);
+	s = socket_loopback(family, sotype | SOCK_NONBLOCK);
 	if (s < 0)
 		return;
 
@@ -1009,7 +1012,7 @@ static void redir_to_listening(int family, int sotype, int sock_mapfd,
 
 	zero_verdict_count(verd_mapfd);
 
-	s = listen_loopback(family, sotype | SOCK_NONBLOCK);
+	s = socket_loopback(family, sotype | SOCK_NONBLOCK);
 	if (s < 0)
 		return;
 
@@ -1120,7 +1123,7 @@ static void test_reuseport_select_listening(int family, int sotype,
 
 	zero_verdict_count(verd_map);
 
-	s = listen_loopback_reuseport(family, sotype, reuseport_prog);
+	s = socket_loopback_reuseport(family, sotype, reuseport_prog);
 	if (s < 0)
 		return;
 
@@ -1174,7 +1177,7 @@ static void test_reuseport_select_connected(int family, int sotype,
 
 	zero_verdict_count(verd_map);
 
-	s = listen_loopback_reuseport(family, sotype, reuseport_prog);
+	s = socket_loopback_reuseport(family, sotype, reuseport_prog);
 	if (s < 0)
 		return;
 
@@ -1249,11 +1252,11 @@ static void test_reuseport_mixed_groups(int family, int sotype, int sock_map,
 	zero_verdict_count(verd_map);
 
 	/* Create two listeners, each in its own reuseport group */
-	s1 = listen_loopback_reuseport(family, sotype, reuseport_prog);
+	s1 = socket_loopback_reuseport(family, sotype, reuseport_prog);
 	if (s1 < 0)
 		return;
 
-	s2 = listen_loopback_reuseport(family, sotype, reuseport_prog);
+	s2 = socket_loopback_reuseport(family, sotype, reuseport_prog);
 	if (s2 < 0)
 		goto close_srv1;
 
-- 
2.20.1

