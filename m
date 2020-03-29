Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7B7196D27
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgC2Lwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:52:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42988 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728160AbgC2LwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:52:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id h15so17476775wrx.9;
        Sun, 29 Mar 2020 04:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2XJQ3tgHhWD6ivUtosaqB5/lO5MxYh8VnUo0/RYkqJg=;
        b=mlQ62uxT9F1ckMjw/2Ns9Q4WN9FaPjxHXDieI4oFLKWS5CxxG1iv/ao3zzTGZ33p1a
         vA1sw70U36UVLJsQl/4wcDg695Wi5v/0mlDhYLCkD5K0gno0K3ehF47VI7A60PAw5Nz2
         3H+3feaBkryw5/8i8aBh7X1IsOi4MyeYiFvW0rQhHy3egLg2WK+IRzg2WSP9jiV/fn83
         XZlbsmAhvQ15VbfngmLx39JPb7Bw9vd4bPIQU+1iGM9MGcJeOsQ1D8RcOCSj0S8apy4P
         oYh1eLDeVeVZtVc25Kbc0uxcYZVUxvRgeUgzA76VmLiF6/z6AmAzt6ogKnynzzG95HTy
         wdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2XJQ3tgHhWD6ivUtosaqB5/lO5MxYh8VnUo0/RYkqJg=;
        b=D42QBGq9sbA4lmKQ64LzehpoIJ1BJKHglPmVFJdwNmkgrsop2aIpniaCO7NqfciRS9
         zuV2bXC3aiMAsEW0uZu57cJqIWkmGki9XuSbQhS7SiRK0659A7hlQigFe8dUQ9aXfSAf
         sOfo9wM/gdKGSW5YKWgA1hvbh911xHkL1ncOjQkVPE8AtDE3lVDXYRKQTAdNvxRm1XpF
         8JA80IC4FBzPifF4lWOVDETz1DPROcBhPP6mZUTjCg8oK44QyYbZ8ieHaJ8pCoABXuWo
         nq+tMUiFuL1pq6sPS1JlM3uN5gFn3oil9Hz3rYW9RsGBuUfvOSyOoO6K/6efsh9L5NR8
         wRxQ==
X-Gm-Message-State: ANhLgQ06j1lYsrE3cXQ96eOJpMAdaPT1B1wRcjWxxMwdraxBfSAQvX3L
        2P67bj6aNxLidTrtu2Fb9lA=
X-Google-Smtp-Source: ADFU+vvdd3RYlP4hgCRjRV+pY89v0AVvzARAkTT2ovUW2xjwt3RzEEzkicl40takmRDg32AHX63M3w==
X-Received: by 2002:adf:dc4f:: with SMTP id m15mr10209603wrj.219.1585482740947;
        Sun, 29 Mar 2020 04:52:20 -0700 (PDT)
Received: from localhost.localdomain (5-12-96-237.residential.rdsnet.ro. [5.12.96.237])
        by smtp.gmail.com with ESMTPSA id 5sm14424108wrs.20.2020.03.29.04.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 04:52:20 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, xiaoliang.yang_1@nxp.com,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        yangbo.lu@nxp.com, alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH v2 net-next 3/6] net: dsa: add port policers
Date:   Sun, 29 Mar 2020 14:51:59 +0300
Message-Id: <20200329115202.16348-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200329115202.16348-1-olteanv@gmail.com>
References: <20200329115202.16348-1-olteanv@gmail.com>
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
Changes in v2:
None.

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

