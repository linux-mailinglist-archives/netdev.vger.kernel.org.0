Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A290461450
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfGGIAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:00:06 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:56533 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGIAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:00:04 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id EF7BA278A;
        Sun,  7 Jul 2019 04:00:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:00:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=O7d2xCFFHk44l0oo6shtnguJ2Aitc7K6sNL7tKtgtg8=; b=VEvlZ9hT
        aAlSlgwIjfoHm39f+uPYsomrljlMTzYys2W6ibt/nX6jWf5XRX9RF9Gaz7tgddPD
        hs9X0i1aJKPD4MnuuvhDHmz1WmNPe0Gizo5WIG9Wft9kKOTsEIqZ9PUcvg3F3D7I
        gzytmOIwP25c80L2eAM9VbhIo+eBeDNAiBQp9TTAQ7yttCQAbRSEnMpPxDtERwmm
        JnHyud6upJmCyLLEN2Amv3WovUt8eyU2pR8PO0XnMPWMgvWt2nJf60hbXieRpP9q
        KcD08tc26Lf0NSEf01aBe/7E0KnJ84gXcXTRt6lpdaeDynUmb2zlxrCVqiSFlY+P
        5FGL1t4Py4bIOA==
X-ME-Sender: <xms:gqYhXSxvqSq9PDQgc14-ox77Zu6-WN1Brg9jphaXmKfpnflDTfwI9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:gqYhXateJezplwQ2hgijnb4YXRWdeR5D57OeNPUPX_ZjnsD4ptKYyg>
    <xmx:gqYhXbk7eblKr6W2tVdr5pr0-HEjUUBi8FI8RivKqw7-GehWqn8I4Q>
    <xmx:gqYhXfC_Jx5AZsk9pNWoPI8bH7vFmaiO2kIQWy72SoCw3Om7wh-jvQ>
    <xmx:gqYhXXH-8eYNr39TNIXlo-CgOceZwjxyKFpY61xaThO5Y3NgU6BTXQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1BB3380075;
        Sun,  7 Jul 2019 03:59:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/11] netdevsim: Add devlink-trap support
Date:   Sun,  7 Jul 2019 10:58:22 +0300
Message-Id: <20190707075828.3315-6-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707075828.3315-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Have netdevsim register its trap groups and traps with devlink during
initialization and periodically report trapped packets to devlink core.

Since netdevsim is not a real device, the trapped packets are emulated
using a workqueue that periodically reports a UDP packet with a random
5-tuple from each active packet trap and from each running netdev.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c       | 270 +++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |   1 +
 2 files changed, 270 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index c5c417a3c0ce..2d8c60c3326c 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -17,11 +17,21 @@
 
 #include <linux/debugfs.h>
 #include <linux/device.h>
+#include <linux/etherdevice.h>
+#include <linux/inet.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/random.h>
+#include <linux/workqueue.h>
+#include <linux/random.h>
 #include <linux/rtnetlink.h>
 #include <net/devlink.h>
+#include <net/ip.h>
+#include <uapi/linux/devlink.h>
+#include <uapi/linux/ip.h>
+#include <uapi/linux/udp.h>
 
 #include "netdevsim.h"
 
@@ -196,6 +206,205 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 	return err;
 }
 
