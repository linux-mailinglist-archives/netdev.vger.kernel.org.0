Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF6321DE09
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgGMQ7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730061AbgGMQ67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:58:59 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601FEC061794
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:58:59 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o18so18023988eje.7
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=linjx8X31u6pUxwsDE1XQj0eBE+GWDbUDTjY/8gm9pI=;
        b=RhK9wvCYYjZ9CBYxCYCWVcgse+/pP8ajUxXlcFX/fAfm5r+8KtNEMPOZmNVZP5YYqQ
         c8dCa9uxgYODPWwwdrXztO2cxWm4pL4f8Fu5PfftXw8AskcDvy/ikeqDVLvDrZz2A1wg
         vsjLV/f3oKBYqwzkLClw+IPE7C+SXR1trQccFVM1K01GKjJestnr78AVY2MO0Dgg3MNp
         vK7nkdZOSrWn3sLGYIo93Jv6N7h6QNvgaa2i2SC5Qsyh+vu2FUlpB8hiAp3MrD2CTdSc
         rN+VwYVCCZMaB7HePDm7agZvvCHixN9cZOEM1P7HCUOEdFXfuj1sTOYrkkB+XfEZ6FG8
         lNGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=linjx8X31u6pUxwsDE1XQj0eBE+GWDbUDTjY/8gm9pI=;
        b=bRSDZJCNv1pd9otBRHk0b4io3OG7QSOho2wbkL09ZMZriJnPrTG46hxK/jBYzV0+m6
         7YZvXfFIa7l+KVplSfZsw6HpjdIMcWn9uriCIs4mQrFUXhOT6Rj3s61EpD/bJALgJ4j2
         OAm8mUAfwiRAb1b4DGGLXPMYnBEPDP4vKlC9ZpsvGVqihsz1W7tjpZuw+jmRzr/BO/nn
         xJ79oIR4ySzMlTadzLPw0ZlPedsG5X2oe5BxbY9TDt6VhgY3ySmmNDgVg1yhfXLhGdnD
         chnNsYquNvzEawp8/AHY89SAgomPZBI/Q419lTL0M6hLhV/W1L1Xw7HejTjYVT7avIk6
         /vxA==
X-Gm-Message-State: AOAM530OAzrPwbZNt+vSmjT+KjAbHOgHFwdUSDaiXbPhU0ZXXMHMoGFz
        e8Tc+7XR3SurEl7MsiHu9kA=
X-Google-Smtp-Source: ABdhPJxmphL/5bbOqIJlWYeSqguqbD4lSHoIqbw2oTdPh4KhFUjxr68xFg8fugrz5IyIWNaKU3dqXg==
X-Received: by 2002:a17:906:57c6:: with SMTP id u6mr664550ejr.194.1594659538056;
        Mon, 13 Jul 2020 09:58:58 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id y1sm12986732ede.7.2020.07.13.09.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:58:57 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: [PATCH v4 net-next 04/11] net: dsa: felix: create a template for the DSA tags on xmit
Date:   Mon, 13 Jul 2020 19:57:04 +0300
Message-Id: <20200713165711.2518150-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713165711.2518150-1-olteanv@gmail.com>
References: <20200713165711.2518150-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Created a function pointer such that Seville could reuse more code.

 drivers/net/dsa/ocelot/felix.c         | 13 +++++++++++++
 drivers/net/dsa/ocelot/felix.h         |  1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c | 20 ++++++++++++++++++++
 include/soc/mscc/ocelot.h              |  2 ++
 net/dsa/tag_ocelot.c                   | 21 ++++++++-------------
 5 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4b255ed614e4..b9981d8c4c98 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -522,6 +522,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	for (port = 0; port < num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port;
 		struct regmap *target;
+		u8 *template;
 
 		ocelot_port = devm_kzalloc(ocelot->dev,
 					   sizeof(struct ocelot_port),
@@ -547,10 +548,22 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
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
index 00137b64132b..a85631d716b9 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -43,6 +43,7 @@ struct felix_info {
 				 enum tc_setup_type type, void *type_data);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
+	void	(*xmit_template_populate)(struct ocelot *ocelot, int port);
 };
 
 extern struct felix_info		felix_info_vsc9959;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index efbfbdccb2b6..d640146acc3d 100644
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
@@ -1432,6 +1433,24 @@ static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
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
@@ -1458,4 +1477,5 @@ struct felix_info felix_info_vsc9959 = {
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc          = vsc9959_port_setup_tc,
 	.port_sched_speed_set   = vsc9959_sched_speed_set,
+	.xmit_template_populate	= vsc9959_xmit_template_populate,
 };
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 19d97585345a..6cfbace57770 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -564,6 +564,8 @@ struct ocelot_port {
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

