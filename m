Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B56F45A434
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 14:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbhKWN7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 08:59:04 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:61051 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237261AbhKWN7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 08:59:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637675753; x=1669211753;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lKn/uI4gjxEpmUWF275O/o9mWH24INhzYTmY3e7nZk0=;
  b=R1jetZ189JLUcp2Vxsd9ycr/JiVwq0y56Z7/SUOtfQv+26YfQqhzc/ww
   n7+/StZuth2+uxl52J1TIISBq2brx/aIETyIJgqARKmYVn17BkC8dJudA
   ED69UddsRxnoKq1GNGl0mq4Ugq222wSNurVO8ExIlACT4D09hY+Fhpv3O
   /wl/1qBp/rMjFUNq52j+pLVOjENajv3VhgZr0T+pDD1idgFdCf7EPriNW
   3j/MKdDxeLC4fKMGqp3BBwSf89K/h/GR4tX/ZBqM3gn9m5cnIL/wBcXOA
   /qMbPl8fn/6AD1jNZeFu+4VtGq6Kl0BpsnP0kbGOEvE/9MIIHIFhZBTfn
   Q==;
IronPort-SDR: ruBNY/BwxeiiNVksCF9xIlPRX2qF5aImjBcmBUPjH9ppROPIZy0+kZ6scjKAH/7TUj2nVfJ/xr
 8b6ntKpzCXwRAHYUyPSsyZw8Pr05KjJ8vnltcVGEVtK1Ob+Hzw+DuKsIykrILsasyo5gqiZt/4
 9oin8PcsxTfVCIpLhZexKuC5yBC779N6BfJMFOuU+bsomNSGahSpJV+icNaSPmwhYOUolaqkiC
 PuBaoZMFnqKRtIv2NjBbaHQ6WyUo7ZOUxC4UbgEw9ajFRwq2sHiSkxc4BI0UvlucmlGBbdjjmw
 RKljvXBd6wAQHJzfoKpkD2oa
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="137464852"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2021 06:55:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 23 Nov 2021 06:55:52 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 23 Nov 2021 06:55:48 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 3/6] net: lan966x: add port module support
Date:   Tue, 23 Nov 2021 14:55:14 +0100
Message-ID: <20211123135517.4037557-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123135517.4037557-1-horatiu.vultur@microchip.com>
References: <20211123135517.4037557-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for netdev and phylink in the switch. The
injection + extraction is register based. This will be replaced with DMA
accees.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_ifh.h  | 173 ++++++
 .../ethernet/microchip/lan966x/lan966x_main.c | 511 +++++++++++++++++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  47 ++
 .../microchip/lan966x/lan966x_phylink.c       |  96 ++++
 .../ethernet/microchip/lan966x/lan966x_port.c | 422 +++++++++++++++
 6 files changed, 1246 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_port.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 7ea90410a0b2..e18c9b2d0bb7 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 
-lan966x-switch-objs  := lan966x_main.o
+lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h b/drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h
new file mode 100644
index 000000000000..ca3314789d18
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h
@@ -0,0 +1,173 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef __LAN966X_IFH_H__
+#define __LAN966X_IFH_H__
+
+/* Fields with description (*) should just be cleared upon injection
+ * IFH is transmitted MSByte first (Highest bit pos sent as MSB of first byte)
+ */
+
+#define IFH_LEN                      7
+
+/* Timestamp for frame */
+#define IFH_POS_TIMESTAMP            192
+
+/* Bypass analyzer with a prefilled IFH */
+#define IFH_POS_BYPASS               191
+
+/* Masqueraded injection with masq_port defining logical source port */
+#define IFH_POS_MASQ                 190
+
+/* Masqueraded port number for injection */
+#define IFH_POS_MASQ_PORT            186
+
+/* Frame length (*) */
+#define IFH_POS_LEN                  178
+
+/* Cell filling mode. Full(0),Etype(1), LlctOpt(2), Llct(3) */
+#define IFH_POS_WRDMODE              176
+
+/* Frame has 16 bits rtag removed compared to line data */
+#define IFH_POS_RTAG48               175
+
+/* Frame has a redundancy tag */
+#define IFH_POS_HAS_RED_TAG          174
+
+/* Frame has been cut through forwarded (*) */
+#define IFH_POS_CUTTHRU              173
+
+/* Rewriter command */
+#define IFH_POS_REW_CMD              163
+
+/* Enable OAM-related rewriting. PDU_TYPE encodes OAM type. */
+#define IFH_POS_REW_OAM              162
+
+/* PDU type. Encoding: (0-NONE, 1-Y1731_CCM, 2-MRP_TST, 3-MRP_ITST, 4-DLR_BCN,
+ * 5-DLR_ADV, 6-RTE_NULL_INJ, 7-IPV4, 8-IPV6, 9-Y1731_NON_CCM).
+ */
+#define IFH_POS_PDU_TYPE             158
+
+/* Update FCS before transmission */
+#define IFH_POS_FCS_UPD              157
+
+/* Classified DSCP value of frame */
+#define IFH_POS_DSCP                 151
+
+/* Yellow indication */
+#define IFH_POS_DP                   150
+
+/* Process in RTE/inbound */
+#define IFH_POS_RTE_INB_UPDATE       149
+
+/* Number of tags to pop from frame */
+#define IFH_POS_POP_CNT              147
+
+/* Number of tags in front of the ethertype */
+#define IFH_POS_ETYPE_OFS            145
+
+/* Logical source port of frame (*) */
+#define IFH_POS_SRCPORT              141
+
+/* Sequence number in redundancy tag */
+#define IFH_POS_SEQ_NUM              120
+
+/* Stagd flag and classified TCI of frame (PCP/DEI/VID) */
+#define IFH_POS_TCI                  103
+
+/* Classified internal priority for queuing */
+#define IFH_POS_QOS_CLASS            100
+
+/* Bit mask with eight cpu copy classses */
+#define IFH_POS_CPUQ                 92
+
+/* Relearn + learn flags (*) */
+#define IFH_POS_LEARN_FLAGS          90
+
+/* SFLOW identifier for frame (0-8: Tx port, 9: Rx sampling, 15: No sampling) */
+#define IFH_POS_SFLOW_ID             86
+
+/* Set if an ACL/S2 rule was hit (*).
+ * Super priority: acl_hit=0 and acl_hit(4)=1.
+ */
+#define IFH_POS_ACL_HIT              85
+
+/* S2 rule index hit (*) */
+#define IFH_POS_ACL_IDX              79
+
+/* ISDX as classified by S1 */
+#define IFH_POS_ISDX                 71
+
+/* Destination ports for frame */
+#define IFH_POS_DSTS                 62
+
+/* Storm policer to be applied: None/Uni/Multi/Broad (*) */
+#define IFH_POS_FLOOD                60
+
+/* Redundancy tag operation */
+#define IFH_POS_SEQ_OP               58
+
+/* Classified internal priority for resourcemgt, tagging etc */
+#define IFH_POS_IPV                  55
+
+/* Frame is for AFI use */
+#define IFH_POS_AFI                  54
+
+/* Internal aging value (*) */
+#define IFH_POS_AGED                 52
+
+/* RTP Identifier */
+#define IFH_POS_RTP_ID               42
+
+/* RTP MRPD flow */
+#define IFH_POS_RTP_SUBID            41
+
+/* Profinet DataStatus or opcua GroupVersion MSB */
+#define IFH_POS_PN_DATA_STATUS       33
+
+/* Profinet transfer status (1 iff the status is 0) */
+#define IFH_POS_PN_TRANSF_STATUS_ZERO 32
+
+/* Profinet cycle counter or opcua NetworkMessageNumber */
+#define IFH_POS_PN_CC                16
+
+#define IFH_WID_TIMESTAMP            32
+#define IFH_WID_BYPASS               1
+#define IFH_WID_MASQ                 1
+#define IFH_WID_MASQ_PORT            4
+#define IFH_WID_LEN                  14
+#define IFH_WID_WRDMODE              2
+#define IFH_WID_RTAG48               1
+#define IFH_WID_HAS_RED_TAG          1
+#define IFH_WID_CUTTHRU              1
+#define IFH_WID_REW_CMD              10
+#define IFH_WID_REW_OAM              1
+#define IFH_WID_PDU_TYPE             4
+#define IFH_WID_FCS_UPD              1
+#define IFH_WID_DSCP                 6
+#define IFH_WID_DP                   1
+#define IFH_WID_RTE_INB_UPDATE       1
+#define IFH_WID_POP_CNT              2
+#define IFH_WID_ETYPE_OFS            2
+#define IFH_WID_SRCPORT              4
+#define IFH_WID_SEQ_NUM              16
+#define IFH_WID_TCI                  17
+#define IFH_WID_QOS_CLASS            3
+#define IFH_WID_CPUQ                 8
+#define IFH_WID_LEARN_FLAGS          2
+#define IFH_WID_SFLOW_ID             4
+#define IFH_WID_ACL_HIT              1
+#define IFH_WID_ACL_IDX              6
+#define IFH_WID_ISDX                 8
+#define IFH_WID_DSTS                 9
+#define IFH_WID_FLOOD                2
+#define IFH_WID_SEQ_OP               2
+#define IFH_WID_IPV                  3
+#define IFH_WID_AFI                  1
+#define IFH_WID_AGED                 2
+#define IFH_WID_RTP_ID               10
+#define IFH_WID_RTP_SUBID            1
+#define IFH_WID_PN_DATA_STATUS       8
+#define IFH_WID_PN_TRANSF_STATUS_ZERO 1
+#define IFH_WID_PN_CC                16
+
+#endif /* __LAN966X_IFH_H__ */
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index c6bdbb065f07..44d71e789c74 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -3,13 +3,25 @@
 #include <asm/memory.h>
 #include <linux/module.h>
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
 #include <linux/iopoll.h>
 #include <linux/of_platform.h>
 #include <linux/of_net.h>
