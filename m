Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC25D36AADB
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhDZCvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbhDZCvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:51:07 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA39C061761;
        Sun, 25 Apr 2021 19:50:26 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id 8so21507548qkv.8;
        Sun, 25 Apr 2021 19:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GwgRYiRyslo628iscBvsP7av/19EwrhlvyUG9PJn1s0=;
        b=J2LzrXgMlx4zBH1RzvBV6CejWskknV9ns40Pnxg9ir8UU2LYoLubsgKT2e2ZqFtrhJ
         eq01rxaiEtHtNPR4kF2ok8rrdKE9pN7e/A+5JTs7sJXBpoSxZW1I5FamSXMEkqbO0om2
         J7pj3kfB2a0H9gaBzuRUoCSsZ02SZ431jRWlanDmLjPypkrALXzJ447B2FuVyqpRinNq
         cwHUCAYNVZNZbjWl15lFvkSx4TqJj0UmKnZkBJAGbyRE0c7aOVxuy1gtdP7L6eh+uIaI
         dseAdf968/X1a9RvFV0pt4BuepqM/QiVglHdgbpACyyKiScv1IZcQPxV+0x4B8SX0sm5
         Rzhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GwgRYiRyslo628iscBvsP7av/19EwrhlvyUG9PJn1s0=;
        b=RHOLu/Qvxf3lHdFaTglSVIRDnvScsAI6U5MzaD4S+YoWUmvLYkDn5Z2FGBLxVF2/vI
         Hi0rzMWMs0izVqQOv0IOYqDnqFCnTiUkfFo7j6Q+tUthkb6C1leZZ00Ce8/bZmFpHR0v
         qPofcxjUHgD3cqCy0P6t6dPwjB3+FpAS50oJjIfGMt5uQ7rZoKf5eT9/CWAQQ7eOn6nM
         CtJHO1xKsaNvvkXVUpJjduxgDFsw2S80BihJKBZz1Gg+ttkW2olU8pdPyfoIKvkh/ltz
         HOqtJCSwOEoh+NM7mCpgKTXbOPxvzRzs+5d0tDxSi41L/rK/OhAPRdE5DtDic8jJoL0Q
         G34g==
X-Gm-Message-State: AOAM533w4kXHA0xVal77ysNdHSjN5GZ5hqruFv4ZhsrCcfdUM/Yv3lVG
        seqn59qI0VajjiZNQYXKYH68WfvnQFg9Hw==
X-Google-Smtp-Source: ABdhPJzI8gNdFrtz7xLlNRhZe/gkVXOgDrTi36tKoxswbiLMzkHPqRwGACHxz5Q5/eYHndW4TXeKaw==
X-Received: by 2002:a05:620a:7d4:: with SMTP id 20mr15126539qkb.58.1619405425930;
        Sun, 25 Apr 2021 19:50:25 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:9050:63f8:875d:8edf])
        by smtp.gmail.com with ESMTPSA id e15sm9632969qkm.129.2021.04.25.19.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 19:50:25 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 10/10] selftests/bpf: add test cases for redirection between udp and unix
Date:   Sun, 25 Apr 2021 19:50:01 -0700
Message-Id: <20210426025001.7899-11-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
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

