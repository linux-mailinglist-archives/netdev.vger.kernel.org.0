Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419B3498667
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244423AbiAXRUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:20:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56166 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244398AbiAXRUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:20:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51872612FA;
        Mon, 24 Jan 2022 17:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038A7C340E7;
        Mon, 24 Jan 2022 17:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643044831;
        bh=2stwZ5ekO5a4ROCROuQftRDYtnk3zAKl0kZa60Avkjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGXAnDlImLxMK98x2PuAQzTnmgxmraT+LgGG1n/bQRN/TRI8wMk7xM2ss7ndGZXRo
         cZNQOMc6URKADHZeJ/UyZ6RZaKbSmN9TQ34LyK9msKFGLCZHuNzu6Nc9XjgbUF1vAY
         RkYVIG7q6zEdlbY8azjyewJSwETUOdl7ZLvZsdPi3HAKk55DjMYuWPr6yaz2+YIBR7
         TKJAfBmUtOZ/2h8Xno58IDqaG2nZX5HvuixLFB2eFt0ZGja3B2GNTfRJh2vBBWoDyO
         V4R08GC2mKmOwb+g3Amk5dwVmjgKB8Z//z5AF0eVehT6ZNVdaR+asiPsCAykBwOMaJ
         8acaUPVPZ8z9A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, dsahern@kernel.org,
        komachi.yoshiki@gmail.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, andrii.nakryiko@gmail.com
Subject: [RFC bpf-next 1/2] net: bridge: add unstable br_fdb_find_port_from_ifindex helper
Date:   Mon, 24 Jan 2022 18:20:15 +0100
Message-Id: <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643044381.git.lorenzo@kernel.org>
References: <cover.1643044381.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to bpf_xdp_ct_lookup routine, introduce
br_fdb_find_port_from_ifindex unstable helper in order to accelerate
linux bridge with XDP. br_fdb_find_port_from_ifindex will perform a
lookup in the associated bridge fdb table and it will return the
output ifindex if the destination address is associated to a bridge
port or -ENODEV for BOM traffic or if lookup fails.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/bridge/br.c         | 21 +++++++++++++
 net/bridge/br_fdb.c     | 67 +++++++++++++++++++++++++++++++++++------
 net/bridge/br_private.h | 12 ++++++++
 3 files changed, 91 insertions(+), 9 deletions(-)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 1fac72cc617f..d2d1c2341d9c 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -16,6 +16,8 @@
 #include <net/llc.h>
 #include <net/stp.h>
 #include <net/switchdev.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
 
 #include "br_private.h"
 
@@ -365,6 +367,17 @@ static const struct stp_proto br_stp_proto = {
 	.rcv	= br_stp_rcv,
 };
 
+#if (IS_ENABLED(CONFIG_DEBUG_INFO_BTF) || IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
+BTF_SET_START(br_xdp_fdb_check_kfunc_ids)
+BTF_ID(func, br_fdb_find_port_from_ifindex)
+BTF_SET_END(br_xdp_fdb_check_kfunc_ids)
+
+static const struct btf_kfunc_id_set br_xdp_fdb_kfunc_set = {
+	.owner     = THIS_MODULE,
+	.check_set = &br_xdp_fdb_check_kfunc_ids,
+};
+#endif
+
 static int __init br_init(void)
 {
 	int err;
@@ -417,6 +430,14 @@ static int __init br_init(void)
 		"need this.\n");
 #endif
 
+#if (IS_ENABLED(CONFIG_DEBUG_INFO_BTF) || IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &br_xdp_fdb_kfunc_set);
+	if (err < 0) {
+		br_netlink_fini();
+		goto err_out6;
+	}
+#endif
+
 	return 0;
 
 err_out6:
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6ccda68bd473..cd3afa240298 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -235,30 +235,79 @@ static struct net_bridge_fdb_entry *br_fdb_find(struct net_bridge *br,
 	return fdb;
 }
 
-struct net_device *br_fdb_find_port(const struct net_device *br_dev,
-				    const unsigned char *addr,
-				    __u16 vid)
+static struct net_device *
+__br_fdb_find_port(const struct net_device *br_dev,
+		   const unsigned char *addr,
+		   __u16 vid, bool ts_update)
 {
 	struct net_bridge_fdb_entry *f;
-	struct net_device *dev = NULL;
 	struct net_bridge *br;
 
-	ASSERT_RTNL();
-
 	if (!netif_is_bridge_master(br_dev))
 		return NULL;
 
 	br = netdev_priv(br_dev);
-	rcu_read_lock();
 	f = br_fdb_find_rcu(br, addr, vid);
-	if (f && f->dst)
-		dev = f->dst->dev;
+
+	if (f && f->dst) {
+		f->updated = jiffies;
+		f->used = f->updated;
+		return f->dst->dev;
+	}
+	return NULL;
+}
+
+struct net_device *br_fdb_find_port(const struct net_device *br_dev,
+				    const unsigned char *addr,
+				    __u16 vid)
+{
+	struct net_device *dev;
+
+	ASSERT_RTNL();
+
+	rcu_read_lock();
+	dev = __br_fdb_find_port(br_dev, addr, vid, false);
 	rcu_read_unlock();
 
 	return dev;
 }
 EXPORT_SYMBOL_GPL(br_fdb_find_port);
 
+int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
+				  struct bpf_fdb_lookup *opt,
+				  u32 opt__sz)
+{
+	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
+	struct net_bridge_port *port;
+	struct net_device *dev;
+	int ret = -ENODEV;
+
+	BUILD_BUG_ON(sizeof(struct bpf_fdb_lookup) != NF_BPF_FDB_OPTS_SZ);
+	if (!opt || opt__sz != sizeof(struct bpf_fdb_lookup))
+		return -ENODEV;
+
+	rcu_read_lock();
+
+	dev = dev_get_by_index_rcu(dev_net(ctx->rxq->dev), opt->ifindex);
+	if (!dev)
+		goto out;
+
+	if (unlikely(!netif_is_bridge_port(dev)))
+		goto out;
+
+	port = br_port_get_check_rcu(dev);
+	if (unlikely(!port || !port->br))
+		goto out;
+
+	dev = __br_fdb_find_port(port->br->dev, opt->addr, opt->vid, true);
+	if (dev)
+		ret = dev->ifindex;
+out:
+	rcu_read_unlock();
+
+	return ret;
+}
+
 struct net_bridge_fdb_entry *br_fdb_find_rcu(struct net_bridge *br,
 					     const unsigned char *addr,
 					     __u16 vid)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2661dda1a92b..64d4f1727da2 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -18,6 +18,7 @@
 #include <linux/if_vlan.h>
 #include <linux/rhashtable.h>
 #include <linux/refcount.h>
+#include <linux/bpf.h>
 
 #define BR_HASH_BITS 8
 #define BR_HASH_SIZE (1 << BR_HASH_BITS)
@@ -2094,4 +2095,15 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 		       u16 vid, struct net_bridge_port *p, struct nd_msg *msg);
 struct nd_msg *br_is_nd_neigh_msg(struct sk_buff *skb, struct nd_msg *m);
+
+#define NF_BPF_FDB_OPTS_SZ	12
+struct bpf_fdb_lookup {
+	u8	addr[ETH_ALEN]; /* ETH_ALEN */
+	u16	vid;
+	u32	ifindex;
+};
+
+int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
+				  struct bpf_fdb_lookup *opt,
+				  u32 opt__sz);
 #endif
-- 
2.34.1

