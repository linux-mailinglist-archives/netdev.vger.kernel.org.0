Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C59D196A74
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 01:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgC2AxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 20:53:06 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40419 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbgC2AxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 20:53:06 -0400
Received: by mail-wm1-f67.google.com with SMTP id a81so17165889wmf.5;
        Sat, 28 Mar 2020 17:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YBK8RiOpgGzr1OscuGx7qp2rLPh/wW8dimuyWNZJk5E=;
        b=sgQcGJDB0rhZIeLJ1pO9ttydCABPZm7wbUvOa1VDtl+XcLIqbPCIstT/DNIXprSy6u
         5iBrs8TKUHHc6Ha8Sg86BjcgZrYuhO5LuzM7KspjUAyA6vyBL1Dbap1irsL7K4LehAwN
         sI4laFD28L8DRXjkABI8zN/BHi90SCgDnu6PtaCEd0J3WUfM0r51yNOMVyMwt0Z2jiFQ
         gADTNHPkLFcQFRnhnXhry5GHLH5BkxsR3/2CWJXlO48Rts5mvHjhWlnJdpmIgo7TfznH
         db/IEc1MN6EvUy30bCIrCnBqkp94rcaObUSZFc7vAqtbw32S2hLkapQuneEjRyfugzeT
         htKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YBK8RiOpgGzr1OscuGx7qp2rLPh/wW8dimuyWNZJk5E=;
        b=bkX1oGshrQjF4wBpp3tOj8gIeau4wdHjf3s4g1CJrkSTGw/N4QJ5Ws6roEl1GR5FsI
         qsqNXGPHGG17nS9vjHFv6ZDHrQlBoJ0SgYjBUL3jOhmguUcJGodYajl1jsXfRipyyChj
         FTtk2HhwwsqcRu4xC08Zb0NDGbKepvIrfeO92DIwTyDbdrxcpCmtK6Z8rYBVFPXvUpqC
         2IGzCKWjO7TIhfBPLxTVzX67v8RxZn42MhwBSEEkVN68GRw7eMN5anv6w0hnzLy5o4Zs
         bA7C04VCUlEdJg30AYSrRwDfWv9ScnMuL6xVjOjmPiXUYZt2xnpm9oFh2CL0XuWV8h/X
         VijQ==
X-Gm-Message-State: ANhLgQ2lkzzcZMzzjANIOqnDW/GH9EUAJwLMAEADLhfgORRxJm0bxuKX
        AMPmgBZTNsM/Hqu9U2Wy8FqY+WSyEziTp1+D
X-Google-Smtp-Source: ADFU+vuRYOlu3HH+Xn0GbNrMtH36SYitmTrsrZdfeRry6LeDjttlQkW4gvOzuGkQvTayEC+QUynVPQ==
X-Received: by 2002:a7b:c3c1:: with SMTP id t1mr5866719wmj.17.1585443184051;
        Sat, 28 Mar 2020 17:53:04 -0700 (PDT)
Received: from localhost.localdomain (5-12-96-237.residential.rdsnet.ro. [5.12.96.237])
        by smtp.gmail.com with ESMTPSA id l1sm8292652wme.14.2020.03.28.17.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 17:53:03 -0700 (PDT)
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
Subject: [PATCH net-next 2/6] net: dsa: refactor matchall mirred action to separate function
Date:   Sun, 29 Mar 2020 02:51:58 +0200
Message-Id: <20200329005202.17926-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200329005202.17926-1-olteanv@gmail.com>
References: <20200329005202.17926-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Make room for other actions for the matchall filter by keeping the
mirred argument parsing self-contained in its own function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

