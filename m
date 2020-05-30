Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CCD1E90F3
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 13:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgE3Lwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 07:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbgE3LwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 07:52:25 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36D4C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:24 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id c35so3742223edf.5
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZmcP3H1ozWcGJ55r+14aGwYGDYC1zwxwvRaIa7yI3Zs=;
        b=p88jKUJb8vpfCkm6dh9rH19NnAhkBuaXxnsQILqhABIVYL0mQKgGWUM4MdX+g9Uulq
         pZFcuCXV6O3m1P7KRhFij7Y9wM/vPKD+nZ0k+SDbkNK/ddPD+bSHPK170jDS/MdFffbD
         EiL0R3RSMtmmCTbFG0nQt/nih3JIWIQSgd2VBpViF+30xyP3qmDWJBphmanTR3qqKty0
         2P2G88tyYPXdVKZekAlrCtvIJrslkJVwy6zoSGvlDiAVFGmZR9VRTJ7xVjCiVHMe/wcd
         gzRHPReuWEtDmdV97yJfvzqdL7WkB+wNqE9+vykHmDCRZeBup2cdQbglZsT4Q0tp6nde
         8n9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZmcP3H1ozWcGJ55r+14aGwYGDYC1zwxwvRaIa7yI3Zs=;
        b=cMvKRtGmQkvN7g0KfrdMY/4iQMja8sxbk3TAfKelBqFYapiB53DS5hcrQ5rVDJZTFu
         0PbT8p2DfHiUrDcGIA2WlqacJ6TaStZRjhQjsU00FI3ycvl/WWlDveybrl8ugoCHOOKv
         5wmSMMO6d/VVCp4qSnZWqcFwEnr72iO2hCjoaUB7+CJx1FWiTKR+BY5HbwmX+0wYZjqP
         bvKaSRJr9gVDoOyaN4bZfcxG4JBskh6IEGyya8R9b6H/v+K2YrcKRXyx5RmPz46rCuTy
         vDhbd9eS+BneVeyWf2ByZsnzoxswt5OZIxe2+XbtZVhVIFP9aL+FRXyo6OA20xttRLIn
         Zf7A==
X-Gm-Message-State: AOAM53143+vCjbWRBJjZYOf2lawMh17ymF7rWyAr7xrCPmdfIkxNi7nd
        YP5Frntft3L2ale8CEEV8aI=
X-Google-Smtp-Source: ABdhPJwhctzJUjxiOG7BiVFMvT+is9Rmfa+IbkKCQPqFymF7MrnZEL7DODgSu55ugr3l2VQFOs8K4A==
X-Received: by 2002:a05:6402:1770:: with SMTP id da16mr12313283edb.122.1590839543583;
        Sat, 30 May 2020 04:52:23 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id z14sm9625203ejd.37.2020.05.30.04.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:52:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v2 net-next 06/13] net: dsa: felix: create a template for the DSA tags on xmit
Date:   Sat, 30 May 2020 14:51:35 +0300
Message-Id: <20200530115142.707415-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200530115142.707415-1-olteanv@gmail.com>
References: <20200530115142.707415-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

With this patch we try to kill 2 birds with 1 stone.

First of all, some switches that use tag_ocelot.c don't have the exact
same bitfield layout for the DSA tags. The destination ports field is
different for Seville VSC9953 for example. So the choices are to either
duplicate tag_ocelot.c into a new tag_seville.c (sub-optimal) or somehow
take into account a supposed ocelot->dest_ports_offset when packing this
field into the DSA injection header (again not ideal).

Secondly, tag_ocelot.c already needs to memset a 128-bit area to zero
and call some packing() functions of dubious performance in the
fastpath. And most of the values it needs to pack are pretty much
constant (BYPASS=1, SRC_PORT=CPU, DEST=port index). So it would be good
if we could improve that.

The proposed solution is to allocate a memory area per port at probe
time, initialize that with the statically defined bits as per chip
hardware revision, and just perform a simpler memcpy in the fastpath.

Other alternatives have been analyzed, such as:
- Create a separate tag_seville.c: too much code duplication for just 1
  bit field difference.
- Create a separate DSA_TAG_PROTO_SEVILLE under tag_ocelot.c, just like
  tag_brcm.c, which would have a separate .xmit function. Again, too
  much code duplication for just 1 bit field difference.
