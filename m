Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D3C560324
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiF2Ofc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiF2Of0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:35:26 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287D331358;
        Wed, 29 Jun 2022 07:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656513326; x=1688049326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gQrU2EruKNz5OjJ8adMk75A73f4PUnnz/N/FjkYep0I=;
  b=ShKMIALxF5+pT2bDzorncdWc/EobO6J0+QnigzR4m0TkzDGxfFtAa95x
   glx0c3W++fsxdPTVuXfCmMjojMVRaHxwtmRVFOno8b96u2Geu+2CoDb8w
   j3UG2Nd/bTs43SZ2f79NRhUOUyJEPHNhvbpq8HlCIsaSlz9O7BNfROeF3
   0BAGmUcLpM0dnSC5KvmghcXOBZCneX6zbC2TG6WMw6U+AVP1gJCXDUjX5
   n1chN1cht1djKjBEIUi0F0M8lUSC/tNb6I2oXEU3ySiDWR4Mk1HR+ameb
   FtSHFD/W4A5jv63oq8y1sj2XxBeUkvzVZHaiXB2QnOJociPwgld6BVj14
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="368357929"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="368357929"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 07:35:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="590765147"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 29 Jun 2022 07:35:24 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 2/4] selftests: xsk: introduce XDP prog load based on existing AF_XDP socket
Date:   Wed, 29 Jun 2022 16:34:56 +0200
Message-Id: <20220629143458.934337-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220629143458.934337-1-maciej.fijalkowski@intel.com>
References: <20220629143458.934337-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, xsk_setup_xdp_prog() uses anonymous xsk_socket struct which
means that during xsk_create_bpf_link() call, xsk->config.xdp_flags is
always 0. This in turn means that from xdpxceiver it is impossible to
use xdpgeneric attachment, so since commit 3b22523bca02 ("selftests,
xsk: Fix bpf_res cleanup test") we were not testing SKB mode at all.

To fix this, introduce a function, called xsk_setup_xdp_prog_xsk(), that
will load XDP prog based on the existing xsk_socket, so that xsk
context's refcount is correctly bumped and flags from application side
are respected. Use this from xdpxceiver side so we get coverage of
generic and native XDP program attach points.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 2 +-
 tools/testing/selftests/bpf/xsk.c        | 5 +++++
 tools/testing/selftests/bpf/xsk.h        | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 019c567b6b4e..c024aa91ea02 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -1130,7 +1130,7 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (!ifindex)
 		exit_with_error(errno);
 
-	ret = xsk_setup_xdp_prog(ifindex, &ifobject->xsk_map_fd);
+	ret = xsk_setup_xdp_prog_xsk(ifobject->xsk->xsk, &ifobject->xsk_map_fd);
 	if (ret)
 		exit_with_error(-ret);
 
diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
index fa13d2c44517..db911127720e 100644
--- a/tools/testing/selftests/bpf/xsk.c
+++ b/tools/testing/selftests/bpf/xsk.c
@@ -880,6 +880,11 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp, int *xsks_map_fd)
 	return err;
 }
 
+int xsk_setup_xdp_prog_xsk(struct xsk_socket *xsk, int *xsks_map_fd)
+{
+	return __xsk_setup_xdp_prog(xsk, xsks_map_fd);
+}
+
 static struct xsk_ctx *xsk_get_ctx(struct xsk_umem *umem, int ifindex,
 				   __u32 queue_id)
 {
diff --git a/tools/testing/selftests/bpf/xsk.h b/tools/testing/selftests/bpf/xsk.h
index 915e7135337c..997723b0bfb2 100644
--- a/tools/testing/selftests/bpf/xsk.h
+++ b/tools/testing/selftests/bpf/xsk.h
@@ -269,6 +269,7 @@ struct xsk_umem_config {
 	__u32 flags;
 };
 
+int xsk_setup_xdp_prog_xsk(struct xsk_socket *xsk, int *xsks_map_fd);
 int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd);
 int xsk_socket__update_xskmap(struct xsk_socket *xsk, int xsks_map_fd);
 
-- 
2.27.0

