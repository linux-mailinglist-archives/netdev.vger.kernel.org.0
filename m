Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2706E63BA49
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiK2HJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiK2HJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:09:27 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B68D4843B;
        Mon, 28 Nov 2022 23:09:17 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669705756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pd8XpFA9fQW2uc7b3+KHvrNWg7Huq2n2i0zUFr3INdc=;
        b=GdlV/yXWCiDHONjn7/yUSuQ7m7P0/2TV9+kthkRVz7pwmehIaHxNe8DfZlpamcmAT5hkxY
        k8Bo8l+82wCiYkQm6jzvprt8iT/ueindsrnJqxfuUufXNok6k5rGaIp4OKB3oHfjhFU7gn
        pFdlIpWzK4+E441Ihs24Jftqi0BVlVY=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf-next 4/7] selftests/bpf: Avoid pinning bpf prog in the netns_load_bpf() callers
Date:   Mon, 28 Nov 2022 23:08:57 -0800
Message-Id: <20221129070900.3142427-5-martin.lau@linux.dev>
In-Reply-To: <20221129070900.3142427-1-martin.lau@linux.dev>
References: <20221129070900.3142427-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

This patch removes the need to pin prog in the remaining tests in
tc_redirect.c by directly using the bpf_tc_hook_create() and
bpf_tc_attach().  The clsact qdisc will go away together with
the test netns, so no need to do bpf_tc_hook_destroy().

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 .../selftests/bpf/prog_tests/tc_redirect.c    | 83 ++++++-------------
 1 file changed, 27 insertions(+), 56 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
index cefde6491749..6f800381f924 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -59,10 +59,6 @@
 #define IFADDR_STR_LEN 18
 #define PING_ARGS "-i 0.2 -c 3 -w 10 -q"
 
-#define SRC_PROG_PIN_FILE "/sys/fs/bpf/test_tc_src"
-#define DST_PROG_PIN_FILE "/sys/fs/bpf/test_tc_dst"
-#define CHK_PROG_PIN_FILE "/sys/fs/bpf/test_tc_chk"
-
 #define TIMEOUT_MILLIS 10000
 #define NSEC_PER_SEC 1000000000ULL
 
@@ -300,19 +296,28 @@ static int xgress_filter_add(struct bpf_tc_hook *qdisc_hook,
 		goto fail;							\
 })
 