+#include <linux/phy/phy.h>
 #include <linux/reset.h>
 
 #include "lan966x_main.h"
 
+#define XTR_EOF_0			0x00000080U
+#define XTR_EOF_1			0x01000080U
+#define XTR_EOF_2			0x02000080U
+#define XTR_EOF_3			0x03000080U
+#define XTR_PRUNED			0x04000080U
+#define XTR_ABORT			0x05000080U
+#define XTR_ESCAPE			0x06000080U
+#define XTR_NOT_READY			0x07000080U
+#define XTR_VALID_BYTES(x)		(4 - (((x) >> 24) & 3))
+
 #define READL_SLEEP_US			10
 #define READL_TIMEOUT_US		100000000
 
@@ -88,21 +100,472 @@ static int lan966x_create_targets(struct platform_device *pdev,
 	return 0;
 }
 
+static int lan966x_port_get_phys_port_name(struct net_device *dev,
+					   char *buf, size_t len)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	int ret;
+
+	ret = snprintf(buf, len, "p%d", port->chip_port);
+	if (ret >= len)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int lan966x_port_open(struct net_device *dev)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	int err;
+
+	if (port->serdes) {
+		err = phy_set_mode_ext(port->serdes, PHY_MODE_ETHERNET,
+				       port->config.phy_mode);
+		if (err) {
+			netdev_err(dev, "Could not set mode of SerDes\n");
+			return err;
+		}
+	}
+
+	/* Enable receiving frames on the port, and activate auto-learning of
+	 * MAC addresses.
+	 */
+	lan_rmw(ANA_PORT_CFG_LEARNAUTO_SET(1) |
+		ANA_PORT_CFG_RECV_ENA_SET(1) |
+		ANA_PORT_CFG_PORTID_VAL_SET(port->chip_port),
+		ANA_PORT_CFG_LEARNAUTO |
+		ANA_PORT_CFG_RECV_ENA |
+		ANA_PORT_CFG_PORTID_VAL,
+		lan966x, ANA_PORT_CFG(port->chip_port));
+
+	err = phylink_fwnode_phy_connect(port->phylink, port->fwnode, 0);
+	if (err) {
+		netdev_err(dev, "Could not attach to PHY\n");
+		return err;
+	}
+
+	phylink_start(port->phylink);
+
+	return 0;
+}
+
+static int lan966x_port_stop(struct net_device *dev)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+
+	lan966x_port_config_down(port);
+	phylink_stop(port->phylink);
+	phylink_disconnect_phy(port->phylink);
+
+	return 0;
+}
+
+static void lan966x_ifh_inject(u32 *ifh, size_t val, size_t pos, size_t length)
+{
+	int i;
+
+	for (i = pos; i < pos + length; ++i) {
+		if (val & BIT(i - pos))
+			ifh[IFH_LEN - i / 32 - 1] |= BIT(i % 32);
+		else
+			ifh[IFH_LEN - i / 32 - 1] &= ~(BIT(i % 32));
+	}
+}
+
+static void lan966x_gen_ifh(u32 *ifh, struct lan966x_frame_info *info,
+			    struct lan966x *lan966x)
+{
+	lan966x_ifh_inject(ifh, 1, IFH_POS_BYPASS, 1);
+	lan966x_ifh_inject(ifh, info->port, IFH_POS_DSTS, IFH_WID_DSTS);
+	lan966x_ifh_inject(ifh, info->qos_class, IFH_POS_QOS_CLASS,
+			   IFH_WID_QOS_CLASS);
+	lan966x_ifh_inject(ifh, info->ipv, IFH_POS_IPV, IFH_WID_IPV);
+}
+
+static int lan966x_port_ifh_xmit(struct sk_buff *skb,
+				 struct lan966x_frame_info *info,
+				 struct net_device *dev)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	u32 i, count, last;
+	u32 ifh[IFH_LEN];
+	u8 grp = 0;
+	u32 val;
+
+	val = lan_rd(lan966x, QS_INJ_STATUS);
+	if (!(QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp)) ||
+	    (QS_INJ_STATUS_WMARK_REACHED_GET(val) & BIT(grp)))
+		return NETDEV_TX_BUSY;
+
+	/* Write start of frame */
+	lan_wr(QS_INJ_CTRL_GAP_SIZE_SET(1) |
+	       QS_INJ_CTRL_SOF_SET(1),
+	       lan966x, QS_INJ_CTRL(grp));
+
+	memset(ifh, 0x0, sizeof(u32) * IFH_LEN);
+	lan966x_gen_ifh(ifh, info, lan966x);
+
+	/* Write IFH header */
+	for (i = 0; i < IFH_LEN; ++i) {
+		/* Wait until the fifo is ready */
+		while (!(QS_INJ_STATUS_FIFO_RDY_GET(lan_rd(lan966x, QS_INJ_STATUS)) &
+			 BIT(grp)))
+			;
+
+		lan_wr((__force u32)cpu_to_be32(ifh[i]), lan966x,
+		       QS_INJ_WR(grp));
+	}
+
+	/* Write frame */
+	count = DIV_ROUND_UP(skb->len, 4);
+	last = skb->len % 4;
+	for (i = 0; i < count; ++i) {
+		/* Wait until the fifo is ready */
+		while (!(QS_INJ_STATUS_FIFO_RDY_GET(lan_rd(lan966x, QS_INJ_STATUS)) &
+			 BIT(grp)))
+			;
+
+		lan_wr(((u32 *)skb->data)[i], lan966x, QS_INJ_WR(grp));
+	}
+
+	/* Add padding */
+	while (i < (LAN966X_BUFFER_MIN_SZ / 4)) {
+		/* Wait until the fifo is ready */
+		while (!(QS_INJ_STATUS_FIFO_RDY_GET(lan_rd(lan966x, QS_INJ_STATUS)) &
+			 BIT(grp)))
+			;
+
+		lan_wr(0, lan966x, QS_INJ_WR(grp));
+		++i;
+	}
+
+	/* Inidcate EOF and valid bytes in the last word */
+	lan_wr(QS_INJ_CTRL_GAP_SIZE_SET(1) |
+	       QS_INJ_CTRL_VLD_BYTES_SET(skb->len < LAN966X_BUFFER_MIN_SZ ?
+				     0 : last) |
+	       QS_INJ_CTRL_EOF_SET(1),
+	       lan966x, QS_INJ_CTRL(grp));
+
+	/* Add dummy CRC */
+	lan_wr(0, lan966x, QS_INJ_WR(grp));
+	skb_tx_timestamp(skb);
+
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
+
+	dev_consume_skb_any(skb);
+	return NETDEV_TX_OK;
+}
+
+static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x_frame_info info;
+
+	memset(&info, 0, sizeof(info));
+
+	info.port = BIT(port->chip_port);
+	info.vid = skb_vlan_tag_get(skb);
+
+	/* Adjust frame priority to priority queue */
+	info.qos_class = skb->priority >= 0x7 ? 0x7 : skb->priority;
+	info.ipv = info.qos_class;
+
+	return lan966x_port_ifh_xmit(skb, &info, dev);
+}
+
+static void lan966x_set_promisc(struct lan966x_port *port, bool enable)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	lan_rmw(ANA_CPU_FWD_CFG_SRC_COPY_ENA_SET(enable),
+		ANA_CPU_FWD_CFG_SRC_COPY_ENA,
+		lan966x, ANA_CPU_FWD_CFG(port->chip_port));
+}
+
+static void lan966x_port_change_rx_flags(struct net_device *dev, int flags)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+
+	if (!(flags & IFF_PROMISC))
+		return;
+
+	if (dev->flags & IFF_PROMISC)
+		lan966x_set_promisc(port, true);
+	else
+		lan966x_set_promisc(port, false);
+}
+
+static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+
+	lan_wr(DEV_MAC_MAXLEN_CFG_MAX_LEN_SET(new_mtu),
+	       lan966x, DEV_MAC_MAXLEN_CFG(port->chip_port));
+	dev->mtu = new_mtu;
+
+	return 0;
+}
+
+static const struct net_device_ops lan966x_port_netdev_ops = {
+	.ndo_open			= lan966x_port_open,
+	.ndo_stop			= lan966x_port_stop,
+	.ndo_start_xmit			= lan966x_port_xmit,
+	.ndo_change_rx_flags		= lan966x_port_change_rx_flags,
+	.ndo_change_mtu			= lan966x_port_change_mtu,
+	.ndo_get_phys_port_name		= lan966x_port_get_phys_port_name,
+};
+
+static int lan966x_ifh_extract(u32 *ifh, size_t pos, size_t length)
+{
+	int val = 0;
+	int i;
+
+	for (i = pos; i < pos + length; ++i)
+		val |= ((ifh[IFH_LEN - i / 32 - 1] & BIT(i % 32)) >>
+			(i % 32)) << (i - pos);
+
+	return val;
+}
+
+static int lan966x_parse_ifh(u32 *ifh, struct lan966x_frame_info *info)
+{
+	int i;
+
+	/* The IFH is in network order, switch to CPU order */
+	for (i = 0; i < IFH_LEN; i++)
+		ifh[i] = ntohl((__force __be32)ifh[i]);
+
+	info->len = lan966x_ifh_extract(ifh, IFH_POS_LEN, IFH_WID_LEN);
+	info->port = lan966x_ifh_extract(ifh, IFH_POS_SRCPORT, IFH_WID_SRCPORT);
+
+	info->vid = lan966x_ifh_extract(ifh, IFH_POS_TCI, IFH_WID_TCI);
+	info->timestamp = lan966x_ifh_extract(ifh, IFH_POS_TIMESTAMP,
+					      IFH_WID_TIMESTAMP);
+	return 0;
+}
+
+static int lan966x_rx_frame_word(struct lan966x *lan966x, u8 grp, bool ifh,
+				 u32 *rval)
+{
+	u32 bytes_valid;
+	u32 val;
+
+	val = lan_rd(lan966x, QS_XTR_RD(grp));
+	if (val == XTR_NOT_READY) {
+		if (ifh)
+			return -EIO;
+
+		do {
+			val = lan_rd(lan966x, QS_XTR_RD(grp));
+		} while (val == XTR_NOT_READY);
+	}
+
+	switch (val) {
+	case XTR_ABORT:
+		return -EIO;
+	case XTR_EOF_0:
+	case XTR_EOF_1:
+	case XTR_EOF_2:
+	case XTR_EOF_3:
+	case XTR_PRUNED:
+		bytes_valid = XTR_VALID_BYTES(val);
+		val = lan_rd(lan966x, QS_XTR_RD(grp));
+		if (val == XTR_ESCAPE)
+			*rval = lan_rd(lan966x, QS_XTR_RD(grp));
+		else
+			*rval = val;
+
+		return bytes_valid;
+	case XTR_ESCAPE:
+		*rval = lan_rd(lan966x, QS_XTR_RD(grp));
+
+		return 4;
+	default:
+		*rval = val;
+
+		return 4;
+	}
+}
+
+static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
+{
+	struct lan966x *lan966x = args;
+	int i, grp = 0, err = 0;
+
+	if (!(lan_rd(lan966x, QS_XTR_DATA_PRESENT) & BIT(grp)))
+		return IRQ_NONE;
+
+	do {
+		u32 ifh[IFH_LEN] = { 0 };
+		struct lan966x_frame_info info;
+		struct net_device *dev;
+		int sz, len, buf_len;
+		struct sk_buff *skb;
+		u32 *buf;
+		u32 val;
+
+		for (i = 0; i < IFH_LEN; i++) {
+			err = lan966x_rx_frame_word(lan966x, grp, true,
+						    &ifh[i]);
+			if (err != 4)
+				break;
+		}
+
+		if (err != 4)
+			break;
+
+		err = 0;
+
+		lan966x_parse_ifh(ifh, &info);
+		WARN_ON(info.port >= lan966x->num_phys_ports);
+
+		dev = lan966x->ports[info.port]->dev;
+		skb = netdev_alloc_skb(dev, info.len);
+		if (unlikely(!skb)) {
+			netdev_err(dev, "Unable to allocate sk_buff\n");
+			err = -ENOMEM;
+			break;
+		}
+		buf_len = info.len - ETH_FCS_LEN;
+		buf = (u32 *)skb_put(skb, buf_len);
+
+		len = 0;
+		do {
+			sz = lan966x_rx_frame_word(lan966x, grp, false, &val);
+			*buf++ = val;
+			len += sz;
+		} while (len < buf_len);
+
+		/* Read the FCS */
+		sz = lan966x_rx_frame_word(lan966x, grp, false, &val);
+
+		/* Update the statistics if part of the FCS was read before */
+		len -= ETH_FCS_LEN - sz;
+
+		if (unlikely(dev->features & NETIF_F_RXFCS)) {
+			buf = (u32 *)skb_put(skb, ETH_FCS_LEN);
+			*buf = val;
+		}
+
+		if (sz < 0) {
+			err = sz;
+			break;
+		}
+
+		skb->protocol = eth_type_trans(skb, dev);
+
+		netif_rx_ni(skb);
+		dev->stats.rx_bytes += len;
+		dev->stats.rx_packets++;
+	} while (lan_rd(lan966x, QS_XTR_DATA_PRESENT) & BIT(grp));
+
+	if (err)
+		while (lan_rd(lan966x, QS_XTR_DATA_PRESENT) & BIT(grp))
+			lan_rd(lan966x, QS_XTR_RD(grp));
+
+	return IRQ_HANDLED;
+}
+
+static void lan966x_cleanup_ports(struct lan966x *lan966x)
+{
+	struct lan966x_port *port;
+	int portno;
+
+	for (portno = 0; portno < lan966x->num_phys_ports; portno++) {
+		port = lan966x->ports[portno];
+		if (!port)
+			continue;
+
+		if (port->phylink) {
+			rtnl_lock();
+			lan966x_port_stop(port->dev);
+			rtnl_unlock();
+			phylink_destroy(port->phylink);
+			port->phylink = NULL;
+		}
+
+		if (port->fwnode)
+			fwnode_handle_put(port->fwnode);
+
+		if (port->dev)
+			unregister_netdev(port->dev);
+	}
+}
+
 static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
