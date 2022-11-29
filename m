Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D8E63BA43
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiK2HJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiK2HJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:09:14 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05ADE391F7;
        Mon, 28 Nov 2022 23:09:12 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669705751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BeXQ1syZzDHmFlguhO+kKhll0xox7nS4pLrij1EQpWQ=;
        b=PACVqbGcIwZUGux2TknqD6jUWH4VEqGpBKz7xivbWd1BA003fKhDeSAOEGeRQrtzFQ+/2E
        /uvAvDzNzyMQRp/cL0BgoRorNwjySUpwl1IymJzBA4Rifl+dAK9tJSEHtiBtNlA8ZG2GM6
        Zj1T4hQDsfo2LT2DSZmCunvZnh2+2bE=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf-next 2/7] selftests/bpf: Avoid pinning bpf prog in the tc_redirect_dtime test
Date:   Mon, 28 Nov 2022 23:08:55 -0800
Message-Id: <20221129070900.3142427-3-martin.lau@linux.dev>
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

This patch removes the need to pin prog in the tc_redirect_dtime
test by directly using the bpf_tc_hook_create() and bpf_tc_attach().
The clsact qdisc will go away together with the test netns, so
no need to do bpf_tc_hook_destroy().

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 .../selftests/bpf/prog_tests/tc_redirect.c    | 149 ++++++++++++------
 1 file changed, 100 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
index 2d85742efdd3..690102f1ceda 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -250,6 +250,56 @@ static int netns_setup_links_and_routes(struct netns_setup_result *result)
 	return -1;
 }
 
+static int qdisc_clsact_create(struct bpf_tc_hook *qdisc_hook, int ifindex)
+{
+	char err_str[128], ifname[16];
+	int err;
+
+	qdisc_hook->ifindex = ifindex;
+	qdisc_hook->attach_point = BPF_TC_INGRESS | BPF_TC_EGRESS;
+	err = bpf_tc_hook_create(qdisc_hook);
+	snprintf(err_str, sizeof(err_str),
+		 "qdisc add dev %s clsact",
+		 if_indextoname(qdisc_hook->ifindex, ifname) ? : "<unknown_iface>");
+	err_str[sizeof(err_str) - 1] = 0;
+	ASSERT_OK(err, err_str);
+
+	return err;
+}
+
+static int xgress_filter_add(struct bpf_tc_hook *qdisc_hook,
+			     enum bpf_tc_attach_point xgress,
+			     const struct bpf_program *prog, int priority)
+{
+	LIBBPF_OPTS(bpf_tc_opts, tc_attach);
+	char err_str[128], ifname[16];
+	int err;
+
+	qdisc_hook->attach_point = xgress;
+	tc_attach.prog_fd = bpf_program__fd(prog);
+	tc_attach.priority = priority;
+	err = bpf_tc_attach(qdisc_hook, &tc_attach);
+	snprintf(err_str, sizeof(err_str),
+		 "filter add dev %s %s prio %d bpf da %s",
+		 if_indextoname(qdisc_hook->ifindex, ifname) ? : "<unknown_iface>",
+		 xgress == BPF_TC_INGRESS ? "ingress" : "egress",
+		 priority, bpf_program__name(prog));
+	err_str[sizeof(err_str) - 1] = 0;
+	ASSERT_OK(err, err_str);
+
+	return err;
+}
+
+#define QDISC_CLSACT_CREATE(qdisc_hook, ifindex) ({		\
+	if ((err = qdisc_clsact_create(qdisc_hook, ifindex)))	\
+		goto fail;					\
+})
+
+#define XGRESS_FILTER_ADD(qdisc_hook, xgress, prog, priority) ({		\
+	if ((err = xgress_filter_add(qdisc_hook, xgress, prog, priority)))	\
+		goto fail;							\
+})
+
 static int netns_load_bpf(void)
 {
 	SYS("tc qdisc add dev veth_src_fwd clsact");
@@ -489,78 +539,79 @@ static void test_inet_dtime(int family, int type, const char *addr, __u16 port)
 		close(client_fd);
 }
 
