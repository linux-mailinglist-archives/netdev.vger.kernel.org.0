Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139C955EE32
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiF1TvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiF1Tuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:50 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A81337AA6;
        Tue, 28 Jun 2022 12:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445753; x=1687981753;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QuDromnuxNsGAITyqqK2ZtJCvPPIlNl9f1QlOMWHD4E=;
  b=nlU/grdtEkCOQC+lV5rw4xBzxhQHIgaiZhbeRJOK8AM+IjKGH4lplqh8
   5wAdBpOG9SUfXYLG1DJL4SjkFdcZ9dK4/8M/CTEIo7VacJQmBCTpCbDOu
   eJVNmspghBp61TvpwpWiDuZyndT9sTjtaw5Odax57gGi7feBE09fHD6UF
   BQK/IX6CKOifKxSFGLrch5Xyi6Uafc3yB0bb0Mh8t1LCviGRT6ycT9n8w
   f85UW07m+U78qVjDe855wfile3BHYE+7KymnHzsbepuiN1ANvHnrwh75U
   pkWuwuaWMBxhoXVrztmc06OxJ6C1y/wB3iDkhxkBVdd/cMBjrtBcYPQLL
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="261635573"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="261635573"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="658257470"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jun 2022 12:49:09 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9A022013;
        Tue, 28 Jun 2022 20:49:07 +0100
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
Subject: [PATCH RFC bpf-next 10/52] net, xdp: add ability to specify frame size threshold for XDP metadata
Date:   Tue, 28 Jun 2022 21:47:30 +0200
Message-Id: <20220628194812.1453059-11-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the UAPI and the corresponding kernel part to be able to specify
the frame size which the drivers should start composing metadata
from (if supported).

Instead of having just 1 bit on/off, have the possilibty to set the
threshold for drivers to start composing meta. It helps with the
situations when e.g. lots of traffic receive %XDP_DROP verdict
without looking at the meta. In such cases, the performance on the
small frames (< 96 bytes) can suffer by several Mpps with no
benefits, so setting the threshold of 100-128 makes much sense.
Setting it to 0 or 1 works just like a bitflag, values of 2-14
work like 1, values of SZ_16K+ works like 0.
So, the logics in the drivers should be like:

	if (rx_desc->frame_size >= meta_thresh)
		compose_meta();

	bpf_prog_run_xdp();

The threshold can be set and updated via both BPF link and rtnetlink
(the %IFLA_XDP_META_THRESH attribute) interfaces, got via
&bpf_link_info and is being passed to the drivers inside
&netdev_bpf. net_device_ops::ndo_bpf() is now also being called when
@new_prog == @old_prog && @new_btf_id == @btf_id &&
@new_meta_thresh != @meta_thresh.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/netdevice.h          |  2 ++
 include/net/xdp.h                  |  1 +
 include/uapi/linux/bpf.h           | 10 +++++++-
 include/uapi/linux/if_link.h       |  1 +
 kernel/bpf/syscall.c               |  2 +-
 net/bpf/core.c                     |  1 +
 net/bpf/dev.c                      | 38 +++++++++++++++++++++++-------
 net/core/rtnetlink.c               |  6 +++++
 tools/include/uapi/linux/bpf.h     | 10 +++++++-
 tools/include/uapi/linux/if_link.h |  1 +
 10 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2218c1901daf..bc2d82a3d0de 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -985,6 +985,7 @@ struct netdev_bpf {
 		/* XDP_SETUP_PROG */
 		struct {
 			u32 flags;
+			u32 meta_thresh;
 			u64 btf_id;
 			struct bpf_prog *prog;
 			struct netlink_ext_ack *extack;
@@ -3853,6 +3854,7 @@ struct xdp_install_args {
 	struct net_device	*dev;
 	struct netlink_ext_ack	*extack;
 	u32			flags;
+	u32			meta_thresh;
 	u64			btf_id;
 };
 
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 13133c7493bc..7b8ba068d28a 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -401,6 +401,7 @@ static inline bool xdp_metalen_invalid(unsigned long metalen)
 struct xdp_attachment_info {
 	struct bpf_prog *prog;
 	u64 btf_id;
+	u32 meta_thresh;
 	u32 flags;
 };
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c67ddb78915d..372170ded1d8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1502,6 +1502,10 @@ union bpf_attr {
 			struct {
 				/* target metadata BTF + type ID */
 				__aligned_u64	btf_id;
+				/* frame size to start composing XDP
+				 * metadata from
+				 */
+				__u32		meta_thresh;
 			} xdp;
 		};
 	} link_create;
@@ -1518,6 +1522,10 @@ union bpf_attr {
 			struct {
 				/* new target metadata BTF + type ID */
 				__aligned_u64	new_btf_id;
+				/* new frame size to start composing XDP
+				 * metadata from
+				 */
+				__u32		new_meta_thresh;
 			} xdp;
 		};
 	} link_update;