-			      phy_interface_t phy_mode)
+			      phy_interface_t phy_mode,
+			      struct fwnode_handle *portnp)
 {
 	struct lan966x_port *port;
+	struct phylink *phylink;
+	struct net_device *dev;
+	int err;
 
 	if (p >= lan966x->num_phys_ports)
 		return -EINVAL;
 
-	port = devm_kzalloc(lan966x->dev, sizeof(*port), GFP_KERNEL);
+	dev = devm_alloc_etherdev_mqs(lan966x->dev,
+				      sizeof(struct lan966x_port), 8, 1);
+	if (!dev)
+		return -ENOMEM;
 
+	SET_NETDEV_DEV(dev, lan966x->dev);
+	port = netdev_priv(dev);
+	port->dev = dev;
 	port->lan966x = lan966x;
 	port->chip_port = p;
 	port->pvid = PORT_PVID;
 	lan966x->ports[p] = port;
 
+	dev->max_mtu = ETH_MAX_MTU;
+
+	dev->netdev_ops = &lan966x_port_netdev_ops;
+	dev->needed_headroom = IFH_LEN * sizeof(u32);
+
+	port->phylink_config.dev = &port->dev->dev;
+	port->phylink_config.type = PHYLINK_NETDEV;
+	port->phylink_config.pcs_poll = true;
+	port->phylink_pcs.poll = true;
+	port->phylink_pcs.ops = &lan966x_phylink_pcs_ops;
+
+	port->phylink_config.mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000FD | MAC_2500FD;
+
+	__set_bit(PHY_INTERFACE_MODE_MII,
+		  port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_GMII,
+		  port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_SGMII,
+		  port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_QSGMII,
+		  port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+		  port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_2500BASEX,
+		  port->phylink_config.supported_interfaces);
+
+	phylink = phylink_create(&port->phylink_config,
+				 portnp,
+				 phy_mode,
+				 &lan966x_phylink_mac_ops);
+	if (IS_ERR(phylink)) {
+		port->dev = NULL;
+		return PTR_ERR(phylink);
+	}
+
+	port->phylink = phylink;
+	phylink_set_pcs(phylink, &port->phylink_pcs);
+
+	err = register_netdev(dev);
+	if (err) {
+		dev_err(lan966x->dev, "register_netdev failed\n");
+		return err;
+	}
+
 	return 0;
 }
 
