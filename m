Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754463BDE59
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 22:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhGFUVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 16:21:15 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:7503 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230187AbhGFUVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 16:21:12 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 6 Jul 2021 13:03:29 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.3])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id E10552027E;
        Tue,  6 Jul 2021 13:03:31 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id DD093AA0C5; Tue,  6 Jul 2021 13:03:31 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 7/7] vmxnet3: update to version 6
Date:   Tue, 6 Jul 2021 13:03:11 -0700
Message-ID: <20210706200312.29777-8-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210706200312.29777-1-doshir@vmware.com>
References: <20210706200312.29777-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With all vmxnet3 version 6 changes incorporated in the vmxnet3 driver,
the driver can configure emulation to run at vmxnet3 version 6, provided
the emulation advertises support for version 6.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 12 +++++++++++-
 drivers/net/vmxnet3/vmxnet3_int.h |  4 ++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 9f52f9c254f4..e3c6b7e3bfdd 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3480,7 +3480,17 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 		goto err_alloc_pci;
 
 	ver = VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_VRRS);
-	if (ver & (1 << VMXNET3_REV_4)) {
+	if (ver & (1 << VMXNET3_REV_6)) {
+		VMXNET3_WRITE_BAR1_REG(adapter,
+				       VMXNET3_REG_VRRS,
+				       1 << VMXNET3_REV_6);
+		adapter->version = VMXNET3_REV_6 + 1;
+	} else if (ver & (1 << VMXNET3_REV_5)) {
+		VMXNET3_WRITE_BAR1_REG(adapter,
+				       VMXNET3_REG_VRRS,
+				       1 << VMXNET3_REV_5);
+		adapter->version = VMXNET3_REV_5 + 1;
+	} else if (ver & (1 << VMXNET3_REV_4)) {
 		VMXNET3_WRITE_BAR1_REG(adapter,
 				       VMXNET3_REG_VRRS,
 				       1 << VMXNET3_REV_4);
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 8675209070ea..7027ff483fa5 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -69,12 +69,12 @@
 /*
  * Version numbers
  */
-#define VMXNET3_DRIVER_VERSION_STRING   "1.5.0.0-k"
+#define VMXNET3_DRIVER_VERSION_STRING   "1.6.0.0-k"
 
 /* Each byte of this 32-bit integer encodes a version number in
  * VMXNET3_DRIVER_VERSION_STRING.
  */
-#define VMXNET3_DRIVER_VERSION_NUM      0x01050000
+#define VMXNET3_DRIVER_VERSION_NUM      0x01060000
 
 #if defined(CONFIG_PCI_MSI)
 	/* RSS only makes sense if MSI-X is supported. */
-- 
2.11.0

