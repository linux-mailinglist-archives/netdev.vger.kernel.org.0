Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A2F5FEBC
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 01:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbfGDXtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 19:49:21 -0400
Received: from mail.us.es ([193.147.175.20]:33104 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727688AbfGDXtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 19:49:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 45C0981694
        for <netdev@vger.kernel.org>; Fri,  5 Jul 2019 01:49:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2DC62115107
        for <netdev@vger.kernel.org>; Fri,  5 Jul 2019 01:49:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2C94D115117; Fri,  5 Jul 2019 01:49:17 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4704BDA4D0;
        Fri,  5 Jul 2019 01:49:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Jul 2019 01:49:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0D6234265A31;
        Fri,  5 Jul 2019 01:49:13 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com
Subject: [PATCH 04/15 net-next,v2] net: sched: add tcf_block_setup()
Date:   Fri,  5 Jul 2019 01:48:32 +0200
Message-Id: <20190704234843.6601-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190704234843.6601-1-pablo@netfilter.org>
References: <20190704234843.6601-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new function allows us to handle tcf_block_cb registrations /
unregistrations from the core, in order to remove a dependency with the
tcf_block object and the .reoffload cls_api callback.

The tcf_block_cb_add() call places the tcf_block_cb object, which has
been set up by the driver, in the tc_block_offload->cb_list. This is a
temporary list that is used to convey the tcf_block_cb objects back to
the core for registration.

Note that this patch introduces a global tcf_block_cb_list, however,
this is a temporary artifact to make it easy for me to update the code
to use this new infrastructure. This global list goes away in a follow
up patch to add per-driver flow block lists.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/net/pkt_cls.h |  19 ++++++++++
 net/sched/cls_api.c   | 102 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index b50df3b9456c..d660cb4fad75 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -75,6 +75,13 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
 					void *cb_ident, void *cb_priv);
 void tcf_block_cb_free(struct tcf_block_cb *block_cb);
+
+struct tc_block_offload;
+void tcf_block_cb_add(struct tcf_block_cb *block_cb,
+		      struct tc_block_offload *offload);
+void tcf_block_cb_remove(struct tcf_block_cb *block_cb,
+			 struct tc_block_offload *offload);
+
 void *tcf_block_cb_priv(struct tcf_block_cb *block_cb);
 struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
 					 tc_setup_cb_t *cb, void *cb_ident);
@@ -163,6 +170,17 @@ static inline void tcf_block_cb_free(struct tcf_block_cb *block_cb)
 {
 }
 
+struct tc_block_offload;
+static inline void tcf_block_cb_add(struct tcf_block_cb *block_cb,
+				    struct tc_block_offload *offload)
+{
+}
+
+static inline void tcf_block_cb_remove(struct tcf_block_cb *block_cb,
+				       struct tc_block_offload *offload)
+{
+}
+
 static inline
 void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
 {
@@ -631,6 +649,7 @@ enum tc_block_command {
 struct tc_block_offload {
 	enum tc_block_command command;
 	enum tcf_block_binder_type binder_type;
+	struct list_head cb_list;
 	struct tcf_block *block;
 	struct netlink_ext_ack *extack;
 };
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 93b74a15e7ac..a2c1258cc8dc 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -710,6 +710,7 @@ static bool tcf_block_offload_in_use(struct tcf_block *block)
 }
 
 struct tcf_block_cb {
+	struct list_head global_list;
 	struct list_head list;
 	tc_setup_cb_t *cb;
 	void *cb_ident;
@@ -723,6 +724,8 @@ void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
 }
 EXPORT_SYMBOL(tcf_block_cb_priv);
 
+static LIST_HEAD(tcf_block_cb_list);
+
 struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
 					 tc_setup_cb_t *cb, void *cb_ident)
 {	struct tcf_block_cb *block_cb;
@@ -769,6 +772,20 @@ void tcf_block_cb_free(struct tcf_block_cb *block_cb)
 }
 EXPORT_SYMBOL(tcf_block_cb_free);
 
