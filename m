Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94FD516A6F5
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgBXNJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:09:20 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38234 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbgBXNJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:09:19 -0500
Received: by mail-wm1-f66.google.com with SMTP id a9so9330351wmj.3
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 05:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fUiOly5CXX1WFZCExB1ddH1eqPhoG6ucCAv+JnDtZ1o=;
        b=SCLsBiWLch08bj7Y5/8zn5fsCzQm2BYaQx91lbHgpITTl1XVkp5SE2Gd5hZmitTS5d
         lVh419HP0WPstjSkU9GU8uusvt5MWe94D6jrql4lKvZArsHKcJ+PtIfD4HBQlQ5hMpsH
         a6+OHTBaKdDy1ygCIeeXK3FpsIK3zJWJKwmONDRb6Va2kuwfdOzBLbzU4MLevGfr4/kh
         ISuCu/3Kf9a4HeJLnNFbF/2MAm5y5Pw5QUdZI5MNApMtNawNF/AvjN1nTXyUBNXbPs/I
         JJR+hHDseAVAxQfYZ+3exBaEO17iAasiEpkTJwg91GE9DpI0RwkkWRW1gN0EpQuAxMln
         APHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fUiOly5CXX1WFZCExB1ddH1eqPhoG6ucCAv+JnDtZ1o=;
        b=YlPBsyjP3xIy3Ki7GXRhRDbQQI3WRjZPZaa/VMspeIw8xkR7SfozPZE455Agl8oCar
         43prr77Sd2Xm492WmsNrR97O9S0H21JCORzL55vpljsGligcMD2LoXLlel0wbwhkHy5D
         mUuUwqcFAVq86GACs7Se64RWnYwgZSay8XZzCoguxVPXvq0eueBTw8kjG+dZDkDUXlwO
         koTqf2GYxOJRpaM1qsQSMxETMG0oXfMwcGi7wOtgOcUEdCyN3xb6zsJ63AP2tTdvjwUf
         v/CNn289ZVvLMdOLmovt1w86X7x1Vg+Z8UVY6JPEN7gPG/j69M5oUUBn6dbCE8IjbPY3
         Vnlg==
X-Gm-Message-State: APjAAAXY91ocJrPfivkP5BCzYsLlsSVyzxZ+tHlbSynR8kullmnVgUIH
        ijSFnNUIewaPDxYeyKuGKwf/8pTQhZ4=
X-Google-Smtp-Source: APXvYqyIJtZUJx9cN7VWD04pecXjDhjyvEJhe6injrlCCsXpvhIIYaikZwV3p/znvWu1RU6UurxNXA==
X-Received: by 2002:a1c:6189:: with SMTP id v131mr23131446wmb.185.1582549757205;
        Mon, 24 Feb 2020 05:09:17 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id i204sm18089298wma.44.2020.02.24.05.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:09:16 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH net-next 01/10] net: mscc: ocelot: make ocelot_ace_rule support multiple ports
Date:   Mon, 24 Feb 2020 15:08:22 +0200
Message-Id: <20200224130831.25347-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224130831.25347-1-olteanv@gmail.com>
References: <20200224130831.25347-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>

The ocelot_ace_rule is port specific now. Make it flexible to
be able to support multiple ports too.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c    | 14 +++++++-------
 drivers/net/ethernet/mscc/ocelot_ace.h    |  4 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c |  8 ++++----
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 86fc6e6b46dd..18670645d47f 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -352,7 +352,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	data.type = IS2_ACTION_TYPE_NORMAL;
 
 	VCAP_KEY_ANY_SET(PAG);
-	VCAP_KEY_SET(IGR_PORT_MASK, 0, ~BIT(ace->chip_port));
+	VCAP_KEY_SET(IGR_PORT_MASK, 0, ~ace->ingress_port_mask);
 	VCAP_KEY_BIT_SET(FIRST, OCELOT_VCAP_BIT_1);
 	VCAP_KEY_BIT_SET(HOST_MATCH, OCELOT_VCAP_BIT_ANY);
 	VCAP_KEY_BIT_SET(L2_MC, ace->dmac_mc);
