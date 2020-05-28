Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2E41E6E20
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436760AbgE1Vxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:53:30 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:58503 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436727AbgE1Vx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 17:53:27 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 28 May 2020 14:53:22 -0700
Received: from ubuntu.eng.vmware.com (unknown [10.20.113.240])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 8B00AB2690;
        Thu, 28 May 2020 17:53:26 -0400 (EDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 net-next 2/4] vmxnet3: add support to get/set rx flow hash
Date:   Thu, 28 May 2020 14:53:20 -0700
Message-ID: <20200528215322.31682-3-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200528215322.31682-1-doshir@vmware.com>
References: <20200528215322.31682-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With vmxnet3 version 4, the emulation supports multiqueue(RSS) for
UDP and ESP traffic. A guest can enable/disable RSS for UDP/ESP over
IPv4/IPv6 by issuing commands introduced in this patch. ESP ipv6 is
not yet supported in this patch.

This patch implements get_rss_hash_opts and set_rss_hash_opts
methods to allow querying and configuring different Rx flow hash
configurations.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_defs.h    |  12 ++
 drivers/net/vmxnet3/vmxnet3_drv.c     |  39 ++++++
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 219 +++++++++++++++++++++++++++++++++-
 drivers/net/vmxnet3/vmxnet3_int.h     |   4 +
 4 files changed, 272 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_defs.h b/drivers/net/vmxnet3/vmxnet3_defs.h
index c77274228a3e..aac97fac1186 100644
--- a/drivers/net/vmxnet3/vmxnet3_defs.h
+++ b/drivers/net/vmxnet3/vmxnet3_defs.h
@@ -82,6 +82,7 @@ enum {
 	VMXNET3_CMD_RESERVED3,
 	VMXNET3_CMD_SET_COALESCE,
 	VMXNET3_CMD_REGISTER_MEMREGS,
+	VMXNET3_CMD_SET_RSS_FIELDS,
 
 	VMXNET3_CMD_FIRST_GET = 0xF00D0000,
 	VMXNET3_CMD_GET_QUEUE_STATUS = VMXNET3_CMD_FIRST_GET,
@@ -96,6 +97,7 @@ enum {
 	VMXNET3_CMD_GET_RESERVED1,
 	VMXNET3_CMD_GET_TXDATA_DESC_SIZE,
 	VMXNET3_CMD_GET_COALESCE,
+	VMXNET3_CMD_GET_RSS_FIELDS,
 };
 
 /*
@@ -685,12 +687,22 @@ struct Vmxnet3_MemRegs {
 	struct Vmxnet3_MemoryRegion		memRegs[1];
 };
 
+enum Vmxnet3_RSSField {
+	VMXNET3_RSS_FIELDS_TCPIP4 = 0x0001,
+	VMXNET3_RSS_FIELDS_TCPIP6 = 0x0002,
+	VMXNET3_RSS_FIELDS_UDPIP4 = 0x0004,
+	VMXNET3_RSS_FIELDS_UDPIP6 = 0x0008,
+	VMXNET3_RSS_FIELDS_ESPIP4 = 0x0010,
+	VMXNET3_RSS_FIELDS_ESPIP6 = 0x0020,
+};
+
 /* If the command data <= 16 bytes, use the shared memory directly.
  * otherwise, use variable length configuration descriptor.
  */
 union Vmxnet3_CmdInfo {
 	struct Vmxnet3_VariableLenConfDesc	varConf;
 	struct Vmxnet3_SetPolling		setPolling;
+	enum   Vmxnet3_RSSField                 setRssFields;
 	__le64					data[2];
 };
 
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index ec2878f8c1f6..4ea7a40ada88 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2554,6 +2554,39 @@ vmxnet3_init_coalesce(struct vmxnet3_adapter *adapter)
 	spin_unlock_irqrestore(&adapter->cmd_lock, flags);
 }
 
+static void
+vmxnet3_init_rssfields(struct vmxnet3_adapter *adapter)
+{
+	struct Vmxnet3_DriverShared *shared = adapter->shared;
+	union Vmxnet3_CmdInfo *cmdInfo = &shared->cu.cmdInfo;
+	unsigned long flags;
+
+		if (!VMXNET3_VERSION_GE_4(adapter))
+			return;
+
+	spin_lock_irqsave(&adapter->cmd_lock, flags);
+
+	if (adapter->default_rss_fields) {
+		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
+				       VMXNET3_CMD_GET_RSS_FIELDS);
+		adapter->rss_fields =
+			VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_CMD);
+	} else {
+		cmdInfo->setRssFields = adapter->rss_fields;
+		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
+				       VMXNET3_CMD_SET_RSS_FIELDS);
+		/* Not all requested RSS may get applied, so get and
+		 * cache what was actually applied.
+		 */
+		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
+				       VMXNET3_CMD_GET_RSS_FIELDS);
+		adapter->rss_fields =
+			VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_CMD);
+	}
+
+	spin_unlock_irqrestore(&adapter->cmd_lock, flags);
+}
+
 int
 vmxnet3_activate_dev(struct vmxnet3_adapter *adapter)
 {
@@ -2603,6 +2636,7 @@ vmxnet3_activate_dev(struct vmxnet3_adapter *adapter)
 	}
 
 	vmxnet3_init_coalesce(adapter);