+void tcf_block_cb_add(struct tcf_block_cb *block_cb,
+		      struct tc_block_offload *offload)
+{
+	list_add_tail(&block_cb->global_list, &offload->cb_list);
+}
+EXPORT_SYMBOL(tcf_block_cb_add);
+
+void tcf_block_cb_remove(struct tcf_block_cb *block_cb,
+			 struct tc_block_offload *offload)
+{
+	list_move(&block_cb->global_list, &offload->cb_list);
+}
+EXPORT_SYMBOL(tcf_block_cb_remove);
+
 struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
 					     tc_setup_cb_t *cb, void *cb_ident,
 					     void *cb_priv,
@@ -828,6 +845,77 @@ void tcf_block_cb_unregister(struct tcf_block *block,
 }
 EXPORT_SYMBOL(tcf_block_cb_unregister);
 
+static int tcf_block_bind(struct tcf_block *block, struct tc_block_offload *bo)
+{
+	struct tcf_block_cb *block_cb, *next;
+	int err, i = 0;
+
+	list_for_each_entry(block_cb, &bo->cb_list, global_list) {
+		err = tcf_block_playback_offloads(block, block_cb->cb,
+						  block_cb->cb_priv, true,
+						  tcf_block_offload_in_use(block),
+						  bo->extack);
+		if (err)
+			goto err_unroll;
+
+		list_add(&block_cb->list, &block->cb_list);
+		i++;
+	}
+	list_splice(&bo->cb_list, &tcf_block_cb_list);
+
+	return 0;
+
+err_unroll:
+	list_for_each_entry_safe(block_cb, next, &bo->cb_list, global_list) {
+		if (i-- > 0) {
+			list_del(&block_cb->list);
+			tcf_block_playback_offloads(block, block_cb->cb,
+						    block_cb->cb_priv, false,
+						    tcf_block_offload_in_use(block),
+						    NULL);
+		}
+		kfree(block_cb);
+	}
+
+	return err;
+}
+
+static void tcf_block_unbind(struct tcf_block *block,
+			     struct tc_block_offload *bo)
+{
+	struct tcf_block_cb *block_cb, *next;
+
+	list_for_each_entry_safe(block_cb, next, &bo->cb_list, global_list) {
+		list_del(&block_cb->global_list);
+		tcf_block_playback_offloads(block, block_cb->cb,
+					    block_cb->cb_priv, false,
+					    tcf_block_offload_in_use(block),
+					    NULL);
+		list_del(&block_cb->list);
+		tcf_block_cb_free(block_cb);
+	}
+}
+
+static int tcf_block_setup(struct tcf_block *block, struct tc_block_offload *bo)
+{
+	int err;
+
+	switch (bo->command) {
+	case TC_BLOCK_BIND:
+		err = tcf_block_bind(block, bo);
+		break;
+	case TC_BLOCK_UNBIND:
+		err = 0;
+		tcf_block_unbind(block, bo);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
 static struct rhashtable indr_setup_block_ht;
 
 struct tc_indr_block_dev {
@@ -944,12 +1032,14 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 		.binder_type	= TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
 		.block		= indr_dev->block,
 	};
+	INIT_LIST_HEAD(&bo.cb_list);
 
 	if (!indr_dev->block)
 		return;
 
 	indr_block_cb->cb(indr_dev->dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
 			  &bo);
+	tcf_block_setup(indr_dev->block, &bo);
 }
 
 int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
@@ -1033,6 +1123,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 		.block		= block,
 		.extack		= extack,
 	};
+	INIT_LIST_HEAD(&bo.cb_list);
 
 	indr_dev = tc_indr_block_dev_lookup(dev);
 	if (!indr_dev)
@@ -1043,6 +1134,8 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
 		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
 				  &bo);
+
+	tcf_block_setup(block, &bo);
 }
 
 static int tcf_block_offload_cmd(struct tcf_block *block,
@@ -1052,12 +1145,19 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 				 struct netlink_ext_ack *extack)
 {
 	struct tc_block_offload bo = {};
+	int err;
 
 	bo.command = command;
 	bo.binder_type = ei->binder_type;
 	bo.block = block;
 	bo.extack = extack;
-	return dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
+	INIT_LIST_HEAD(&bo.cb_list);
+
+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
+	if (err < 0)
+		return err;
+
+	return tcf_block_setup(block, &bo);
 }
 
 static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
-- 
2.11.0

