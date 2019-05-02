Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5DB41169D
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfEBJlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:41:23 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:34333 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfEBJlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 05:41:22 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Joergen.Andreasen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="Joergen.Andreasen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Joergen.Andreasen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,421,1549954800"; 
   d="scan'208";a="31502446"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 May 2019 02:41:11 -0700
Received: from localhost (10.10.76.4) by chn-sv-exch03.mchp-main.com
 (10.10.76.49) with Microsoft SMTP Server id 14.3.352.0; Thu, 2 May 2019
 02:41:10 -0700
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     Joergen Andreasen <joergen.andreasen@microchip.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Paul Burton" <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, <linux-mips@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 2/3] net: mscc: ocelot: Implement port policers via tc command
Date:   Thu, 2 May 2019 11:40:28 +0200
Message-ID: <20190502094029.22526-3-joergen.andreasen@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190502094029.22526-1-joergen.andreasen@microchip.com>
References: <20190502094029.22526-1-joergen.andreasen@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hardware offload of port policers are now supported via the tc command.
Supported police parameters are: rate, burst and overhead.

Example:

Add:
tc qdisc add dev eth3 handle ffff: ingress
tc filter add dev eth3 parent ffff: prio 1 handle 2		\
	matchall skip_sw					\
	action police rate 100Mbit burst 10000 overhead 20

Show:
tc -s -d qdisc show dev eth3
tc -s -d filter show dev eth3 ingress

Delete:
tc filter del dev eth3 parent ffff: prio 1
tc qdisc del dev eth3 handle ffff: ingress

Signed-off-by: Joergen Andreasen <joergen.andreasen@microchip.com>
---
 drivers/net/ethernet/mscc/Makefile        |   2 +-
 drivers/net/ethernet/mscc/ocelot.c        |   6 +-
 drivers/net/ethernet/mscc/ocelot.h        |   3 +
 drivers/net/ethernet/mscc/ocelot_police.c | 289 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_police.h |  16 ++
 drivers/net/ethernet/mscc/ocelot_tc.c     | 151 +++++++++++
 drivers/net/ethernet/mscc/ocelot_tc.h     |  19 ++
 7 files changed, 483 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_police.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_police.h
 create mode 100644 drivers/net/ethernet/mscc/ocelot_tc.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_tc.h

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index cb52a3b128ae..5e694dc1f7f8 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: (GPL-2.0 OR MIT)
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot_common.o
 mscc_ocelot_common-y := ocelot.o ocelot_io.o
-mscc_ocelot_common-y += ocelot_regs.o
+mscc_ocelot_common-y += ocelot_regs.o ocelot_tc.o ocelot_police.o
 obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += ocelot_board.o
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d715ef4fc92f..3ec7864d9dc8 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -943,6 +943,7 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_vlan_rx_kill_vid		= ocelot_vlan_rx_kill_vid,
 	.ndo_set_features		= ocelot_set_features,
 	.ndo_get_port_parent_id		= ocelot_get_port_parent_id,
+	.ndo_setup_tc			= ocelot_setup_tc,
 };
 
 static void ocelot_get_strings(struct net_device *netdev, u32 sset, u8 *data)
@@ -1663,8 +1664,9 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 	dev->netdev_ops = &ocelot_port_netdev_ops;
 	dev->ethtool_ops = &ocelot_ethtool_ops;
 
-	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS |
+		NETIF_F_HW_TC;
+	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
 
 	memcpy(dev->dev_addr, ocelot->base_mac, ETH_ALEN);
 	dev->dev_addr[ETH_ALEN - 1] += port;
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index ba3b3380b4d0..9514979fa075 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -22,6 +22,7 @@
 #include "ocelot_rew.h"
 #include "ocelot_sys.h"
 #include "ocelot_qs.h"
+#include "ocelot_tc.h"
 
 #define PGID_AGGR    64
 #define PGID_SRC     80
