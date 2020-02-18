Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3CA162D74
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgBRRwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:52:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25232 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726703AbgBRRwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:52:39 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01IHo1mG132805;
        Tue, 18 Feb 2020 12:52:33 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6dp9t53c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 12:52:33 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01IHoO34134063;
        Tue, 18 Feb 2020 12:52:33 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6dp9t52r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 12:52:32 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01IHotEF003810;
        Tue, 18 Feb 2020 17:52:31 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 2y6896jygw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 17:52:31 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01IHqU2D60293494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 17:52:30 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7283C13604F;
        Tue, 18 Feb 2020 17:52:30 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01287136051;
        Tue, 18 Feb 2020 17:52:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.24.11.154])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Feb 2020 17:52:29 +0000 (GMT)
From:   Cris Forno <cforno12@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        davem@davemloft.net, mkubecek@suse.cz,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        Cris Forno <cforno12@linux.vnet.ibm.com>
Subject: [PATCH, net-next, v5, 2/2] net/ethtool: Introduce link_ksettings API for virtual network devices
Date:   Tue, 18 Feb 2020 11:52:27 -0600
Message-Id: <20200218175227.8511-3-cforno12@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200218175227.8511-1-cforno12@linux.vnet.ibm.com>
References: <20200218175227.8511-1-cforno12@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_05:2020-02-18,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=1 adultscore=0 bulkscore=0 impostorscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002180124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With get/set link settings functions in core/ethtool.c, ibmveth,
netvsc, and virtio now use the core's helper function.

Funtionality changes that pertain to ibmveth driver include:

  1. Changed the initial hardcoded link speed to 1GB.

  2. Added support for allowing a user to change the reported link
  speed via ethtool.

Changes to the netvsc driver include:

  1. When netvsc_get_link_ksettings is called, it will defer to the VF
  device if it exists to pull accelerated networking values, otherwise
  pull default or user-defined values.

  2. Similarly, if netvsc_set_link_ksettings called and a VF device
  exists, the real values of speed and duplex are changed.

Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 57 ++++++++++++++++++++++----------------
 drivers/net/ethernet/ibm/ibmveth.h |  3 ++
 drivers/net/hyperv/netvsc_drv.c    | 25 +++++++++++------
 drivers/net/virtio_net.c           | 40 ++------------------------
 4 files changed, 55 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 84121aa..fe2405a 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -712,29 +712,36 @@ static int ibmveth_close(struct net_device *netdev)
 	return 0;
 }
 
-static int netdev_get_link_ksettings(struct net_device *dev,
-				     struct ethtool_link_ksettings *cmd)
+static int ibmveth_set_link_ksettings(struct net_device *dev,
+				      const struct ethtool_link_ksettings *cmd)
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
+	struct ibmveth_adapter *adapter = netdev_priv(dev);
+
+	return ethtool_virtdev_set_link_ksettings(dev, cmd,
+						  &adapter->speed,
+						  &adapter->duplex, NULL);
+}
+
+static int ibmveth_get_link_ksettings(struct net_device *dev,
+				      struct ethtool_link_ksettings *cmd)
+{
+	struct ibmveth_adapter *adapter = netdev_priv(dev);
+
+	cmd->base.speed = adapter->speed;
+	cmd->base.duplex = adapter->duplex;
+	cmd->base.port = PORT_OTHER;
 
 	return 0;
 }
 
+static void ibmveth_init_link_settings(struct net_device *dev)
+{
+	struct ibmveth_adapter *adapter = netdev_priv(dev);
+
+	adapter->speed = SPEED_1000;
+	adapter->duplex = DUPLEX_FULL;
+}
+
 static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
@@ -965,12 +972,13 @@ static void ibmveth_get_ethtool_stats(struct net_device *dev,
 }
 
 static const struct ethtool_ops netdev_ethtool_ops = {
-	.get_drvinfo		= netdev_get_drvinfo,
-	.get_link		= ethtool_op_get_link,
-	.get_strings		= ibmveth_get_strings,
-	.get_sset_count		= ibmveth_get_sset_count,
-	.get_ethtool_stats	= ibmveth_get_ethtool_stats,
-	.get_link_ksettings	= netdev_get_link_ksettings,
+	.get_drvinfo		         = netdev_get_drvinfo,
+	.get_link		         = ethtool_op_get_link,
+	.get_strings		         = ibmveth_get_strings,
+	.get_sset_count		         = ibmveth_get_sset_count,
+	.get_ethtool_stats	         = ibmveth_get_ethtool_stats,
+	.get_link_ksettings	         = ibmveth_get_link_ksettings,
+	.set_link_ksettings              = ibmveth_set_link_ksettings,
 };
 
 static int ibmveth_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