@@ -576,7 +576,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 
 static void is2_entry_get(struct ocelot_ace_rule *rule, int ix)
 {
-	struct ocelot *op = rule->port->ocelot;
+	struct ocelot *op = rule->ocelot;
 	struct vcap_data data;
 	int row = (ix / 2);
 	u32 cnt;
@@ -655,11 +655,11 @@ int ocelot_ace_rule_offload_add(struct ocelot_ace_rule *rule)
 	/* Move down the rules to make place for the new rule */
 	for (i = acl_block->count - 1; i > index; i--) {
 		ace = ocelot_ace_rule_get_rule_index(acl_block, i);
-		is2_entry_set(rule->port->ocelot, i, ace);
+		is2_entry_set(rule->ocelot, i, ace);
 	}
 
 	/* Now insert the new rule */
-	is2_entry_set(rule->port->ocelot, index, rule);
+	is2_entry_set(rule->ocelot, index, rule);
 	return 0;
 }
 
@@ -697,11 +697,11 @@ int ocelot_ace_rule_offload_del(struct ocelot_ace_rule *rule)
 	/* Move up all the blocks over the deleted rule */
 	for (i = index; i < acl_block->count; i++) {
 		ace = ocelot_ace_rule_get_rule_index(acl_block, i);
-		is2_entry_set(rule->port->ocelot, i, ace);
+		is2_entry_set(rule->ocelot, i, ace);
 	}
 
 	/* Now delete the last rule, because it is duplicated */
-	is2_entry_set(rule->port->ocelot, acl_block->count, &del_ace);
+	is2_entry_set(rule->ocelot, acl_block->count, &del_ace);
 
 	return 0;
 }
@@ -717,7 +717,7 @@ int ocelot_ace_rule_stats_update(struct ocelot_ace_rule *rule)
 	/* After we get the result we need to clear the counters */
 	tmp = ocelot_ace_rule_get_rule_index(acl_block, index);
 	tmp->stats.pkts = 0;
-	is2_entry_set(rule->port->ocelot, index, tmp);
+	is2_entry_set(rule->ocelot, index, tmp);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index c08e3e8482e7..2927ac83741b 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -186,14 +186,14 @@ struct ocelot_ace_stats {
 
 struct ocelot_ace_rule {
 	struct list_head list;
-	struct ocelot_port *port;
+	struct ocelot *ocelot;
 
 	u16 prio;
 	u32 id;
 
 	enum ocelot_ace_action action;
 	struct ocelot_ace_stats stats;
-	int chip_port;
+	u16 ingress_port_mask;
 
 	enum ocelot_vcap_bit dmac_mc;
 	enum ocelot_vcap_bit dmac_bc;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 3d65b99b9734..ffd2bb50cfc3 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -177,8 +177,8 @@ struct ocelot_ace_rule *ocelot_ace_rule_create(struct flow_cls_offload *f,
 	if (!rule)
 		return NULL;
 
-	rule->port = &block->priv->port;
-	rule->chip_port = block->priv->chip_port;
+	rule->ocelot = block->priv->port.ocelot;
+	rule->ingress_port_mask = BIT(block->priv->chip_port);
 	return rule;
 }
 
@@ -213,7 +213,7 @@ static int ocelot_flower_destroy(struct flow_cls_offload *f,
 	int ret;
 
 	rule.prio = f->common.prio;
-	rule.port = &port_block->priv->port;
+	rule.ocelot = port_block->priv->port.ocelot;
 	rule.id = f->cookie;
 
 	ret = ocelot_ace_rule_offload_del(&rule);
@@ -231,7 +231,7 @@ static int ocelot_flower_stats_update(struct flow_cls_offload *f,
 	int ret;
 
 	rule.prio = f->common.prio;
-	rule.port = &port_block->priv->port;
+	rule.ocelot = port_block->priv->port.ocelot;
 	rule.id = f->cookie;
 	ret = ocelot_ace_rule_stats_update(&rule);
 	if (ret)
-- 
2.17.1

