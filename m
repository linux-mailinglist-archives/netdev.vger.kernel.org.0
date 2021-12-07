Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A42746B606
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhLGIgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:36:16 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:20448 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232964AbhLGIgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 03:36:15 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Dec 2021 03:36:15 EST
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 7 Dec 2021 00:17:38 -0800
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 51C6620397;
        Tue,  7 Dec 2021 00:17:40 -0800 (PST)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 4A548AA1DC; Tue,  7 Dec 2021 00:17:40 -0800 (PST)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] vmxnet3: fix minimum vectors alloc issue
Date:   Tue, 7 Dec 2021 00:17:37 -0800
Message-ID: <20211207081737.14000-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'Commit 39f9895a00f4 ("vmxnet3: add support for 32 Tx/Rx queues")'
added support for 32Tx/Rx queues. Within that patch, value of
VMXNET3_LINUX_MIN_MSIX_VECT was updated.

However, there is a case (numvcpus = 2) which actually requires 3
intrs which matches VMXNET3_LINUX_MIN_MSIX_VECT which then is
treated as failure by stack to allocate more vectors. This patch
fixes this issue.

Fixes: 39f9895a00f4 ("vmxnet3: add support for 32 Tx/Rx queues")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 14fae317bc70..fd407c0e2856 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3261,7 +3261,7 @@ vmxnet3_alloc_intr_resources(struct vmxnet3_adapter *adapter)
 
 #ifdef CONFIG_PCI_MSI
 	if (adapter->intr.type == VMXNET3_IT_MSIX) {
-		int i, nvec;
+		int i, nvec, nvec_allocated;
 
 		nvec  = adapter->share_intr == VMXNET3_INTR_TXSHARE ?
 			1 : adapter->num_tx_queues;
@@ -3274,14 +3274,15 @@ vmxnet3_alloc_intr_resources(struct vmxnet3_adapter *adapter)
 		for (i = 0; i < nvec; i++)
 			adapter->intr.msix_entries[i].entry = i;
 
-		nvec = vmxnet3_acquire_msix_vectors(adapter, nvec);
-		if (nvec < 0)
+		nvec_allocated = vmxnet3_acquire_msix_vectors(adapter, nvec);
+		if (nvec_allocated < 0)
 			goto msix_err;
 
 		/* If we cannot allocate one MSIx vector per queue
 		 * then limit the number of rx queues to 1
 		 */
-		if (nvec == VMXNET3_LINUX_MIN_MSIX_VECT) {
+		if (nvec_allocated == VMXNET3_LINUX_MIN_MSIX_VECT &&
+		    nvec != VMXNET3_LINUX_MIN_MSIX_VECT) {
 			if (adapter->share_intr != VMXNET3_INTR_BUDDYSHARE
 			    || adapter->num_rx_queues != 1) {
 				adapter->share_intr = VMXNET3_INTR_TXSHARE;
@@ -3291,14 +3292,14 @@ vmxnet3_alloc_intr_resources(struct vmxnet3_adapter *adapter)
 			}
 		}
 
-		adapter->intr.num_intrs = nvec;
+		adapter->intr.num_intrs = nvec_allocated;
 		return;
 
 msix_err:
 		/* If we cannot allocate MSIx vectors use only one rx queue */
 		dev_info(&adapter->pdev->dev,
 			 "Failed to enable MSI-X, error %d. "
-			 "Limiting #rx queues to 1, try MSI.\n", nvec);
+			 "Limiting #rx queues to 1, try MSI.\n", nvec_allocated);
 
 		adapter->intr.type = VMXNET3_IT_MSI;
 	}
-- 
2.11.0