@@ -6148,7 +6156,7 @@ struct bpf_link_info {
 		} netns;
 		struct {
 			__u32 ifindex;
-			__u32 :32;
+			__u32 meta_thresh;
 			__aligned_u64 btf_id;
 		} xdp;
 	};
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 73cdcc86875e..78b448ff1cb7 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1308,6 +1308,7 @@ enum {
 	IFLA_XDP_HW_PROG_ID,
 	IFLA_XDP_EXPECTED_FD,
 	IFLA_XDP_BTF_ID,
+	IFLA_XDP_META_THRESH,
 	__IFLA_XDP_MAX,
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2e86cfeae10f..e1a56e62bdb4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4575,7 +4575,7 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 	return ret;
 }
 
-#define BPF_LINK_UPDATE_LAST_FIELD link_update.xdp.new_btf_id
+#define BPF_LINK_UPDATE_LAST_FIELD link_update.xdp.new_meta_thresh
 
 static int link_update(union bpf_attr *attr)
 {
diff --git a/net/bpf/core.c b/net/bpf/core.c
index e5abd5a64df7..dcd3b6ae86b7 100644
--- a/net/bpf/core.c
+++ b/net/bpf/core.c
@@ -553,6 +553,7 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 		bpf_prog_put(info->prog);
 	info->prog = bpf->prog;
 	info->btf_id = bpf->btf_id;
+	info->meta_thresh = bpf->meta_thresh;
 	info->flags = bpf->flags;
 }
 EXPORT_SYMBOL_GPL(xdp_attachment_setup);
diff --git a/net/bpf/dev.c b/net/bpf/dev.c
index e96986220126..82948d0536c8 100644
--- a/net/bpf/dev.c
+++ b/net/bpf/dev.c
@@ -273,6 +273,7 @@ struct bpf_xdp_link {
 	struct bpf_link link;
 	struct net_device *dev; /* protected by rtnl_lock, no refcnt held */
 	int flags;
+	u32 meta_thresh;
 	u64 btf_id;
 };
 
@@ -358,12 +359,20 @@ static int dev_xdp_install(const struct xdp_install_args *args,
 	struct netdev_bpf xdp;
 	int err;
 
-	/* BTF ID must not be set when uninstalling the program */
-	if (!prog && args->btf_id)
+	/* Neither BTF ID nor meta threshold can be set when uninstalling
+	 * the program
+	 */
+	if (!prog && (args->btf_id || args->meta_thresh))
+		return -EINVAL;
+
+	/* Both meta threshold and BTF ID must be either specified or not */
+	if (!args->btf_id != !args->meta_thresh)
 		return -EINVAL;
 
 	memset(&xdp, 0, sizeof(xdp));
 	xdp.command = mode == XDP_MODE_HW ? XDP_SETUP_PROG_HW : XDP_SETUP_PROG;
+	/* Convert 0 to "infitity" to allow plain >= comparison on hotpath */
+	xdp.meta_thresh = args->meta_thresh ? : ~args->meta_thresh;
 	xdp.btf_id = args->btf_id;
 	xdp.extack = args->extack;
 	xdp.flags = args->flags;
@@ -523,11 +532,13 @@ static int dev_xdp_attach(const struct xdp_install_args *args,
 		}
 	}
 
