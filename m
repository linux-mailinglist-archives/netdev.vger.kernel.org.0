Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE6855EEB2
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbiF1Tvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiF1Tuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:52 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB03E3A718;
        Tue, 28 Jun 2022 12:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445760; x=1687981760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Br7PA2LhyRZLtGRuJC1NdDKYX7AsconXTD56haHkAIc=;
  b=gMf7pQgWoNgVnc+Lnz/9QCg6nQ1Qj0YebyBl/ga5IDMfduefkTNc4A/b
   IYEgF47Yl13KGqt5qVfroNTNsQS0L31w61lr5IufzRylvYyvDQr6pIGfs
   kD1v88+X45LzxpJFfe7D6vfhxakvSVdKkkxzXVpbMR7QCGST/czfOexuZ
   WBTs/GU9yDRV5N3YD/cdHY/qjSXz+B7DigtQ1Dq4F9GXdkYstX1jsOatx
   tscKnMFNA1WGzvjNUVpndjMFU+6EE6nKrIbdk3mV1DSJg8zCtvO7HVYet
   UDApQS1hED7OqgwzJxoG+WmO4yPo0EdU+gxo4g9QLRRDM7/w8leIb7AtR
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282927787"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="282927787"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="540598913"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 28 Jun 2022 12:49:15 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9F022013;
        Tue, 28 Jun 2022 20:49:14 +0100
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
Subject: [PATCH RFC bpf-next 15/52] libbpf: add bpf_program__attach_xdp_opts()
Date:   Tue, 28 Jun 2022 21:47:35 +0200
Message-Id: <20220628194812.1453059-16-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
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

Add a version of bpf_program__attach_xdp() which can take an
optional pointer to &bpf_xdp_attach_opts to carry opts from it to
bpf_link_create(), primarily to be able to specify a BTF/type ID and
a metadata threshold when attaching an XDP program.
This struct is originally designed for bpf_xdp_{at,de}tach(), reuse
it here as well to not spawn entities (with ::old_prog_fd reused for
XDP flags via union).

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/lib/bpf/libbpf.c   | 16 ++++++++++++++++
 tools/lib/bpf/libbpf.h   | 27 ++++++++++++++++++---------
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f4014c09f1cf..b6cc238a2657 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -12010,6 +12010,22 @@ struct bpf_link *bpf_program__attach_xdp(const struct bpf_program *prog, int ifi
 	return bpf_program__attach_fd(prog, ifindex, NULL, "xdp");
 }
 
+struct bpf_link *
+bpf_program__attach_xdp_opts(const struct bpf_program *prog, int ifindex,
+			     const struct bpf_xdp_attach_opts *opts)
+{
+	LIBBPF_OPTS(bpf_link_create_opts, lc_opts);
+
+	if (!OPTS_VALID(opts, bpf_xdp_attach_opts))
+		return libbpf_err_ptr(-EINVAL);
+
+	lc_opts.flags = OPTS_GET(opts, flags, 0);
+	lc_opts.xdp.btf_id = OPTS_GET(opts, btf_id, 0);
+	lc_opts.xdp.meta_thresh = OPTS_GET(opts, meta_thresh, 0);
+
+	return bpf_program__attach_fd(prog, ifindex, &lc_opts, "xdp");
+}
+
 struct bpf_link *bpf_program__attach_freplace(const struct bpf_program *prog,
 					      int target_fd,
 					      const char *attach_func_name)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 99ac94f148fc..d6dd05b5b753 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -678,8 +678,26 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_cgroup(const struct bpf_program *prog, int cgroup_fd);
 LIBBPF_API struct bpf_link *
 bpf_program__attach_netns(const struct bpf_program *prog, int netns_fd);
+
+struct bpf_xdp_attach_opts {
+	size_t sz;
+	union {
+		int old_prog_fd;
+		/* for bpf_program__attach_xdp_opts() */
+		__u32 flags;
+	};
+	__u32 meta_thresh;
+	__u64 btf_id;
+	size_t :0;
+};
+#define bpf_xdp_attach_opts__last_field btf_id
+
 LIBBPF_API struct bpf_link *
 bpf_program__attach_xdp(const struct bpf_program *prog, int ifindex);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_xdp_opts(const struct bpf_program *prog, int ifindex,
+			     const struct bpf_xdp_attach_opts *opts);
+
 LIBBPF_API struct bpf_link *
 bpf_program__attach_freplace(const struct bpf_program *prog,
 			     int target_fd, const char *attach_func_name);
@@ -1210,15 +1228,6 @@ LIBBPF_DEPRECATED_SINCE(0, 8, "use bpf_xdp_query() instead")
 LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 				     size_t info_size, __u32 flags);
 
-struct bpf_xdp_attach_opts {
-	size_t sz;
-	int old_prog_fd;
-	__u32 meta_thresh;
-	__u64 btf_id;
-	size_t :0;
-};
-#define bpf_xdp_attach_opts__last_field btf_id
-
 struct bpf_xdp_query_opts {
 	size_t sz;
 	__u32 prog_id;		/* output */
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index f0987df15b7a..d14bbf82e37c 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -464,6 +464,7 @@ LIBBPF_1.0.0 {
 	global:
 		btf__add_enum64;
 		btf__add_enum64_value;
+		bpf_program__attach_xdp_opts;
 		libbpf_bpf_attach_type_str;
 		libbpf_bpf_link_type_str;
 		libbpf_bpf_map_type_str;
-- 
2.36.1

