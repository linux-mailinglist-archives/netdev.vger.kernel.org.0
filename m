Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E029955EE44
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbiF1Tva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiF1Tuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:51 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D963819E;
        Tue, 28 Jun 2022 12:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445759; x=1687981759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KvcLFlvO+Aq/YsYPMNHuBin8lYDZ9TRXn0mscwW8tkw=;
  b=V/GfsjM42m5u0YL8eT/47JtQYYGDQRC66vGuDwGm1YaPkTMBNAWg7Zqf
   HLFUuExKiaV1DwQllpe5oZ34TrnSPeNGUYwCW6j4sKDGFVSmIyEBoYLRs
   WehCNUsq3ASxJx8ow52d1FNZxPkFYAZ1plDzsUN1SycIbVwXxVv5EkKkC
   Qft/Rm6l2JB93rgN1aA9kjLIa881RZHv63QEZZIM8BhId8ze+uevxSB8e
   /GtWCVjYsHb/p7SjO4nyZp+0w75/Efoz+iSp9VZLcDyEbPVz29hnksg0O
   +5B3DV+jcvvUc/RQt27x96ECRgGCoedzj9etYCSsE9usQo+8K8xLRAmun
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="343523213"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="343523213"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="717555046"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 28 Jun 2022 12:49:14 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9E022013;
        Tue, 28 Jun 2022 20:49:12 +0100
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
Subject: [PATCH RFC bpf-next 14/52] libbpf: pass &bpf_link_create_opts directly to bpf_program__attach_fd()
Date:   Tue, 28 Jun 2022 21:47:34 +0200
Message-Id: <20220628194812.1453059-15-alexandr.lobakin@intel.com>
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

Instead of providing an optional @btf_id which is zero in 3 of 4
cases as an argument, pass a pointer to &bpf_link_create_ops
directly instead. This way we can just pass %NULL when no opts are
needed and use any of its fields on our wish otherwise.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/lib/bpf/libbpf.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9bda111c8167..f4014c09f1cf 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -11958,11 +11958,10 @@ static int attach_lsm(const struct bpf_program *prog, long cookie, struct bpf_li
 }
 
 static struct bpf_link *
-bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id,
+bpf_program__attach_fd(const struct bpf_program *prog, int target_fd,
+		       const struct bpf_link_create_opts *opts,
 		       const char *target_name)
 {
-	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
-			    .target_btf_id = btf_id);
 	enum bpf_attach_type attach_type;
 	char errmsg[STRERR_BUFSIZE];
 	struct bpf_link *link;
@@ -11980,7 +11979,7 @@ bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id
 	link->detach = &bpf_link__detach_fd;
 
 	attach_type = bpf_program__expected_attach_type(prog);
-	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, &opts);
+	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, opts);
 	if (link_fd < 0) {
 		link_fd = -errno;
 		free(link);
@@ -11996,19 +11995,19 @@ bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id
 struct bpf_link *
 bpf_program__attach_cgroup(const struct bpf_program *prog, int cgroup_fd)
 {
-	return bpf_program__attach_fd(prog, cgroup_fd, 0, "cgroup");
+	return bpf_program__attach_fd(prog, cgroup_fd, NULL, "cgroup");
 }
 
 struct bpf_link *
 bpf_program__attach_netns(const struct bpf_program *prog, int netns_fd)
 {
-	return bpf_program__attach_fd(prog, netns_fd, 0, "netns");
+	return bpf_program__attach_fd(prog, netns_fd, NULL, "netns");
 }
 
 struct bpf_link *bpf_program__attach_xdp(const struct bpf_program *prog, int ifindex)
 {
 	/* target_fd/target_ifindex use the same field in LINK_CREATE */
-	return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
+	return bpf_program__attach_fd(prog, ifindex, NULL, "xdp");
 }
 
 struct bpf_link *bpf_program__attach_freplace(const struct bpf_program *prog,
@@ -12030,11 +12029,16 @@ struct bpf_link *bpf_program__attach_freplace(const struct bpf_program *prog,
 	}
 
 	if (target_fd) {
+		LIBBPF_OPTS(bpf_link_create_opts, opts);
+
 		btf_id = libbpf_find_prog_btf_id(attach_func_name, target_fd);
 		if (btf_id < 0)
 			return libbpf_err_ptr(btf_id);
 
-		return bpf_program__attach_fd(prog, target_fd, btf_id, "freplace");
+		opts.target_btf_id = btf_id;
+
+		return bpf_program__attach_fd(prog, target_fd, &opts,
+					      "freplace");
 	} else {
 		/* no target, so use raw_tracepoint_open for compatibility
 		 * with old kernels
-- 
2.36.1

