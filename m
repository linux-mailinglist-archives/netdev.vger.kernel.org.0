Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D12A63BA40
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiK2HJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiK2HJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:09:15 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC5654775;
        Mon, 28 Nov 2022 23:09:15 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669705753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=daLJ29yFihWyOC2f6+d94eIoT4i4pfmWhCamEpp1TLc=;
        b=ImhbJ30X91vbpiHkp3C8dU4qHdqoQaj4A+z4q07tvWtjQVCrc8Lzy4KFXiAh3ZU2IMEIz+
        phxjPvpoaMWF6lfXGlnm3wm3RGAKo9DFbE/sxdFE8FY7PkqGoNfqaQ2ICtH+DP625Wb4v2
        rmXcQcB4dbcB7YT6UnoEVdMF6IsNZ38=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf-next 3/7] selftests/bpf: Avoid pinning bpf prog in the tc_redirect_peer_l3 test
Date:   Mon, 28 Nov 2022 23:08:56 -0800
Message-Id: <20221129070900.3142427-4-martin.lau@linux.dev>
In-Reply-To: <20221129070900.3142427-1-martin.lau@linux.dev>
References: <20221129070900.3142427-1-martin.lau@linux.dev>
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

This patch removes the need to pin prog in the tc_redirect_peer_l3
test by directly using the bpf_tc_hook_create() and bpf_tc_attach().
The clsact qdisc will go away together with the test netns, so
no need to do bpf_tc_hook_destroy().

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 .../selftests/bpf/prog_tests/tc_redirect.c    | 32 +++++++------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
index 690102f1ceda..cefde6491749 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -1032,6 +1032,8 @@ static int tun_relay_loop(int src_fd, int target_fd)
 
 static void test_tc_redirect_peer_l3(struct netns_setup_result *setup_result)
 {
+	LIBBPF_OPTS(bpf_tc_hook, qdisc_tun_fwd);
+	LIBBPF_OPTS(bpf_tc_hook, qdisc_veth_dst_fwd);
 	struct test_tc_peer *skel = NULL;
 	struct nstoken *nstoken = NULL;
 	int err;
@@ -1086,31 +1088,21 @@ static void test_tc_redirect_peer_l3(struct netns_setup_result *setup_result)
 	if (!ASSERT_OK(err, "test_tc_peer__load"))
 		goto fail;
 
-	err = bpf_program__pin(skel->progs.tc_src_l3, SRC_PROG_PIN_FILE);
-	if (!ASSERT_OK(err, "pin " SRC_PROG_PIN_FILE))
-		goto fail;
-
-	err = bpf_program__pin(skel->progs.tc_dst_l3, DST_PROG_PIN_FILE);
-	if (!ASSERT_OK(err, "pin " DST_PROG_PIN_FILE))
-		goto fail;
-
-	err = bpf_program__pin(skel->progs.tc_chk, CHK_PROG_PIN_FILE);
-	if (!ASSERT_OK(err, "pin " CHK_PROG_PIN_FILE))
-		goto fail;
-
 	/* Load "tc_src_l3" to the tun_fwd interface to redirect packets
 	 * towards dst, and "tc_dst" to redirect packets
 	 * and "tc_chk" on veth_dst_fwd to drop non-redirected packets.
 	 */
-	SYS("tc qdisc add dev tun_fwd clsact");
-	SYS("tc filter add dev tun_fwd ingress bpf da object-pinned "
-	    SRC_PROG_PIN_FILE);
+	/* tc qdisc add dev tun_fwd clsact */
+	QDISC_CLSACT_CREATE(&qdisc_tun_fwd, ifindex);
+	/* tc filter add dev tun_fwd ingress bpf da tc_src_l3 */
+	XGRESS_FILTER_ADD(&qdisc_tun_fwd, BPF_TC_INGRESS, skel->progs.tc_src_l3, 0);
 
-	SYS("tc qdisc add dev veth_dst_fwd clsact");
-	SYS("tc filter add dev veth_dst_fwd ingress bpf da object-pinned "
-	    DST_PROG_PIN_FILE);
-	SYS("tc filter add dev veth_dst_fwd egress bpf da object-pinned "
-	    CHK_PROG_PIN_FILE);
+	/* tc qdisc add dev veth_dst_fwd clsact */
+	QDISC_CLSACT_CREATE(&qdisc_veth_dst_fwd, setup_result->ifindex_veth_dst_fwd);
+	/* tc filter add dev veth_dst_fwd ingress bpf da tc_dst_l3 */
+	XGRESS_FILTER_ADD(&qdisc_veth_dst_fwd, BPF_TC_INGRESS, skel->progs.tc_dst_l3, 0);
+	/* tc filter add dev veth_dst_fwd egress bpf da tc_chk */
+	XGRESS_FILTER_ADD(&qdisc_veth_dst_fwd, BPF_TC_EGRESS, skel->progs.tc_chk, 0);
 
 	/* Setup route and neigh tables */
 	SYS("ip -netns " NS_SRC " addr add dev tun_src " IP4_TUN_SRC "/24");
-- 
2.30.2

