Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 271D82FCEA
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 16:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfE3OI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 10:08:59 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:44261 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfE3OI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 10:08:59 -0400
X-Originating-IP: 86.206.242.253
Received: from mc-bl-xps13.lan (lfbn-tou-1-417-253.w86-206.abo.wanadoo.fr [86.206.242.253])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 383D21BF209;
        Thu, 30 May 2019 14:08:50 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com
Subject: [PATCH net] ethtool: Check for vlan etype or vlan tci when parsing flow_rule
Date:   Thu, 30 May 2019 16:08:40 +0200
Message-Id: <20190530140840.741-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When parsing an ethtool flow spec to build a flow_rule, the code checks
if both the vlan etype and the vlan tci are specified by the user to add
a FLOW_DISSECTOR_KEY_VLAN match.

However, when the user only specified a vlan etype or a vlan tci, this
check silently ignores these parameters.

For example, the following rule :

ethtool -N eth0 flow-type udp4 vlan 0x0010 action -1 loc 0

will result in no error being issued, but the equivalent rule will be
created and passed to the NIC driver :

ethtool -N eth0 flow-type udp4 action -1 loc 0

In the end, neither the NIC driver using the rule nor the end user have
a way to know that these keys were dropped along the way, or that
incorrect parameters were entered.

This kind of check should be left to either the driver, or the ethtool
flow spec layer.

This commit makes so that ethtool parameters are forwarded as-is to the
NIC driver.

Since none of the users of ethtool_rx_flow_rule_create are using the
VLAN dissector, I don't think this qualifies as a regression.

Fixes: eca4205f9ec3 ("ethtool: add ethtool_rx_flow_spec to flow_rule structure translator")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---

This patch was previously sent as :
"ethtool: Drop check for vlan etype and vlan tci when parsing flow_rule"

Following Pablo's review, we don't drop the check anymore, hence the
more fitting subject.


 net/core/ethtool.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 4a593853cbf2..43e9add58340 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -3010,11 +3010,12 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
 		const struct ethtool_flow_ext *ext_h_spec = &fs->h_ext;
 		const struct ethtool_flow_ext *ext_m_spec = &fs->m_ext;
 
-		if (ext_m_spec->vlan_etype &&
-		    ext_m_spec->vlan_tci) {
+		if (ext_m_spec->vlan_etype) {
 			match->key.vlan.vlan_tpid = ext_h_spec->vlan_etype;
 			match->mask.vlan.vlan_tpid = ext_m_spec->vlan_etype;
+		}
 
+		if (ext_m_spec->vlan_tci) {
 			match->key.vlan.vlan_id =
 				ntohs(ext_h_spec->vlan_tci) & 0x0fff;
 			match->mask.vlan.vlan_id =
@@ -3024,7 +3025,10 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
 				(ntohs(ext_h_spec->vlan_tci) & 0xe000) >> 13;
 			match->mask.vlan.vlan_priority =
 				(ntohs(ext_m_spec->vlan_tci) & 0xe000) >> 13;
+		}
 
+		if (ext_m_spec->vlan_etype ||
+		    ext_m_spec->vlan_tci) {
 			match->dissector.used_keys |=
 				BIT(FLOW_DISSECTOR_KEY_VLAN);
 			match->dissector.offset[FLOW_DISSECTOR_KEY_VLAN] =
-- 
2.20.1

