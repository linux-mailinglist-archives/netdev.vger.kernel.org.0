Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EAB1C2F62
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 23:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbgECVLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 17:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729128AbgECVLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 17:11:00 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E48C061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 14:10:58 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x18so18580013wrq.2
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 14:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zgLUHGAmUVguBMzEf6CjmppThQS74fns5r5nV8+5y+E=;
        b=NK3Im/iqBu7kdhs7Op56nTR7fh0uKv4oh9G1TcVJRZ26KjL2FSI6ZzWx+3aByqin1T
         +RGpvuaZQaOCANba8OfX5ErSWSyXwFCIA6eJ0TtFWC4eWipkegjENnAVSqDnu5Ujxar5
         m7PRExlr+r1QoEIaghn7vtZgcaHQZ2qdYSN6SJug7ONMQpECmJZHd4mQaKwbDbNM+ovn
         LDIwLmzzyOMY63UjDByVyGpMJ5k95lkJMf7EQoVGLsUq8F1XLdm035U96eMwUjuc8fkl
         EYT0zjvMZiIAEOfArIxvbqdfAgOwKYwqlUMfwFZOQJ6Nw8siYZAh5yjBaY54UB3Dh/ZN
         2UCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zgLUHGAmUVguBMzEf6CjmppThQS74fns5r5nV8+5y+E=;
        b=iNfxB8YqRz7pwWcbw5hVQyj2TmOT63jnq0+ksOKuMSgLGqZGhu4+kQeTMIMsbBwSct
         Q/21+ylSJBo8CXZ8p8qHwuv9+ryqWPptwgs5ivr9HFX1MtqQsdCl7xwSZDuTJ70JeaZ6
         GBe2RqpvhT/++hMSPdPDdlkpWv63ryQzYf22v/ubFJsVL8lnTZKiv0SOhjvvZiKhamRi
         dJXdnR83fSGI7ly6SFaUqcR46bWPSCULB77/sBMzDKmoG41nUykJmZBeI4/xz9NPz3sM
         rvztT+HwtTSFSLM5Dqehzk5iTcUXKxRZMGoyrVD6L/FjT2pHH8bptI/cISK5NoAY5P8q
         2RCQ==
X-Gm-Message-State: AGi0PubtLUqwPFrDpq78b5+URaQpkwvNUqhwAbauf9EqheFfMP8bWoQx
        JuF3uNkY1vlxWB8h1/nopQ7YKA0f
X-Google-Smtp-Source: APiQypL1pHEz4xicz/Y+mXIMp9y7oDORIDCsl3enbsgfes1qfzj2TvBGls6q0XlPTSDg7QmtXMfgYA==
X-Received: by 2002:a5d:4447:: with SMTP id x7mr15348771wrr.299.1588540257485;
        Sun, 03 May 2020 14:10:57 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id s6sm10252682wmh.17.2020.05.03.14.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 14:10:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, vlad@buslov.dev, jiri@mellanox.com,
        idosch@mellanox.com, kuba@kernel.org
Subject: [PATCH net-next 3/6] net: dsa: sja1105: make room for virtual link parsing in flower offload
Date:   Mon,  4 May 2020 00:10:32 +0300
Message-Id: <20200503211035.19363-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503211035.19363-1-olteanv@gmail.com>
References: <20200503211035.19363-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Virtual links are a sja1105 hardware concept of executing various flow
actions based on a key extracted from the frame's DMAC, VID and PCP.

Currently the tc-flower offload code supports only parsing the DMAC if
that is the broadcast MAC address, and the VLAN PCP. Extract the key
parsing logic from the L2 policers functionality and move it into its
own function, after adding extra logic for matching on any DMAC and VID.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes from RFC:
None.

 drivers/net/dsa/sja1105/sja1105.h        |  28 +++++-
 drivers/net/dsa/sja1105/sja1105_flower.c | 111 +++++++++++++++++------
 2 files changed, 112 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 602aa30c832f..95633ad9bfb7 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -97,6 +97,32 @@ struct sja1105_info {
 	const char *name;
 };
 
