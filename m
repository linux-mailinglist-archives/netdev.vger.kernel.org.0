Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFD681974C
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 06:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfEJENy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 00:13:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49124 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726132AbfEJENy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 00:13:54 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4A42vVB073305
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 00:13:53 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2scvyn9ucq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 00:13:53 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <tlfalcon@linux.ibm.com>;
        Fri, 10 May 2019 05:13:52 +0100
Received: from b03cxnp07029.gho.boulder.ibm.com (9.17.130.16)
        by e34.co.us.ibm.com (192.168.1.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 May 2019 05:13:50 +0100
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4A4DnDl24445060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 04:13:49 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2FEB6E053;
        Fri, 10 May 2019 04:13:48 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67ED86E056;
        Fri, 10 May 2019 04:13:48 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.213.250])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 10 May 2019 04:13:48 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     julietk@linux.ibm.com, Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net] net/ibmvnic: Update MAC address settings after adapter reset
Date:   Thu,  9 May 2019 23:13:43 -0500
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
x-cbid: 19051004-0016-0000-0000-000009B00DB3
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011080; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01201127; UDB=6.00630282; IPR=6.00982022;
 MB=3.00026822; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-10 04:13:51
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051004-0017-0000-0000-00004327DC21
Message-Id: <1557461624-21959-1-git-send-email-tlfalcon@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905100027
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was discovered in testing that the underlying hardware MAC
address will revert to initial settings following a device reset,
but the driver fails to resend the current OS MAC settings. This
oversight can result in dropped packets should the scenario occur.
Fix this by informing hardware of current MAC address settings 
following any adapter initialization or resets.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 53 ++++++++++++++++++++------------------
 drivers/net/ethernet/ibm/ibmvnic.h |  2 --
 2 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b398d6c94dbd..faee60914874 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -118,7 +118,7 @@ static int init_sub_crq_irqs(struct ibmvnic_adapter *adapter);
 static int ibmvnic_init(struct ibmvnic_adapter *);
 static int ibmvnic_reset_init(struct ibmvnic_adapter *);
 static void release_crq_queue(struct ibmvnic_adapter *);
-static int __ibmvnic_set_mac(struct net_device *netdev, struct sockaddr *p);
+static int __ibmvnic_set_mac(struct net_device *, u8 *);
 static int init_crq_queue(struct ibmvnic_adapter *adapter);
 static int send_query_phys_parms(struct ibmvnic_adapter *adapter);
 
@@ -849,11 +849,7 @@ static int ibmvnic_login(struct net_device *netdev)
 		}
 	} while (retry);
 
-	/* handle pending MAC address changes after successful login */
-	if (adapter->mac_change_pending) {
-		__ibmvnic_set_mac(netdev, &adapter->desired.mac);
-		adapter->mac_change_pending = false;
-	}
+	__ibmvnic_set_mac(netdev, adapter->mac_addr);
 
 	return 0;
 }
@@ -1686,28 +1682,40 @@ static void ibmvnic_set_multi(struct net_device *netdev)
 	}
 }
 
-static int __ibmvnic_set_mac(struct net_device *netdev, struct sockaddr *p)
+static int __ibmvnic_set_mac(struct net_device *netdev, u8 *dev_addr)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	struct sockaddr *addr = p;
 	union ibmvnic_crq crq;
 	int rc;
 
-	if (!is_valid_ether_addr(addr->sa_data))
-		return -EADDRNOTAVAIL;
+	if (!is_valid_ether_addr(dev_addr)) {
+		rc = -EADDRNOTAVAIL;
+		goto err;
+	}
 
 	memset(&crq, 0, sizeof(crq));
 	crq.change_mac_addr.first = IBMVNIC_CRQ_CMD;
 	crq.change_mac_addr.cmd = CHANGE_MAC_ADDR;
-	ether_addr_copy(&crq.change_mac_addr.mac_addr[0], addr->sa_data);
+	ether_addr_copy(&crq.change_mac_addr.mac_addr[0], dev_addr);
 
 	init_completion(&adapter->fw_done);
 	rc = ibmvnic_send_crq(adapter, &crq);
-	if (rc)
-		return rc;
+	if (rc) {
+		rc = -EIO;
+		goto err;
+	}
+
 	wait_for_completion(&adapter->fw_done);
 	/* netdev->dev_addr is changed in handle_change_mac_rsp function */
-	return adapter->fw_done_rc ? -EIO : 0;
+	if (adapter->fw_done_rc) {
+		rc = -EIO;
+		goto err;
+	}
+
+	return 0;
+err:
+	ether_addr_copy(adapter->mac_addr, netdev->dev_addr);
+	return rc;
 }
 
 static int ibmvnic_set_mac(struct net_device *netdev, void *p)
@@ -1716,13 +1724,10 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
 	struct sockaddr *addr = p;
 	int rc;
 
-	if (adapter->state == VNIC_PROBED) {
-		memcpy(&adapter->desired.mac, addr, sizeof(struct sockaddr));
-		adapter->mac_change_pending = true;
-		return 0;
-	}
-
-	rc = __ibmvnic_set_mac(netdev, addr);
+	rc = 0;
+	ether_addr_copy(adapter->mac_addr, addr->sa_data);
+	if (adapter->state != VNIC_PROBED)
+		rc = __ibmvnic_set_mac(netdev, addr->sa_data);
 
 	return rc;
 }
@@ -3937,8 +3942,8 @@ static int handle_change_mac_rsp(union ibmvnic_crq *crq,
 		dev_err(dev, "Error %ld in CHANGE_MAC_ADDR_RSP\n", rc);
 		goto out;
 	}
-	memcpy(netdev->dev_addr, &crq->change_mac_addr_rsp.mac_addr[0],
-	       ETH_ALEN);
+	ether_addr_copy(netdev->dev_addr,
+			&crq->change_mac_addr_rsp.mac_addr[0]);
 out:
 	complete(&adapter->fw_done);
 	return rc;
@@ -4852,8 +4857,6 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	init_completion(&adapter->init_done);
 	adapter->resetting = false;
 
-	adapter->mac_change_pending = false;
-
 	do {
 		rc = init_crq_queue(adapter);
 		if (rc) {
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index cffdac372a33..dcf2eb6d9290 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -969,7 +969,6 @@ struct ibmvnic_tunables {
 	u64 rx_entries;
 	u64 tx_entries;
 	u64 mtu;
-	struct sockaddr mac;
 };
 
 struct ibmvnic_adapter {
@@ -1091,7 +1090,6 @@ struct ibmvnic_adapter {
 	bool resetting;
 	bool napi_enabled, from_passive_init;
 
-	bool mac_change_pending;
 	bool failover_pending;
 	bool force_reset_recovery;
 
-- 
2.12.3

