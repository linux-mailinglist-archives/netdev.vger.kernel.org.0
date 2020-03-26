Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90FA7194BAD
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 23:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgCZWlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 18:41:16 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50588 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbgCZWlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 18:41:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id d198so9310829wmd.0
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 15:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jLPub5Fn9cx2du/Xv/A+n22ayPb338MqU7QOaBqb8/Q=;
        b=fVGtKO93MMy8pP9jsrxHgZ6Y3tTfwAz0833TkxFKYzN56s60Ij0Qf6nQLXEM8jpX0F
         E/vgYRn8XBiorOGCE8Yl4d1fmP6Zj4iBDoY4KLBqzOHqk1u5TIUnPJYB/TmgvMlewarX
         z2rGPdglA8wy/m/xiJbMrAgcGq/+KTwqZwrvFkiTYK3HWmgSC03zec77CU/Mc99X9DDr
         Yany7Lf58HxyfACtqMC84NgEINEsPeJoDUTGsg6REZT65BcES7XPuHvyCE25gpzB+BOd
         C62GsQYyyq2t/Ed1YvR3mYodt3Db0I02IBHjNO7AFAlMwKGREmcRfu9PvPBrfcigXW6c
         bQYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jLPub5Fn9cx2du/Xv/A+n22ayPb338MqU7QOaBqb8/Q=;
        b=EkqzVo/b7h0VD3yaOkQi4Gx0SZGPuXUcBnCnxk93/sop3vxZMynOmZYMmC0diC3roT
         cbSzTshKxShyL66nazJmyFFY93c28HKjBiazGWBBgS9Y15qfX86JElplgnVOHjCvYonP
         LhJq/D1QGtl0da+vKH9uZC/OZpsPwVgIu7VmqH1vaJMaH+DOaGcgwIFltmvfQBx/qLFb
         Dd5uhQUYfWjkf3qF0oahZc5kJnBuc55j6k38NoIIKuuOtXATKpTwdIlHPN9y35876uDn
         xnMNtTG0xIsUrACVt2oVLElPRL2X92de9xY1wTogsvqX3fNtGXwU/Vk3geYQ0CqdknZH
         9dKA==
X-Gm-Message-State: ANhLgQ1NyRaArA3pi4P6YhkBnZEhj3+tBIFWcf9o0P+URxj277XcWhhb
        VAWevIUbJdUu+lpruK2zEk4=
X-Google-Smtp-Source: ADFU+vsYUkinpIb3y3/2eCxNypOGIPDNXBggvGGFwyoNp1r1cvBMNdv/GLwCyMvXWoNVZkzta3Zp8Q==
X-Received: by 2002:a5d:6441:: with SMTP id d1mr5215900wrw.301.1585262472139;
        Thu, 26 Mar 2020 15:41:12 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id t81sm5522783wmb.15.2020.03.26.15.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 15:41:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 8/8] net: dsa: felix: support changing the MTU
Date:   Fri, 27 Mar 2020 00:40:40 +0200
Message-Id: <20200326224040.32014-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200326224040.32014-1-olteanv@gmail.com>
References: <20200326224040.32014-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Changing the MTU for this switch means altering the
DEV_GMII:MAC_CFG_STATUS:MAC_MAXLEN_CFG field MAX_LEN, which in turn
limits the size of frames that can be received.

Special accounting needs to be done for the DSA CPU port (NPI port in
hardware terms). The NPI port configuration needs to be held inside the
private ocelot structure, since it is now accessed from multiple places.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
Now setting the ds->mtu_enforcement_ingress variable to true.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c     | 19 +++++++++++++
 drivers/net/ethernet/mscc/ocelot.c | 45 +++++++++++++++++++++++-------
 include/soc/mscc/ocelot.h          |  7 +++++
 3 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9f9efb974003..eef9fa812a3c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -533,6 +533,7 @@ static int felix_setup(struct dsa_switch *ds)
 			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
 			 ANA_PGID_PGID, PGID_UC);
 
