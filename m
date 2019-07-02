Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F69B5D40B
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfGBQOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:14:23 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:37914 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfGBQOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:14:23 -0400
Received: by mail-pg1-f202.google.com with SMTP id w5so5602900pgs.5
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 09:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=19GqNZAUbOCzZk9W21NwRshRndAMEUUewda1E89bnvQ=;
        b=NWt6Q/DP5kiBE/f1HKxmKwns3SeFXmKDqhUa5J64xlt7UtNK4FnH9p1BUmRqffGwLz
         q6mvuHMaP26eqI2cT2lengeBpH7qvH8qP6T3D4BoYqarGVqbvVEwY4bS1jSDCPiV2iSx
         95hyOWmWSFI3mYcFHUHUCjLe5cyWP6e6KZRKdRiIGVLyygc/T1jW+aXpwtURm2XSeQAq
         n3HItmpnaYCWgZBvBJl8TRak6eb5PywGm0wwzNGypF4ZmbOA5q96t0Y4SS7tC7lF/RHO
         IpxIWjJ9/S0q/bRX5mW7bq5VDDe3ij0omiI/y3/LEVzl/WsOFg/Q04FCZOLnXdYaS9Ve
         DnIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=19GqNZAUbOCzZk9W21NwRshRndAMEUUewda1E89bnvQ=;
        b=qEHJ13mBsR59A9EONsvYcx/3uqMz179W2YN5sgw6m7ga6uMfzjHe7NwtXh1O/jPMTc
         sZ5ClmgKcZ6Q0jVIXN49XEIQhb7+gifh0RUve0+Ch2E1f9yHGqnvSo221VS6T/3PyUDf
         Gd1M+99PLyhHQdfbAsha+jb3n9rl4ij6ZI50wIbVRptF3VsqIfodoi/mEW0CXd3UOg+I
         5y30YEbfQ8wzktQdemL8Zuc+D/ceFniDMV2NGiQghD2SGU/7p7HKbQNantp8iIL/Pyb1
         wIbCip/1JZw/Ygw3/sfQIOeMBAsoeyQbe8N1l8Pf1rg/n3ATn6xQ9x1KCn+LVFke/hQj
         iHzQ==
X-Gm-Message-State: APjAAAVbShIBcxDOXz7CAFqF6Qs4zxgZ3zJj+/AFzi1zJuFXJf4EcFL5
        +2glWiSDppebGPOC0plBStqlk3pEf0NUSsqstRFCWh/px5h5BUsAIyVeOIbutFe/SfabUyzVvRW
        qgWvtwg1RxaYeAV4urpYI/IHxHSbR5h+UFJXi3YMlRYtMIKeeZ4D6OQ==
X-Google-Smtp-Source: APXvYqwHUh8zNb8jMNKwJIMexUiWnjHqQ+BBf4vRUNhG5E3zKy3cy7idbbewpW4CtmlT90Gaw43Tlag=
X-Received: by 2002:a63:e156:: with SMTP id h22mr31113204pgk.370.1562084061733;
 Tue, 02 Jul 2019 09:14:21 -0700 (PDT)
Date:   Tue,  2 Jul 2019 09:14:01 -0700
In-Reply-To: <20190702161403.191066-1-sdf@google.com>
Message-Id: <20190702161403.191066-7-sdf@google.com>
Mime-Version: 1.0
References: <20190702161403.191066-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v2 6/8] selftests/bpf: test BPF_SOCK_OPS_RTT_CB
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the callback is invoked for syn-ack and data packet.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Priyaranjan Jha <priyarjha@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/Makefile        |   3 +-
 tools/testing/selftests/bpf/progs/tcp_rtt.c |  61 +++++
 tools/testing/selftests/bpf/test_tcp_rtt.c  | 254 ++++++++++++++++++++
 3 files changed, 317 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_rtt.c
 create mode 100644 tools/testing/selftests/bpf/test_tcp_rtt.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index de1754a8f5fe..2620406a53ec 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -27,7 +27,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
 	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
-	test_sockopt_multi
+	test_sockopt_multi test_tcp_rtt
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
@@ -107,6 +107,7 @@ $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
 $(OUTPUT)/test_sockopt: cgroup_helpers.c
 $(OUTPUT)/test_sockopt_sk: cgroup_helpers.c
 $(OUTPUT)/test_sockopt_multi: cgroup_helpers.c
+$(OUTPUT)/test_tcp_rtt: cgroup_helpers.c
 
 .PHONY: force
 
