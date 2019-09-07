Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD02AC921
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 22:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436719AbfIGUBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 16:01:23 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33936 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436710AbfIGUBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 16:01:21 -0400
Received: by mail-qt1-f193.google.com with SMTP id a13so11329147qtj.1
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 13:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VHWqLWNYbQSjJEbZH3NQJfj6PtoD6ad0zgoLKUQj7Qk=;
        b=PSEitL7ngcQwVftZX6XTE6ApKx2Ugm1Vb0OtFmAPEdHl9qx6fXnXXXl/YnqJyYbZWe
         cCNCsyw0Wuen48eVkYs4f1KhVr2sQM74vlMcR4Rw9pP7Y3PkX3TBXzVuso3EPLC9pbq3
         1L4iA0JOLhnYnRmbpT0mUCebQ/PHBFpuzDRMVsGuC3oXEJzdaOLvVF6RCBs2wZ6VoaXm
         XQKNTx4Riw7S5889ntKFO9pQIN7zwzjUJaBPWlCmsSRPYQ6bnDbdIoR8cka6hoiWUqJ2
         pH6i5ERxC3y+gtj8vCXC8ocHAIo0cq+xir3xg2TaeRJruCeL0w5dFYuP6xpcsw++rmO5
         0hLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VHWqLWNYbQSjJEbZH3NQJfj6PtoD6ad0zgoLKUQj7Qk=;
        b=rbEHJ9xJaW5crCPaRTRZXsh4sUmq0XSzqdl9MsUTiwn8Kjw8Y1wSyV2LBek5LBc4cI
         J59vn9BfjS2Bso5XYnsncneVVs9fAKEp7OAHH8yTQuyGORtYgiNagonWJ6F2DTJc5LB4
         13WQ7PB6hgWs9bEzpSrbC/pyHQBUQjxpwjdxBUcJOshE58/Q4C66yLJR8UeEdWSK5R4Q
         cqlJDb0nxncU4fCmF0C7U0WY7qctZ8YTpiNa/58t6lmhJpk+HaiHgDgko1PqrA1DoAqD
         fOpaJff5ed7PlcxU32l1mEZA6pbupbcHmLeNK9ygahiAKtUdUDsppbOEffzLk7D+huxB
         4hmw==
X-Gm-Message-State: APjAAAXm3xF3TH1F8OgPJMPgpg9VYognmb/KS0Y2c4iuPh+L2q9sHCN1
        IjEqJcpK4ZoEApa0gb1+vIL2gby1
X-Google-Smtp-Source: APXvYqxVr+dBX515AfzwLbsM1hU9yTt1d1IFuosPFH2jRWMfDKrO7WZLWxDta2oK3MR2amxXCsGV2Q==
X-Received: by 2002:ac8:149a:: with SMTP id l26mr15805268qtj.267.1567886480477;
        Sat, 07 Sep 2019 13:01:20 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b4sm4484538qkd.121.2019.09.07.13.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 13:01:19 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 3/3] net: dsa: mv88e6xxx: add RXNFC support
Date:   Sat,  7 Sep 2019 16:00:49 -0400
Message-Id: <20190907200049.25273-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190907200049.25273-1-vivien.didelot@gmail.com>
References: <20190907200049.25273-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the .get_rxnfc and .set_rxnfc DSA operations to configure
a port's Layer 2 Policy Control List (PCL) via ethtool.

Currently only dropping frames based on MAC Destination or Source
Address (including the option VLAN parameter) is supported.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 213 +++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  13 ++
 2 files changed, 226 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6f4d5303a1f3..6787d560e9e3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1524,6 +1524,216 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_g1_atu_loadpurge(chip, fid, &entry);
 }
 