@@ -316,28 +779,68 @@ static int lan966x_probe(struct platform_device *pdev)
 	/* There QS system has 32KB of memory */
 	lan966x->shared_queue_sz = LAN966X_BUFFER_MEMORY;
 
+	/* set irq */
+	lan966x->xtr_irq = platform_get_irq_byname(pdev, "xtr");
+	if (lan966x->xtr_irq <= 0)
+		return -EINVAL;
+
+	err = devm_request_threaded_irq(&pdev->dev, lan966x->xtr_irq, NULL,
+					lan966x_xtr_irq_handler, IRQF_ONESHOT,
+					"frame extraction", lan966x);
+	if (err) {
+		pr_err("Unable to use xtr irq");
+		return -ENODEV;
+	}
+
 	/* init switch */
 	lan966x_init(lan966x);
 
 	/* go over the child nodes */
 	fwnode_for_each_available_child_node(ports, portnp) {
 		phy_interface_t phy_mode;
+		struct phy *serdes;
 		u32 p;
 
 		if (fwnode_property_read_u32(portnp, "reg", &p))
 			continue;
 
 		phy_mode = fwnode_get_phy_mode(portnp);
-		err = lan966x_probe_port(lan966x, p, phy_mode);
+		err = lan966x_probe_port(lan966x, p, phy_mode, portnp);
 		if (err)
-			return err;
+			goto cleanup_ports;
+
+		/* Read needed configuration */
+		lan966x->ports[p]->config.phy_mode = phy_mode;
+		lan966x->ports[p]->config.portmode = phy_mode;
+		lan966x->ports[p]->fwnode = fwnode_handle_get(portnp);
+
+		serdes = devm_of_phy_get(lan966x->dev, to_of_node(portnp), NULL);
+		if (!IS_ERR(serdes))
+			lan966x->ports[p]->serdes = serdes;
+
+		lan966x_port_init(lan966x->ports[p]);
 	}
 
 	return 0;