+enum sja1105_key_type {
+	SJA1105_KEY_BCAST,
+	SJA1105_KEY_TC,
+	SJA1105_KEY_VLAN_UNAWARE_VL,
+	SJA1105_KEY_VLAN_AWARE_VL,
+};
+
+struct sja1105_key {
+	enum sja1105_key_type type;
+
+	union {
+		/* SJA1105_KEY_TC */
+		struct {
+			int pcp;
+		} tc;
+
+		/* SJA1105_KEY_VLAN_UNAWARE_VL */
+		/* SJA1105_KEY_VLAN_AWARE_VL */
+		struct {
+			u64 dmac;
+			u16 vid;
+			u16 pcp;
+		} vl;
+	};
+};
+
 enum sja1105_rule_type {
 	SJA1105_RULE_BCAST_POLICER,
 	SJA1105_RULE_TC_POLICER,
@@ -106,6 +132,7 @@ struct sja1105_rule {
 	struct list_head list;
 	unsigned long cookie;
 	unsigned long port_mask;
+	struct sja1105_key key;
 	enum sja1105_rule_type type;
 
 	union {
@@ -117,7 +144,6 @@ struct sja1105_rule {
 		/* SJA1105_RULE_TC_POLICER */
 		struct {
 			int sharindx;
-			int tc;
 		} tc_pol;
 	};
 };
diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 5288a722e625..3246d5a49436 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -46,6 +46,7 @@ static int sja1105_setup_bcast_policer(struct sja1105_private *priv,
 		rule->cookie = cookie;
 		rule->type = SJA1105_RULE_BCAST_POLICER;
 		rule->bcast_pol.sharindx = sja1105_find_free_l2_policer(priv);
+		rule->key.type = SJA1105_KEY_BCAST;
 		new_rule = true;
 	}
 
@@ -117,7 +118,8 @@ static int sja1105_setup_tc_policer(struct sja1105_private *priv,
 		rule->cookie = cookie;
 		rule->type = SJA1105_RULE_TC_POLICER;
 		rule->tc_pol.sharindx = sja1105_find_free_l2_policer(priv);
-		rule->tc_pol.tc = tc;
+		rule->key.type = SJA1105_KEY_TC;
+		rule->key.tc.pcp = tc;
 		new_rule = true;
 	}
 
@@ -169,14 +171,37 @@ static int sja1105_setup_tc_policer(struct sja1105_private *priv,
 	return rc;
 }
 
-static int sja1105_flower_parse_policer(struct sja1105_private *priv, int port,
-					struct netlink_ext_ack *extack,
-					struct flow_cls_offload *cls,
-					u64 rate_bytes_per_sec,
-					s64 burst)
+static int sja1105_flower_policer(struct sja1105_private *priv, int port,
+				  struct netlink_ext_ack *extack,
+				  unsigned long cookie, struct sja1105_key *key,
+				  u64 rate_bytes_per_sec,
+				  s64 burst)
+{
+	switch (key->type) {
+	case SJA1105_KEY_BCAST:
+		return sja1105_setup_bcast_policer(priv, extack, cookie, port,
+						   rate_bytes_per_sec, burst);
+	case SJA1105_KEY_TC:
+		return sja1105_setup_tc_policer(priv, extack, cookie, port,
+						key->tc.pcp, rate_bytes_per_sec,
+						burst);
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Unknown keys for policing");
+		return -EOPNOTSUPP;
+	}
+}
+
+static int sja1105_flower_parse_key(struct sja1105_private *priv,
+				    struct netlink_ext_ack *extack,
+				    struct flow_cls_offload *cls,
+				    struct sja1105_key *key)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct flow_dissector *dissector = rule->match.dissector;
+	bool is_bcast_dmac = false;
+	u64 dmac = U64_MAX;
+	u16 vid = U16_MAX;
+	u16 pcp = U16_MAX;
 
 	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_BASIC) |
@@ -213,16 +238,14 @@ static int sja1105_flower_parse_policer(struct sja1105_private *priv, int port,
 			return -EOPNOTSUPP;
 		}
 
-		if (!ether_addr_equal_masked(match.key->dst, bcast,
-					     match.mask->dst)) {
+		if (!ether_addr_equal(match.mask->dst, bcast)) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Only matching on broadcast DMAC is supported");
+					   "Masked matching on MAC not supported");
 			return -EOPNOTSUPP;
 		}
 
