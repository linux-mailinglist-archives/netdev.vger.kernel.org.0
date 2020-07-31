Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED7B234CAC
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 23:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgGaVHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 17:07:15 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:10024 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgGaVHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 17:07:15 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06VL76vx018712;
        Fri, 31 Jul 2020 14:07:06 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, vishal@chelsio.com, dt@chelsio.com
Subject: [PATCH net-next] cxgb4: fix extracting IP addresses in TC-FLOWER rules
Date:   Sat,  1 Aug 2020 02:23:40 +0530
Message-Id: <1596228820-25570-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit c8729cac2a11 ("cxgb4: add ethtool n-tuple filter insertion")
has removed checking control key for determining IP address types
for TC-FLOWER rules, which causes all the rules being inserted to
hardware to become IPv6 rule type always. So, add back the check
to select the correct IP address type to extract and hence fix the
correct rule type being inserted to hardware.

Also, ethtool_rx_flow_key doesn't have any control key and instead
directly sets the IPv4/IPv6 address keys. So, explicitly set the
IP address type for ethtool n-tuple filters to reuse the same code.

Fixes: c8729cac2a11 ("cxgb4: add ethtool n-tuple filter insertion")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c    | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 6251444ffa58..f642c1b475c4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -80,6 +80,19 @@ static void cxgb4_process_flow_match(struct net_device *dev,
 				     struct flow_rule *rule,
 				     struct ch_filter_specification *fs)
 {
+	u16 addr_type = 0;
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
+
+		flow_rule_match_control(rule, &match);
+		addr_type = match.key->addr_type;
+	} else if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
+		addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+	} else if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
+		addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
 		struct flow_match_basic match;
 		u16 ethtype_key, ethtype_mask;
@@ -102,7 +115,7 @@ static void cxgb4_process_flow_match(struct net_device *dev,
 		fs->mask.proto = match.mask->ip_proto;
 	}
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
+	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
 		struct flow_match_ipv4_addrs match;
 
 		flow_rule_match_ipv4_addrs(rule, &match);
@@ -117,7 +130,7 @@ static void cxgb4_process_flow_match(struct net_device *dev,
 		memcpy(&fs->nat_fip[0], &match.key->src, sizeof(match.key->src));
 	}
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
+	if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
 		struct flow_match_ipv6_addrs match;
 
 		flow_rule_match_ipv6_addrs(rule, &match);
-- 
2.24.0

