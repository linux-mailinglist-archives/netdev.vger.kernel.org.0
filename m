Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2A127F3E9
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbgI3VHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:07:30 -0400
Received: from mail.katalix.com ([3.9.82.81]:34406 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbgI3VH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 17:07:28 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 210ED96D56;
        Wed, 30 Sep 2020 22:07:25 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1601500045; bh=EKDDY7in4ql/2PryyF2xzU90BoKj5gQrXdmakbfXa2A=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=205/6]=20l2tp:=20add=
         20ac_pppoe=20pseudowire=20driver|Date:=20Wed,=2030=20Sep=202020=20
         22:07:06=20+0100|Message-Id:=20<20200930210707.10717-6-tparkin@kat
         alix.com>|In-Reply-To:=20<20200930210707.10717-1-tparkin@katalix.c
         om>|References:=20<20200930210707.10717-1-tparkin@katalix.com>;
        b=KuRxkKeU6xcOr5gTY35xyz5VCq9N0axvLCtrFA4ineiDBD5APyZm7aQgmRPOKgbAW
         y40IvG5caOpmDvSoQkv3xlgh+JWp+uor9kXICBh3taWu+I+A4IvOY5fAHqv+VNoUBj
         kqxj3rnyBy6tXDzy8h9dd6ccsWWrC+Yd26ivqJVXp/MOFFVwlhyVd2L7JzwbTzng8o
         T2WJyHb8XyGd7wrV7QiGk04LM5GESlDbW/W/NJTwQOOyt3PXRhd2+bGInvJXrh0nEq
         xKWrs7tYBDgzox5/F88SUA2KfPLyMy+tNxgmpOGGK/5vcXpoCTf4hbRQgGe5LPip+h
         6zpHJjAOCKXBQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 5/6] l2tp: add ac_pppoe pseudowire driver
Date:   Wed, 30 Sep 2020 22:07:06 +0100
Message-Id: <20200930210707.10717-6-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930210707.10717-1-tparkin@katalix.com>
References: <20200930210707.10717-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AC/PPPoE driver implements pseudowire type L2TP_PWTYPE_PPP_AC, for
use in a PPPoE Access Concentrator configuration.  Rather than
terminating the PPP session locally, the AC/PPPoE driver forwards PPP
packets over an L2TP tunnel for termination at the LNS.

l2tp_ac_pppoe provides a data path for PPPoE session packets, and
should be instantiated once a userspace process has completed the PPPoE
discovery process.

To create an instance of an L2TP_PWTYPE_PPP_AC pseudowire, userspace
must use the L2TP_CMD_SESSION_CREATE netlink command, and pass the
following attributes:

 * L2TP_ATTR_IFNAME, to specify the name of the interface associated
   with the PPPoE session;
 * L2TP_ATTR_PPPOE_SESSION_ID, to specify the PPPoE session ID assigned
   to the session;
 * L2TP_ATTR_PPPOE_PEER_MAC_ADDR, to specify the MAC address of the
   PPPoE peer

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/Kconfig         |   7 +
 net/l2tp/Makefile        |   1 +
 net/l2tp/l2tp_ac_pppoe.c | 446 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 454 insertions(+)
 create mode 100644 net/l2tp/l2tp_ac_pppoe.c

diff --git a/net/l2tp/Kconfig b/net/l2tp/Kconfig
index b7856748e960..f34d72070a6f 100644
--- a/net/l2tp/Kconfig
+++ b/net/l2tp/Kconfig
@@ -108,3 +108,10 @@ config L2TP_ETH
 
 	  To compile this driver as a module, choose M here. The module
 	  will be called l2tp_eth.
+
+config L2TP_AC_PPPOE
+	tristate "L2TP PPP Access Concentrator support"
+	depends on L2TP
+	help
+	  Support for tunneling PPP frames from PPPoE sessions in an L2TP
+	  session.
diff --git a/net/l2tp/Makefile b/net/l2tp/Makefile
index cf8f27071d3f..5bd66ae45eb6 100644
--- a/net/l2tp/Makefile
+++ b/net/l2tp/Makefile
@@ -16,3 +16,4 @@ obj-$(subst y,$(CONFIG_L2TP),$(CONFIG_L2TP_DEBUGFS)) += l2tp_debugfs.o
 ifneq ($(CONFIG_IPV6),)
 obj-$(subst y,$(CONFIG_L2TP),$(CONFIG_L2TP_IP)) += l2tp_ip6.o
 endif
