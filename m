Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77EAB6CAC73
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbjC0Rzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbjC0RzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:55:24 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BF44487;
        Mon, 27 Mar 2023 10:55:09 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j13so8413870pjd.1;
        Mon, 27 Mar 2023 10:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679939708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5+s10zrxZejqq5bq+XUHu3L+KgjuGIY37R9ThVwAs5g=;
        b=mO8s5pjMGSmdLjwJC6jf0vcvjqtH5tdOzNABg82WWKkD4359fNsFNPgQ5IPuMHB5eZ
         4s67PUs+qBpBHYJBTkSptMymiPl0jsZ3V3xFsBhbBAkUASZSIIGS9sOq3R6Sm7zMzZgZ
         43kpaQQneyRluhea6vdbjIeaoyWxpMidbOLeqZNfRoyW+D5mg2hmZO9diD2eQBqygSAM
         ayuDbDgqofXsmNvgKJdUBJsrgwyDaxj7MyZXBOLChkZ+L2gDuWQuiInXHc+vXP0i9W2K
         zrnYMqChaGKD7bGKBoqfvRe92jtbpyWxKsF3RFx3RiOHqVwYMjCNONX6qbrqulgSIa5B
         VP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679939708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5+s10zrxZejqq5bq+XUHu3L+KgjuGIY37R9ThVwAs5g=;
        b=JcHTEp6pCs2qAvtxZt8+UHViAweI7NaGvo+fTpJW7foJ0fyYtxHuiTefBATsdG0jC2
         vJkJO0JzwK9mRfNTgAgkNyl2ScpjCq/koMbeLb46gkThHxveOvJd11rhEdvqrosz8wSg
         yVpNgm9yIc9HP/hykFrwujKDoV9O0HNfUnTJR0c4o4qfXvgpNBrnfPzTAw/fw5GhCekx
         1J2ToARVleyAWf4UqLspe6XqRM18iz1guxhgoT9VW/rU2wS8kUg0TI8WNEUHWdrUvMx9
         6BqYrSZFf6XHEUsL2q49/A6M/f+yK+W7LHDRVAEpOeUkMYgbnxmKkBCCSkUSfQJoLnO7
         VXoA==
X-Gm-Message-State: AO0yUKUB8CeQHUTtJnHoHfUjotQPUHYlJTqdbnRM6K4b9rkEI8aTjF7V
        ZU0AzBpvUnDClxRTpGZ9nl8=
X-Google-Smtp-Source: AK7set/g5PTNrfrp781nZI2lkPmBDBD7/pW74IKFOa5RZeOs0GIOnsxjBJwU23gG/vEM9A+jYB75Kg==
X-Received: by 2002:a05:6a20:b26:b0:d8:d3b4:4912 with SMTP id x38-20020a056a200b2600b000d8d3b44912mr10031760pzf.9.1679939708289;
        Mon, 27 Mar 2023 10:55:08 -0700 (PDT)
Received: from john.lan ([98.97.117.131])
        by smtp.gmail.com with ESMTPSA id r1-20020a62e401000000b005a8ba70315bsm19408316pfh.6.2023.03.27.10.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 10:55:07 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v2 11/12] bpf: sockmap, test FIONREAD returns correct bytes in rx buffer
Date:   Mon, 27 Mar 2023 10:54:45 -0700
Message-Id: <20230327175446.98151-12-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230327175446.98151-1-john.fastabend@gmail.com>
References: <20230327175446.98151-1-john.fastabend@gmail.com>
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
index 8f0d60f5c847..16d76ec1ea1c 100644
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

