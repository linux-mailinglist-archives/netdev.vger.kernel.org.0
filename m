Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB31C55EE81
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiF1TvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiF1Tuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:50 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6AC17E3F;
        Tue, 28 Jun 2022 12:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445752; x=1687981752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SqWbOCdnhWLJ6BpjYS5/roLulPLkxRjJFV89S0QmGTs=;
  b=f6B+pJGrIU4mqL40TbHGKn3zn85qew+G1Z9pDz14rNBJandV19G8eApk
   Z2Y+r0Vk/NHrnTGheCBOzVJPYqSNdCzW/0A1BuvKEPgTPisQ2fpLr4O/7
   AOv9yi0JfGtXTz7vkCRXDyy/MP64EqJFOvxEpguvvbdulwad1QgSYizcU
   y8ogWlEFiUvmfEu6JPaycpPwPU/Ghs9EK76+9tXUyWNkJbIH9YY+wOrjZ
   +KRfUt5/QXm60/aXTC8WDykV8vcIZ3wP8jDyuzhEvYw9Hmh4hhLRJ8YtH
   sk9wjOAwNvZvMpRWrgHwhZOgNoI5irPZ+1xM1KKIg2JK1g2DR6/2l+zih
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="264874045"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="264874045"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="693250944"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jun 2022 12:49:07 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr99022013;
        Tue, 28 Jun 2022 20:49:06 +0100
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
Subject: [PATCH RFC bpf-next 09/52] net, xdp: add ability to specify BTF ID for XDP metadata
Date:   Tue, 28 Jun 2022 21:47:29 +0200
Message-Id: <20220628194812.1453059-10-alexandr.lobakin@intel.com>
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

Add the UAPI and the corresponding kernel part to be able to specify
the BTF ID of the format which the drivers should compose metadata
in (if supported).

A driver might be able to provide XDP metadata in different formats,
e.g. the generic one and one or several custom (with some
non-universal data from DMA descriptors etc.). In this case, a BPF
loader program will specify the wanted BTF ID and then BPF and
AF_XDP programs will be expecting this format in XDP metadata and
will be comparing different BTF IDs against the one that will be
put in front of a frame.

The BTF ID can be set and updated via both BPF link and rtnetlink
(the %IFLA_XDP_BTF_ID attribute) interfaces, got via &bpf_link_info
and is being passed to the drivers inside &netdev_bpf.
net_device_ops::ndo_bpf() is now being called not only when
@new_prog != @old_prog, but also when @new_prog == @old_prog &&
@new_btf_id != @btf_id, so the drivers should be able to handle
such cases.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/netdevice.h          |  2 ++
 include/net/xdp.h                  |  1 +
 include/uapi/linux/bpf.h           | 12 ++++++++++++
 include/uapi/linux/if_link.h       |  1 +
 kernel/bpf/syscall.c               |  2 +-
 net/bpf/core.c                     |  1 +
 net/bpf/dev.c                      | 26 +++++++++++++++++++++++---
 net/core/rtnetlink.c               |  6 ++++++
 tools/include/uapi/linux/bpf.h     | 12 ++++++++++++
 tools/include/uapi/linux/if_link.h |  1 +
 10 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1e342c285f48..2218c1901daf 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -985,6 +985,7 @@ struct netdev_bpf {
 		/* XDP_SETUP_PROG */
 		struct {
 			u32 flags;
+			u64 btf_id;
 			struct bpf_prog *prog;
 			struct netlink_ext_ack *extack;
 		};
@@ -3852,6 +3853,7 @@ struct xdp_install_args {
 	struct net_device	*dev;
 	struct netlink_ext_ack	*extack;
 	u32			flags;
+	u64			btf_id;
 };
 
 DECLARE_STATIC_KEY_FALSE(generic_xdp_needed_key);
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 04c852c7a77f..13133c7493bc 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -400,6 +400,7 @@ static inline bool xdp_metalen_invalid(unsigned long metalen)
 
 struct xdp_attachment_info {
 	struct bpf_prog *prog;
+	u64 btf_id;
 	u32 flags;
 };
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e81362891596..c67ddb78915d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1499,6 +1499,10 @@ union bpf_attr {
 				 */
 				__u64		cookie;
 			} tracing;
+			struct {
+				/* target metadata BTF + type ID */
+				__aligned_u64	btf_id;
+			} xdp;
 		};
 	} link_create;
 
