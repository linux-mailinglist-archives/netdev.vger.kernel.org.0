Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E0E192F1B
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgCYRXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 13:23:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:56897 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727685AbgCYRXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 13:23:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585157011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k5hr2aQZeEb8hZ8qYomsvDOaw9krebjQTQ3Tidf7gec=;
        b=hvkQ3XF0gB7HvSXQpgQZQQv0YmkxU2gYvh2tJjVJjx56PB/bAt1RVCHXG96zApx7LU9vAt
        JqbdlcXoyoZYwctCEh3w6N+lcbexMsXIsRAOXPXQETzE4NY/bSPmOBntuO+OA5jkBTZuZA
        +nfkkMdofN71XmwFyyZ8a7iStDSTWkE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-x3bD39ZoNSilUoGfttxPnQ-1; Wed, 25 Mar 2020 13:23:29 -0400
X-MC-Unique: x3bD39ZoNSilUoGfttxPnQ-1
Received: by mail-lf1-f71.google.com with SMTP id j3so1109622lfe.10
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 10:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=k5hr2aQZeEb8hZ8qYomsvDOaw9krebjQTQ3Tidf7gec=;
        b=oS26rRI7JeTgegqt8WCAG04/pSPDkjEZfLiqzUq0qrN4YaMiQzsg+JD5R7HYBuZ6ob
         gIolxqOYo9ffvh0VY77U7f6H1ckGoi62jhYs1YyNT7yVpz6omTmLD8A5GmMyyOc/sQC5
         evR1D1sL++LNpzgDo76AXQ9BOvEjA01Wz8Bsi1bhtDdw4ARG4BRohpvWK/2eoRvjW+sh
         X6bqiNokbOFkRpiGkaqilkaTdlhpoFwDcNRtJnjLBLzkjet5j4eZ69OoX6TaxesjeQB6
         A2GLy+gzcdwI0h4svynNJEWQKMOba8remzU/OZ3Nk6le5VUukOpyJLbzmSzDT5E0VFYF
         EP6Q==
X-Gm-Message-State: ANhLgQ2FucMR3YMThIgL6WvjfJdU9zsIBBPdxk4/E4qGyd5a8sA6ujHQ
        ANR2YzZm5bv4SxvkRJBA6ATPxlBSjICmjZ+Cd7HnkNUVvTKDbC9XSDd3PGBPmvR7rRqUTv7WCHd
        sCbXyR69iol1LxG4v
X-Received: by 2002:ac2:4309:: with SMTP id l9mr2949747lfh.65.1585157008061;
        Wed, 25 Mar 2020 10:23:28 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvw94eQR7JpRbshHnHYbaZ3gUDI6xS3iCk74YM8ZCWpwuGcETt3HjsTv47oTnIA5Vo5fzRPzQ==
X-Received: by 2002:ac2:4309:: with SMTP id l9mr2949714lfh.65.1585157007734;
        Wed, 25 Mar 2020 10:23:27 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m21sm12313936ljb.89.2020.03.25.10.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 10:23:27 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 72D0018158C; Wed, 25 Mar 2020 18:23:26 +0100 (CET)
Subject: [PATCH bpf-next v4 1/4] xdp: Support specifying expected existing
 program when attaching XDP
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Andrey Ignatov <rdna@fb.com>
Date:   Wed, 25 Mar 2020 18:23:26 +0100
Message-ID: <158515700640.92963.3551295145441017022.stgit@toke.dk>
In-Reply-To: <158515700529.92963.17609642163080084530.stgit@toke.dk>
References: <158515700529.92963.17609642163080084530.stgit@toke.dk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

While it is currently possible for userspace to specify that an existing
XDP program should not be replaced when attaching to an interface, there is
no mechanism to safely replace a specific XDP program with another.

This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, which can be
set along with IFLA_XDP_FD. If set, the kernel will check that the program
currently loaded on the interface matches the expected one, and fail the
operation if it does not. This corresponds to a 'cmpxchg' memory operation.
Setting the new attribute with a negative value means that no program is
expected to be attached, which corresponds to setting the UPDATE_IF_NOEXIST
flag.

A new companion flag, XDP_FLAGS_REPLACE, is also added to explicitly
request checking of the EXPECTED_FD attribute. This is needed for userspace
to discover whether the kernel supports the new attribute.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/netdevice.h    |    2 +-
 include/uapi/linux/if_link.h |    4 +++-
 net/core/dev.c               |   26 +++++++++++++++++++++-----
 net/core/rtnetlink.c         |   14 ++++++++++++++
 4 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 654808bfad83..b503d468f0df 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3768,7 +3768,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags);
