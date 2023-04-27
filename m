Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A3A6F06F3
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 16:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243710AbjD0OEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 10:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243687AbjD0OEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 10:04:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74934690;
        Thu, 27 Apr 2023 07:04:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D44B63D25;
        Thu, 27 Apr 2023 14:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D03C433D2;
        Thu, 27 Apr 2023 14:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682604258;
        bh=PVqEIORgYMewCOBcKdAZRUMx649Murxtz9FX/yndQpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxJbwbQ+Vr1bOE+YyG9We31TNk30TuHcnyL403NDoy+JyAksufFfjtIASZ/gul34q
         zpuKCoTLXr/kgCElOFFfLAsyBLOHhQx1aSBVPgyMCvuEQmZcRaEGTkMVrH5EmRy2jL
         lNmbOCfi3ExRWV11hI6y8VJg1aDPVFNGMkoujmPlqFLWrbXmGjyV6rn0v3SZXHwNVM
         /0iBX2Viu8c2AmrOgOxBI8KTCOvUpGZLy7aiPUdbbvIiW42I1iwwoe/GMXdpR+ZxcC
         GHwjq6K2VgM0htv5BbFvTG5eZcPHEAtnBGa1e6EEgPVKtCfAo/LNUW1UjNMnxNaxf6
         lzGPOYUP0nY0g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, bpf@vger.kernel.org,
        andrii@kernel.org, mykolal@fb.com, ast@kernel.org,
        daniel@iogearbox.net, martin.lau@linux.dev, alardam@gmail.com,
        memxor@gmail.com, sdf@google.com, brouer@redhat.com,
        toke@redhat.com
Subject: [PATCH net 2/2] selftests/bpf: add xdp_feature selftest for bond device
Date:   Thu, 27 Apr 2023 16:03:34 +0200
Message-Id: <b834b5a0c5e0e76a2ae34b1525a7761ef59c20d8.1682603719.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682603719.git.lorenzo@kernel.org>
References: <cover.1682603719.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.40.0