-	/* don't call drivers if the effective program or BTF ID didn't change.
-	 * If @link == %NULL, we don't know the old value, so the only thing we
-	 * can do is to call installing unconditionally
+	/* don't call drivers if the effective program or BTF ID / metadata
+	 * threshold didn't change. If @link == %NULL, we don't know the
+	 * old values, so the only thing we can do is to call installing
+	 * unconditionally
 	 */
-	if (new_prog != cur_prog || !link || args->btf_id != link->btf_id) {
+	if (new_prog != cur_prog || !link || args->btf_id != link->btf_id ||
+	    args->meta_thresh != link->meta_thresh) {
 		bpf_op = dev_xdp_bpf_op(dev, mode);
 		if (!bpf_op) {
 			NL_SET_ERR_MSG(extack, "Underlying driver does not support XDP in native mode");
@@ -555,6 +566,7 @@ static int dev_xdp_attach_link(struct bpf_xdp_link *link)
 		.dev		= link->dev,
 		.flags		= link->flags,
 		.btf_id		= link->btf_id,
+		.meta_thresh	= link->meta_thresh,
 	};
 
 	return dev_xdp_attach(&args, link, NULL, NULL);
@@ -615,16 +627,18 @@ static void bpf_xdp_link_show_fdinfo(const struct bpf_link *link,
 				     struct seq_file *seq)
 {
 	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
-	u32 ifindex = 0;
+	u32 meta_thresh, ifindex = 0;
 	u64 btf_id;
 
 	rtnl_lock();
 	if (xdp_link->dev)
 		ifindex = xdp_link->dev->ifindex;
+	meta_thresh = xdp_link->meta_thresh;
 	btf_id = xdp_link->btf_id;
 	rtnl_unlock();
 
 	seq_printf(seq, "ifindex:\t%u\n", ifindex);
+	seq_printf(seq, "meta_thresh:\t%u\n", meta_thresh);
 	seq_printf(seq, "btf_id:\t0x%llx\n", btf_id);
 }
 
@@ -632,17 +646,19 @@ static int bpf_xdp_link_fill_link_info(const struct bpf_link *link,
 				       struct bpf_link_info *info)
 {
 	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
-	u32 ifindex = 0;
+	u32 meta_thresh, ifindex = 0;
 	u64 btf_id;
 
 	rtnl_lock();
 	if (xdp_link->dev)
 		ifindex = xdp_link->dev->ifindex;
+	meta_thresh = xdp_link->meta_thresh;
 	btf_id = xdp_link->btf_id;
 	rtnl_unlock();
 
 	info->xdp.ifindex = ifindex;
 	info->xdp.btf_id = btf_id;
+	info->xdp.meta_thresh = meta_thresh;
 	return 0;
 }
 
@@ -656,6 +672,7 @@ static int bpf_xdp_link_update(struct bpf_link *link,
 		.dev		= xdp_link->dev,
 		.flags		= xdp_link->flags,
 		.btf_id		= attr->link_update.xdp.new_btf_id,
+		.meta_thresh	= attr->link_update.xdp.new_meta_thresh,
 	};
 	enum bpf_xdp_mode mode;
 	bpf_op_t bpf_op;
@@ -680,7 +697,8 @@ static int bpf_xdp_link_update(struct bpf_link *link,
 		goto out_unlock;
 	}
 
-	if (old_prog == new_prog && args.btf_id == xdp_link->btf_id) {
+	if (old_prog == new_prog && args.btf_id == xdp_link->btf_id &&
+	    args.meta_thresh == xdp_link->meta_thresh) {
 		/* no-op, don't disturb drivers */
 		bpf_prog_put(new_prog);
 		goto out_unlock;
@@ -696,6 +714,7 @@ static int bpf_xdp_link_update(struct bpf_link *link,
 	bpf_prog_put(old_prog);
 
 	xdp_link->btf_id = args.btf_id;
+	xdp_link->meta_thresh = args.meta_thresh;
 
 out_unlock:
 	rtnl_unlock();
@@ -736,6 +755,7 @@ int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 	link->dev = dev;
 	link->flags = attr->link_create.flags;
 	link->btf_id = attr->link_create.xdp.btf_id;
+	link->meta_thresh = attr->link_create.xdp.meta_thresh;
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err) {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a30723b0e50c..500420d5017c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1980,6 +1980,7 @@ static const struct nla_policy ifla_xdp_policy[IFLA_XDP_MAX + 1] = {
 	[IFLA_XDP_FLAGS]	= { .type = NLA_U32 },
 	[IFLA_XDP_PROG_ID]	= { .type = NLA_U32 },
 	[IFLA_XDP_BTF_ID]	= { .type = NLA_U64 },
+	[IFLA_XDP_META_THRESH]	= { .type = NLA_U32 },
 };
 
 static const struct rtnl_link_ops *linkinfo_to_kind_ops(const struct nlattr *nla)
@@ -2962,6 +2963,7 @@ static int do_setlink(const struct sk_buff *skb,
 
 	if (tb[IFLA_XDP]) {
 		struct nlattr *xdp[IFLA_XDP_MAX + 1];
+		u32 meta_thresh = 0;
 		u32 xdp_flags = 0;
 		u64 btf_id = 0;
 
@@ -2991,12 +2993,16 @@ static int do_setlink(const struct sk_buff *skb,
 		if (xdp[IFLA_XDP_BTF_ID])
 			btf_id = nla_get_u64(xdp[IFLA_XDP_BTF_ID]);
 
+		if (xdp[IFLA_XDP_META_THRESH])
+			meta_thresh = nla_get_u32(xdp[IFLA_XDP_META_THRESH]);
+
 		if (xdp[IFLA_XDP_FD]) {
 			struct xdp_install_args args = {
 				.dev		= dev,
 				.extack		= extack,
 				.btf_id		= btf_id,
 				.flags		= xdp_flags,
+				.meta_thresh	= meta_thresh,
 			};
 			int expected_fd = -1;
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c67ddb78915d..372170ded1d8 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1502,6 +1502,10 @@ union bpf_attr {
 			struct {
 				/* target metadata BTF + type ID */
 				__aligned_u64	btf_id;
+				/* frame size to start composing XDP
+				 * metadata from
+				 */
+				__u32		meta_thresh;
 			} xdp;
 		};
 	} link_create;
@@ -1518,6 +1522,10 @@ union bpf_attr {
 			struct {
 				/* new target metadata BTF + type ID */
 				__aligned_u64	new_btf_id;
+				/* new frame size to start composing XDP
+				 * metadata from
+				 */
+				__u32		new_meta_thresh;
 			} xdp;
 		};
 	} link_update;
@@ -6148,7 +6156,7 @@ struct bpf_link_info {
 		} netns;
 		struct {
 			__u32 ifindex;
-			__u32 :32;
+			__u32 meta_thresh;
 			__aligned_u64 btf_id;
 		} xdp;
 	};
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 68b126678dc8..b73b9c0f06fb 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -1213,6 +1213,7 @@ enum {
 	IFLA_XDP_HW_PROG_ID,
 	IFLA_XDP_EXPECTED_FD,
 	IFLA_XDP_BTF_ID,
+	IFLA_XDP_META_THRESH,
 	__IFLA_XDP_MAX,
 };
 
-- 
2.36.1

