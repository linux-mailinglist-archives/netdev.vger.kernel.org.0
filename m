Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E22189319
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgCRAlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:41:05 -0400
Received: from correo.us.es ([193.147.175.20]:45652 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727283AbgCRAkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3C09B27F8C3
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2F0A4DA3A3
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:47 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 24DC1DA3A0; Wed, 18 Mar 2020 01:39:47 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 472EADA38F;
        Wed, 18 Mar 2020 01:39:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 216FF426CCB9;
        Wed, 18 Mar 2020 01:39:45 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/29] netfilter: flowtable: add indr block setup support
Date:   Wed, 18 Mar 2020 01:39:39 +0100
Message-Id: <20200318003956.73573-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add etfilter flowtable support indr-block setup. It makes flowtable offload
vlan and tunnel device.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 94 +++++++++++++++++++++++++++++++++--
 1 file changed, 90 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c4cb03555315..f60f01e929b8 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -7,6 +7,7 @@
 #include <linux/tc_act/tc_csum.h>
 #include <net/flow_offload.h>
 #include <net/netfilter/nf_flow_table.h>
+#include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
@@ -827,6 +828,22 @@ static void nf_flow_table_block_offload_init(struct flow_block_offload *bo,
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
+static int nf_flow_table_indr_offload_cmd(struct flow_block_offload *bo,
+					  struct nf_flowtable *flowtable,
+					  struct net_device *dev,
+					  enum flow_block_command cmd,
+					  struct netlink_ext_ack *extack)
+{
+	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
+					 extack);
+	flow_indr_block_call(dev, bo, cmd);
+
+	if (list_empty(&bo->cb_list))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 				     struct nf_flowtable *flowtable,
 				     struct net_device *dev,
@@ -835,9 +852,6 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 {
 	int err;
 
-	if (!dev->netdev_ops->ndo_setup_tc)
-		return -EOPNOTSUPP;
-
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
@@ -858,7 +872,12 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	if (!nf_flowtable_hw_offload(flowtable))
 		return 0;
 
-	err = nf_flow_table_offload_cmd(&bo, flowtable, dev, cmd, &extack);
+	if (dev->netdev_ops->ndo_setup_tc)
+		err = nf_flow_table_offload_cmd(&bo, flowtable, dev, cmd,
+						&extack);
+	else
+		err = nf_flow_table_indr_offload_cmd(&bo, flowtable, dev, cmd,
+						     &extack);
 	if (err < 0)
 		return err;
 
@@ -866,10 +885,75 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_setup);
 
+static void nf_flow_table_indr_block_ing_cmd(struct net_device *dev,
+					     struct nf_flowtable *flowtable,
+					     flow_indr_block_bind_cb_t *cb,
+					     void *cb_priv,
+					     enum flow_block_command cmd)
+{
+	struct netlink_ext_ack extack = {};
+	struct flow_block_offload bo;
+
+	if (!flowtable)
+		return;
+
+	nf_flow_table_block_offload_init(&bo, dev_net(dev), cmd, flowtable,
+					 &extack);
+
+	cb(dev, cb_priv, TC_SETUP_FT, &bo);
+
+	nf_flow_table_block_setup(flowtable, &bo, cmd);
+}
+
+static void nf_flow_table_indr_block_cb_cmd(struct nf_flowtable *flowtable,
+					    struct net_device *dev,
+					    flow_indr_block_bind_cb_t *cb,
+					    void *cb_priv,
+					    enum flow_block_command cmd)
+{
+	if (!(flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD))
+		return;
+
+	nf_flow_table_indr_block_ing_cmd(dev, flowtable, cb, cb_priv, cmd);
+}
+
+static void nf_flow_table_indr_block_cb(struct net_device *dev,
+					flow_indr_block_bind_cb_t *cb,
+					void *cb_priv,
+					enum flow_block_command cmd)
+{
+	struct net *net = dev_net(dev);
+	struct nft_flowtable *nft_ft;
+	struct nft_table *table;
+	struct nft_hook *hook;
+
+	mutex_lock(&net->nft.commit_mutex);
+	list_for_each_entry(table, &net->nft.tables, list) {
+		list_for_each_entry(nft_ft, &table->flowtables, list) {
+			list_for_each_entry(hook, &nft_ft->hook_list, list) {
+				if (hook->ops.dev != dev)
+					continue;
+
+				nf_flow_table_indr_block_cb_cmd(&nft_ft->data,
+								dev, cb,
+								cb_priv, cmd);
+			}
+		}
+	}
+	mutex_unlock(&net->nft.commit_mutex);
+}
+
+static struct flow_indr_block_entry block_ing_entry = {
+	.cb	= nf_flow_table_indr_block_cb,
+	.list	= LIST_HEAD_INIT(block_ing_entry.list),
+};
+
 int nf_flow_table_offload_init(void)
 {
 	INIT_WORK(&nf_flow_offload_work, flow_offload_work_handler);
 
+	flow_indr_add_block_cb(&block_ing_entry);
+
 	return 0;
 }
 
@@ -878,6 +962,8 @@ void nf_flow_table_offload_exit(void)
 	struct flow_offload_work *offload, *next;
 	LIST_HEAD(offload_pending_list);
 
+	flow_indr_del_block_cb(&block_ing_entry);
+
 	cancel_work_sync(&nf_flow_offload_work);
 
 	list_for_each_entry_safe(offload, next, &offload_pending_list, list) {
-- 
2.11.0

