Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D873CBF59
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 00:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237917AbhGPWj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 18:39:56 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:11619 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237590AbhGPWjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 18:39:46 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Jul 2021 15:36:44 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.3])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 596182034D;
        Fri, 16 Jul 2021 15:36:49 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 54E26AA043; Fri, 16 Jul 2021 15:36:49 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 6/7] vmxnet3: increase maximum configurable mtu to 9190
Date:   Fri, 16 Jul 2021 15:36:25 -0700
Message-ID: <20210716223626.18928-7-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210716223626.18928-1-doshir@vmware.com>
References: <20210716223626.18928-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch increases the maximum configurable mtu to 9190
to accommodate jumbo packets of overlay traffic.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_defs.h | 1 +
 drivers/net/vmxnet3/vmxnet3_drv.c  | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_defs.h b/drivers/net/vmxnet3/vmxnet3_defs.h
index bc82bbbcb1ab..74d4e8bc4abc 100644
--- a/drivers/net/vmxnet3/vmxnet3_defs.h
+++ b/drivers/net/vmxnet3/vmxnet3_defs.h
@@ -795,6 +795,7 @@ struct Vmxnet3_DriverShared {
 	((vfTable[vid >> 5] & (1 << (vid & 31))) != 0)
 
 #define VMXNET3_MAX_MTU     9000
+#define VMXNET3_V6_MAX_MTU  9190
 #define VMXNET3_MIN_MTU     60
 
 #define VMXNET3_LINK_UP         (10000 << 16 | 1)    /* 10 Gbps, up */
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 4fd6ce15a860..9f52f9c254f4 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3641,9 +3641,12 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 	vmxnet3_set_ethtool_ops(netdev);
 	netdev->watchdog_timeo = 5 * HZ;
 
-	/* MTU range: 60 - 9000 */
+	/* MTU range: 60 - 9190 */
 	netdev->min_mtu = VMXNET3_MIN_MTU;
-	netdev->max_mtu = VMXNET3_MAX_MTU;
+	if (VMXNET3_VERSION_GE_6(adapter))
+		netdev->max_mtu = VMXNET3_V6_MAX_MTU;
+	else
+		netdev->max_mtu = VMXNET3_MAX_MTU;
 
 	INIT_WORK(&adapter->work, vmxnet3_reset_work);
 	set_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state);
-- 
2.11.0

