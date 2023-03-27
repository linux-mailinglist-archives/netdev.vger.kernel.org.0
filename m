Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397826CAE4F
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 21:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbjC0TNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 15:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbjC0TMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 15:12:48 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131902726
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 12:11:56 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id h16so2834292qtn.7
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 12:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1679944316;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OzIQcNqys8Zuk/+dMRpS5HHTGI8p2pv2tGiZ4CSbhe0=;
        b=igvtpJ4h3mUlwgPmMGjf4lj+LFMtI2T0XYCHEitT1RscqfzENMJBHAjAnDcXeggWw6
         BbPAk8qywx5LNuJPbvpM5LPKuNdtgstorMSUa2VKyft0Ghm+pq958iTlO31Bo/D21RLA
         Isr+wZmCR5DbTw3i2Ukpq6BHU8FPyOcdQxORtvQONKTHzcU0KZ/npyCiM0AGLKaIp3bQ
         c3zpG9mGslhgAvJqvq9FwLylcN9VzV1BdZwEKwrYOtZhxr+Rgn8eFOLI7PI0ojx3O+1h
         0Osy9DCmUHnGVJ9MPQP4V1H2L6XWqTn3ZxTaIqg8iHNRInwAzGBvvs6QX1yCdHaDp1St
         s9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679944316;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OzIQcNqys8Zuk/+dMRpS5HHTGI8p2pv2tGiZ4CSbhe0=;
        b=jhBG0jXfnTFmptjXTrhJJyiarVJxiEjaN/eklTi3YvbAQNdMn95jvUOxp5wv8U0MQI
         +q0NOGWXshrLtSCqSRXbdtI/vNVCtI8m2gAeQBEt0wWUBBaeXHqYg3H1KO3PJkkobYb7
         2gbpBggjPh6d4priC6LAfMfAK/w9z57KxtaXYZE/ofjP7AEzqy+Pniqr0OCo3G9RA72m
         U5zhnMvixjhMxGRhQsKIQ//g7Vqj1MfrLCX7Foz7bJ2rHqVhSp8vDa8gRJVozpF9dwwA
         cz2AfAyA9xIvHEtqT4TyUWZA2lVjleucLXFfMAIn7RexzkLbiTX6T+p068NYt3UJxa+l
         pCSw==
X-Gm-Message-State: AO0yUKWMnDx2le5228K/MaOV11qzr4ho1okInCFu3qSimZ4w+hRl38Y1
        m8a1prkvaizkLaIYBkYHyEt+HQ==
X-Google-Smtp-Source: AK7set+DaMDq197o5VboTURLgPUvM1L8Cilfj2fo6Qhqc7ss6X/78vWszCgw7RUV52PIvI5enmaXCA==
X-Received: by 2002:a05:622a:81:b0:3de:4819:2449 with SMTP id o1-20020a05622a008100b003de48192449mr23393643qtw.38.1679944316085;
        Mon, 27 Mar 2023 12:11:56 -0700 (PDT)
Received: from [172.17.0.3] ([130.44.215.126])
        by smtp.gmail.com with ESMTPSA id d185-20020a37b4c2000000b007425ef4cbc2sm16989236qkf.100.2023.03.27.12.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 12:11:55 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Mon, 27 Mar 2023 19:11:53 +0000
Subject: [PATCH net-next v4 3/3] selftests/bpf: add a test case for vsock
 sockmap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230327-vsock-sockmap-v4-3-c62b7cd92a85@bytedance.com>
References: <20230327-vsock-sockmap-v4-0-c62b7cd92a85@bytedance.com>
In-Reply-To: <20230327-vsock-sockmap-v4-0-c62b7cd92a85@bytedance.com>
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
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test case testing the redirection from connectible AF_VSOCK
sockets to connectible AF_UNIX sockets.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Acked-by: Stefano Garzarella <sgarzare@redhat.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 163 +++++++++++++++++++++
 1 file changed, 163 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 567e07c19ecc..8f09e1ea3ba7 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -18,6 +18,7 @@
 #include <string.h>
 #include <sys/select.h>
 #include <unistd.h>
+#include <linux/vm_sockets.h>
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
@@ -251,6 +252,16 @@ static void init_addr_loopback6(struct sockaddr_storage *ss, socklen_t *len)
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
@@ -261,6 +272,9 @@ static void init_addr_loopback(int family, struct sockaddr_storage *ss,
 	case AF_INET6:
 		init_addr_loopback6(ss, len);
 		return;
+	case AF_VSOCK:
+		init_addr_loopback_vsock(ss, len);
+		return;
 	default:
 		FAIL("unsupported address family %d", family);
 	}
@@ -1478,6 +1492,8 @@ static const char *family_str(sa_family_t family)
 		return "IPv6";
 	case AF_UNIX:
 		return "Unix";
+	case AF_VSOCK:
+		return "VSOCK";
 	default:
 		return "unknown";
 	}
@@ -1689,6 +1705,151 @@ static void test_unix_redir(struct test_sockmap_listen *skel, struct bpf_map *ma
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
@@ -2060,12 +2221,14 @@ void serial_test_sockmap_listen(void)
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
2.30.2

