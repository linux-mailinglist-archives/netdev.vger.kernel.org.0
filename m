Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEB95EEE60
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbiI2HFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235025AbiI2HEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:04:46 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2289EE16;
        Thu, 29 Sep 2022 00:04:39 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664435077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VvIKaWyrD++47cob00FLRKjCXfixbyYJJB5mAod9z80=;
        b=kvMJ5uJ+vqDnrPMsi6q9nrtcFEEMXbNUE8hOsYzvwoksSgl9RC/087RhIyhbtIb7GPqeCY
        +a+RQsVAKWdoMB9V0tmvbRXMt2w/P+nMtI6QumgALGxH+FOW1626DNjkr2RNzAQ00UP5h3
        weTATx8C7OWYYYVEi64kTpNcs1gl9b4=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     ' ' <bpf@vger.kernel.org>, ' ' <netdev@vger.kernel.org>
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        'David Miller ' <davem@davemloft.net>,
        'Jakub Kicinski ' <kuba@kernel.org>,
        'Eric Dumazet ' <edumazet@google.com>,
        'Paolo Abeni ' <pabeni@redhat.com>, ' ' <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 5/5] selftests/bpf: Check -EBUSY for the recurred bpf_setsockopt(TCP_CONGESTION)
Date:   Thu, 29 Sep 2022 00:04:07 -0700
Message-Id: <20220929070407.965581-6-martin.lau@linux.dev>
In-Reply-To: <20220929070407.965581-1-martin.lau@linux.dev>
References: <20220929070407.965581-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

This patch changes the bpf_dctcp test to ensure the recurred
bpf_setsockopt(TCP_CONGESTION) returns -EBUSY.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |  4 +++
 tools/testing/selftests/bpf/progs/bpf_dctcp.c | 25 +++++++++++++------
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
index 2959a52ced06..e980188d4124 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
@@ -290,6 +290,10 @@ static void test_dctcp_fallback(void)
 		goto done;
 	ASSERT_STREQ(dctcp_skel->bss->cc_res, "cubic", "cc_res");
 	ASSERT_EQ(dctcp_skel->bss->tcp_cdg_res, -ENOTSUPP, "tcp_cdg_res");
+	/* All setsockopt(TCP_CONGESTION) in the recurred
+	 * bpf_dctcp->init() should fail with -EBUSY.
+	 */
+	ASSERT_EQ(dctcp_skel->bss->ebusy_cnt, 3, "ebusy_cnt");
 
 	err = getsockopt(srv_fd, SOL_TCP, TCP_CONGESTION, srv_cc, &cc_len);
 	if (!ASSERT_OK(err, "getsockopt(srv_fd, TCP_CONGESTION)"))
diff --git a/tools/testing/selftests/bpf/progs/bpf_dctcp.c b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
index 9573be6122be..460682759aed 100644
--- a/tools/testing/selftests/bpf/progs/bpf_dctcp.c
+++ b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/tcp.h>
+#include <errno.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include "bpf_tcp_helpers.h"
@@ -23,6 +24,7 @@ const char tcp_cdg[] = "cdg";
 char cc_res[TCP_CA_NAME_MAX];
 int tcp_cdg_res = 0;
 int stg_result = 0;
+int ebusy_cnt = 0;
 
 struct {
 	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
@@ -64,16 +66,23 @@ void BPF_PROG(dctcp_init, struct sock *sk)
 
 	if (!(tp->ecn_flags & TCP_ECN_OK) && fallback[0]) {
 		/* Switch to fallback */
-		bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
-			       (void *)fallback, sizeof(fallback));
-		/* Switch back to myself which the bpf trampoline
-		 * stopped calling dctcp_init recursively.
+		if (bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
+				   (void *)fallback, sizeof(fallback)) == -EBUSY)
+			ebusy_cnt++;
+
+		/* Switch back to myself and the recurred dctcp_init()
+		 * will get -EBUSY for all bpf_setsockopt(TCP_CONGESTION),
+		 * except the last "cdg" one.
 		 */
-		bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
-			       (void *)bpf_dctcp, sizeof(bpf_dctcp));
+		if (bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
+				   (void *)bpf_dctcp, sizeof(bpf_dctcp)) == -EBUSY)
+			ebusy_cnt++;
+
 		/* Switch back to fallback */
-		bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
-			       (void *)fallback, sizeof(fallback));
+		if (bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
+				   (void *)fallback, sizeof(fallback)) == -EBUSY)
+			ebusy_cnt++;
+
 		/* Expecting -ENOTSUPP for tcp_cdg_res */
 		tcp_cdg_res = bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
 					     (void *)tcp_cdg, sizeof(tcp_cdg));
-- 
2.30.2

