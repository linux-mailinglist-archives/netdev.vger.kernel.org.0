Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3774393A03
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 02:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbhE1AFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 20:05:43 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26156 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236616AbhE1AFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 20:05:21 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14S015iU008071;
        Thu, 27 May 2021 17:01:34 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38sxpmd046-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:01:34 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 17:01:32 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 27 May 2021 17:01:29 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>,
        "Nikolay Assa" <nassa@marvell.com>
Subject: [RFC PATCH v6 18/27] qedn: Add qedn_claim_dev API support
Date:   Fri, 28 May 2021 02:58:53 +0300
Message-ID: <20210527235902.2185-19-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210527235902.2185-1-smalin@marvell.com>
References: <20210527235902.2185-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: LEHBHUr4OYf3NMbcdDl_hUhqJECkegFR
X-Proofpoint-GUID: LEHBHUr4OYf3NMbcdDl_hUhqJECkegFR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_13:2021-05-27,2021-05-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Assa <nassa@marvell.com>

This patch introduces the qedn_claim_dev() network service which the
offload device (qedn) is using through the paired net-device (qede).
qedn_claim_dev() returns true if the IP addr(IPv4 or IPv6) of the target
server is reachable via the net-device which is paired with the
offloaded device.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Nikolay Assa <nassa@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/hw/qedn/qedn.h      |  4 +++
 drivers/nvme/hw/qedn/qedn_main.c | 50 +++++++++++++++++++++++++++++---
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
index 931efc3afbaa..0ce1e19d1ba8 100644
--- a/drivers/nvme/hw/qedn/qedn.h
+++ b/drivers/nvme/hw/qedn/qedn.h
@@ -8,6 +8,10 @@
 
 #include <linux/qed/qed_if.h>
 #include <linux/qed/qed_nvmetcp_if.h>
+#include <linux/qed/qed_nvmetcp_ip_services_if.h>
+#include <linux/qed/qed_chain.h>
+#include <linux/qed/storage_common.h>
+#include <linux/qed/nvmetcp_common.h>
 
 /* Driver includes */
 #include "../../host/tcp-offload.h"
diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qedn_main.c
index 1888c72805cb..2f02867c5c36 100644
--- a/drivers/nvme/hw/qedn/qedn_main.c
+++ b/drivers/nvme/hw/qedn/qedn_main.c
@@ -22,13 +22,56 @@ static struct pci_device_id qedn_pci_tbl[] = {
 	{0, 0},
 };
 
+static int
+qedn_find_dev(struct nvme_tcp_ofld_dev *dev,
+	      struct nvme_tcp_ofld_ctrl_con_params *conn_params,
+	      void *qctrl)
+{
+	struct pci_dev *qede_pdev = NULL;
+	struct sockaddr remote_mac_addr;
+	struct net_device *ndev = NULL;
+	u16 vlan_id = 0;
+	int rc = 0;
+
+	/* qedn utilizes host network stack through paired qede device for
+	 * non-offload traffic. First we verify there is valid route to remote
+	 * peer.
+	 */
+	if (conn_params->remote_ip_addr.ss_family == AF_INET) {
+		rc = qed_route_ipv4(&conn_params->local_ip_addr,
+				    &conn_params->remote_ip_addr,
+				    &remote_mac_addr, &ndev);
+	} else if (conn_params->remote_ip_addr.ss_family == AF_INET6) {
+		rc = qed_route_ipv6(&conn_params->local_ip_addr,
+				    &conn_params->remote_ip_addr,
+				    &remote_mac_addr, &ndev);
+	} else {
+		pr_err("address family %d not supported\n",
+		       conn_params->remote_ip_addr.ss_family);
+
+		return false;
+	}
+
+	if (rc)
+		return false;
+
+	qed_vlan_get_ndev(&ndev, &vlan_id);
+
+	dev->ndev = ndev;
+
+	/* route found through ndev - validate this is qede*/
+	qede_pdev = qed_validate_ndev(ndev);
+	if (!qede_pdev)
+		return false;
+
+	return true;
+}
+
 static int
 qedn_claim_dev(struct nvme_tcp_ofld_dev *dev,
 	       struct nvme_tcp_ofld_ctrl_con_params *conn_params)
 {
-	/* Placeholder - qedn_claim_dev */
-
-	return 0;
+	return qedn_find_dev(dev, conn_params, NULL);
 }
 
 static int qedn_setup_ctrl(struct nvme_tcp_ofld_ctrl *ctrl)
@@ -41,7 +84,6 @@ static int qedn_setup_ctrl(struct nvme_tcp_ofld_ctrl *ctrl)
 static int qedn_release_ctrl(struct nvme_tcp_ofld_ctrl *ctrl)
 {
 	/* Placeholder - qedn_release_ctrl */
-
 	return 0;
 }
 
-- 
2.22.0

