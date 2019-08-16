Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B8090556
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 18:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfHPQDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 12:03:44 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40705 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfHPQDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 12:03:44 -0400
Received: by mail-pl1-f196.google.com with SMTP id a93so2628289pla.7;
        Fri, 16 Aug 2019 09:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IsyaBI53vlhVFwEj55jm631qg+ZeEvxgq87mCMPjPqE=;
        b=raABAyA/SRX7wBb0sZMtVZg3VQdVpjS5uOi8Jq0dMJhqIGOJkovKIgAAFzAADAu8s9
         bi33YuEEKu6Lr3/rbZPBUMYccKNmwDMPQQi5ymvHx3gAv3OC7zQOl2OYCRfrGZWv/GhM
         xM7nWKoaJhXM6gn2PGl/Zrsb2HTPp2IP72coCTztWbGs3NX1gLSH+8UVYYV6AT/uJ1V6
         IaunLVzDYLufNjN11ApTvGS+AYmYnatIe5JCh4uyJ/6kmYYqjqm3SKCMYvWRIt6PZBCN
         AZbtTlASKi6c7FInjEy0DhWW6rQcjCY7nOC+q0rasqnlRpXIkDa/fwN/hWxjH4W24fFp
         8Azw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IsyaBI53vlhVFwEj55jm631qg+ZeEvxgq87mCMPjPqE=;
        b=YS5wphjvK9IJSvNJ1Wq2Jfl4zQ6MhckL7NPdlM0QFqDSg7ksmleBGsfNPXFfOp45XD
         p0ZCoL7dIt8aw0/kFmi1B4rmA4LAIwVJ7/Fc4vI9Ng8cHhmNPjf+af5i45NiEutMT6Si
         kGE605aLNk9yX4/VrqiDE8nsEIwLwjCOQVtHFH+CzgLjh781AQTytgcA4eDuFuMUdaNL
         4MAtUiWHqUlPhyKEhYgdrbuEC+11ZjMABChXD1OXqmZp4wniVyfCSsxnqP8UrxbfV2Li
         jE3QolxushBXaThNwXJjsD9fw6a7kW8sMft2pl24K3A4fuaahoR6zMk5YBACxWnR3J1H
         bd0w==
X-Gm-Message-State: APjAAAUhtJkfV/DlusrkZxYM1AL+d/ZefZYjDkUtf3arDADyj0RjV8SX
        Y54KzWhJroKKmVhoJOOaxEDfcmRI
X-Google-Smtp-Source: APXvYqwpS7uoEfKXNDCd6pkgEamcrZuSfpYkDZZa99FRkK3tvMuRjyfSWRg2ZQheUxffkUfFh7MMJQ==
X-Received: by 2002:a17:902:d917:: with SMTP id c23mr10041133plz.248.1565971423216;
        Fri, 16 Aug 2019 09:03:43 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id t9sm6078591pgj.89.2019.08.16.09.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 09:03:42 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        sdf@google.com, Petar Penkov <ppenkov@google.com>
Subject: [bpf-next] selftests/bpf: fix race in test_tcp_rtt test
Date:   Fri, 16 Aug 2019 09:03:39 -0700
Message-Id: <20190816160339.249832-1-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

There is a race in this test between receiving the ACK for the
single-byte packet sent in the test, and reading the values from the
map.

This patch fixes this by having the client wait until there are no more
unacknowledged packets.

Before:
for i in {1..1000}; do ../net/in_netns.sh ./test_tcp_rtt; \
done | grep -c PASSED
< trimmed error messages >
993

After:
for i in {1..10000}; do ../net/in_netns.sh ./test_tcp_rtt; \
done | grep -c PASSED
10000

Fixes: b55873984dab ("selftests/bpf: test BPF_SOCK_OPS_RTT_CB")
Signed-off-by: Petar Penkov <ppenkov@google.com>
---
 tools/testing/selftests/bpf/test_tcp_rtt.c | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_tcp_rtt.c b/tools/testing/selftests/bpf/test_tcp_rtt.c
index 90c3862f74a8..2b4754473956 100644
--- a/tools/testing/selftests/bpf/test_tcp_rtt.c
+++ b/tools/testing/selftests/bpf/test_tcp_rtt.c
@@ -6,6 +6,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
+#include <netinet/tcp.h>
 #include <pthread.h>
 
 #include <linux/filter.h>
@@ -34,6 +35,30 @@ static void send_byte(int fd)
 		error(1, errno, "Failed to send single byte");
 }
 
+static int wait_for_ack(int fd, int retries)
+{
+	struct tcp_info info;
+	socklen_t optlen;
+	int i, err;
+
+	for (i = 0; i < retries; i++) {
+		optlen = sizeof(info);
+		err = getsockopt(fd, SOL_TCP, TCP_INFO, &info, &optlen);
+		if (err < 0) {
+			log_err("Failed to lookup TCP stats");
+			return err;
+		}
+
+		if (info.tcpi_unacked == 0)
+			return 0;
+
+		sleep(1);
+	}
+
+	log_err("Did not receive ACK");
+	return -1;
+}
+
 static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 invoked,
 		     __u32 dsack_dups, __u32 delivered, __u32 delivered_ce,
 		     __u32 icsk_retransmits)
@@ -149,6 +174,11 @@ static int run_test(int cgroup_fd, int server_fd)
 			 /*icsk_retransmits=*/0);
 
 	send_byte(client_fd);
+	if (wait_for_ack(client_fd, 5) < 0) {
+		err = -1;
+		goto close_client_fd;
+	}
+
 
 	err += verify_sk(map_fd, client_fd, "first payload byte",
 			 /*invoked=*/2,
@@ -157,6 +187,7 @@ static int run_test(int cgroup_fd, int server_fd)
 			 /*delivered_ce=*/0,
 			 /*icsk_retransmits=*/0);
 
+close_client_fd:
 	close(client_fd);
 
 close_bpf_object:
-- 
2.23.0.rc1.153.gdeed80330f-goog

