Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 475B31175D2
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfLIT1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:27:46 -0500
Received: from correo.us.es ([193.147.175.20]:58466 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbfLIT0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 14:26:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CFF67120841
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1AD0DA70D
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:47 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B72E4DA70B; Mon,  9 Dec 2019 20:26:47 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B759FDA701;
        Mon,  9 Dec 2019 20:26:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 20:26:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4DDA64265A5A;
        Mon,  9 Dec 2019 20:26:45 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/17] netfilter: nf_flow_table_offload: Fix block_cb tc_setup_type as TC_SETUP_CLSFLOWER
Date:   Mon,  9 Dec 2019 20:26:24 +0100
Message-Id: <20191209192638.71184-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191209192638.71184-1-pablo@netfilter.org>
References: <20191209192638.71184-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add/del/stats flows through block_cb call must set the tc_setup_type as
TC_SETUP_CLSFLOWER.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 6067268ab9bc..b3ad285e057d 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -574,7 +574,7 @@ static int flow_offload_tuple_add(struct flow_offload_work *offload,
 	cls_flow.rule = flow_rule->rule;
 
 	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list) {
-		err = block_cb->cb(TC_SETUP_FT, &cls_flow,
+		err = block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow,
 				   block_cb->cb_priv);
 		if (err < 0)
 			continue;
@@ -599,7 +599,7 @@ static void flow_offload_tuple_del(struct flow_offload_work *offload,
 			     &offload->flow->tuplehash[dir].tuple, &extack);
 
 	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list)
-		block_cb->cb(TC_SETUP_FT, &cls_flow, block_cb->cb_priv);
+		block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow, block_cb->cb_priv);
 
 	offload->flow->flags |= FLOW_OFFLOAD_HW_DEAD;
 }
@@ -656,7 +656,7 @@ static void flow_offload_tuple_stats(struct flow_offload_work *offload,
 			     &offload->flow->tuplehash[dir].tuple, &extack);
 
 	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list)
-		block_cb->cb(TC_SETUP_FT, &cls_flow, block_cb->cb_priv);
+		block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow, block_cb->cb_priv);
 	memcpy(stats, &cls_flow.stats, sizeof(*stats));
 }
 
-- 
2.11.0

