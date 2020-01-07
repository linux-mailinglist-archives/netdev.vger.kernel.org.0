Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3314C132A56
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgAGPqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:46:06 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59047 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728405AbgAGPqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:46:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E917D22015;
        Tue,  7 Jan 2020 10:45:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 07 Jan 2020 10:45:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=i+kknurHdGBWNwwBn6shognc4waI42eMe4gpNvX0nuw=; b=TL2bZGcp
        0yeOpLZAELPOR/H4GjCCLW8bh6B+qrYrwdDv+jcfeXu/2M/XunRk2Lial6fqo/vP
        34JimCSaNkecOL9wUdqPmXBTPfwXz6b/SNMvfFcahhE4rByO8x29RZb/PogDDh1y
        kzcfU/4P+iY2I0l3J1adVtDLacmrGN1CNs/GDX2KcOx1rzX9xs5ptIVXEj+zuECy
        BFRuhLdZPhBopgcRHDIRL7KsjHVQA8HNbBPDHrnJgUrGKa3sd56kdc0rwkwY/RuL
        ibJypv4JGZ6aM+GEN2qw1FrSkequc5HubZ2JiklMzwvRJ1C+pd4KgNyoSBSJa98V
        PX7GR6VpiP2uLQ==
X-ME-Sender: <xms:tqcUXrlvTJEd7Uv8nwiVVLBz8C7KuVrqIPBjucyGZCkXzq7XVlIctA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehgedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeh
X-ME-Proxy: <xmx:tqcUXhHMRfV7SyQXmcZ1omk0zoA-RoSMPifKfU5UqjqfzKGiDiWp6A>
    <xmx:tqcUXj4F_-zTC3IKp32JpYP0PZoJdHsklSfiGFCMb0b5WgvpDH1iXQ>
    <xmx:tqcUXpldIi9hKM5k1yHMubw2E8HLTPNBqEAiAokh-HS3swm8DsoKqA>
    <xmx:tqcUXv01KWXVKv9G3inUlwuu7ch10wLYulXSju15r5v4eWAeQkOodQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 245328005C;
        Tue,  7 Jan 2020 10:45:57 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/10] netdevsim: fib: Add dummy implementation for FIB offload
Date:   Tue,  7 Jan 2020 17:45:14 +0200
Message-Id: <20200107154517.239665-8-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107154517.239665-1-idosch@idosch.org>
References: <20200107154517.239665-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Implement dummy IPv4 and IPv6 FIB "offload" in the driver by storing
currently "programmed" routes in a hash table. Each route in the hash
table is marked with "trap" indication. The indication is cleared when
the route is replaced or when the netdevsim instance is deleted.

This will later allow us to test the route offload API on top of
netdevsim.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/Kconfig         |   1 +
 drivers/net/netdevsim/fib.c | 664 +++++++++++++++++++++++++++++++++++-
 2 files changed, 656 insertions(+), 9 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 01e2657e4c26..e65ed4d0a7ad 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -549,6 +549,7 @@ source "drivers/net/hyperv/Kconfig"
 config NETDEVSIM
 	tristate "Simulated networking device"
 	depends on DEBUG_FS
+	depends on IPV6 || IPV6=n
 	select NET_DEVLINK
 	help
 	  This driver is a developer testing tool and software model that can
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index b5df308b4e33..82ee44569d3b 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -14,6 +14,12 @@
  * THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
  */
 
+#include <linux/in6.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/rhashtable.h>
+#include <linux/spinlock_types.h>
+#include <linux/types.h>
 #include <net/fib_notifier.h>
 #include <net/ip_fib.h>
 #include <net/ip6_fib.h>
