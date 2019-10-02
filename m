Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D180C49CE
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfJBIl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:56 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44515 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727953AbfJBIlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DFEB9217DD;
        Wed,  2 Oct 2019 04:41:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=lI9z6oZvFsu38XwrJPCEMvqLB6Phbtm6rnDVLysCJPA=; b=TYfjTYrE
        o4eH5G1DZ+oJsrXi6wjVSwfQCk1Dr1b8GSy36opm5Gl2b3dLjC/EvZ9yYJNKD+a5
        3Ql8XlA8MK92ezpqebzCJoilKurbjr7jz/W8n7LudlLi6RrNx+gKhbmOM2/HW/6z
        SK+tx4VgjFwZ0QaO2j2HMitdKNHAwoyDBnkuorJQcyP0tZQeNESJA1nOYtvQjfVR
        duqkoKhrmHi4+xVCJ0BbuK1TBHraBS7yBB2DNO8K8FXLu5hTkW1NeJTjpiyKTIkE
        nxRS787EMx8yH3OPjKbB1OfNVrj40aXRZumxz6kuwBnqIeWFBlqSm8XPFPSIKwd3
        rQskcRrTKxiqHA==
X-ME-Sender: <xms:z2KUXVMWpiFBS6OpSDKGVoKDrWux0PWuYqM4hnvHhQk87PlSwcKm5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddt
X-ME-Proxy: <xmx:z2KUXdao4uok0YT1gx4_dxECm4PVLKLjt2PUyI1cjjxH9lwIgkJSsA>
    <xmx:z2KUXZBGgbKh1HYColPT9jWkoUgOaSzCNQGtb18EQP0oJNhlTvnzew>
    <xmx:z2KUXSrUo1cfxvFcD1CgemtI4QO6c7Z4iFToBuQ4oeS-g8S7rhMwNg>
    <xmx:z2KUXQSljEPy0C0FWY4vEBQabrXp4ZixxG9lgQBSLnxPC5KVlnjIrA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 50FA9D6005E;
        Wed,  2 Oct 2019 04:41:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 14/15] netdevsim: fib: Mark routes as "in hardware"
Date:   Wed,  2 Oct 2019 11:41:02 +0300
Message-Id: <20191002084103.12138-15-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002084103.12138-1-idosch@idosch.org>
References: <20191002084103.12138-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Implement dummy IPv4 FIB "offload" in the driver by storing currently
"offloaded" routes in a hash table. Each route in the hash table is
marked as "in hardware". The indication is cleared when the route is
replaced or when the netdevsim instance is deleted.

This will later allow us to test the route offload API on top of
netdevsim.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/netdevsim/fib.c | 259 +++++++++++++++++++++++++++++++++++-
 1 file changed, 256 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 4e02a4231fcb..ab08d6e73356 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -14,6 +14,9 @@
  * THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
  */
 
+#include <linux/in6.h>
+#include <linux/kernel.h>
+#include <linux/rhashtable.h>
 #include <net/fib_notifier.h>
 #include <net/ip_fib.h>
 #include <net/ip6_fib.h>
@@ -36,6 +39,34 @@ struct nsim_fib_data {
 	struct notifier_block fib_nb;
 	struct nsim_per_fib_data ipv4;
 	struct nsim_per_fib_data ipv6;
+	struct rhashtable fib_rt_ht;
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
+};
+
+struct nsim_fib4_rt {
+	struct nsim_fib_rt common;
+	struct fib_info *fi;
+	u8 type;
+	u8 tos;
+};
+
+static const struct rhashtable_params nsim_fib_rt_ht_params = {
+	.key_offset = offsetof(struct nsim_fib_rt, key),
+	.head_offset = offsetof(struct nsim_fib_rt, ht_node),
+	.key_len = sizeof(struct nsim_fib_rt_key),
+	.automatic_shrinking = true,
 };
 
 u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
@@ -144,6 +175,191 @@ static int nsim_fib_account(struct nsim_fib_entry *entry, bool add,
 	return err;
 }
 