-static int netns_load_dtime_bpf(struct test_tc_dtime *skel)
+static int netns_load_dtime_bpf(struct test_tc_dtime *skel,
+				const struct netns_setup_result *setup_result)
 {
+	LIBBPF_OPTS(bpf_tc_hook, qdisc_veth_src_fwd);
+	LIBBPF_OPTS(bpf_tc_hook, qdisc_veth_dst_fwd);
+	LIBBPF_OPTS(bpf_tc_hook, qdisc_veth_src);
+	LIBBPF_OPTS(bpf_tc_hook, qdisc_veth_dst);
 	struct nstoken *nstoken;
-
-#define PIN_FNAME(__file) "/sys/fs/bpf/" #__file
-#define PIN(__prog) ({							\
-		int err = bpf_program__pin(skel->progs.__prog, PIN_FNAME(__prog)); \
-		if (!ASSERT_OK(err, "pin " #__prog))		\
-			goto fail;					\
-		})
+	int err;
 
 	/* setup ns_src tc progs */
 	nstoken = open_netns(NS_SRC);
 	if (!ASSERT_OK_PTR(nstoken, "setns " NS_SRC))
 		return -1;
-	PIN(egress_host);
-	PIN(ingress_host);
-	SYS("tc qdisc add dev veth_src clsact");
-	SYS("tc filter add dev veth_src ingress bpf da object-pinned "
-	    PIN_FNAME(ingress_host));
-	SYS("tc filter add dev veth_src egress bpf da object-pinned "
-	    PIN_FNAME(egress_host));
+	/* tc qdisc add dev veth_src clsact */
+	QDISC_CLSACT_CREATE(&qdisc_veth_src, setup_result->ifindex_veth_src);
+	/* tc filter add dev veth_src ingress bpf da ingress_host */
+	XGRESS_FILTER_ADD(&qdisc_veth_src, BPF_TC_INGRESS, skel->progs.ingress_host, 0);
+	/* tc filter add dev veth_src egress bpf da egress_host */
+	XGRESS_FILTER_ADD(&qdisc_veth_src, BPF_TC_EGRESS, skel->progs.egress_host, 0);
 	close_netns(nstoken);
 
 	/* setup ns_dst tc progs */
 	nstoken = open_netns(NS_DST);
 	if (!ASSERT_OK_PTR(nstoken, "setns " NS_DST))
 		return -1;
-	PIN(egress_host);
-	PIN(ingress_host);
-	SYS("tc qdisc add dev veth_dst clsact");
-	SYS("tc filter add dev veth_dst ingress bpf da object-pinned "
-	    PIN_FNAME(ingress_host));
-	SYS("tc filter add dev veth_dst egress bpf da object-pinned "
-	    PIN_FNAME(egress_host));
+	/* tc qdisc add dev veth_dst clsact */
+	QDISC_CLSACT_CREATE(&qdisc_veth_dst, setup_result->ifindex_veth_dst);
+	/* tc filter add dev veth_dst ingress bpf da ingress_host */
+	XGRESS_FILTER_ADD(&qdisc_veth_dst, BPF_TC_INGRESS, skel->progs.ingress_host, 0);
+	/* tc filter add dev veth_dst egress bpf da egress_host */
+	XGRESS_FILTER_ADD(&qdisc_veth_dst, BPF_TC_EGRESS, skel->progs.egress_host, 0);
 	close_netns(nstoken);
 
 	/* setup ns_fwd tc progs */
 	nstoken = open_netns(NS_FWD);
 	if (!ASSERT_OK_PTR(nstoken, "setns " NS_FWD))
 		return -1;
-	PIN(ingress_fwdns_prio100);
-	PIN(egress_fwdns_prio100);
-	PIN(ingress_fwdns_prio101);
-	PIN(egress_fwdns_prio101);
-	SYS("tc qdisc add dev veth_dst_fwd clsact");
-	SYS("tc filter add dev veth_dst_fwd ingress prio 100 bpf da object-pinned "
-	    PIN_FNAME(ingress_fwdns_prio100));
-	SYS("tc filter add dev veth_dst_fwd ingress prio 101 bpf da object-pinned "
-	    PIN_FNAME(ingress_fwdns_prio101));
-	SYS("tc filter add dev veth_dst_fwd egress prio 100 bpf da object-pinned "
-	    PIN_FNAME(egress_fwdns_prio100));
-	SYS("tc filter add dev veth_dst_fwd egress prio 101 bpf da object-pinned "
-	    PIN_FNAME(egress_fwdns_prio101));
-	SYS("tc qdisc add dev veth_src_fwd clsact");
-	SYS("tc filter add dev veth_src_fwd ingress prio 100 bpf da object-pinned "
-	    PIN_FNAME(ingress_fwdns_prio100));
-	SYS("tc filter add dev veth_src_fwd ingress prio 101 bpf da object-pinned "
-	    PIN_FNAME(ingress_fwdns_prio101));
-	SYS("tc filter add dev veth_src_fwd egress prio 100 bpf da object-pinned "
-	    PIN_FNAME(egress_fwdns_prio100));
-	SYS("tc filter add dev veth_src_fwd egress prio 101 bpf da object-pinned "
-	    PIN_FNAME(egress_fwdns_prio101));
+	/* tc qdisc add dev veth_dst_fwd clsact */
+	QDISC_CLSACT_CREATE(&qdisc_veth_dst_fwd, setup_result->ifindex_veth_dst_fwd);
+	/* tc filter add dev veth_dst_fwd ingress prio 100 bpf da ingress_fwdns_prio100 */
+	XGRESS_FILTER_ADD(&qdisc_veth_dst_fwd, BPF_TC_INGRESS,
+			  skel->progs.ingress_fwdns_prio100, 100);
+	/* tc filter add dev veth_dst_fwd ingress prio 101 bpf da ingress_fwdns_prio101 */
+	XGRESS_FILTER_ADD(&qdisc_veth_dst_fwd, BPF_TC_INGRESS,
+			  skel->progs.ingress_fwdns_prio101, 101);
+	/* tc filter add dev veth_dst_fwd egress prio 100 bpf da egress_fwdns_prio100 */
+	XGRESS_FILTER_ADD(&qdisc_veth_dst_fwd, BPF_TC_EGRESS,
+			  skel->progs.egress_fwdns_prio100, 100);
+	/* tc filter add dev veth_dst_fwd egress prio 101 bpf da egress_fwdns_prio101 */
+	XGRESS_FILTER_ADD(&qdisc_veth_dst_fwd, BPF_TC_EGRESS,
+			  skel->progs.egress_fwdns_prio101, 101);
+
+	/* tc qdisc add dev veth_src_fwd clsact */
+	QDISC_CLSACT_CREATE(&qdisc_veth_src_fwd, setup_result->ifindex_veth_src_fwd);
+	/* tc filter add dev veth_src_fwd ingress prio 100 bpf da ingress_fwdns_prio100 */
+	XGRESS_FILTER_ADD(&qdisc_veth_src_fwd, BPF_TC_INGRESS,
+			  skel->progs.ingress_fwdns_prio100, 100);
+	/* tc filter add dev veth_src_fwd ingress prio 101 bpf da ingress_fwdns_prio101 */
+	XGRESS_FILTER_ADD(&qdisc_veth_src_fwd, BPF_TC_INGRESS,
+			  skel->progs.ingress_fwdns_prio101, 101);
+	/* tc filter add dev veth_src_fwd egress prio 100 bpf da egress_fwdns_prio100 */
+	XGRESS_FILTER_ADD(&qdisc_veth_src_fwd, BPF_TC_EGRESS,
+			  skel->progs.egress_fwdns_prio100, 100);
+	/* tc filter add dev veth_src_fwd egress prio 101 bpf da egress_fwdns_prio101 */
+	XGRESS_FILTER_ADD(&qdisc_veth_src_fwd, BPF_TC_EGRESS,
+			  skel->progs.egress_fwdns_prio101, 101);
 	close_netns(nstoken);
-
-#undef PIN
-
 	return 0;
 
 fail:
 	close_netns(nstoken);
-	return -1;
+	return err;
 }
 
 enum {
@@ -736,7 +787,7 @@ static void test_tc_redirect_dtime(struct netns_setup_result *setup_result)
 	if (!ASSERT_OK(err, "test_tc_dtime__load"))
 		goto done;
 
-	if (netns_load_dtime_bpf(skel))
+	if (netns_load_dtime_bpf(skel, setup_result))
 		goto done;
 
 	nstoken = open_netns(NS_FWD);
-- 
2.30.2

