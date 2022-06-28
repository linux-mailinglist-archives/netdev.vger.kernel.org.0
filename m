Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3850B55EE6B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbiF1Tvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiF1Tuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:52 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144CB3A71C;
        Tue, 28 Jun 2022 12:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445762; x=1687981762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V/LelW6Mb5Cc8sNSdQPVZg4VOEAQ0MECgTTL8gSA07g=;
  b=aJa6bknhYwbF4rMjA/gztvpXrCxKIUFAH4+Tqj9UYtaStH0OiQsCBGhf
   P9fJB2VcIKAva1Rc5TuWO7KLE54Rp/B5LGJfaRpNsgYai6lUfNiqrzm+9
   vcksegu+CK4OiAktBZ5DRQrylc67bJvbW5ul1uYpVN3N7CLT2i3mTUL5Y
   DaC+OVrGwYSENbix6+3JKbAnGaz9Bs6za65kWWUCBX+PMnNWhdm0btCuq
   69ahgG8dmntXw6PEvovMBkdQT5viMOBJItwyjdiYmFQkdOPJl1lMnQNQ9
   sq/AEuPOVG9IM25G91T7o3zFZO+GfaJaYRX7aqltaj2CA5OrlV9FYj1FR
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="264874102"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="264874102"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="767288073"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2022 12:49:17 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9G022013;
        Tue, 28 Jun 2022 20:49:15 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 16/52] selftests/bpf: expand xdp_link to check that setting meta opts works
Date:   Tue, 28 Jun 2022 21:47:36 +0200
Message-Id: <20220628194812.1453059-17-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a check in xdp_link to ensure that the values of btf_id and
meta_thresh gotten via bpf_obj_get_info_by_fd() is the same as was
passed via bpf_link_update(). Plus, that the kernel should fail to
set btf_id to 0 when meta_thresh != 0.
Also, use the new bpf_program__attach_xdp_opts() instead of the
non-optsed version and set the initial metadata threshold value
to check whether the kernel is able to process this request.
When the threshold is being set via the Netlink interface, it's
not being stored anywhere in the kernel core, so no test for it.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 .../selftests/bpf/prog_tests/xdp_link.c       | 30 +++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_link.c b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
index 3e9d5c5521f0..0723278c448f 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_link.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
@@ -10,6 +10,7 @@ void serial_test_xdp_link(void)
 {
 	struct test_xdp_link *skel1 = NULL, *skel2 = NULL;
 	__u32 id1, id2, id0 = 0, prog_fd1, prog_fd2;
+	LIBBPF_OPTS(bpf_link_update_opts, lu_opts);
 	LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
 	struct bpf_link_info link_info;
 	struct bpf_prog_info prog_info;
@@ -103,8 +104,16 @@ void serial_test_xdp_link(void)
 	bpf_link__destroy(skel1->links.xdp_handler);
 	skel1->links.xdp_handler = NULL;
 
+	opts.old_prog_fd = 0;
+	opts.meta_thresh = 128;
+
+	err = libbpf_get_type_btf_id("struct xdp_meta_generic", &opts.btf_id);
+	if (!ASSERT_OK(err, "libbpf_get_type_btf_id"))
+		goto cleanup;
+
 	/* new link attach should succeed */
-	link = bpf_program__attach_xdp(skel2->progs.xdp_handler, IFINDEX_LO);
+	link = bpf_program__attach_xdp_opts(skel2->progs.xdp_handler,
+					    IFINDEX_LO, &opts);
 	if (!ASSERT_OK_PTR(link, "link_attach"))
 		goto cleanup;
 	skel2->links.xdp_handler = link;
@@ -113,11 +122,25 @@ void serial_test_xdp_link(void)
 	if (!ASSERT_OK(err, "id2_check_err") || !ASSERT_EQ(id0, id2, "id2_check_val"))
 		goto cleanup;
 
+	lu_opts.xdp.new_meta_thresh = 256;
+	lu_opts.xdp.new_btf_id = opts.btf_id;
+
 	/* updating program under active BPF link works as expected */
-	err = bpf_link__update_program(link, skel1->progs.xdp_handler);
+	err = bpf_link_update(bpf_link__fd(link),
+			      bpf_program__fd(skel1->progs.xdp_handler),
+			      &lu_opts);
 	if (!ASSERT_OK(err, "link_upd"))
 		goto cleanup;
 
+	lu_opts.xdp.new_btf_id = 0;
+
+	/* BTF ID can't be 0 when meta_thresh != 0, and vice versa */
+	err = bpf_link_update(bpf_link__fd(link),
+			      bpf_program__fd(skel1->progs.xdp_handler),
+			      &lu_opts);
+	if (!ASSERT_ERR(err, "link_upd_fail"))
+		goto cleanup;
+
 	memset(&link_info, 0, sizeof(link_info));
 	err = bpf_obj_get_info_by_fd(bpf_link__fd(link), &link_info, &link_info_len);
 	if (!ASSERT_OK(err, "link_info"))
@@ -126,6 +149,9 @@ void serial_test_xdp_link(void)
 	ASSERT_EQ(link_info.type, BPF_LINK_TYPE_XDP, "link_type");
 	ASSERT_EQ(link_info.prog_id, id1, "link_prog_id");
 	ASSERT_EQ(link_info.xdp.ifindex, IFINDEX_LO, "link_ifindex");
+	ASSERT_EQ(link_info.xdp.btf_id, opts.btf_id, "btf_id");
+	ASSERT_EQ(link_info.xdp.meta_thresh, lu_opts.xdp.new_meta_thresh,
+		  "meta_thresh");
 
 	/* updating program under active BPF link with different type fails */
 	err = bpf_link__update_program(link, skel1->progs.tc_handler);
-- 
2.36.1

