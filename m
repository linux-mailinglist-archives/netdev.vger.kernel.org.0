Return-Path: <netdev+bounces-3205-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B1AD705F5A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:29:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C2D21C20831
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C20FD1119B;
	Wed, 17 May 2023 05:23:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B430C11199;
	Wed, 17 May 2023 05:23:19 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFD13C25;
	Tue, 16 May 2023 22:23:12 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64a9335a8e7so10616615b3a.0;
        Tue, 16 May 2023 22:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684300992; x=1686892992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yWuuJj1UmKb8bhc9koutosmHK7yiCrZ5XUNipDsC3uQ=;
        b=A5YcKUbXy2aPMmWCljFPbHsoJaDh+VqqnX2h+7Ul+kE3Z9/dHWHtWobnwI1R5+WwnR
         CQ8ArI74Azg14LWpzNTEGfPmz1Lgrv0JpZFmHrm4u8kmwLy24HcT28sPdLjJPD+tZsCY
         VfcRAFoSXuw8xQL8o2HfktHL/kx6cyYFKQj+QieQGyu7QDAG/k3cI2WAWyL61ZAFZbaT
         LPm08MrBP41WIFALyUU1aOvj/6+8YT49vSnPlD9rag0pV+2jHeROuOi/9hP2Cq62TIQl
         vq2L/gGGu+y16BmOXoSqX5VGkIGwEAWtCto09RwqmmXucgJhBiClmb9SqVmP9n3iaUea
         aMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684300992; x=1686892992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yWuuJj1UmKb8bhc9koutosmHK7yiCrZ5XUNipDsC3uQ=;
        b=VO0cShCC+2OjA1hTaK4d5GD8UtCXMIZuX7G3YPwKETI0P/z+ZFQOsZP2ablGBqrGHm
         q5pEyycp2RsMrIv8BMlJl0ij09iMJPzFwNdPZVdtumEyL0vtBFwgJrTTytH9D9kYRNE7
         SstuxkPFRxEmQYrhRyqjBtTpVwlVYgjPNSutz6LXODwwDqc3VIcbPDvoHLGncetiqwUm
         d19O4DmqRd8mhko7ggveukEMdHVLQWsIj2y7mhzC6Of7zoRo3MiF/effZgQdqAssSaV9
         QYHzyFPGtOlSCADLX8OA28S3G7Gp3I5MQUUig3jeIq3JLenAFn9gZ338xZM1t06NSI7y
         Dm4A==
X-Gm-Message-State: AC+VfDxeCHx2+NiVK2WLaoTXpqgqGabNvKbkqo7TMpEBGyY4YgqXEfGr
	nNxe/hknWrFw0V34ean1vMk=
X-Google-Smtp-Source: ACHHUZ5TrMY+eb8hyXU4QkIUempAE70jHDU6EBB8Kgvydk0Zg6HXLuOEUE3HS60cv0gXXls0XCVpyQ==
X-Received: by 2002:a17:90a:d389:b0:24e:3752:194f with SMTP id q9-20020a17090ad38900b0024e3752194fmr1278239pju.21.1684300992267;
        Tue, 16 May 2023 22:23:12 -0700 (PDT)
Received: from john.lan ([98.97.37.198])
        by smtp.gmail.com with ESMTPSA id n11-20020a17090a2fcb00b0023cfdbb6496sm581779pjm.1.2023.05.16.22.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 22:23:11 -0700 (PDT)
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
Subject: [PATCH bpf v8 13/13] bpf: sockmap, test FIONREAD returns correct bytes in rx buffer with drops
Date: Tue, 16 May 2023 22:22:44 -0700
Message-Id: <20230517052244.294755-14-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230517052244.294755-1-john.fastabend@gmail.com>
References: <20230517052244.294755-1-john.fastabend@gmail.com>
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

When BPF program drops pkts the sockmap logic 'eats' the packet and
updates copied_seq. In the PASS case where the sk_buff is accepted
we update copied_seq from recvmsg path so we need a new test to
handle the drop case.

Original patch series broke this resulting in

test_sockmap_skb_verdict_fionread:PASS:ioctl(FIONREAD) error 0 nsec
test_sockmap_skb_verdict_fionread:FAIL:ioctl(FIONREAD) unexpected ioctl(FIONREAD): actual 1503041772 != expected 256
#176/17  sockmap_basic/sockmap skb_verdict fionread on drop:FAIL

After updated patch with fix.

#176/16  sockmap_basic/sockmap skb_verdict fionread:OK
#176/17  sockmap_basic/sockmap skb_verdict fionread on drop:OK

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 47 ++++++++++++++-----
 .../bpf/progs/test_sockmap_drop_prog.c        | 32 +++++++++++++
 2 files changed, 66 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index fe56049f6568..064cc5e8d9ad 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -11,6 +11,7 @@
 #include "test_sockmap_skb_verdict_attach.skel.h"
 #include "test_sockmap_progs_query.skel.h"
 #include "test_sockmap_pass_prog.skel.h"
