Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD6316A6FB
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgBXNJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:09:30 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33194 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbgBXNJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:09:29 -0500
Received: by mail-wr1-f66.google.com with SMTP id u6so10346395wrt.0
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 05:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yzlNYOSv03WWOjBTQyAM0nDGMHoQBEREp6E2fkjx7O8=;
        b=grnRqVjYho8+FQ1iV6agwCpE5FpMf0gsv5XMw7vdz+2/3Tk2qWhgqM5rFrEIuQ2D8R
         QOq9JGz15mXqXkVPQ4fsELSSZ+fJKOLpMZHdRcAetxqf0eE+P+hXptWvnC2E5yPZwUmI
         M5CQbtTVvnYUKQBofsWZzvbja0dCnhP9bZVrmaBWYve3wPpM2w/wTUgts+rg66tWdgUy
         o6FPcWvpcHbQSKCxOddscgQ39kS/claBdSZVxhcJqi8tiw6XcP0VD+18+Nz5OA7l+cfB
         nJxcuhpmg9Z04FL6zKsH14dnEr7HwiIXnXL1QagXHWuNqOBW2DiLvgfVJ687d+3Xkz/g
         ZWsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yzlNYOSv03WWOjBTQyAM0nDGMHoQBEREp6E2fkjx7O8=;
        b=gTZxSlMw39WaphKaG+1qbkNxDhxMz3zNd/Q8O+M9fqTZ3VJcy8MEbDOPGBBL6LkLK2
         3nFfoLbVC7as0nCZUX1kv8IhmAlPFc8QtnRvpQFz0lkiqJV00nQVFbsGPmEBzku1ZdhR
         8ykIzPQxk8eBwlhH5pmWlhrTEseWnhgWN8n1a6DScj9LJ236uHf6I1wJNye2oo8Kr2LT
         7P6UDEEik5BlYsyuyobBaLamJwh5mqrC5A/p7ZdrfME9HqsqhgLO75ErpgUWfkrCZZjl
         KMUf2jaDXBNNcpi6oLAVpkMGigDBg303e7+JG9UUDms+rtmai0lJcJOsf/wUJ9QNtg1k
         3G7Q==
X-Gm-Message-State: APjAAAXDfHka3JRkz+WlvdDWPJucsFXHXPqdOYrooQypfhfnv+TtUFsB
        p58xVHGKvvYFGXsCgseDh9o=
X-Google-Smtp-Source: APXvYqwetHRqP3hhzzG9Dbbn7cSMs54q0osthpu8cWprJMWaHa+8WYycMYfJ2/BlqNW/a2BQbw/uuw==
X-Received: by 2002:a5d:628e:: with SMTP id k14mr4383440wru.425.1582549767580;
        Mon, 24 Feb 2020 05:09:27 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id i204sm18089298wma.44.2020.02.24.05.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:09:27 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH net-next 08/10] net: dsa: Refactor matchall mirred action to separate function
Date:   Mon, 24 Feb 2020 15:08:29 +0200
Message-Id: <20200224130831.25347-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224130831.25347-1-olteanv@gmail.com>
References: <20200224130831.25347-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Make room for other actions for the matchall filter by keeping the
mirred argument parsing self-contained in its own function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 68 +++++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 088c886e609e..8cd28e88431e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -846,57 +846,65 @@ dsa_slave_mall_tc_entry_find(struct net_device *dev, unsigned long cookie)
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
 
-	act = &cls->rule->action.entries[0];
+	if (!dsa_slave_dev_check(act->dev))
+		return -EOPNOTSUPP;
 
-	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {
-		struct dsa_mall_mirror_tc_entry *mirror;
+	mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
+	if (!mall_tc_entry)
+		return -ENOMEM;
 
-		if (!act->dev)
-			return -EINVAL;
+	mall_tc_entry->cookie = cls->cookie;
+	mall_tc_entry->type = DSA_PORT_MALL_MIRROR;
+	mirror = &mall_tc_entry->mirror;
 
-		if (!dsa_slave_dev_check(act->dev))
-			return -EOPNOTSUPP;
+	to_dp = dsa_slave_to_port(act->dev);
 
-		mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
-		if (!mall_tc_entry)
-			return -ENOMEM;
+	mirror->to_local_port = to_dp->index;
+	mirror->ingress = ingress;
 
-		mall_tc_entry->cookie = cls->cookie;
-		mall_tc_entry->type = DSA_PORT_MALL_MIRROR;
-		mirror = &mall_tc_entry->mirror;
+	err = ds->ops->port_mirror_add(ds, dp->index, mirror, ingress);
+	if (err) {
+		kfree(mall_tc_entry);
+		return err;
+	}
 
-		to_dp = dsa_slave_to_port(act->dev);
+	list_add_tail(&mall_tc_entry->list, &p->mall_tc_list);
 
-		mirror->to_local_port = to_dp->index;
-		mirror->ingress = ingress;
+	return err;
+}
 
-		err = ds->ops->port_mirror_add(ds, dp->index, mirror, ingress);
-		if (err) {
-			kfree(mall_tc_entry);
-			return err;
-		}
+static int dsa_slave_add_cls_matchall(struct net_device *dev,
+				      struct tc_cls_matchall_offload *cls,
+				      bool ingress)
+{
+	int err = -EOPNOTSUPP;
 
-		list_add_tail(&mall_tc_entry->list, &p->mall_tc_list);
-	}
+	if (cls->common.protocol == htons(ETH_P_ALL) &&
+	    flow_offload_has_one_action(&cls->rule->action) &&
+	    cls->rule->action.entries[0].id == FLOW_ACTION_MIRRED)
+		err = dsa_slave_add_cls_matchall_mirred(dev, cls, ingress);
 
 	return 0;
 }
-- 
2.17.1

