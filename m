Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D966DB172
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjDGRR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjDGRRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:17:32 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3A2C670;
        Fri,  7 Apr 2023 10:17:17 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id w4so40467714plg.9;
        Fri, 07 Apr 2023 10:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680887836; x=1683479836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I/e44MTh7M407OJ1hC7xQsEWYl13ekNij3tNSRQR2hY=;
        b=oCzjtfJaQzrDfCEiBA4aQsRhMWDamBJxXbiVrl67kuNg82pUOInYunuVPCDiMGTMLl
         5HnM9E7RaXlgCi2kuqBjjy6R8+tVnugR3PM7ADnbIAZjG3Z+EOt/+tHbuJiPdnH4l7To
         qdtLsty1zwvhUQ+8FULhET7dUJtCJAVfAc41UK1SvxHyjpMHbh6hSnEZUdONZA7U6Q+L
         Og4J6eQxHXYXUMcxUxhB8UbHQKqI4az5sg9IF2dWaWBedx4UhAhKMPwdd5zAmhA31T+3
         023BCDXcn8ld7pi4xtufEQnkszaK0LUlWFlasW8K/XVtwzGC9o2zhWm2GRYseMGxcStQ
         w/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680887836; x=1683479836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I/e44MTh7M407OJ1hC7xQsEWYl13ekNij3tNSRQR2hY=;
        b=WDNXnVGZcI4QsUKc+uOYRQufmfUFxjGY/3TLqY9AM3/uJXxaVP6MHa5WoAtVDCFBkJ
         UeN697RuOgwzyprZoOImZgf64T7Sg42xvvcwuTOU9IO4bRCYYevUeetzXik1121Bnwwl
         tnZJbvNcvRzjww/xu5zHxlHz/WFQZUP1o8F7KntgfbRu6rMJ3+pLu2RLWCQeCAKKbA08
         8xhloOm+eyALQjDPxfcKuYMMPM4lyGmgzJd4Cl38TtZwg5M8sQcu9QOOtDQFW+ETr6BX
         /8VPvZA4JJn7wlQtRvZvMM4Xh2A+EZWMcAZzP5GnsFTM0EJ2L2nSiN9HfylTBhl3a7Bl
         2DxQ==
X-Gm-Message-State: AAQBX9cf5mEIF88xl6rp+bZDapp4mtxtHLu8mdTWvCD89x112Qk5mKoe
        lGYWbGeiV+EZChmE2HDPI18=
X-Google-Smtp-Source: AKy350a3Epup/AhXQ/gL92DanbrczxzXAfLw6BiPaWDJX+8TLRdoNMYXaieoxQGVfHNrkeLKE58iYg==
X-Received: by 2002:a17:902:c7d1:b0:1a5:deb:a339 with SMTP id r17-20020a170902c7d100b001a50deba339mr2774664pla.6.1680887836721;
        Fri, 07 Apr 2023 10:17:16 -0700 (PDT)
Received: from john.lan ([98.97.116.126])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709028a8100b0019b0937003esm3185425plo.150.2023.04.07.10.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 10:17:16 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v6 11/12] bpf: sockmap, test FIONREAD returns correct bytes in rx buffer
Date:   Fri,  7 Apr 2023 10:16:53 -0700
Message-Id: <20230407171654.107311-12-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230407171654.107311-1-john.fastabend@gmail.com>
References: <20230407171654.107311-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bug was reported where ioctl(FIONREAD) returned zero even though the
socket with a SK_SKB verdict program attached had bytes in the msg
queue. The result is programs may hang or more likely try to recover,
but use suboptimal buffer sizes.

Add a test to check that ioctl(FIONREAD) returns the correct number of
bytes.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 48 +++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index f9f611618e45..322b5a135740 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -416,6 +416,52 @@ static void test_sockmap_skb_verdict_shutdown(void)
 	test_sockmap_pass_prog__destroy(skel);
 }
 
+static void test_sockmap_skb_verdict_fionread(void)
+{
+	int err, map, verdict, s, c0, c1, p0, p1;
+	struct test_sockmap_pass_prog *skel;
+	int zero = 0, sent, recvd, avail;
+	char buf[256] = "0123456789";
+
+	skel = test_sockmap_pass_prog__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
+	map = bpf_map__fd(skel->maps.sock_map_rx);
+
+	err = bpf_prog_attach(verdict, map, BPF_SK_SKB_STREAM_VERDICT, 0);
+	if (!ASSERT_OK(err, "bpf_prog_attach"))
+		goto out;
+
+	s = socket_loopback(AF_INET, SOCK_STREAM);
+	if (!ASSERT_GT(s, -1, "socket_loopback(s)"))
+		goto out;
+	err = create_socket_pairs(s, AF_INET, SOCK_STREAM, &c0, &c1, &p0, &p1);
+	if (!ASSERT_OK(err, "create_socket_pairs(s)"))
+		goto out;
+
+	err = bpf_map_update_elem(map, &zero, &c1, BPF_NOEXIST);
+	if (!ASSERT_OK(err, "bpf_map_update_elem(c1)"))
+		goto out_close;
+
+	sent = xsend(p1, &buf, sizeof(buf), 0);
+	ASSERT_EQ(sent, sizeof(buf), "xsend(p0)");
+	err = ioctl(c1, FIONREAD, &avail);
+	ASSERT_OK(err, "ioctl(FIONREAD) error");
+	ASSERT_EQ(avail, sizeof(buf), "ioctl(FIONREAD)");
+	recvd = recv_timeout(c1, &buf, sizeof(buf), SOCK_NONBLOCK, IO_TIMEOUT_SEC);
+	ASSERT_EQ(recvd, sizeof(buf), "recv_timeout(c0)");
+
+out_close:
+	close(c0);
+	close(p0);
+	close(c1);
+	close(p1);
+out:
+	test_sockmap_pass_prog__destroy(skel);
+}
+
 void test_sockmap_basic(void)
 {
 	if (test__start_subtest("sockmap create_update_free"))
@@ -452,4 +498,6 @@ void test_sockmap_basic(void)
 		test_sockmap_progs_query(BPF_SK_SKB_VERDICT);
 	if (test__start_subtest("sockmap skb_verdict shutdown"))
 		test_sockmap_skb_verdict_shutdown();
+	if (test__start_subtest("sockmap skb_verdict fionread"))
+		test_sockmap_skb_verdict_fionread();
 }
-- 
2.33.0

