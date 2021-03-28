Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E73034BEDC
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhC1UU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhC1UUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:20:34 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8B1C061756;
        Sun, 28 Mar 2021 13:20:34 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so10361871oto.2;
        Sun, 28 Mar 2021 13:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gOC5unRxfv/K/WT+PzYY09V5EeMjRcHWr4Ygtd7dIvU=;
        b=JD1MEpFxsd38kLfDbU8C0ORD1oEkoE67u2ScKI/bhC3oBaZZFzT29Ug4wAonoXauuv
         LkAyuJ/doxb9RE52E4qwINZmQbMWvvlcFvY/YcVdeEegvihDgaVlE1TFJ6mSAUDkVQ9V
         xac6qHSDD+c4zkPM1EGVJVsBMr6MTy/comNvmmIQmvULwLzBg9u2qWx3Jor0uzGDcAWo
         7V0nhp0PjakD2NsMEpoDC3zYCOJnodStzFowDxGCOE7G0q/6Z1/pB0tlEUAdMZKC1hUC
         cxp5UQ2LKAPPgV41A+hCsoL+JFo4qbuQiv4pvurK7PuhZOVVkmtHzHPfh5Z9AjoQo6nf
         5xAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gOC5unRxfv/K/WT+PzYY09V5EeMjRcHWr4Ygtd7dIvU=;
        b=QRYv4t1+UHIMEVj+Ipyd1acGGDjCPk9jcNKBJFXUytiKCltuFsjfaEB6i3Sre5JZwa
         7691mRaKkS+J09jq4SDE8HcmmkZ25cF7Yr/4mOIZ/O7B2lG175wMVtRGYi4Muz96JAD0
         OlrDYaZQumVbR38U2gG4lGfY+b4my2v33UgObffJLqXpTvlLIpqOxjZV84/kqLgqcESy
         S5ev8kHqtq9xEB9mmXcJP6wMT0S0WsxVh6wQUMs3N08lEEvVlvZ1AG9RD8jkZO35anSh
         b1Aps78v7JpkxY1Sk8qUdbX9S/1eKryVD/qYosfuhIk1rBt7I6f0MDzlGmPXhRCaN++3
         Ye0A==
X-Gm-Message-State: AOAM533AJhvRvVrINpeK2iPA6KstAk7poYjxoOvStYwn2gTLMWm0j2oV
        iwhS5M2nH+M5MpkMFeOZ0TDsMrBLafZwMw==
X-Google-Smtp-Source: ABdhPJxjTiD3duCgNEjlRNZYyWr09XGiPGMjXNuTkY7BNOVUbZhegqjGAfZ3aV9dEtw/9/BdbwPalw==
X-Received: by 2002:a9d:6959:: with SMTP id p25mr20235697oto.154.1616962833948;
        Sun, 28 Mar 2021 13:20:33 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:bca7:4b69:be8f:21bb])
        by smtp.gmail.com with ESMTPSA id v30sm3898240otb.23.2021.03.28.13.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 13:20:33 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v7 13/13] selftests/bpf: add a test case for udp sockmap
Date:   Sun, 28 Mar 2021 13:20:13 -0700
Message-Id: <20210328202013.29223-14-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
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
 .../selftests/bpf/prog_tests/sockmap_listen.c | 136 ++++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |  22 +++
 2 files changed, 158 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index c26e6bf05e49..648d9ae898d2 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1603,6 +1603,141 @@ static void test_reuseport(struct test_sockmap_listen *skel,
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
+				       struct bpf_map *inner_map, int family)
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
+	udp_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
+			       REDIR_EGRESS);
+	skel->bss->test_ingress = true;
+	udp_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
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
+	udp_skb_redir_to_connected(skel, map, family);
+}
+
 static void run_tests(struct test_sockmap_listen *skel, struct bpf_map *map,
 		      int family)
 {
@@ -1611,6 +1746,7 @@ static void run_tests(struct test_sockmap_listen *skel, struct bpf_map *map,
 	test_redir(skel, map, family, SOCK_STREAM);
 	test_reuseport(skel, map, family, SOCK_STREAM);
 	test_reuseport(skel, map, family, SOCK_DGRAM);
+	test_udp_redir(skel, map, family);
 }
 
 void test_sockmap_listen(void)
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

