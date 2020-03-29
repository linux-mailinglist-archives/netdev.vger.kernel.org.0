Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4BF196A72
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 01:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgC2AxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 20:53:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38142 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727799AbgC2AxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 20:53:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id f6so10579095wmj.3;
        Sat, 28 Mar 2020 17:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E7oIGTj6GfoqLrMS12mWuCCLdpEMZGxznqyF5gEoRek=;
        b=TxISylqW1G6ZK3gDULFg8AYbJnE66axqDcAxM4kwsnZOYBkRJFbgbynD9fWEcwNX0k
         JrOzKYQnqpE0sET0b6xk9M4FU4ffOjTvP0Yf0gvK36g5xhX6pz7WdiuG8nd21k3vJ4FA
         aoy1Q0YR10d5avJ0j7LjpSA34mXzCUi70hIclD7o8WauvXo044UEXkCrKoc/Mn/ky5e2
         nXBeepFqi9fwnXqYU6tBK/BfHS31WUr3wydOstSlyiCiF3iF3uj0dFk+YMs8NSbIukWe
         AbG5tjLuhk7abCQYgOSMoctnKVrRtHTfiq9TtHqQAeqHvGLnJhNMURTax7rlcmqzGk8X
         zsww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E7oIGTj6GfoqLrMS12mWuCCLdpEMZGxznqyF5gEoRek=;
        b=A0sMT5R/rB9mPl/kCsPbY0qxNnXZOL26lpqt2He50ZNW2xgLWlgW+//p+E1sDAI1Cv
         FMHoYkJ6wiyHgTm+xWYFoOqH4NT8wV7qzyF87p/InyZBSaG58HmySaiKJqfJQOxyc5NM
         lnikGbh7QJDrJznpxQnGEhhJ2k5Jc2y9mSTU5LT0POp9iqvb31+B5dLib4YplXJ0E50V
         /6zVrH7SryE1Bly4AV4VoM4b7GsxsO/4nzL9eGc5EZo48IxE83snF1gzjxCfuNUQGcXb
         Oe3WwJzzT2BNaaDQbV8cwK60FiIi9blGv70odRQPRjXs4B9m+0g1xvK/JbUzQjoM3Yvg
         vPhA==
X-Gm-Message-State: ANhLgQ2DBQKoRIoKmk0xzJwNnYGcvTLNsMZNXwSTwjymb0ERaxyPuu41
        M/HbH+Ad33MABzr9cweWh7UFNXDBNdXuakuR
X-Google-Smtp-Source: ADFU+vvXnwaJlvYUg7Vt8F3iDIAxYYqw+wTxSEQj/yIpmkjEaxycEwn5nxkgJDxM2xav4oCxCvLcpQ==
X-Received: by 2002:a1c:dd8b:: with SMTP id u133mr5702479wmg.109.1585443185474;
        Sat, 28 Mar 2020 17:53:05 -0700 (PDT)
Received: from localhost.localdomain (5-12-96-237.residential.rdsnet.ro. [5.12.96.237])
        by smtp.gmail.com with ESMTPSA id l1sm8292652wme.14.2020.03.28.17.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 17:53:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, xiaoliang.yang_1@nxp.com,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        yangbo.lu@nxp.com, alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, leoyang.li@nxp.com
Subject: [PATCH net-next 3/6] net: dsa: add port policers
Date:   Sun, 29 Mar 2020 02:51:59 +0200
Message-Id: <20200329005202.17926-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200329005202.17926-1-olteanv@gmail.com>
References: <20200329005202.17926-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The approach taken to pass the port policer methods on to drivers is
pragmatic. It is similar to the port mirroring implementation (in that
the DSA core does all of the filter block interaction and only passes
simple operations for the driver to implement) and dissimilar to how
flow-based policers are going to be implemented (where the driver has
full control over the flow_cls_offload data structure).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 13 +++++++-
 net/dsa/slave.c   | 79 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 85 insertions(+), 7 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index aeb411e77b9a..fb3f9222f2a1 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -130,9 +130,10 @@ struct dsa_switch_tree {
 	struct list_head rtable;
 };
 
-/* TC matchall action types, only mirroring for now */
+/* TC matchall action types */
 enum dsa_port_mall_action_type {
 	DSA_PORT_MALL_MIRROR,
+	DSA_PORT_MALL_POLICER,
 };
 
 /* TC mirroring entry */
@@ -141,6 +142,12 @@ struct dsa_mall_mirror_tc_entry {
 	bool ingress;
 };
 
