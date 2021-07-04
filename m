Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A273BAE93
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhGDTGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhGDTFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 15:05:54 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C840C061574;
        Sun,  4 Jul 2021 12:03:18 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id o23-20020a4a2c170000b029025469ad0e4aso827006ooo.0;
        Sun, 04 Jul 2021 12:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hsNWW59Zj9o7HbYXqSyI4xDiojOuK6TebQsfkzRvP6c=;
        b=frbPX3LEOC5QxEOLq9zEuHh93DzBxLohkP1frj9SmgW7SKXw8UfqvILaDGJi5nYIeV
         9dqubTH12jaRm91gpaszZmLC0CWjdnmN1sd+2Ol9f55wNt054JTMK//Ye5kiz8IdI91m
         RuUixvjELOuTHnjv4IpMeE73bZ4t1byt2Fc38QJ4naC7DxCsLhFDC4LMsXlOYvVvGEzz
         UTIqhauiF7crvD8lxVS8fjp/lLrOOY65d9BU5B3fHBIxY+2/vgQZgEw4E63bsc/8oORB
         yOg6RYGGyNNqwlCjEohyyBUWLYEZsR2m5mNfIFUWtP3JNfoS4btfvZQHqE1TJj4QJ9/w
         J65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hsNWW59Zj9o7HbYXqSyI4xDiojOuK6TebQsfkzRvP6c=;
        b=Wl4YUUua9kEqNb9kx9TBq5k5WgKf+KaQf6jh4TU0iK6MxPMQY9wZuVlnVU8qioTY2W
         u0pPQU4my4AABpI30xky9BYhrhqYS6lcNzFAs4qeBpIudcpPQfU3lrFTvdDnJaHijQ/N
         dov867RRkYrUOznUUEiEibgGv+VzpGYAk3N9MsYVg/JeQzK6YrIIY1Z00dgZRXzpmjjI
         R4BQPxBR3Lcvu4Bh2OeIKyb2Pl50EE/sQin7v1k+6fCLyaHYiz/QtP8CtYEehLCd9rGE
         3sOleRIEuop+2OtdQ88kNQCoHvAswAylHVP51B+tW7I2OazQZXHyzbEs27fZhdnka0XJ
         O4Gw==
X-Gm-Message-State: AOAM533tM0jQKA2Fi36FGCkgh/oNP88+UFVk8JN9JbKPxuDF1BxpqN3H
        uPFy2PoeB71enO84QvcOjIjYo3RFb7E=
X-Google-Smtp-Source: ABdhPJxJggu48XSvJYUZc96tLnldFrwkTwem0ESdZsKRWogQnrH36z1mTcPq10OSzIBRp0lGdFPoNg==
X-Received: by 2002:a4a:956f:: with SMTP id n44mr7715593ooi.54.1625425397492;
        Sun, 04 Jul 2021 12:03:17 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id 186sm1865848ooe.28.2021.07.04.12.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 12:03:17 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v5 11/11] selftests/bpf: add test cases for redirection between udp and unix
Date:   Sun,  4 Jul 2021 12:02:52 -0700
Message-Id: <20210704190252.11866-12-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Add two test cases to ensure redirection between udp and unix
work bidirectionally.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 170 ++++++++++++++++++
 1 file changed, 170 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index b6464be89f1a..a9f1bf9d5dff 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1825,6 +1825,175 @@ static void test_udp_redir(struct test_sockmap_listen *skel, struct bpf_map *map
 	udp_skb_redir_to_connected(skel, map, family);
 }
 
+static void udp_unix_redir_to_connected(int family, int sock_mapfd,
+					int verd_mapfd, enum redir_mode mode)
+{
+	const char *log_prefix = redir_mode_str(mode);
+	int c0, c1, p0, p1;
+	unsigned int pass;
+	int retries = 100;
+	int err, n;
+	int sfd[2];
+	u32 key;
+	char b;
+
+	zero_verdict_count(verd_mapfd);
+
+	if (socketpair(AF_UNIX, SOCK_DGRAM | SOCK_NONBLOCK, 0, sfd))
+		return;
+	c0 = sfd[0], p0 = sfd[1];
+
+	err = udp_socketpair(family, &p1, &c1);
+	if (err)
+		goto close;
+
+	err = add_to_sockmap(sock_mapfd, p0, p1);
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
+again:
+	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
+	if (n < 0) {
+		if (errno == EAGAIN && retries--)
+			goto again;
+		FAIL_ERRNO("%s: read", log_prefix);
+	}
+	if (n == 0)
+		FAIL("%s: incomplete read", log_prefix);
+
+close_cli1:
+	xclose(c1);
+	xclose(p1);
+close:
+	xclose(c0);
+	xclose(p0);
+}
+
+static void udp_unix_skb_redir_to_connected(struct test_sockmap_listen *skel,
+					    struct bpf_map *inner_map, int family)
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
+	udp_unix_redir_to_connected(family, sock_map, verdict_map, REDIR_EGRESS);
+	skel->bss->test_ingress = true;
+	udp_unix_redir_to_connected(family, sock_map, verdict_map, REDIR_INGRESS);
+
+	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
+}
+
+static void unix_udp_redir_to_connected(int family, int sock_mapfd,
+					int verd_mapfd, enum redir_mode mode)
+{
+	const char *log_prefix = redir_mode_str(mode);
+	int c0, c1, p0, p1;
+	unsigned int pass;
+	int err, n;
+	int sfd[2];
+	u32 key;
+	char b;
+
+	zero_verdict_count(verd_mapfd);
+
+	err = udp_socketpair(family, &p0, &c0);
+	if (err)
+		return;
+
+	if (socketpair(AF_UNIX, SOCK_DGRAM | SOCK_NONBLOCK, 0, sfd))
+		goto close_cli0;
+	c1 = sfd[0], p1 = sfd[1];
+
+	err = add_to_sockmap(sock_mapfd, p0, p1);
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
+close_cli0:
+	xclose(c0);
+	xclose(p0);
+
+}
+
+static void unix_udp_skb_redir_to_connected(struct test_sockmap_listen *skel,
+					    struct bpf_map *inner_map, int family)
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
+	unix_udp_redir_to_connected(family, sock_map, verdict_map, REDIR_EGRESS);
+	skel->bss->test_ingress = true;
+	unix_udp_redir_to_connected(family, sock_map, verdict_map, REDIR_INGRESS);
+
+	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
+}
+
+static void test_udp_unix_redir(struct test_sockmap_listen *skel, struct bpf_map *map,
+				int family)
+{
+	const char *family_name, *map_name;
+	char s[MAX_TEST_NAME];
+
+	family_name = family_str(family);
+	map_name = map_type_str(map);
+	snprintf(s, sizeof(s), "%s %s %s", map_name, family_name, __func__);
+	if (!test__start_subtest(s))
+		return;
+	udp_unix_skb_redir_to_connected(skel, map, family);
+	unix_udp_skb_redir_to_connected(skel, map, family);
+}
+
 static void run_tests(struct test_sockmap_listen *skel, struct bpf_map *map,
 		      int family)
 {
@@ -1834,6 +2003,7 @@ static void run_tests(struct test_sockmap_listen *skel, struct bpf_map *map,
 	test_reuseport(skel, map, family, SOCK_STREAM);
 	test_reuseport(skel, map, family, SOCK_DGRAM);
 	test_udp_redir(skel, map, family);
+	test_udp_unix_redir(skel, map, family);
 }
 
 void test_sockmap_listen(void)
-- 
2.27.0

