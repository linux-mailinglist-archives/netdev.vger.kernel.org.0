Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDA767294A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 21:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjARU3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 15:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjARU32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 15:29:28 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7FA5EF89
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 12:29:27 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id y3-20020a17090a390300b00229add7bb36so3359541pjb.4
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 12:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G3SSHfwD1JWrYtYUVCovQ7Td7i1weIvYDlK0fNQrT54=;
        b=lqiHRIGe8gj28v5IdrqBD149FOkVZQtrXO1HuNvbrlLaDvAuhbJY0jmZOtUC83FLlr
         MoJ4uWPuQq5mS5cWJZhqyMxyLYSi1+TEHqCBWfyb6a+WPYwcumKZ/fHWh6tfk4iH1KMr
         mmEmSLtHSkhaTM1Rbxq57fqW5lbW3J0l0cn99mTAxb5dUFvgIa8AHfnNjcMv7O5zeu6w
         pi6SSBZhCVgf4PFi/XGE4YlaEt6XQ+rK66MaPbQAJjWHHWw1r08yzkIdOtBgMtsJvd6c
         9GsTb2PN6FOf8S4mQzvozkpa9oPE3Z2CVEQqpcjc9GjIGVThuFJkhZGealsuuiakVnx3
         LMkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G3SSHfwD1JWrYtYUVCovQ7Td7i1weIvYDlK0fNQrT54=;
        b=mvXlAIc5PSm1tGt+Rq7Z1llHWik0mdlv6NXNdA6VFw5w5n9GE7f4nWUkcv+S597hPi
         eJUYTtMYy4YRFAy0ouKAsz1JBuUVEhxezCM1yuxfL90yc+EwjgML0eyEc8dniGtHdASP
         LWYnxwcHdC6k+l6dF2cjhwZ/4NCIhvGjRnovcJo2kTTjbw7BnGEDcdTzNE2Inef+peuL
         T4sIUIsMvqHI2fMguY1vzf/HFUNEpEiBJTG8WNhvtrTrayw/45Nr3RPVeaho2fgiG3L8
         d0gJV0gAo985FtD6C4oQhokYpEwbSq9/+XXTYaYfS+zPj/dqA3+8OOxvq548pNnOnj4K
         0idw==
X-Gm-Message-State: AFqh2kr0bzcfbvjDM59zT9yiiJ+0GEZYC9eHhNFjY2GjCKrSm5TaoyAX
        lH0pvZGOoYVu4+8FMzgBPTKdtQ==
X-Google-Smtp-Source: AMrXdXuo5N5MDii1yAlspTLojs1jtFrzmpvl6JPW+DYYC4k2nz8+GCQyAHmbFEc0nF1Ygod5iuA6Iw==
X-Received: by 2002:a17:90a:7408:b0:229:ca6a:464e with SMTP id a8-20020a17090a740800b00229ca6a464emr3121546pjg.36.1674073766884;
        Wed, 18 Jan 2023 12:29:26 -0800 (PST)
Received: from [127.0.1.1] (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090a3b4d00b002132f3e71c6sm1724948pjf.52.2023.01.18.12.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 12:29:26 -0800 (PST)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Wed, 18 Jan 2023 12:27:41 -0800
Subject: [PATCH RFC 3/3] selftests/bpf: Add a test case for vsock sockmap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230118-support-vsock-sockmap-connectible-v1-3-d47e6294827b@bytedance.com>
References: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
In-Reply-To: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
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
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
X-Mailer: b4 0.11.2
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
index 2cf0c7a3fe232..8b5a2e09c9ede 100644
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
2.30.2
