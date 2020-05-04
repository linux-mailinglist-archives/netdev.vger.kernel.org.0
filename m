Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AD91C49F2
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgEDXAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728281AbgEDXAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:00:50 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F78C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:00:49 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id r26so117071wmh.0
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SgXFNoRmWixck9stHB0XVVqohZyUP7VT6k+vlt794wc=;
        b=JpMGgj25RddMHYjKtWTiJOFci0fNT8esC0iAlV1fFjuoz5wZ0WNxUcnzeJ53Pc5IUJ
         aG1ZOgYXC/VqMCKB6IPgq6pZhBkTb6t45feDdfto57WEDzWZUjPb6IWrdiaAyH4Dzc0D
         GzGQExQh9FFLbyJRK1LxHp17Sje5P2puSAFiQ9Qx7bIwYJuA1a9OBKuN9KWV3kwW+5Se
         aZtdQ1nlslAl0UWYHR7qh0bmA9XrseK7FyJJDUV9imQlyyN1Eo7hSdfXnr+qbJaG64fq
         moX/Si1TVAdYLZC1oFIlOS9lVXsNCkKRTmR2wj4//++UelRkKxorywIYYpHnP8d8ac7f
         3jqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SgXFNoRmWixck9stHB0XVVqohZyUP7VT6k+vlt794wc=;
        b=ePYoasfq6koW+xgw/lf29593MpzEGhH7+nIUyOgKAUf7MSuGPtTEwjEL5NTxn9DUX6
         mAVJXm7BtCOZqwxKqcDntf8DDxQ5BUSpKWqDiVpoQIjQ5sCPeZBNVc/z/aZrOgZrfTBL
         NKG8jT+lCEGN+0HDE7Z9/UoUFUeVa9zYPdFa+TqTEXmkDnoZ68RsAmzPhR2mNnY6qRa5
         jQN5RwZFoAHix1/hRxriJqvActrXlY3KiGlNdHO9g8VoAD5DUTxyHVuZJhC8jVQeWLrm
         uytqpDcKq5JVrgbPnhBGzOXtV4eLlLXIVvHIUHETpg7nbGSnJ/TkgX2fg87o0da2uO5a
         rysg==
X-Gm-Message-State: AGi0PuZmjcCsZtvb6GlBxn6V2JNt5DHZpAQGtj71hVvkajZgxP0o6fsQ
        zoJstpKz8HycmAwRrods4i+4qpQ1P7Q=
X-Google-Smtp-Source: APiQypK30G/b9K80P0d4oGa6CSVcZPAPdNOprQrAqsKBaajMJIRouY0T7GJThPcf0KyipgcD8GY4bw==
X-Received: by 2002:a1c:3c54:: with SMTP id j81mr44864wma.140.1588633247919;
        Mon, 04 May 2020 16:00:47 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id r23sm15322570wra.74.2020.05.04.16.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:00:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang_1@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vlad@buslov.dev, jiri@mellanox.com, idosch@mellanox.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 3/6] net: dsa: sja1105: make room for virtual link parsing in flower offload
Date:   Tue,  5 May 2020 02:00:31 +0300
Message-Id: <20200504230034.23958-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504230034.23958-1-olteanv@gmail.com>
References: <20200504230034.23958-1-olteanv@gmail.com>
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
Changes from v1:
None.

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

