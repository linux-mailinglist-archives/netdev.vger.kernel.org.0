Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590CE107E29
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 12:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfKWLII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 06:08:08 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39987 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfKWLIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 06:08:06 -0500
Received: by mail-lj1-f195.google.com with SMTP id q2so10290237ljg.7
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 03:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l6hoyFyikNGhNFuQZ2cgm5txH5kYFoNddoXqF9YdMD4=;
        b=C8si1SFRBir+wYbcpwty3BmqITjCkXjIlG6AjwWBxs1ulA1fJsXz5+ierU4DP+gY9f
         uF72Pepw/v5JrhefUm1+eKM9lEPESvXbIlB6Nwl20CtpYI2OgB6neO6Kd2U3ijDrEm/B
         X98066pV5CBifZf86Unh5TShvVN9hat3kWOE8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l6hoyFyikNGhNFuQZ2cgm5txH5kYFoNddoXqF9YdMD4=;
        b=iR/54tbjwX4OPROKToEU7TVv1weAFOqM0IOGWgcgXYepk7d2MSNzkrH0TV3VZu6kY6
         UGBnx+pv54CMf1zWtA5E2K1lAkMTy2HkNznGUxtK+fkB4MLO7FEcNrBXCnTlNU15D1t9
         4MiZk0yCrJs/+T3+EhvfDGZT8eQBILZUpM+dJ7MpsotCY31zs2BKxxJwiRbATg2P+Sz8
         xONNv5y5GrT/ezxoVJPyrhR0uJOly49JGsvzRLLSdAxrExAO2upxvamzUbNpmHFMvuI4
         zZpN0zmZIOPDOiolnlV+yX2cff9JCYniTScuZA/GnsDrGIYmkhEkqgc3i4Jo98tkY9UL
         Mgjw==
X-Gm-Message-State: APjAAAVml5CVrmm02las9QhHgY1SiKGjwoV6KMGok31G994IGEZqjYvq
        kYDZqkmKgYE0XKyxqEsrqeaqiA==
X-Google-Smtp-Source: APXvYqzduL0mwhk+4SPeTaSmn6Tb1k4YU9DCZpDku4G5//FVC1Or8nuN0X/Qf4jptGbXBmAgFtFDdQ==
X-Received: by 2002:a2e:9a55:: with SMTP id k21mr14090022ljj.85.1574507283865;
        Sat, 23 Nov 2019 03:08:03 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id v21sm604654ljh.53.2019.11.23.03.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 03:08:03 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next 7/8] selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
Date:   Sat, 23 Nov 2019 12:07:50 +0100
Message-Id: <20191123110751.6729-8-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191123110751.6729-1-jakub@cloudflare.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parametrize the SK_REUSEPORT tests so that the map type for storing sockets
can be selected at run-time. Also allow choosing which L4 protocols get
tested.

Run the extended reuseport program test two times, once for
REUSEPORT_ARRAY, and once for SOCKMAP but just with TCP to cover the newly
enabled map type.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/bpf/Makefile          |   7 +-
 .../selftests/bpf/test_select_reuseport.c     | 141 ++++++++++++++----
 .../selftests/bpf/test_select_reuseport.sh    |  14 ++
 3 files changed, 131 insertions(+), 31 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_select_reuseport.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 085678d88ef8..51d16837b6ca 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -28,7 +28,7 @@ LDLIBS += -lcap -lelf -lrt -lpthread
 TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test_progs \
 	test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
-	test_cgroup_storage test_select_reuseport \
+	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
 	test_cgroup_attach test_progs-no_alu32
 
@@ -60,7 +60,8 @@ TEST_PROGS := test_kmod.sh \
 	test_tc_tunnel.sh \
 	test_tc_edt.sh \
 	test_xdping.sh \
