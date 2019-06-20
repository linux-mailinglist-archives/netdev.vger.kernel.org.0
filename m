Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9DF4DA9F
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfFTTts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:49:48 -0400
Received: from mail.us.es ([193.147.175.20]:54324 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbfFTTtq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:49:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8D300B60E3
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7553DDA70B
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 71D10DA705; Thu, 20 Jun 2019 21:49:44 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD354DA709;
        Thu, 20 Jun 2019 21:49:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 21:49:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A0BDA4265A2F;
        Thu, 20 Jun 2019 21:49:39 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: [PATCH net-next 08/12] net: cls_api: do not expose tcf_block to drivers
Date:   Thu, 20 Jun 2019 21:49:13 +0200
Message-Id: <20190620194917.2298-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190620194917.2298-1-pablo@netfilter.org>
References: <20190620194917.2298-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose the block index which is sufficient to look up for the
tcf_block_cb object.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mscc/ocelot_tc.c               | 2 +-
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 2 +-
 include/net/pkt_cls.h                               | 2 +-
 net/sched/cls_api.c                                 | 4 +---
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index e99865b873df..1a2ec5eb65a5 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -140,7 +140,7 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 
 	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
 		cb = ocelot_setup_tc_block_cb_ig;
-		port->tc.block_shared = tcf_block_shared(f->block);
+		port->tc.block_shared = f->block_shared;
 	} else if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
 		cb = ocelot_setup_tc_block_cb_eg;
 	} else {
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 8197bf6358aa..297ee0a9c194 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1270,7 +1270,7 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 		return -EOPNOTSUPP;
 
 	repr_priv = repr->app_priv;
-	repr_priv->block_shared = tcf_block_shared(f->block);
+	repr_priv->block_shared = f->block_shared;
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 2f3fac9ccf60..97d9578bc9c4 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -663,7 +663,7 @@ struct tc_block_offload {
 	enum tcf_block_binder_type binder_type;
 	struct list_head cb_list;
 	struct net *net;
-	struct tcf_block *block;
+	bool block_shared;
 	struct netlink_ext_ack *extack;
 };
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 6b397784eee5..ec3663511436 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1073,7 +1073,6 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 		.command	= command,
 		.binder_type	= TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
 		.net		= dev_net(indr_dev->dev),
-		.block		= indr_dev->block,
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
 
@@ -1164,7 +1163,6 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 		.command	= command,
 		.binder_type	= ei->binder_type,
 		.net		= dev_net(dev),
-		.block		= block,
 		.extack		= extack,
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
@@ -1195,7 +1193,7 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 	bo.command = command;
 	bo.binder_type = ei->binder_type;
 	bo.net = dev_net(dev),
-	bo.block = block;
+	bo.block_shared = tcf_block_shared(block);
 	bo.extack = extack;
 	INIT_LIST_HEAD(&bo.cb_list);
 
-- 
2.11.0

