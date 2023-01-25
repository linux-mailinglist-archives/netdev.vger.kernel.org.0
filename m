Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66D667A7D9
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 01:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbjAYAfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 19:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbjAYAe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 19:34:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03529521DE;
        Tue, 24 Jan 2023 16:34:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9331DB811C1;
        Wed, 25 Jan 2023 00:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B2DC4339B;
        Wed, 25 Jan 2023 00:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674606880;
        bh=VCGnWFr95SwwAJ+v2VcqnBX0uqgPPRwmMsbFoP0le3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHxs1RQ8H91C77Kof8fjiUY+MTA/fyRE85EC/wzr1JYT0auJULNL3V8ZozDL8xB9j
         96hXwCqm9R3cX0ghYm/MqvlbfzDg8DT6tmDw9hCuFwH5Pq/qoUcRxyUQQevTjKNCns
         UHQx5dJvq0tQ9cDKlFdkHXyagq8LTY/hCgkSfk5B9jxgIP3M0pGZx9u3dl5PdVHWkJ
         maxX4in/Eg/EF4e326uPXbMd+VfOvb5uqJHX2vo/EszaTrntxUilBvot8u5Pkl5Gpl
         /d/KiJ53pV3/ilGZhnWqk3XURCO7r5vvLQtJxNmlp5qMK6s/AcTifJeROwWJ+qVCr3
         qirjTXqHVhTwg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, martin.lau@linux.dev
Subject: [PATCH v2 bpf-next 7/8] selftests/bpf: add test for bpf_xdp_query xdp-features support
Date:   Wed, 25 Jan 2023 01:33:27 +0100
Message-Id: <a60e73ce6334030d29765125ccda17ace814ada5.1674606198.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674606193.git.lorenzo@kernel.org>
References: <cover.1674606193.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a self-test to verify libbpf bpf_xdp_query capability to dump
the xdp-features supported by the device (lo and veth in this case).

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../bpf/prog_tests/xdp_do_redirect.c          | 27 ++++++++++++++++++-
 .../selftests/bpf/prog_tests/xdp_info.c       |  8 ++++++
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
index a50971c6cf4a..e15fb3f0306c 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -4,10 +4,12 @@
 #include <net/if.h>
 #include <linux/if_ether.h>
 #include <linux/if_packet.h>
+#include <linux/if_link.h>
 #include <linux/ipv6.h>
 #include <linux/in6.h>
 #include <linux/udp.h>
 #include <bpf/bpf_endian.h>
+#include <uapi/linux/netdev.h>
 #include "test_xdp_do_redirect.skel.h"
 
 #define SYS(fmt, ...)						\
@@ -92,7 +94,7 @@ void test_xdp_do_redirect(void)
 	struct test_xdp_do_redirect *skel = NULL;
 	struct nstoken *nstoken = NULL;
 	struct bpf_link *link;
-
+	LIBBPF_OPTS(bpf_xdp_query_opts, query_opts);
 	struct xdp_md ctx_in = { .data = sizeof(__u32),
 				 .data_end = sizeof(data) };
 	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
@@ -153,6 +155,29 @@ void test_xdp_do_redirect(void)
 	    !ASSERT_NEQ(ifindex_dst, 0, "ifindex_dst"))
 		goto out;
 
+	/* Check xdp features supported by veth driver */
+	err = bpf_xdp_query(ifindex_src, XDP_FLAGS_DRV_MODE, &query_opts);
+	if (!ASSERT_OK(err, "veth_src bpf_xdp_query"))
+		goto out;
+
+	if (!ASSERT_EQ(query_opts.fflags,
+		       NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+		       NETDEV_XDP_ACT_NDO_XMIT | NETDEV_XDP_ACT_RX_SG |
+		       NETDEV_XDP_ACT_NDO_XMIT_SG,
+		       "veth_src query_opts.fflags"))
+		goto out;
+
+	err = bpf_xdp_query(ifindex_dst, XDP_FLAGS_DRV_MODE, &query_opts);
+	if (!ASSERT_OK(err, "veth_dst bpf_xdp_query"))
+		goto out;
+
+	if (!ASSERT_EQ(query_opts.fflags,
+		       NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+		       NETDEV_XDP_ACT_NDO_XMIT | NETDEV_XDP_ACT_RX_SG |
+		       NETDEV_XDP_ACT_NDO_XMIT_SG,
+		       "veth_dst query_opts.fflags"))
+		goto out;
+
 	memcpy(skel->rodata->expect_dst, &pkt_udp.eth.h_dest, ETH_ALEN);
 	skel->rodata->ifindex_out = ifindex_src; /* redirect back to the same iface */
 	skel->rodata->ifindex_in = ifindex_src;
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_info.c b/tools/testing/selftests/bpf/prog_tests/xdp_info.c
index cd3aa340e65e..8397468a9e74 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_info.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_info.c
@@ -8,6 +8,7 @@ void serial_test_xdp_info(void)
 {
 	__u32 len = sizeof(struct bpf_prog_info), duration = 0, prog_id;
 	const char *file = "./xdp_dummy.bpf.o";
+	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
 	struct bpf_prog_info info = {};
 	struct bpf_object *obj;
 	int err, prog_fd;
@@ -61,6 +62,13 @@ void serial_test_xdp_info(void)
 	if (CHECK(prog_id, "prog_id_drv", "unexpected prog_id=%u\n", prog_id))
 		goto out;
 
+	/* Check xdp features supported by lo device */
+	opts.fflags = ~0;
+	err = bpf_xdp_query(IFINDEX_LO, XDP_FLAGS_DRV_MODE, &opts);
+	if (!ASSERT_OK(err, "bpf_xdp_query"))
+		goto out;
+
+	ASSERT_EQ(opts.fflags, 0, "opts.fflags");
 out:
 	bpf_xdp_detach(IFINDEX_LO, 0, NULL);
 out_close:
-- 
2.39.1