@@ -36,6 +42,48 @@ struct nsim_fib_data {
 	struct notifier_block fib_nb;
 	struct nsim_per_fib_data ipv4;
 	struct nsim_per_fib_data ipv6;
+	struct rhashtable fib_rt_ht;
+	struct list_head fib_rt_list;
+	spinlock_t fib_lock;	/* Protects hashtable, list and accounting */
+	struct devlink *devlink;
+};
+
+struct nsim_fib_rt_key {
+	unsigned char addr[sizeof(struct in6_addr)];
+	unsigned char prefix_len;
+	int family;
+	u32 tb_id;
+};
+
+struct nsim_fib_rt {
+	struct nsim_fib_rt_key key;
+	struct rhash_head ht_node;
+	struct list_head list;	/* Member of fib_rt_list */
+};
+
+struct nsim_fib4_rt {
+	struct nsim_fib_rt common;
+	struct fib_info *fi;
+	u8 tos;
+	u8 type;
+};
+
+struct nsim_fib6_rt {
+	struct nsim_fib_rt common;
+	struct list_head nh_list;
+	unsigned int nhs;
+};
+
+struct nsim_fib6_rt_nh {
+	struct list_head list;	/* Member of nh_list */
+	struct fib6_info *rt;
+};
+
+static const struct rhashtable_params nsim_fib_rt_ht_params = {
+	.key_offset = offsetof(struct nsim_fib_rt, key),
+	.head_offset = offsetof(struct nsim_fib_rt, ht_node),
+	.key_len = sizeof(struct nsim_fib_rt_key),
+	.automatic_shrinking = true,
 };
 
 u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
@@ -144,18 +192,549 @@ static int nsim_fib_account(struct nsim_fib_entry *entry, bool add,
 	return err;
 }
 
