Return-Path: <netdev+bounces-3358-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 254D4706A15
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:42:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4B101C20F42
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F01D323D59;
	Wed, 17 May 2023 13:41:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF3B18B17;
	Wed, 17 May 2023 13:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB592C433EF;
	Wed, 17 May 2023 13:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684330914;
	bh=TL5r4qhrusoNkBXego/GgughnB7vFvifa0eMTc124jA=;
	h=From:To:Cc:Subject:Date:From;
	b=mthQ3UD5cWdXWSyBCeCh+mZUQdHGsrVDMwELcjoxg0iUDJlq6w7uLOJpRWVbab9Rw
	 dPE1/lrAbnOAVCRS5GGr2gtKJPz8YR5QIFnz9zljc4dKNQyAf3mM5D7ok0ooioxAWl
	 yjuD718RN1GREVbqFrvMPf3ncdPAL0XtAdcKNG8sk8W/W4JLjpfu9+ziP3T5hZ4Lps
	 NtEehgBu4vKlxznQjzVvQQ7nCO0xENXBaahmqASSjtCQtyueMA8yA6cXuJGUDSaT8J
	 GctYDIFoa0mnHM+qKyEpQzNiqoSeC77n6/8tYg4ykPmgLpSKj79Byyl4Dt612f9hSD
	 n5hiR6sXErIPg==
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: bpf@vger.kernel.org
Cc: lorenzo.bianconi@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH bpf-next] selftests/bpf: add xdp_feature selftest for bond device
Date: Wed, 17 May 2023 15:41:33 +0200
Message-Id: <64cb8f20e6491f5b971f8d3129335093c359aad7.1684329998.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce selftests to check xdp_feature support for bond driver.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../selftests/bpf/prog_tests/xdp_bonding.c    | 121 ++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
index d19f79048ff6..c3b45745cbcc 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
@@ -18,6 +18,7 @@
 #include <linux/if_bonding.h>
 #include <linux/limits.h>
 #include <linux/udp.h>
+#include <uapi/linux/netdev.h>
 
 #include "xdp_dummy.skel.h"
 #include "xdp_redirect_multi_kern.skel.h"
@@ -492,6 +493,123 @@ static void test_xdp_bonding_nested(struct skeletons *skeletons)
 	system("ip link del bond_nest2");
 }
 
