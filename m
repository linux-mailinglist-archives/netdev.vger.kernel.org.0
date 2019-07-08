Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9F3625A9
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391358AbfGHQGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:06:36 -0400
Received: from mail.us.es ([193.147.175.20]:52884 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391078AbfGHQGf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 12:06:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A2EC8B633D
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 18:06:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 833301150DD
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 18:06:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7ECD61150CB; Mon,  8 Jul 2019 18:06:33 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9900E1150CC;
        Mon,  8 Jul 2019 18:06:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 18:06:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 72E3D4265A2F;
        Mon,  8 Jul 2019 18:06:29 +0200 (CEST)
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
Subject: [PATCH net-next,v3 07/11] net: sched: use flow block API
Date:   Mon,  8 Jul 2019 18:06:09 +0200
Message-Id: <20190708160614.2226-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708160614.2226-1-pablo@netfilter.org>
References: <20190708160614.2226-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tcf_block_setup() which uses the flow block API.

This infrastructure takes the flow block callbacks coming from the
driver and register/unregister to/from the cls_api core.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: call tcf_block_cb_free() - Jakub Kicinski.
    tcf_block_setup() already deals with unroll (see err_unroll) in case
    of error, so it is undoing ndo_setup_tc().

 net/sched/cls_api.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 72761b43ae41..728714d8f601 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -672,6 +672,9 @@ static void tc_indr_block_cb_del(struct tc_indr_block_cb *indr_block_cb)
 	kfree(indr_block_cb);
 }
 
+static int tcf_block_setup(struct tcf_block *block,
+			   struct flow_block_offload *bo);
+
 static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 				  struct tc_indr_block_cb *indr_block_cb,
 				  enum flow_block_command command)
@@ -682,12 +685,14 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 		.net		= dev_net(indr_dev->dev),
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
@@ -772,6 +777,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 		.block		= block,
 		.extack		= extack,
 	};
+	INIT_LIST_HEAD(&bo.cb_list);
 
 	indr_dev = tc_indr_block_dev_lookup(dev);
 	if (!indr_dev)
@@ -782,6 +788,8 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
 		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
 				  &bo);
+
+	tcf_block_setup(block, &bo);
 }
 
 static bool tcf_block_offload_in_use(struct tcf_block *block)
@@ -796,13 +804,20 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 				 struct netlink_ext_ack *extack)
 {
 	struct tc_block_offload bo = {};
+	int err;
 
 	bo.net = dev_net(dev);
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
@@ -1636,6 +1651,79 @@ void tcf_block_cb_unregister(struct tcf_block *block,
 }
 EXPORT_SYMBOL(tcf_block_cb_unregister);
 
+static int tcf_block_bind(struct tcf_block *block,
+			  struct flow_block_offload *bo)
+{
+	struct flow_block_cb *block_cb, *next;
+	int err, i = 0;
+
+	list_for_each_entry(block_cb, &bo->cb_list, driver_list) {
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
+	list_splice(&bo->cb_list, bo->driver_block_list);
+
+	return 0;
+
+err_unroll:
+	list_for_each_entry_safe(block_cb, next, &bo->cb_list, driver_list) {
+		if (i-- > 0) {
+			list_del(&block_cb->list);
+			tcf_block_playback_offloads(block, block_cb->cb,
+						    block_cb->cb_priv, false,
+						    tcf_block_offload_in_use(block),
+						    NULL);
+		}
+		flow_block_cb_free(block_cb);
+	}
+
+	return err;
+}
+
+static void tcf_block_unbind(struct tcf_block *block,
+			     struct flow_block_offload *bo)
+{
+	struct flow_block_cb *block_cb, *next;
+
+	list_for_each_entry_safe(block_cb, next, &bo->cb_list, driver_list) {
+		list_del(&block_cb->driver_list);
+		tcf_block_playback_offloads(block, block_cb->cb,
+					    block_cb->cb_priv, false,
+					    tcf_block_offload_in_use(block),
+					    NULL);
+		list_del(&block_cb->list);
+		flow_block_cb_free(block_cb);
+	}
+}
+
+static int tcf_block_setup(struct tcf_block *block,
+			   struct flow_block_offload *bo)
+{
+	int err;
+
+	switch (bo->command) {
+	case FLOW_BLOCK_BIND:
+		err = tcf_block_bind(block, bo);
+		break;
+	case FLOW_BLOCK_UNBIND:
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
 /* Main classifier routine: scans classifier chain attached
  * to this qdisc, (optionally) tests for protocol and asks
  * specific classifiers.
-- 
2.11.0

