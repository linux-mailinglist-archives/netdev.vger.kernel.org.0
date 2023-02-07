Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1B968D535
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 12:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjBGLL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 06:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBGLL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 06:11:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DE537545;
        Tue,  7 Feb 2023 03:11:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C83E36131F;
        Tue,  7 Feb 2023 11:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71B0C433D2;
        Tue,  7 Feb 2023 11:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675768286;
        bh=jl4PjawqucOASaz4y2Zdb4dsQGmfOCDQKtqdvhDPIDM=;
        h=From:To:Cc:Subject:Date:From;
        b=iswyT+O7g0zgjPAs5E7DOuLYNKNyn+1ZiDRcAKvlA8Tb7V3fMTjc5aF05YTABeFWB
         U5GmFroZfbm/bK7Xbakt0h5/J2nPHjGFrvjo9ZDaVbviPQ+qA8Q+Zp+q97e+KzNShi
         oDewa5IOKhaTgMhPxrA0ldMmvLGsqn0KBflA7fGvaZMCmlFYKHIKYd8SYCzjaI1DYZ
         mEsnPkOSEjaiBx2xLEtq/oKC3gQYaRCHWC21G9xaLyNOB4uCMnd6WllSzatr1h4S9g
         17qpgBHRwPa4xeEyTsdLO0fO0LtmGcP0FhsL9ZsZiANmMuqf0BU2ySvlDLJ9NAMzOS
         inoJf4VpR0xUQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, lorenzo.bianconi@redhat.com
Subject: [PATCH bpf-next] libbpf: always use libbpf_err to return an error in bpf_xdp_query()
Date:   Tue,  7 Feb 2023 12:11:03 +0100
Message-Id: <827d40181f9f90fb37702f44328e1614df7c0503.1675768112.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
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

In order to properly set errno, rely on libbpf_err utility routine in
bpf_xdp_query() to return an error to the caller.

Fixes: 04d58f1b26a4 ("libbpf: add API to get XDP/XSK supported features")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/lib/bpf/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 32b13b7a11b0..cb082a04ffa8 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -480,7 +480,7 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
 
 	err = nlattr_add(&req, NETDEV_A_DEV_IFINDEX, &ifindex, sizeof(ifindex));
 	if (err < 0)
-		return err;
+		return libbpf_err(err);
 
 	err = libbpf_netlink_send_recv(&req, NETLINK_GENERIC,
 				       parse_xdp_features, NULL, &md);
-- 
2.39.1

