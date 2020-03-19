Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA1AA18B4DF
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbgCSNNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:13:23 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:41323 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727457AbgCSNNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:13:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584623597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FKAKULdXX3NFx+6MxVA4WzdMEWsVTjMw9Bd0ud5/okA=;
        b=GqVt+PZ9WFTpHGR/7X2YVEtsFJ3UZY277vYS8DjQ54JDnogfvlHdQjH78Zstg6qkIfyZGW
        eInBkwHUOaW0+GFBBvstDfj0lj7n9uN3ojHKCGoP2Sh+fnwCBio9BUgO0CGdcKi4fbougg
        jnspbM23GNW6xXPIWdst4c+eTHC+UHY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-Kx9RQI7oOUG8fYE9AaGKTA-1; Thu, 19 Mar 2020 09:13:15 -0400
X-MC-Unique: Kx9RQI7oOUG8fYE9AaGKTA-1
Received: by mail-wm1-f70.google.com with SMTP id n188so685242wmf.0
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 06:13:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=FKAKULdXX3NFx+6MxVA4WzdMEWsVTjMw9Bd0ud5/okA=;
        b=fb7Zj/H7WTWUpNjUIuBhrmhjuKle9J4aJEs60iZt+NjrXK595/6eXCBHRQ7X8D43G0
         kkRkHAxtb0rJgRuPkIf1fzhq0p1i8xp9Qfil1M4LgqfKBUi9cq1VykFNP0EHIf9Chsee
         V1OFEhNUumIEzsoXYQFhN5mq5hLqN0yH2pqAUF6anBpvoUOfy8v1i3fM5kbTJIqKZObG
         KCQmr8V9+joZQ3mFSSLC1qjmsfhLvcrdaMWQYJ3iCSH7qhu6OvDRsdbjX4nZ49j3wFMQ
         NkagFQ2x2FJ8eKv6+JGJbYlYb7UbpnRYWzopa1HmuT3j4Xtt+uFVyCvnMv6SESlIxxMN
         K0oA==
X-Gm-Message-State: ANhLgQ2KKewdDrbH1zjtdd8+T2M50WQx+889bt451eu+63htkBF+WUkK
        RMS0Dijv/K8zZgk4Pro3wcmn4i12Wk4zgqcLeZZlWmYN25Ydkbqjxj4NbUU4PxjPXpwlPJF0cZC
        JIR7Vjya++vckvLYB
X-Received: by 2002:a5d:5089:: with SMTP id a9mr4323484wrt.187.1584623594474;
        Thu, 19 Mar 2020 06:13:14 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvnYxlGJTIbDXWeGk2deGexfPbab5uRwaBVl91k2hv/ZO57xVT+n3WEZmpNy8u3dfpZ+nIhTg==
X-Received: by 2002:a5d:5089:: with SMTP id a9mr4323455wrt.187.1584623594269;
        Thu, 19 Mar 2020 06:13:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b17sm3568133wrn.87.2020.03.19.06.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 06:13:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3D56318038E; Thu, 19 Mar 2020 14:13:13 +0100 (CET)
Subject: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 19 Mar 2020 14:13:13 +0100
Message-ID: <158462359315.164779.13931660750493121404.stgit@toke.dk>
In-Reply-To: <158462359206.164779.15902346296781033076.stgit@toke.dk>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
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

A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to explicitly
request checking of the EXPECTED_FD attribute. This is needed for userspace
to discover whether the kernel supports the new attribute.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/netdevice.h    |    2 +-
 include/uapi/linux/if_link.h |    4 +++-
 net/core/dev.c               |   25 ++++++++++++++++++++-----
 net/core/rtnetlink.c         |   11 +++++++++++
 4 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b6fedd54cd8e..40b12bd93913 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3767,7 +3767,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags);
+		      int fd, int expected_fd, u32 flags);
 u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
 		    enum bpf_netdev_command cmd);
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 61e0801c82df..314173f8079e 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -972,11 +972,12 @@ enum {
 #define XDP_FLAGS_SKB_MODE		(1U << 1)
 #define XDP_FLAGS_DRV_MODE		(1U << 2)
 #define XDP_FLAGS_HW_MODE		(1U << 3)
+#define XDP_FLAGS_EXPECT_FD		(1U << 4)
 #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
 					 XDP_FLAGS_DRV_MODE | \
 					 XDP_FLAGS_HW_MODE)
 #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
-					 XDP_FLAGS_MODES)
+					 XDP_FLAGS_MODES | XDP_FLAGS_EXPECT_FD)
 
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
index 25dab1598803..44095326b8d5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8654,15 +8654,17 @@ static void dev_xdp_uninstall(struct net_device *dev)
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
@@ -8683,15 +8685,28 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	if (bpf_op == bpf_chk)
 		bpf_chk = generic_xdp_install;
 
-	if (fd >= 0) {
-		u32 prog_id;
+	prog_id = __dev_xdp_query(dev, bpf_op, query);
+	if (expected_fd >= 0 || (flags & XDP_FLAGS_EXPECT_FD)) {
+		if (expected_fd >= 0) {
+			prog = bpf_prog_get_type_dev(expected_fd, BPF_PROG_TYPE_XDP,
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
@@ -8714,7 +8729,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 			return 0;
 		}
 	} else {
-		if (!__dev_xdp_query(dev, bpf_op, query))
+		if (!prog_id)
 			return 0;
 	}
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 14e6ea21c378..09c08980f6f6 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1873,6 +1873,7 @@ static const struct nla_policy ifla_port_policy[IFLA_PORT_MAX+1] = {
 
 static const struct nla_policy ifla_xdp_policy[IFLA_XDP_MAX + 1] = {
 	[IFLA_XDP_FD]		= { .type = NLA_S32 },
+	[IFLA_XDP_EXPECTED_FD]	= { .type = NLA_S32 },
 	[IFLA_XDP_ATTACHED]	= { .type = NLA_U8 },
 	[IFLA_XDP_FLAGS]	= { .type = NLA_U32 },
 	[IFLA_XDP_PROG_ID]	= { .type = NLA_U32 },
@@ -2799,8 +2800,18 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 
 		if (xdp[IFLA_XDP_FD]) {
+			int expected_fd = -1;
+
+			if (xdp[IFLA_XDP_EXPECTED_FD]) {
+				expected_fd = nla_get_s32(xdp[IFLA_XDP_EXPECTED_FD]);
+			} else if(xdp_flags & XDP_FLAGS_EXPECT_FD) {
+				err = -EINVAL;
+				goto errout;
+			}
+
 			err = dev_change_xdp_fd(dev, extack,
 						nla_get_s32(xdp[IFLA_XDP_FD]),
+						expected_fd,
 						xdp_flags);
 			if (err)
 				goto errout;

