Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF671E716F
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438096AbgE2A0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:26:41 -0400
Received: from correo.us.es ([193.147.175.20]:44342 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438100AbgE2AZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:25:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E4F78CF69E
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 02:25:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D63A4DA705
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 02:25:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C1E61DA716; Fri, 29 May 2020 02:25:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C82BDA701;
        Fri, 29 May 2020 02:25:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 02:25:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 01BB3426CCB9;
        Fri, 29 May 2020 02:25:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, vladbu@mellanox.com, jiri@resnulli.us,
        kuba@kernel.org, saeedm@mellanox.com, michael.chan@broadcom.com,
        sriharsha.basavapatna@broadcom.com
Subject: [PATCH net-next 3/8] net: cls_api: add tcf_block_offload_init()
Date:   Fri, 29 May 2020 02:25:36 +0200
Message-Id: <20200529002541.19743-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529002541.19743-1-pablo@netfilter.org>
References: <20200529002541.19743-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper function to initialize the flow_block_offload structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/sched/cls_api.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 752d608f4442..c5a2f16097b6 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -693,6 +693,22 @@ static void tc_indr_block_get_and_cmd(struct net_device *dev,
 	tc_indr_block_cmd(dev, block, cb, cb_priv, command, false);
 }
 
+static void tcf_block_offload_init(struct flow_block_offload *bo,
+				   struct net_device *dev,
+				   enum flow_block_command command,
+				   enum flow_block_binder_type binder_type,
+				   struct flow_block *flow_block,
+				   bool shared, struct netlink_ext_ack *extack)
+{
+	bo->net = dev_net(dev);
+	bo->command = command;
+	bo->binder_type = binder_type;
+	bo->block = flow_block;
+	bo->block_shared = shared;
+	bo->extack = extack;
+	INIT_LIST_HEAD(&bo->cb_list);
+}
+
 static void tc_indr_block_call(struct tcf_block *block,
 			       struct net_device *dev,
 			       struct tcf_block_ext_info *ei,
@@ -727,13 +743,9 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 	struct flow_block_offload bo = {};
 	int err;
 
-	bo.net = dev_net(dev);
-	bo.command = command;
-	bo.binder_type = ei->binder_type;
-	bo.block = &block->flow_block;
-	bo.block_shared = tcf_block_shared(block);
-	bo.extack = extack;
-	INIT_LIST_HEAD(&bo.cb_list);
+	tcf_block_offload_init(&bo, dev, command, ei->binder_type,
+			       &block->flow_block, tcf_block_shared(block),
+			       extack);
 
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
 	if (err < 0) {
-- 
2.20.1