-		return sja1105_setup_bcast_policer(priv, extack, cls->cookie,
-						   port, rate_bytes_per_sec,
-						   burst);
+		dmac = ether_addr_to_u64(match.key->dst);
+		is_bcast_dmac = ether_addr_equal(match.key->dst, bcast);
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
@@ -230,22 +253,46 @@ static int sja1105_flower_parse_policer(struct sja1105_private *priv, int port,
 
 		flow_rule_match_vlan(rule, &match);
 
-		if (match.key->vlan_id & match.mask->vlan_id) {
+		if (match.mask->vlan_id &&
+		    match.mask->vlan_id != VLAN_VID_MASK) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Matching on VID is not supported");
+					   "Masked matching on VID is not supported");
 			return -EOPNOTSUPP;
 		}
 
-		if (match.mask->vlan_priority != 0x7) {
+		if (match.mask->vlan_priority &&
+		    match.mask->vlan_priority != 0x7) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Masked matching on PCP is not supported");
 			return -EOPNOTSUPP;
 		}
 
-		return sja1105_setup_tc_policer(priv, extack, cls->cookie, port,
-						match.key->vlan_priority,
-						rate_bytes_per_sec,
-						burst);
+		if (match.mask->vlan_id)
+			vid = match.key->vlan_id;
+		if (match.mask->vlan_priority)
+			pcp = match.key->vlan_priority;
+	}
+
+	if (is_bcast_dmac && vid == U16_MAX && pcp == U16_MAX) {
+		key->type = SJA1105_KEY_BCAST;
+		return 0;
+	}
+	if (dmac == U64_MAX && vid == U16_MAX && pcp != U16_MAX) {
+		key->type = SJA1105_KEY_TC;
+		key->tc.pcp = pcp;
+		return 0;
+	}
+	if (dmac != U64_MAX && vid != U16_MAX && pcp != U16_MAX) {
+		key->type = SJA1105_KEY_VLAN_AWARE_VL;
+		key->vl.dmac = dmac;
+		key->vl.vid = vid;
+		key->vl.pcp = pcp;
+		return 0;
+	}
+	if (dmac != U64_MAX) {
+		key->type = SJA1105_KEY_VLAN_UNAWARE_VL;
+		key->vl.dmac = dmac;
+		return 0;
 	}
 
 	NL_SET_ERR_MSG_MOD(extack, "Not matching on any known key");
@@ -259,22 +306,34 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 	struct netlink_ext_ack *extack = cls->common.extack;
 	struct sja1105_private *priv = ds->priv;
 	const struct flow_action_entry *act;
-	int rc = -EOPNOTSUPP, i;
+	unsigned long cookie = cls->cookie;
+	struct sja1105_key key;
+	int rc, i;
+
+	rc = sja1105_flower_parse_key(priv, extack, cls, &key);
+	if (rc)
+		return rc;
+
+	rc = -EOPNOTSUPP;
 
 	flow_action_for_each(i, act, &rule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
-			rc = sja1105_flower_parse_policer(priv, port, extack, cls,
-							  act->police.rate_bytes_ps,
-							  act->police.burst);
+			rc = sja1105_flower_policer(priv, port,
+						    extack, cookie, &key,
+						    act->police.rate_bytes_ps,
+						    act->police.burst);
+			if (rc)
+				goto out;
 			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Action not supported");
-			break;
+			rc = -EOPNOTSUPP;
+			goto out;
 		}
 	}
-
+out:
 	return rc;
 }
 
@@ -297,7 +356,7 @@ int sja1105_cls_flower_del(struct dsa_switch *ds, int port,
 		old_sharindx = policing[bcast].sharindx;
 		policing[bcast].sharindx = port;
 	} else if (rule->type == SJA1105_RULE_TC_POLICER) {
-		int index = (port * SJA1105_NUM_TC) + rule->tc_pol.tc;
+		int index = (port * SJA1105_NUM_TC) + rule->key.tc.pcp;
 
 		old_sharindx = policing[index].sharindx;
 		policing[index].sharindx = port;
-- 
2.17.1

