Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0013368F5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhCKAg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:36:56 -0500
Received: from correo.us.es ([193.147.175.20]:50156 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230087AbhCKAg2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DB9BD12E830
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CDBDBDA792
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:27 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C2FD7DA78E; Thu, 11 Mar 2021 01:36:27 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90AB5DA704;
        Thu, 11 Mar 2021 01:36:25 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:25 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 5C5B542DC6E2;
        Thu, 11 Mar 2021 01:36:25 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 19/23] netfilter: flowtable: support for FLOW_ACTION_PPPOE_PUSH
Date:   Thu, 11 Mar 2021 01:36:00 +0100
Message-Id: <20210311003604.22199-20-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a PPPoE push action if layer 2 protocol is ETH_P_PPP_SES to add
PPPoE flowtable hardware offload support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 796f46463457..7d6526c571d4 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -598,9 +598,18 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 			continue;
 
 		entry = flow_action_entry_next(flow_rule);
-		entry->id = FLOW_ACTION_VLAN_PUSH;
-		entry->vlan.vid = other_tuple->encap[i].id;
-		entry->vlan.proto = other_tuple->encap[i].proto;
+
+		switch (other_tuple->encap[i].proto) {
+		case htons(ETH_P_PPP_SES):
+			entry->id = FLOW_ACTION_PPPOE_PUSH;
+			entry->pppoe.sid = other_tuple->encap[i].id;
+			break;
+		case htons(ETH_P_8021Q):
+			entry->id = FLOW_ACTION_VLAN_PUSH;
+			entry->vlan.vid = other_tuple->encap[i].id;
+			entry->vlan.proto = other_tuple->encap[i].proto;
+			break;
+		}
 	}
 
 	return 0;
-- 
2.20.1

