Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762733BAE92
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhGDTGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhGDTFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 15:05:53 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215D7C061574;
        Sun,  4 Jul 2021 12:03:17 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id u11so18315770oiv.1;
        Sun, 04 Jul 2021 12:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SUU/gKTyd7+O+GGHnsFXdAF3YUxRlBV8s9nYTd9lwRM=;
        b=uK8tjcA+v6BYz5Px/LPrna9HYP/bfpylbWonQoI9ybwn3e2TYyyk4gJBz9sFz98Gdt
         fOfH1CicBSk9X0O7FCFwEmP4nCB7NTWBIWNQidL7DP5dxuBmofK8PmksIvruXqNjFMEO
         BTtddnNPVLVuyxIy32Raq9smPOB/lC/LbwshXiILkVO5VgshWCeosShDsIG8QDbKrKmF
         1jhz49bt5hTwYXwAvbXLXQLLfUf5OCpjBVXddgFcz9cTm1vRNpQ08OC2CgptFuHd5aRQ
         Xx9ZHbALDUUGu4Ag/fBRKeERxDy2X+mk6P0LxTk42BDnb194UKIHb4m/3ZSwk/XXZyIq
         PF5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SUU/gKTyd7+O+GGHnsFXdAF3YUxRlBV8s9nYTd9lwRM=;
        b=B9qqhRk6ucu29yqhPrsEgN5lkyr83bHp095f1kUkBSr4FXHP70A2B6CGCXjcxsBRcx
         b7XGHGas4XhJdZBLmRoD0+LcZ7u9mHbN1S7hd+Qa9jR9cuhq7LTpGLdQmegRQ+3KoZ2e
         DkRHWzm7DBLZROcdxozg4JiqUwJtlDfNxmolI12FQkWxtw31MtI2Toi+1U4dzK/9iKpE
         JTJXf9Y+OqdV8IVEULUiL12lFEA7INJ64/DMYq9YoCKJ6BEyIVBvjJsUNJ2jxZBdSmUE
         ci8BisYkSThzxlr3/zK/vP2BRxRrkHnUlWboU3tr2N2/+ZxZbpkyTqBXu9kVr97aUAxV
         mI+g==
X-Gm-Message-State: AOAM530yY1f69D0IoZLX8OY+P59B/wV6sJcuVgXJJnHYEIADypFAa7ev
        J41jqAqfh8UEw+Eqn3oBp5FGblLTiaM=
X-Google-Smtp-Source: ABdhPJzEP9CzvoFSkgq2GYVfYJBF3KrBmwaKwOxC6tWgEmFUP51MYXBn7huJsp9AzGx1Tj5YZs5YWA==
X-Received: by 2002:a05:6808:1309:: with SMTP id y9mr7617101oiv.112.1625425396412;
        Sun, 04 Jul 2021 12:03:16 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id 186sm1865848ooe.28.2021.07.04.12.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 12:03:16 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v5 10/11] selftests/bpf: add a test case for unix sockmap
Date:   Sun,  4 Jul 2021 12:02:51 -0700
Message-Id: <20210704190252.11866-11-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Add a test case to ensure redirection between two AF_UNIX
datagram sockets work.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 97 +++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index a023a824af78..b6464be89f1a 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1435,6 +1435,8 @@ static const char *family_str(sa_family_t family)
 		return "IPv4";
 	case AF_INET6:
 		return "IPv6";
+	case AF_UNIX:
+		return "Unix";
 	default:
 		return "unknown";
 	}
@@ -1557,6 +1559,99 @@ static void test_redir(struct test_sockmap_listen *skel, struct bpf_map *map,
 	}
 }
 
+static void unix_redir_to_connected(int sotype, int sock_mapfd,
+			       int verd_mapfd, enum redir_mode mode)
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
+	if (socketpair(AF_UNIX, sotype | SOCK_NONBLOCK, 0, sfd))
+		return;
+	c0 = sfd[0], p0 = sfd[1];
+
+	if (socketpair(AF_UNIX, sotype | SOCK_NONBLOCK, 0, sfd))
+		goto close0;
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
@@ -1754,10 +1849,12 @@ void test_sockmap_listen(void)
 	skel->bss->test_sockmap = true;
 	run_tests(skel, skel->maps.sock_map, AF_INET);
 	run_tests(skel, skel->maps.sock_map, AF_INET6);
+	test_unix_redir(skel, skel->maps.sock_map, SOCK_DGRAM);
 
 	skel->bss->test_sockmap = false;
 	run_tests(skel, skel->maps.sock_hash, AF_INET);
 	run_tests(skel, skel->maps.sock_hash, AF_INET6);
+	test_unix_redir(skel, skel->maps.sock_hash, SOCK_DGRAM);
 
 	test_sockmap_listen__destroy(skel);
 }
-- 
2.27.0