-	test_bpftool_build.sh
+	test_bpftool_build.sh \
+	test_select_reuseport.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh \
@@ -71,7 +72,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
-	test_lirc_mode2_user xdping
+	test_lirc_mode2_user xdping test_select_reuseport
 
 TEST_CUSTOM_PROGS = urandom_read
 
diff --git a/tools/testing/selftests/bpf/test_select_reuseport.c b/tools/testing/selftests/bpf/test_select_reuseport.c
index 7566c13eb51a..732cfeee189f 100644
--- a/tools/testing/selftests/bpf/test_select_reuseport.c
+++ b/tools/testing/selftests/bpf/test_select_reuseport.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2018 Facebook */
 
+#define _GNU_SOURCE
 #include <stdlib.h>
 #include <unistd.h>
 #include <stdbool.h>
@@ -29,6 +30,12 @@
 #define TCP_FO_SYSCTL "/proc/sys/net/ipv4/tcp_fastopen"
 #define REUSEPORT_ARRAY_SIZE 32
 
+#define BIND_TO_INANY		true
+#define BIND_TO_LOOPBACK	(!BIND_TO_INANY)
+
+static enum bpf_map_type cfg_map_type = BPF_MAP_TYPE_REUSEPORT_SOCKARRAY;
+static unsigned int cfg_sock_types = (1 << SOCK_STREAM) | (1 << SOCK_DGRAM);
+
 static int result_map, tmp_index_ovr_map, linum_map, data_check_map;
 static enum result expected_results[NR_RESULTS];
 static int sk_fds[REUSEPORT_ARRAY_SIZE];
@@ -61,7 +68,7 @@ static void create_maps(void)
 
 	/* Creating reuseport_array */
 	attr.name = "reuseport_array";
-	attr.map_type = BPF_MAP_TYPE_REUSEPORT_SOCKARRAY;
+	attr.map_type = cfg_map_type;
 	attr.key_size = sizeof(__u32);
 	attr.value_size = sizeof(__u32);
 	attr.max_entries = REUSEPORT_ARRAY_SIZE;
@@ -680,53 +687,131 @@ static void cleanup(void)
 	bpf_object__close(obj);
 }
 
