Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9885F682350
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 05:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjAaEg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 23:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjAaEg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 23:36:26 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EABB3A595
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 20:35:54 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id bb40so4869123qtb.2
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 20:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=skMwyc22NR9Qk8YVny2dR/jEXQcu8nXYP2om5YcHDp8=;
        b=vbqASWaYlv8/x9oWVi1jq0jC7/PmzDkGXEQjFiy0sXuRAEqjH0A7jFO8775AstWjlH
         1x8gnNQaryySG7a0fOiYPxDhGfddCQ0XklaZVrr/n8re5om8WYECP9s90uGxS4q8CKxK
         s2uEaLAXVG2MjBTBCCTKn2uGh057r+1H3pt53Kl7AWuyM7DIcXzmjvYzG23WWx5WEmk9
         S04IYBPaUnvghaSOCUFoVn7WwMlS4D3dRo/uPVet+Z7CMcDBFIZZcVLQAtR389pgtGO/
         uDNNsiX6IEpzwdSiQQfTFLNWp0ddWrGQR4mBNyb02t5DA6hTpNoPn8OxDv7VK0DtGJva
         d5NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=skMwyc22NR9Qk8YVny2dR/jEXQcu8nXYP2om5YcHDp8=;
        b=vr0oCGfCBsvRzQd5u6TczwMTAXtbCz5QyxqsOMb4KvFsR5XqygPaUP3oizmzCLnC++
         jOPhyXbueQEu4rQ+NwJ4YGTIx2tm+178p6Ar3twECcncRvtjPqp4VlV5ROSOfCBZp/ez
         P5WGxFNaPe8UTnCPBdCQQuMfVHaB49f2VCNNDZU4ImSiJEkh7ti069AVEH4o9qPfYRsV
         F4FAklQIckOzqLLLaY5m5Yb27hx+vjOTciIviPrOXfdF0gzYRgBrfxxdERy/eArao9yg
         OD6xLw/Lz/r4s/gRbWpdz+Yg0/cUzpLx1K/H05AO5ih4P5GnQSjZlUF9DlOsx8ETYz+O
         Pqmg==
X-Gm-Message-State: AO0yUKVLziOLc+CDaPMJPgxp9pAQD7UMZP0ebPPIgmIZhIGDRNqaoYQw
        5AsMTVk6PJWBrG5P9JK54aMKUQ==
X-Google-Smtp-Source: AK7set9BM+8iUKiCkpfLTmszHcuZgOQUjyY5cg1pD/EnFFDR3dMjz+xiPonG6jQ4anPf45O7e+VacQ==
X-Received: by 2002:ac8:7e93:0:b0:3b8:2940:e2e8 with SMTP id w19-20020ac87e93000000b003b82940e2e8mr24857592qtj.14.1675139753541;
        Mon, 30 Jan 2023 20:35:53 -0800 (PST)
Received: from C02G8BMUMD6R.bytedance.net ([148.59.24.152])
        by smtp.gmail.com with ESMTPSA id b13-20020ac801cd000000b003a6a19ee4f0sm9260682qtg.33.2023.01.30.20.35.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Jan 2023 20:35:53 -0800 (PST)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jakub@cloudflare.com, hdanton@sina.com, cong.wang@bytedance.com
Subject: [PATCH RFC net-next v2 3/3] selftests/bpf: Add a test case for vsock sockmap
Date:   Mon, 30 Jan 2023 20:35:14 -0800
Message-Id: <20230118-support-vsock-sockmap-connectible-v2-3-58ffafde0965@bytedance.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230118-support-vsock-sockmap-connectible-v2-0-58ffafde0965@bytedance.com>
References: <20230118-support-vsock-sockmap-connectible-v2-0-58ffafde0965@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test case testing the redirection from connectible AF_VSOCK
sockets to connectible AF_UNIX sockets.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 163 +++++++++++++++++++++
 1 file changed, 163 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 2cf0c7a3fe23..8b5a2e09c9ed 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -18,6 +18,7 @@
 #include <string.h>
 #include <sys/select.h>
 #include <unistd.h>
+#include <linux/vm_sockets.h>
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
@@ -249,6 +250,16 @@ static void init_addr_loopback6(struct sockaddr_storage *ss, socklen_t *len)
 	*len = sizeof(*addr6);
 }
 
+static void init_addr_loopback_vsock(struct sockaddr_storage *ss, socklen_t *len)
+{
+	struct sockaddr_vm *addr = memset(ss, 0, sizeof(*ss));
+
+	addr->svm_family = AF_VSOCK;
+	addr->svm_port = VMADDR_PORT_ANY;
+	addr->svm_cid = VMADDR_CID_LOCAL;
+	*len = sizeof(*addr);
+}
+
 static void init_addr_loopback(int family, struct sockaddr_storage *ss,
 			       socklen_t *len)
 {
@@ -259,6 +270,9 @@ static void init_addr_loopback(int family, struct sockaddr_storage *ss,
 	case AF_INET6:
 		init_addr_loopback6(ss, len);
 		return;
+	case AF_VSOCK:
+		init_addr_loopback_vsock(ss, len);
+		return;
 	default:
 		FAIL("unsupported address family %d", family);
 	}
@@ -1434,6 +1448,8 @@ static const char *family_str(sa_family_t family)
 		return "IPv6";
 	case AF_UNIX:
 		return "Unix";
+	case AF_VSOCK:
+		return "VSOCK";
 	default:
 		return "unknown";
 	}
@@ -1644,6 +1660,151 @@ static void test_unix_redir(struct test_sockmap_listen *skel, struct bpf_map *ma
 	unix_skb_redir_to_connected(skel, map, sotype);
 }
 
