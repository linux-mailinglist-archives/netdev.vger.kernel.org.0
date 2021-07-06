Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C543BDE5A
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 22:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhGFUVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 16:21:10 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:45527 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229781AbhGFUVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 16:21:10 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jul 2021 16:21:10 EDT
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 6 Jul 2021 13:03:28 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.3])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 7AE8D202D8;
        Tue,  6 Jul 2021 13:03:30 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 76C95AA0C5; Tue,  6 Jul 2021 13:03:30 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 3/7] vmxnet3: remove power of 2 limitation on the queues
Date:   Tue, 6 Jul 2021 13:03:07 -0700
Message-ID: <20210706200312.29777-4-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210706200312.29777-1-doshir@vmware.com>
References: <20210706200312.29777-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With version 6, vmxnet3 relaxes the restriction on queues to
be power of two. This is helpful in cases (Edge VM) where
vcpus are less than 8 and device requires more than 4 queues.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index d32fa6f3ae57..41e694d13c92 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3399,7 +3399,6 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 	else
 #endif
 		num_rx_queues = 1;
-	num_rx_queues = rounddown_pow_of_two(num_rx_queues);
 
 	if (enable_mq)
 		num_tx_queues = min(VMXNET3_DEVICE_MAX_TX_QUEUES,
@@ -3407,7 +3406,6 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 	else
 		num_tx_queues = 1;
 
-	num_tx_queues = rounddown_pow_of_two(num_tx_queues);
 	netdev = alloc_etherdev_mq(sizeof(struct vmxnet3_adapter),
 				   max(num_tx_queues, num_rx_queues));
 	if (!netdev)
@@ -3525,6 +3523,8 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 		}
 	} else {
 		adapter->queuesExtEnabled = false;
+		num_rx_queues = rounddown_pow_of_two(num_rx_queues);
+		num_tx_queues = rounddown_pow_of_two(num_tx_queues);
 		adapter->num_rx_queues = min(num_rx_queues,
 					     VMXNET3_DEVICE_DEFAULT_RX_QUEUES);
 		adapter->num_tx_queues = min(num_tx_queues,
@@ -3705,7 +3705,9 @@ vmxnet3_remove_device(struct pci_dev *pdev)
 	else
 #endif
 		num_rx_queues = 1;
-	num_rx_queues = rounddown_pow_of_two(num_rx_queues);
+	if (!VMXNET3_VERSION_GE_6(adapter)) {
+		num_rx_queues = rounddown_pow_of_two(num_rx_queues);
+	}
 	if (VMXNET3_VERSION_GE_6(adapter)) {
 		spin_lock_irqsave(&adapter->cmd_lock, flags);
 		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
-- 
2.11.0

