Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8733E55EE84
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiF1TvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbiF1Tuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:50 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1573A715;
        Tue, 28 Jun 2022 12:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445757; x=1687981757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TNfBgVKLQyn2LgZtWghMUTiye2sgpvYA6TvdfH/NL10=;
  b=fquriFWpmeUuj/t+DBAb6GdrZkHwE7Wiq9kNGOGKyngzfCbwckFZoV4w
   0WfecC5+zO/EmKCtMUA8ZSrVzCca3OWtfkinhg3EOFHas5XWk7ZFBKg99
   xT0WkGJOPn8Qmw1Ab4+BSR0D6ILhrMPxsb/FLWIa+f3heumivQKrJsXIY
   OTP/RhxsBxDVgIsieZIm6RY4IWQ+v/LXSWlcpTVj4v+ahEqp+3I9gbscf
   zHK6p2VQm238Gnbfb628I61Dua9PkGCWHCxydbw+Ch3h8wbeNntdVML33
   LGsqeXls5OIqmyQtZ7AGPf2rkPlf+eVaIaVwZ7hakL63ZmO1tVqJSUZrI
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="281869513"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="281869513"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="587988501"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 28 Jun 2022 12:49:11 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9C022013;
        Tue, 28 Jun 2022 20:49:10 +0100
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
Subject: [PATCH RFC bpf-next 12/52] libbpf: add ability to set the BTF/type ID on setting XDP prog
Date:   Tue, 28 Jun 2022 21:47:32 +0200
Message-Id: <20220628194812.1453059-13-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Covered functions:
 * bpf_link_create() - via &bpf_link_create_ops;
 * bpf_link_update() - via &bpf_link_update_ops;
 * bpf_xdp_attach() - via &bpf_xdp_attach_ops;
 * bpf_set_link_xdp_fd_opts() - via &bpf_xdp_set_link_opts;

bpf_link_update() got the ability to pass arbitrary link
type-specific data to the kernel, not just the old and new FDs.
No support for bpf_get_link_xdp_info()/&xdp_link_info as we store
additional data such as flags and BTF ID in the kernel in BPF link
mode only.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/lib/bpf/bpf.c     | 19 +++++++++++++++++++
 tools/lib/bpf/bpf.h     | 16 +++++++++++++++-
 tools/lib/bpf/libbpf.h  |  8 ++++++--
 tools/lib/bpf/netlink.c | 11 +++++++++++
 4 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 240186aac8e6..6036dc75cc7b 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -805,6 +805,11 @@ int bpf_link_create(int prog_fd, int target_fd,
 		if (!OPTS_ZEROED(opts, tracing))
 			return libbpf_err(-EINVAL);
 		break;
+	case BPF_XDP:
+		attr.link_create.xdp.btf_id = OPTS_GET(opts, xdp.btf_id, 0);
+		if (!OPTS_ZEROED(opts, xdp))
+			return libbpf_err(-EINVAL);
+		break;
 	default:
 		if (!OPTS_ZEROED(opts, flags))
 			return libbpf_err(-EINVAL);
@@ -872,6 +877,20 @@ int bpf_link_update(int link_fd, int new_prog_fd,
 	attr.link_update.flags = OPTS_GET(opts, flags, 0);
 	attr.link_update.old_prog_fd = OPTS_GET(opts, old_prog_fd, 0);
 
+	/* As the union in both @attr and @opts is unnamed, just use a pointer
+	 * to any of its members to copy the whole rest of the union/opts
+	 */
+	if (opts && opts->sz > offsetof(typeof(*opts), xdp)) {
+		__u32 attr_left, opts_left;
+
+		attr_left = sizeof(attr.link_update) -
+			    offsetof(typeof(attr.link_update), xdp);
+		opts_left = opts->sz - offsetof(typeof(*opts), xdp);
+
+		memcpy(&attr.link_update.xdp, &opts->xdp,
+		       min(attr_left, opts_left));
+	}
+
 	ret = sys_bpf(BPF_LINK_UPDATE, &attr, sizeof(attr));
 	return libbpf_err_errno(ret);
 }
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index cabc03703e29..4e17995fdaff 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -382,6 +382,10 @@ struct bpf_link_create_opts {
 		struct {
 			__u64 cookie;
 		} tracing;
+		struct {
+			/* target metadata BTF + type ID */
+			__aligned_u64 btf_id;
+		} xdp;
 	};
 	size_t :0;
 };
