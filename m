Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C5755EE4F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiF1TvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiF1Tut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:49 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A444EA7;
        Tue, 28 Jun 2022 12:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445751; x=1687981751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fLcsoB6VtjEUPeJ9dvKqgy5Y7I+Rr4vHLG6qaoWyTqw=;
  b=UvHRfJQLm2wKmvyZRwbRT9mjg2nrLe5aJje+ZoxrQbEsAJx8mEPVMgw/
   Onp9uMlxNJDs2pkzP7BuDmXPWNOVPZeZbH7cR6iKwdyC6guf+qGZDtwmp
   /jZtzOx/LS2cXZDyftWxALH+LcNCqa39RoOVKqyrSudWWbSL0XMlgp2r6
   GiDBbP0h5EfCNm1hgSijUviVb2q7a5doxyppZt11CyZSBrY/OujcY2Fzf
   RxJY92cVEwaZVWLfbRUW5VVpxSJW6bw70SBwpxBTvmJwGFWSL24gFsmyR
   j3RubVWqmdpwMrEA8SbNyqeMXaszP9KB3161KXEHDlj+dxa3r02uOwtQN
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="264874035"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="264874035"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="693250940"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jun 2022 12:49:06 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr98022013;
        Tue, 28 Jun 2022 20:49:04 +0100
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
Subject: [PATCH RFC bpf-next 08/52] net, xdp: factor out XDP install arguments to a separate structure
Date:   Tue, 28 Jun 2022 21:47:28 +0200
Message-Id: <20220628194812.1453059-9-alexandr.lobakin@intel.com>
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

The current way of passing parameters from userland/rtnetlink
(do_set_link()) to dev_change_xdp_fd() and in the end to the drivers
separately does not scale a lot: each new parameter/argument
requires changing the prototypes of several functions at once.
To be able to pass more, derive them into a structure which for now
will contain:
 * dev, the actual netdevice,
 * extack, Netlink extack to pass arbitrary messages to userland,
 * flags, XDP install flags passed from the user.
and use it in the following functions instead of the separate
arguments: dev_change_xdp_fd(), dev_xdp_attach() and
dev_xdp_install(). Adjust the rest accordingly.
Those three are being used in the whole chain 'user -> driver', the
rest can {,dis}appear later, thus not included.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/netdevice.h | 10 +++++--
 net/bpf/dev.c             | 61 ++++++++++++++++++++++++---------------
 net/core/rtnetlink.c      | 10 +++++--
 3 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0b8169c23f22..1e342c285f48 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3848,11 +3848,17 @@ struct sk_buff *validate_xmit_skb_list(struct sk_buff *skb, struct net_device *d
 struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 				    struct netdev_queue *txq, int *ret);
 
+struct xdp_install_args {
+	struct net_device	*dev;
+	struct netlink_ext_ack	*extack;
+	u32			flags;
+};
+
 DECLARE_STATIC_KEY_FALSE(generic_xdp_needed_key);
 
 int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
-int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, int expected_fd, u32 flags);
+int dev_change_xdp_fd(const struct xdp_install_args *args, int fd,
+		      int expected_fd);
 void dev_xdp_uninstall(struct net_device *dev);
 u8 dev_xdp_prog_count(struct net_device *dev);
 u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode);
diff --git a/net/bpf/dev.c b/net/bpf/dev.c
index 0010b20719e8..7df42bb886ad 100644
--- a/net/bpf/dev.c
+++ b/net/bpf/dev.c
@@ -350,17 +350,17 @@ static void dev_xdp_set_prog(struct net_device *dev, enum bpf_xdp_mode mode,
 	dev->xdp_state[mode].prog = prog;
 }
 
-static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
-			   bpf_op_t bpf_op, struct netlink_ext_ack *extack,
-			   u32 flags, struct bpf_prog *prog)
+static int dev_xdp_install(const struct xdp_install_args *args,
+			   enum bpf_xdp_mode mode, bpf_op_t bpf_op,
+			   struct bpf_prog *prog)
 {
 	struct netdev_bpf xdp;
 	int err;
 
 	memset(&xdp, 0, sizeof(xdp));
 	xdp.command = mode == XDP_MODE_HW ? XDP_SETUP_PROG_HW : XDP_SETUP_PROG;
-	xdp.extack = extack;
-	xdp.flags = flags;
+	xdp.extack = args->extack;
+	xdp.flags = args->flags;
 	xdp.prog = prog;
 
 	/* Drivers assume refcnt is already incremented (i.e, prog pointer is
@@ -371,7 +371,7 @@ static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
 	 */
 	if (prog)
 		bpf_prog_inc(prog);
-	err = bpf_op(dev, &xdp);
+	err = bpf_op(args->dev, &xdp);
 	if (err) {
 		if (prog)
 			bpf_prog_put(prog);
@@ -379,13 +379,16 @@ static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
 	}
 
 	if (mode != XDP_MODE_HW)
-		bpf_prog_change_xdp(dev_xdp_prog(dev, mode), prog);
+		bpf_prog_change_xdp(dev_xdp_prog(args->dev, mode), prog);
 
 	return 0;
 }
 
 void dev_xdp_uninstall(struct net_device *dev)
 {
+	struct xdp_install_args args = {
+		.dev		= dev,
+	};
 	struct bpf_xdp_link *link;
 	struct bpf_prog *prog;
 	enum bpf_xdp_mode mode;
@@ -402,7 +405,7 @@ void dev_xdp_uninstall(struct net_device *dev)
 		if (!bpf_op)
 			continue;
 
-		WARN_ON(dev_xdp_install(dev, mode, bpf_op, NULL, 0, NULL));
+		WARN_ON(dev_xdp_install(&args, mode, bpf_op, NULL));
 
 		/* auto-detach link from net device */
 		link = dev_xdp_link(dev, mode);
@@ -415,13 +418,16 @@ void dev_xdp_uninstall(struct net_device *dev)
 	}
 }
 