+static void nsim_fib_rt_init(struct nsim_fib_data *data,
+			     struct nsim_fib_rt *fib_rt, const void *addr,
+			     size_t addr_len, unsigned int prefix_len,
+			     int family, u32 tb_id)
+{
+	memcpy(fib_rt->key.addr, addr, addr_len);
+	fib_rt->key.prefix_len = prefix_len;
+	fib_rt->key.family = family;
+	fib_rt->key.tb_id = tb_id;
+	list_add(&fib_rt->list, &data->fib_rt_list);
+}
+
+static void nsim_fib_rt_fini(struct nsim_fib_rt *fib_rt)
+{
+	list_del(&fib_rt->list);
+}
+
+static struct nsim_fib_rt *nsim_fib_rt_lookup(struct rhashtable *fib_rt_ht,
+					      const void *addr, size_t addr_len,
+					      unsigned int prefix_len,
+					      int family, u32 tb_id)
+{
+	struct nsim_fib_rt_key key;
+
+	memset(&key, 0, sizeof(key));
+	memcpy(key.addr, addr, addr_len);
+	key.prefix_len = prefix_len;
+	key.family = family;
+	key.tb_id = tb_id;
+
+	return rhashtable_lookup_fast(fib_rt_ht, &key, nsim_fib_rt_ht_params);
+}
+
+static struct nsim_fib4_rt *
+nsim_fib4_rt_create(struct nsim_fib_data *data,
+		    struct fib_entry_notifier_info *fen_info)
+{
+	struct nsim_fib4_rt *fib4_rt;
+
+	fib4_rt = kzalloc(sizeof(*fib4_rt), GFP_ATOMIC);
+	if (!fib4_rt)
+		return NULL;
+
+	nsim_fib_rt_init(data, &fib4_rt->common, &fen_info->dst, sizeof(u32),
+			 fen_info->dst_len, AF_INET, fen_info->tb_id);
+
+	fib4_rt->fi = fen_info->fi;
+	fib_info_hold(fib4_rt->fi);
+	fib4_rt->tos = fen_info->tos;
+	fib4_rt->type = fen_info->type;
+
+	return fib4_rt;
+}
+
+static void nsim_fib4_rt_destroy(struct nsim_fib4_rt *fib4_rt)
+{
+	fib_info_put(fib4_rt->fi);
+	nsim_fib_rt_fini(&fib4_rt->common);
+	kfree(fib4_rt);
+}
+
+static struct nsim_fib4_rt *
+nsim_fib4_rt_lookup(struct rhashtable *fib_rt_ht,
+		    const struct fib_entry_notifier_info *fen_info)
+{
+	struct nsim_fib_rt *fib_rt;
+
+	fib_rt = nsim_fib_rt_lookup(fib_rt_ht, &fen_info->dst, sizeof(u32),
+				    fen_info->dst_len, AF_INET,
+				    fen_info->tb_id);
+	if (!fib_rt)
+		return NULL;
+
+	return container_of(fib_rt, struct nsim_fib4_rt, common);
+}
+
+static void nsim_fib4_rt_hw_flags_set(struct net *net,
+				      const struct nsim_fib4_rt *fib4_rt,
+				      bool trap)
+{
+	u32 *p_dst = (u32 *) fib4_rt->common.key.addr;
+	int dst_len = fib4_rt->common.key.prefix_len;
+
+	fib_alias_hw_flags_set(net, *p_dst, dst_len, fib4_rt->fi, fib4_rt->tos,
+			       fib4_rt->type, fib4_rt->common.key.tb_id,
+			       false, trap);
+}
+
+static int nsim_fib4_rt_add(struct nsim_fib_data *data,
+			    struct nsim_fib4_rt *fib4_rt,
+			    struct netlink_ext_ack *extack)
+{
+	struct net *net = devlink_net(data->devlink);
+	int err;
+
+	err = nsim_fib_account(&data->ipv4.fib, true, extack);
+	if (err)
+		return err;
+
+	err = rhashtable_insert_fast(&data->fib_rt_ht,
+				     &fib4_rt->common.ht_node,
+				     nsim_fib_rt_ht_params);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to insert IPv4 route");
+		goto err_fib_dismiss;
+	}
+
+	nsim_fib4_rt_hw_flags_set(net, fib4_rt, true);
+
+	return 0;
+
+err_fib_dismiss:
+	nsim_fib_account(&data->ipv4.fib, false, extack);
+	return err;
+}
+
+static int nsim_fib4_rt_replace(struct nsim_fib_data *data,
+				struct nsim_fib4_rt *fib4_rt,
+				struct nsim_fib4_rt *fib4_rt_old,
+				struct netlink_ext_ack *extack)
+{
+	struct net *net = devlink_net(data->devlink);
+	int err;
+
+	/* We are replacing a route, so no need to change the accounting. */
+	err = rhashtable_replace_fast(&data->fib_rt_ht,
+				      &fib4_rt_old->common.ht_node,
+				      &fib4_rt->common.ht_node,
+				      nsim_fib_rt_ht_params);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to replace IPv4 route");
+		return err;
+	}
+
+	nsim_fib4_rt_hw_flags_set(net, fib4_rt, true);
+
+	nsim_fib4_rt_hw_flags_set(net, fib4_rt_old, false);
+	nsim_fib4_rt_destroy(fib4_rt_old);
+
+	return 0;
+}
+
+static int nsim_fib4_rt_insert(struct nsim_fib_data *data,
+			       struct fib_entry_notifier_info *fen_info)
+{
+	struct netlink_ext_ack *extack = fen_info->info.extack;
+	struct nsim_fib4_rt *fib4_rt, *fib4_rt_old;
+	int err;
+
+	fib4_rt = nsim_fib4_rt_create(data, fen_info);
+	if (!fib4_rt)
+		return -ENOMEM;
+
+	fib4_rt_old = nsim_fib4_rt_lookup(&data->fib_rt_ht, fen_info);
+	if (!fib4_rt_old)
+		err = nsim_fib4_rt_add(data, fib4_rt, extack);
+	else
+		err = nsim_fib4_rt_replace(data, fib4_rt, fib4_rt_old, extack);
+
+	if (err)
+		nsim_fib4_rt_destroy(fib4_rt);
+
+	return err;
+}
+
+static void nsim_fib4_rt_remove(struct nsim_fib_data *data,
+				const struct fib_entry_notifier_info *fen_info)
+{
+	struct netlink_ext_ack *extack = fen_info->info.extack;
+	struct nsim_fib4_rt *fib4_rt;
+
+	fib4_rt = nsim_fib4_rt_lookup(&data->fib_rt_ht, fen_info);
+	if (WARN_ON_ONCE(!fib4_rt))
+		return;
+
+	rhashtable_remove_fast(&data->fib_rt_ht, &fib4_rt->common.ht_node,
+			       nsim_fib_rt_ht_params);
+	nsim_fib_account(&data->ipv4.fib, false, extack);
+	nsim_fib4_rt_destroy(fib4_rt);
+}
+
+static int nsim_fib4_event(struct nsim_fib_data *data,
+			   struct fib_notifier_info *info,
+			   unsigned long event)
+{
+	struct fib_entry_notifier_info *fen_info;
+	int err = 0;
+
+	fen_info = container_of(info, struct fib_entry_notifier_info, info);
+
+	if (fen_info->fi->nh) {
+		NL_SET_ERR_MSG_MOD(info->extack, "IPv4 route with nexthop objects is not supported");
+		return 0;
+	}
+
+	switch (event) {
+	case FIB_EVENT_ENTRY_REPLACE:
+		err = nsim_fib4_rt_insert(data, fen_info);
+		break;
+	case FIB_EVENT_ENTRY_DEL:
+		nsim_fib4_rt_remove(data, fen_info);
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static struct nsim_fib6_rt_nh *
+nsim_fib6_rt_nh_find(const struct nsim_fib6_rt *fib6_rt,
+		     const struct fib6_info *rt)
+{
+	struct nsim_fib6_rt_nh *fib6_rt_nh;
+
+	list_for_each_entry(fib6_rt_nh, &fib6_rt->nh_list, list) {
+		if (fib6_rt_nh->rt == rt)
+			return fib6_rt_nh;
+	}
+
+	return NULL;
+}
+
+static int nsim_fib6_rt_nh_add(struct nsim_fib6_rt *fib6_rt,
+			       struct fib6_info *rt)
+{
+	struct nsim_fib6_rt_nh *fib6_rt_nh;
+
+	fib6_rt_nh = kzalloc(sizeof(*fib6_rt_nh), GFP_ATOMIC);
+	if (!fib6_rt_nh)
+		return -ENOMEM;
+
+	fib6_info_hold(rt);
+	fib6_rt_nh->rt = rt;
+	list_add_tail(&fib6_rt_nh->list, &fib6_rt->nh_list);
+	fib6_rt->nhs++;
+
+	return 0;
+}
+
+static void nsim_fib6_rt_nh_del(struct nsim_fib6_rt *fib6_rt,
+				const struct fib6_info *rt)
+{
+	struct nsim_fib6_rt_nh *fib6_rt_nh;
+
+	fib6_rt_nh = nsim_fib6_rt_nh_find(fib6_rt, rt);
+	if (WARN_ON_ONCE(!fib6_rt_nh))
+		return;
+
+	fib6_rt->nhs--;
+	list_del(&fib6_rt_nh->list);
+#if IS_ENABLED(CONFIG_IPV6)
+	fib6_info_release(fib6_rt_nh->rt);
+#endif
+	kfree(fib6_rt_nh);
+}
+
+static struct nsim_fib6_rt *
+nsim_fib6_rt_create(struct nsim_fib_data *data,
+		    struct fib6_entry_notifier_info *fen6_info)
+{
+	struct fib6_info *iter, *rt = fen6_info->rt;
+	struct nsim_fib6_rt *fib6_rt;
+	int i = 0;
+	int err;
+
+	fib6_rt = kzalloc(sizeof(*fib6_rt), GFP_ATOMIC);
+	if (!fib6_rt)
+		return NULL;
+
+	nsim_fib_rt_init(data, &fib6_rt->common, &rt->fib6_dst.addr,
+			 sizeof(rt->fib6_dst.addr), rt->fib6_dst.plen, AF_INET6,
+			 rt->fib6_table->tb6_id);
+
+	/* We consider a multipath IPv6 route as one entry, but it can be made
+	 * up from several fib6_info structs (one for each nexthop), so we
+	 * add them all to the same list under the entry.
+	 */
+	INIT_LIST_HEAD(&fib6_rt->nh_list);
+
+	err = nsim_fib6_rt_nh_add(fib6_rt, rt);
+	if (err)
+		goto err_fib_rt_fini;
+
+	if (!fen6_info->nsiblings)
+		return fib6_rt;
+
+	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings) {
+		if (i == fen6_info->nsiblings)
+			break;
+
+		err = nsim_fib6_rt_nh_add(fib6_rt, iter);
+		if (err)
+			goto err_fib6_rt_nh_del;
+		i++;
+	}
+	WARN_ON_ONCE(i != fen6_info->nsiblings);
+
+	return fib6_rt;
+
+err_fib6_rt_nh_del:
+	list_for_each_entry_continue_reverse(iter, &rt->fib6_siblings,
+					     fib6_siblings)
+		nsim_fib6_rt_nh_del(fib6_rt, iter);
+	nsim_fib6_rt_nh_del(fib6_rt, rt);
+err_fib_rt_fini:
+	nsim_fib_rt_fini(&fib6_rt->common);
+	kfree(fib6_rt);
+	return ERR_PTR(err);
+}
+
+static void nsim_fib6_rt_destroy(struct nsim_fib6_rt *fib6_rt)
+{
+	struct nsim_fib6_rt_nh *iter, *tmp;
+
+	list_for_each_entry_safe(iter, tmp, &fib6_rt->nh_list, list)
+		nsim_fib6_rt_nh_del(fib6_rt, iter->rt);
+	WARN_ON_ONCE(!list_empty(&fib6_rt->nh_list));
+	nsim_fib_rt_fini(&fib6_rt->common);
+	kfree(fib6_rt);
+}
+
+static struct nsim_fib6_rt *
+nsim_fib6_rt_lookup(struct rhashtable *fib_rt_ht, const struct fib6_info *rt)
+{
+	struct nsim_fib_rt *fib_rt;
+
+	fib_rt = nsim_fib_rt_lookup(fib_rt_ht, &rt->fib6_dst.addr,
+				    sizeof(rt->fib6_dst.addr),
+				    rt->fib6_dst.plen, AF_INET6,
+				    rt->fib6_table->tb6_id);
+	if (!fib_rt)
+		return NULL;
+
+	return container_of(fib_rt, struct nsim_fib6_rt, common);
+}
+
+static int nsim_fib6_rt_append(struct nsim_fib_data *data,
+			       struct fib6_entry_notifier_info *fen6_info)
+{
+	struct fib6_info *iter, *rt = fen6_info->rt;
+	struct nsim_fib6_rt *fib6_rt;
+	int i = 0;
+	int err;
+
+	fib6_rt = nsim_fib6_rt_lookup(&data->fib_rt_ht, rt);
+	if (WARN_ON_ONCE(!fib6_rt))
+		return -EINVAL;
+
+	err = nsim_fib6_rt_nh_add(fib6_rt, rt);
+	if (err)
+		return err;
+	rt->trap = true;
+
+	if (!fen6_info->nsiblings)
+		return 0;
+
+	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings) {
+		if (i == fen6_info->nsiblings)
+			break;
+
+		err = nsim_fib6_rt_nh_add(fib6_rt, iter);
+		if (err)
+			goto err_fib6_rt_nh_del;
+		iter->trap = true;
+		i++;
+	}
+	WARN_ON_ONCE(i != fen6_info->nsiblings);
+
+	return 0;
+
+err_fib6_rt_nh_del:
+	list_for_each_entry_continue_reverse(iter, &rt->fib6_siblings,
+					     fib6_siblings) {
+		iter->trap = false;
+		nsim_fib6_rt_nh_del(fib6_rt, iter);
+	}
+	rt->trap = false;
+	nsim_fib6_rt_nh_del(fib6_rt, rt);
+	return err;
+}
+
+static void nsim_fib6_rt_hw_flags_set(const struct nsim_fib6_rt *fib6_rt,
+				      bool trap)
+{
+	struct nsim_fib6_rt_nh *fib6_rt_nh;
+
+	list_for_each_entry(fib6_rt_nh, &fib6_rt->nh_list, list)
+		fib6_info_hw_flags_set(fib6_rt_nh->rt, false, trap);
+}
+
+static int nsim_fib6_rt_add(struct nsim_fib_data *data,
+			    struct nsim_fib6_rt *fib6_rt,
+			    struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = nsim_fib_account(&data->ipv6.fib, true, extack);
+	if (err)
+		return err;
+
+	err = rhashtable_insert_fast(&data->fib_rt_ht,
+				     &fib6_rt->common.ht_node,
+				     nsim_fib_rt_ht_params);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to insert IPv6 route");
+		goto err_fib_dismiss;
+	}
+
+	nsim_fib6_rt_hw_flags_set(fib6_rt, true);
+
+	return 0;
+
+err_fib_dismiss:
+	nsim_fib_account(&data->ipv6.fib, false, extack);
+	return err;
+}
+
+static int nsim_fib6_rt_replace(struct nsim_fib_data *data,
+				struct nsim_fib6_rt *fib6_rt,
+				struct nsim_fib6_rt *fib6_rt_old,
+				struct netlink_ext_ack *extack)
+{
+	int err;
+
+	/* We are replacing a route, so no need to change the accounting. */
+	err = rhashtable_replace_fast(&data->fib_rt_ht,
+				      &fib6_rt_old->common.ht_node,
+				      &fib6_rt->common.ht_node,
+				      nsim_fib_rt_ht_params);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to replace IPv6 route");
+		return err;
+	}
+
+	nsim_fib6_rt_hw_flags_set(fib6_rt, true);
+
+	nsim_fib6_rt_hw_flags_set(fib6_rt_old, false);
+	nsim_fib6_rt_destroy(fib6_rt_old);
+
+	return 0;
+}
+
+static int nsim_fib6_rt_insert(struct nsim_fib_data *data,
+			       struct fib6_entry_notifier_info *fen6_info)
+{
+	struct netlink_ext_ack *extack = fen6_info->info.extack;
+	struct nsim_fib6_rt *fib6_rt, *fib6_rt_old;
+	int err;
+
+	fib6_rt = nsim_fib6_rt_create(data, fen6_info);
+	if (!fib6_rt)
+		return -ENOMEM;
+
+	fib6_rt_old = nsim_fib6_rt_lookup(&data->fib_rt_ht, fen6_info->rt);
+	if (!fib6_rt_old)
+		err = nsim_fib6_rt_add(data, fib6_rt, extack);
+	else
+		err = nsim_fib6_rt_replace(data, fib6_rt, fib6_rt_old, extack);
+
+	if (err)
+		nsim_fib6_rt_destroy(fib6_rt);
+
+	return err;
+}
+
+static void
+nsim_fib6_rt_remove(struct nsim_fib_data *data,
+		    const struct fib6_entry_notifier_info *fen6_info)
+{
+	struct netlink_ext_ack *extack = fen6_info->info.extack;
+	struct nsim_fib6_rt *fib6_rt;
+
+	/* Multipath routes are first added to the FIB trie and only then
+	 * notified. If we vetoed the addition, we will get a delete
+	 * notification for a route we do not have. Therefore, do not warn if
+	 * route was not found.
+	 */
+	fib6_rt = nsim_fib6_rt_lookup(&data->fib_rt_ht, fen6_info->rt);
+	if (!fib6_rt)
+		return;
+
+	/* If not all the nexthops are deleted, then only reduce the nexthop
+	 * group.
+	 */
+	if (fen6_info->nsiblings + 1 != fib6_rt->nhs) {
+		nsim_fib6_rt_nh_del(fib6_rt, fen6_info->rt);
+		return;
+	}
+
+	rhashtable_remove_fast(&data->fib_rt_ht, &fib6_rt->common.ht_node,
+			       nsim_fib_rt_ht_params);
+	nsim_fib_account(&data->ipv6.fib, false, extack);
+	nsim_fib6_rt_destroy(fib6_rt);
+}
+
+static int nsim_fib6_event(struct nsim_fib_data *data,
+			   struct fib_notifier_info *info,
+			   unsigned long event)
+{
+	struct fib6_entry_notifier_info *fen6_info;
+	int err = 0;
+
+	fen6_info = container_of(info, struct fib6_entry_notifier_info, info);
+
+	if (fen6_info->rt->nh) {
+		NL_SET_ERR_MSG_MOD(info->extack, "IPv6 route with nexthop objects is not supported");
+		return 0;
+	}
+
+	if (fen6_info->rt->fib6_src.plen) {
+		NL_SET_ERR_MSG_MOD(info->extack, "IPv6 source-specific route is not supported");
+		return 0;
+	}
+
+	switch (event) {
+	case FIB_EVENT_ENTRY_REPLACE:
+		err = nsim_fib6_rt_insert(data, fen6_info);
+		break;
+	case FIB_EVENT_ENTRY_APPEND:
+		err = nsim_fib6_rt_append(data, fen6_info);
+		break;
+	case FIB_EVENT_ENTRY_DEL:
+		nsim_fib6_rt_remove(data, fen6_info);
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
 static int nsim_fib_event(struct nsim_fib_data *data,
-			  struct fib_notifier_info *info, bool add)
+			  struct fib_notifier_info *info, unsigned long event)
 {
-	struct netlink_ext_ack *extack = info->extack;
 	int err = 0;
 
 	switch (info->family) {
 	case AF_INET:
-		err = nsim_fib_account(&data->ipv4.fib, add, extack);
+		err = nsim_fib4_event(data, info, event);
 		break;
 	case AF_INET6:
-		err = nsim_fib_account(&data->ipv6.fib, add, extack);
+		err = nsim_fib6_event(data, info, event);
 		break;
 	}
 
@@ -170,6 +749,9 @@ static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 	struct fib_notifier_info *info = ptr;
 	int err = 0;
 
+	/* IPv6 routes can be added via RAs from softIRQ. */
+	spin_lock_bh(&data->fib_lock);
+
 	switch (event) {
 	case FIB_EVENT_RULE_ADD: /* fall through */
 	case FIB_EVENT_RULE_DEL:
@@ -178,23 +760,74 @@ static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 		break;
 
 	case FIB_EVENT_ENTRY_REPLACE:  /* fall through */
+	case FIB_EVENT_ENTRY_APPEND:  /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
-		err = nsim_fib_event(data, info, event != FIB_EVENT_ENTRY_DEL);
+		err = nsim_fib_event(data, info, event);
 		break;
 	}
 
+	spin_unlock_bh(&data->fib_lock);
+
 	return notifier_from_errno(err);
 }
 
+static void nsim_fib4_rt_free(struct nsim_fib_rt *fib_rt,
+			      struct nsim_fib_data *data)
+{
+	struct devlink *devlink = data->devlink;
+	struct nsim_fib4_rt *fib4_rt;
+
+	fib4_rt = container_of(fib_rt, struct nsim_fib4_rt, common);
+	nsim_fib4_rt_hw_flags_set(devlink_net(devlink), fib4_rt, false);
+	nsim_fib_account(&data->ipv4.fib, false, NULL);
+	nsim_fib4_rt_destroy(fib4_rt);
+}
+
+static void nsim_fib6_rt_free(struct nsim_fib_rt *fib_rt,
+			      struct nsim_fib_data *data)
+{
+	struct nsim_fib6_rt *fib6_rt;
+
+	fib6_rt = container_of(fib_rt, struct nsim_fib6_rt, common);
+	nsim_fib6_rt_hw_flags_set(fib6_rt, false);
+	nsim_fib_account(&data->ipv6.fib, false, NULL);
+	nsim_fib6_rt_destroy(fib6_rt);
+}
+
+static void nsim_fib_rt_free(void *ptr, void *arg)
+{
+	struct nsim_fib_rt *fib_rt = ptr;
+	struct nsim_fib_data *data = arg;
+
+	switch (fib_rt->key.family) {
+	case AF_INET:
+		nsim_fib4_rt_free(fib_rt, data);
+		break;
+	case AF_INET6:
+		nsim_fib6_rt_free(fib_rt, data);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+
 /* inconsistent dump, trying again */
 static void nsim_fib_dump_inconsistent(struct notifier_block *nb)
 {
 	struct nsim_fib_data *data = container_of(nb, struct nsim_fib_data,
 						  fib_nb);
+	struct nsim_fib_rt *fib_rt, *fib_rt_tmp;
+
+	/* The notifier block is still not registered, so we do not need to
+	 * take any locks here.
+	 */
+	list_for_each_entry_safe(fib_rt, fib_rt_tmp, &data->fib_rt_list, list) {
+		rhashtable_remove_fast(&data->fib_rt_ht, &fib_rt->ht_node,
+				       nsim_fib_rt_ht_params);
+		nsim_fib_rt_free(fib_rt, data);
+	}
 
-	data->ipv4.fib.num = 0ULL;
 	data->ipv4.rules.num = 0ULL;
-	data->ipv6.fib.num = 0ULL;
 	data->ipv6.rules.num = 0ULL;
 }
 
@@ -255,6 +888,13 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
+	data->devlink = devlink;
+
+	spin_lock_init(&data->fib_lock);
+	INIT_LIST_HEAD(&data->fib_rt_list);
+	err = rhashtable_init(&data->fib_rt_ht, &nsim_fib_rt_ht_params);
+	if (err)
+		goto err_data_free;
 
 	nsim_fib_set_max_all(data, devlink);
 
@@ -263,7 +903,7 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 				    nsim_fib_dump_inconsistent, extack);
 	if (err) {
 		pr_err("Failed to register fib notifier\n");
-		goto err_out;
+		goto err_rhashtable_destroy;
 	}
 
 	devlink_resource_occ_get_register(devlink,
@@ -284,7 +924,10 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 					  data);
 	return data;
 
-err_out:
+err_rhashtable_destroy:
+	rhashtable_free_and_destroy(&data->fib_rt_ht, nsim_fib_rt_free,
+				    data);
+err_data_free:
 	kfree(data);
 	return ERR_PTR(err);
 }
@@ -300,5 +943,8 @@ void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 	devlink_resource_occ_get_unregister(devlink,
 					    NSIM_RESOURCE_IPV4_FIB);
 	unregister_fib_notifier(devlink_net(devlink), &data->fib_nb);
+	rhashtable_free_and_destroy(&data->fib_rt_ht, nsim_fib_rt_free,
+				    data);
+	WARN_ON_ONCE(!list_empty(&data->fib_rt_list));
 	kfree(data);
 }
-- 
2.24.1