@@ -1510,6 +1514,12 @@ union bpf_attr {
 		/* expected link's program fd; is specified only if
 		 * BPF_F_REPLACE flag is set in flags */
 		__u32		old_prog_fd;
+		union {
+			struct {
+				/* new target metadata BTF + type ID */
+				__aligned_u64	new_btf_id;
+			} xdp;
+		};
 	} link_update;
 
 	struct {
@@ -6138,6 +6148,8 @@ struct bpf_link_info {
 		} netns;
 		struct {
 			__u32 ifindex;
+			__u32 :32;
+			__aligned_u64 btf_id;
 		} xdp;
 	};
 } __attribute__((aligned(8)));
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5f58dcfe2787..73cdcc86875e 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1307,6 +1307,7 @@ enum {
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
 	IFLA_XDP_EXPECTED_FD,
+	IFLA_XDP_BTF_ID,
 	__IFLA_XDP_MAX,
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f7a674656067..2e86cfeae10f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4575,7 +4575,7 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 	return ret;
 }
 
-#define BPF_LINK_UPDATE_LAST_FIELD link_update.old_prog_fd
+#define BPF_LINK_UPDATE_LAST_FIELD link_update.xdp.new_btf_id
 
 static int link_update(union bpf_attr *attr)
 {
diff --git a/net/bpf/core.c b/net/bpf/core.c
index fbb72792320a..e5abd5a64df7 100644
--- a/net/bpf/core.c
+++ b/net/bpf/core.c
@@ -552,6 +552,7 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 	if (info->prog)
 		bpf_prog_put(info->prog);
 	info->prog = bpf->prog;
+	info->btf_id = bpf->btf_id;
 	info->flags = bpf->flags;
 }
 EXPORT_SYMBOL_GPL(xdp_attachment_setup);
diff --git a/net/bpf/dev.c b/net/bpf/dev.c
index 7df42bb886ad..e96986220126 100644
--- a/net/bpf/dev.c
+++ b/net/bpf/dev.c
@@ -273,6 +273,7 @@ struct bpf_xdp_link {
 	struct bpf_link link;
 	struct net_device *dev; /* protected by rtnl_lock, no refcnt held */
 	int flags;
+	u64 btf_id;
 };
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
@@ -357,8 +358,13 @@ static int dev_xdp_install(const struct xdp_install_args *args,
 	struct netdev_bpf xdp;
 	int err;
 
+	/* BTF ID must not be set when uninstalling the program */
+	if (!prog && args->btf_id)
+		return -EINVAL;
+
 	memset(&xdp, 0, sizeof(xdp));
 	xdp.command = mode == XDP_MODE_HW ? XDP_SETUP_PROG_HW : XDP_SETUP_PROG;
+	xdp.btf_id = args->btf_id;
 	xdp.extack = args->extack;
 	xdp.flags = args->flags;
 	xdp.prog = prog;
@@ -517,8 +523,11 @@ static int dev_xdp_attach(const struct xdp_install_args *args,
 		}
 	}
 