-static int netns_load_bpf(void)
+static int netns_load_bpf(const struct bpf_program *src_prog,
+			  const struct bpf_program *dst_prog,
+			  const struct bpf_program *chk_prog,
+			  const struct netns_setup_result *setup_result)
 {
-	SYS("tc qdisc add dev veth_src_fwd clsact");
-	SYS("tc filter add dev veth_src_fwd ingress bpf da object-pinned "
-	    SRC_PROG_PIN_FILE);
-	SYS("tc filter add dev veth_src_fwd egress bpf da object-pinned "
-	    CHK_PROG_PIN_FILE);
-
-	SYS("tc qdisc add dev veth_dst_fwd clsact");
-	SYS("tc filter add dev veth_dst_fwd ingress bpf da object-pinned "
-	    DST_PROG_PIN_FILE);
-	SYS("tc filter add dev veth_dst_fwd egress bpf da object-pinned "
-	    CHK_PROG_PIN_FILE);
+	LIBBPF_OPTS(bpf_tc_hook, qdisc_veth_src_fwd);
+	LIBBPF_OPTS(bpf_tc_hook, qdisc_veth_dst_fwd);
+	int err;
+
+	/* tc qdisc add dev veth_src_fwd clsact */
+	QDISC_CLSACT_CREATE(&qdisc_veth_src_fwd, setup_result->ifindex_veth_src_fwd);
+	/* tc filter add dev veth_src_fwd ingress bpf da src_prog */
+	XGRESS_FILTER_ADD(&qdisc_veth_src_fwd, BPF_TC_INGRESS, src_prog, 0);
+	/* tc filter add dev veth_src_fwd egress bpf da chk_prog */
+	XGRESS_FILTER_ADD(&qdisc_veth_src_fwd, BPF_TC_EGRESS, chk_prog, 0);
+
+	/* tc qdisc add dev veth_dst_fwd clsact */
+	QDISC_CLSACT_CREATE(&qdisc_veth_dst_fwd, setup_result->ifindex_veth_dst_fwd);
+	/* tc filter add dev veth_dst_fwd ingress bpf da dst_prog */
+	XGRESS_FILTER_ADD(&qdisc_veth_dst_fwd, BPF_TC_INGRESS, dst_prog, 0);
+	/* tc filter add dev veth_dst_fwd egress bpf da chk_prog */
+	XGRESS_FILTER_ADD(&qdisc_veth_dst_fwd, BPF_TC_EGRESS, chk_prog, 0);
 
 	return 0;
 fail:
@@ -829,7 +834,6 @@ static void test_tc_redirect_neigh_fib(struct netns_setup_result *setup_result)
 {
 	struct nstoken *nstoken = NULL;
 	struct test_tc_neigh_fib *skel = NULL;
-	int err;
 
 	nstoken = open_netns(NS_FWD);
 	if (!ASSERT_OK_PTR(nstoken, "setns fwd"))
@@ -842,19 +846,8 @@ static void test_tc_redirect_neigh_fib(struct netns_setup_result *setup_result)
 	if (!ASSERT_OK(test_tc_neigh_fib__load(skel), "test_tc_neigh_fib__load"))
 		goto done;
 
-	err = bpf_program__pin(skel->progs.tc_src, SRC_PROG_PIN_FILE);
-	if (!ASSERT_OK(err, "pin " SRC_PROG_PIN_FILE))
-		goto done;
-
-	err = bpf_program__pin(skel->progs.tc_chk, CHK_PROG_PIN_FILE);
-	if (!ASSERT_OK(err, "pin " CHK_PROG_PIN_FILE))
-		goto done;
-
-	err = bpf_program__pin(skel->progs.tc_dst, DST_PROG_PIN_FILE);
-	if (!ASSERT_OK(err, "pin " DST_PROG_PIN_FILE))
-		goto done;
-
-	if (netns_load_bpf())
+	if (netns_load_bpf(skel->progs.tc_src, skel->progs.tc_dst,
+			   skel->progs.tc_chk, setup_result))
 		goto done;
 
 	/* bpf_fib_lookup() checks if forwarding is enabled */
@@ -890,19 +883,8 @@ static void test_tc_redirect_neigh(struct netns_setup_result *setup_result)
 	if (!ASSERT_OK(err, "test_tc_neigh__load"))
 		goto done;
 
-	err = bpf_program__pin(skel->progs.tc_src, SRC_PROG_PIN_FILE);
-	if (!ASSERT_OK(err, "pin " SRC_PROG_PIN_FILE))
-		goto done;
-
-	err = bpf_program__pin(skel->progs.tc_chk, CHK_PROG_PIN_FILE);
-	if (!ASSERT_OK(err, "pin " CHK_PROG_PIN_FILE))
-		goto done;
-
-	err = bpf_program__pin(skel->progs.tc_dst, DST_PROG_PIN_FILE);
-	if (!ASSERT_OK(err, "pin " DST_PROG_PIN_FILE))
-		goto done;
-
-	if (netns_load_bpf())
+	if (netns_load_bpf(skel->progs.tc_src, skel->progs.tc_dst,
+			   skel->progs.tc_chk, setup_result))
 		goto done;
 
 	if (!ASSERT_OK(set_forwarding(false), "disable forwarding"))
@@ -937,19 +919,8 @@ static void test_tc_redirect_peer(struct netns_setup_result *setup_result)
 	if (!ASSERT_OK(err, "test_tc_peer__load"))
 		goto done;
 
-	err = bpf_program__pin(skel->progs.tc_src, SRC_PROG_PIN_FILE);
-	if (!ASSERT_OK(err, "pin " SRC_PROG_PIN_FILE))
-		goto done;
-
-	err = bpf_program__pin(skel->progs.tc_chk, CHK_PROG_PIN_FILE);
-	if (!ASSERT_OK(err, "pin " CHK_PROG_PIN_FILE))
-		goto done;
-
-	err = bpf_program__pin(skel->progs.tc_dst, DST_PROG_PIN_FILE);
-	if (!ASSERT_OK(err, "pin " DST_PROG_PIN_FILE))
-		goto done;
-
-	if (netns_load_bpf())
+	if (netns_load_bpf(skel->progs.tc_src, skel->progs.tc_dst,
+			   skel->progs.tc_chk, setup_result))
 		goto done;
 
 	if (!ASSERT_OK(set_forwarding(false), "disable forwarding"))
-- 
2.30.2

