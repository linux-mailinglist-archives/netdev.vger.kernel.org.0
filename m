Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91610377451
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhEHWKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhEHWK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:10:27 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60920C061574;
        Sat,  8 May 2021 15:09:24 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id y12so9297501qtx.11;
        Sat, 08 May 2021 15:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GwgRYiRyslo628iscBvsP7av/19EwrhlvyUG9PJn1s0=;
        b=aHdSQN18OQto2rONRzflkU0nt3yXjniMeit89QC35HdOZMYDaveiGxkeJVf5y4PsNm
         Gqk9b0mOkeDsdJlGdKJxmtCkPAzPvMn5yBA6n1SPCD390473wqjX6gE4rw4EtkmGmYHv
         j18Hmi3cSvbXNi77pvu2z06an7oVO3LNCXmYK98rQjnxMtW1FAhOxG9mfMifQL/DPXt3
         Rd9qpsMrHZ88Gt1frs/DexYo1p9bYmBUA9cxmPHZ/9rVMLirh/12xdgmRaDYkCm3ju8R
         AqyjdztDRlH9YCZ24bCeAdcHokWN5NY9uf5OvCCnyl9Ka7xBXzGlu29i/J3kIR9aKIZ4
         XqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GwgRYiRyslo628iscBvsP7av/19EwrhlvyUG9PJn1s0=;
        b=LNGVbC1dmDH5CJbegZKG2vT4KXLCEannhXjaK0X756dJZ/1yyOq69DnXIklP+4GD3X
         0oTSniSI9ZcyoS1hVpkkCw7UKA4E/nG9H1cG0EVCNqJFfcndKi03AqlzW6NV0CkQADwf
         IzN2mVz7SwpzKZ2HmE1ELJViey5n7IHoFFpkNNK6x/DO6YK7IRG8FK0y6OWC6On/e/wt
         eBG1S+dX8kRnaEDcoXXiOCl2UWzbWwVqkm9J7vBy0KxcLHju7CO6UzNwqxijDlKfaU1G
         dpAtQ6YJkgC3QpxTUNTAoeckbjrHGuMIKDnfWNn3SJHXvCj8VVItPRbIWPSEhYDrJDs0
         gb5g==
X-Gm-Message-State: AOAM531E8YBJjfb5V2L552g6DZKytkGb02oUAueo9el6H3QruSV6HoJH
        HG9KKHv+PeU4h2XJdaqe4RrJpO8/BOnlwg==
X-Google-Smtp-Source: ABdhPJyHu7/Ke34yGeuk4vMbPkkICdtNCmzKVgkQ7D4xYYqtI8GfV26neVmnqt9G2AB3qYlpfIpkCw==
X-Received: by 2002:ac8:4792:: with SMTP id k18mr15629580qtq.111.1620511763512;
        Sat, 08 May 2021 15:09:23 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id 189sm8080797qkd.51.2021.05.08.15.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:09:23 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 12/12] selftests/bpf: add test cases for redirection between udp and unix
Date:   Sat,  8 May 2021 15:08:35 -0700
Message-Id: <20210508220835.53801-13-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
References: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
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
 .../selftests/bpf/prog_tests/sockmap_listen.c | 165 ++++++++++++++++++
 1 file changed, 165 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 2b1bdb8fa48d..01c052e15a83 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1813,6 +1813,170 @@ static void test_udp_redir(struct test_sockmap_listen *skel, struct bpf_map *map
 	udp_skb_redir_to_connected(skel, map, family);
 }
 
+static void udp_unix_redir_to_connected(int family, int sock_mapfd,
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
+	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
+	if (n < 0)
+		FAIL_ERRNO("%s: read", log_prefix);
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
@@ -1822,6 +1986,7 @@ static void run_tests(struct test_sockmap_listen *skel, struct bpf_map *map,
 	test_reuseport(skel, map, family, SOCK_STREAM);
 	test_reuseport(skel, map, family, SOCK_DGRAM);
 	test_udp_redir(skel, map, family);
+	test_udp_unix_redir(skel, map, family);
 }
 
 void test_sockmap_listen(void)
-- 
2.25.1