+#include "test_sockmap_drop_prog.skel.h"
 #include "bpf_iter_sockmap.skel.h"
 
 #include "sockmap_helpers.h"
@@ -410,19 +411,31 @@ static void test_sockmap_skb_verdict_shutdown(void)
 	test_sockmap_pass_prog__destroy(skel);
 }
 
-static void test_sockmap_skb_verdict_fionread(void)
+static void test_sockmap_skb_verdict_fionread(bool pass_prog)
 {
+	int expected, zero = 0, sent, recvd, avail;
 	int err, map, verdict, s, c0, c1, p0, p1;
-	struct test_sockmap_pass_prog *skel;
-	int zero = 0, sent, recvd, avail;
+	struct test_sockmap_pass_prog *pass;
+	struct test_sockmap_drop_prog *drop;
 	char buf[256] = "0123456789";
 
-	skel = test_sockmap_pass_prog__open_and_load();
-	if (!ASSERT_OK_PTR(skel, "open_and_load"))
-		return;
+	if (pass_prog) {
+		pass = test_sockmap_pass_prog__open_and_load();
+		if (!ASSERT_OK_PTR(pass, "open_and_load"))
+			return;
+		verdict = bpf_program__fd(pass->progs.prog_skb_verdict);
+		map = bpf_map__fd(pass->maps.sock_map_rx);
+		expected = sizeof(buf);
+	} else {
+		drop = test_sockmap_drop_prog__open_and_load();
+		if (!ASSERT_OK_PTR(drop, "open_and_load"))
+			return;
+		verdict = bpf_program__fd(drop->progs.prog_skb_verdict);
+		map = bpf_map__fd(drop->maps.sock_map_rx);
+		/* On drop data is consumed immediately and copied_seq inc'd */
+		expected = 0;
+	}
 
-	verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
-	map = bpf_map__fd(skel->maps.sock_map_rx);
 
 	err = bpf_prog_attach(verdict, map, BPF_SK_SKB_STREAM_VERDICT, 0);
 	if (!ASSERT_OK(err, "bpf_prog_attach"))
@@ -443,9 +456,12 @@ static void test_sockmap_skb_verdict_fionread(void)
 	ASSERT_EQ(sent, sizeof(buf), "xsend(p0)");
 	err = ioctl(c1, FIONREAD, &avail);
 	ASSERT_OK(err, "ioctl(FIONREAD) error");
-	ASSERT_EQ(avail, sizeof(buf), "ioctl(FIONREAD)");
-	recvd = recv_timeout(c1, &buf, sizeof(buf), SOCK_NONBLOCK, IO_TIMEOUT_SEC);
-	ASSERT_EQ(recvd, sizeof(buf), "recv_timeout(c0)");
+	ASSERT_EQ(avail, expected, "ioctl(FIONREAD)");
+	/* On DROP test there will be no data to read */
+	if (pass_prog) {
+		recvd = recv_timeout(c1, &buf, sizeof(buf), SOCK_NONBLOCK, IO_TIMEOUT_SEC);
+		ASSERT_EQ(recvd, sizeof(buf), "recv_timeout(c0)");
+	}
 
 out_close:
 	close(c0);
@@ -453,7 +469,10 @@ static void test_sockmap_skb_verdict_fionread(void)
 	close(c1);
 	close(p1);
 out:
-	test_sockmap_pass_prog__destroy(skel);
+	if (pass_prog)
+		test_sockmap_pass_prog__destroy(pass);
+	else
+		test_sockmap_drop_prog__destroy(drop);
 }
 
 void test_sockmap_basic(void)
@@ -493,5 +512,7 @@ void test_sockmap_basic(void)
 	if (test__start_subtest("sockmap skb_verdict shutdown"))
 		test_sockmap_skb_verdict_shutdown();
 	if (test__start_subtest("sockmap skb_verdict fionread"))
-		test_sockmap_skb_verdict_fionread();
+		test_sockmap_skb_verdict_fionread(true);
+	if (test__start_subtest("sockmap skb_verdict fionread on drop"))
+		test_sockmap_skb_verdict_fionread(false);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c b/tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c
new file mode 100644
index 000000000000..29314805ce42
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c
@@ -0,0 +1,32 @@
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 20);
+	__type(key, int);
+	__type(value, int);
+} sock_map_rx SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 20);
+	__type(key, int);
+	__type(value, int);
+} sock_map_tx SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 20);
+	__type(key, int);
+	__type(value, int);
+} sock_map_msg SEC(".maps");
+
+SEC("sk_skb")
+int prog_skb_verdict(struct __sk_buff *skb)
+{
+	return SK_DROP;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.33.0