- Allocate the template from the init function of the tag_ocelot.c
  module, instead of from the driver: couldn't figure out a method of
  accessing the correct port template corresponding to the correct
  tagger in the .xmit function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Created a function pointer such that Seville could reuse more code.

 drivers/net/dsa/ocelot/felix.c         | 13 +++++++++++++
 drivers/net/dsa/ocelot/felix.h         |  1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c | 20 ++++++++++++++++++++
 include/soc/mscc/ocelot.h              |  2 ++
 net/dsa/tag_ocelot.c                   | 21 ++++++++-------------
 5 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 80b0735d680e..0346697bed3f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -502,6 +502,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	for (port = 0; port < num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port;
 		struct regmap *target;
+		u8 *template;
 
 		ocelot_port = devm_kzalloc(ocelot->dev,
 					   sizeof(struct ocelot_port),
@@ -527,10 +528,22 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 			return PTR_ERR(target);
 		}
 
+		template = devm_kzalloc(ocelot->dev, OCELOT_TAG_LEN,
+					GFP_KERNEL);
+		if (!template) {
+			dev_err(ocelot->dev,
+				"Failed to allocate memory for DSA tag\n");
+			kfree(port_phy_modes);
+			return -ENOMEM;
+		}
+
 		ocelot_port->phy_mode = port_phy_modes[port];
 		ocelot_port->ocelot = ocelot;
 		ocelot_port->target = target;
+		ocelot_port->xmit_template = template;
 		ocelot->ports[port] = ocelot_port;
+
+		felix->info->xmit_template_populate(ocelot, port);
 	}
 
 	kfree(port_phy_modes);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index a891736ca006..2f28c28fdef0 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -40,6 +40,7 @@ struct felix_info {
 				 enum tc_setup_type type, void *type_data);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
+	void	(*xmit_template_populate)(struct ocelot *ocelot, int port);
 };
 
 extern struct felix_info		felix_info_vsc9959;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index bdc805686196..554f24fa6ff9 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -8,6 +8,7 @@
 #include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot.h>
+#include <linux/packing.h>
 #include <net/pkt_sched.h>
 #include <linux/iopoll.h>
 #include <linux/pci.h>
@@ -1446,6 +1447,24 @@ static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 	}
 }
 
+static void vsc9959_xmit_template_populate(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u8 *template = ocelot_port->xmit_template;
+	u64 bypass, dest, src;
+
+	/* Set the source port as the CPU port module and not the
+	 * NPI port
+	 */
+	src = ocelot->num_phys_ports;
+	dest = BIT(port);
+	bypass = true;
+
+	packing(template, &bypass, 127, 127, OCELOT_TAG_LEN, PACK, 0);
+	packing(template, &dest,    68,  56, OCELOT_TAG_LEN, PACK, 0);
+	packing(template, &src,     46,  43, OCELOT_TAG_LEN, PACK, 0);
+}
+
 struct felix_info felix_info_vsc9959 = {
 	.target_io_res		= vsc9959_target_io_res,
 	.port_io_res		= vsc9959_port_io_res,
@@ -1472,4 +1491,5 @@ struct felix_info felix_info_vsc9959 = {
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc          = vsc9959_port_setup_tc,
 	.port_sched_speed_set   = vsc9959_sched_speed_set,
+	.xmit_template_populate	= vsc9959_xmit_template_populate,
 };
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 8e6c13d99ced..1a87a3a32616 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -549,6 +549,8 @@ struct ocelot_port {
 	u8				ts_id;
 
 	phy_interface_t			phy_mode;
+
+	u8				*xmit_template;
 };
 
 struct ocelot {
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index b0c98ee4e13b..42f327c06dca 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -137,11 +137,10 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	u64 bypass, dest, src, qos_class, rew_op;
 	struct dsa_switch *ds = dp->ds;
-	int port = dp->index;
 	struct ocelot *ocelot = ds->priv;
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_port *ocelot_port;
+	u64 qos_class, rew_op;
 	u8 *injection;
 
 	if (unlikely(skb_cow_head(skb, OCELOT_TAG_LEN) < 0)) {
@@ -149,19 +148,15 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 		return NULL;
 	}
 
-	injection = skb_push(skb, OCELOT_TAG_LEN);
+	ocelot_port = ocelot->ports[dp->index];
 
-	memset(injection, 0, OCELOT_TAG_LEN);
+	injection = skb_push(skb, OCELOT_TAG_LEN);
 
-	/* Set the source port as the CPU port module and not the NPI port */
-	src = ocelot->num_phys_ports;
-	dest = BIT(port);
-	bypass = true;
+	memcpy(injection, ocelot_port->xmit_template, OCELOT_TAG_LEN);
+	/* Fix up the fields which are not statically determined
+	 * in the template
+	 */
 	qos_class = skb->priority;
-
-	packing(injection, &bypass,   127, 127, OCELOT_TAG_LEN, PACK, 0);
-	packing(injection, &dest,      68,  56, OCELOT_TAG_LEN, PACK, 0);
-	packing(injection, &src,       46,  43, OCELOT_TAG_LEN, PACK, 0);
 	packing(injection, &qos_class, 19,  17, OCELOT_TAG_LEN, PACK, 0);
 
 	if (ocelot->ptp && (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
-- 
2.25.1

