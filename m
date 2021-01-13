Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2C02F4F02
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbhAMPmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbhAMPma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:42:30 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BB4C061794
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:41:49 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r5so2375796eda.12
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vwWcMTMyk24+rh4c72Wp8SrfaddlvPGRdvIZGR8m/HA=;
        b=RDinLs+5ob4TSN35+xin/aFCiGd2KUe534aDOKkYiBawLm9geBZJUh/W7mPXWpMMgv
         ZWFw1DlsoShibPNiaUV1QQGQir+XPOs6btuN84HuG1DMG+lHXOrYxNydydO4h2yyzEW8
         hQClQ55Y11cb2okT4JpSgtL/EVMyqQzTOT9ERuvC9tLGm8hWlQEWo2lxVmpDDNXCA2T0
         qWtYMBBgGLz+XnMkKP3hp/8VMqShmxaCFM+s+jVRpe5PfZzKCEa0QVsKIZ3wS/VSd/vF
         HObN2fftkiZAc6FPEayG/qTUsHJ+uN6HFtz8BH1WBuSYzgchUtWNa+nw1MXVSFJii56g
         WKNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vwWcMTMyk24+rh4c72Wp8SrfaddlvPGRdvIZGR8m/HA=;
        b=boxvO+t/FvHuVSmiKT1CbDEmoIf+vo6PdZ3t6qYbgE4Txg/7X5KQMOPxq09oCYqy9O
         ZtlfqO5Zbvo6aeQUULF369AXu9cXxeaRLHLmTo+gD0sh6r1xDw9jHJGuAJogVw8hCp19
         OUkmspyr01FVtCcBKbpJkYXfqWTI2lp3C8hQV3ioUm4dR3zqKREMx65Z99ctGX821nWY
         ks7l0XSbpu3qVFPQvRRnzxmSz1cS/woo4NystrkNC4UbybqinQBgoGIfYpYW0W2F7qrl
         G+65K3fpMjJrrIueZC0c9ras8SNzc8tUtB0V2UD5upeHrZz5m/RMR2oe/Wej+9gaIRkU
         30yw==
X-Gm-Message-State: AOAM530BGS9qEZxf5NbH82Ljt8qxSfcUaLWxyr4dgJ9K69Ya3pRfZkJ8
        Sg5QKiK5DZuyjiu2m0c3dTA=
X-Google-Smtp-Source: ABdhPJwS9uhk1crnkSXTmSc4GA+ExVxGbsIJp0FA57CS+6zTfJacDirbX5v7WMGJDw1TAvkK1hUNaw==
X-Received: by 2002:a05:6402:30ac:: with SMTP id df12mr2367013edb.175.1610552507989;
        Wed, 13 Jan 2021 07:41:47 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id bn21sm852499ejb.47.2021.01.13.07.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 07:41:47 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: [RFC PATCH net-next 1/2] net: dsa: allow setting port-based QoS priority using tc matchall skbedit
