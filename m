Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9597E6E2BAA
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 23:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjDNVV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 17:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjDNVV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 17:21:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A00194;
        Fri, 14 Apr 2023 14:21:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A20C464A51;
        Fri, 14 Apr 2023 21:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33C9C433EF;
        Fri, 14 Apr 2023 21:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681507317;
        bh=9Uh2fi0S2RpdOG1SPYvlG9TdwMqnDH0hbJiy3mgDCJM=;
        h=From:To:Cc:Subject:Date:From;
        b=nZ3kqqLPKDDuA/8JQBa8dlg4LempcXEzx+rtjL1CeqsV+ksKwx5+hDaiKtx5FUZUq
         fdME9sQODoUe53JDCEsws5dyyzI0Xb5cGEye01wscbexMdJGEWgYsgadkDY85Ga9Oo
         +USIBYOn+PaKuLPOoiMOL1vOGy2H3HJIVJ3hgu2cVUpMaRi65N9Ie0ynsnBofu+Iyc
         JjSVafCQQF+wiBko1d8H0ksg245+RcPJxVasYDkPGwhhzgx1EE5HfPbxZhzYo2ODi9
         zID0JisPFroMSBPon1RgKK7upO14lGhmF9EHf6/jJKqMBfsWECB9yRL4DnzbWe2Kbb
         Fh2ldEGWIZHxQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, joamaki@gmail.com
Subject: [PATCH bpf] selftests/bpf: fix xdp_redirect xdp-features for xdp_bonding selftest
Date:   Fri, 14 Apr 2023 23:21:43 +0200
Message-Id: <73f0028461c4f3fa577e24d8d797ddd76f1d17c6.1681507058.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NETDEV_XDP_ACT_NDO_XMIT is not enabled by default for veth driver but it
depends on the device configuration. Fix XDP_REDIRECT xdp-features in
xdp_bonding selftest loading a dummy XDP program on veth2_2 device.

Fixes: fccca038f300 ("veth: take into account device reconfiguration for xdp_features flag")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/xdp_bonding.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
index 5e3a26b15ec6..dcbe30c81291 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
@@ -168,6 +168,17 @@ static int bonding_setup(struct skeletons *skeletons, int mode, int xmit_policy,
 
 		if (xdp_attach(skeletons, skeletons->xdp_dummy->progs.xdp_dummy_prog, "veth1_2"))
 			return -1;
+
+		if (!ASSERT_OK(setns_by_name("ns_dst"), "set netns to ns_dst"))
+			return -1;
+
+		/* Load a dummy XDP program on veth2_2 in order to enable
+		 * NETDEV_XDP_ACT_NDO_XMIT feature
+		 */
+		if (xdp_attach(skeletons, skeletons->xdp_dummy->progs.xdp_dummy_prog, "veth2_2"))
+			return -1;
+
+		restore_root_netns();
 	}
 
 	SYS("ip -netns ns_dst link set veth2_1 master bond2");
-- 
2.39.2

