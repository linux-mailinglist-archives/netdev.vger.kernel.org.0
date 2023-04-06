Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B186D8C5C
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbjDFBBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234598AbjDFBBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:01:18 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55847DA0;
        Wed,  5 Apr 2023 18:00:55 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j14-20020a17090a7e8e00b002448c0a8813so585877pjl.0;
        Wed, 05 Apr 2023 18:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680742855; x=1683334855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I/e44MTh7M407OJ1hC7xQsEWYl13ekNij3tNSRQR2hY=;
        b=Rso3+k445QUTHSANEySLZR+OC66w2K1sHYmRZ4GthKilvYJQlNsTdgot/a8RXJuB9W
         Sr2Kcsmu+eS02XXk5gSzocZIIDjvz3LraoMXDH3nm9Zb1aZcELqOtyJWvp4LziKnH4Hc
         fACS8O3F7VwXZLOf3VHwDFuv6cZQgn2bglHGTTc4eVOmEpzkdfNyWW6aj8lZzDz6RNIT
         GdpRYWjzi7f9xM8dKX4Wx6VsY0yxGgPW3FOk2tnX8itxqiJs6fKdVcG9gxjzbUW+dPrT
         FzmYCb5ooRIp9WmGP0Na06fjoEZvKpD7/NKoIUUXMXHrvsD6GgjSpeAPVz+L+3OrANYy
         xklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680742855; x=1683334855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I/e44MTh7M407OJ1hC7xQsEWYl13ekNij3tNSRQR2hY=;
        b=NE0Elkg8WgzK3jH5QQimzHTXGTrOLSMZCmYT4aC/jVAVY6JaV8FGL1c4wiqnNGg6tL
         Mx6+XX9AgGV1IdJYs99BlH0z8YnHylpA4/YoObxpa2+ZdYu+QDCVGvsTScOJQu2VZnSI
         lI8s18rzUKY2Wawxklb6Jd0lCtMOFfIWalJxRZ0+2TLC7nmdz7a/YX40j7+VzZMH4XJ4
         DS+SwgyW6vLWFAN0sG6wHobFV8dxi+oeJdOuxNk7SOj+DvAQCUgwMvKxU1m2tV7UeGyd
         FLVEjMm7gu/7fG7lj9P5aTGohVmiuG1bRhKusYur6KLIKtLXkLUzCchIjBKaP/I2+saf
         mXOw==
X-Gm-Message-State: AAQBX9dATZDXQibsmIukkQmtvdB9FA3RCmkXGb/wQ0bEWyr9YSbsLkxu
        8lKXyAlHcdzy0cQjPHI/dYA=
X-Google-Smtp-Source: AKy350aT55GunTpFhicAChLYS7ZTb9pQ6rD1qanBTZTHXWAkFUcYzUZ1m9k7JSAR1R1AMaWqzHCdAA==
X-Received: by 2002:a05:6a20:6c91:b0:dd:f44a:2717 with SMTP id em17-20020a056a206c9100b000ddf44a2717mr1006733pzb.8.1680742855401;
        Wed, 05 Apr 2023 18:00:55 -0700 (PDT)
Received: from john.lan ([98.97.117.85])
        by smtp.gmail.com with ESMTPSA id c14-20020aa78c0e000000b0062c0c3da6b8sm35377pfd.13.2023.04.05.18.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 18:00:54 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v5 11/12] bpf: sockmap, test FIONREAD returns correct bytes in rx buffer
Date:   Wed,  5 Apr 2023 18:00:30 -0700
Message-Id: <20230406010031.3354-12-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230406010031.3354-1-john.fastabend@gmail.com>
References: <20230406010031.3354-1-john.fastabend@gmail.com>
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

