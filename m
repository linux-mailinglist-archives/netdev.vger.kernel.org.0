Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B377730D294
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhBCEVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbhBCET1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:19:27 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D35C061353;
        Tue,  2 Feb 2021 20:17:21 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id i30so22161750ota.6;
        Tue, 02 Feb 2021 20:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=saLuuaeWczof9wJYKKradx1AJv81Ng0Xq/LvVJwFhoo=;
        b=u+vfaiGTXjWLjGwvgTY0K3aKnG5b13FMXezlUJdteUKVF/H2ksIS9eVRWp/T4P9yMX
         FiuJoAxiDrmVzbFZnlzbWQ2Wp2M5eN8rqYVK1/T1NzKjRCK6cpZLPMSyKXydgGro0cQr
         GdqUOeVOW3W3sgjtgFsd24xmRgqIp2MgKfhHDRTRQ9ExiYoG//DpUp5EZHBpnBuKks6P
         PyF2Ksar5E1DejK8ajCzXr0H2WbAStPTMBmrtkrqm/F4AA0Jt55Kalue+AgO1xqAM4h3
         7UQlPJOlv9m5ySx8EJeknRYonvAqvPuuq5ugWdrKr9yvn+O6AjBeL0caJMpv0yk4Om+0
         Ly1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=saLuuaeWczof9wJYKKradx1AJv81Ng0Xq/LvVJwFhoo=;
        b=Jkoey850LiB8uQGDoulnzUBfcYx2/Fd1GNYckKkg9iU34Dy2X1FV0Gpeo0FUMBetbF
         2bsgeJFsNxP+5nTbDihFUubBwoETJbuAObjn/WP9RH1O6AhRd7lR9ToPsVciW+ZY/c5l
         ZgfPw50FL3XSHKQNHUPgDn83eM8leU0mFg2WrUV2r4SlWco/CQcjr16nAGj78U43139b
         QIO+OnALAZrpisfHb/611zHgjq6HLwtJm5pN+Fx4LTAeRQDo9Il7BEJ0KSwLQFO4rxia
         VOrufgVAWFH9HIaAOavMb+cmI+VNzX8CAb//YgxCF5NydRLi0lkkQq78jUVIecPdkNrZ
         dzqw==
X-Gm-Message-State: AOAM533afZkKjqpd6jeb6pfyuWCzXZ7r7hJJGeM/VxXJ0v5xOS2HCgj+
        e45twvHunheKImaZgGCUcKRuDiiO0uZHmw==
X-Google-Smtp-Source: ABdhPJzXiZZ5nGmXDboUNeaxgc9lkigW75/iGy/FT/+XSRGxeMohurhXz7PM3x8eX3z3sm3tD2pjAA==
X-Received: by 2002:a9d:3ec4:: with SMTP id b62mr756468otc.43.1612325840931;
        Tue, 02 Feb 2021 20:17:20 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:17:20 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 18/19] selftests/bpf: add test cases for unix and udp sockmap
Date:   Tue,  2 Feb 2021 20:16:35 -0800
Message-Id: <20210203041636.38555-19-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Add two test cases to ensure redirection between two
AF_UNIX sockets or two UDP sockets work.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 241 ++++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |  20 ++
 2 files changed, 261 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index c26e6bf05e49..8f52302165a6 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1441,6 +1441,8 @@ static const char *family_str(sa_family_t family)
 		return "IPv4";
 	case AF_INET6:
 		return "IPv6";
+	case AF_UNIX:
+		return "Unix";
 	default:
 		return "unknown";
 	}
@@ -1563,6 +1565,239 @@ static void test_redir(struct test_sockmap_listen *skel, struct bpf_map *map,
 	}
 }
 
