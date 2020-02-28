Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50DCA17369F
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 12:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgB1LzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 06:55:07 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40502 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgB1Lyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 06:54:47 -0500
Received: by mail-wm1-f65.google.com with SMTP id d138so1288933wmd.5
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 03:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qgZ3nu/Bbfdwe+GDZ451yJiCX8ETGH9pPjG5oF9BPog=;
        b=etWy7VMS5c5Fvlp2X/iYvcnBrHzNw7tAs3b/st1Fe3RCLvzWAWNaX0rMjyjgJxVlVu
         1q67U3Y4oLiaLTF/9e0nWaEUCFM1saNsaqNaJENf8Z3mAI/uHQSgktjJ7pzyC81wiuRS
         64fBjjMiFG+AV8+tUwGaVsxdLFk87P0neuvao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qgZ3nu/Bbfdwe+GDZ451yJiCX8ETGH9pPjG5oF9BPog=;
        b=Mvj8//FKpBk30H+HOWv0Ia+tRTqcBoA7Mk9usX65ZIO9PLcN14hdo0WidZWF9bvA0N
         Jfq6pFiOk6ezB4PK/oCLURey0Ippd1wE+OitCQGkvgYnQuNFJFEoK1G8/AQjfHrmeHG2
         D4rch5WTx2CiNpOXlKFxGwhhPT+SSD6/2gAVOhR5Avl3/pDh0G+hjYJeIIdyiGiCFQ26
         rpKcJrIrJVwHPbHrdBCUBLFcxaQuTLMWW8xvH/5DHb/h0bHEVlaERrsgVDQGwOVRMFyT
         90rmLX6ACk9leZ6tKsvlPFieRMauxQlOoArpzYnDe94oMkxpxAFbil5OFnBcY7adUk7A
         V0bw==
X-Gm-Message-State: APjAAAXaV3N4wRuHmKqA2hOspyKUNGkJXL9GzQjRwVW3Wl4RXJ+ZXJnj
        KX8lGyVeSVcXYC0rKMsd9YIrig==
X-Google-Smtp-Source: APXvYqwc05OdtN0Be7Qgk7jhcOkgMo1PUJoree+JaCcUtw6sQ9XkQxZIkMBMrH379PX+OU7nw5Ke4A==
X-Received: by 2002:a1c:1944:: with SMTP id 65mr4310640wmz.7.1582890883929;
        Fri, 28 Feb 2020 03:54:43 -0800 (PST)
Received: from antares.lan (b.2.d.a.1.b.1.b.2.c.5.e.0.3.d.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4d30:e5c2:b1b1:ad2b])
        by smtp.gmail.com with ESMTPSA id q125sm2044284wme.19.2020.02.28.03.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 03:54:43 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 6/9] selftests: bpf: don't listen() on UDP sockets
Date:   Fri, 28 Feb 2020 11:53:41 +0000
Message-Id: <20200228115344.17742-7-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228115344.17742-1-lmb@cloudflare.com>
References: <20200228115344.17742-1-lmb@cloudflare.com>
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

