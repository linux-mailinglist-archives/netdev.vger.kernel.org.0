Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0057732A317
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381823AbhCBIqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444166AbhCBCj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:39:57 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18FEC0617AB;
        Mon,  1 Mar 2021 18:38:06 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id x62so6193490oix.5;
        Mon, 01 Mar 2021 18:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g3nptvPrG/Rja0vDg1eqjKadpsNbfe6SjFJEHfl1sz0=;
        b=pl7tpEzuYgw7xAUS2PXljzawtnR88XWzXZTy+ZPdEhS5ZMdNNsLcpyiSgeVD9qQ6Qz
         jSSGiUghjGhQUQY/OsTt/bFkjczkum43iYvveJxVE5svkHO9XR5lYRWlepFKkEXJ69Ix
         91+PELGmSjSiDRwJlq0X+VB3/15PMgiEUq/TruDnEbPyDDpKMJuSeHtiOMWuMU+Ciqgh
         xR8SC4emtX97RzHmVVKL41Jo+48k4c7Yfhd9ZUQKdtJI+lZ0Qp40moNvV4bqVaps9YOB
         K6g8hZIWXm4RCt/GzezN927EFOoYIX0vJf1fuFmB7WUtVWCaO2IoHUeJaa2YxSM3Ccwy
         dsaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g3nptvPrG/Rja0vDg1eqjKadpsNbfe6SjFJEHfl1sz0=;
        b=uHz4p1aaVyntXvERodgMd5ctrjhXEeZ2jR5Ktb/Sf/bbl/fb+l95oZPttQPNruc7Vx
         YG1+BJanYGIu32BSLApC4e0cP9Y8kMyNF5thUKRForEk241hiimEfRM42u2rlB0j3xjF
         u80g1gIgmRZR1HehTmR1J0/eK51vAHZIwaHO6a5UtPrpfYK08Wjf14mrlxQ03muh9pip
         isS8Ch+4/RxkHs6PJY/9NfGQr8HH+/iJ/1D5kas2Y6wVXfKkCHX9+9g42tLCn2wOmD6S
         GJelT9WRrr+t84J+11A6+HsR1z7+Ttmok/OzgD6jct5VmK/RX5sIeqPMK9F1XACbe/E3
         6TWA==
X-Gm-Message-State: AOAM532HYxtAb2BsyjrRkFBoQfrLhxGsMURvacvwebpYbSdmAqZnlYgx
        kbBba6oSdqqRCfRcM5SXv8LoPNzFk+Uxww==
X-Google-Smtp-Source: ABdhPJw4gLXpMKB5ZZ/RrdPRQKemKnRZ2Do0c0kpdg7xE9dbJNSsR0zhMH8e6uOo0Ur1aurea4lbVA==
X-Received: by 2002:aca:a809:: with SMTP id r9mr1626335oie.163.1614652686127;
        Mon, 01 Mar 2021 18:38:06 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1bb:8d29:39ef:5fe5])
        by smtp.gmail.com with ESMTPSA id a30sm100058oiy.42.2021.03.01.18.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:38:05 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 9/9] selftests/bpf: add a test case for udp sockmap
Date:   Mon,  1 Mar 2021 18:37:43 -0800
Message-Id: <20210302023743.24123-10-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
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

