Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132AC36AADC
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhDZCvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbhDZCvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:51:06 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7374CC061760;
        Sun, 25 Apr 2021 19:50:25 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id q136so34285382qka.7;
        Sun, 25 Apr 2021 19:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UjK9BI5v2k7+AWEzGv15pygYECWaieRAsq8bft/a118=;
        b=AVHhP3fAlCLw/c+++DMSLdzfqIBy1SltDKqp3PAUTK+54gbVcXajpcSCMXAWfUpgg2
         fd1s6/2dgu3ZMQjPxM3etBPe6asoqrri6aHAOuymvCNu8gu27LvQImjSiN8xK0mHL/Rp
         rWaT4X7dnYeT4UBcJJLeoIawD32p9+aiXnYFrcDr4h788rZF+RJNUko5D3zAABBEzPum
         2xWATBZ9eippyt/ozmwLFbEgsfiVCt3otq63PF4Gkzq73OVxJzWbYfMdTVBpYZH3EA1B
         jijKBCWrIR75tR843nAw/B1u1faVQtX5pTu8wRs/i23FWbF1D4uD+kOyagJnKEuvaIZe
         7ivw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UjK9BI5v2k7+AWEzGv15pygYECWaieRAsq8bft/a118=;
        b=ogZ/A0h9LodxhY2c2X5HEqH+J9FCNjdKSjZKW0k5kTX6JrLjbX09+pA7aa2YfvxavO
         jT/WcOPq8ivkCjC9hBWCE0TXiZTMVRQDsb9ZpjmGOZkOg9Sn8NBlXw5uFnbYpzF7tgU2
         2uCslwPLnO/IQf4dphuQL58RFlYDRn1PzqdAyFODnzxhJJkEuA9AF6+QR1X8JpFWsA5x
         8SfwgOW2Fy3tnPJTvdPKt1YVHzVEVVM9vy4S0DhfasGs+IkYTmwlIgRmvnjNM/ApVfVU
         aatHSKBCcZbtN55qR+YVIo8TBL6nFRRnb2sQxV6SUDqAQx7Wz4f/8bXVLAsnkuxw34zc
         Zb/w==
X-Gm-Message-State: AOAM532e45GEhHf1wLDpEWVsWng6k7wdsHPyleUQ+sewM3zXKdGC5mMO
        /Po45HL48fHbQ/Ap64H7r8vQ6QInOdhGlg==
X-Google-Smtp-Source: ABdhPJzYa768AX/K1iy4vAbTfGJeG0N7YRoP/nCaxvTb3klHLAnjHRjiMnpbqKvQrishLwKDqsch2g==
X-Received: by 2002:ae9:eb56:: with SMTP id b83mr3950823qkg.350.1619405424427;
        Sun, 25 Apr 2021 19:50:24 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:9050:63f8:875d:8edf])
        by smtp.gmail.com with ESMTPSA id e15sm9632969qkm.129.2021.04.25.19.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 19:50:24 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 09/10] selftests/bpf: add a test case for unix sockmap
Date:   Sun, 25 Apr 2021 19:50:00 -0700
Message-Id: <20210426025001.7899-10-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
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
 .../selftests/bpf/prog_tests/sockmap_listen.c | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index ee017278fae4..2b1bdb8fa48d 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1433,6 +1433,8 @@ static const char *family_str(sa_family_t family)
 		return "IPv4";
 	case AF_INET6:
 		return "IPv6";
+	case AF_UNIX:
+		return "Unix";
 	default:
 		return "unknown";
 	}
@@ -1555,6 +1557,94 @@ static void test_redir(struct test_sockmap_listen *skel, struct bpf_map *map,
 	}
 }
 
+static void unix_redir_to_connected(int sotype, int sock_mapfd,
+			       int verd_mapfd, enum redir_mode mode)
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
@@ -1747,10 +1837,12 @@ void test_sockmap_listen(void)
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
2.25.1

