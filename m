Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E1655EE30
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiF1TvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiF1Tuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:50 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F58A3A712;
        Tue, 28 Jun 2022 12:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445755; x=1687981755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KP8+M2ZNDj+bGLuKjD0DKVm/0e+VNysNArAnGfFt/hk=;
  b=VGZyeyQOA3ZQRhYZoUgIuckUwXOmqYutJY5+HNigN9K72rmhMp9INWeW
   Y+Bu/DjnkxucyGGLkc0SSrHB8RQ7um98prNg9NRbSolPPRu4AryaIQrKi
   /Glb9JT90jKwdiajo4fwKbKc4ASS0HAdC2wPv2wbwxrOr5bmH9BneQ2WU
   NdXMdeYR3dgkj3YethqmI+6aIKcvPylqTc/Rer+ImB0nUVjHLY95WJq0C
   5IqTdyUcSn4B1hl7wHqYqeVgAIWxsCyJliW0kzfVX0gUUVFntzuraTPAs
   TTyOP9AMRcu+GD9M4mobUsNdkgQmF79tKrRC3AVxfZn1ELTURWH5T79vu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282568081"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="282568081"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="680182439"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jun 2022 12:49:10 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9B022013;
        Tue, 28 Jun 2022 20:49:08 +0100
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
Subject: [PATCH RFC bpf-next 11/52] libbpf: factor out __bpf_set_link_xdp_fd_replace() args into a struct
Date:   Tue, 28 Jun 2022 21:47:31 +0200
Message-Id: <20220628194812.1453059-12-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Its argument list already consists of 4 entries, and there are more
to be added. It's convenient to add new opts as they are already
being passed using structs, but at the end the mentioned function
take all the opts one by one.
Place them into a local struct which will satisfy every initial call
site, so it will be now a matter of adding a new field and a
corresponding nlattr_add() to handle a new opt.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/lib/bpf/netlink.c | 60 ++++++++++++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index cbc8967d5402..3a25178d0d12 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -230,8 +230,15 @@ static int libbpf_netlink_send_recv(struct libbpf_nla_req *req,
 	return ret;
 }
 
-static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
-					 __u32 flags)
+struct __bpf_set_link_xdp_fd_opts {
+	int ifindex;
+	int fd;
+	int old_fd;
+	__u32 flags;
+};
+
+static int
+__bpf_set_link_xdp_fd_replace(const struct __bpf_set_link_xdp_fd_opts *opts)
 {
 	struct nlattr *nla;
 	int ret;
@@ -242,22 +249,23 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 	req.nh.nlmsg_flags    = NLM_F_REQUEST | NLM_F_ACK;
 	req.nh.nlmsg_type     = RTM_SETLINK;
 	req.ifinfo.ifi_family = AF_UNSPEC;
-	req.ifinfo.ifi_index  = ifindex;
+	req.ifinfo.ifi_index  = opts->ifindex;
 
 	nla = nlattr_begin_nested(&req, IFLA_XDP);
 	if (!nla)
 		return -EMSGSIZE;
-	ret = nlattr_add(&req, IFLA_XDP_FD, &fd, sizeof(fd));
+	ret = nlattr_add(&req, IFLA_XDP_FD, &opts->fd, sizeof(opts->fd));
 	if (ret < 0)
 		return ret;
-	if (flags) {
-		ret = nlattr_add(&req, IFLA_XDP_FLAGS, &flags, sizeof(flags));
+	if (opts->flags) {
+		ret = nlattr_add(&req, IFLA_XDP_FLAGS, &opts->flags,
+				 sizeof(opts->flags));
 		if (ret < 0)
 			return ret;
 	}
-	if (flags & XDP_FLAGS_REPLACE) {
-		ret = nlattr_add(&req, IFLA_XDP_EXPECTED_FD, &old_fd,
-				 sizeof(old_fd));
+	if (opts->flags & XDP_FLAGS_REPLACE) {
+		ret = nlattr_add(&req, IFLA_XDP_EXPECTED_FD, &opts->old_fd,
+				 sizeof(opts->old_fd));
 		if (ret < 0)
 			return ret;
 	}
@@ -268,18 +276,23 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 
 int bpf_xdp_attach(int ifindex, int prog_fd, __u32 flags, const struct bpf_xdp_attach_opts *opts)
 {
-	int old_prog_fd, err;
+	struct __bpf_set_link_xdp_fd_opts sl_opts = {
+		.ifindex = ifindex,
+		.flags = flags,
+		.fd = prog_fd,
+	};
+	int err;
 
 	if (!OPTS_VALID(opts, bpf_xdp_attach_opts))
 		return libbpf_err(-EINVAL);
 
-	old_prog_fd = OPTS_GET(opts, old_prog_fd, 0);
-	if (old_prog_fd)
+	sl_opts.old_fd = OPTS_GET(opts, old_prog_fd, 0);
+	if (sl_opts.old_fd)
 		flags |= XDP_FLAGS_REPLACE;
 	else
-		old_prog_fd = -1;
+		sl_opts.old_fd = -1;
 
-	err = __bpf_set_link_xdp_fd_replace(ifindex, prog_fd, old_prog_fd, flags);
+	err = __bpf_set_link_xdp_fd_replace(&sl_opts);
 	return libbpf_err(err);
 }
 
@@ -291,25 +304,36 @@ int bpf_xdp_detach(int ifindex, __u32 flags, const struct bpf_xdp_attach_opts *o
 int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
 			     const struct bpf_xdp_set_link_opts *opts)
 {
-	int old_fd = -1, ret;
+	struct __bpf_set_link_xdp_fd_opts sl_opts = {
+		.ifindex = ifindex,
+		.flags = flags,
+		.old_fd = -1,
+		.fd = fd,
+	};
+	int ret;
 
 	if (!OPTS_VALID(opts, bpf_xdp_set_link_opts))
 		return libbpf_err(-EINVAL);
 
 	if (OPTS_HAS(opts, old_fd)) {
-		old_fd = OPTS_GET(opts, old_fd, -1);
+		sl_opts.old_fd = OPTS_GET(opts, old_fd, -1);
 		flags |= XDP_FLAGS_REPLACE;
 	}
 
-	ret = __bpf_set_link_xdp_fd_replace(ifindex, fd, old_fd, flags);
+	ret = __bpf_set_link_xdp_fd_replace(&sl_opts);
 	return libbpf_err(ret);
 }
 
 int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 {
+	struct __bpf_set_link_xdp_fd_opts sl_opts = {
+		.ifindex = ifindex,
+		.flags = flags,
+		.fd = fd,
+	};
 	int ret;
 
-	ret = __bpf_set_link_xdp_fd_replace(ifindex, fd, 0, flags);
+	ret = __bpf_set_link_xdp_fd_replace(&sl_opts);
 	return libbpf_err(ret);
 }
 
-- 
2.36.1