+
+cleanup_ports:
+	fwnode_handle_put(portnp);
+
+	disable_irq(lan966x->xtr_irq);
+	lan966x->xtr_irq = -ENXIO;
+	lan966x_cleanup_ports(lan966x);
+
+	return err;
 }
 
 static int lan966x_remove(struct platform_device *pdev)
 {
+	struct lan966x *lan966x = platform_get_drvdata(pdev);
+
+	disable_irq(lan966x->xtr_irq);
+	lan966x->xtr_irq = -ENXIO;
+	lan966x_cleanup_ports(lan966x);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 7a1ff9d19fbf..ce2798db0449 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -3,7 +3,12 @@
 #ifndef __LAN966X_MAIN_H__
 #define __LAN966X_MAIN_H__
 
+#include <linux/etherdevice.h>
+#include <linux/phy.h>
+#include <linux/phylink.h>
+
 #include "lan966x_regs.h"
+#include "lan966x_ifh.h"
 
 #define LAN966X_BUFFER_CELL_SZ		64
 #define LAN966X_BUFFER_MEMORY		(160 * 1024)
@@ -35,6 +40,15 @@
 
 struct lan966x_port;
 
+struct lan966x_frame_info {
+	u32 len;
+	u16 port; /* Bit mask */
+	u16 vid;
+	u32 timestamp;
+	u8 qos_class;
+	u8 ipv;
+};
+
 struct lan966x {
 	struct device *dev;
 
@@ -44,15 +58,48 @@ struct lan966x {
 	void __iomem *regs[NUM_TARGETS];
 
 	int shared_queue_sz;
+
+	/* interrupts */
+	int xtr_irq;
+};
+
+struct lan966x_port_config {
+	phy_interface_t portmode;
+	phy_interface_t phy_mode;
+	const unsigned long *advertising;
+	int speed;
+	int duplex;
+	u32 pause;
+	bool inband;
+	bool autoneg;
 };
 
 struct lan966x_port {
+	struct net_device *dev;
 	struct lan966x *lan966x;
 
 	u8 chip_port;
 	u16 pvid;
+
+	struct phylink_config phylink_config;
+	struct phylink_pcs phylink_pcs;
+	struct lan966x_port_config config;
+	struct phylink *phylink;
+	struct phy *serdes;
+	struct fwnode_handle *fwnode;
 };
 
+extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
+extern const struct phylink_pcs_ops lan966x_phylink_pcs_ops;
+
+void lan966x_port_config_down(struct lan966x_port *port);
+void lan966x_port_config_up(struct lan966x_port *port);
+void lan966x_port_status_get(struct lan966x_port *port,
+			     struct phylink_link_state *state);
+int lan966x_port_pcs_set(struct lan966x_port *port,
+			 struct lan966x_port_config *config);
+void lan966x_port_init(struct lan966x_port *port);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
new file mode 100644
index 000000000000..7e8187155e4a
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <linux/module.h>
+#include <linux/phylink.h>
+#include <linux/device.h>
+#include <linux/netdevice.h>
+#include <linux/sfp.h>
+
+#include "lan966x_main.h"
+
+static void lan966x_phylink_mac_config(struct phylink_config *config,
+				       unsigned int mode,
+				       const struct phylink_link_state *state)
+{
+}
+
+static void lan966x_phylink_mac_link_up(struct phylink_config *config,
+					struct phy_device *phy,
+					unsigned int mode,
+					phy_interface_t interface,
+					int speed, int duplex,
+					bool tx_pause, bool rx_pause)
+{
+	struct lan966x_port *port = netdev_priv(to_net_dev(config->dev));
+	struct lan966x_port_config *port_config = &port->config;
+
+	port_config->duplex = duplex;
+	port_config->speed = speed;
+	port_config->pause = 0;
+	port_config->pause |= tx_pause ? MLO_PAUSE_TX : 0;
+	port_config->pause |= rx_pause ? MLO_PAUSE_RX : 0;
+
+	lan966x_port_config_up(port);
+}
+
+static void lan966x_phylink_mac_link_down(struct phylink_config *config,
+					  unsigned int mode,
+					  phy_interface_t interface)
+{
+}
+
+static struct lan966x_port *lan966x_pcs_to_port(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct lan966x_port, phylink_pcs);
+}
+
+static void lan966x_pcs_get_state(struct phylink_pcs *pcs,
+				  struct phylink_link_state *state)
+{
+	struct lan966x_port *port = lan966x_pcs_to_port(pcs);
+
+	lan966x_port_status_get(port, state);
+}
+
+static int lan966x_pcs_config(struct phylink_pcs *pcs,
+			      unsigned int mode,
+			      phy_interface_t interface,
+			      const unsigned long *advertising,
+			      bool permit_pause_to_mac)
+{
+	struct lan966x_port *port = lan966x_pcs_to_port(pcs);
+	struct lan966x_port_config config;
+	int ret;
+
+	memset(&config, 0, sizeof(config));
+
+	config = port->config;
+	config.portmode = interface;
+	config.inband = phylink_autoneg_inband(mode);
+	config.autoneg = phylink_test(advertising, Autoneg);
+	config.advertising = advertising;
+
+	ret = lan966x_port_pcs_set(port, &config);
+	if (ret)
+		netdev_err(port->dev, "port PCS config failed: %d\n", ret);
+
+	return ret;
+}
+
+static void lan966x_pcs_aneg_restart(struct phylink_pcs *pcs)
+{
+	/* Currently not used */
+}
+
+const struct phylink_mac_ops lan966x_phylink_mac_ops = {
+	.validate = phylink_generic_validate,
+	.mac_config = lan966x_phylink_mac_config,
+	.mac_link_down = lan966x_phylink_mac_link_down,
+	.mac_link_up = lan966x_phylink_mac_link_up,
+};
+
+const struct phylink_pcs_ops lan966x_phylink_pcs_ops = {
+	.pcs_get_state = lan966x_pcs_get_state,
+	.pcs_config = lan966x_pcs_config,
+	.pcs_an_restart = lan966x_pcs_aneg_restart,
+};
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
new file mode 100644
index 000000000000..ca1b0c8d1bf5
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -0,0 +1,422 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <linux/netdevice.h>
+#include <linux/phy/phy.h>
+
+#include "lan966x_main.h"
+
+/* Watermark encode */
+#define MULTIPLIER_BIT BIT(8)
+static u32 lan966x_wm_enc(u32 value)
+{
+	value /= LAN966X_BUFFER_CELL_SZ;
+
+	if (value >= MULTIPLIER_BIT) {
+		value /= 16;
+		if (value >= MULTIPLIER_BIT)
+			value = (MULTIPLIER_BIT - 1);
+
+		value |= MULTIPLIER_BIT;
+	}
+
+	return value;
+}
+
+static void lan966x_port_link_down(struct lan966x_port *port)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u32 val, delay = 0;
+
+	/* 0.5: Disable any AFI */
+	lan_rmw(AFI_PORT_CFG_FC_SKIP_TTI_INJ_SET(1) |
+		AFI_PORT_CFG_FRM_OUT_MAX_SET(0),
+		AFI_PORT_CFG_FC_SKIP_TTI_INJ |
+		AFI_PORT_CFG_FRM_OUT_MAX,
+		lan966x, AFI_PORT_CFG(port->chip_port));
+
+	/* wait for reg afi_port_frm_out to become 0 for the port */
+	while (true) {
+		val = lan_rd(lan966x, AFI_PORT_FRM_OUT(port->chip_port));
+		if (!AFI_PORT_FRM_OUT_FRM_OUT_CNT_GET(val))
+			break;
+
+		usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
+		delay++;
+		if (delay == 2000) {
+			pr_err("AFI timeout chip port %u", port->chip_port);
+			break;
+		}
+	}
+
+	delay = 0;
+
+	/* 1: Reset the PCS Rx clock domain  */
+	lan_rmw(DEV_CLOCK_CFG_PCS_RX_RST_SET(1),
+		DEV_CLOCK_CFG_PCS_RX_RST,
+		lan966x, DEV_CLOCK_CFG(port->chip_port));
+
+	/* 2: Disable MAC frame reception */
+	lan_rmw(DEV_MAC_ENA_CFG_RX_ENA_SET(0),
+		DEV_MAC_ENA_CFG_RX_ENA,
+		lan966x, DEV_MAC_ENA_CFG(port->chip_port));
+
+	/* 3: Disable traffic being sent to or from switch port */
+	lan_rmw(QSYS_SW_PORT_MODE_PORT_ENA_SET(0),
+		QSYS_SW_PORT_MODE_PORT_ENA,
+		lan966x, QSYS_SW_PORT_MODE(port->chip_port));
+
+	/* 4: Disable dequeuing from the egress queues  */
+	lan_rmw(QSYS_PORT_MODE_DEQUEUE_DIS_SET(1),
+		QSYS_PORT_MODE_DEQUEUE_DIS,
+		lan966x, QSYS_PORT_MODE(port->chip_port));
+
+	/* 5: Disable Flowcontrol */
+	lan_rmw(SYS_PAUSE_CFG_PAUSE_ENA_SET(0),
+		SYS_PAUSE_CFG_PAUSE_ENA,
+		lan966x, SYS_PAUSE_CFG(port->chip_port));
+
+	/* 5.1: Disable PFC */
+	lan_rmw(QSYS_SW_PORT_MODE_TX_PFC_ENA_SET(0),
+		QSYS_SW_PORT_MODE_TX_PFC_ENA,
+		lan966x, QSYS_SW_PORT_MODE(port->chip_port));
+
+	/* 6: Wait a worst case time 8ms (jumbo/10Mbit) */
+	usleep_range(8 * USEC_PER_MSEC, 9 * USEC_PER_MSEC);
+
+	/* 7: Disable HDX backpressure */
+	lan_rmw(SYS_FRONT_PORT_MODE_HDX_MODE_SET(0),
+		SYS_FRONT_PORT_MODE_HDX_MODE,
+		lan966x, SYS_FRONT_PORT_MODE(port->chip_port));
+
+	/* 8: Flush the queues accociated with the port */
+	lan_rmw(QSYS_SW_PORT_MODE_AGING_MODE_SET(3),
+		QSYS_SW_PORT_MODE_AGING_MODE,
+		lan966x, QSYS_SW_PORT_MODE(port->chip_port));
+
+	/* 9: Enable dequeuing from the egress queues */
+	lan_rmw(QSYS_PORT_MODE_DEQUEUE_DIS_SET(0),
+		QSYS_PORT_MODE_DEQUEUE_DIS,
+		lan966x, QSYS_PORT_MODE(port->chip_port));
+
+	/* 10: Wait until flushing is complete */
+	while (true) {
+		val = lan_rd(lan966x, QSYS_SW_STATUS(port->chip_port));
+		if (!QSYS_SW_STATUS_EQ_AVAIL_GET(val))
+			break;
+
+		usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
+		delay++;
+		if (delay == 2000) {
+			pr_err("Flush timeout chip port %u", port->chip_port);
+			break;
+		}
+	}
+
+	/* 11: Reset the Port and MAC clock domains */
+	lan_rmw(DEV_MAC_ENA_CFG_TX_ENA_SET(0),
+		DEV_MAC_ENA_CFG_TX_ENA,
+		lan966x, DEV_MAC_ENA_CFG(port->chip_port));
+
+	lan_rmw(DEV_CLOCK_CFG_PORT_RST_SET(1),
+		DEV_CLOCK_CFG_PORT_RST,
+		lan966x, DEV_CLOCK_CFG(port->chip_port));
+
+	usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
+
+	lan_rmw(DEV_CLOCK_CFG_MAC_TX_RST_SET(1) |
+		DEV_CLOCK_CFG_MAC_RX_RST_SET(1) |
+		DEV_CLOCK_CFG_PORT_RST_SET(1),
+		DEV_CLOCK_CFG_MAC_TX_RST |
+		DEV_CLOCK_CFG_MAC_RX_RST |
+		DEV_CLOCK_CFG_PORT_RST,
+		lan966x, DEV_CLOCK_CFG(port->chip_port));
+
+	/* 12: Clear flushing */
+	lan_rmw(QSYS_SW_PORT_MODE_AGING_MODE_SET(2),
+		QSYS_SW_PORT_MODE_AGING_MODE,
+		lan966x, QSYS_SW_PORT_MODE(port->chip_port));
+
+	/* The port is disabled and flushed, now set up the port in the
+	 * new operating mode
+	 */
+}
+
+static void lan966x_port_link_up(struct lan966x_port *port)
+{
+	struct lan966x_port_config *config = &port->config;
+	struct lan966x *lan966x = port->lan966x;
+	int speed = 0, mode = 0;
+	int atop_wm = 0;
+
+	switch (config->speed) {
+	case SPEED_10:
+		speed = LAN966X_SPEED_10;
+		break;
+	case SPEED_100:
+		speed = LAN966X_SPEED_100;
+		break;
+	case SPEED_1000:
+		speed = LAN966X_SPEED_1000;
+		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA_SET(1);
+		break;
+	}
+
+	/* Also the GIGA_MODE_ENA(1) needs to be set regardless of the
+	 * port speed for QSGMII ports.
+	 */
+	if (config->phy_mode == PHY_INTERFACE_MODE_QSGMII)
+		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA_SET(1);
+
+	lan_wr(config->duplex | mode,
+	       lan966x, DEV_MAC_MODE_CFG(port->chip_port));
+
+	lan_rmw(DEV_MAC_IFG_CFG_TX_IFG_SET(config->duplex ? 6 : 5) |
+		DEV_MAC_IFG_CFG_RX_IFG1_SET(config->speed == SPEED_10 ? 2 : 1) |
+		DEV_MAC_IFG_CFG_RX_IFG2_SET(2),
+		DEV_MAC_IFG_CFG_TX_IFG |
+		DEV_MAC_IFG_CFG_RX_IFG1 |
+		DEV_MAC_IFG_CFG_RX_IFG2,
+		lan966x, DEV_MAC_IFG_CFG(port->chip_port));
+
+	lan_rmw(DEV_MAC_HDX_CFG_SEED_SET(4) |
+		DEV_MAC_HDX_CFG_SEED_LOAD_SET(1),
+		DEV_MAC_HDX_CFG_SEED |
+		DEV_MAC_HDX_CFG_SEED_LOAD,
+		lan966x, DEV_MAC_HDX_CFG(port->chip_port));
+
+	if (config->phy_mode == PHY_INTERFACE_MODE_GMII) {
+		if (config->speed == SPEED_1000)
+			lan_rmw(CHIP_TOP_CUPHY_PORT_CFG_GTX_CLK_ENA_SET(1),
+				CHIP_TOP_CUPHY_PORT_CFG_GTX_CLK_ENA,
+				lan966x,
+				CHIP_TOP_CUPHY_PORT_CFG(port->chip_port));
+		else
+			lan_rmw(CHIP_TOP_CUPHY_PORT_CFG_GTX_CLK_ENA_SET(0),
+				CHIP_TOP_CUPHY_PORT_CFG_GTX_CLK_ENA,
+				lan966x,
+				CHIP_TOP_CUPHY_PORT_CFG(port->chip_port));
+	}
+
+	/* No PFC */
+	lan_wr(ANA_PFC_CFG_FC_LINK_SPEED_SET(speed),
+	       lan966x, ANA_PFC_CFG(port->chip_port));
+
+	if (config->phy_mode == PHY_INTERFACE_MODE_QSGMII) {
+		lan_rmw(DEV_PCS1G_CFG_PCS_ENA_SET(1),
+			DEV_PCS1G_CFG_PCS_ENA,
+			lan966x, DEV_PCS1G_CFG(port->chip_port));
+
+		lan_rmw(DEV_PCS1G_SD_CFG_SD_ENA_SET(0),
+			DEV_PCS1G_SD_CFG_SD_ENA,
+			lan966x, DEV_PCS1G_SD_CFG(port->chip_port));
+	}
+
+	lan_rmw(DEV_PCS1G_CFG_PCS_ENA_SET(1),
+		DEV_PCS1G_CFG_PCS_ENA,
+		lan966x, DEV_PCS1G_CFG(port->chip_port));
+
+	lan_rmw(DEV_PCS1G_SD_CFG_SD_ENA_SET(0),
+		DEV_PCS1G_SD_CFG_SD_ENA,
+		lan966x, DEV_PCS1G_SD_CFG(port->chip_port));
+
+	/* Set Pause WM hysteresis, start/stop are in 1518 byte units */
+	lan_wr(SYS_PAUSE_CFG_PAUSE_ENA_SET(1) |
+	       SYS_PAUSE_CFG_PAUSE_STOP_SET(lan966x_wm_enc(4 * 1518)) |
+	       SYS_PAUSE_CFG_PAUSE_START_SET(lan966x_wm_enc(6 * 1518)),
+	       lan966x, SYS_PAUSE_CFG(port->chip_port));
+
+	/* Set SMAC of Pause frame (00:00:00:00:00:00) */
+	lan_wr(0, lan966x, DEV_FC_MAC_LOW_CFG(port->chip_port));
+	lan_wr(0, lan966x, DEV_FC_MAC_HIGH_CFG(port->chip_port));
+
+	/* Flow control */
+	lan_rmw(SYS_MAC_FC_CFG_FC_LINK_SPEED_SET(speed) |
+		SYS_MAC_FC_CFG_FC_LATENCY_CFG_SET(7) |
+		SYS_MAC_FC_CFG_ZERO_PAUSE_ENA_SET(1) |
+		SYS_MAC_FC_CFG_PAUSE_VAL_CFG_SET(0xffff) |
+		SYS_MAC_FC_CFG_RX_FC_ENA_SET(config->pause & MLO_PAUSE_RX ? 1 : 0) |
+		SYS_MAC_FC_CFG_TX_FC_ENA_SET(config->pause & MLO_PAUSE_TX ? 1 : 0),
+		SYS_MAC_FC_CFG_FC_LINK_SPEED |
+		SYS_MAC_FC_CFG_FC_LATENCY_CFG |
+		SYS_MAC_FC_CFG_ZERO_PAUSE_ENA |
+		SYS_MAC_FC_CFG_PAUSE_VAL_CFG |
+		SYS_MAC_FC_CFG_RX_FC_ENA |
+		SYS_MAC_FC_CFG_TX_FC_ENA,
+		lan966x, SYS_MAC_FC_CFG(port->chip_port));
+
+	/* Tail dropping watermark */
+	atop_wm = lan966x->shared_queue_sz;
+
+	/* The total memory size is diveded by number of front ports plus CPU
+	 * port
+	 */
+	lan_wr(lan966x_wm_enc(atop_wm / lan966x->num_phys_ports + 1), lan966x,
+	       SYS_ATOP(port->chip_port));
+	lan_wr(lan966x_wm_enc(atop_wm), lan966x, SYS_ATOP_TOT_CFG);
+
+	/* This needs to be at the end */
+	/* Enable MAC module */
+	lan_wr(DEV_MAC_ENA_CFG_RX_ENA_SET(1) |
+	       DEV_MAC_ENA_CFG_TX_ENA_SET(1),
+	       lan966x, DEV_MAC_ENA_CFG(port->chip_port));
+
+	/* Take out the clock from reset */
+	lan_wr(DEV_CLOCK_CFG_LINK_SPEED_SET(speed),
+	       lan966x, DEV_CLOCK_CFG(port->chip_port));
+
+	/* Core: Enable port for frame transfer */
+	lan_wr(QSYS_SW_PORT_MODE_PORT_ENA_SET(1) |
+	       QSYS_SW_PORT_MODE_SCH_NEXT_CFG_SET(1) |
+	       QSYS_SW_PORT_MODE_INGRESS_DROP_MODE_SET(1),
+	       lan966x, QSYS_SW_PORT_MODE(port->chip_port));
+
+	lan_rmw(AFI_PORT_CFG_FC_SKIP_TTI_INJ_SET(0) |
+		AFI_PORT_CFG_FRM_OUT_MAX_SET(16),
+		AFI_PORT_CFG_FC_SKIP_TTI_INJ |
+		AFI_PORT_CFG_FRM_OUT_MAX,
+		lan966x, AFI_PORT_CFG(port->chip_port));
+}
+
+void lan966x_port_config_down(struct lan966x_port *port)
+{
+	lan966x_port_link_down(port);
+}
+
+void lan966x_port_config_up(struct lan966x_port *port)
+{
+	lan966x_port_link_up(port);
+}
+
+void lan966x_port_status_get(struct lan966x_port *port,
+			     struct phylink_link_state *state)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u16 lp_adv, ld_adv;
+	bool link_down;
+	u16 bmsr = 0;
+	u32 val;
+
+	val = lan_rd(lan966x, DEV_PCS1G_STICKY(port->chip_port));
+	link_down = DEV_PCS1G_STICKY_LINK_DOWN_STICKY_GET(val);
+	if (link_down)
+		lan_wr(val, lan966x, DEV_PCS1G_STICKY(port->chip_port));
+
+	/* Get both current Link and Sync status */
+	val = lan_rd(lan966x, DEV_PCS1G_LINK_STATUS(port->chip_port));
+	state->link = DEV_PCS1G_LINK_STATUS_LINK_STATUS_GET(val) &&
+		      DEV_PCS1G_LINK_STATUS_SYNC_STATUS_GET(val);
+	state->link &= !link_down;
+
+	if (port->config.portmode == PHY_INTERFACE_MODE_1000BASEX)
+		state->speed = SPEED_1000;
+	else if (port->config.portmode == PHY_INTERFACE_MODE_2500BASEX)
+		state->speed = SPEED_2500;
+
+	state->duplex = DUPLEX_FULL;
+
+	/* Get PCS ANEG status register */
+	val = lan_rd(lan966x, DEV_PCS1G_ANEG_STATUS(port->chip_port));
+
+	/* Aneg complete provides more information  */
+	if (DEV_PCS1G_ANEG_STATUS_ANEG_COMPLETE_GET(val)) {
+		lp_adv = DEV_PCS1G_ANEG_STATUS_LP_ADV_GET(val);
+		state->an_complete = true;
+
+		bmsr |= state->link ? BMSR_LSTATUS : 0;
+		bmsr |= state->an_complete;
+
+		if (port->config.portmode == PHY_INTERFACE_MODE_SGMII) {
+			phylink_mii_c22_pcs_decode_state(state, bmsr, lp_adv);
+		} else {
+			val = lan_rd(lan966x, DEV_PCS1G_ANEG_CFG(port->chip_port));
+			ld_adv = DEV_PCS1G_ANEG_CFG_ADV_ABILITY_GET(val);
+			phylink_mii_c22_pcs_decode_state(state, bmsr, ld_adv);
+		}
+	}
+}
+
+int lan966x_port_pcs_set(struct lan966x_port *port,
+			 struct lan966x_port_config *config)
+{
+	struct lan966x *lan966x = port->lan966x;
+	bool inband_aneg = false;
+	bool outband;
+	int err;
+
+	lan966x_port_link_down(port);
+
+	if (config->inband) {
+		if (config->portmode == PHY_INTERFACE_MODE_SGMII ||
+		    config->portmode == PHY_INTERFACE_MODE_QSGMII)
+			inband_aneg = true; /* Cisco-SGMII in-band-aneg */
+		else if (config->portmode == PHY_INTERFACE_MODE_1000BASEX &&
+			 config->autoneg)
+			inband_aneg = true; /* Clause-37 in-band-aneg */
+
+		if (config->speed > 0) {
+			err = phy_set_speed(port->serdes, config->speed);
+			if (err)
+				return err;
+		}
+		outband = false;
+	} else {
+		outband = true;
+	}
+
+	/* Disable or enable inband */
+	lan_rmw(DEV_PCS1G_MODE_CFG_SGMII_MODE_ENA_SET(outband),
+		DEV_PCS1G_MODE_CFG_SGMII_MODE_ENA,
+		lan966x, DEV_PCS1G_MODE_CFG(port->chip_port));
+
+	/* Enable PCS */
+	lan_wr(DEV_PCS1G_CFG_PCS_ENA_SET(1),
+	       lan966x, DEV_PCS1G_CFG(port->chip_port));
+
+	if (inband_aneg) {
+		int adv = phylink_mii_c22_pcs_encode_advertisement(config->portmode,
+								   config->advertising);
+		if (adv >= 0)
+			/* Enable in-band aneg */
+			lan_wr(DEV_PCS1G_ANEG_CFG_ADV_ABILITY_SET(adv) |
+			       DEV_PCS1G_ANEG_CFG_SW_RESOLVE_ENA_SET(1) |
+			       DEV_PCS1G_ANEG_CFG_ENA_SET(1) |
+			       DEV_PCS1G_ANEG_CFG_RESTART_ONE_SHOT_SET(1),
+			       lan966x, DEV_PCS1G_ANEG_CFG(port->chip_port));
+	} else {
+		lan_wr(0, lan966x, DEV_PCS1G_ANEG_CFG(port->chip_port));
+	}
+
+	/* Take PCS out of reset */
+	lan_rmw(DEV_CLOCK_CFG_LINK_SPEED_SET(2) |
+		DEV_CLOCK_CFG_PCS_RX_RST_SET(0) |
+		DEV_CLOCK_CFG_PCS_TX_RST_SET(0),
+		DEV_CLOCK_CFG_LINK_SPEED |
+		DEV_CLOCK_CFG_PCS_RX_RST |
+		DEV_CLOCK_CFG_PCS_TX_RST,
+		lan966x, DEV_CLOCK_CFG(port->chip_port));
+
+	port->config = *config;
+
+	return 0;
+}
+
+void lan966x_port_init(struct lan966x_port *port)
+{
+	struct lan966x_port_config *config = &port->config;
+	struct lan966x *lan966x = port->lan966x;
+
+	lan_rmw(ANA_PORT_CFG_LEARN_ENA_SET(0),
+		ANA_PORT_CFG_LEARN_ENA,
+		lan966x, ANA_PORT_CFG(port->chip_port));
+
+	if (config->phy_mode != PHY_INTERFACE_MODE_QSGMII)
+		return;
+
+	lan_rmw(DEV_CLOCK_CFG_PCS_RX_RST_SET(0) |
+		DEV_CLOCK_CFG_PCS_TX_RST_SET(0) |
+		DEV_CLOCK_CFG_LINK_SPEED_SET(LAN966X_SPEED_1000),
+		DEV_CLOCK_CFG_PCS_RX_RST |
+		DEV_CLOCK_CFG_PCS_TX_RST |
+		DEV_CLOCK_CFG_LINK_SPEED,
+		lan966x, DEV_CLOCK_CFG(port->chip_port));
+}
-- 
2.33.0

