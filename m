Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B939BC89B1
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 15:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfJBNap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 09:30:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbfJBNaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 09:30:35 -0400
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AABA664120
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 13:30:34 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id g88so2255284lje.10
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 06:30:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=MbRvjz+ayvhsM9IuG/jm9f41EnIQ3Vg+fezDs5aB4Tc=;
        b=VcUc4bHabRfnIX2jU8gXvBKqpRphzWhD9t9TdPg6L1xYtFlggXgK7Qw4R+9KWxpn5h
         JJe3eHYSzlz4Xgkr6DS0P3+FSRgK9S8v+doF77wbqmEenT5esBLLzEONMbasjRAuLVBg
         cUXbK/yu1zEFzEY7GveF3yCII/e5y9p8BtZkavxPZRcRn4u6KpuRcDI6TuT/uCkNElnE
         th6R+L1j3jHeb0okArRbrPVuWMwe+cXylv+oipW9dv4vkt/+ZEpv5EA/17wlMCxfMHCC
         bjtqeKIvJ1JvlSUrtIfHPczoce9dRpZq1wXCo7gBUPo1TUnA6dgZIwIwKl8YMTqTUNSS
         gy3w==
X-Gm-Message-State: APjAAAU89Tt9bcnEHxjAuhJ1EUfCjqRW1qUOHD5edjymJKFqyc1I+yQg
        ZYnYHPhyD/CNEbOHgn/qFbPhB+pl3R0yoWsB+lJkYEV4o9KleSD0kXFORRFLpxItirBZydkXEYZ
        j1BD6QzpuDtfH9ZLg
X-Received: by 2002:a2e:9049:: with SMTP id n9mr2265451ljg.45.1570023033163;
        Wed, 02 Oct 2019 06:30:33 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzhItDCSb7i8ynjfpi0BvSstWb51xyb3Rm9KKA3hObciBcFvKthQDh/jZ9n5jJ2l1fAb+QWGQ==
X-Received: by 2002:a2e:9049:: with SMTP id n9mr2265439ljg.45.1570023032936;
        Wed, 02 Oct 2019 06:30:32 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id x2sm4887334ljj.94.2019.10.02.06.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 06:30:31 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E513D180640; Wed,  2 Oct 2019 15:30:27 +0200 (CEST)
Subject: [PATCH bpf-next 3/9] xdp: Support setting and getting device chain
 map
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 02 Oct 2019 15:30:27 +0200
Message-ID: <157002302784.1302756.2073486805381846919.stgit@alrua-x1>
In-Reply-To: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds support to rtnetlink for setting and getting the per-device XDP
chain map. The map is set by means of a new netlink attribute that contains
a pointer to a BPF map of the XDP chain type. If such an attribute is
included, it will be inserted into the struct net_device so that the XDP
chain call code will pick it up on program execution.

To prevent old userspace programs that do not understand the chain map
attribute from messing up the chain call order, a netlink message with no
chain map attribute set will be rejected if a chain map has already been
installed.

When installing a new chain call map, an XDP program fd must also be
provided, otherwise the operation will be rejected.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/netdevice.h    |    3 ++-
 include/uapi/linux/if_link.h |    2 ++
 net/core/dev.c               |   42 ++++++++++++++++++++++++++++++++++++------
 net/core/rtnetlink.c         |   23 +++++++++++++++++++++++
 4 files changed, 63 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 48cc71aae466..60f3b510b175 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1941,6 +1941,7 @@ struct net_device {
 	unsigned int		real_num_rx_queues;
 
 	struct bpf_prog __rcu	*xdp_prog;
+	struct bpf_map __rcu	*xdp_chain_map;
 	unsigned long		gro_flush_timeout;
 	rx_handler_func_t __rcu	*rx_handler;
 	void __rcu		*rx_handler_data;
@@ -3702,7 +3703,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags);
+		      int prog_fd, int chain_map_fd, u32 flags);
 u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
 		    enum bpf_netdev_command cmd);
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 8aec8769d944..e7a704387608 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -976,6 +976,8 @@ enum {
 	IFLA_XDP_DRV_PROG_ID,
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
+	IFLA_XDP_CHAIN_MAP_FD,
+	IFLA_XDP_CHAIN_MAP_ID,
 	__IFLA_XDP_MAX,
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 7a456c6a7ad8..0aa5106339e7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8177,9 +8177,15 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 
 static void dev_xdp_uninstall(struct net_device *dev)
 {
+	struct bpf_map *chain_map = NULL;
 	struct netdev_bpf xdp;
 	bpf_op_t ndo_bpf;
 
+	/* Remove chain map */
+	rcu_swap_protected(dev->xdp_chain_map, chain_map, 1);
+	if(chain_map)
+		bpf_map_put_with_uref(chain_map);
+
 	/* Remove generic XDP */
 	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL));
 
