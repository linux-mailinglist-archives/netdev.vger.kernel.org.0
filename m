Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9125C1AE565
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgDQTDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725960AbgDQTDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 15:03:31 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481F9C061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 12:03:31 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y24so4118194wma.4
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 12:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EikCUfiBLwSbnCEJ3phBC6Rg4AdDtAKWNBIE3BztNo0=;
        b=CcnjcHcULTseoVwTEDlsh09uqtFvHIjn08rfKF3EpkYs9ptyZ4T5C/xU/MADmBy4vz
         N+wUQ+O4lDBX1NZy+X8zjGmmujbijagSiYuFc6/jk1x6HCblpFiqK1u8fXsRNIikU+14
         FWxJAgHZxLwmlkbxTF4QXk1oCol35rvP+a5AiQDX9F4UKdnaqoq0eRy3Vw/oLaO9xkDV
         DZuoZgqzpkQZ6YsLInOM5OnGdhFu8VrPDpJmHgbNzTS3oDHX7BMVhVLcptfd2pL85oIW
         SBFdC710AeibZBtVQreKZGBKfUjgG9L6qJWrHR+dO6LF7iMx+aNccOQEB/hicstNEZ2N
         DnTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EikCUfiBLwSbnCEJ3phBC6Rg4AdDtAKWNBIE3BztNo0=;
        b=dM0B0ZIv/trUkGCdal1MDSHezDhDPeBpwbTH+6HoAs/yBz99Zk+9GMBTrz3ZzGjRCe
         myPupt5n6quAAxx9d5lFCNWNR9kMkX+n58GTRM8iH1ph9AtPZB5MDVAEr+YmC271k5Ba
         0FjK6LMEn+GzdtANGY+SvV0qQjYcv3KntLXH6Qm1xpp3fk6R1kAg3tQvWBU5eZmF5piJ
         egAeKL5tp5xcu2wmzvN+2yXPKH2K/rJAgRgVWK3sg8WaqiTbWg/l8dSJImm/GoIUDALX
         hWBaO9fJE5diU1K0Io67X4hOUpr25e6vKV2OgFBkMfmSyAiwB5O6vRRYhZRVu/9MFm+S
         fx9Q==
X-Gm-Message-State: AGi0PuYVI96phuZssA2jkXP15MF47gvH4mm4+7kHzDZmUgZtchPQXcef
        ocd2MMuoMLWE+QlSNnauxdE=
X-Google-Smtp-Source: APiQypKoCl44cGwdpISJnqe21St/U9wKiaLyi9FyLQDJhOCDcb+U0tizz8esxjGofSZsI5atCXcwTA==
X-Received: by 2002:a1c:6741:: with SMTP id b62mr3886654wmc.22.1587150209906;
        Fri, 17 Apr 2020 12:03:29 -0700 (PDT)
Received: from localhost.localdomain ([188.25.102.96])
        by smtp.gmail.com with ESMTPSA id h3sm27520231wrm.73.2020.04.17.12.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 12:03:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com, jiri@mellanox.com,
        idosch@idosch.org, kuba@kernel.org
Subject: [PATCH net-next] net: mscc: ocelot: deal with problematic MAC_ETYPE VCAP IS2 rules
Date:   Fri, 17 Apr 2020 22:03:08 +0300
Message-Id: <20200417190308.32598-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

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
2.17.1

