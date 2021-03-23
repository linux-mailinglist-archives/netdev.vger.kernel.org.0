Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B82E34540A
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhCWAjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbhCWAif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 20:38:35 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36B2C061574;
        Mon, 22 Mar 2021 17:38:34 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id s2so13804827qtx.10;
        Mon, 22 Mar 2021 17:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g3nptvPrG/Rja0vDg1eqjKadpsNbfe6SjFJEHfl1sz0=;
        b=hrNum4QvL3LamXWq9P4plZ53fQ3WQRfknjOtzqq1IhGP743lYsIihPZ0tga1D/KVbX
         +sLccEWajK/7rMy3pLgA49qWcfUfY8a2jo1jTe+LmD2mvSgnHo6nPUlfTSMZYd5oxdzm
         Y6HnAAibmwWSFGQ1NNolZxRiKYzmjqIIhl4tJLStj8Q4x/aVeXZKpu3qa77yU3sWOSp8
         2BtBwLqCRsWChWBYmneLZSCF6LN+0nRiT6Sb9o8FYNJGEe2WmnUWH9+EPU/++B7NW1fC
         8OgvNftY5nKzkVixPgdsHAzQfCCCYloyRGMbCryCDlrXPCAbaub9L7CXxUkoyZJx+ZfN
         H49A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g3nptvPrG/Rja0vDg1eqjKadpsNbfe6SjFJEHfl1sz0=;
        b=XXrSijfKweU1wF40Snq9uPYUz46sYn6vZhOArljb/LfkEhv1d8h88BtpF423fGP6ps
         RGaPgVkZId9LVA2tsyOBGGavImErtHgnSTLOUJjYieHpcZJhkigqpm4I/ocEUAKWZ5Pc
         JAMV6obRnC8eahznOchfgDFG/FLQnhDW227TvcA+Ohan7mhWp4yegnwR0Kg4BRPn5npW
         42udfXauI8hwnvCzts++x1L3E+26r8lNA3R/z2mXJSQNmAocPGWIIdT7mSVVuG7RnqXN
         QJthTimDRpB5Vq7SKlArHJxaqFN+6FakpNoHkGHj96a1DepCq7eQnkTKyFKY8XbBww9o
         rb/g==
X-Gm-Message-State: AOAM533pOMKSkzxtDYHRdDOcy2rR5wMV299yYLWofOib/h11pHSZH7cB
        /CWid3lxTfe51rgUtsK+svYwkVfc/CCJaw==
X-Google-Smtp-Source: ABdhPJxPf9vTbaZDie5kbxaQAkg1xL9Texd791A7afJdJVxkRgn8eVLh2YrsDHx4nHVerQChTuT4ew==
X-Received: by 2002:a05:622a:3cf:: with SMTP id k15mr2294520qtx.282.1616459913939;
        Mon, 22 Mar 2021 17:38:33 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:fda6:6522:f108:7bd8])
        by smtp.gmail.com with ESMTPSA id 184sm12356403qki.97.2021.03.22.17.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 17:38:33 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v6 12/12] selftests/bpf: add a test case for udp sockmap
Date:   Mon, 22 Mar 2021 17:38:08 -0700
Message-Id: <20210323003808.16074-13-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Add a test case to ensure redirection between two UDP sockets work.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 140 ++++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |  22 +++
 2 files changed, 162 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index c26e6bf05e49..a549ebd3b5a6 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1563,6 +1563,142 @@ static void test_redir(struct test_sockmap_listen *skel, struct bpf_map *map,
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
 static void test_reuseport(struct test_sockmap_listen *skel,
 			   struct bpf_map *map, int family, int sotype)
 {
@@ -1626,10 +1762,14 @@ void test_sockmap_listen(void)
 	skel->bss->test_sockmap = true;
 	run_tests(skel, skel->maps.sock_map, AF_INET);
 	run_tests(skel, skel->maps.sock_map, AF_INET6);
+	test_udp_redir(skel, skel->maps.sock_map, AF_INET);
+	test_udp_redir(skel, skel->maps.sock_map, AF_INET6);
 
 	skel->bss->test_sockmap = false;
 	run_tests(skel, skel->maps.sock_hash, AF_INET);
 	run_tests(skel, skel->maps.sock_hash, AF_INET6);
+	test_udp_redir(skel, skel->maps.sock_hash, AF_INET);
+	test_udp_redir(skel, skel->maps.sock_hash, AF_INET6);
 
 	test_sockmap_listen__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_listen.c b/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
index fa221141e9c1..a39eba9f5201 100644
--- a/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
@@ -29,6 +29,7 @@ struct {
 } verdict_map SEC(".maps");
 
 static volatile bool test_sockmap; /* toggled by user-space */
+static volatile bool test_ingress; /* toggled by user-space */
 
 SEC("sk_skb/stream_parser")
 int prog_stream_parser(struct __sk_buff *skb)
@@ -55,6 +56,27 @@ int prog_stream_verdict(struct __sk_buff *skb)
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
+		verdict = bpf_sk_redirect_map(skb, &sock_map, zero,
+					      test_ingress ? BPF_F_INGRESS : 0);
+	else
+		verdict = bpf_sk_redirect_hash(skb, &sock_hash, &zero,
+					       test_ingress ? BPF_F_INGRESS : 0);
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

