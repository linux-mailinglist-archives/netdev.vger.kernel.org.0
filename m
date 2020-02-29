Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7099F174765
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 15:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgB2Obg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 09:31:36 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38543 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgB2Obd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 09:31:33 -0500
Received: by mail-wr1-f65.google.com with SMTP id t11so418278wrw.5
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 06:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CF+72A1NA3lO3JgnakxoXZ9JJ5ZN+e0ML/CgbqDNJuY=;
        b=JqJVfHfQ4XN+87cmpUkoJo7lWHqivhQ+pMr/pL3RivK1Hc1MZxcIwEM9sOJ9clau41
         jANhddi7MUzdcjJ2fVzQBEELUTRmipnfPGyU0yy5HsML+G+SMkMCf9No1j3GQb1bJKHl
         9IbPWFYuaOiPDBGT73bCc/eTnK3j/HWTWW66tJ/QvzQLbNtr1bGITnDwjYK+VWJpt5Ay
         txrYsdHxzzEVPCAYbnQqMg2Mk+EjaOZb6tJEZ1kIF+yWZAkCwye+fLHvUYkgGI+41aI0
         r4XHN6ZjjVyi8CRJFHzffxzEu9BmZkWj+8/yim3BZyWmCyTyqi2Ve8J2ThMp/sFOnWhN
         O5wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CF+72A1NA3lO3JgnakxoXZ9JJ5ZN+e0ML/CgbqDNJuY=;
        b=M5PF5HaIN084Ju70j52xyv3JHNLnzn/yoxfEG4e6/xHuB7jm32xPLxbU1i3Mq67+oN
         2QtBXysffb5nZBXE0zd/o7h2EVL19EuxddqmlRhwBZMhVmVLlx5GMdMhdznqU4pE6tGP
         JF9vypUB9uK+Ds7qP3BnWEhLLaASVUYXCs0wIe31Q9jlX3Lxg5kXjSYcHdEr+sGalh6o
         gV669IfZXUhgKHPP/8eLNl5I7xs1QNH8COlQBDXqXlb/qDh3Hbd56gB9SqnCSzhJz8Tt
         y7OgjmfbcrZBBxhOh3UmhAzPlU2KjT8LAq9Z/VfFtShCMO/CnC4WsTZwtCqhpOy6Vtaj
         ojaA==
X-Gm-Message-State: APjAAAVuT78ZnvfmRLo6Q84pgmF7qzxBtS+ySb8GRjtZBP62fC8iZHBN
        n9qBa2cXIuzbk/OkZ1cPzko=
X-Google-Smtp-Source: APXvYqx9VQGyAX4aREQuuic40XGuTQ8w/A+dPfGPib5wwY4r1ED/6o6hfPjaur7rRuLtA/15VPuZ4w==
X-Received: by 2002:adf:dd8f:: with SMTP id x15mr6405090wrl.284.1582986691860;
        Sat, 29 Feb 2020 06:31:31 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id d7sm7573528wmc.6.2020.02.29.06.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 06:31:31 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH v2 net-next 09/10] net: dsa: Add bypass operations for the flower classifier-action filter
Date:   Sat, 29 Feb 2020 16:31:13 +0200
Message-Id: <20200229143114.10656-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200229143114.10656-1-olteanv@gmail.com>
References: <20200229143114.10656-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Due to the immense variety of classification keys and actions available
for tc-flower, as well as due to potentially very different DSA switch
capabilities, it doesn't make a lot of sense for the DSA mid layer to
even attempt to interpret these. So just pass them on to the underlying
switch driver.

DSA implements just the standard boilerplate for binding and unbinding
flow blocks to ports, since nobody wants to deal with that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 include/net/dsa.h |  6 +++++
 net/dsa/slave.c   | 60 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 7d3d84f0ef42..beeb81a532e3 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -540,6 +540,12 @@ struct dsa_switch_ops {
 	/*
 	 * TC integration
 	 */
+	int	(*cls_flower_add)(struct dsa_switch *ds, int port,
+				  struct flow_cls_offload *cls, bool ingress);
+	int	(*cls_flower_del)(struct dsa_switch *ds, int port,
+				  struct flow_cls_offload *cls, bool ingress);
+	int	(*cls_flower_stats)(struct dsa_switch *ds, int port,
+				    struct flow_cls_offload *cls, bool ingress);
 	int	(*port_mirror_add)(struct dsa_switch *ds, int port,
 				   struct dsa_mall_mirror_tc_entry *mirror,
 				   bool ingress);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 088c886e609e..79d9b4384d7b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -946,6 +946,64 @@ static int dsa_slave_setup_tc_cls_matchall(struct net_device *dev,
 	}
 }
 
+static int dsa_slave_add_cls_flower(struct net_device *dev,
+				    struct flow_cls_offload *cls,
+				    bool ingress)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
+
+	if (!ds->ops->cls_flower_add)
+		return -EOPNOTSUPP;
+
+	return ds->ops->cls_flower_add(ds, port, cls, ingress);
+}
+
+static int dsa_slave_del_cls_flower(struct net_device *dev,
+				    struct flow_cls_offload *cls,
+				    bool ingress)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
+
+	if (!ds->ops->cls_flower_del)
+		return -EOPNOTSUPP;
+
+	return ds->ops->cls_flower_del(ds, port, cls, ingress);
+}
+
+static int dsa_slave_stats_cls_flower(struct net_device *dev,
+				      struct flow_cls_offload *cls,
+				      bool ingress)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
+
+	if (!ds->ops->cls_flower_stats)
+		return -EOPNOTSUPP;
+
+	return ds->ops->cls_flower_stats(ds, port, cls, ingress);
+}
+
+static int dsa_slave_setup_tc_cls_flower(struct net_device *dev,
+					 struct flow_cls_offload *cls,
+					 bool ingress)
+{
+	switch (cls->command) {
+	case FLOW_CLS_REPLACE:
+		return dsa_slave_add_cls_flower(dev, cls, ingress);
+	case FLOW_CLS_DESTROY:
+		return dsa_slave_del_cls_flower(dev, cls, ingress);
+	case FLOW_CLS_STATS:
+		return dsa_slave_stats_cls_flower(dev, cls, ingress);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int dsa_slave_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 				       void *cb_priv, bool ingress)
 {
@@ -957,6 +1015,8 @@ static int dsa_slave_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	switch (type) {
 	case TC_SETUP_CLSMATCHALL:
 		return dsa_slave_setup_tc_cls_matchall(dev, type_data, ingress);
+	case TC_SETUP_CLSFLOWER:
+		return dsa_slave_setup_tc_cls_flower(dev, type_data, ingress);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.17.1

