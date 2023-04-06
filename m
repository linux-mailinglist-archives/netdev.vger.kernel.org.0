Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B430D6D8C60
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbjDFBCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbjDFBBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:01:18 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D2B7EE8;
        Wed,  5 Apr 2023 18:00:57 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id u38so24806273pfg.10;
        Wed, 05 Apr 2023 18:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680742857; x=1683334857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpxzIylC0O+QIhlCGWKD1562wl2qGt79MOUaYG3771U=;
        b=e9JOUh9BpEI5eu/55ijip7QptCADK0JibFDDNBRs/RvgJnwM+EEFzwILbyus3qXRXw
         NLkcqI8ypZ6K2+2ZtncUefYGNyzhKDCJ4roAnSjP6F2sLIvIXq6n5syenoQ55BKH2dQP
         zfp+hsyU6cP0Zu9ph7/VATLTPBOr1nk8TY4YRIp9rTgmYF2bguUuLWHf3muWp1odU5Zf
         4Z49OTlSJtNxiKNRE0zmE9lkBXh63kVIeu9cgy36mndbbCEarhkfQG2FP02Cu+hpQ97s
         ZknfL/M/6iaQ6v/91eLexQKBU8iJt4IY6L1RTwYv0qgjzcXjOkPYKMz0fwWBiwjn5ZqM
         1ECQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680742857; x=1683334857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MpxzIylC0O+QIhlCGWKD1562wl2qGt79MOUaYG3771U=;
        b=PotKPT/yFeBpnYVauOgdb3y19ev4CLFpBSWkiRmb6ZW0wFE/6pWVFFis55n7GYds8o
         USlQpfJneT21tghtygs6I6h5ePTh4Ja/gzPwz4p3m1NIGlNP7wNfXfUj8s4m1xKOxjbY
         xZwtvUZfH+4cNNiLH3zibWJqmau2i/uUDbRHX37f8wesC7d4R1dTdzVg5DEU1EqXwRKH
         9ti3A1Vkfyrn3M9J6QTjKFJyv4rTkjvM80GNzX4X5g7gtL9UtgymKOV+FwoRfqID1zTi
         5DncIg194z/NTY0AmFENVwFCO/GEoS3yaga0w4KnPTDioDysInv+x/xNiNj3A7aj88kS
         2beA==
X-Gm-Message-State: AAQBX9eL3XXY1Gko0SBJlD8g6VPsa3pv061JnA76rTzIC51CG2hR6qqV
        l+F75vPdh8jMy2JC4j7xUKk=
X-Google-Smtp-Source: AKy350bm+0AtfW+NnsDIjBq1MCnhhNbpsfzJQrdW/fP7aC0fEQB3qp9iCW/uDyKNrIbe4dbjpkKbtw==
X-Received: by 2002:a05:6a00:1a49:b0:627:f40a:fd35 with SMTP id h9-20020a056a001a4900b00627f40afd35mr4806625pfv.10.1680742856974;
        Wed, 05 Apr 2023 18:00:56 -0700 (PDT)
Received: from john.lan ([98.97.117.85])
        by smtp.gmail.com with ESMTPSA id c14-20020aa78c0e000000b0062c0c3da6b8sm35377pfd.13.2023.04.05.18.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 18:00:56 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v5 12/12] bpf: sockmap, test FIONREAD returns correct bytes in rx buffer with drops
Date:   Wed,  5 Apr 2023 18:00:31 -0700
Message-Id: <20230406010031.3354-13-john.fastabend@gmail.com>
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

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 47 ++++++++++++++-----
 .../bpf/progs/test_sockmap_drop_prog.c        | 32 +++++++++++++
 2 files changed, 66 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 322b5a135740..10112a1ab443 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -11,6 +11,7 @@
 #include "test_sockmap_skb_verdict_attach.skel.h"
 #include "test_sockmap_progs_query.skel.h"
 #include "test_sockmap_pass_prog.skel.h"
+#include "test_sockmap_drop_prog.skel.h"
 #include "bpf_iter_sockmap.skel.h"
 
 #include "sockmap_helpers.h"
@@ -416,19 +417,31 @@ static void test_sockmap_skb_verdict_shutdown(void)
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
@@ -449,9 +462,12 @@ static void test_sockmap_skb_verdict_fionread(void)
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
@@ -459,7 +475,10 @@ static void test_sockmap_skb_verdict_fionread(void)
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
@@ -499,5 +518,7 @@ void test_sockmap_basic(void)
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