@@ -397,8 +401,18 @@ struct bpf_link_update_opts {
 	size_t sz; /* size of this struct for forward/backward compatibility */
 	__u32 flags;	   /* extra flags */
 	__u32 old_prog_fd; /* expected old program FD */
+	/* must have the same layout as the same union from
+	 * bpf_attr::link_update, uses direct memcpy() to there
+	 */
+	union {
+		struct {
+			/* new target metadata BTF + type ID */
+			__aligned_u64 new_btf_id;
+		} xdp;
+	};
+	size_t :0;
 };
-#define bpf_link_update_opts__last_field old_prog_fd
+#define bpf_link_update_opts__last_field xdp.new_btf_id
 
 LIBBPF_API int bpf_link_update(int link_fd, int new_prog_fd,
 			       const struct bpf_link_update_opts *opts);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 4056e9038086..4f77128ba770 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -1193,9 +1193,11 @@ struct xdp_link_info {
 struct bpf_xdp_set_link_opts {
 	size_t sz;
 	int old_fd;
+	__u32 :32;
+	__u64 btf_id;
 	size_t :0;
 };
-#define bpf_xdp_set_link_opts__last_field old_fd
+#define bpf_xdp_set_link_opts__last_field btf_id
 
 LIBBPF_DEPRECATED_SINCE(0, 8, "use bpf_xdp_attach() instead")
 LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
@@ -1211,9 +1213,11 @@ LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 struct bpf_xdp_attach_opts {
 	size_t sz;
 	int old_prog_fd;
+	__u32 :32;
+	__u64 btf_id;
 	size_t :0;
 };
-#define bpf_xdp_attach_opts__last_field old_prog_fd
+#define bpf_xdp_attach_opts__last_field btf_id
 
 struct bpf_xdp_query_opts {
 	size_t sz;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 3a25178d0d12..104a809d5fb2 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -235,6 +235,7 @@ struct __bpf_set_link_xdp_fd_opts {
 	int fd;
 	int old_fd;
 	__u32 flags;
+	__u64 btf_id;
 };
 
 static int
@@ -269,6 +270,12 @@ __bpf_set_link_xdp_fd_replace(const struct __bpf_set_link_xdp_fd_opts *opts)
 		if (ret < 0)
 			return ret;
 	}
+	if (opts->btf_id) {
+		ret = nlattr_add(&req, IFLA_XDP_BTF_ID, &opts->btf_id,
+				 sizeof(opts->btf_id));
+		if (ret < 0)
+			return ret;
+	}
 	nlattr_end_nested(&req, nla);
 
 	return libbpf_netlink_send_recv(&req, NULL, NULL, NULL);
@@ -292,6 +299,8 @@ int bpf_xdp_attach(int ifindex, int prog_fd, __u32 flags, const struct bpf_xdp_a
 	else
 		sl_opts.old_fd = -1;
 
+	sl_opts.btf_id = OPTS_GET(opts, btf_id, 0);
+
 	err = __bpf_set_link_xdp_fd_replace(&sl_opts);
 	return libbpf_err(err);
 }
@@ -320,6 +329,8 @@ int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
 		flags |= XDP_FLAGS_REPLACE;
 	}
 
+	sl_opts.btf_id = OPTS_GET(opts, btf_id, 0);
+
 	ret = __bpf_set_link_xdp_fd_replace(&sl_opts);
 	return libbpf_err(ret);
 }
-- 
2.36.1

