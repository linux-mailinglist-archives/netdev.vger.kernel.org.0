Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922FA33F65
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 08:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfFDG6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 02:58:50 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:26585 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726547AbfFDG6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 02:58:49 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 3 Jun 2019 23:58:46 -0700
Received: from ubuntu.eng.vmware.com (unknown [10.33.74.142])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 59ABA4132E;
        Mon,  3 Jun 2019 23:58:48 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] vmxnet3: turn off lro when rxcsum is disabled
Date:   Mon, 3 Jun 2019 23:58:38 -0700
Message-ID: <20190604065838.22243-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when rx csum is disabled, vmxnet3 driver does not turn
off lro, which can cause performance issues if user does not turn off
lro explicitly. This patch adds fix_features support which is used to
turn off LRO whenever RXCSUM is disabled.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Rishi Mehta <rmehta@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c     |  1 +
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 10 ++++++++++
 drivers/net/vmxnet3/vmxnet3_int.h     |  7 +++++--
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 1b2a18ea855c..3f48f05dd2a6 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3247,6 +3247,7 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 		.ndo_start_xmit = vmxnet3_xmit_frame,
 		.ndo_set_mac_address = vmxnet3_set_mac_addr,
 		.ndo_change_mtu = vmxnet3_change_mtu,
+		.ndo_fix_features = vmxnet3_fix_features,
 		.ndo_set_features = vmxnet3_set_features,
 		.ndo_get_stats64 = vmxnet3_get_stats64,
 		.ndo_tx_timeout = vmxnet3_tx_timeout,
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 559db051a500..0a38c76688ab 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -257,6 +257,16 @@ vmxnet3_get_strings(struct net_device *netdev, u32 stringset, u8 *buf)
 	}
 }
 
+netdev_features_t vmxnet3_fix_features(struct net_device *netdev,
+				       netdev_features_t features)
+{
+	/* If Rx checksum is disabled, then LRO should also be disabled */
+	if (!(features & NETIF_F_RXCSUM))
+		features &= ~NETIF_F_LRO;
+
+	return features;
+}
+
 int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index a2c554f8a61b..1cc1cd4aaa59 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -69,12 +69,12 @@
 /*
  * Version numbers
  */
-#define VMXNET3_DRIVER_VERSION_STRING   "1.4.16.0-k"
+#define VMXNET3_DRIVER_VERSION_STRING   "1.4.17.0-k"
 
 /* Each byte of this 32-bit integer encodes a version number in
  * VMXNET3_DRIVER_VERSION_STRING.
  */
-#define VMXNET3_DRIVER_VERSION_NUM      0x01041000
+#define VMXNET3_DRIVER_VERSION_NUM      0x01041100
 
 #if defined(CONFIG_PCI_MSI)
 	/* RSS only makes sense if MSI-X is supported. */
@@ -454,6 +454,9 @@ vmxnet3_tq_destroy_all(struct vmxnet3_adapter *adapter);
 void
 vmxnet3_rq_destroy_all(struct vmxnet3_adapter *adapter);
 
+netdev_features_t
+vmxnet3_fix_features(struct net_device *netdev, netdev_features_t features);
+
 int
 vmxnet3_set_features(struct net_device *netdev, netdev_features_t features);
 
-- 
2.11.0