+struct nsim_trap_item {
+	void *trap_ctx;
+	enum devlink_trap_action action;
+};
+
+struct nsim_trap_data {
+	struct delayed_work trap_report_dw;
+	struct nsim_trap_item *trap_items_arr;
+	struct nsim_dev *nsim_dev;
+	spinlock_t trap_lock;	/* Protects trap_items_arr */
+};
+
+enum {
+	NSIM_TRAP_ID_BASE = DEVLINK_TRAP_GENERIC_ID_MAX,
+	NSIM_TRAP_ID_FID_MISS,
+};
+
+#define NSIM_TRAP_NAME_FID_MISS "fid_miss"
+
+#define NSIM_TRAP_METADATA DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT
+
+#define NSIM_TRAP_DROP(_id, _group_id)					      \
+	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
+			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			     NSIM_TRAP_METADATA)
+#define NSIM_TRAP_EXCEPTION(_id, _group_id)				      \
+	DEVLINK_TRAP_GENERIC(EXCEPTION, TRAP, _id,			      \
+			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			     NSIM_TRAP_METADATA)
+#define NSIM_TRAP_DRIVER_EXCEPTION(_id, _group_id)			      \
+	DEVLINK_TRAP_DRIVER(EXCEPTION, TRAP, NSIM_TRAP_ID_##_id,	      \
+			    NSIM_TRAP_NAME_##_id,			      \
+			    DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			    NSIM_TRAP_METADATA)
+
+static const struct devlink_trap nsim_traps_arr[] = {
+	NSIM_TRAP_DROP(SMAC_MC, L2_DROPS),
+	NSIM_TRAP_DROP(VLAN_TAG_MISMATCH, L2_DROPS),
+	NSIM_TRAP_DROP(INGRESS_VLAN_FILTER, L2_DROPS),
+	NSIM_TRAP_DROP(INGRESS_STP_FILTER, L2_DROPS),
+	NSIM_TRAP_DROP(EMPTY_TX_LIST, L2_DROPS),
+	NSIM_TRAP_DROP(PORT_LOOPBACK_FILTER, L2_DROPS),
+	NSIM_TRAP_DRIVER_EXCEPTION(FID_MISS, L2_DROPS),
+	NSIM_TRAP_DROP(BLACKHOLE_ROUTE, L3_DROPS),
+	NSIM_TRAP_EXCEPTION(TTL_ERROR, L3_DROPS),
+	NSIM_TRAP_DROP(TAIL_DROP, BUFFER_DROPS),
+};
+
+#define NSIM_TRAP_L4_DATA_LEN 100
+
+static struct sk_buff *nsim_dev_trap_skb_build(void)
+{
+	int tot_len, data_len = NSIM_TRAP_L4_DATA_LEN;
+	struct sk_buff *skb;
+	struct udphdr *udph;
+	struct ethhdr *eth;
+	struct iphdr *iph;
+
+	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
+	if (!skb)
+		return NULL;
+	tot_len = sizeof(struct iphdr) + sizeof(struct udphdr) + data_len;
+
+	eth = skb_put(skb, sizeof(struct ethhdr));
+	eth_random_addr(eth->h_dest);
+	eth_random_addr(eth->h_source);
+	eth->h_proto = htons(ETH_P_IP);
+	skb->protocol = htons(ETH_P_IP);
+
+	iph = skb_put(skb, sizeof(struct iphdr));
+	iph->protocol = IPPROTO_UDP;
+	iph->saddr = in_aton("192.0.2.1");
+	iph->daddr = in_aton("198.51.100.1");
+	iph->version = 0x4;
+	iph->frag_off = 0;
+	iph->ihl = 0x5;
+	iph->tot_len = htons(tot_len);
+	ip_send_check(iph);
+
+	udph = skb_put_zero(skb, sizeof(struct udphdr) + data_len);
+	get_random_bytes(&udph->source, sizeof(u16));
+	get_random_bytes(&udph->dest, sizeof(u16));
+	udph->len = htons(sizeof(struct udphdr) + data_len);
+
+	return skb;
+}
+
+static void nsim_dev_trap_report(struct nsim_dev_port *nsim_dev_port)
+{
+	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
+	struct nsim_trap_data *nsim_trap_data = nsim_dev->trap_data;
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
+	int i;
+
+	spin_lock(&nsim_trap_data->trap_lock);
+	for (i = 0; i < ARRAY_SIZE(nsim_traps_arr); i++) {
+		struct nsim_trap_item *nsim_trap_item;
+		struct sk_buff *skb;
+
+		nsim_trap_item = &nsim_trap_data->trap_items_arr[i];
+		if (nsim_trap_item->action == DEVLINK_TRAP_ACTION_DROP)
+			continue;
+
+		skb = nsim_dev_trap_skb_build();
+		if (!skb)
+			continue;
+		skb->dev = nsim_dev_port->ns->netdev;
+
+		devlink_trap_report(devlink, skb, nsim_trap_item->trap_ctx,
+				    &nsim_dev_port->devlink_port);
+		consume_skb(skb);
+	}
+	spin_unlock(&nsim_trap_data->trap_lock);
+}
+
+#define NSIM_TRAP_REPORT_INTERVAL_MS	100
+
+static void nsim_dev_trap_report_work(struct work_struct *work)
+{
+	struct nsim_trap_data *nsim_trap_data;
+	struct nsim_dev_port *nsim_dev_port;
+	struct nsim_dev *nsim_dev;
+
+	nsim_trap_data = container_of(work, struct nsim_trap_data,
+				      trap_report_dw.work);
+	nsim_dev = nsim_trap_data->nsim_dev;
+
+	/* For each running port and enabled packet trap, generate a UDP
+	 * packet with a random 5-tuple and report it.
+	 */
+	mutex_lock(&nsim_dev->port_list_lock);
+	list_for_each_entry(nsim_dev_port, &nsim_dev->port_list, list) {
+		if (!netif_running(nsim_dev_port->ns->netdev))
+			continue;
+
+		nsim_dev_trap_report(nsim_dev_port);
+	}
+	mutex_unlock(&nsim_dev->port_list_lock);
+
+	schedule_delayed_work(&nsim_dev->trap_data->trap_report_dw,
+			      msecs_to_jiffies(NSIM_TRAP_REPORT_INTERVAL_MS));
+}
+
+static int nsim_dev_traps_init(struct devlink *devlink)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	struct nsim_trap_data *nsim_trap_data;
+	int err;
+
+	nsim_trap_data = kzalloc(sizeof(*nsim_trap_data), GFP_KERNEL);
+	if (!nsim_trap_data)
+		return -ENOMEM;
+
+	nsim_trap_data->trap_items_arr = kcalloc(ARRAY_SIZE(nsim_traps_arr),
+						 sizeof(struct nsim_trap_item),
+						 GFP_KERNEL);
+	if (!nsim_trap_data->trap_items_arr) {
+		err = -ENOMEM;
+		goto err_trap_data_free;
+	}
+
+	/* The lock is used to protect the action state of the registered
+	 * traps. The value is written by user and read in delayed work when
+	 * iterating over all the traps.
+	 */
+	spin_lock_init(&nsim_trap_data->trap_lock);
+	nsim_trap_data->nsim_dev = nsim_dev;
+	nsim_dev->trap_data = nsim_trap_data;
+
+	err = devlink_traps_register(devlink, nsim_traps_arr,
+				     ARRAY_SIZE(nsim_traps_arr), NULL);
+	if (err)
+		goto err_trap_items_free;
+
+	INIT_DELAYED_WORK(&nsim_dev->trap_data->trap_report_dw,
+			  nsim_dev_trap_report_work);
+	schedule_delayed_work(&nsim_dev->trap_data->trap_report_dw,
+			      msecs_to_jiffies(NSIM_TRAP_REPORT_INTERVAL_MS));
+
+	return 0;
+
+err_trap_items_free:
+	kfree(nsim_trap_data->trap_items_arr);
+err_trap_data_free:
+	kfree(nsim_trap_data);
+	return err;
+}
+
+static void nsim_dev_traps_exit(struct devlink *devlink)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+
+	cancel_delayed_work_sync(&nsim_dev->trap_data->trap_report_dw);
+	devlink_traps_unregister(devlink, nsim_traps_arr,
+				 ARRAY_SIZE(nsim_traps_arr));
+	kfree(nsim_dev->trap_data->trap_items_arr);
+	kfree(nsim_dev->trap_data);
+}
+
 static int nsim_dev_reload(struct devlink *devlink,
 			   struct netlink_ext_ack *extack)
 {
@@ -262,9 +471,61 @@ static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
 	return 0;
 }
 
