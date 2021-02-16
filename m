Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A021D31D256
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhBPVq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:46:58 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35157 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhBPVqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:46:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613511969; x=1645047969;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=21JiiqEIgm5zFzzo3WjE3M2nVZRsuDLR5EdGNJxiEgU=;
  b=sF/Si8ycZZIEsa1FJD8WqwZIt/BuLipemqZ+fk86pDU0Vy/yyyykiNUW
   tSwJiro6TSCl8td5D+jLmp3VbzlfE4yMfDlXzYykD4djRJKHTDU7Bjjhx
   aXPwl/XlC3RjAHlmHK5AVWPuooEbg+6KoRvKqVfy+elbKx+OC/mSrfI6F
   JG7dPPJZqyxuoQELhCXIqAKUMc8/LewmVt5vkKn1ZtRpxRLjkek8WJZno
   5LSGRCB28mxPDumrwc4Uqb37og4nBwdjEL69/4bqteNjsSnKwUSd13qUF
   1vYahwbNZ3nRF/EhkZC5KpgauH2DfZJB8hYUdJD2jYfAW51N55fL6lV5S
   w==;
IronPort-SDR: rFZo+EnCajOdqG6loZiGFSJeaRUUzS43m0EDS3lNMYtaSsmQ2po4JosbYewL1hbZCyAXCWOIRP
 8t6zCD7DrEGmaWwE2hTkzT40/xUnKJMi0DZLqWp6v/oWU9VsXw25gipyBdVg38nayRExmNQnok
 YPSVul1pqHmvluonHiqK4dsiMXSv9puaBxbCujSXxLMdDKYk5vHzvO4ZHlL5Oa3ub9/xLYObNA
 xB/d6B1zStgmScPzO3/PtSbBDgceW44q18U7C9UqPaRiX9QwRATP8T33+5V4mprL7FP9NIn+si
 SUY=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="109914805"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2021 14:43:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 16 Feb 2021 14:43:28 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 16 Feb 2021 14:43:25 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jiri@resnulli.us>, <ivecera@redhat.com>, <nikolay@nvidia.com>,
        <roopa@nvidia.com>, <vladimir.oltean@nxp.com>,
        <claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <rasmus.villemoes@prevas.dk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 8/8] net: dsa: felix: Add support for MRP
Date:   Tue, 16 Feb 2021 22:42:05 +0100
Message-ID: <20210216214205.32385-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216214205.32385-1-horatiu.vultur@microchip.com>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement functions 'port_mrp_add', 'port_mrp_del',
'port_mrp_add_ring_role' and 'port_mrp_del_ring_role' to call the mrp
functions from ocelot.

Also all MRP frames that arrive to CPU on queue number OCELOT_MRP_CPUQ
will be forward by the SW.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/dsa/ocelot/felix.c | 38 ++++++++++++++++++++++++++++++++++
 net/dsa/tag_ocelot.c           |  8 +++++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 800f27d65c6c..fa1c3f14bb88 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1561,6 +1561,40 @@ static int felix_sb_occ_tc_port_bind_get(struct dsa_switch *ds, int port,
 					      pool_type, p_cur, p_max);
 }
 
+static int felix_mrp_add(struct dsa_switch *ds, int port,
+			 const struct switchdev_obj_mrp *mrp)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_mrp_add(ocelot, port, mrp);
+}
+
+static int felix_mrp_del(struct dsa_switch *ds, int port,
+			 const struct switchdev_obj_mrp *mrp)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_mrp_add(ocelot, port, mrp);
+}
+
+static int
+felix_mrp_add_ring_role(struct dsa_switch *ds, int port,
+			const struct switchdev_obj_ring_role_mrp *mrp)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_mrp_add_ring_role(ocelot, port, mrp);
+}
+
+static int
+felix_mrp_del_ring_role(struct dsa_switch *ds, int port,
+			const struct switchdev_obj_ring_role_mrp *mrp)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_mrp_del_ring_role(ocelot, port, mrp);
+}
+
 const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol		= felix_get_tag_protocol,
 	.change_tag_protocol		= felix_change_tag_protocol,
@@ -1615,6 +1649,10 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.devlink_sb_occ_max_clear	= felix_sb_occ_max_clear,
 	.devlink_sb_occ_port_pool_get	= felix_sb_occ_port_pool_get,
 	.devlink_sb_occ_tc_port_bind_get= felix_sb_occ_tc_port_bind_get,
+	.port_mrp_add			= felix_mrp_add,
+	.port_mrp_del			= felix_mrp_del,
+	.port_mrp_add_ring_role		= felix_mrp_add_ring_role,
+	.port_mrp_del_ring_role		= felix_mrp_del_ring_role,
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index f9df9cac81c5..743809b5806b 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -83,6 +83,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	struct dsa_port *dp;
 	u8 *extraction;
 	u16 vlan_tpid;
+	u64 cpuq;
 
 	/* Revert skb->data by the amount consumed by the DSA master,
 	 * so it points to the beginning of the frame.
@@ -112,6 +113,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	ocelot_xfh_get_qos_class(extraction, &qos_class);
 	ocelot_xfh_get_tag_type(extraction, &tag_type);
 	ocelot_xfh_get_vlan_tci(extraction, &vlan_tci);
+	ocelot_xfh_get_cpuq(extraction, &cpuq);
 
 	skb->dev = dsa_master_find_slave(netdev, 0, src_port);
 	if (!skb->dev)
@@ -126,6 +128,12 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	skb->offload_fwd_mark = 1;
 	skb->priority = qos_class;
 
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+	if (eth_hdr(skb)->h_proto == cpu_to_be16(ETH_P_MRP) &&
+	    cpuq & BIT(OCELOT_MRP_CPUQ))
+		skb->offload_fwd_mark = 0;
+#endif
+
 	/* Ocelot switches copy frames unmodified to the CPU. However, it is
 	 * possible for the user to request a VLAN modification through
 	 * VCAP_IS1_ACT_VID_REPLACE_ENA. In this case, what will happen is that
-- 
2.27.0

