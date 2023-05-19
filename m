Return-Path: <netdev+bounces-3810-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D7AA708EAD
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 06:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3B7A1C20A56
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 04:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56CDE64B;
	Fri, 19 May 2023 04:07:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490BF566C;
	Fri, 19 May 2023 04:07:23 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC6A10CF;
	Thu, 18 May 2023 21:07:22 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64d341bdedcso104187b3a.3;
        Thu, 18 May 2023 21:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684469241; x=1687061241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJKVFV10Wskzd6UgwZOel3wsQif2pwvMqBZ8BBnsjqM=;
        b=WsvyN66+TfkgaltRV9Ur7u1FMNeVA3UucwZUt1duuRt7KY5imZpzsD36LP7bWVM8f0
         yxTIAnzxy91OPvSMPCUiVnMNWNXVT+ELR9PXeJGZIPnwGQXZPLSrmFGJLPgnFuJ4eI5U
         X5pow9ZpAIpzwePM47cwMHzMpkGY6ZSyMZz/Q7KMoXwWBMgcOpnxt33kCQwYOzlhYaN9
         xozx6aGuh6YLWL1PQk/33ApCe8+nkEd+q1MvTYQqWSej/g7dZUt5SOW04sZ1E2Q4GmF3
         n6zLG7sGIEDEoOB4Cl34z84vnMq2KWXCRGvhOBMG+EdhsujG7A2cFZJzRny9GiIBNXWd
         epGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684469241; x=1687061241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BJKVFV10Wskzd6UgwZOel3wsQif2pwvMqBZ8BBnsjqM=;
        b=cB5LT7i6TEeHNhheYL96GEr5yT0FE5mGBjIAB0U6AZcVOyaqXzgcvFXhzDrE6P5z2t
         rzKHvk9v9tsG4RLbE/ey02vFxKxaGPG8dahyyJHfJCOq2vpPPktKs2UF9LUwz/2SQzRi
         WdcxfmoQDc+kVNQd7yjpdLZHIn/j1RTJ06mf5o22vd17Mr1rsNkBTPqzRQqHjpv3/A66
         e0LNhz8x7Ent5dO4xZ0JJWfGnwlvEuVKWdcD697X4IhuxNCV0feNvttC6fIxg6swCUaN
         98f762TE5Yyce+m/uJneqjnJvCUJxYiQntGyoqzA3QJmxIMPYAoC6brq4ZDy8Y2m7PbG
         42yA==
X-Gm-Message-State: AC+VfDyO4W7m3hX5zJBjhIoJkQrcMhg/zlFyb/kDPb2GW+x5rjvBpJBA
	tR+/u3oMfpMeCS23HYeDfOw=
X-Google-Smtp-Source: ACHHUZ7oB02emgalktNEIyQrUQ3/9Ry0232PUFXb8GKGQ/Q9jd7rl0nEqoF+1/dXvMWVoKYfvGzojQ==
X-Received: by 2002:a05:6a00:c96:b0:64a:ff32:7347 with SMTP id a22-20020a056a000c9600b0064aff327347mr1661519pfv.13.1684469241544;
        Thu, 18 May 2023 21:07:21 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:706:628a:e6ce:c8a9])
        by smtp.gmail.com with ESMTPSA id x11-20020aa784cb000000b00625d84a0194sm434833pfn.107.2023.05.18.21.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 21:07:21 -0700 (PDT)
From: John Fastabend <john.fastabend@gmail.com>
To: jakub@cloudflare.com,
	daniel@iogearbox.net
Cc: john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	ast@kernel.org,
	andrii@kernel.org,
	will@isovalent.com
Subject: [PATCH bpf v9 12/14] bpf: sockmap, test FIONREAD returns correct bytes in rx buffer
Date: Thu, 18 May 2023 21:06:57 -0700
Message-Id: <20230519040659.670644-13-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230519040659.670644-1-john.fastabend@gmail.com>
References: <20230519040659.670644-1-john.fastabend@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A bug was reported where ioctl(FIONREAD) returned zero even though the
socket with a SK_SKB verdict program attached had bytes in the msg
queue. The result is programs may hang or more likely try to recover,
but use suboptimal buffer sizes.

Add a test to check that ioctl(FIONREAD) returns the correct number of
bytes.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 48 +++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 615a8164c8f0..fe56049f6568 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -410,6 +410,52 @@ static void test_sockmap_skb_verdict_shutdown(void)
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
@@ -446,4 +492,6 @@ void test_sockmap_basic(void)
 		test_sockmap_progs_query(BPF_SK_SKB_VERDICT);
 	if (test__start_subtest("sockmap skb_verdict shutdown"))
 		test_sockmap_skb_verdict_shutdown();
+	if (test__start_subtest("sockmap skb_verdict fionread"))
+		test_sockmap_skb_verdict_fionread();
 }
-- 
2.33.0


