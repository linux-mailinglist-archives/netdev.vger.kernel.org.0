Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 414D5178E20
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387891AbgCDKNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 05:13:55 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39051 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387857AbgCDKNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:13:54 -0500
Received: by mail-lj1-f194.google.com with SMTP id f10so1344800ljn.6
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 02:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qgZ3nu/Bbfdwe+GDZ451yJiCX8ETGH9pPjG5oF9BPog=;
        b=ySCW+/494DSUY4cH8Co3m45bz7DMpeO9CAnj98zfqwTTzI6K8q1UlVQRUkLGDlt/d7
         RNSQjkbvG60q9UO7X/8/o4gI+fdQ6QOcPERwiIryv5cZqD696LhWx8/37cYgqtAoTO90
         OemD9o6+jsOY/Gnl3e3M3hgT0Tq4823cj9Q2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qgZ3nu/Bbfdwe+GDZ451yJiCX8ETGH9pPjG5oF9BPog=;
        b=t9qg4aB9xflXCt4DRqc7S+jYBTTM8nzrUHtR5NF5UfFvCPRMdwSzUCCK2puNS2iCC7
         y1x+8+1IJptVfy25uATTDyweyercUcdoukD1tdhnqSB/ihrdiATw9nS0BEX6ReaPOtLS
         KQ/EihNNAUSVeaP4cm1bA5nObfzRHR0bwuEIFc3QYUjIM0IkgxSHquLyRXvOGHXH11ex
         GuQ9G/vaExtfe7FXwu0snV6RCRy8nBANSSYzZsjO52oJkdXMEFhb6FnOjIzXLNVTJG42
         waYS6jPYh2T3F710n9VSX5wzU0G2JKNcBTv9BXEMwi+WfRPLiBlTfVs6gYs8aO35HMbC
         2GZw==
X-Gm-Message-State: ANhLgQ0wNbXsNBIbajYn6OhYDuu7hYDQy0rjjqmqKYTDko5J+ejwRFe5
        1yAUDyzAkn2hUD9JTTHVoUYTRw==
X-Google-Smtp-Source: ADFU+vsHkXTuwBCutx37rT+SHK3e40nGnHVZjL5Auj0/0SfQrk66wtGroFLclar6ISuTu7pr9C04Og==
X-Received: by 2002:a2e:9094:: with SMTP id l20mr1423596ljg.131.1583316831827;
        Wed, 04 Mar 2020 02:13:51 -0800 (PST)
Received: from localhost.localdomain ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id l7sm341777lfk.65.2020.03.04.02.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 02:13:51 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 09/12] selftests: bpf: don't listen() on UDP sockets
Date:   Wed,  4 Mar 2020 11:13:14 +0100
Message-Id: <20200304101318.5225-10-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304101318.5225-1-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
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