+		      int fd, int expected_fd, u32 flags);
 u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
 		    enum bpf_netdev_command cmd);
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 61e0801c82df..c2f768c8d65b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -972,11 +972,12 @@ enum {
 #define XDP_FLAGS_SKB_MODE		(1U << 1)
 #define XDP_FLAGS_DRV_MODE		(1U << 2)
 #define XDP_FLAGS_HW_MODE		(1U << 3)
+#define XDP_FLAGS_REPLACE		(1U << 4)
 #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
 					 XDP_FLAGS_DRV_MODE | \
 					 XDP_FLAGS_HW_MODE)
 #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
-					 XDP_FLAGS_MODES)
+					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE)
 
 /* These are stored into IFLA_XDP_ATTACHED on dump. */
 enum {
@@ -996,6 +997,7 @@ enum {
 	IFLA_XDP_DRV_PROG_ID,
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
+	IFLA_XDP_EXPECTED_FD,
 	__IFLA_XDP_MAX,
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index d84541c24446..651a3c28d33a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8655,15 +8655,17 @@ static void dev_xdp_uninstall(struct net_device *dev)
  *	@dev: device
  *	@extack: netlink extended ack
  *	@fd: new program fd or negative value to clear
+ *	@expected_fd: old program fd that userspace expects to replace or clear
  *	@flags: xdp-related flags
  *
  *	Set or clear a bpf program for a device
  */
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags)
+		      int fd, int expected_fd, u32 flags)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	enum bpf_netdev_command query;
+	u32 prog_id, expected_id = 0;
 	struct bpf_prog *prog = NULL;
 	bpf_op_t bpf_op, bpf_chk;
 	bool offload;
@@ -8684,15 +8686,29 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	if (bpf_op == bpf_chk)
 		bpf_chk = generic_xdp_install;
 
-	if (fd >= 0) {
-		u32 prog_id;
+	prog_id = __dev_xdp_query(dev, bpf_op, query);
+	if (flags & XDP_FLAGS_REPLACE) {
+		if (expected_fd >= 0) {
+			prog = bpf_prog_get_type_dev(expected_fd,
+						     BPF_PROG_TYPE_XDP,
+						     bpf_op == ops->ndo_bpf);
+			if (IS_ERR(prog))
+				return PTR_ERR(prog);
+			expected_id = prog->aux->id;
+			bpf_prog_put(prog);
+		}
 
+		if (prog_id != expected_id) {
+			NL_SET_ERR_MSG(extack, "Active program does not match expected");
+			return -EEXIST;
+		}
+	}
+	if (fd >= 0) {
 		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
 			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
 			return -EEXIST;
 		}
 
-		prog_id = __dev_xdp_query(dev, bpf_op, query);
 		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && prog_id) {
 			NL_SET_ERR_MSG(extack, "XDP program already attached");
 			return -EBUSY;
@@ -8715,7 +8731,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 			return 0;
 		}
 	} else {
-		if (!__dev_xdp_query(dev, bpf_op, query))
+		if (!prog_id)
 			return 0;
 	}
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 14e6ea21c378..709ebbf8ab5b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1872,7 +1872,9 @@ static const struct nla_policy ifla_port_policy[IFLA_PORT_MAX+1] = {
 };
 
 static const struct nla_policy ifla_xdp_policy[IFLA_XDP_MAX + 1] = {
+	[IFLA_XDP_UNSPEC]	= { .strict_start_type = IFLA_XDP_EXPECTED_FD },
 	[IFLA_XDP_FD]		= { .type = NLA_S32 },
+	[IFLA_XDP_EXPECTED_FD]	= { .type = NLA_S32 },
 	[IFLA_XDP_ATTACHED]	= { .type = NLA_U8 },
 	[IFLA_XDP_FLAGS]	= { .type = NLA_U32 },
 	[IFLA_XDP_PROG_ID]	= { .type = NLA_U32 },
@@ -2799,8 +2801,20 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 
 		if (xdp[IFLA_XDP_FD]) {
+			int expected_fd = -1;
+
+			if (xdp_flags & XDP_FLAGS_REPLACE) {
+				if (!xdp[IFLA_XDP_EXPECTED_FD]) {
+					err = -EINVAL;
+					goto errout;
+				}
+				expected_fd =
+					nla_get_s32(xdp[IFLA_XDP_EXPECTED_FD]);
+			}
+
 			err = dev_change_xdp_fd(dev, extack,
 						nla_get_s32(xdp[IFLA_XDP_FD]),
+						expected_fd,
 						xdp_flags);
 			if (err)
 				goto errout;

