Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504CA625AD
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391324AbfGHQGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:06:34 -0400
Received: from mail.us.es ([193.147.175.20]:52936 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388381AbfGHQGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 12:06:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B0C0FB6BB8
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 18:06:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86E8A1021A7
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 18:06:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8452E6E7A0; Mon,  8 Jul 2019 18:06:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80E8610219C;
        Mon,  8 Jul 2019 18:06:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 18:06:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 508FD4265A31;
        Mon,  8 Jul 2019 18:06:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
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
        cphealy@gmail.com, netfilter-devel@vger.kernel.org
Subject: [PATCH net-next,v3 05/11] net: flow_offload: add list handling functions
Date:   Mon,  8 Jul 2019 18:06:07 +0200
Message-Id: <20190708160614.2226-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708160614.2226-1-pablo@netfilter.org>
References: <20190708160614.2226-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the list handling functions for the flow block API:

* flow_block_cb_lookup() allows drivers to look up for existing flow blocks.
* flow_block_cb_add() adds a flow block to the list to be registered by the
  core.
* flow_block_cb_remove() to remove a flow block from the list of existing
  flow blocks per driver and to request the core to unregister this.

The flow block API also annotates the netns this flow block belongs to.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: extracted from former patch "net: flow_offload: add flow_block_cb API".

 include/net/flow_offload.h | 20 ++++++++++++++++++++
 net/core/flow_offload.c    | 18 ++++++++++++++++++
 net/sched/cls_api.c        |  3 +++
 3 files changed, 41 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index bcc4e2fef6ba..06acde2960fa 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -251,12 +251,16 @@ struct flow_block_offload {
 	enum flow_block_command command;
 	enum flow_block_binder_type binder_type;
 	struct tcf_block *block;
+	struct net *net;
+	struct list_head cb_list;
 	struct list_head *driver_block_list;
 	struct netlink_ext_ack *extack;
 };
 
 struct flow_block_cb {
+	struct list_head	driver_list;
 	struct list_head	list;
+	struct net		*net;
 	tc_setup_cb_t		*cb;
 	void			*cb_ident;
 	void			*cb_priv;
@@ -269,6 +273,22 @@ struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
 					  void (*release)(void *cb_priv));
 void flow_block_cb_free(struct flow_block_cb *block_cb);
 
+struct flow_block_cb *flow_block_cb_lookup(struct net *net,
+					   struct list_head *driver_flow_block_list,
+					   tc_setup_cb_t *cb, void *cb_ident);
+
+static inline void flow_block_cb_add(struct flow_block_cb *block_cb,
+				     struct flow_block_offload *offload)
+{
+	list_add_tail(&block_cb->driver_list, &offload->cb_list);
+}
+
+static inline void flow_block_cb_remove(struct flow_block_cb *block_cb,
+					struct flow_block_offload *offload)
+{
+	list_move(&block_cb->driver_list, &offload->cb_list);
+}
+
 int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       struct list_head *driver_list, tc_setup_cb_t *cb,
 			       void *cb_ident, void *cb_priv, bool ingress_only);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index d08148cb6953..85fd5f4a1e0f 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -176,6 +176,7 @@ struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
 	if (!block_cb)
 		return ERR_PTR(-ENOMEM);
 
+	block_cb->net = net;
 	block_cb->cb = cb;
 	block_cb->cb_ident = cb_ident;
 	block_cb->cb_priv = cb_priv;
@@ -194,6 +195,23 @@ void flow_block_cb_free(struct flow_block_cb *block_cb)
 }
 EXPORT_SYMBOL(flow_block_cb_free);
 
+struct flow_block_cb *flow_block_cb_lookup(struct net *net,
+					   struct list_head *driver_block_list,
+					   tc_setup_cb_t *cb, void *cb_ident)
+{
+	struct flow_block_cb *block_cb;
+
+	list_for_each_entry(block_cb, driver_block_list, driver_list) {
+		if (block_cb->net == net &&
+		    block_cb->cb == cb &&
+		    block_cb->cb_ident == cb_ident)
+			return block_cb;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(flow_block_cb_lookup);
+
 int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       struct list_head *driver_block_list,
 			       tc_setup_cb_t *cb, void *cb_ident, void *cb_priv,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index fa0c451aca59..72761b43ae41 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -679,6 +679,7 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 	struct tc_block_offload bo = {
 		.command	= command,
 		.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
+		.net		= dev_net(indr_dev->dev),
 		.block		= indr_dev->block,
 	};
 
@@ -767,6 +768,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 	struct tc_block_offload bo = {
 		.command	= command,
 		.binder_type	= ei->binder_type,
+		.net		= dev_net(dev),
 		.block		= block,
 		.extack		= extack,
 	};
@@ -795,6 +797,7 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 {
 	struct tc_block_offload bo = {};
 
+	bo.net = dev_net(dev);
 	bo.command = command;
 	bo.binder_type = ei->binder_type;
 	bo.block = block;
-- 
2.11.0

