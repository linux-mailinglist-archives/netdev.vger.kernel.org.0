Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0689455EE61
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiF1Tvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbiF1Tuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:52 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AC83A724;
        Tue, 28 Jun 2022 12:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445764; x=1687981764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yNkO5OonyawD491tq3UN3yp8qYpkGlKlrdxkHHQ0Dbc=;
  b=gOkPh3YBO8qpcjeMa36Vs3wKtaPejFFtZKnlnhuLA6JniZkhhzZclpAk
   3O7TXYUMxm2WrLoLE9U4nfkmOpFrbt2G6jOxDEtuvX+UaOlVyUFi9a0ir
   ZhJe3VGsA7CalHtM8AiW0im1gmz60/Nu6DYFG80XGjNpfyruri+UYQgJS
   r7MyTx4ID8ZQRXmkv6lJ1R6Fk4rWX+7iPv3/3t/UulB/wsTlqsEMLgtwT
   fDkZMzJC3mcfyTDpi/HJ3euu9p9GCS3LM7TIpL2+Tq6yO5z5jalRwKFRM
   uMWyJb9OtCd+jK/rbhdgIsriaI76yudOV9bm2dP1qAuPrOPY1Ti70UMBo
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="262242844"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="262242844"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="917306820"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jun 2022 12:49:13 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9D022013;
        Tue, 28 Jun 2022 20:49:11 +0100
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
Subject: [PATCH RFC bpf-next 13/52] libbpf: add ability to set the meta threshold on setting XDP prog
Date:   Tue, 28 Jun 2022 21:47:33 +0200
Message-Id: <20220628194812.1453059-14-alexandr.lobakin@intel.com>
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

Covered functions:
 * bpf_link_create() - via &bpf_link_create_ops;
 * bpf_link_update() - via &bpf_link_update_ops;
 * bpf_xdp_attach() - via &bpf_xdp_attach_ops;
 * bpf_set_link_xdp_fd_opts() - via &bpf_xdp_set_link_opts;

No support for bpf_get_link_xdp_info()/&xdp_link_info as we store
additional data in the kernel in BPF link mode only.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/lib/bpf/bpf.c     |  3 +++
 tools/lib/bpf/bpf.h     |  8 +++++++-
 tools/lib/bpf/libbpf.h  |  4 ++--
 tools/lib/bpf/netlink.c | 10 ++++++++++
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 6036dc75cc7b..e7c713a418f6 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -807,6 +807,9 @@ int bpf_link_create(int prog_fd, int target_fd,
 		break;
 	case BPF_XDP:
 		attr.link_create.xdp.btf_id = OPTS_GET(opts, xdp.btf_id, 0);
+		attr.link_create.xdp.meta_thresh = OPTS_GET(opts,
+							    xdp.meta_thresh,
+							    0);
 		if (!OPTS_ZEROED(opts, xdp))
 			return libbpf_err(-EINVAL);
 		break;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 4e17995fdaff..c0f54f24d675 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -385,6 +385,8 @@ struct bpf_link_create_opts {
 		struct {
 			/* target metadata BTF + type ID */
 			__aligned_u64 btf_id;
+			/* frame size to start composing XDP metadata from */
+			__u32 meta_thresh;
 		} xdp;
 	};
 	size_t :0;
@@ -408,11 +410,15 @@ struct bpf_link_update_opts {
 		struct {
 			/* new target metadata BTF + type ID */
 			__aligned_u64 new_btf_id;
+			/* new frame size to start composing XDP
+			 * metadata from
+			 */
+			__u32 new_meta_thresh;
 		} xdp;
 	};
 	size_t :0;
 };
-#define bpf_link_update_opts__last_field xdp.new_btf_id
+#define bpf_link_update_opts__last_field xdp.new_meta_thresh
 
 LIBBPF_API int bpf_link_update(int link_fd, int new_prog_fd,
 			       const struct bpf_link_update_opts *opts);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 4f77128ba770..99ac94f148fc 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -1193,7 +1193,7 @@ struct xdp_link_info {
 struct bpf_xdp_set_link_opts {
 	size_t sz;
 	int old_fd;
-	__u32 :32;
+	__u32 meta_thresh;
 	__u64 btf_id;
 	size_t :0;
 };
@@ -1213,7 +1213,7 @@ LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 struct bpf_xdp_attach_opts {
 	size_t sz;
 	int old_prog_fd;
-	__u32 :32;
+	__u32 meta_thresh;
 	__u64 btf_id;
 	size_t :0;
 };
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 104a809d5fb2..ac2a87243ecd 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -236,6 +236,7 @@ struct __bpf_set_link_xdp_fd_opts {
 	int old_fd;
 	__u32 flags;
 	__u64 btf_id;
+	__u32 meta_thresh;
 };
 
 static int
@@ -276,6 +277,13 @@ __bpf_set_link_xdp_fd_replace(const struct __bpf_set_link_xdp_fd_opts *opts)
 		if (ret < 0)
 			return ret;
 	}
+	if (opts->meta_thresh) {
+		ret = nlattr_add(&req, IFLA_XDP_META_THRESH,
+				 &opts->meta_thresh,
+				 sizeof(opts->meta_thresh));
+		if (ret < 0)
+			return ret;
+	}
 	nlattr_end_nested(&req, nla);
 
 	return libbpf_netlink_send_recv(&req, NULL, NULL, NULL);
@@ -300,6 +308,7 @@ int bpf_xdp_attach(int ifindex, int prog_fd, __u32 flags, const struct bpf_xdp_a
 		sl_opts.old_fd = -1;
 
 	sl_opts.btf_id = OPTS_GET(opts, btf_id, 0);
+	sl_opts.meta_thresh = OPTS_GET(opts, meta_thresh, 0);
 
 	err = __bpf_set_link_xdp_fd_replace(&sl_opts);
 	return libbpf_err(err);
@@ -330,6 +339,7 @@ int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
 	}
 
 	sl_opts.btf_id = OPTS_GET(opts, btf_id, 0);
+	sl_opts.meta_thresh = OPTS_GET(opts, meta_thresh, 0);
 
 	ret = __bpf_set_link_xdp_fd_replace(&sl_opts);
 	return libbpf_err(ret);
-- 
2.36.1