+static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
+				   int verd_mapfd, enum redir_mode mode)
+{
+	const char *log_prefix = redir_mode_str(mode);
+	struct sockaddr_storage addr;
+	int c0, c1, p0, p1;
+	unsigned int pass;
+	socklen_t len;
+	int err, n;
+	u64 value;
+	u32 key;
+	char b;
+
+	zero_verdict_count(verd_mapfd);
+
+	p0 = socket_loopback(family, sotype | SOCK_NONBLOCK);
+	if (p0 < 0)
+		return;
+	len = sizeof(addr);
+	err = xgetsockname(p0, sockaddr(&addr), &len);
+	if (err)
+		goto close_peer0;
+
+	c0 = xsocket(family, sotype | SOCK_NONBLOCK, 0);
+	if (c0 < 0)
+		goto close_peer0;
+	err = xconnect(c0, sockaddr(&addr), len);
+	if (err)
+		goto close_cli0;
+	err = xgetsockname(c0, sockaddr(&addr), &len);
+	if (err)
+		goto close_cli0;
+	err = xconnect(p0, sockaddr(&addr), len);
+	if (err)
+		goto close_cli0;
+
+	p1 = socket_loopback(family, sotype | SOCK_NONBLOCK);
+	if (p1 < 0)
+		goto close_cli0;
+	err = xgetsockname(p1, sockaddr(&addr), &len);
+	if (err)
+		goto close_cli0;
+
+	c1 = xsocket(family, sotype | SOCK_NONBLOCK, 0);
+	if (c1 < 0)
+		goto close_peer1;
+	err = xconnect(c1, sockaddr(&addr), len);
+	if (err)
+		goto close_cli1;
+	err = xgetsockname(c1, sockaddr(&addr), &len);
+	if (err)
+		goto close_cli1;
+	err = xconnect(p1, sockaddr(&addr), len);
+	if (err)
+		goto close_cli1;
+
+	key = 0;
+	value = p0;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close_cli1;
+
+	key = 1;
+	value = p1;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close_cli1;
+
+	n = write(c1, "a", 1);
+	if (n < 0)
+		FAIL_ERRNO("%s: write", log_prefix);
+	if (n == 0)
+		FAIL("%s: incomplete write", log_prefix);
+	if (n < 1)
+		goto close_cli1;
+
+	key = SK_PASS;
+	err = xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
+	if (err)
+		goto close_cli1;
+	if (pass != 1)
+		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
+
+	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
+	if (n < 0)
+		FAIL_ERRNO("%s: read", log_prefix);
+	if (n == 0)
+		FAIL("%s: incomplete read", log_prefix);
+
+close_cli1:
+	xclose(c1);
+close_peer1:
+	xclose(p1);
+close_cli0:
+	xclose(c0);
+close_peer0:
+	xclose(p0);
+}
+
+static void udp_skb_redir_to_connected(struct test_sockmap_listen *skel,
+					   struct bpf_map *inner_map, int family,
+					   int sotype)
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
+	udp_redir_to_connected(family, sotype, sock_map, verdict_map,
+			       REDIR_EGRESS);
+	skel->bss->test_ingress = true;
+	udp_redir_to_connected(family, sotype, sock_map, verdict_map,
+			       REDIR_INGRESS);
+
+	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
+}
+
+static void test_udp_redir(struct test_sockmap_listen *skel, struct bpf_map *map,
+			   int family)
+{
+	const char *family_name, *map_name;
+	char s[MAX_TEST_NAME];
+
+	family_name = family_str(family);
+	map_name = map_type_str(map);
+	snprintf(s, sizeof(s), "%s %s %s", map_name, family_name, __func__);
+	if (!test__start_subtest(s))
+		return;
+	udp_skb_redir_to_connected(skel, map, family, SOCK_DGRAM);
+}
+
+static void unix_redir_to_connected(int sotype, int sock_mapfd,
+			       int verd_mapfd, enum redir_mode mode)
+{
+	const char *log_prefix = redir_mode_str(mode);
+	int c0, c1, p0, p1;
+	unsigned int pass;
+	int err, n;
+	int sfd[2];
+	u64 value;
+	u32 key;
+	char b;
+
+	zero_verdict_count(verd_mapfd);
+
+	if (socketpair(AF_UNIX, sotype | SOCK_NONBLOCK, 0, sfd))
+		return;
+	c0 = sfd[0], p0 = sfd[1];
+
+	if (socketpair(AF_UNIX, sotype | SOCK_NONBLOCK, 0, sfd))
+		goto close0;
+	c1 = sfd[0], p1 = sfd[1];
+
+	key = 0;
+	value = p0;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close;
+
+	key = 1;
+	value = p1;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close;
+
+	n = write(c1, "a", 1);
+	if (n < 0)
+		FAIL_ERRNO("%s: write", log_prefix);
+	if (n == 0)
+		FAIL("%s: incomplete write", log_prefix);
+	if (n < 1)
+		goto close;
+
+	key = SK_PASS;
+	err = xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
+	if (err)
+		goto close;
+	if (pass != 1)
+		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
+
+	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
+	if (n < 0)
+		FAIL_ERRNO("%s: read", log_prefix);
+	if (n == 0)
+		FAIL("%s: incomplete read", log_prefix);
+
+close:
+	xclose(c1);
+	xclose(p1);
+close0:
+	xclose(c0);
+	xclose(p0);
+}
+
+static void unix_skb_redir_to_connected(struct test_sockmap_listen *skel,
+					struct bpf_map *inner_map, int sotype)
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
+	unix_redir_to_connected(sotype, sock_map, verdict_map, REDIR_EGRESS);
+	skel->bss->test_ingress = true;
+	unix_redir_to_connected(sotype, sock_map, verdict_map, REDIR_INGRESS);
+
+	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
+}
+
+static void test_unix_redir(struct test_sockmap_listen *skel, struct bpf_map *map,
+			    int sotype)
+{
+	const char *family_name, *map_name;
+	char s[MAX_TEST_NAME];
+
+	family_name = family_str(AF_UNIX);
+	map_name = map_type_str(map);
+	snprintf(s, sizeof(s), "%s %s %s", map_name, family_name, __func__);
+	if (!test__start_subtest(s))
+		return;
+	unix_skb_redir_to_connected(skel, map, sotype);
+}
+
 static void test_reuseport(struct test_sockmap_listen *skel,
 			   struct bpf_map *map, int family, int sotype)
 {
@@ -1626,10 +1861,16 @@ void test_sockmap_listen(void)
 	skel->bss->test_sockmap = true;
 	run_tests(skel, skel->maps.sock_map, AF_INET);
 	run_tests(skel, skel->maps.sock_map, AF_INET6);
+	test_udp_redir(skel, skel->maps.sock_map, AF_INET);
+	test_udp_redir(skel, skel->maps.sock_map, AF_INET6);
+	test_unix_redir(skel, skel->maps.sock_map, SOCK_DGRAM);
 
 	skel->bss->test_sockmap = false;
 	run_tests(skel, skel->maps.sock_hash, AF_INET);
 	run_tests(skel, skel->maps.sock_hash, AF_INET6);
+	test_udp_redir(skel, skel->maps.sock_hash, AF_INET);
+	test_udp_redir(skel, skel->maps.sock_hash, AF_INET6);
+	test_unix_redir(skel, skel->maps.sock_hash, SOCK_DGRAM);
 
 	test_sockmap_listen__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_listen.c b/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
index fa221141e9c1..49537c78e34a 100644
--- a/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
@@ -29,6 +29,7 @@ struct {
 } verdict_map SEC(".maps");
 
 static volatile bool test_sockmap; /* toggled by user-space */
+static volatile bool test_ingress; /* toggled by user-space */
 
 SEC("sk_skb/stream_parser")
 int prog_stream_parser(struct __sk_buff *skb)
@@ -55,6 +56,25 @@ int prog_stream_verdict(struct __sk_buff *skb)
 	return verdict;
 }
 
+SEC("sk_skb/skb_verdict")
+int prog_skb_verdict(struct __sk_buff *skb)
+{
+	unsigned int *count;
+	__u32 zero = 0;
+	int verdict;
+
+	if (test_sockmap)
+		verdict = bpf_sk_redirect_map(skb, &sock_map, zero, test_ingress ? BPF_F_INGRESS : 0);
+	else
+		verdict = bpf_sk_redirect_hash(skb, &sock_hash, &zero, test_ingress ? BPF_F_INGRESS : 0);
+
+	count = bpf_map_lookup_elem(&verdict_map, &verdict);
+	if (count)
+		(*count)++;
+
+	return verdict;
+}
+
 SEC("sk_msg")
 int prog_msg_verdict(struct sk_msg_md *msg)
 {
-- 
2.25.1

