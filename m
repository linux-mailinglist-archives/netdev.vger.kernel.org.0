Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4241C100E4F
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfKRVtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:49:51 -0500
Received: from correo.us.es ([193.147.175.20]:45706 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbfKRVth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8807EBACC
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9455DA8E8
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9F283DA801; Mon, 18 Nov 2019 22:49:32 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05E64B7FFE;
        Mon, 18 Nov 2019 22:49:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CC30842EE38F;
        Mon, 18 Nov 2019 22:49:28 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/18] netfilter: nf_flow_table: remove unnecessary parameter in flow_offload_fill_dir
Date:   Mon, 18 Nov 2019 22:49:09 +0100
Message-Id: <20191118214914.142794-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The ct object is already in the flow_offload structure, remove it.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 8468d2d02284..9889d52eda82 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -18,11 +18,11 @@ static DEFINE_MUTEX(flowtable_lock);
 static LIST_HEAD(flowtables);
 
 static void
-flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
+flow_offload_fill_dir(struct flow_offload *flow,
 		      enum flow_offload_tuple_dir dir)
 {
 	struct flow_offload_tuple *ft = &flow->tuplehash[dir].tuple;
-	struct nf_conntrack_tuple *ctt = &ct->tuplehash[dir].tuple;
+	struct nf_conntrack_tuple *ctt = &flow->ct->tuplehash[dir].tuple;
 
 	ft->dir = dir;
 
@@ -57,8 +57,8 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 
 	flow->ct = ct;
 
-	flow_offload_fill_dir(flow, ct, FLOW_OFFLOAD_DIR_ORIGINAL);
-	flow_offload_fill_dir(flow, ct, FLOW_OFFLOAD_DIR_REPLY);
+	flow_offload_fill_dir(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
+	flow_offload_fill_dir(flow, FLOW_OFFLOAD_DIR_REPLY);
 
 	if (ct->status & IPS_SRC_NAT)
 		flow->flags |= FLOW_OFFLOAD_SNAT;
-- 
2.11.0

