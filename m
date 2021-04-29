Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A990536F058
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 21:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhD2TSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 15:18:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11568 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241984AbhD2TNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 15:13:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13TJ5GSr027367;
        Thu, 29 Apr 2021 12:10:55 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 387rpnamsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Apr 2021 12:10:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Apr
 2021 12:10:53 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 12:10:50 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>, <hch@lst.de>, <axboe@fb.com>,
        <kbusch@kernel.org>
CC:     =?UTF-8?q?David=20S=20=2E=20Miller=20davem=20=40=20davemloft=20=2E=20net=20=C2=A0--cc=3DJakub=20Kicinski?= 
        <kuba@kernel.org>, <smalin@marvell.com>, <aelior@marvell.com>,
        <mkalderon@marvell.com>, <okulkarni@marvell.com>,
        <pkushwaha@marvell.com>, <malin1024@gmail.com>,
        Nikolay Assa <nassa@marvell.com>
Subject: [RFC PATCH v4 18/27] qedn: Add qedn_claim_dev API support
Date:   Thu, 29 Apr 2021 22:09:17 +0300
Message-ID: <20210429190926.5086-19-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210429190926.5086-1-smalin@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: JNay_2PNs0-8k6GGjFuyCvYOPGSTGelf
X-Proofpoint-ORIG-GUID: JNay_2PNs0-8k6GGjFuyCvYOPGSTGelf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-29_10:2021-04-28,2021-04-29 signatures=0
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
---
 drivers/nvme/hw/qedn/qedn.h      |  4 +++
 drivers/nvme/hw/qedn/qedn_main.c | 42 ++++++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
index c1ac17eabcb7..7efe2366eb7c 100644
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
index e3e8e3676b79..52007d35622d 100644
--- a/drivers/nvme/hw/qedn/qedn_main.c
+++ b/drivers/nvme/hw/qedn/qedn_main.c
@@ -27,9 +27,47 @@ static int
 qedn_claim_dev(struct nvme_tcp_ofld_dev *dev,
 	       struct nvme_tcp_ofld_ctrl_con_params *conn_params)
 {
-	/* Placeholder - qedn_claim_dev */
+	struct pci_dev *qede_pdev = NULL;
+	struct net_device *ndev = NULL;
+	u16 vlan_id = 0;
+	int rc = 0;
 
-	return 0;
+	/* qedn utilizes host network stack through paired qede device for
+	 * non-offload traffic. First we verify there is valid route to remote
+	 * peer.
+	 */
+	if (conn_params->remote_ip_addr.ss_family == AF_INET) {
+		rc = qed_route_ipv4(&conn_params->local_ip_addr,
+				    &conn_params->remote_ip_addr,
+				    &conn_params->remote_mac_addr,
+				    &ndev);
+	} else if (conn_params->remote_ip_addr.ss_family == AF_INET6) {
+		rc = qed_route_ipv6(&conn_params->local_ip_addr,
+				    &conn_params->remote_ip_addr,
+				    &conn_params->remote_mac_addr,
+				    &ndev);
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
+	conn_params->vlan_id = vlan_id;
+
+	/* route found through ndev - validate this is qede*/
+	qede_pdev = qed_validate_ndev(ndev);
+	if (!qede_pdev)
+		return false;
+
+	dev->qede_pdev = qede_pdev;
+	dev->ndev = ndev;
+
+	return true;
 }
 
 static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qid,
-- 
2.22.0

