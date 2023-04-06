Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762936D9449
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 12:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbjDFKkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 06:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjDFKk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 06:40:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFD555A6;
        Thu,  6 Apr 2023 03:40:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D99B644CD;
        Thu,  6 Apr 2023 10:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30974C433D2;
        Thu,  6 Apr 2023 10:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680777627;
        bh=12VeyPDe+foPT2W8xQk6q7Ek5sPvYoGsogLUhvcCStg=;
        h=From:To:Cc:Subject:Date:From;
        b=Ach5uNTOd/eHW/9O0UqJwlinYtGIxLA84ajugKUUa84tKnxGvgxbXX72JqyRVF5o1
         rVW83AES62pxtLMJe2gCinG9igzL9oNuaQAmsqQEupVM0YbUor1fsevyyibyeJwuz+
         wYaK1QIhWxmB+MlSUTOMViL1v6WlSrTO851qbNlnC7gi80qvYTPwfhWF9V/9ePCOm/
         ZltvZWkNrgE5GXCLKulW8WBnk+gI1J8KVFH+Zb2kdmglITkj2Bb5w+RwPIH/uqoOq0
         7LxvFK7fiEIBvGqGpwBaQbpteTk33Z7W9Lb0VcCd/IVWrJkRAnQ1BiIf/Kg2oZ9r77
         NKBd9mWgHny6g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        martin.lau@linux.dev, lorenzo.bianconi@redhat.com,
        andrii@kernel.org
Subject: [PATCH bpf] selftests/bpf: fix xdp_redirect xdp-features selftest for veth driver
Date:   Thu,  6 Apr 2023 12:40:19 +0200
Message-Id: <bc35455cfbb1d4f7f52536955ded81ad47d8dc54.1680777371.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp-features supported by veth driver are no more static, but they
depends on veth configuration (e.g. if GRO is enabled/disabled or
TX/RX queue configuration). Take it into account in xdp_redirect
xdp-features selftest for veth driver.

Fixes: fccca038f300 ("veth: take into account device reconfiguration for xdp_features flag")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../bpf/prog_tests/xdp_do_redirect.c          | 30 +++++++++++++++++--
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
index 7271a18ab3e2..8251a0fc6ee9 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -167,8 +167,7 @@ void test_xdp_do_redirect(void)
 
 	if (!ASSERT_EQ(query_opts.feature_flags,
 		       NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
-		       NETDEV_XDP_ACT_NDO_XMIT | NETDEV_XDP_ACT_RX_SG |
-		       NETDEV_XDP_ACT_NDO_XMIT_SG,
+		       NETDEV_XDP_ACT_RX_SG,
 		       "veth_src query_opts.feature_flags"))
 		goto out;
 
@@ -176,11 +175,36 @@ void test_xdp_do_redirect(void)
 	if (!ASSERT_OK(err, "veth_dst bpf_xdp_query"))
 		goto out;
 
+	if (!ASSERT_EQ(query_opts.feature_flags,
+		       NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+		       NETDEV_XDP_ACT_RX_SG,
+		       "veth_dst query_opts.feature_flags"))
+		goto out;
+
+	/* Enable GRO */
+	SYS("ethtool -K veth_src gro on");
+	SYS("ethtool -K veth_dst gro on");
+
+	err = bpf_xdp_query(ifindex_src, XDP_FLAGS_DRV_MODE, &query_opts);
+	if (!ASSERT_OK(err, "veth_src bpf_xdp_query gro on"))
+		goto out;
+
 	if (!ASSERT_EQ(query_opts.feature_flags,
 		       NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
 		       NETDEV_XDP_ACT_NDO_XMIT | NETDEV_XDP_ACT_RX_SG |
 		       NETDEV_XDP_ACT_NDO_XMIT_SG,
-		       "veth_dst query_opts.feature_flags"))
+		       "veth_src query_opts.feature_flags gro on"))
+		goto out;
+
+	err = bpf_xdp_query(ifindex_dst, XDP_FLAGS_DRV_MODE, &query_opts);
+	if (!ASSERT_OK(err, "veth_dst bpf_xdp_query gro on"))
+		goto out;
+
+	if (!ASSERT_EQ(query_opts.feature_flags,
+		       NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+		       NETDEV_XDP_ACT_NDO_XMIT | NETDEV_XDP_ACT_RX_SG |
+		       NETDEV_XDP_ACT_NDO_XMIT_SG,
+		       "veth_dst query_opts.feature_flags gro on"))
 		goto out;
 
 	memcpy(skel->rodata->expect_dst, &pkt_udp.eth.h_dest, ETH_ALEN);
-- 
2.39.2

