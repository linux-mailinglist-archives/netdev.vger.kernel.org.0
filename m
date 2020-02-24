Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E40E16A6FC
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgBXNJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:09:32 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42860 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727757AbgBXNJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:09:30 -0500
Received: by mail-wr1-f68.google.com with SMTP id p18so6677939wre.9
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 05:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=62H7ysUkUuExleOC5ntJZXCetDbbF/5JrioOW80ezDE=;
        b=lELHg/BrnxwZTFKGDrICrPvmrrE+8juYtuhjpyuSS+OVBx5pvLmZLla9r6MS+TYB1Q
         N5crWALkgDlrR2TPia5xzri4S+MBJROGDK1qqZyTMHW5nNxiwSEmhr7a7zHDv0CptS5+
         oLsDkOD8Cjt0b08bZIc8cHCBNIlMh3j4DAra4OG7xVY0ZybkRTWfKoSeJ0NxcpLagSG4
         39f4WV2xwXAa/YNiDN4brz219ghoLyV/v79vJYjtdYBlcIbxEPxRkebH5zoxIWKQWTGN
         3G8ZuJgDo0tCXbrbEui/HzGWaqRge8AwwV3gvP3165iEM53DNVxwED1gIhdOx0Dd6wG/
         iStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=62H7ysUkUuExleOC5ntJZXCetDbbF/5JrioOW80ezDE=;
        b=jNEhvaknKgICBlFdAF2oMzK98sHxck7quA9n+Is/TI9s5GjHcqCwWUBI3V2SBg44i0
         1wzCa6nsjM2euN6S3Fc8hsKDCNZ2zGsRPhoLA4R3YprenSYT3M06hkvKOBJubJEVpc0x
         odi6stLyIK5KbSUMC5ml3lSPpPmr0PrEtI1KDBxACgIn3mQt2AYPWy57APgTDPfJqbSx
         dASeGKxUv8j2VuzFMQMtvIt5XwimeBgCalNS3dynSPTp6Pf6gc/cK2GqqU/4FfU38Bll
         FibrBTyiBekRZ1kev5CQeX6JhAqyUOG5+jmv6YsvuLjkgy/ooNUPV05BzJUDcH1BTNwC
         G1JQ==
X-Gm-Message-State: APjAAAV7CLWZ7keECksWLddGV1oZ2o+5dDOnqwKokVK+zFWLn6GWjQC2
        jRckP2l/+y+63N0SdlZ32BM=
X-Google-Smtp-Source: APXvYqxkYtLlob/pczfxeVwIlWzy3SoMOsTghnCm4Qxn6yG+dtmmIm1FPrVXJmQ8liyOh9/HL9gEqw==
X-Received: by 2002:adf:e401:: with SMTP id g1mr11172842wrm.165.1582549768956;
        Mon, 24 Feb 2020 05:09:28 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id i204sm18089298wma.44.2020.02.24.05.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:09:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH net-next 09/10] net: dsa: Add bypass operations for the flower classifier-action filter
Date:   Mon, 24 Feb 2020 15:08:30 +0200
Message-Id: <20200224130831.25347-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224130831.25347-1-olteanv@gmail.com>
References: <20200224130831.25347-1-olteanv@gmail.com>
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
 include/net/dsa.h |  6 +++++
 net/dsa/slave.c   | 60 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 63495e3443ac..6cb87f037120 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -538,6 +538,12 @@ struct dsa_switch_ops {
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
index 8cd28e88431e..5f07f1ca91a9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -954,6 +954,64 @@ static int dsa_slave_setup_tc_cls_matchall(struct net_device *dev,
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
@@ -965,6 +1023,8 @@ static int dsa_slave_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
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

