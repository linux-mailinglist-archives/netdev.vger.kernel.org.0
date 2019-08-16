Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5029190674
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 19:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfHPRIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 13:08:30 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37865 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfHPRI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 13:08:29 -0400
Received: by mail-pl1-f194.google.com with SMTP id bj8so2691286plb.4;
        Fri, 16 Aug 2019 10:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VztW51XA4vx8PX2Mz/t0kTb9/SRjKZo7CzRhZxpblX0=;
        b=bouj+2M9urBXvFJ5K/O+dTYmgXzSr+S/Ik2NQmrSHdA+X8BQNiSjgUoZxa8GiMPriu
         CBgo/N1EhJx+V94t9m/R1qSNOn+eEi+t6k9/pADkP6PE+aKyKatcgNzMhmnPTWidKCFZ
         WgFq87i27xHJ/ELaXrcmM62qmDTxZMDFsPbY/FB26AvFcPIA9dlLpTyFb9jA0G9FBXb0
         v2+j5KYKykm3C47py0M1pPrqmWk+dQNT96uUiOKVqkh5h+xFS5xsJ5HouGhvEsDZghJ3
         PmKgk6Q7KAzZZKhwsXtHTZTSpYi/LgjowIIr2qxwlsKOIuOPpkPm6Mr1bEnviZjUJyU1
         l2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VztW51XA4vx8PX2Mz/t0kTb9/SRjKZo7CzRhZxpblX0=;
        b=Q4Q4pxH9BHOo5oxqV/4+sM52fH7+M3inmeMYZkxalzTTCesVV+evmCXjkeMTX9hJJw
         zaaJI1Qa3tcBBWY0OBZAz/jFhTr+HaUMG3GIPbBgSC+/p7ry1K8L64HW+Jf6b1dQA/eY
         EYmuZaWrro1Ela2VaROi9MWLiANJmXx/7+4ZFU8hWogndemzQMhP/vQWvuqV+KM5NAAa
         J7Zf8H1oFeBb8ATHXq+iAWyMuXb1u9n8JLiAgEM2PA+4OmHVGDa68CcKOzqJckvcNi34
         HSezN2R7qNeaxcCitSsEq9aWwD/zwEvQu9o6Tq92HOeTu5cBf6VyUowPl0TQqgcmL3eV
         zpFg==
X-Gm-Message-State: APjAAAXX2hF+6kdE5rGpNtbM1+6E4hI/0oLGOiSWusobwpV5Rdkwe5Xb
        0mR4hTQzisMKFPW9tsbl2JWubab+
X-Google-Smtp-Source: APXvYqwIeDQKZJbyVJjTXgFuAPjG2NNPGJortHgJf9lEnuPVu86cfNOCfw67hVgMbc52foDzfAWGPw==
X-Received: by 2002:a17:902:1107:: with SMTP id d7mr10149403pla.184.1565975308839;
        Fri, 16 Aug 2019 10:08:28 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id e13sm7194113pff.181.2019.08.16.10.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 10:08:28 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        sdf@google.com, Petar Penkov <ppenkov@google.com>
Subject: [bpf-next,v2] selftests/bpf: fix race in test_tcp_rtt test
Date:   Fri, 16 Aug 2019 10:08:25 -0700
Message-Id: <20190816170825.22500-1-ppenkov.kernel@gmail.com>
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
index 90c3862f74a8..93916a69823e 100644
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
+		usleep(10);
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
+	if (wait_for_ack(client_fd, 100) < 0) {
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

