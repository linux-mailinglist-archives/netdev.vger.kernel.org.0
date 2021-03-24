Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB9A346ED6
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbhCXBb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbhCXBbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:31:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58602C061763;
        Tue, 23 Mar 2021 18:31:20 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0256963129;
        Wed, 24 Mar 2021 02:31:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 19/24] netfilter: flowtable: support for FLOW_ACTION_PPPOE_PUSH
Date:   Wed, 24 Mar 2021 02:30:50 +0100
Message-Id: <20210324013055.5619-20-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a PPPoE push action if layer 2 protocol is ETH_P_PPP_SES to add
PPPoE flowtable hardware offload support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 net/netfilter/nf_flow_table_offload.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 9326ba74745e..7d0d128407be 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -600,9 +600,18 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
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