@@ -458,6 +459,8 @@ struct ocelot_port {
 
 	phy_interface_t phy_mode;
 	struct phy *serdes;
+
+	struct ocelot_port_tc tc;
 };
 
 u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
diff --git a/drivers/net/ethernet/mscc/ocelot_police.c b/drivers/net/ethernet/mscc/ocelot_police.c
new file mode 100644
index 000000000000..b40382dcc748
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_police.c
@@ -0,0 +1,289 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Microsemi Ocelot Switch TC driver
+ *
+ * Copyright (c) 2019 Microsemi Corporation
+ */
+
+#include "ocelot_police.h"
+
+#define MSCC_RC(expr)				\
+	do {					\
+		int __rc__ = (expr);		\
+		if (__rc__ < 0)			\
+			return __rc__;		\
+	}					\
+	while (0)
+
+/* The following two functions do the same as in iproute2 */
+#define TIME_UNITS_PER_SEC	1000000
+static unsigned int tc_core_tick2time(unsigned int tick)
+{
+	return (tick * (u32)PSCHED_TICKS2NS(1)) / 1000;
+}
+
+static unsigned int tc_calc_xmitsize(u64 rate, unsigned int ticks)
+{
+	return div_u64(rate * tc_core_tick2time(ticks), TIME_UNITS_PER_SEC);
+}
+
+enum mscc_qos_rate_mode {
+	MSCC_QOS_RATE_MODE_DISABLED, /* Policer/shaper disabled */
+	MSCC_QOS_RATE_MODE_LINE, /* Measure line rate in kbps incl. IPG */
+	MSCC_QOS_RATE_MODE_DATA, /* Measures data rate in kbps excl. IPG */
+	MSCC_QOS_RATE_MODE_FRAME, /* Measures frame rate in fps */
+	__MSCC_QOS_RATE_MODE_END,
+	NUM_MSCC_QOS_RATE_MODE = __MSCC_QOS_RATE_MODE_END,
+	MSCC_QOS_RATE_MODE_MAX = __MSCC_QOS_RATE_MODE_END - 1,
+};
+
+/* Round x divided by y to nearest integer. x and y are integers */
+#define MSCC_ROUNDING_DIVISION(x, y) (((x) + ((y) / 2)) / (y))
+
+/* Round x divided by y to nearest higher integer. x and y are integers */
+#define MSCC_DIV_ROUND_UP(x, y) (((x) + (y) - 1) / (y))
+
+/* Types for ANA:POL[0-192]:POL_MODE_CFG.FRM_MODE */
+#define POL_MODE_LINERATE   0 /* Incl IPG. Unit: 33 1/3 kbps, 4096 bytes */
+#define POL_MODE_DATARATE   1 /* Excl IPG. Unit: 33 1/3 kbps, 4096 bytes  */
+#define POL_MODE_FRMRATE_HI 2 /* Unit: 33 1/3 fps, 32.8 frames */
+#define POL_MODE_FRMRATE_LO 3 /* Unit: 1/3 fps, 0.3 frames */
+
+/* Policer indexes */
+#define POL_IX_PORT    0    /* 0-11    : Port policers */
+#define POL_IX_QUEUE   32   /* 32-127  : Queue policers  */
+
+/* Default policer order */
+#define POL_ORDER 0x1d3 /* Ocelot policer order: Serial (QoS -> Port -> VCAP) */
+
+struct qos_policer_conf {
+	enum mscc_qos_rate_mode mode;
+	bool dlb; /* Enable DLB (dual leaky bucket mode */
+	bool cf;  /* Coupling flag (ignored in SLB mode) */
+	u32  cir; /* CIR in kbps/fps (ignored in SLB mode) */
+	u32  cbs; /* CBS in bytes/frames (ignored in SLB mode) */
+	u32  pir; /* PIR in kbps/fps */
+	u32  pbs; /* PBS in bytes/frames */
+	u8   ipg; /* Size of IPG when MSCC_QOS_RATE_MODE_LINE is chosen */
+};
+
+static int qos_policer_conf_set(struct ocelot_port *port,
+				u32 pol_ix,
+				struct qos_policer_conf *conf)
+{
+	struct ocelot *ocelot = port->ocelot;
+	u32 cir = 0, cbs = 0, pir = 0, pbs = 0;
+	u32 cf = 0, cir_ena = 0, frm_mode = 0;
+	u32 pbs_max = 0, cbs_max = 0;
+	bool cir_discard = 0, pir_discard = 0;
+	u8 ipg = 20;
+	u32 value;
+
+	pir = conf->pir;
+	pbs = conf->pbs;
+
+	switch (conf->mode) {
+	case MSCC_QOS_RATE_MODE_LINE:
+	case MSCC_QOS_RATE_MODE_DATA:
+		if (conf->mode == MSCC_QOS_RATE_MODE_LINE) {
+			frm_mode = POL_MODE_LINERATE;
+			ipg = min_t(u8, GENMASK(4, 0), conf->ipg);
+		} else {
+			frm_mode = POL_MODE_DATARATE;
+		}
+		if (conf->dlb) {
+			cir_ena = 1;
+			cir = conf->cir;
+			cbs = conf->cbs;
+			if (cir == 0 && cbs == 0) {
+				/* Discard cir frames */
+				cir_discard = 1;
+			} else {
+				cir = MSCC_DIV_ROUND_UP(cir, 100);
+				cir *= 3; /* 33 1/3 kbps */
+				cbs = MSCC_DIV_ROUND_UP(cbs, 4096);
+				cbs = (cbs ? cbs : 1); /* No zero burst size */
+				cbs_max = 60; /* Limit burst size */
+				cf = conf->cf;
+				if (cf)
+					pir += conf->cir;
+			}
+		}
+		if (pir == 0 && pbs == 0) {
+			/* Discard PIR frames */
+			pir_discard = 1;
+		} else {
+			pir = MSCC_DIV_ROUND_UP(pir, 100);
+			pir *= 3;  /* 33 1/3 kbps */
+			pbs = MSCC_DIV_ROUND_UP(pbs, 4096);
+			pbs = (pbs ? pbs : 1); /* No zero burst size */
+			pbs_max = 60; /* Limit burst size */
+		}
+		break;
+	case MSCC_QOS_RATE_MODE_FRAME:
+		if (pir >= 100) {
+			frm_mode = POL_MODE_FRMRATE_HI;
+			pir = MSCC_DIV_ROUND_UP(pir, 100);
+			pir *= 3;  /* 33 1/3 fps */
+			pbs = (pbs * 10) / 328; /* 32.8 frames */
+			pbs = (pbs ? pbs : 1); /* No zero burst size */
+			pbs_max = GENMASK(6, 0); /* Limit burst size */
+		} else {
+			frm_mode = POL_MODE_FRMRATE_LO;
+			if (pir == 0 && pbs == 0) {
+				/* Discard all frames */
+				pir_discard = 1;
+				cir_discard = 1;
+			} else {
+				pir *= 3; /* 1/3 fps */
+				pbs = (pbs * 10) / 3; /* 0.3 frames */
+				pbs = (pbs ? pbs : 1); /* No zero burst size */
+				pbs_max = 61; /* Limit burst size */
+			}
+		}
+		break;
+	default: /* MSCC_QOS_RATE_MODE_DISABLED */
+		/* Disable policer using maximum rate and zero burst */
+		pir = GENMASK(15, 0);
+		pbs = 0;
+		break;
+	}
+
+	/* Limit to maximum values */
+	pir = min_t(u32, GENMASK(15, 0), pir);
+	cir = min_t(u32, GENMASK(15, 0), cir);
+	pbs = min_t(u32, pbs_max, pbs);
+	cbs = min_t(u32, cbs_max, cbs);
+
+	value = (ANA_POL_MODE_CFG_IPG_SIZE(ipg) |
+		 ANA_POL_MODE_CFG_FRM_MODE(frm_mode) |
+		 (cf ? ANA_POL_MODE_CFG_DLB_COUPLED : 0) |
+		 (cir_ena ? ANA_POL_MODE_CFG_CIR_ENA : 0) |
+		 ANA_POL_MODE_CFG_OVERSHOOT_ENA);
+
+	ocelot_write_gix(ocelot,
+			 value,
+			 ANA_POL_MODE_CFG,
+			 pol_ix);
+
+	ocelot_write_gix(ocelot,
+			 ANA_POL_PIR_CFG_PIR_RATE(pir) |
+			 ANA_POL_PIR_CFG_PIR_BURST(pbs),
+			 ANA_POL_PIR_CFG,
+			 pol_ix);
+
+	ocelot_write_gix(ocelot,
+			 (pir_discard ? GENMASK(22, 0) : 0),
+			 ANA_POL_PIR_STATE,
+			 pol_ix);
+
+	ocelot_write_gix(ocelot,
+			 ANA_POL_CIR_CFG_CIR_RATE(cir) |
+			 ANA_POL_CIR_CFG_CIR_BURST(cbs),
+			 ANA_POL_CIR_CFG,
+			 pol_ix);
+
+	ocelot_write_gix(ocelot,
+			 (cir_discard ? GENMASK(22, 0) : 0),
+			 ANA_POL_CIR_STATE,
+			 pol_ix);
+
+	return 0;
+}
+
+int ocelot_port_policer_add(struct ocelot_port *port,
+			    struct tcf_police *p)
+{
+	struct ocelot *ocelot = port->ocelot;
+	struct qos_policer_conf pp;
+
+	if (!p)
+		return -EINVAL;
+
+	netdev_dbg(port->dev,
+		   "result %d ewma_rate %u burst %lld mtu %u mtu_pktoks %lld\n",
+		   p->params->tcfp_result,
+		   p->params->tcfp_ewma_rate,
+		   p->params->tcfp_burst,
+		   p->params->tcfp_mtu,
+		   p->params->tcfp_mtu_ptoks);
+
+	if (p->params->rate_present)
+		netdev_dbg(port->dev,
+			   "rate: rate %llu mult %u over %u link %u shift %u\n",
+			   p->params->rate.rate_bytes_ps,
+			   p->params->rate.mult,
+			   p->params->rate.overhead,
+			   p->params->rate.linklayer,
+			   p->params->rate.shift);
+
+	if (p->params->peak_present)
+		netdev_dbg(port->dev,
+			   "peak: rate %llu mult %u over %u link %u shift %u\n",
+			   p->params->peak.rate_bytes_ps,
+			   p->params->peak.mult,
+			   p->params->peak.overhead,
+			   p->params->peak.linklayer,
+			   p->params->peak.shift);
+
+	memset(&pp, 0, sizeof(pp));
+
+	if (p->params->tcfp_ewma_rate) {
+		netdev_err(port->dev, "tcfp_ewma_rate is not supported\n");
+		return -EOPNOTSUPP;
+	}
+	if (p->params->peak_present) {
+		netdev_err(port->dev, "peakrate is not supported\n");
+		return -EOPNOTSUPP;
+	}
+	if (!p->params->rate_present) {
+		netdev_err(port->dev, "rate not specified\n");
+		return -EINVAL;
+	}
+	if (p->params->rate.overhead) {
+		pp.mode = MSCC_QOS_RATE_MODE_LINE;
+		pp.ipg = p->params->rate.overhead;
+	} else {
+		pp.mode = MSCC_QOS_RATE_MODE_DATA;
+	}
+
+	pp.pir = (u32)div_u64(p->params->rate.rate_bytes_ps, 1000) * 8;
+	pp.pbs = tc_calc_xmitsize(p->params->rate.rate_bytes_ps,
+				  PSCHED_NS2TICKS(p->params->tcfp_burst));
+	netdev_dbg(port->dev,
+		   "%s: port %u pir %u kbps, pbs %u bytes, ipg %u bytes\n",
+		   __func__, port->chip_port, pp.pir, pp.pbs, pp.ipg);
+
+	MSCC_RC(qos_policer_conf_set(port, POL_IX_PORT + port->chip_port, &pp));
+
+	ocelot_rmw_gix(ocelot,
+		       ANA_PORT_POL_CFG_PORT_POL_ENA |
+		       ANA_PORT_POL_CFG_POL_ORDER(POL_ORDER),
+		       ANA_PORT_POL_CFG_PORT_POL_ENA |
+		       ANA_PORT_POL_CFG_POL_ORDER_M,
+		       ANA_PORT_POL_CFG,
+		       port->chip_port);
+
+	return 0;
+}
+
+int ocelot_port_policer_del(struct ocelot_port *port)
+{
+	struct ocelot *ocelot = port->ocelot;
+	struct qos_policer_conf pp;
+
+	netdev_dbg(port->dev, "%s: port %u\n", __func__, port->chip_port);
+
+	memset(&pp, 0, sizeof(pp));
+	pp.mode = MSCC_QOS_RATE_MODE_DISABLED;
+
+	MSCC_RC(qos_policer_conf_set(port, POL_IX_PORT + port->chip_port, &pp));
+
+	ocelot_rmw_gix(ocelot, 0 |
+		       ANA_PORT_POL_CFG_POL_ORDER(POL_ORDER),
+		       ANA_PORT_POL_CFG_PORT_POL_ENA |
+		       ANA_PORT_POL_CFG_POL_ORDER_M,
+		       ANA_PORT_POL_CFG,
+		       port->chip_port);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mscc/ocelot_police.h b/drivers/net/ethernet/mscc/ocelot_police.h
new file mode 100644
index 000000000000..bc4dc34c684e
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_police.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/* Microsemi Ocelot Switch driver
+ *
+ * Copyright (c) 2019 Microsemi Corporation
+ */
+
+#ifndef _MSCC_OCELOT_POLICE_H_
+#define _MSCC_OCELOT_POLICE_H_
+
+#include <net/tc_act/tc_police.h>
+#include "ocelot.h"
+
+int ocelot_port_policer_add(struct ocelot_port *port, struct tcf_police *p);
+int ocelot_port_policer_del(struct ocelot_port *port);
+
+#endif /* _MSCC_OCELOT_POLICE_H_ */
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
new file mode 100644
index 000000000000..97b0a7bf5d06
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Microsemi Ocelot Switch TC driver
+ *
+ * Copyright (c) 2019 Microsemi Corporation
+ */
+
+#include "ocelot_tc.h"
+#include "ocelot_police.h"
+#include <net/pkt_cls.h>
+
+static int ocelot_setup_tc_cls_matchall(struct ocelot_port *port,
+					struct tc_cls_matchall_offload *f,
+					bool ingress)
+{
+	const struct tc_action *a;
+	int err;
+
+	netdev_dbg(port->dev,
+		   "%s: port %u cookie %lu\n",
+		   __func__, port->chip_port, f->cookie);
+	switch (f->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		if (!tcf_exts_has_one_action(f->exts)) {
+			netdev_err(port->dev, "only one action is supported\n");
+			return -EOPNOTSUPP;
+		}
+
+		a = tcf_exts_first_action(f->exts);
+
+		if (is_tcf_police(a)) {
+			if (!ingress)
+				return -EOPNOTSUPP;
+
+			if (port->tc.police_id &&
+			    port->tc.police_id != f->cookie) {
+				netdev_warn(port->dev,
+					    "Only one policer per port is supported\n");
+				return -EEXIST;
+			}
+
+			err = ocelot_port_policer_add(port, to_police(a));
+			if (err) {
+				netdev_err(port->dev, "Could not add policer\n");
+				return err;
+			}
+			port->tc.police_id = f->cookie;
+			return 0;
+		} else {
+			return -EOPNOTSUPP;
+		}
+	case TC_CLSMATCHALL_DESTROY:
+		if (port->tc.police_id != f->cookie)
+			return -ENOENT;
+
+		err = ocelot_port_policer_del(port);
+		if (err) {
+			netdev_err(port->dev, "Could not delete policer\n");
+			return err;
+		}
+		port->tc.police_id = 0;
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int ocelot_setup_tc_block_cb(enum tc_setup_type type,
+				    void *type_data,
+				    void *cb_priv, bool ingress)
+{
+	struct ocelot_port *port = cb_priv;
+
+	if (!tc_cls_can_offload_and_chain0(port->dev, type_data))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSMATCHALL:
+		netdev_dbg(port->dev, "tc_block_cb: TC_SETUP_CLSMATCHALL %s\n",
+			   ingress ? "ingress" : "egress");
+
+		return ocelot_setup_tc_cls_matchall(port, type_data, ingress);
+	case TC_SETUP_CLSFLOWER:
+		netdev_dbg(port->dev, "tc_block_cb: TC_SETUP_CLSFLOWER %s\n",
+			   ingress ? "ingress" : "egress");
+
+		return -EOPNOTSUPP;
+	default:
+		netdev_dbg(port->dev, "tc_block_cb: type %d %s\n",
+			   type,
+			   ingress ? "ingress" : "egress");
+
+		return -EOPNOTSUPP;
+	}
+}
+
+static int ocelot_setup_tc_block_cb_ig(enum tc_setup_type type,
+				       void *type_data,
+				       void *cb_priv)
+{
+	return ocelot_setup_tc_block_cb(type, type_data,
+					cb_priv, true);
+}
+
+static int ocelot_setup_tc_block_cb_eg(enum tc_setup_type type,
+				       void *type_data,
+				       void *cb_priv)
+{
+	return ocelot_setup_tc_block_cb(type, type_data,
+					cb_priv, false);
+}
+
+static int ocelot_setup_tc_block(struct ocelot_port *port,
+				 struct tc_block_offload *f)
+{
+	tc_setup_cb_t *cb;
+
+	netdev_dbg(port->dev, "tc_block command %d, binder_type %d\n",
+		   f->command, f->binder_type);
+
+	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		cb = ocelot_setup_tc_block_cb_ig;
+	else if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
+		cb = ocelot_setup_tc_block_cb_eg;
+	else
+		return -EOPNOTSUPP;
+
+	switch (f->command) {
+	case TC_BLOCK_BIND:
+		return tcf_block_cb_register(f->block, cb, port,
+					     port, f->extack);
+	case TC_BLOCK_UNBIND:
+		tcf_block_cb_unregister(f->block, cb, port);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+int ocelot_setup_tc(struct net_device *dev, enum tc_setup_type type,
+		    void *type_data)
+{
+	struct ocelot_port *port = netdev_priv(dev);
+
+	switch (type) {
+	case TC_SETUP_BLOCK:
+		return ocelot_setup_tc_block(port, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.h b/drivers/net/ethernet/mscc/ocelot_tc.h
new file mode 100644
index 000000000000..c905b98b6b4c
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_tc.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/* Microsemi Ocelot Switch driver
+ *
+ * Copyright (c) 2019 Microsemi Corporation
+ */
+
+#ifndef _MSCC_OCELOT_TC_H_
+#define _MSCC_OCELOT_TC_H_
+
+#include <linux/netdevice.h>
+
+struct ocelot_port_tc {
+	unsigned long police_id;
+};
+
+int ocelot_setup_tc(struct net_device *dev, enum tc_setup_type type,
+		    void *type_data);
+
+#endif /* _MSCC_OCELOT_TC_H_ */
-- 
2.17.1