+/* Returns two connected loopback vsock sockets */
+static int vsock_socketpair_connectible(int sotype, int *v0, int *v1)
+{
+	struct sockaddr_storage addr;
+	socklen_t len = sizeof(addr);
+	int s, p, c;
+
+	s = socket_loopback(AF_VSOCK, sotype);
+	if (s < 0)
+		return -1;
+
+	c = xsocket(AF_VSOCK, sotype | SOCK_NONBLOCK, 0);
+	if (c == -1)
+		goto close_srv;
+
+	if (getsockname(s, sockaddr(&addr), &len) < 0)
+		goto close_cli;
+
+	if (connect(c, sockaddr(&addr), len) < 0 && errno != EINPROGRESS) {
+		FAIL_ERRNO("connect");
+		goto close_cli;
+	}
+
+	len = sizeof(addr);
+	p = accept_timeout(s, sockaddr(&addr), &len, IO_TIMEOUT_SEC);
+	if (p < 0)
+		goto close_cli;
+
+	*v0 = p;
+	*v1 = c;
+
+	return 0;
+
+close_cli:
+	close(c);
+close_srv:
+	close(s);
+
+	return -1;
+}
+
+static void vsock_unix_redir_connectible(int sock_mapfd, int verd_mapfd,
+					 enum redir_mode mode, int sotype)
+{
+	const char *log_prefix = redir_mode_str(mode);
+	char a = 'a', b = 'b';
+	int u0, u1, v0, v1;
+	int sfd[2];
+	unsigned int pass;
+	int err, n;
+	u32 key;
+
+	zero_verdict_count(verd_mapfd);
+
+	if (socketpair(AF_UNIX, SOCK_STREAM | SOCK_NONBLOCK, 0, sfd))
+		return;
+
+	u0 = sfd[0];
+	u1 = sfd[1];
+
+	err = vsock_socketpair_connectible(sotype, &v0, &v1);
+	if (err) {
+		FAIL("vsock_socketpair_connectible() failed");
+		goto close_uds;
+	}
+
+	err = add_to_sockmap(sock_mapfd, u0, v0);
+	if (err) {
+		FAIL("add_to_sockmap failed");
+		goto close_vsock;
+	}
+
+	n = write(v1, &a, sizeof(a));
+	if (n < 0)
+		FAIL_ERRNO("%s: write", log_prefix);
+	if (n == 0)
+		FAIL("%s: incomplete write", log_prefix);
+	if (n < 1)
+		goto out;
+
+	n = recv(mode == REDIR_INGRESS ? u0 : u1, &b, sizeof(b), MSG_DONTWAIT);
+	if (n < 0)
+		FAIL("%s: recv() err, errno=%d", log_prefix, errno);
+	if (n == 0)
+		FAIL("%s: incomplete recv", log_prefix);
+	if (b != a)
+		FAIL("%s: vsock socket map failed, %c != %c", log_prefix, a, b);
+
+	key = SK_PASS;
+	err = xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
+	if (err)
+		goto out;
+	if (pass != 1)
+		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
+out:
+	key = 0;
+	bpf_map_delete_elem(sock_mapfd, &key);
+	key = 1;
+	bpf_map_delete_elem(sock_mapfd, &key);
+
+close_vsock:
+	close(v0);
+	close(v1);
+
+close_uds:
+	close(u0);
+	close(u1);
+}
+
+static void vsock_unix_skb_redir_connectible(struct test_sockmap_listen *skel,
+					     struct bpf_map *inner_map,
+					     int sotype)
+{
+	int verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
+	int verdict_map = bpf_map__fd(skel->maps.verdict_map);
+	int sock_map = bpf_map__fd(inner_map);
+	int err;
+
+	err = xbpf_prog_attach(verdict, sock_map, BPF_SK_SKB_VERDICT, 0);
+	if (err)
+		return;
+
+	skel->bss->test_ingress = false;
+	vsock_unix_redir_connectible(sock_map, verdict_map, REDIR_EGRESS, sotype);
+	skel->bss->test_ingress = true;
+	vsock_unix_redir_connectible(sock_map, verdict_map, REDIR_INGRESS, sotype);
+
+	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
+}
+
+static void test_vsock_redir(struct test_sockmap_listen *skel, struct bpf_map *map)
+{
+	const char *family_name, *map_name;
+	char s[MAX_TEST_NAME];
+
+	family_name = family_str(AF_VSOCK);
+	map_name = map_type_str(map);
+	snprintf(s, sizeof(s), "%s %s %s", map_name, family_name, __func__);
+	if (!test__start_subtest(s))
+		return;
+
+	vsock_unix_skb_redir_connectible(skel, map, SOCK_STREAM);
+	vsock_unix_skb_redir_connectible(skel, map, SOCK_SEQPACKET);
+}
+
 static void test_reuseport(struct test_sockmap_listen *skel,
 			   struct bpf_map *map, int family, int sotype)
 {
@@ -2015,12 +2176,14 @@ void serial_test_sockmap_listen(void)
 	run_tests(skel, skel->maps.sock_map, AF_INET6);
 	test_unix_redir(skel, skel->maps.sock_map, SOCK_DGRAM);
 	test_unix_redir(skel, skel->maps.sock_map, SOCK_STREAM);
+	test_vsock_redir(skel, skel->maps.sock_map);
 
 	skel->bss->test_sockmap = false;
 	run_tests(skel, skel->maps.sock_hash, AF_INET);
 	run_tests(skel, skel->maps.sock_hash, AF_INET6);
 	test_unix_redir(skel, skel->maps.sock_hash, SOCK_DGRAM);
 	test_unix_redir(skel, skel->maps.sock_hash, SOCK_STREAM);
+	test_vsock_redir(skel, skel->maps.sock_hash);
 
 	test_sockmap_listen__destroy(skel);
 }

-- 
2.35.1

