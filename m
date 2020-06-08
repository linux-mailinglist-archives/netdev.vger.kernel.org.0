Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A278B1F3085
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 03:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387928AbgFIBAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 21:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbgFHXI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F4BD20774;
        Mon,  8 Jun 2020 23:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657706;
        bh=LGucAxx+x52tVKnfbNkMjULMnphu0SKvwqOkseuLR7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjTPc3JYW60UXwGXlMlWoSYlMDTN4KntvnAWtE3IyWyRh5MA4pnJEMjlF7UeSV0Yv
         sr2Nl+fC7Jpew9Az9UJbH+PW+ZrorRKzhAVwHiTxde13ErOSWI9l3iPMqRvckH04Tf
         fVB4EKSesJkYwVCXRgGDTDhiLiEPPFNmpxRs3WVg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 103/274] net: mscc: ocelot: deal with problematic MAC_ETYPE VCAP IS2 rules
Date:   Mon,  8 Jun 2020 19:03:16 -0400
Message-Id: <20200608230607.3361041-103-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 89f9ffd3eb670bad1260bc579f5e13b8f2d5b3e0 ]

By default, the VCAP IS2 will produce a single match for each frame, on
the most specific classification.

Example: a ping packet (ICMP over IPv4 over Ethernet) sent from an IP
address of 10.0.0.1 and a MAC address of 96:18:82:00:04:01 will match
this rule:

tc filter add dev swp0 ingress protocol ipv4 \
	flower skip_sw src_ip 10.0.0.1 action drop

but not this one:

tc filter add dev swp0 ingress \
	flower skip_sw src_mac 96:18:82:00:04:01 action drop

Currently the driver does not really warn the user in any way about
this, and the behavior is rather strange anyway.

The current patch is a workaround to force matches on MAC_ETYPE keys
(DMAC and SMAC) for all packets irrespective of higher layer protocol.
The setting is made at the port level.

Of course this breaks all other non-src_mac and non-dst_mac matches, so
rule exclusivity checks have been added to the driver, in order to never
have rules of both types on any ingress port.

The bits that discard higher-level protocol information are set only
once a MAC_ETYPE rule is added to a filter block, and only for the ports
that are bound to that filter block. Then all further non-MAC_ETYPE
rules added to that filter block should be denied by the ports bound to
it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_ace.c    | 103 +++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_ace.h    |   5 +-
 drivers/net/ethernet/mscc/ocelot_flower.c |   2 +-
 3 files changed, 106 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 3bd286044480..8a2f7d13ef6d 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -706,13 +706,114 @@ ocelot_ace_rule_get_rule_index(struct ocelot_acl_block *block, int index)
 	return NULL;
 }
 