+obj-$(subst y,$(CONFIG_L2TP),$(CONFIG_L2TP_AC_PPPOE)) += l2tp_ac_pppoe.o
diff --git a/net/l2tp/l2tp_ac_pppoe.c b/net/l2tp/l2tp_ac_pppoe.c
new file mode 100644
index 000000000000..59dce046c813
--- /dev/null
+++ b/net/l2tp/l2tp_ac_pppoe.c
@@ -0,0 +1,446 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* L2TP PPPoE access concentrator driver
+ *
+ * Copyright (c) 2020 Katalix Systems Ltd
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/if_pppox.h>
+#include <linux/l2tp.h>
+#include <linux/ppp_defs.h>
+#include <linux/etherdevice.h>
+
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
+
+#include "l2tp_core.h"
+
+#define L2TP_AC_PPPOE_SESSION_HASH_BITS 5
+#define L2TP_AC_PPPOE_SESSION_HASH_SIZE BIT(L2TP_AC_PPPOE_SESSION_HASH_BITS)
+
+/* Global hash list of PPPoE sessions.
+ * We hash on the PPPoE session ID, and scope session lookups to the
+ * associated netdev instance.
+ * Because the lookup is scoped to the netdev, it is practically
+ * scoped to the network namespace the netdev exists in.
+ */
+static struct hlist_head pppoe_session_hlist[L2TP_AC_PPPOE_SESSION_HASH_SIZE];
+static spinlock_t pppoe_session_hlist_lock;
+
+/* An AC PPPoE session instance */
+struct l2tp_ac_pppoe_session {
+	/* "Dead" flag used to prevent races between l2tp_core session delete
+	 * and session removal via. a netdev event.
+	 */
+	unsigned long			dead;
+	/* Device associated with the PPPoE session */
+	struct net_device __rcu		*dev;
+	/* PPPoE session ID */
+	u16				id;
+	/* Destination MAC address for PPPoE frames */
+	unsigned char			h_dest[ETH_ALEN];
+	/* L2TP session for this PPPoE session */
+	struct l2tp_session		*ls;
+	/* Entry on global hashlist */
+	struct hlist_node		hlist;
+};
+
+static struct hlist_head *l2tp_ac_pppoe_id_hash(u16 id)
+{
+	return &pppoe_session_hlist[hash_32(id, L2TP_AC_PPPOE_SESSION_HASH_BITS)];
+}
+
+/* Look up a PPPoE session instance by its ID.
+ * Must be called inside an rcu read lock.
+ */
+static struct l2tp_ac_pppoe_session *l2tp_ac_pppoe_find_by_id(struct net_device *dev, u16 id)
+{
+	struct l2tp_ac_pppoe_session *ps;
+	struct hlist_head *head;
+
+	head = l2tp_ac_pppoe_id_hash(id);
+
+	hlist_for_each_entry_rcu(ps, head, hlist)
+		if (ps->id == id)
+			if (rcu_dereference(ps->dev) == dev)
+				return ps;
+
+	return NULL;
+}
+
+static void l2tp_ac_pppoe_unhash_session(struct l2tp_ac_pppoe_session *ps)
+{
+	spin_lock_bh(&pppoe_session_hlist_lock);
+	hlist_del_init_rcu(&ps->hlist);
+	spin_unlock_bh(&pppoe_session_hlist_lock);
+	synchronize_rcu();
+}
+
+static void l2tp_ac_pppoe_kill_session(struct l2tp_ac_pppoe_session *ps)
+{
+	struct net_device *dev;
+
+	if (test_and_set_bit(0, &ps->dead))
+		return;
+
+	rcu_read_lock();
+	dev = rcu_dereference(ps->dev);
+	rcu_assign_pointer(ps->dev, NULL);
+	rcu_read_unlock();
+
+	/* This shouldn't occur, ref: l2tp_ac_pppoe_create_session
+	 * which holds a session reference around assigning the dev
+	 * pointer.
+	 */
+	if (WARN_ON(!dev))
+		return;
+
+	l2tp_ac_pppoe_unhash_session(ps);
+
+	/* Drop the references taken by the session */
+	dev_put(dev);
+	module_put(THIS_MODULE);
+}
+
+/* struct l2tp_session pseudowire close callback */
+static void l2tp_ac_pppoe_session_close(struct l2tp_session *ls)
+{
+	l2tp_ac_pppoe_kill_session(l2tp_session_priv(ls));
+}
+
+/* struct l2tp_session pseudowire recv callback */
+static void l2tp_ac_pppoe_recv_skb(struct l2tp_session *ls, struct sk_buff *skb, int l2tp_data_len)
+{
+	struct l2tp_ac_pppoe_session *ps = l2tp_session_priv(ls);
+	int data_len = skb->len;
+	struct net_device *dev;
+	struct pppoe_hdr *ph;
+
+	rcu_read_lock();
+
+	dev = rcu_dereference(ps->dev);
+	if (!dev)
+		goto drop;
+
+	if (skb_cow_head(skb, sizeof(*ph) + dev->hard_header_len))
+		goto drop;
+
+	/* If the user data has PPP Address and Control fields, strip them out.
+	 * This follows the approach of l2tp_ppp.c, which notes that although
+	 * use of these fields should in theory be negotiated and handled at
+	 * the PPP layer, the L2TP subsystem has always detected and removed
+	 * them.
+	 */
+	if (skb->data[0] == PPP_ALLSTATIONS && skb->data[1] == PPP_UI) {
+		if (pskb_may_pull(skb, 2)) {
+			skb_pull(skb, 2);
+			data_len -= 2;
+		}
+	}
+
+	/* Add PPPoE header */
+	__skb_push(skb, sizeof(*ph));
+	skb_reset_network_header(skb);
+
+	ph = pppoe_hdr(skb);
+	ph->ver = 0x1;
+	ph->type = 0x1;
+	ph->code = 0;
+	ph->sid = htons(ps->id);
+	ph->length = htons(data_len);
+
+	/* SKB settings */
+	skb->dev = dev;
+	skb->protocol = htons(ETH_P_PPP_SES);
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+	/* Add Ethernet header */
+	dev_hard_header(skb, dev, ETH_P_PPP_SES, ps->h_dest, NULL, data_len);
+
+	rcu_read_unlock();
+
+	dev_queue_xmit(skb);
+
+	return;
+
+drop:
+	rcu_read_unlock();
+	kfree_skb(skb);
+}
+
+/* struct l2tp_session pseudowire show callback */
+static void l2tp_ac_pppoe_show(struct seq_file *m, void *arg)
+{
+	struct l2tp_ac_pppoe_session *ps = l2tp_session_priv(arg);
+	struct net_device *dev;
+
+	rcu_read_lock();
+	dev = rcu_dereference(ps->dev);
+	if (!dev) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	seq_printf(m, "   interface %s\n", dev->name);
+	seq_printf(m, "   PPPoE session %d\n", ps->id);
+	seq_printf(m, "   client hwaddr %02X:%02X:%02X:%02X:%02X:%02X\n",
+		   ps->h_dest[0], ps->h_dest[1], ps->h_dest[2],
+		   ps->h_dest[3], ps->h_dest[4], ps->h_dest[5]);
+}
+
+static int l2tp_ac_pppoe_create_session(struct net_device *dev, u16 id,
+					unsigned char *peer_mac,
+					struct l2tp_tunnel *tunnel, u32 sid,
+					u32 psid, struct l2tp_session_cfg *cfg,
+					struct l2tp_ac_pppoe_session **out)
+{
+	struct l2tp_ac_pppoe_session *ps;
+	struct l2tp_session *ls;
+	int ret = 0;
+
+	ls = l2tp_session_create(sizeof(*ps), tunnel, sid, psid, cfg);
+	if (IS_ERR(ls)) {
+		ret = PTR_ERR(ls);
+		goto out;
+	}
+
+	ps = l2tp_session_priv(ls);
+	memcpy(ps->h_dest, peer_mac, ETH_ALEN);
+	ps->id = id;
+	ps->ls = ls;
+	INIT_HLIST_NODE(&ps->hlist);
+
+	ls->session_close = l2tp_ac_pppoe_session_close;
+	ls->recv_skb = l2tp_ac_pppoe_recv_skb;
+	if (IS_ENABLED(CONFIG_L2TP_DEBUGFS))
+		ls->show = l2tp_ac_pppoe_show;
+
+	/* Hold session refcount to ensure it can't go away until we have
+	 * assigned the dev pointer in struct l2tp_ac_pppoe_session and
+	 * taken a reference on the device.
+	 */
+	l2tp_session_inc_refcount(ls);
+
+	ret = l2tp_session_register(ls, tunnel);
+	if (ret < 0) {
+		l2tp_session_dec_refcount(ls);
+		goto out;
+	}
+
+	rcu_assign_pointer(ps->dev, dev);
+	dev_hold(ps->dev);
+
+	l2tp_session_dec_refcount(ls);
+
+	__module_get(THIS_MODULE);
+
+	*out = ps;
+
+out:
+	return ret;
+}
+
+/* Pass PPPoE packet into the associated L2TP session */
+static int l2tp_ac_pppoe_l2tp_xmit(struct net_device *dev, struct sk_buff *skb)
+{
+	struct l2tp_ac_pppoe_session *ps;
+	struct pppoe_hdr *ph;
+	int ret;
+
+	if (!pskb_may_pull(skb, sizeof(*ph)))
+		goto drop;
+
+	ph = pppoe_hdr(skb);
+
+	skb_pull(skb, sizeof(*ph));
+
+	rcu_read_lock();
+
+	ps = l2tp_ac_pppoe_find_by_id(dev, ntohs(ph->sid));
+	if (!ps)
+		goto unlock_drop;
+
+	ret = l2tp_xmit_skb(ps->ls, skb);
+	rcu_read_unlock();
+	return ret;
+
+unlock_drop:
+	rcu_read_unlock();
+drop:
+	kfree_skb(skb);
+	return NET_RX_DROP;
+}
+
+/* PPPoE session packet rx handler */
+static int l2tp_ac_pppoe_recv_pppoe(struct sk_buff *skb, struct net_device *dev,
+				    struct packet_type *pt,
+				    struct net_device *orig_dev)
+{
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
+		return NET_RX_DROP;
+	return l2tp_ac_pppoe_l2tp_xmit(dev, skb);
+}
+
+/* L2TP/netlink pseudowire create callback */
+static int l2tp_ac_pppoe_nl_create(struct net *net, struct l2tp_tunnel *tunnel,
+				   u32 sid, u32 psid,
+				   struct l2tp_session_cfg *cfg,
+				   struct genl_info *info)
+{
+	unsigned char peer_mac[ETH_ALEN];
+	struct l2tp_ac_pppoe_session *ps;
+	struct net_device *dev = NULL;
+	u16 pppoe_id;
+	int ret;
+
+	/* We must have PPPoE session ID, the PPPoE peer's MAC address.
+	 * and the name of the interface.  The latter has already been
+	 * unpacked into the session config structure by l2tp_netlink.c.
+	 */
+	if (!info->attrs[L2TP_ATTR_PPPOE_SESSION_ID]) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	pppoe_id = nla_get_u16(info->attrs[L2TP_ATTR_PPPOE_SESSION_ID]);
+	if (!pppoe_id) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!info->attrs[L2TP_ATTR_PPPOE_PEER_MAC_ADDR]) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* l2tp_netlink policy for mandates that PEER_MAC_ADDR must be of ETH_ALEN bytes */
+	memcpy(peer_mac, nla_data(info->attrs[L2TP_ATTR_PPPOE_PEER_MAC_ADDR]), ETH_ALEN);
+	if (!is_valid_ether_addr(peer_mac)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!cfg->ifname) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Look up the netdev of the specified name */
+	dev = dev_get_by_name(net, cfg->ifname);
+	if (!dev) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	/* Prevent ID clashes.
+	 * Note the genl lock prevents any race due to the gap between checking
+	 * for a clash and adding this session to the hash list, since:
+	 *  - ac_pppoe sessions can only be created by netlink command, and
+	 *  - l2tp_netlink doesn't enable parallel genl ops.
+	 */
+	rcu_read_lock();
+	if (l2tp_ac_pppoe_find_by_id(dev, pppoe_id)) {
+		ret = -EALREADY;
+		rcu_read_unlock();
+		goto out;
+	}
+	rcu_read_unlock();
+
+	ret = l2tp_ac_pppoe_create_session(dev, pppoe_id, peer_mac, tunnel, sid, psid, cfg, &ps);
+	if (ret != 0)
+		goto out;
+
+	/* Add session to global hash */
+	spin_lock_bh(&pppoe_session_hlist_lock);
+	hlist_add_head_rcu(&ps->hlist, l2tp_ac_pppoe_id_hash(pppoe_id));
+	spin_unlock_bh(&pppoe_session_hlist_lock);
+
+out:
+	/* Drop dev reference if we have it: the session takes its own reference */
+	if (dev)
+		dev_put(dev);
+	return ret;
+}
+
+static int l2tp_ac_pppoe_netdevice_event(struct notifier_block *unused,
+					 unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct l2tp_ac_pppoe_session *ps;
+	int hash;
+
+	if (event == NETDEV_UNREGISTER) {
+		rcu_read_lock();
+		for (hash = 0; hash < L2TP_AC_PPPOE_SESSION_HASH_SIZE; hash++)
+			hlist_for_each_entry_rcu(ps, &pppoe_session_hlist[hash], hlist)
+				if (ps->dev == dev)
+					l2tp_ac_pppoe_kill_session(ps);
+		rcu_read_unlock();
+		return NOTIFY_OK;
+	}
+	return NOTIFY_DONE;
+}
+
+/******************************************************************************
+ * Init and cleanup
+ */
+
+static const struct l2tp_nl_cmd_ops l2tp_ac_pppoe_nl_cmd_ops = {
+	.session_create	= l2tp_ac_pppoe_nl_create,
+	/* Our cleanup is handled via. the session_close callback, called by l2tp_session_delete */
+	.session_delete	= l2tp_session_delete,
+};
+
+static struct packet_type pppoes_ptype = {
+	.type	= htons(ETH_P_PPP_SES),
+	.func	= l2tp_ac_pppoe_recv_pppoe,
+};
+
+static struct notifier_block l2tp_ac_pppoe_notifier_block = {
+	.notifier_call = l2tp_ac_pppoe_netdevice_event,
+};
+
+static int __init l2tp_ac_pppoe_init(void)
+{
+	int err, hash;
+
+	spin_lock_init(&pppoe_session_hlist_lock);
+	for (hash = 0; hash < L2TP_AC_PPPOE_SESSION_HASH_SIZE; hash++)
+		INIT_HLIST_HEAD(&pppoe_session_hlist[hash]);
+
+	err = l2tp_nl_register_ops(L2TP_PWTYPE_PPP_AC, &l2tp_ac_pppoe_nl_cmd_ops);
+	if (err)
+		return err;
+
+	err = register_netdevice_notifier(&l2tp_ac_pppoe_notifier_block);
+	if (err) {
+		l2tp_nl_unregister_ops(L2TP_PWTYPE_PPP_AC);
+		return err;
+	}
+
+	dev_add_pack(&pppoes_ptype);
+
+	pr_info("L2TP AC PPPoE support\n");
+
+	return err;
+}
+
+static void __exit l2tp_ac_pppoe_exit(void)
+{
+	l2tp_nl_unregister_ops(L2TP_PWTYPE_PPP_AC);
+	unregister_netdevice_notifier(&l2tp_ac_pppoe_notifier_block);
+	dev_remove_pack(&pppoes_ptype);
+}
+
+module_init(l2tp_ac_pppoe_init);
+module_exit(l2tp_ac_pppoe_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tom Parkin <tparkin@katalix.com>");
+MODULE_DESCRIPTION("L2TP AC PPPoE driver");
+MODULE_VERSION("1.0");
+MODULE_ALIAS_L2TP_PWTYPE(8);
-- 
2.17.1