-	/* don't call drivers if the effective program didn't change */
-	if (new_prog != cur_prog) {
+	/* don't call drivers if the effective program or BTF ID didn't change.
+	 * If @link == %NULL, we don't know the old value, so the only thing we
+	 * can do is to call installing unconditionally
+	 */
+	if (new_prog != cur_prog || !link || args->btf_id != link->btf_id) {
 		bpf_op = dev_xdp_bpf_op(dev, mode);
 		if (!bpf_op) {
 			NL_SET_ERR_MSG(extack, "Underlying driver does not support XDP in native mode");
@@ -545,6 +554,7 @@ static int dev_xdp_attach_link(struct bpf_xdp_link *link)
 	struct xdp_install_args args = {
 		.dev		= link->dev,
 		.flags		= link->flags,
+		.btf_id		= link->btf_id,
 	};
 
 	return dev_xdp_attach(&args, link, NULL, NULL);
@@ -606,13 +616,16 @@ static void bpf_xdp_link_show_fdinfo(const struct bpf_link *link,
 {
 	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
 	u32 ifindex = 0;
+	u64 btf_id;
 
 	rtnl_lock();
 	if (xdp_link->dev)
 		ifindex = xdp_link->dev->ifindex;
+	btf_id = xdp_link->btf_id;
 	rtnl_unlock();
 
 	seq_printf(seq, "ifindex:\t%u\n", ifindex);
+	seq_printf(seq, "btf_id:\t0x%llx\n", btf_id);
 }
 
 static int bpf_xdp_link_fill_link_info(const struct bpf_link *link,
@@ -620,13 +633,16 @@ static int bpf_xdp_link_fill_link_info(const struct bpf_link *link,
 {
 	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
 	u32 ifindex = 0;
+	u64 btf_id;
 
 	rtnl_lock();
 	if (xdp_link->dev)
 		ifindex = xdp_link->dev->ifindex;
+	btf_id = xdp_link->btf_id;
 	rtnl_unlock();
 
 	info->xdp.ifindex = ifindex;
+	info->xdp.btf_id = btf_id;
 	return 0;
 }
 
@@ -639,6 +655,7 @@ static int bpf_xdp_link_update(struct bpf_link *link,
 	struct xdp_install_args args = {
 		.dev		= xdp_link->dev,
 		.flags		= xdp_link->flags,
+		.btf_id		= attr->link_update.xdp.new_btf_id,
 	};
 	enum bpf_xdp_mode mode;
 	bpf_op_t bpf_op;
@@ -663,7 +680,7 @@ static int bpf_xdp_link_update(struct bpf_link *link,
 		goto out_unlock;
 	}
 
-	if (old_prog == new_prog) {
+	if (old_prog == new_prog && args.btf_id == xdp_link->btf_id) {
 		/* no-op, don't disturb drivers */
 		bpf_prog_put(new_prog);
 		goto out_unlock;
@@ -678,6 +695,8 @@ static int bpf_xdp_link_update(struct bpf_link *link,
 	old_prog = xchg(&link->prog, new_prog);
 	bpf_prog_put(old_prog);
 
+	xdp_link->btf_id = args.btf_id;
+
 out_unlock:
 	rtnl_unlock();
 	return err;
@@ -716,6 +735,7 @@ int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 	bpf_link_init(&link->link, BPF_LINK_TYPE_XDP, &bpf_xdp_link_lops, prog);
 	link->dev = dev;
 	link->flags = attr->link_create.flags;
+	link->btf_id = attr->link_create.xdp.btf_id;
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err) {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 5b06ded689b2..a30723b0e50c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1979,6 +1979,7 @@ static const struct nla_policy ifla_xdp_policy[IFLA_XDP_MAX + 1] = {
 	[IFLA_XDP_ATTACHED]	= { .type = NLA_U8 },
 	[IFLA_XDP_FLAGS]	= { .type = NLA_U32 },
 	[IFLA_XDP_PROG_ID]	= { .type = NLA_U32 },
+	[IFLA_XDP_BTF_ID]	= { .type = NLA_U64 },
 };
 
 static const struct rtnl_link_ops *linkinfo_to_kind_ops(const struct nlattr *nla)
@@ -2962,6 +2963,7 @@ static int do_setlink(const struct sk_buff *skb,
 	if (tb[IFLA_XDP]) {
 		struct nlattr *xdp[IFLA_XDP_MAX + 1];
 		u32 xdp_flags = 0;
+		u64 btf_id = 0;
 
 		err = nla_parse_nested_deprecated(xdp, IFLA_XDP_MAX,
 						  tb[IFLA_XDP],
@@ -2986,10 +2988,14 @@ static int do_setlink(const struct sk_buff *skb,
 			}
 		}
 
+		if (xdp[IFLA_XDP_BTF_ID])
+			btf_id = nla_get_u64(xdp[IFLA_XDP_BTF_ID]);
+
 		if (xdp[IFLA_XDP_FD]) {
 			struct xdp_install_args args = {
 				.dev		= dev,
 				.extack		= extack,
+				.btf_id		= btf_id,
 				.flags		= xdp_flags,
 			};
 			int expected_fd = -1;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index e81362891596..c67ddb78915d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1499,6 +1499,10 @@ union bpf_attr {
 				 */
 				__u64		cookie;
 			} tracing;
+			struct {
+				/* target metadata BTF + type ID */
+				__aligned_u64	btf_id;
+			} xdp;
 		};
 	} link_create;
 
@@ -1510,6 +1514,12 @@ union bpf_attr {
 		/* expected link's program fd; is specified only if
 		 * BPF_F_REPLACE flag is set in flags */
 		__u32		old_prog_fd;
+		union {
+			struct {
+				/* new target metadata BTF + type ID */
+				__aligned_u64	new_btf_id;
+			} xdp;
+		};
 	} link_update;
 
 	struct {
@@ -6138,6 +6148,8 @@ struct bpf_link_info {
 		} netns;
 		struct {
 			__u32 ifindex;
+			__u32 :32;
+			__aligned_u64 btf_id;
 		} xdp;
 	};
 } __attribute__((aligned(8)));
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index b339bf2196ca..68b126678dc8 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -1212,6 +1212,7 @@ enum {
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
 	IFLA_XDP_EXPECTED_FD,
+	IFLA_XDP_BTF_ID,
 	__IFLA_XDP_MAX,
 };
 
-- 
2.36.1

