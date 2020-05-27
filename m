Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E651E51EC
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 01:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgE0Xli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 19:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgE0Xle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 19:41:34 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B22C08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:32 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id x1so30059651ejd.8
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NG9Qr95MEesg3cmh0ZBCXpm/uYcdefCcyCE7X4+sY/E=;
        b=WYUEKa+2M0oOVPinOtDXCoQhQncAsPxWpFevjE15LQnoCsPO2av5FSQuoDGC0kpvOH
         4c7gAGP++QjLF1kwaB9mdgVthVIggR38ECl+K1SveNBreSWlvTIIduml5NRIL8BwAbtK
         uBQw4FphcsZ55gq5Z4DgR57/uOKQ6p3/c+kHf+vIBds4WhwaxXtwP1v3w/8IoOjQg533
         7uhO+45GFwdqIfuto5eTFILlQNZt1oGgbq1UxeBFY00Dc2va1e8E9gcnYDiM/1L2KUNV
         PkOLf/kZE38y3yJWwyzJlyy3WU+uZUKJDFBwe+h1DMlcxgSEwJ/oS73qZNJWC1aPsrZz
         EVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NG9Qr95MEesg3cmh0ZBCXpm/uYcdefCcyCE7X4+sY/E=;
        b=iCEPSgWGmDvUZ1vl82ekYQ2blr0FRSjen32/Y2IerhtOom3j9WUuAu8/M8E6PjHo9Z
         /qAIcLj6UQnRzUywYiEd6cMfyGjbhS6MwXecR/q7BLbM5ib17ApzZnM05EZDwDHvhufx
         Qr7X3p4BcBVSB3BhHjZEDcssfFJoEGads3brhLy56EyBWL9L8a7WuH1BPqgRUHUKfXQu
         FXXgNOAxWDr5CdILRZ1p9+lBGU2Rc/43wPJ0NA0i0puX5iLksLl6GWcq+IZFkmqoL4Fv
         qlA4mPjLUQ80LOeI+jxRb3v3Op2cHRSSFHr1Zzf6i/mU7J0uFcP4mk+osJfdctdDgkJh
         t5Ag==
X-Gm-Message-State: AOAM533RXvnq9+IywEVvhOzWckLgfQ+mMm8AalRQT+qIDkJF4BzbZpO8
        vinS+ubBQUbmiUIvvrA8+LjroLE1
X-Google-Smtp-Source: ABdhPJz4XXDYi1a/1kN2ufW9bW6Fj+SPP3PG8vGiImmEPuw5tkB+WUo2RRYleT10VjGwGZoE6EXbtQ==
X-Received: by 2002:a17:906:9707:: with SMTP id k7mr718051ejx.18.1590622891315;
        Wed, 27 May 2020 16:41:31 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id a13sm3236555eds.6.2020.05.27.16.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 16:41:30 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH net-next 06/11] net: dsa: ocelot: create a template for the DSA tags on xmit
Date:   Thu, 28 May 2020 02:41:08 +0300
Message-Id: <20200527234113.2491988-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200527234113.2491988-1-olteanv@gmail.com>
References: <20200527234113.2491988-1-olteanv@gmail.com>
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

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 23 +++++++++++++++++++++++
 include/soc/mscc/ocelot.h      |  2 ++
 net/dsa/tag_ocelot.c           | 21 ++++++++-------------
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 8b15cbcb597c..0a392e0f4fbb 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -480,6 +480,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	for (port = 0; port < num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port;
 		struct regmap *target;
+		u64 bypass, dest, src;
+		u8 *template;
 
 		ocelot_port = devm_kzalloc(ocelot->dev,
 					   sizeof(struct ocelot_port),
@@ -505,9 +507,30 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
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
+		/* Set the source port as the CPU port module and not the
+		 * NPI port
+		 */
+		src = ocelot->num_phys_ports;
+		dest = BIT(port);
+		bypass = true;
+
+		packing(template, &bypass, 127, 127, OCELOT_TAG_LEN, PACK, 0);
+		packing(template, &dest,    68,  56, OCELOT_TAG_LEN, PACK, 0);
+		packing(template, &src,     46,  43, OCELOT_TAG_LEN, PACK, 0);
+
 		ocelot_port->phy_mode = port_phy_modes[port];
 		ocelot_port->ocelot = ocelot;
 		ocelot_port->target = target;
+		ocelot_port->xmit_template = template;
 		ocelot->ports[port] = ocelot_port;
 	}
 
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