diff --git a/tools/testing/selftests/bpf/progs/tcp_rtt.c b/tools/testing/selftests/bpf/progs/tcp_rtt.c
new file mode 100644
index 000000000000..233bdcb1659e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tcp_rtt.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
+
+struct tcp_rtt_storage {
+	__u32 invoked;
+	__u32 dsack_dups;
+	__u32 delivered;
+	__u32 delivered_ce;
+	__u32 icsk_retransmits;
+};
+
+struct bpf_map_def SEC("maps") socket_storage_map = {
+	.type = BPF_MAP_TYPE_SK_STORAGE,
+	.key_size = sizeof(int),
+	.value_size = sizeof(struct tcp_rtt_storage),
+	.map_flags = BPF_F_NO_PREALLOC,
+};
+BPF_ANNOTATE_KV_PAIR(socket_storage_map, int, struct tcp_rtt_storage);
+
+SEC("sockops")
+int _sockops(struct bpf_sock_ops *ctx)
+{
+	struct tcp_rtt_storage *storage;
+	struct bpf_tcp_sock *tcp_sk;
+	int op = (int) ctx->op;
+	struct bpf_sock *sk;
+
+	sk = ctx->sk;
+	if (!sk)
+		return 1;
+
+	storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
+				     BPF_SK_STORAGE_GET_F_CREATE);
+	if (!storage)
+		return 1;
+
+	if (op == BPF_SOCK_OPS_TCP_CONNECT_CB) {
+		bpf_sock_ops_cb_flags_set(ctx, BPF_SOCK_OPS_RTT_CB_FLAG);
+		return 1;
+	}
+
+	if (op != BPF_SOCK_OPS_RTT_CB)
+		return 1;
+
+	tcp_sk = bpf_tcp_sock(sk);
+	if (!tcp_sk)
+		return 1;
+
+	storage->invoked++;
+
+	storage->dsack_dups = tcp_sk->dsack_dups;
+	storage->delivered = tcp_sk->delivered;
+	storage->delivered_ce = tcp_sk->delivered_ce;
+	storage->icsk_retransmits = tcp_sk->icsk_retransmits;
+
+	return 1;
+}
diff --git a/tools/testing/selftests/bpf/test_tcp_rtt.c b/tools/testing/selftests/bpf/test_tcp_rtt.c
new file mode 100644
index 000000000000..90c3862f74a8
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_tcp_rtt.c
@@ -0,0 +1,254 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <error.h>
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <pthread.h>
+
+#include <linux/filter.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "bpf_rlimit.h"
+#include "bpf_util.h"
+#include "cgroup_helpers.h"
+
+#define CG_PATH                                "/tcp_rtt"
+
+struct tcp_rtt_storage {
+	__u32 invoked;
+	__u32 dsack_dups;
+	__u32 delivered;
+	__u32 delivered_ce;
+	__u32 icsk_retransmits;
+};
+
+static void send_byte(int fd)
+{
+	char b = 0x55;
+
+	if (write(fd, &b, sizeof(b)) != 1)
+		error(1, errno, "Failed to send single byte");
+}
+
+static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 invoked,
+		     __u32 dsack_dups, __u32 delivered, __u32 delivered_ce,
+		     __u32 icsk_retransmits)
+{
+	int err = 0;
+	struct tcp_rtt_storage val;
+
+	if (bpf_map_lookup_elem(map_fd, &client_fd, &val) < 0)
+		error(1, errno, "Failed to read socket storage");
+
+	if (val.invoked != invoked) {
+		log_err("%s: unexpected bpf_tcp_sock.invoked %d != %d",
+			msg, val.invoked, invoked);
+		err++;
+	}
+
+	if (val.dsack_dups != dsack_dups) {
+		log_err("%s: unexpected bpf_tcp_sock.dsack_dups %d != %d",
+			msg, val.dsack_dups, dsack_dups);
+		err++;
+	}
+
+	if (val.delivered != delivered) {
+		log_err("%s: unexpected bpf_tcp_sock.delivered %d != %d",
+			msg, val.delivered, delivered);
+		err++;
+	}
+
+	if (val.delivered_ce != delivered_ce) {
+		log_err("%s: unexpected bpf_tcp_sock.delivered_ce %d != %d",
+			msg, val.delivered_ce, delivered_ce);
+		err++;
+	}
+
+	if (val.icsk_retransmits != icsk_retransmits) {
+		log_err("%s: unexpected bpf_tcp_sock.icsk_retransmits %d != %d",
+			msg, val.icsk_retransmits, icsk_retransmits);
+		err++;
+	}
+
+	return err;
+}
+
+static int connect_to_server(int server_fd)
+{
+	struct sockaddr_storage addr;
+	socklen_t len = sizeof(addr);
+	int fd;
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
+	if (fd < 0) {
+		log_err("Failed to create client socket");
+		return -1;
+	}
+
+	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
+		log_err("Failed to get server addr");
+		goto out;
+	}
+
+	if (connect(fd, (const struct sockaddr *)&addr, len) < 0) {
+		log_err("Fail to connect to server");
+		goto out;
+	}
+
+	return fd;
+
+out:
+	close(fd);
+	return -1;
+}
+
+static int run_test(int cgroup_fd, int server_fd)
+{
+	struct bpf_prog_load_attr attr = {
+		.prog_type = BPF_PROG_TYPE_SOCK_OPS,
+		.file = "./tcp_rtt.o",
+		.expected_attach_type = BPF_CGROUP_SOCK_OPS,
+	};
+	struct bpf_object *obj;
+	struct bpf_map *map;
+	int client_fd;
+	int prog_fd;
+	int map_fd;
+	int err;
+
+	err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
+	if (err) {
+		log_err("Failed to load BPF object");
+		return -1;
+	}
+
+	map = bpf_map__next(NULL, obj);
+	map_fd = bpf_map__fd(map);
+
+	err = bpf_prog_attach(prog_fd, cgroup_fd, BPF_CGROUP_SOCK_OPS, 0);
+	if (err) {
+		log_err("Failed to attach BPF program");
+		goto close_bpf_object;
+	}
+
+	client_fd = connect_to_server(server_fd);
+	if (client_fd < 0) {
+		err = -1;
+		goto close_bpf_object;
+	}
+
+	err += verify_sk(map_fd, client_fd, "syn-ack",
+			 /*invoked=*/1,
+			 /*dsack_dups=*/0,
+			 /*delivered=*/1,
+			 /*delivered_ce=*/0,
+			 /*icsk_retransmits=*/0);
+
+	send_byte(client_fd);
+
+	err += verify_sk(map_fd, client_fd, "first payload byte",
+			 /*invoked=*/2,
+			 /*dsack_dups=*/0,
+			 /*delivered=*/2,
+			 /*delivered_ce=*/0,
+			 /*icsk_retransmits=*/0);
+
+	close(client_fd);
+
+close_bpf_object:
+	bpf_object__close(obj);
+	return err;
+}
+
+static int start_server(void)
+{
+	struct sockaddr_in addr = {
+		.sin_family = AF_INET,
+		.sin_addr.s_addr = htonl(INADDR_LOOPBACK),
+	};
+	int fd;
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
+	if (fd < 0) {
+		log_err("Failed to create server socket");
+		return -1;
+	}
+
+	if (bind(fd, (const struct sockaddr *)&addr, sizeof(addr)) < 0) {
+		log_err("Failed to bind socket");
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+static void *server_thread(void *arg)
+{
+	struct sockaddr_storage addr;
+	socklen_t len = sizeof(addr);
+	int fd = *(int *)arg;
+	int client_fd;
+
+	if (listen(fd, 1) < 0)
+		error(1, errno, "Failed to listed on socket");
+
+	client_fd = accept(fd, (struct sockaddr *)&addr, &len);
+	if (client_fd < 0)
+		error(1, errno, "Failed to accept client");
+
+	/* Wait for the next connection (that never arrives)
+	 * to keep this thread alive to prevent calling
+	 * close() on client_fd.
+	 */
+	if (accept(fd, (struct sockaddr *)&addr, &len) >= 0)
+		error(1, errno, "Unexpected success in second accept");
+
+	close(client_fd);
+
+	return NULL;
+}
+
+int main(int args, char **argv)
+{
+	int server_fd, cgroup_fd;
+	int err = EXIT_SUCCESS;
+	pthread_t tid;
+
+	if (setup_cgroup_environment())
+		goto cleanup_obj;
+
+	cgroup_fd = create_and_get_cgroup(CG_PATH);
+	if (cgroup_fd < 0)
+		goto cleanup_cgroup_env;
+
+	if (join_cgroup(CG_PATH))
+		goto cleanup_cgroup;
+
+	server_fd = start_server();
+	if (server_fd < 0) {
+		err = EXIT_FAILURE;
+		goto cleanup_cgroup;
+	}
+
+	pthread_create(&tid, NULL, server_thread, (void *)&server_fd);
+
+	if (run_test(cgroup_fd, server_fd))
+		err = EXIT_FAILURE;
+
+	close(server_fd);
+
+	printf("test_sockopt_sk: %s\n",
+	       err == EXIT_SUCCESS ? "PASSED" : "FAILED");
+
+cleanup_cgroup:
+	close(cgroup_fd);
+cleanup_cgroup_env:
+	cleanup_cgroup_environment();
+cleanup_obj:
+	return err;
+}
-- 
2.22.0.410.gd8fdbe21b5-goog