+static struct nsim_trap_item *
+nsim_dev_trap_item_lookup(struct nsim_dev *nsim_dev, u16 trap_id)
+{
+	struct nsim_trap_data *nsim_trap_data = nsim_dev->trap_data;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(nsim_traps_arr); i++) {
+		if (nsim_traps_arr[i].id == trap_id)
+			return &nsim_trap_data->trap_items_arr[i];
+	}
+
+	return NULL;
+}
+
+static int nsim_dev_devlink_trap_init(struct devlink *devlink,
+				      const struct devlink_trap *trap,
+				      void *trap_ctx)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	struct nsim_trap_item *nsim_trap_item;
+
+	nsim_trap_item = nsim_dev_trap_item_lookup(nsim_dev, trap->id);
+	if (WARN_ON(!nsim_trap_item))
+		return -ENOENT;
+
+	nsim_trap_item->trap_ctx = trap_ctx;
+	nsim_trap_item->action = trap->init_action;
+
+	return 0;
+}
+
+static int
+nsim_dev_devlink_trap_action_set(struct devlink *devlink,
+				 const struct devlink_trap *trap,
+				 enum devlink_trap_action action)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	struct nsim_trap_item *nsim_trap_item;
+
+	nsim_trap_item = nsim_dev_trap_item_lookup(nsim_dev, trap->id);
+	if (WARN_ON(!nsim_trap_item))
+		return -ENOENT;
+
+	spin_lock(&nsim_dev->trap_data->trap_lock);
+	nsim_trap_item->action = action;
+	spin_unlock(&nsim_dev->trap_data->trap_lock);
+
+	return 0;
+}
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.reload = nsim_dev_reload,
 	.flash_update = nsim_dev_flash_update,