+static int mv88e6xxx_policy_apply(struct mv88e6xxx_chip *chip, int port,
+				  const struct mv88e6xxx_policy *policy)
+{
+	enum mv88e6xxx_policy_mapping mapping = policy->mapping;
+	enum mv88e6xxx_policy_action action = policy->action;
+	const u8 *addr = policy->addr;
+	u16 vid = policy->vid;
+	u8 state;
+	int err;
+	int id;
+
+	if (!chip->info->ops->port_set_policy)
+		return -EOPNOTSUPP;
+
+	switch (mapping) {
+	case MV88E6XXX_POLICY_MAPPING_DA:
+	case MV88E6XXX_POLICY_MAPPING_SA:
+		if (action == MV88E6XXX_POLICY_ACTION_NORMAL)
+			state = 0; /* Dissociate the port and address */
+		else if (action == MV88E6XXX_POLICY_ACTION_DISCARD &&
+			 is_multicast_ether_addr(addr))
+			state = MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_POLICY;
+		else if (action == MV88E6XXX_POLICY_ACTION_DISCARD &&
+			 is_unicast_ether_addr(addr))
+			state = MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_POLICY;
+		else
+			return -EOPNOTSUPP;
+
+		err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid,
+						   state);
+		if (err)
+			return err;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	/* Skip the port's policy clearing if the mapping is still in use */
+	if (action == MV88E6XXX_POLICY_ACTION_NORMAL)
+		idr_for_each_entry(&chip->policies, policy, id)
+			if (policy->port == port &&
+			    policy->mapping == mapping &&
+			    policy->action != action)
+				return 0;
+
+	return chip->info->ops->port_set_policy(chip, port, mapping, action);
+}
+
+static int mv88e6xxx_policy_insert(struct mv88e6xxx_chip *chip, int port,
+				   struct ethtool_rx_flow_spec *fs)
+{
+	struct ethhdr *mac_entry = &fs->h_u.ether_spec;
+	struct ethhdr *mac_mask = &fs->m_u.ether_spec;
+	enum mv88e6xxx_policy_mapping mapping;
+	enum mv88e6xxx_policy_action action;
+	struct mv88e6xxx_policy *policy;
+	u16 vid = 0;
+	u8 *addr;
+	int err;
+	int id;
+
+	if (fs->location != RX_CLS_LOC_ANY)
+		return -EINVAL;
+
+	if (fs->ring_cookie == RX_CLS_FLOW_DISC)
+		action = MV88E6XXX_POLICY_ACTION_DISCARD;
+	else
+		return -EOPNOTSUPP;
+
+	switch (fs->flow_type & ~FLOW_EXT) {
+	case ETHER_FLOW:
+		if (!is_zero_ether_addr(mac_mask->h_dest) &&
+		    is_zero_ether_addr(mac_mask->h_source)) {
+			mapping = MV88E6XXX_POLICY_MAPPING_DA;
+			addr = mac_entry->h_dest;
+		} else if (is_zero_ether_addr(mac_mask->h_dest) &&
+		    !is_zero_ether_addr(mac_mask->h_source)) {
+			mapping = MV88E6XXX_POLICY_MAPPING_SA;
+			addr = mac_entry->h_source;
+		} else {
+			/* Cannot support DA and SA mapping in the same rule */
+			return -EOPNOTSUPP;
+		}
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if ((fs->flow_type & FLOW_EXT) && fs->m_ext.vlan_tci) {
+		if (fs->m_ext.vlan_tci != 0xffff)
+			return -EOPNOTSUPP;
+		vid = be16_to_cpu(fs->h_ext.vlan_tci) & VLAN_VID_MASK;
+	}
+
+	idr_for_each_entry(&chip->policies, policy, id) {
+		if (policy->port == port && policy->mapping == mapping &&
+		    policy->action == action && policy->vid == vid &&
+		    ether_addr_equal(policy->addr, addr))
+			return -EEXIST;
+	}
+
+	policy = devm_kzalloc(chip->dev, sizeof(*policy), GFP_KERNEL);
+	if (!policy)
+		return -ENOMEM;
+
+	fs->location = 0;
+	err = idr_alloc_u32(&chip->policies, policy, &fs->location, 0xffffffff,
+			    GFP_KERNEL);
+	if (err) {
+		devm_kfree(chip->dev, policy);
+		return err;
+	}
+
+	memcpy(&policy->fs, fs, sizeof(*fs));
+	ether_addr_copy(policy->addr, addr);
+	policy->mapping = mapping;
+	policy->action = action;
+	policy->port = port;
+	policy->vid = vid;
+
+	err = mv88e6xxx_policy_apply(chip, port, policy);
+	if (err) {
+		idr_remove(&chip->policies, fs->location);
+		devm_kfree(chip->dev, policy);
+		return err;
+	}
+
+	return 0;
+}
+
+static int mv88e6xxx_get_rxnfc(struct dsa_switch *ds, int port,
+			       struct ethtool_rxnfc *rxnfc, u32 *rule_locs)
+{
+	struct ethtool_rx_flow_spec *fs = &rxnfc->fs;
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_policy *policy;
+	int err;
+	int id;
+
+	mv88e6xxx_reg_lock(chip);
+
+	switch (rxnfc->cmd) {
+	case ETHTOOL_GRXCLSRLCNT:
+		rxnfc->data = 0;
+		rxnfc->data |= RX_CLS_LOC_SPECIAL;
+		rxnfc->rule_cnt = 0;
+		idr_for_each_entry(&chip->policies, policy, id)
+			if (policy->port == port)
+				rxnfc->rule_cnt++;
+		err = 0;
+		break;
+	case ETHTOOL_GRXCLSRULE:
+		err = -ENOENT;
+		policy = idr_find(&chip->policies, fs->location);
+		if (policy) {
+			memcpy(fs, &policy->fs, sizeof(*fs));
+			err = 0;
+		}
+		break;
+	case ETHTOOL_GRXCLSRLALL:
+		rxnfc->data = 0;
+		rxnfc->rule_cnt = 0;
+		idr_for_each_entry(&chip->policies, policy, id)
+			if (policy->port == port)
+				rule_locs[rxnfc->rule_cnt++] = id;
+		err = 0;
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
+static int mv88e6xxx_set_rxnfc(struct dsa_switch *ds, int port,
+			       struct ethtool_rxnfc *rxnfc)
+{
+	struct ethtool_rx_flow_spec *fs = &rxnfc->fs;
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_policy *policy;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+
+	switch (rxnfc->cmd) {
+	case ETHTOOL_SRXCLSRLINS:
+		err = mv88e6xxx_policy_insert(chip, port, fs);
+		break;
+	case ETHTOOL_SRXCLSRLDEL:
+		err = -ENOENT;
+		policy = idr_remove(&chip->policies, fs->location);
+		if (policy) {
+			policy->action = MV88E6XXX_POLICY_ACTION_NORMAL;
+			err = mv88e6xxx_policy_apply(chip, port, policy);
+			devm_kfree(chip->dev, policy);
+		}
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
 static int mv88e6xxx_port_add_broadcast(struct mv88e6xxx_chip *chip, int port,
 					u16 vid)
 {
@@ -4655,6 +4865,7 @@ static struct mv88e6xxx_chip *mv88e6xxx_alloc_chip(struct device *dev)
 
 	mutex_init(&chip->reg_lock);
 	INIT_LIST_HEAD(&chip->mdios);
+	idr_init(&chip->policies);
 
 	return chip;
 }
@@ -4739,6 +4950,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.set_eeprom		= mv88e6xxx_set_eeprom,
 	.get_regs_len		= mv88e6xxx_get_regs_len,
 	.get_regs		= mv88e6xxx_get_regs,
+	.get_rxnfc		= mv88e6xxx_get_rxnfc,
+	.set_rxnfc		= mv88e6xxx_set_rxnfc,
 	.set_ageing_time	= mv88e6xxx_set_ageing_time,
 	.port_bridge_join	= mv88e6xxx_port_bridge_join,
 	.port_bridge_leave	= mv88e6xxx_port_bridge_leave,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 04a329a98158..e9b1a1ac9a8e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -8,6 +8,7 @@
 #ifndef _MV88E6XXX_CHIP_H
 #define _MV88E6XXX_CHIP_H
 
+#include <linux/idr.h>
 #include <linux/if_vlan.h>
 #include <linux/irq.h>
 #include <linux/gpio/consumer.h>
@@ -207,6 +208,15 @@ enum mv88e6xxx_policy_action {
 	MV88E6XXX_POLICY_ACTION_DISCARD,
 };
 
+struct mv88e6xxx_policy {
+	enum mv88e6xxx_policy_mapping mapping;
+	enum mv88e6xxx_policy_action action;
+	struct ethtool_rx_flow_spec fs;
+	u8 addr[ETH_ALEN];
+	int port;
+	u16 vid;
+};
+
 struct mv88e6xxx_port {
 	struct mv88e6xxx_chip *chip;
 	int port;
@@ -265,6 +275,9 @@ struct mv88e6xxx_chip {
 	/* List of mdio busses */
 	struct list_head mdios;
 
+	/* Policy Control List IDs and rules */
+	struct idr policies;
+
 	/* There can be two interrupt controllers, which are chained
 	 * off a GPIO as interrupt source
 	 */
-- 
2.23.0

