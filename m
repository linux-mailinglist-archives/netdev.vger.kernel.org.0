Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C48141981
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgARUO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:14:58 -0500
Received: from correo.us.es ([193.147.175.20]:48408 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728797AbgARUOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B31382EFEB7
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A418EDA70F
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 997B1DA717; Sat, 18 Jan 2020 21:14:30 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45729DA705;
        Sat, 18 Jan 2020 21:14:28 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:28 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1F76A41E4800;
        Sat, 18 Jan 2020 21:14:28 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/21] netfilter: flowtable: add nf_flow_table_offload_cmd()
Date:   Sat, 18 Jan 2020 21:14:07 +0100
Message-Id: <20200118201417.334111-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split nf_flow_table_offload_setup() in two functions to make it more
maintainable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 40 ++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 3cd8dc8714e3..c8b70ffeef0c 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -838,12 +838,12 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 	return err;
 }
 
-int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
-				struct net_device *dev,
-				enum flow_block_command cmd)
+static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
+				     struct nf_flowtable *flowtable,
+				     struct net_device *dev,
+				     enum flow_block_command cmd,
+				     struct netlink_ext_ack *extack)
 {
-	struct netlink_ext_ack extack = {};
-	struct flow_block_offload bo = {};
 	int err;
 
 	if (!nf_flowtable_hw_offload(flowtable))
@@ -852,14 +852,30 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	if (!dev->netdev_ops->ndo_setup_tc)
 		return -EOPNOTSUPP;
 
-	bo.net		= dev_net(dev);
-	bo.block	= &flowtable->flow_block;
-	bo.command	= cmd;
-	bo.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
-	bo.extack	= &extack;
-	INIT_LIST_HEAD(&bo.cb_list);
+	memset(bo, 0, sizeof(*bo));
+	bo->net		= dev_net(dev);
+	bo->block	= &flowtable->flow_block;
+	bo->command	= cmd;
+	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
+	bo->extack	= extack;
+	INIT_LIST_HEAD(&bo->cb_list);
+
+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
+				struct net_device *dev,
+				enum flow_block_command cmd)
+{
+	struct netlink_ext_ack extack = {};
+	struct flow_block_offload bo;
+	int err;
 
-	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, &bo);
+	err = nf_flow_table_offload_cmd(&bo, flowtable, dev, cmd, &extack);
 	if (err < 0)
 		return err;
 
-- 
2.11.0