+	vmxnet3_init_rssfields(adapter);
 
 	for (i = 0; i < adapter->num_rx_queues; i++) {
 		VMXNET3_WRITE_BAR0_REG(adapter,
@@ -3430,6 +3464,11 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 		adapter->default_coal_mode = true;
 	}
 
+	if (VMXNET3_VERSION_GE_4(adapter)) {
+		adapter->default_rss_fields = true;
+		adapter->rss_fields = VMXNET3_RSS_FIELDS_DEFAULT;
+	}
+
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 	vmxnet3_declare_features(adapter, dma64);
 
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 1163eca7aba5..57460cf1967f 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -665,18 +665,232 @@ vmxnet3_set_ringparam(struct net_device *netdev,
 	return err;
 }
 
+static int
+vmxnet3_get_rss_hash_opts(struct vmxnet3_adapter *adapter,
+			  struct ethtool_rxnfc *info)
+{
+	enum Vmxnet3_RSSField rss_fields;
+
+	if (netif_running(adapter->netdev)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&adapter->cmd_lock, flags);
+
+		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
+				       VMXNET3_CMD_GET_RSS_FIELDS);
+		rss_fields = VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_CMD);
+		spin_unlock_irqrestore(&adapter->cmd_lock, flags);
+	} else {
+		rss_fields = adapter->rss_fields;
+	}
+
+	info->data = 0;
+
+	/* Report default options for RSS on vmxnet3 */
+	switch (info->flow_type) {
+	case TCP_V4_FLOW:
+	case TCP_V6_FLOW:
+		info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3 |
+			      RXH_IP_SRC | RXH_IP_DST;
+		break;
+	case UDP_V4_FLOW:
+		if (rss_fields & VMXNET3_RSS_FIELDS_UDPIP4)
+			info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		info->data |= RXH_IP_SRC | RXH_IP_DST;
+		break;
+	case AH_ESP_V4_FLOW:
+	case AH_V4_FLOW:
+	case ESP_V4_FLOW:
+		if (rss_fields & VMXNET3_RSS_FIELDS_ESPIP4)
+			info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+			/* fallthrough */
+	case SCTP_V4_FLOW:
+	case IPV4_FLOW:
+		info->data |= RXH_IP_SRC | RXH_IP_DST;
+		break;
+	case UDP_V6_FLOW:
+		if (rss_fields & VMXNET3_RSS_FIELDS_UDPIP6)
+			info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		info->data |= RXH_IP_SRC | RXH_IP_DST;
+		break;
+	case AH_ESP_V6_FLOW:
+	case AH_V6_FLOW:
+	case ESP_V6_FLOW:
+	case SCTP_V6_FLOW:
+	case IPV6_FLOW:
+		info->data |= RXH_IP_SRC | RXH_IP_DST;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+vmxnet3_set_rss_hash_opt(struct net_device *netdev,
+			 struct vmxnet3_adapter *adapter,
+			 struct ethtool_rxnfc *nfc)
+{
+	enum Vmxnet3_RSSField rss_fields = adapter->rss_fields;
+
+	/* RSS does not support anything other than hashing
+	 * to queues on src and dst IPs and ports
+	 */
+	if (nfc->data & ~(RXH_IP_SRC | RXH_IP_DST |
+			  RXH_L4_B_0_1 | RXH_L4_B_2_3))
+		return -EINVAL;
+
+	switch (nfc->flow_type) {
+	case TCP_V4_FLOW:
+	case TCP_V6_FLOW:
+		if (!(nfc->data & RXH_IP_SRC) ||
+		    !(nfc->data & RXH_IP_DST) ||
+		    !(nfc->data & RXH_L4_B_0_1) ||
+		    !(nfc->data & RXH_L4_B_2_3))
+			return -EINVAL;
+		break;
+	case UDP_V4_FLOW:
+		if (!(nfc->data & RXH_IP_SRC) ||
+		    !(nfc->data & RXH_IP_DST))
+			return -EINVAL;
+		switch (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)) {
+		case 0:
+			rss_fields &= ~VMXNET3_RSS_FIELDS_UDPIP4;
+			break;
+		case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
+			rss_fields |= VMXNET3_RSS_FIELDS_UDPIP4;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	case UDP_V6_FLOW:
+		if (!(nfc->data & RXH_IP_SRC) ||
+		    !(nfc->data & RXH_IP_DST))
+			return -EINVAL;
+		switch (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)) {
+		case 0:
+			rss_fields &= ~VMXNET3_RSS_FIELDS_UDPIP6;
+			break;
+		case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
+			rss_fields |= VMXNET3_RSS_FIELDS_UDPIP6;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	case ESP_V4_FLOW:
+	case AH_V4_FLOW:
+	case AH_ESP_V4_FLOW:
+		if (!(nfc->data & RXH_IP_SRC) ||
+		    !(nfc->data & RXH_IP_DST))
+			return -EINVAL;
+		switch (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)) {
+		case 0:
+			rss_fields &= ~VMXNET3_RSS_FIELDS_ESPIP4;
+			break;
+		case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
+			rss_fields |= VMXNET3_RSS_FIELDS_ESPIP4;
+		break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	case ESP_V6_FLOW:
+	case AH_V6_FLOW:
+	case AH_ESP_V6_FLOW:
+	case SCTP_V4_FLOW:
+	case SCTP_V6_FLOW:
+		if (!(nfc->data & RXH_IP_SRC) ||
+		    !(nfc->data & RXH_IP_DST) ||
+		    (nfc->data & RXH_L4_B_0_1) ||
+		    (nfc->data & RXH_L4_B_2_3))
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* if we changed something we need to update flags */
+	if (rss_fields != adapter->rss_fields) {
+		adapter->default_rss_fields = false;
+		if (netif_running(netdev)) {
+			struct Vmxnet3_DriverShared *shared = adapter->shared;
+			union Vmxnet3_CmdInfo *cmdInfo = &shared->cu.cmdInfo;
+			unsigned long flags;
+
+			spin_lock_irqsave(&adapter->cmd_lock, flags);
+			cmdInfo->setRssFields = rss_fields;
+			VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
+					       VMXNET3_CMD_SET_RSS_FIELDS);
+
+			/* Not all requested RSS may get applied, so get and
+			 * cache what was actually applied.
+			 */
+			VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
+					       VMXNET3_CMD_GET_RSS_FIELDS);
+			adapter->rss_fields =
+				VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_CMD);
+			spin_unlock_irqrestore(&adapter->cmd_lock, flags);
+		} else {
+			/* When the device is activated, we will try to apply
+			 * these rules and cache the applied value later.
+			 */
+			adapter->rss_fields = rss_fields;
+		}
+	}
+	return 0;
+}
 
 static int
 vmxnet3_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *info,
 		  u32 *rules)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+	int err = 0;