Date:   Wed, 13 Jan 2021 17:41:38 +0200
Message-Id: <20210113154139.1803705-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210113154139.1803705-1-olteanv@gmail.com>
References: <20210113154139.1803705-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In Time Sensitive Networking it is a common and simple use case to
configure switches to give all traffic from an attached station the same
priority, without requiring those stations to use VLAN PCP or IP DSCP to
signal the priority that they want. Many pieces of hardware support this
feature via a port-based default priority. We can model this in Linux
through a matchall action on the ingress qdisc of the port, plus a
skbedit priority action with the desired priority.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  8 ++++++
 net/dsa/slave.c   | 72 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index c9a3dd7588df..4b774287d255 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -155,6 +155,7 @@ struct dsa_switch_tree {
 enum dsa_port_mall_action_type {
 	DSA_PORT_MALL_MIRROR,
 	DSA_PORT_MALL_POLICER,
+	DSA_PORT_MALL_SKBEDIT,
 };
 
 /* TC mirroring entry */
@@ -169,6 +170,10 @@ struct dsa_mall_policer_tc_entry {
 	u64 rate_bytes_per_sec;
 };
 
+struct dsa_mall_skbedit_tc_entry {
+	int priority;
+};
+
 /* TC matchall entry */
 struct dsa_mall_tc_entry {
 	struct list_head list;
@@ -177,6 +182,7 @@ struct dsa_mall_tc_entry {
 	union {
 		struct dsa_mall_mirror_tc_entry mirror;
 		struct dsa_mall_policer_tc_entry policer;
+		struct dsa_mall_skbedit_tc_entry skbedit;
 	};
 };
 
@@ -612,6 +618,8 @@ struct dsa_switch_ops {
 	int	(*port_policer_add)(struct dsa_switch *ds, int port,
 				    struct dsa_mall_policer_tc_entry *policer);
 	void	(*port_policer_del)(struct dsa_switch *ds, int port);
+	int	(*port_priority_set)(struct dsa_switch *ds, int port,
+				     struct dsa_mall_skbedit_tc_entry *skbedit);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type, void *type_data);
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5d7f6cada6a8..82cba26e2a8f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1018,6 +1018,66 @@ dsa_slave_add_cls_matchall_police(struct net_device *dev,
 	return err;
 }
 
+static int
+dsa_slave_add_cls_matchall_skbedit(struct net_device *dev,
+				   struct tc_cls_matchall_offload *cls,
+				   bool ingress)
+{
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_mall_skbedit_tc_entry *skbedit;
+	struct dsa_mall_tc_entry *mall_tc_entry;
+	struct dsa_switch *ds = dp->ds;
+	struct flow_action_entry *act;
+	int err;
+
+	if (!ds->ops->port_priority_set) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port priority not implemented");
+		return -EOPNOTSUPP;
+	}
+
+	if (!ingress) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only supported on ingress qdisc");
+		return -EOPNOTSUPP;
+	}
+
+	if (!flow_action_basic_hw_stats_check(&cls->rule->action,
+					      cls->common.extack))
+		return -EOPNOTSUPP;
+
+	list_for_each_entry(mall_tc_entry, &p->mall_tc_list, list) {
+		if (mall_tc_entry->type == DSA_PORT_MALL_SKBEDIT) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only one port priority allowed");
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
+	mall_tc_entry->type = DSA_PORT_MALL_SKBEDIT;
+	skbedit = &mall_tc_entry->skbedit;
+	skbedit->priority = act->priority;
+
+	err = ds->ops->port_priority_set(ds, dp->index, skbedit);
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
@@ -1031,6 +1091,9 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
 	else if (flow_offload_has_one_action(&cls->rule->action) &&
 		 cls->rule->action.entries[0].id == FLOW_ACTION_POLICE)
 		err = dsa_slave_add_cls_matchall_police(dev, cls, ingress);
+	else if (flow_offload_has_one_action(&cls->rule->action) &&
+		 cls->rule->action.entries[0].id == FLOW_ACTION_PRIORITY)
+		err = dsa_slave_add_cls_matchall_skbedit(dev, cls, ingress);
 
 	return err;
 }
@@ -1058,6 +1121,15 @@ static void dsa_slave_del_cls_matchall(struct net_device *dev,
 		if (ds->ops->port_policer_del)
 			ds->ops->port_policer_del(ds, dp->index);
 		break;
+	case DSA_PORT_MALL_SKBEDIT:
+		if (ds->ops->port_priority_set) {
+			struct dsa_mall_skbedit_tc_entry *skbedit;
+
+			skbedit = &mall_tc_entry->skbedit;
+			skbedit->priority = 0;
+			ds->ops->port_priority_set(ds, dp->index, skbedit);
+		}
+		break;
 	default:
 		WARN_ON(1);
 	}
-- 
2.25.1

