Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDD1EB9AB4
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 01:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404923AbfITXaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 19:30:25 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:38832 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404787AbfITXaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 19:30:25 -0400
Received: by mail-pf1-f201.google.com with SMTP id o73so5786707pfg.5
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 16:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LJNLWG7qxYqlS4vxPRzBWLNbdp5Nxg08SBYosGNjYvM=;
        b=I9j8JiW/Y939Qs7zTunJb7AGiK32Ul7LmZ0u0+HTC7x8O4OOHqanSRqoe2LtxWr8pm
         FF+zwUd3VDy7XLS/F6ZVOhmDxnC9XwoehOTphIls8m351YHSEJuASbaO4sz/zjkCF6hR
         ZHWcKkidhcICyS2j+dsJlQ/UWxaPjzIwnEf7diBYMgvzuahkYW8oljl2F9eNy8RLCPW3
         8CR7HPXv5/xL4fIQ2j+rycayMRGmY0/UsQqBulT5usIEF2hF7ezGbTAQSIjDFJ30y/4E
         ox420ynJgDHTxeM4Zv7ICWG1mqQWwTPnSNjB2YXnFwlpstahr+gTtJQhiJEf4cwR/x5e
         zAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=LJNLWG7qxYqlS4vxPRzBWLNbdp5Nxg08SBYosGNjYvM=;
        b=Jqzbgyx2p3pWYSnEsHHhFiQCTtFbbCDgAjMpP42kv5uBya2yqtj+cg5Dvp2QA8zSOO
         Gtx2hK0LgqMSxVVYxmlA2b70yeJj+yeyekCa12w6+/DBebexQ2Z8EQf0ZHrQnoN/0T/Y
         7y1Ea/+2DX+1pq26DEF9EJ+OcSjw/kGD0QuxDxrXhThhiIXvsLTkqDGKEW5DAGQ5b6ls
         VfV7ajijTWlzg30ML7oB7Mmv/v65YLTEpgxqpsGF5zKNpuzsiISxa8lrK/wwy+cZthLm
         NEYObYRxEGQRXneaL0uWGFPoVNE/77REY2j/PLjPdk5YxcT8/+BUJAdCPIGbakKzal6V
         xzIw==
X-Gm-Message-State: APjAAAUOUH63rEE6Byckv9U1Iy1+h+cZ30FY8ueA985Lc+aFjgIAYV4z
        rAOSSSQ003CzAsDadjpCTUlZXJ0v/4cW2/65ogqEG8cKzLgg5R6BBBjBQvf7BqWf3y0ahrcA5fN
        uDDpRUHbKPpfccna2w6K1XvFoc5BLofVvzn+urf5eFRDx+nrSDupfPA==
X-Google-Smtp-Source: APXvYqxhXCDSVeeIEupzk0OAb4uhhKv2RGkIC/qWrJabw+QjDvsPOWSJb0hRJHF3gvZ0TPbmh13Fl9s=
X-Received: by 2002:a65:6709:: with SMTP id u9mr18415155pgf.59.1569022222352;
 Fri, 20 Sep 2019 16:30:22 -0700 (PDT)
Date:   Fri, 20 Sep 2019 16:30:19 -0700
Message-Id: <20190920233019.187498-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH bpf] selftests/bpf: test_progs: fix client/server race in tcp_rtt
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the same problem I found earlier in test_sockopt_inherit:
there is a race between server thread doing accept() and client
thread doing connect(). Let's explicitly synchronize them via
pthread conditional variable.

Fixes: b55873984dab ("selftests/bpf: test BPF_SOCK_OPS_RTT_CB")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
index fdc0b3614a9e..e64058906bcd 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
@@ -203,6 +203,9 @@ static int start_server(void)
 	return fd;
 }
 
+static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
+
 static void *server_thread(void *arg)
 {
 	struct sockaddr_storage addr;
@@ -215,6 +218,10 @@ static void *server_thread(void *arg)
 		return NULL;
 	}
 
+	pthread_mutex_lock(&server_started_mtx);
+	pthread_cond_signal(&server_started);
+	pthread_mutex_unlock(&server_started_mtx);
+
 	client_fd = accept(fd, (struct sockaddr *)&addr, &len);
 	if (CHECK_FAIL(client_fd < 0)) {
 		perror("Failed to accept client");
@@ -248,7 +255,14 @@ void test_tcp_rtt(void)
 	if (CHECK_FAIL(server_fd < 0))
 		goto close_cgroup_fd;
 
-	pthread_create(&tid, NULL, server_thread, (void *)&server_fd);
+	if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
+				      (void *)&server_fd)))
+		goto close_cgroup_fd;
+
+	pthread_mutex_lock(&server_started_mtx);
+	pthread_cond_wait(&server_started, &server_started_mtx);
+	pthread_mutex_unlock(&server_started_mtx);
+
 	CHECK_FAIL(run_test(cgroup_fd, server_fd));
 	close(server_fd);
 close_cgroup_fd:
-- 
2.23.0.351.gc4317032e6-goog