+
 	switch (info->cmd) {
 	case ETHTOOL_GRXRINGS:
 		info->data = adapter->num_rx_queues;
-		return 0;
+		break;
+	case ETHTOOL_GRXFH:
+		if (!VMXNET3_VERSION_GE_4(adapter)) {
+			err = -EOPNOTSUPP;
+			break;
+		}
+		err = vmxnet3_get_rss_hash_opts(adapter, info);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
 	}
-	return -EOPNOTSUPP;
+
+	return err;
+}
+
+static int
+vmxnet3_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *info)
+{
+	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+	int err = 0;
+
+	if (!VMXNET3_VERSION_GE_4(adapter)) {
+		err = -EOPNOTSUPP;
+		goto done;
+	}
+
+	switch (info->cmd) {
+	case ETHTOOL_SRXFH:
+		err = vmxnet3_set_rss_hash_opt(netdev, adapter, info);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+done:
+	return err;
 }
 
 #ifdef VMXNET3_RSS
@@ -887,6 +1101,7 @@ static const struct ethtool_ops vmxnet3_ethtool_ops = {
 	.get_ringparam     = vmxnet3_get_ringparam,
 	.set_ringparam     = vmxnet3_set_ringparam,
 	.get_rxnfc         = vmxnet3_get_rxnfc,
+	.set_rxnfc         = vmxnet3_set_rxnfc,
 #ifdef VMXNET3_RSS
 	.get_rxfh_indir_size = vmxnet3_get_rss_indir_size,
 	.get_rxfh          = vmxnet3_get_rss,
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index e803ffad75d6..d52ccc3eeba2 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -377,6 +377,8 @@ struct vmxnet3_adapter {
 	u16 rxdata_desc_size;
 
 	bool rxdataring_enabled;
+	bool default_rss_fields;
+	enum Vmxnet3_RSSField rss_fields;
 
 	struct work_struct work;
 
@@ -438,6 +440,8 @@ struct vmxnet3_adapter {
 
 #define VMXNET3_COAL_RBC_RATE(usecs) (1000000 / usecs)
 #define VMXNET3_COAL_RBC_USECS(rbc_rate) (1000000 / rbc_rate)
+#define VMXNET3_RSS_FIELDS_DEFAULT (VMXNET3_RSS_FIELDS_TCPIP4 | \
+				    VMXNET3_RSS_FIELDS_TCPIP6)
 
 int
 vmxnet3_quiesce_dev(struct vmxnet3_adapter *adapter);
-- 
2.11.0