+static const char *family_to_str(int family)
+{
+	switch (family) {
+	case AF_INET:
+		return "IPv4";
+	case AF_INET6:
+		return "IPv6";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *type_to_str(int type)
+{
+	switch (type) {
+	case SOCK_STREAM:
+		return "TCP";
+	case SOCK_DGRAM:
+		return "UDP";
+	default:
+		return "unknown";
+	}
+}
+
+static void test_one(int family, int type, bool inany)
+{
+	int err;
+
+	printf("######## %s/%s %-8s ########\n",
+	       family_to_str(family), type_to_str(type),
+	       inany ? "INANY" : "LOOPBACK");
+
+	setup_per_test(type, family, inany);
+
+	test_err_inner_map(type, family);
+
+	/* Install reuseport_array to the outer_map */
+	err = bpf_map_update_elem(outer_map, &index_zero, &reuseport_array,
+				  BPF_ANY);
+	CHECK(err == -1, "update_elem(outer_map)",
+	      "err:%d errno:%d\n", err, errno);
+
+	test_err_skb_data(type, family);
+	test_err_sk_select_port(type, family);
+	test_pass(type, family);
+	test_syncookie(type, family);
+	test_pass_on_err(type, family);
+	/* Must be the last test */
+	test_detach_bpf(type, family);
+
+	cleanup_per_test();
+	printf("\n");
+}
+
 static void test_all(void)
 {
-	/* Extra SOCK_STREAM to test bind_inany==true */
-	const int types[] = { SOCK_STREAM, SOCK_DGRAM, SOCK_STREAM };
-	const char * const type_strings[] = { "TCP", "UDP", "TCP" };
-	const char * const family_strings[] = { "IPv6", "IPv4" };
+	const int types[] = { SOCK_STREAM, SOCK_DGRAM };
 	const unsigned short families[] = { AF_INET6, AF_INET };
-	const bool bind_inany[] = { false, false, true };
-	int t, f, err;
+	int t, f;
 
 	for (f = 0; f < ARRAY_SIZE(families); f++) {
 		unsigned short family = families[f];
 
 		for (t = 0; t < ARRAY_SIZE(types); t++) {
-			bool inany = bind_inany[t];
 			int type = types[t];
 
-			printf("######## %s/%s %s ########\n",
-			       family_strings[f], type_strings[t],
-				inany ? " INANY  " : "LOOPBACK");
+			/* Socket type excluded from tests? */
+			if (~cfg_sock_types & (1 << type))
+				continue;
 
-			setup_per_test(type, family, inany);
+			test_one(family, type, BIND_TO_LOOPBACK);
+			test_one(family, type, BIND_TO_INANY);
+		}
+	}
+}
 
-			test_err_inner_map(type, family);
+static void __attribute__((noreturn)) usage(void)
+{
+	fprintf(stderr,
+		"Usage: %s [-m reuseport_sockarray|sockmap] [-t] [-u]\n",
+		program_invocation_short_name);
+	exit(1);
+}
 
-			/* Install reuseport_array to the outer_map */
-			err = bpf_map_update_elem(outer_map, &index_zero,
-						  &reuseport_array, BPF_ANY);
-			CHECK(err == -1, "update_elem(outer_map)",
-			      "err:%d errno:%d\n", err, errno);
+static enum bpf_map_type parse_map_type(const char *optarg)
+{
+	if (!strcmp(optarg, "reuseport_sockarray"))
+		return BPF_MAP_TYPE_REUSEPORT_SOCKARRAY;
+	if (!strcmp(optarg, "sockmap"))
+		return BPF_MAP_TYPE_SOCKMAP;
 
-			test_err_skb_data(type, family);
-			test_err_sk_select_port(type, family);
-			test_pass(type, family);
-			test_syncookie(type, family);
-			test_pass_on_err(type, family);
-			/* Must be the last test */
-			test_detach_bpf(type, family);
+	return BPF_MAP_TYPE_UNSPEC;
+}
 
-			cleanup_per_test();
-			printf("\n");
+static void parse_opts(int argc, char **argv)
+{
+	unsigned int sock_types = 0;
+	int c;
+
+	while ((c = getopt(argc, argv, "hm:tu")) != -1) {
+		switch (c) {
+		case 'h':
+			usage();
+			break;
+		case 'm':
+			cfg_map_type = parse_map_type(optarg);
+			break;
+		case 't':
+			sock_types |= 1 << SOCK_STREAM;
+			break;
+		case 'u':
+			sock_types |= 1 << SOCK_DGRAM;
+			break;
 		}
 	}
+
+	if (cfg_map_type == BPF_MAP_TYPE_UNSPEC)
+		usage();
+	if (sock_types != 0)
+		cfg_sock_types = sock_types;
 }
 
-int main(int argc, const char **argv)
+int main(int argc, char **argv)
 {
+	parse_opts(argc, argv);
 	create_maps();
 	prepare_bpf_obj();
 	saved_tcp_fo = read_int_sysctl(TCP_FO_SYSCTL);
diff --git a/tools/testing/selftests/bpf/test_select_reuseport.sh b/tools/testing/selftests/bpf/test_select_reuseport.sh
new file mode 100755
index 000000000000..1951b4886021
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_select_reuseport.sh
@@ -0,0 +1,14 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+set -eu
+
+DIR=$(dirname $0)
+
+echo "Testing reuseport with REUSEPORT_SOCKARRAY..."
+$DIR/test_select_reuseport -m reuseport_sockarray
+
+echo "Testing reuseport with SOCKMAP (TCP only)..."
+$DIR/test_select_reuseport -m sockmap -t
+
+exit 0
-- 
2.20.1