@@ -1674,6 +1682,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	adapter->netdev = netdev;
 	adapter->mcastFilterSize = be32_to_cpu(*mcastFilterSize_p);
 	adapter->pool_config = 0;
+	ibmveth_init_link_settings(netdev);
 
 	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
 
diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
index 4e9bf34..27dfff2 100644
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -162,6 +162,9 @@ struct ibmveth_adapter {
     u64 tx_send_failed;
     u64 tx_large_packets;
     u64 rx_large_packets;
+    /* Ethtool settings */
+	u8 duplex;
+	u32 speed;
 };
 
 /*
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 65e12cb..f733ec5 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1175,6 +1175,12 @@ static int netvsc_get_link_ksettings(struct net_device *dev,
 				     struct ethtool_link_ksettings *cmd)
 {
 	struct net_device_context *ndc = netdev_priv(dev);
+	struct net_device *vf_netdev;
+
+	vf_netdev = rtnl_dereference(ndc->vf_netdev);
+
+	if (vf_netdev)
+		return __ethtool_get_link_ksettings(vf_netdev, cmd);
 
 	cmd->base.speed = ndc->speed;
 	cmd->base.duplex = ndc->duplex;
@@ -1187,18 +1193,19 @@ static int netvsc_set_link_ksettings(struct net_device *dev,
 				     const struct ethtool_link_ksettings *cmd)
 {
 	struct net_device_context *ndc = netdev_priv(dev);
-	u32 speed;
+	struct net_device *vf_netdev = rtnl_dereference(ndc->vf_netdev);
 
-	speed = cmd->base.speed;
-	if (!ethtool_validate_speed(speed) ||
-	    !ethtool_validate_duplex(cmd->base.duplex) ||
-	    !netvsc_validate_ethtool_ss_cmd(cmd))
-		return -EINVAL;
+	if (vf_netdev) {
+		if (!vf_netdev->ethtool_ops->set_link_ksettings)
+			return -EOPNOTSUPP;
 
-	ndc->speed = speed;
-	ndc->duplex = cmd->base.duplex;
+		return vf_netdev->ethtool_ops->set_link_ksettings(vf_netdev,
+								  cmd);
+	}
 
-	return 0;
+	return ethtool_virtdev_set_link_ksettings(dev, cmd,
+						  &ndc->speed, &ndc->duplex,
+						  &netvsc_validate_ethtool_ss_cmd);
 }
 
 static int netvsc_change_mtu(struct net_device *ndev, int mtu)
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2fe7a31..48755c6 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2166,48 +2166,14 @@ static void virtnet_get_channels(struct net_device *dev,
 	channels->other_count = 0;
 }
 
-/* Check if the user is trying to change anything besides speed/duplex */
-static bool
-virtnet_validate_ethtool_cmd(const struct ethtool_link_ksettings *cmd)
-{
-	struct ethtool_link_ksettings diff1 = *cmd;
-	struct ethtool_link_ksettings diff2 = {};
-
-	/* cmd is always set so we need to clear it, validate the port type
-	 * and also without autonegotiation we can ignore advertising
-	 */
-	diff1.base.speed = 0;
-	diff2.base.port = PORT_OTHER;
-	ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
-	diff1.base.duplex = 0;
-	diff1.base.cmd = 0;
-	diff1.base.link_mode_masks_nwords = 0;
-
-	return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&
-		bitmap_empty(diff1.link_modes.supported,
-			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
-		bitmap_empty(diff1.link_modes.advertising,
-			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
-		bitmap_empty(diff1.link_modes.lp_advertising,
-			     __ETHTOOL_LINK_MODE_MASK_NBITS);
-}
-
 static int virtnet_set_link_ksettings(struct net_device *dev,
 				      const struct ethtool_link_ksettings *cmd)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
-	u32 speed;
-
-	speed = cmd->base.speed;
-	/* don't allow custom speed and duplex */
-	if (!ethtool_validate_speed(speed) ||
-	    !ethtool_validate_duplex(cmd->base.duplex) ||
-	    !virtnet_validate_ethtool_cmd(cmd))
-		return -EINVAL;
-	vi->speed = speed;
-	vi->duplex = cmd->base.duplex;
 
-	return 0;
+	return ethtool_virtdev_set_link_ksettings(dev, cmd,
+						  &vi->speed, &vi->duplex,
+						  NULL);
 }
 
 static int virtnet_get_link_ksettings(struct net_device *dev,
-- 
1.8.3.1