+/* TC port policer entry */
+struct dsa_mall_policer_tc_entry {
+	s64 burst;
+	u64 rate_bytes_per_sec;
+};
+
 /* TC matchall entry */
 struct dsa_mall_tc_entry {
 	struct list_head list;
@@ -148,6 +155,7 @@ struct dsa_mall_tc_entry {
 	enum dsa_port_mall_action_type type;
 	union {
 		struct dsa_mall_mirror_tc_entry mirror;
+		struct dsa_mall_policer_tc_entry policer;
 	};
 };
 
@@ -557,6 +565,9 @@ struct dsa_switch_ops {
 				   bool ingress);
 	void	(*port_mirror_del)(struct dsa_switch *ds, int port,
 				   struct dsa_mall_mirror_tc_entry *mirror);
+	int	(*port_policer_add)(struct dsa_switch *ds, int port,
+				    struct dsa_mall_policer_tc_entry *policer);
+	void	(*port_policer_del)(struct dsa_switch *ds, int port);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type, void *type_data);
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e6040a11bd83..9692a726f2ed 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -859,14 +859,14 @@ dsa_slave_add_cls_matchall_mirred(struct net_device *dev,
 	act = &cls->rule->action.entries[0];
 
 	if (!ds->ops->port_mirror_add)
-		return err;
+		return -EOPNOTSUPP;
 
 	if (!act->dev)
 		return -EINVAL;
 
 	if (!flow_action_basic_hw_stats_check(&cls->rule->action,
 					      cls->common.extack))
-		return err;
+		return -EOPNOTSUPP;
 
 	act = &cls->rule->action.entries[0];
 
@@ -897,6 +897,67 @@ dsa_slave_add_cls_matchall_mirred(struct net_device *dev,
 	return err;
 }
 
+static int
+dsa_slave_add_cls_matchall_police(struct net_device *dev,
+				  struct tc_cls_matchall_offload *cls,
+				  bool ingress)
+{
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_mall_policer_tc_entry *policer;
+	struct dsa_mall_tc_entry *mall_tc_entry;
+	struct dsa_switch *ds = dp->ds;
+	struct flow_action_entry *act;
+	int err;
+
+	if (!ds->ops->port_policer_add) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Policing offload not implemented\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (!ingress) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only supported on ingress qdisc\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (!flow_action_basic_hw_stats_check(&cls->rule->action,
+					      cls->common.extack))
+		return -EOPNOTSUPP;
+
+	list_for_each_entry(mall_tc_entry, &p->mall_tc_list, list) {
+		if (mall_tc_entry->type == DSA_PORT_MALL_POLICER) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only one port policer allowed\n");
+			return -EEXIST;
+		}
+	}
+
+	act = &cls->rule->action.entries[0];
+
+	mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
+	if (!mall_tc_entry)
+		return -ENOMEM;
+
+	mall_tc_entry->cookie = cls->cookie;
+	mall_tc_entry->type = DSA_PORT_MALL_POLICER;
+	policer = &mall_tc_entry->policer;
+	policer->rate_bytes_per_sec = act->police.rate_bytes_ps;
+	policer->burst = act->police.burst;
+
+	err = ds->ops->port_policer_add(ds, dp->index, policer);
+	if (err) {
+		kfree(mall_tc_entry);
+		return err;
+	}
+
+	list_add_tail(&mall_tc_entry->list, &p->mall_tc_list);
+
+	return err;
+}
+
 static int dsa_slave_add_cls_matchall(struct net_device *dev,
 				      struct tc_cls_matchall_offload *cls,
 				      bool ingress)
@@ -907,6 +968,9 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
 	    flow_offload_has_one_action(&cls->rule->action) &&
 	    cls->rule->action.entries[0].id == FLOW_ACTION_MIRRED)
 		err = dsa_slave_add_cls_matchall_mirred(dev, cls, ingress);
+	else if (flow_offload_has_one_action(&cls->rule->action) &&
+		 cls->rule->action.entries[0].id == FLOW_ACTION_POLICE)
+		err = dsa_slave_add_cls_matchall_police(dev, cls, ingress);
 
 	return err;
 }
@@ -918,9 +982,6 @@ static void dsa_slave_del_cls_matchall(struct net_device *dev,
 	struct dsa_mall_tc_entry *mall_tc_entry;
 	struct dsa_switch *ds = dp->ds;
 
-	if (!ds->ops->port_mirror_del)
-		return;
-
 	mall_tc_entry = dsa_slave_mall_tc_entry_find(dev, cls->cookie);
 	if (!mall_tc_entry)
 		return;
@@ -929,7 +990,13 @@ static void dsa_slave_del_cls_matchall(struct net_device *dev,
 
 	switch (mall_tc_entry->type) {
 	case DSA_PORT_MALL_MIRROR:
-		ds->ops->port_mirror_del(ds, dp->index, &mall_tc_entry->mirror);
+		if (ds->ops->port_mirror_del)
+			ds->ops->port_mirror_del(ds, dp->index,
+						 &mall_tc_entry->mirror);
+		break;
+	case DSA_PORT_MALL_POLICER:
+		if (ds->ops->port_policer_del)
+			ds->ops->port_policer_del(ds, dp->index);
 		break;
 	default:
 		WARN_ON(1);
-- 
2.17.1

