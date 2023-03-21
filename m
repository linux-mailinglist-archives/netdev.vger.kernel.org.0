Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6DB6C3D18
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCUVyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCUVwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:52:53 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53833D0AD;
        Tue, 21 Mar 2023 14:52:38 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so17297801pjt.5;
        Tue, 21 Mar 2023 14:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679435557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryxn+5k5MD1criPhX9Z+EEFH37S3XNjS5ric5THSlS8=;
        b=dHVyFEo/2DWq2+kLMcYWhJqMyaaZDJGAeePwX5ONAMEblLoCjNYvVSQXkMv669q6AI
         Zv4L0Qw0pvpJH9eRnqD+P1rkV3f5ejTygFe9u/LbXVNgkLN7QQGCIinpj8vZzOLTqtUL
         d4gkEFVgurLHfaP20amdX/bXmoy8ri6Sx0DI7P/O0LWiYCAVuXpnn7cvvCYeg6b1ZPR/
         9ojJZzHuAv/xgTCAvTaatlMmkHJSyZg9Ry0gKott+9SGB0axYqu+uwL4tDLKIYl1m1M7
         EMandROxu6sOTRGH3f6M1mkZVSaAh89cq/DZ1tmnUK6ROPwBY9qR3pBR6TUVDmUCwS4p
         ZtjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679435557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ryxn+5k5MD1criPhX9Z+EEFH37S3XNjS5ric5THSlS8=;
        b=c6dTs8l44RYq9oUzVLMMTpdBsjLHKRWuHgYCg/IpA7NCnejxFwhi7PSVHOo8c/H+kk
         c16O6wROrFHELhdDKBOfnTyCY4ZdMMhHVjh/Fq0hAQbrRf+Cm/teLuC/XOwp5LKdmff5
         2XRBPzxxYYVJbJ46nAgfVC7N1cS1WEqxUusx8DBZSE4WJaShaND0XPK88zV+4iWTmZae
         jPlqfh8DJeet4hI4dgXCNOxC5Mg7uMvU2aNq160STH8KzVlbCyJ11xAiJIHWVGqqUJNy
         8ao4H2qcMcsgRACdFlnhYpIfmr8wsGVRar37t+SfOQ2aIS+77uMj8u0yAJiMwaWXXfLl
         mAIw==
X-Gm-Message-State: AO0yUKUIJX5DfQ3giuQKWXyFUoxq3xokd85ypBFpIrwNPzjIYiRGNgr1
        Z3dhDM+EOlnQYTEigv2Npec=
X-Google-Smtp-Source: AK7set86hnr0tSI2zIGyZtp8UiGA+CMlm35cQ2akSabsiI+Cxpij++FQDC/+eIvUw1znXeFNnup5Xg==
X-Received: by 2002:a05:6a20:c29c:b0:da:368e:7c73 with SMTP id bs28-20020a056a20c29c00b000da368e7c73mr3185014pzb.37.1679435557681;
        Tue, 21 Mar 2023 14:52:37 -0700 (PDT)
Received: from john.lan ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id m3-20020a63fd43000000b004facdf070d6sm8661331pgj.39.2023.03.21.14.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 14:52:37 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        cong.wang@bytedance.com
Cc:     bpf@vger.kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: [PATCH bpf 11/11] bpf: sockmap, test FIONREAD returns correct bytes in rx buffer
Date:   Tue, 21 Mar 2023 14:52:12 -0700
Message-Id: <20230321215212.525630-12-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230321215212.525630-1-john.fastabend@gmail.com>
References: <20230321215212.525630-1-john.fastabend@gmail.com>
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
index 38a22c71b8dd..b092355a8833 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -413,6 +413,52 @@ static void test_sockmap_skb_verdict_shutdown(void)
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
@@ -449,4 +495,6 @@ void test_sockmap_basic(void)
 		test_sockmap_progs_query(BPF_SK_SKB_VERDICT);
 	if (test__start_subtest("sockmap skb_verdict shutdown"))
 		test_sockmap_skb_verdict_shutdown();
+	if (test__start_subtest("sockmap skb_verdict fionread"))
+		test_sockmap_skb_verdict_fionread();
 }
-- 
2.33.0