+	ds->mtu_enforcement_ingress = true;
 	/* It looks like the MAC/PCS interrupt register - PM0_IEVENT (0x8040)
 	 * isn't instantiated for the Felix PF.
 	 * In-band AN may take a few ms to complete, so we need to poll.
@@ -610,6 +611,22 @@ static bool felix_txtstamp(struct dsa_switch *ds, int port,
 	return false;
 }
 
+static int felix_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_set_maxlen(ocelot, port, new_mtu);
+
+	return 0;
+}
+
+static int felix_get_max_mtu(struct dsa_switch *ds, int port)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_get_max_mtu(ocelot, port);
+}
+
 static int felix_cls_flower_add(struct dsa_switch *ds, int port,
 				struct flow_cls_offload *cls, bool ingress)
 {
@@ -665,6 +682,8 @@ static const struct dsa_switch_ops felix_switch_ops = {
 	.port_hwtstamp_set	= felix_hwtstamp_set,
 	.port_rxtstamp		= felix_rxtstamp,
 	.port_txtstamp		= felix_txtstamp,
+	.port_change_mtu	= felix_change_mtu,
+	.port_max_mtu		= felix_get_max_mtu,
 	.cls_flower_add		= felix_cls_flower_add,
 	.cls_flower_del		= felix_cls_flower_del,
 	.cls_flower_stats	= felix_cls_flower_stats,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 114d6053aa26..b5f925c1b5b2 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1998,13 +1998,25 @@ EXPORT_SYMBOL(ocelot_switchdev_blocking_nb);
 
 /* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
  * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
+ * In the special case that it's the NPI port that we're configuring, the
+ * length of the tag and optional prefix needs to be accounted for privately,
+ * in order to be able to sustain communication at the requested @sdu.
  */
-static void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
+void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int maxlen = sdu + ETH_HLEN + ETH_FCS_LEN;
 	int atop_wm;
 
+	if (port == ocelot->npi) {
+		maxlen += OCELOT_TAG_LEN;
+
+		if (ocelot->inj_prefix == OCELOT_TAG_PREFIX_SHORT)
+			maxlen += OCELOT_SHORT_PREFIX_LEN;
+		else if (ocelot->inj_prefix == OCELOT_TAG_PREFIX_LONG)
+			maxlen += OCELOT_LONG_PREFIX_LEN;
+	}
+
 	ocelot_port_writel(ocelot_port, maxlen, DEV_MAC_MAXLEN_CFG);
 
 	/* Set Pause WM hysteresis
@@ -2022,6 +2034,24 @@ static void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 			 SYS_ATOP, port);
 	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
 }
+EXPORT_SYMBOL(ocelot_port_set_maxlen);
+
+int ocelot_get_max_mtu(struct ocelot *ocelot, int port)
+{
+	int max_mtu = 65535 - ETH_HLEN - ETH_FCS_LEN;
+
+	if (port == ocelot->npi) {
+		max_mtu -= OCELOT_TAG_LEN;
+
+		if (ocelot->inj_prefix == OCELOT_TAG_PREFIX_SHORT)
+			max_mtu -= OCELOT_SHORT_PREFIX_LEN;
+		else if (ocelot->inj_prefix == OCELOT_TAG_PREFIX_LONG)
+			max_mtu -= OCELOT_LONG_PREFIX_LEN;
+	}
+
+	return max_mtu;
+}
+EXPORT_SYMBOL(ocelot_get_max_mtu);
 
 void ocelot_init_port(struct ocelot *ocelot, int port)
 {
@@ -2131,6 +2161,10 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
 {
 	int cpu = ocelot->num_phys_ports;
 
+	ocelot->npi = npi;
+	ocelot->inj_prefix = injection;
+	ocelot->xtr_prefix = extraction;
+
 	/* The unicast destination PGID for the CPU port module is unused */
 	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, cpu);
 	/* Instead set up a multicast destination PGID for traffic copied to
@@ -2143,19 +2177,10 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
 			 ANA_PORT_PORT_CFG, cpu);
 
 	if (npi >= 0 && npi < ocelot->num_phys_ports) {
-		int sdu = ETH_DATA_LEN + OCELOT_TAG_LEN;
-
 		ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
 			     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(npi),
 			     QSYS_EXT_CPU_CFG);
 
-		if (injection == OCELOT_TAG_PREFIX_SHORT)
-			sdu += OCELOT_SHORT_PREFIX_LEN;
-		else if (injection == OCELOT_TAG_PREFIX_LONG)
-			sdu += OCELOT_LONG_PREFIX_LEN;
-
-		ocelot_port_set_maxlen(ocelot, npi, sdu);
-
 		/* Enable NPI port */
 		ocelot_write_rix(ocelot,
 				 QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index db2fb14bd775..23a78d927838 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -522,6 +522,11 @@ struct ocelot {
 	 */
 	u8				num_phys_ports;
 
+	int				npi;
+
+	enum ocelot_tag_prefix		inj_prefix;
+	enum ocelot_tag_prefix		xtr_prefix;
+
 	u32				*lags;
 
 	struct list_head		multicast;
@@ -616,6 +621,8 @@ int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr);
 int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
 				 struct sk_buff *skb);
 void ocelot_get_txtstamp(struct ocelot *ocelot);
+void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu);
+int ocelot_get_max_mtu(struct ocelot *ocelot, int port);
 int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress);
 int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
-- 
2.17.1

