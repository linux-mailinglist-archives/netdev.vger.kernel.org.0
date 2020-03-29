Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13F3196D22
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgC2LwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:52:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46973 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgC2LwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:52:22 -0400
Received: by mail-wr1-f65.google.com with SMTP id j17so17434652wru.13;
        Sun, 29 Mar 2020 04:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W8WsyWCtPOeL5qDDuLwyMMGpeOtsq3R2zE86WTDb4PQ=;
        b=f2uK5hwaAkJ1oXFaaiJgVAu+MlHX6F9FwMv6+bedKSUgy17ULKGrZN/5HCKfRtsu1p
         /3I4PTGwp4AgLO1Mi+bUDd9ma8mZO+YfUPMH9ZKohy9Z/1tItKYdOVF/bMdN0a4MmD2D
         +uFBEZZvOfkVrQ702mRPdyOa+CfoQ/uIaesMNJVJ1/o49MBQuw9TuKL0OMwzKnuRCBaO
         8Dw1i2F12QpJgmCHWe5eT+bi5mNozqfae2F/1Q8Z/1ht6s9zPip0+y312gS0GUBji5z7
         l04uKWoCs60JbEQ1NhcEN8FDx8KSrMpcvnCna/qat0hLtq34BDYZljDm7wwJMsnHeRdx
         HOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W8WsyWCtPOeL5qDDuLwyMMGpeOtsq3R2zE86WTDb4PQ=;
        b=TfPg5JAMsCSu58ET0TUBpF+05VqdzGlMYqMOb84VaW6fkW31DKYjEBehrS41liNEcS
         tHJTenjWoDRc9ulAyl+9Xsx4lFNGi8v1rRI/VlDLphsSAiqFgKR3XgLjRPmjJ+J/zxAC
         s9RcsPSa46/t+iFv0jMBfjIS4iMTPLtbBliYV/RsKs6QTjHKRXM12mJryztvqX2+R7A6
         7riOUvyz3NJyIByYZtENLmreECOS2Dm2LWI29uCXMrE3CxH4ZHblN2itx4+tD8VjSEJi
         rR1TJbfXOJ5emytiJv8Kdg0bXQWGlmQE1g0IRXxbVuvxLPN4OxNeHVfxxUac+ziNwzpC
         HAYA==
X-Gm-Message-State: ANhLgQ0TchH1yJLLOFL9PVVI08brtdJi/VgKZwrvXFKWMRVSEF7IjW/I
        2PVd32Drwev3QU7e8k/wmqM=
X-Google-Smtp-Source: ADFU+vsq+gRKl5RcViH+r87NH02QIRnQWMWr+m1T/k21bR27uhFg5dZwQOf4zexf5LaddesnSf9wEw==
X-Received: by 2002:adf:efc2:: with SMTP id i2mr9335992wrp.420.1585482739046;
        Sun, 29 Mar 2020 04:52:19 -0700 (PDT)
Received: from localhost.localdomain (5-12-96-237.residential.rdsnet.ro. [5.12.96.237])
        by smtp.gmail.com with ESMTPSA id 5sm14424108wrs.20.2020.03.29.04.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 04:52:18 -0700 (PDT)
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
Subject: [PATCH v2 net-next 2/6] net: dsa: refactor matchall mirred action to separate function
Date:   Sun, 29 Mar 2020 14:51:58 +0300
Message-Id: <20200329115202.16348-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200329115202.16348-1-olteanv@gmail.com>
References: <20200329115202.16348-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Make room for other actions for the matchall filter by keeping the
mirred argument parsing self-contained in its own function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

The diff for this patch does not look amazing..

 net/dsa/slave.c | 70 ++++++++++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 30 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8ced165a7908..e6040a11bd83 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -842,24 +842,27 @@ dsa_slave_mall_tc_entry_find(struct net_device *dev, unsigned long cookie)
 	return NULL;
 }
 
-static int dsa_slave_add_cls_matchall(struct net_device *dev,
-				      struct tc_cls_matchall_offload *cls,
-				      bool ingress)
+static int
+dsa_slave_add_cls_matchall_mirred(struct net_device *dev,
+				  struct tc_cls_matchall_offload *cls,
+				  bool ingress)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_mall_mirror_tc_entry *mirror;
 	struct dsa_mall_tc_entry *mall_tc_entry;
-	__be16 protocol = cls->common.protocol;
 	struct dsa_switch *ds = dp->ds;
 	struct flow_action_entry *act;
 	struct dsa_port *to_dp;
-	int err = -EOPNOTSUPP;
+	int err;
+
+	act = &cls->rule->action.entries[0];
 
 	if (!ds->ops->port_mirror_add)
 		return err;
 
-	if (!flow_offload_has_one_action(&cls->rule->action))
-		return err;
+	if (!act->dev)
+		return -EINVAL;
 
 	if (!flow_action_basic_hw_stats_check(&cls->rule->action,
 					      cls->common.extack))
@@ -867,38 +870,45 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
 
 	act = &cls->rule->action.entries[0];
 
-	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {
-		struct dsa_mall_mirror_tc_entry *mirror;
+	if (!dsa_slave_dev_check(act->dev))
+		return -EOPNOTSUPP;
 
-		if (!act->dev)
-			return -EINVAL;
+	mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
+	if (!mall_tc_entry)
+		return -ENOMEM;
 
-		if (!dsa_slave_dev_check(act->dev))
-			return -EOPNOTSUPP;
+	mall_tc_entry->cookie = cls->cookie;
+	mall_tc_entry->type = DSA_PORT_MALL_MIRROR;
+	mirror = &mall_tc_entry->mirror;
 
-		mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
-		if (!mall_tc_entry)
-			return -ENOMEM;
+	to_dp = dsa_slave_to_port(act->dev);
 
-		mall_tc_entry->cookie = cls->cookie;
-		mall_tc_entry->type = DSA_PORT_MALL_MIRROR;
-		mirror = &mall_tc_entry->mirror;
+	mirror->to_local_port = to_dp->index;
+	mirror->ingress = ingress;
 
-		to_dp = dsa_slave_to_port(act->dev);
+	err = ds->ops->port_mirror_add(ds, dp->index, mirror, ingress);
+	if (err) {
+		kfree(mall_tc_entry);
+		return err;
+	}
 
-		mirror->to_local_port = to_dp->index;
-		mirror->ingress = ingress;
+	list_add_tail(&mall_tc_entry->list, &p->mall_tc_list);
 
-		err = ds->ops->port_mirror_add(ds, dp->index, mirror, ingress);
-		if (err) {
-			kfree(mall_tc_entry);
-			return err;
-		}
+	return err;
+}
 
-		list_add_tail(&mall_tc_entry->list, &p->mall_tc_list);
-	}
+static int dsa_slave_add_cls_matchall(struct net_device *dev,
+				      struct tc_cls_matchall_offload *cls,
+				      bool ingress)
+{
+	int err = -EOPNOTSUPP;
 
-	return 0;
+	if (cls->common.protocol == htons(ETH_P_ALL) &&
+	    flow_offload_has_one_action(&cls->rule->action) &&
+	    cls->rule->action.entries[0].id == FLOW_ACTION_MIRRED)
+		err = dsa_slave_add_cls_matchall_mirred(dev, cls, ingress);
+
+	return err;
 }
 
 static void dsa_slave_del_cls_matchall(struct net_device *dev,
-- 
2.17.1