+/* If @on=false, then SNAP, ARP, IP and OAM frames will not match on keys based
+ * on destination and source MAC addresses, but only on higher-level protocol
+ * information. The only frame types to match on keys containing MAC addresses
+ * in this case are non-SNAP, non-ARP, non-IP and non-OAM frames.
+ *
+ * If @on=true, then the above frame types (SNAP, ARP, IP and OAM) will match
+ * on MAC_ETYPE keys such as destination and source MAC on this ingress port.
+ * However the setting has the side effect of making these frames not matching
+ * on any _other_ keys than MAC_ETYPE ones.
+ */
+static void ocelot_match_all_as_mac_etype(struct ocelot *ocelot, int port,
+					  bool on)
+{
+	u32 val = 0;
+
+	if (on)
+		val = ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS(3) |
+		      ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS(3) |
+		      ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS(3) |
+		      ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS(3) |
+		      ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS(3);
+
+	ocelot_rmw_gix(ocelot, val,
+		       ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS_M |
+		       ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS_M |
+		       ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS_M |
+		       ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS_M |
+		       ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS_M,
+		       ANA_PORT_VCAP_S2_CFG, port);
+}
+
+static bool ocelot_ace_is_problematic_mac_etype(struct ocelot_ace_rule *ace)
+{
+	if (ace->type != OCELOT_ACE_TYPE_ETYPE)
+		return false;
+	if (ether_addr_to_u64(ace->frame.etype.dmac.value) &
+	    ether_addr_to_u64(ace->frame.etype.dmac.mask))
+		return true;
+	if (ether_addr_to_u64(ace->frame.etype.smac.value) &
+	    ether_addr_to_u64(ace->frame.etype.smac.mask))
+		return true;
+	return false;
+}
+
+static bool ocelot_ace_is_problematic_non_mac_etype(struct ocelot_ace_rule *ace)
+{
+	if (ace->type == OCELOT_ACE_TYPE_SNAP)
+		return true;
+	if (ace->type == OCELOT_ACE_TYPE_ARP)
+		return true;
+	if (ace->type == OCELOT_ACE_TYPE_IPV4)
+		return true;
+	if (ace->type == OCELOT_ACE_TYPE_IPV6)
+		return true;
+	return false;
+}
+
+static bool ocelot_exclusive_mac_etype_ace_rules(struct ocelot *ocelot,
+						 struct ocelot_ace_rule *ace)
+{
+	struct ocelot_acl_block *block = &ocelot->acl_block;
+	struct ocelot_ace_rule *tmp;
+	unsigned long port;
+	int i;
+
+	if (ocelot_ace_is_problematic_mac_etype(ace)) {
+		/* Search for any non-MAC_ETYPE rules on the port */
+		for (i = 0; i < block->count; i++) {
+			tmp = ocelot_ace_rule_get_rule_index(block, i);
+			if (tmp->ingress_port_mask & ace->ingress_port_mask &&
+			    ocelot_ace_is_problematic_non_mac_etype(tmp))
+				return false;
+		}
+
+		for_each_set_bit(port, &ace->ingress_port_mask,
+				 ocelot->num_phys_ports)
+			ocelot_match_all_as_mac_etype(ocelot, port, true);
+	} else if (ocelot_ace_is_problematic_non_mac_etype(ace)) {
+		/* Search for any MAC_ETYPE rules on the port */
+		for (i = 0; i < block->count; i++) {
+			tmp = ocelot_ace_rule_get_rule_index(block, i);
+			if (tmp->ingress_port_mask & ace->ingress_port_mask &&
+			    ocelot_ace_is_problematic_mac_etype(tmp))
+				return false;
+		}
+
+		for_each_set_bit(port, &ace->ingress_port_mask,
+				 ocelot->num_phys_ports)
+			ocelot_match_all_as_mac_etype(ocelot, port, false);
+	}
+
+	return true;
+}
+
 int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
-				struct ocelot_ace_rule *rule)
+				struct ocelot_ace_rule *rule,
+				struct netlink_ext_ack *extack)
 {
 	struct ocelot_acl_block *block = &ocelot->acl_block;
 	struct ocelot_ace_rule *ace;
 	int i, index;
 
+	if (!ocelot_exclusive_mac_etype_ace_rules(ocelot, rule)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot mix MAC_ETYPE with non-MAC_ETYPE rules");
+		return -EBUSY;
+	}
+
 	/* Add rule to the linked list */
 	ocelot_ace_rule_add(ocelot, block, rule);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index 29d22c566786..099e177f2617 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -194,7 +194,7 @@ struct ocelot_ace_rule {
 
 	enum ocelot_ace_action action;
 	struct ocelot_ace_stats stats;
-	u16 ingress_port_mask;
+	unsigned long ingress_port_mask;
 
 	enum ocelot_vcap_bit dmac_mc;
 	enum ocelot_vcap_bit dmac_bc;
@@ -215,7 +215,8 @@ struct ocelot_ace_rule {
 };
 
 int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
-				struct ocelot_ace_rule *rule);
+				struct ocelot_ace_rule *rule,
+				struct netlink_ext_ack *extack);
 int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
 				struct ocelot_ace_rule *rule);
 int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 341923311fec..954cb67eeaa2 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -205,7 +205,7 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 		return ret;
 	}
 
-	return ocelot_ace_rule_offload_add(ocelot, ace);
+	return ocelot_ace_rule_offload_add(ocelot, ace, f->common.extack);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
 
-- 
2.25.1

