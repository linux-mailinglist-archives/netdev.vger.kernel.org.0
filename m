Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E436D51CD
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbjDCUCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbjDCUCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:02:15 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6BB4206;
        Mon,  3 Apr 2023 13:02:01 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id kq3so29143325plb.13;
        Mon, 03 Apr 2023 13:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680552120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I/e44MTh7M407OJ1hC7xQsEWYl13ekNij3tNSRQR2hY=;
        b=ZlPnN3muJIZbLV9/ke9ewgRl4NLVpXIHmpi/WpNGTaR7yJRdKx/LX7z2xdLLC//zlv
         XOy7GBqnDLWTlt8biNL4RWbLgwvQchtJWAe663zjbJHoBjys4yoO10cZcP/wK6LCnoqz
         FgcBPDlIkkNwuLdZb4vwsNhW8uolKMm/uzGrDV8iPdP2e6bNTRMjkS2nn6zpSE4Kx15x
         C3sK2vEXtgUy1VPS4xi8MLWE/0DAeKcE9532xWNjImojT4rUAOFgONDdRx9c9/fFu/il
         NI1/aV0r2XJX3NMJG9y93xZIZdwPBvtCi4mfRRPFwOVY11LMKPjcqtlZQQzT4pcp6xKD
         PIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680552120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I/e44MTh7M407OJ1hC7xQsEWYl13ekNij3tNSRQR2hY=;
        b=aLD53eVwmy8UK4Gdyqo3B0QHrGCbhvaOpbmrccONgDbVwkW6Gi4KoFViQpCMeO8Aoj
         29dWKpynKsnxwq5AplR6e5m/XU5/627fLWCDDchLKRXbksokZNSth2RPkc/RRewrfv7R
         3oGKBOkiTfeKjt1cJJgjtSWFyLedv0cucCPc7fHydAdiCcMCAnshnQRw5zhj4L4VrGY5
         RNO0lvyIbjV05b0muky95B8xBD/gozPzaq2CThBU/KA2waCH7KfkHh/hwd3u+mIiT5C9
         fdKBQLlsk0zZ9z7cQdCwK+sf+ghaSBUkp7YBBn6rWZb+9m0Vc0sBWIFkZ7rnk9X5rQSx
         2VGg==
X-Gm-Message-State: AAQBX9fwJIni4ZAJyy0SlUG5MNGNIMZ0QufQlHLnJ377FvKDaJKrWjaa
        /2GIF4brc5n3wK4iFwfgdiU=
X-Google-Smtp-Source: AKy350aPo5UebHDU3NSOYF3AWReoOBMIemJwh9lEdgh0Ztd63n45Vnp0v8YxBMLIvKle2mKSn+QEcA==
X-Received: by 2002:a17:902:dcd4:b0:1a2:c05b:1525 with SMTP id t20-20020a170902dcd400b001a2c05b1525mr213630pll.48.1680552120498;
        Mon, 03 Apr 2023 13:02:00 -0700 (PDT)
Received: from localhost.localdomain ([2605:59c8:4c5:7110:3da7:5d97:f465:5e01])
        by smtp.gmail.com with ESMTPSA id t18-20020a1709028c9200b0019c2b1c4db1sm6948835plo.239.2023.04.03.13.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:02:00 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v3 11/12] bpf: sockmap, test FIONREAD returns correct bytes in rx buffer
Date:   Mon,  3 Apr 2023 13:01:37 -0700
Message-Id: <20230403200138.937569-12-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230403200138.937569-1-john.fastabend@gmail.com>
References: <20230403200138.937569-1-john.fastabend@gmail.com>
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