-static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack,
+static int dev_xdp_attach(const struct xdp_install_args *args,
 			  struct bpf_xdp_link *link, struct bpf_prog *new_prog,
-			  struct bpf_prog *old_prog, u32 flags)
+			  struct bpf_prog *old_prog)
 {
-	unsigned int num_modes = hweight32(flags & XDP_FLAGS_MODES);
+	unsigned int num_modes = hweight32(args->flags & XDP_FLAGS_MODES);
+	struct netlink_ext_ack *extack = args->extack;
+	struct net_device *dev = args->dev;
 	struct bpf_prog *cur_prog;
 	struct net_device *upper;
+	u32 flags = args->flags;
 	struct list_head *iter;
 	enum bpf_xdp_mode mode;
 	bpf_op_t bpf_op;
@@ -519,7 +525,7 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 			return -EOPNOTSUPP;
 		}
 
-		err = dev_xdp_install(dev, mode, bpf_op, extack, flags, new_prog);
+		err = dev_xdp_install(args, mode, bpf_op, new_prog);
 		if (err)
 			return err;
 	}
@@ -536,12 +542,20 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 
 static int dev_xdp_attach_link(struct bpf_xdp_link *link)
 {
-	return dev_xdp_attach(link->dev, NULL, link, NULL, NULL, link->flags);
+	struct xdp_install_args args = {
+		.dev		= link->dev,
+		.flags		= link->flags,
+	};
+
+	return dev_xdp_attach(&args, link, NULL, NULL);
 }
 
 static int dev_xdp_detach_link(struct bpf_xdp_link *link)
 {
 	struct net_device *dev = link->dev;
+	struct xdp_install_args args = {
+		.dev		= dev,
+	};
 	enum bpf_xdp_mode mode;
 	bpf_op_t bpf_op;
 
@@ -552,7 +566,7 @@ static int dev_xdp_detach_link(struct bpf_xdp_link *link)
 		return -EINVAL;
 
 	bpf_op = dev_xdp_bpf_op(dev, mode);
-	WARN_ON(dev_xdp_install(dev, mode, bpf_op, NULL, 0, NULL));
+	WARN_ON(dev_xdp_install(&args, mode, bpf_op, NULL));
 	dev_xdp_set_link(dev, mode, NULL);
 	return 0;
 }
@@ -622,6 +636,10 @@ static int bpf_xdp_link_update(struct bpf_link *link,
 			       struct bpf_prog *old_prog)
 {
 	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
+	struct xdp_install_args args = {
+		.dev		= xdp_link->dev,
+		.flags		= xdp_link->flags,
+	};
 	enum bpf_xdp_mode mode;
 	bpf_op_t bpf_op;
 	int err = 0;
@@ -653,8 +671,7 @@ static int bpf_xdp_link_update(struct bpf_link *link,
 
 	mode = dev_xdp_mode(xdp_link->dev, xdp_link->flags);
 	bpf_op = dev_xdp_bpf_op(xdp_link->dev, mode);
-	err = dev_xdp_install(xdp_link->dev, mode, bpf_op, NULL,
-			      xdp_link->flags, new_prog);
+	err = dev_xdp_install(&args, mode, bpf_op, new_prog);
 	if (err)
 		goto out_unlock;
 
@@ -730,18 +747,16 @@ int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 
 /**
  *	dev_change_xdp_fd - set or clear a bpf program for a device rx path
- *	@dev: device
- *	@extack: netlink extended ack
+ *	@args: common XDP arguments (device, extended ack, flags etc.)
  *	@fd: new program fd or negative value to clear
  *	@expected_fd: old program fd that userspace expects to replace or clear
- *	@flags: xdp-related flags
  *
  *	Set or clear a bpf program for a device
  */
-int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, int expected_fd, u32 flags)
+int dev_change_xdp_fd(const struct xdp_install_args *args, int fd,
+		      int expected_fd)
 {
-	enum bpf_xdp_mode mode = dev_xdp_mode(dev, flags);
+	enum bpf_xdp_mode mode = dev_xdp_mode(args->dev, args->flags);
 	struct bpf_prog *new_prog = NULL, *old_prog = NULL;
 	int err;
 
@@ -764,7 +779,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		}
 	}
 
-	err = dev_xdp_attach(dev, extack, NULL, new_prog, old_prog, flags);
+	err = dev_xdp_attach(args, NULL, new_prog, old_prog);
 
 err_out:
 	if (err && new_prog)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ac45328607f7..5b06ded689b2 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2987,6 +2987,11 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 
 		if (xdp[IFLA_XDP_FD]) {
+			struct xdp_install_args args = {
+				.dev		= dev,
+				.extack		= extack,
+				.flags		= xdp_flags,
+			};
 			int expected_fd = -1;
 
 			if (xdp_flags & XDP_FLAGS_REPLACE) {
@@ -2998,10 +3003,9 @@ static int do_setlink(const struct sk_buff *skb,
 					nla_get_s32(xdp[IFLA_XDP_EXPECTED_FD]);
 			}
 
-			err = dev_change_xdp_fd(dev, extack,
+			err = dev_change_xdp_fd(&args,
 						nla_get_s32(xdp[IFLA_XDP_FD]),
-						expected_fd,
-						xdp_flags);
+						expected_fd);
 			if (err)
 				goto errout;
 			status |= DO_SETLINK_NOTIFY;
-- 
2.36.1