+	.trap_init = nsim_dev_devlink_trap_init,
+	.trap_action_set = nsim_dev_devlink_trap_action_set,
 };
 
 static struct nsim_dev *
@@ -299,10 +560,14 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 	if (err)
 		goto err_resources_unregister;
 
-	err = nsim_dev_debugfs_init(nsim_dev);
+	err = nsim_dev_traps_init(devlink);
 	if (err)
 		goto err_dl_unregister;
 
+	err = nsim_dev_debugfs_init(nsim_dev);
+	if (err)
+		goto err_traps_exit;
+
 	err = nsim_bpf_dev_init(nsim_dev);
 	if (err)
 		goto err_debugfs_exit;
@@ -311,6 +576,8 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 
 err_debugfs_exit:
 	nsim_dev_debugfs_exit(nsim_dev);
+err_traps_exit:
+	nsim_dev_traps_exit(devlink);
 err_dl_unregister:
 	devlink_unregister(devlink);
 err_resources_unregister:
@@ -328,6 +595,7 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 
 	nsim_bpf_dev_exit(nsim_dev);
 	nsim_dev_debugfs_exit(nsim_dev);
+	nsim_dev_traps_exit(devlink);
 	devlink_unregister(devlink);
 	devlink_resources_unregister(devlink, NULL);
 	nsim_fib_destroy(nsim_dev->fib_data);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 79c05af2a7c0..a3dd73ae252e 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -145,6 +145,7 @@ struct nsim_dev_port {
 struct nsim_dev {
 	struct nsim_bus_dev *nsim_bus_dev;
 	struct nsim_fib_data *fib_data;
+	struct nsim_trap_data *trap_data;
 	struct dentry *ddir;
 	struct dentry *ports_ddir;
 	struct bpf_offload_dev *bpf_dev;
-- 
2.20.1