+static void test_xdp_bonding_features(struct skeletons *skeletons)
+{
+	LIBBPF_OPTS(bpf_xdp_query_opts, query_opts);
+	int bond_idx, veth1_idx, err;
+	struct bpf_link *link = NULL;
+
+	if (!ASSERT_OK(system("ip link add bond type bond"), "add bond"))
+		goto out;
+
+	bond_idx = if_nametoindex("bond");
+	if (!ASSERT_GE(bond_idx, 0, "if_nametoindex bond"))
+		goto out;
+
+	/* query default xdp-feature for bond device */
+	err = bpf_xdp_query(bond_idx, XDP_FLAGS_DRV_MODE, &query_opts);
+	if (!ASSERT_OK(err, "bond bpf_xdp_query"))
+		goto out;
+
+	if (!ASSERT_EQ(query_opts.feature_flags, NETDEV_XDP_ACT_MASK,
+		       "bond query_opts.feature_flags"))
+		goto out;
+
+	if (!ASSERT_OK(system("ip link add veth0 type veth peer name veth1"),
+		       "add veth{0,1} pair"))
+		goto out;
+
+	if (!ASSERT_OK(system("ip link add veth2 type veth peer name veth3"),
+		       "add veth{2,3} pair"))
+		goto out;
+
+	if (!ASSERT_OK(system("ip link set veth0 master bond"),
+		       "add veth0 to master bond"))
+		goto out;
+
+	/* xdp-feature for bond device should be obtained from the single slave
+	 * device (veth0)
+	 */
+	err = bpf_xdp_query(bond_idx, XDP_FLAGS_DRV_MODE, &query_opts);
+	if (!ASSERT_OK(err, "bond bpf_xdp_query"))
+		goto out;
+
+	if (!ASSERT_EQ(query_opts.feature_flags,
+		       NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+		       NETDEV_XDP_ACT_RX_SG,
+		       "bond query_opts.feature_flags"))
+		goto out;
+
+	veth1_idx = if_nametoindex("veth1");
+	if (!ASSERT_GE(veth1_idx, 0, "if_nametoindex veth1"))
+		goto out;
+
+	link = bpf_program__attach_xdp(skeletons->xdp_dummy->progs.xdp_dummy_prog,
+				       veth1_idx);
+	if (!ASSERT_OK_PTR(link, "attach program to veth1"))
+		goto out;
+
+	/* xdp-feature for veth0 are changed */
+	err = bpf_xdp_query(bond_idx, XDP_FLAGS_DRV_MODE, &query_opts);
+	if (!ASSERT_OK(err, "bond bpf_xdp_query"))
+		goto out;
+
+	if (!ASSERT_EQ(query_opts.feature_flags,
+		       NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+		       NETDEV_XDP_ACT_RX_SG | NETDEV_XDP_ACT_NDO_XMIT |
+		       NETDEV_XDP_ACT_NDO_XMIT_SG,
+		       "bond query_opts.feature_flags"))
+		goto out;
+
+	if (!ASSERT_OK(system("ip link set veth2 master bond"),
+		       "add veth2 to master bond"))
+		goto out;
+
+	err = bpf_xdp_query(bond_idx, XDP_FLAGS_DRV_MODE, &query_opts);
+	if (!ASSERT_OK(err, "bond bpf_xdp_query"))
+		goto out;
+
+	/* xdp-feature for bond device should be set to the most restrict
+	 * value obtained from attached slave devices (veth0 and veth2)
+	 */
+	if (!ASSERT_EQ(query_opts.feature_flags,
+		       NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+		       NETDEV_XDP_ACT_RX_SG,
+		       "bond query_opts.feature_flags"))
+		goto out;
+
+	if (!ASSERT_OK(system("ip link set veth2 nomaster"),
+		       "del veth2 to master bond"))
+		goto out;
+
+	err = bpf_xdp_query(bond_idx, XDP_FLAGS_DRV_MODE, &query_opts);
+	if (!ASSERT_OK(err, "bond bpf_xdp_query"))
+		goto out;
+
+	if (!ASSERT_EQ(query_opts.feature_flags,
+		       NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+		       NETDEV_XDP_ACT_RX_SG | NETDEV_XDP_ACT_NDO_XMIT |
+		       NETDEV_XDP_ACT_NDO_XMIT_SG,
+		       "bond query_opts.feature_flags"))
+		goto out;
+
+	if (!ASSERT_OK(system("ip link set veth0 nomaster"),
+		       "del veth0 to master bond"))
+		goto out;
+
+	err = bpf_xdp_query(bond_idx, XDP_FLAGS_DRV_MODE, &query_opts);
+	if (!ASSERT_OK(err, "bond bpf_xdp_query"))
+		goto out;
+
+	ASSERT_EQ(query_opts.feature_flags, NETDEV_XDP_ACT_MASK,
+		  "bond query_opts.feature_flags");
+out:
+	bpf_link__destroy(link);
+	system("ip link del veth0");
+	system("ip link del veth2");
+	system("ip link del bond");
+}
+
 static int libbpf_debug_print(enum libbpf_print_level level,
 			      const char *format, va_list args)
 {
@@ -546,6 +664,9 @@ void serial_test_xdp_bonding(void)
 	if (test__start_subtest("xdp_bonding_nested"))
 		test_xdp_bonding_nested(&skeletons);
 
+	if (test__start_subtest("xdp_bonding_features"))
+		test_xdp_bonding_features(&skeletons);
+
 	for (i = 0; i < ARRAY_SIZE(bond_test_cases); i++) {
 		struct bond_test_case *test_case = &bond_test_cases[i];
 
-- 
2.40.1


