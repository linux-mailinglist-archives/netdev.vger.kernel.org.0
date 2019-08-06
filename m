Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3273B8369E
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387572AbfHFQY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:24:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10362 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728927AbfHFQY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 12:24:26 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x76GHk4q087280;
        Tue, 6 Aug 2019 12:24:14 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2u7atsxeg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 12:23:33 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x76GAd7c026027;
        Tue, 6 Aug 2019 16:23:11 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 2u51w6smvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 16:23:11 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x76GNA9D29557036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Aug 2019 16:23:10 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EC68B2064;
        Tue,  6 Aug 2019 16:23:10 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43E84B205F;
        Tue,  6 Aug 2019 16:23:10 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.41.178.211])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  6 Aug 2019 16:23:10 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     mpe@ellerman.id.au
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net-next v2] ibmveth: Allow users to update reported speed and duplex
Date:   Tue,  6 Aug 2019 11:23:08 -0500
Message-Id: <1565108588-17331-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported ethtool link settings for the ibmveth driver are currently
hardcoded and no longer reflect the actual capabilities of supported
hardware. There is no interface designed for retrieving this information
from device firmware nor is there any way to update current settings
to reflect observed or expected link speeds.

To avoid breaking existing configurations, retain current values as
default settings but let users update them to match the expected
capabilities of underlying hardware if needed. This update would
allow the use of configurations that rely on certain link speed
settings, such as LACP. This patch is based on the implementation
in virtio_net.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
v2: Updated default driver speed/duplex settings to avoid
    breaking existing setups
---
 drivers/net/ethernet/ibm/ibmveth.c | 83 ++++++++++++++++++++++++++++----------
 drivers/net/ethernet/ibm/ibmveth.h |  3 ++
 2 files changed, 64 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index d654c23..5dc634f 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -712,31 +712,68 @@ static int ibmveth_close(struct net_device *netdev)
 	return 0;
 }
 
-static int netdev_get_link_ksettings(struct net_device *dev,
-				     struct ethtool_link_ksettings *cmd)
+static bool
+ibmveth_validate_ethtool_cmd(const struct ethtool_link_ksettings *cmd)
 {
-	u32 supported, advertising;
-
-	supported = (SUPPORTED_1000baseT_Full | SUPPORTED_Autoneg |
-				SUPPORTED_FIBRE);
-	advertising = (ADVERTISED_1000baseT_Full | ADVERTISED_Autoneg |
-				ADVERTISED_FIBRE);
-	cmd->base.speed = SPEED_1000;
-	cmd->base.duplex = DUPLEX_FULL;
-	cmd->base.port = PORT_FIBRE;
-	cmd->base.phy_address = 0;
-	cmd->base.autoneg = AUTONEG_ENABLE;
-
-	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
-						supported);
-	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
-						advertising);
+	struct ethtool_link_ksettings diff1 = *cmd;
+	struct ethtool_link_ksettings diff2 = {};
+
+	diff2.base.port = PORT_OTHER;
+	diff1.base.speed = 0;
+	diff1.base.duplex = 0;
+	diff1.base.cmd = 0;
+	diff1.base.link_mode_masks_nwords = 0;
+	ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
+
+	return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&
+		bitmap_empty(diff1.link_modes.supported,
+			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
+		bitmap_empty(diff1.link_modes.advertising,
+			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
+		bitmap_empty(diff1.link_modes.lp_advertising,
+			     __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static int ibmveth_set_link_ksettings(struct net_device *dev,
+				      const struct ethtool_link_ksettings *cmd)
+{
+	struct ibmveth_adapter *adapter = netdev_priv(dev);
+	u32 speed;
+	u8 duplex;
+
+	speed = cmd->base.speed;
+	duplex = cmd->base.duplex;
+	/* don't allow custom speed and duplex */
+	if (!ethtool_validate_speed(speed) ||
+	    !ethtool_validate_duplex(duplex) ||
+	    !ibmveth_validate_ethtool_cmd(cmd))
+		return -EINVAL;
+	adapter->speed = speed;
+	adapter->duplex = duplex;
 
 	return 0;
 }
 
-static void netdev_get_drvinfo(struct net_device *dev,
-			       struct ethtool_drvinfo *info)
+static int ibmveth_get_link_ksettings(struct net_device *dev,
+				      struct ethtool_link_ksettings *cmd)
+{
+	struct ibmveth_adapter *adapter = netdev_priv(dev);
+
+	cmd->base.speed = adapter->speed;
+	cmd->base.duplex = adapter->duplex;
+	cmd->base.port = PORT_OTHER;
+
+	return 0;
+}
+
+static void ibmveth_init_link_settings(struct ibmveth_adapter *adapter)
+{
+	adapter->duplex = DUPLEX_FULL;
+	adapter->speed = SPEED_1000;
+}
+
+static void ibmveth_get_drvinfo(struct net_device *dev,
+				struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, ibmveth_driver_name, sizeof(info->driver));
 	strlcpy(info->version, ibmveth_driver_version, sizeof(info->version));
@@ -965,12 +1002,13 @@ static void ibmveth_get_ethtool_stats(struct net_device *dev,
 }
 
 static const struct ethtool_ops netdev_ethtool_ops = {
-	.get_drvinfo		= netdev_get_drvinfo,
+	.get_drvinfo		= ibmveth_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
 	.get_strings		= ibmveth_get_strings,
 	.get_sset_count		= ibmveth_get_sset_count,
 	.get_ethtool_stats	= ibmveth_get_ethtool_stats,
-	.get_link_ksettings	= netdev_get_link_ksettings,
+	.get_link_ksettings	= ibmveth_get_link_ksettings,
+	.set_link_ksettings	= ibmveth_set_link_ksettings
 };
 
 static int ibmveth_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
@@ -1647,6 +1685,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	adapter->netdev = netdev;
 	adapter->mcastFilterSize = *mcastFilterSize_p;
 	adapter->pool_config = 0;
+	ibmveth_init_link_settings(adapter);
 
 	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
 
diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
index 4e9bf34..db96c88 100644
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -162,6 +162,9 @@ struct ibmveth_adapter {
     u64 tx_send_failed;
     u64 tx_large_packets;
     u64 rx_large_packets;
+    /* Ethtool settings */
+    u8 duplex;
+    u32 speed;
 };
 
 /*
-- 
1.8.3.1