+static void nsim_fib_rt_init(struct nsim_fib_rt *fib_rt, const void *addr,
+			     size_t addr_len, unsigned int prefix_len,
+			     int family, u32 tb_id)
+{
+	memcpy(fib_rt->key.addr, addr, addr_len);
+	fib_rt->key.prefix_len = prefix_len;
+	fib_rt->key.family = family;
+	fib_rt->key.tb_id = tb_id;
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
+nsim_fib4_rt_create(struct fib_entry_notifier_info *fen_info)
+{
+	struct nsim_fib4_rt *fib4_rt;
+
+	fib4_rt = kzalloc(sizeof(*fib4_rt), GFP_ATOMIC);
+	if (!fib4_rt)
+		return NULL;
+
+	nsim_fib_rt_init(&fib4_rt->common, &fen_info->dst, sizeof(u32),
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
+static int nsim_fib4_rt_add(struct nsim_fib_data *data,
+			    struct nsim_fib4_rt *fib4_rt,
+			    struct netlink_ext_ack *extack)
+{
+	struct nsim_fib_rt *fib_rt = &fib4_rt->common;
+	struct net *net = devlink_net(data->devlink);
+	u32 *addr = (u32 *) fib_rt->key.addr;
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
+	fib_alias_in_hw_set(net, *addr, fib_rt->key.prefix_len, fib4_rt->fi,
+			    fib4_rt->tos, fib4_rt->type, fib_rt->key.tb_id);
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
+	struct nsim_fib_rt *fib_rt = &fib4_rt->common;
+	struct net *net = devlink_net(data->devlink);
+	u32 *addr = (u32 *) fib_rt->key.addr;
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
+	fib_alias_in_hw_clear(net, *addr, fib_rt->key.prefix_len,
+			      fib4_rt_old->fi, fib4_rt_old->tos,
+			      fib4_rt_old->type, fib_rt->key.tb_id);
+	nsim_fib4_rt_destroy(fib4_rt_old);
+
+	fib_alias_in_hw_set(net, *addr, fib_rt->key.prefix_len,
+			    fib4_rt->fi, fib4_rt->tos, fib4_rt->type,
+			    fib_rt->key.tb_id);
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
+	fib4_rt = nsim_fib4_rt_create(fen_info);
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
+			   struct fib_notifier_info *info, bool add)
+{
+	struct fib_entry_notifier_info *fen_info;
+	int err = 0;
+
+	fen_info = container_of(info, struct fib_entry_notifier_info, info);
+
+	if (add)
+		err = nsim_fib4_rt_insert(data, fen_info);
+	else
+		nsim_fib4_rt_remove(data, fen_info);
+
+	return err;
+}
+
 static int nsim_fib_event(struct nsim_fib_data *data,
 			  struct fib_notifier_info *info, bool add)
 {
@@ -152,7 +368,7 @@ static int nsim_fib_event(struct nsim_fib_data *data,
 
 	switch (info->family) {
 	case AF_INET:
-		err = nsim_fib_account(&data->ipv4.fib, add, extack);
+		err = nsim_fib4_event(data, info, add);
 		break;
 	case AF_INET6:
 		err = nsim_fib_account(&data->ipv6.fib, add, extack);
@@ -247,6 +463,33 @@ static void nsim_fib_set_max_all(struct nsim_fib_data *data,
 	}
 }
 
+static void nsim_fib4_rt_free(struct nsim_fib_rt *fib_rt,
+			      struct devlink *devlink)
+{
+	u32 *addr = (u32 *) fib_rt->key.addr;
+	struct nsim_fib4_rt *fib4_rt;
+
+	fib4_rt = container_of(fib_rt, struct nsim_fib4_rt, common);
+	fib_alias_in_hw_clear(devlink_net(devlink), *addr,
+			      fib_rt->key.prefix_len, fib4_rt->fi, fib4_rt->tos,
+			      fib4_rt->type, fib_rt->key.tb_id);
+	nsim_fib4_rt_destroy(fib4_rt);
+}
+
+static void nsim_fib_rt_free(void *ptr, void *arg)
+{
+	struct nsim_fib_rt *fib_rt = ptr;
+	struct devlink *devlink = arg;
+
+	switch (fib_rt->key.family) {
+	case AF_INET:
+		nsim_fib4_rt_free(fib_rt, devlink);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+
 struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 				      struct netlink_ext_ack *extack)
 {
@@ -256,6 +499,11 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
+	data->devlink = devlink;
+
+	err = rhashtable_init(&data->fib_rt_ht, &nsim_fib_rt_ht_params);
+	if (err)
+		goto err_data_free;
 
 	nsim_fib_set_max_all(data, devlink);
 
@@ -264,7 +512,7 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 				    nsim_fib_dump_inconsistent, extack);
 	if (err) {
 		pr_err("Failed to register fib notifier\n");
-		goto err_out;
+		goto err_rhashtable_destroy;
 	}
 
 	devlink_resource_occ_get_register(devlink,
@@ -285,7 +533,10 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 					  data);
 	return data;
 
-err_out:
+err_rhashtable_destroy:
+	rhashtable_free_and_destroy(&data->fib_rt_ht, nsim_fib_rt_free,
+				    devlink);
+err_data_free:
 	kfree(data);
 	return ERR_PTR(err);
 }
@@ -301,5 +552,7 @@ void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 	devlink_resource_occ_get_unregister(devlink,
 					    NSIM_RESOURCE_IPV4_FIB);
 	unregister_fib_notifier(devlink_net(devlink), &data->fib_nb);
+	rhashtable_free_and_destroy(&data->fib_rt_ht, nsim_fib_rt_free,
+				    devlink);
 	kfree(data);
 }
-- 
2.21.0