@@ -8207,15 +8213,17 @@ static void dev_xdp_uninstall(struct net_device *dev)
  *	dev_change_xdp_fd - set or clear a bpf program for a device rx path
  *	@dev: device
  *	@extack: netlink extended ack
- *	@fd: new program fd or negative value to clear
+ *	@prog_fd: new program fd or negative value to clear
+ *	@chain_map_fd: new chain map fd or negative value to clear
  *	@flags: xdp-related flags
  *
  *	Set or clear a bpf program for a device
  */
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags)
+		      int prog_fd, int chain_map_fd, u32 flags)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
+	struct bpf_map *chain_map = NULL;
 	enum bpf_netdev_command query;
 	struct bpf_prog *prog = NULL;
 	bpf_op_t bpf_op, bpf_chk;
@@ -8237,7 +8245,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	if (bpf_op == bpf_chk)
 		bpf_chk = generic_xdp_install;
 
-	if (fd >= 0) {
+	if (prog_fd >= 0) {
 		u32 prog_id;
 
 		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
@@ -8251,7 +8259,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 			return -EBUSY;
 		}
 
-		prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
+		prog = bpf_prog_get_type_dev(prog_fd, BPF_PROG_TYPE_XDP,
 					     bpf_op == ops->ndo_bpf);
 		if (IS_ERR(prog))
 			return PTR_ERR(prog);
@@ -8267,13 +8275,35 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 			return 0;
 		}
 	} else {
+		if (chain_map_fd >= 0)
+			return -EINVAL;
+
 		if (!__dev_xdp_query(dev, bpf_op, query))
 			return 0;
 	}
 
+	if (chain_map_fd >= 0) {
+		chain_map = bpf_map_get_with_uref(chain_map_fd);
+		if (IS_ERR(chain_map))
+			return PTR_ERR(chain_map);
+
+		if (chain_map->map_type != BPF_MAP_TYPE_XDP_CHAIN) {
+			NL_SET_ERR_MSG(extack, "invalid chain map type");
+			bpf_map_put_with_uref(chain_map);
+			return -EINVAL;
+		}
+	}
+
 	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
-	if (err < 0 && prog)
-		bpf_prog_put(prog);
+	if (err < 0) {
+		if (prog)
+			bpf_prog_put(prog);
+	} else {
+		rcu_swap_protected(dev->xdp_chain_map, chain_map, 1);
+	}
+
+	if(chain_map)
+		bpf_map_put_with_uref(chain_map);
 
 	return err;
 }
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 49fa910b58af..d6123efdff80 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1427,6 +1427,7 @@ static int rtnl_xdp_report_one(struct sk_buff *skb, struct net_device *dev,
 
 static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
 {
+	struct bpf_map *chain_map;
 	struct nlattr *xdp;
 	u32 prog_id;
 	int err;
@@ -1461,6 +1462,13 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
 			goto err_cancel;
 	}
 
+	chain_map = rcu_dereference(dev->xdp_chain_map);
+	if (chain_map) {
+		err = nla_put_u32(skb, IFLA_XDP_CHAIN_MAP_ID, chain_map->id);
+		if (err)
+			goto err_cancel;
+	}
+
 	nla_nest_end(skb, xdp);
 	return 0;
 
@@ -2756,12 +2764,27 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 
 		if (xdp[IFLA_XDP_FD]) {
+			int chain_map_fd = -1;
+
+			if (xdp[IFLA_XDP_CHAIN_MAP_FD]) {
+				chain_map_fd = nla_get_s32(xdp[IFLA_XDP_CHAIN_MAP_FD]);
+			} else if (dev->xdp_chain_map) {
+				NL_SET_ERR_MSG(extack, "no chain map attribute, but chain map loaded");
+				err = -EINVAL;
+				goto errout;
+			}
+
 			err = dev_change_xdp_fd(dev, extack,
 						nla_get_s32(xdp[IFLA_XDP_FD]),
+						chain_map_fd,
 						xdp_flags);
 			if (err)
 				goto errout;
 			status |= DO_SETLINK_NOTIFY;
+		} else if (xdp[IFLA_XDP_CHAIN_MAP_FD]) {
+			err = -EINVAL;
+			NL_SET_ERR_MSG(extack, "chain map attribute invalid without prog fd");
+			goto errout;
 		}
 	}
 

