Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827B21096A2
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfKYXNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:13:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727329AbfKYXNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:13:14 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAPMvJC9126473;
        Mon, 25 Nov 2019 18:13:09 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wfjq0t4rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Nov 2019 18:13:09 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAPMtVvj012635;
        Mon, 25 Nov 2019 23:13:13 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 2wevd5x32x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Nov 2019 23:13:13 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAPND7I658982758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Nov 2019 23:13:07 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2499BE058;
        Mon, 25 Nov 2019 23:13:06 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09169BE05A;
        Mon, 25 Nov 2019 23:13:06 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.224.141])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 25 Nov 2019 23:13:05 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com,
        julietk@linux.vnet.ibm.com, Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net v2 4/4] ibmvnic: Serialize device queries
Date:   Mon, 25 Nov 2019 17:12:56 -0600
Message-Id: <1574723576-27553-5-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574723576-27553-1-git-send-email-tlfalcon@linux.ibm.com>
References: <20191125112359.7a468352@cakuba.hsd1.ca.comcast.net>
 <1574723576-27553-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-25_06:2019-11-21,2019-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=3
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911250181
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide some serialization for device CRQ commands
and queries to ensure that the shared variable used for
storing return codes is properly synchronized.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 54 ++++++++++++++++++++++++++++++++++----
 drivers/net/ethernet/ibm/ibmvnic.h |  2 ++
 2 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 4504f96ee07d..42e15b31a5ff 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -210,11 +210,14 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 	ltb->map_id = adapter->map_id;
 	adapter->map_id++;
 
+	mutex_lock(&adapter->fw_lock);
+	adapter->fw_done_rc = 0;
 	reinit_completion(&adapter->fw_done);
 	rc = send_request_map(adapter, ltb->addr,
 			      ltb->size, ltb->map_id);
 	if (rc) {
 		dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
+		mutex_unlock(&adapter->fw_lock);
 		return rc;
 	}
 
@@ -224,6 +227,7 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 			"Long term map request aborted or timed out,rc = %d\n",
 			rc);
 		dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
+		mutex_unlock(&adapter->fw_lock);
 		return rc;
 	}
 
@@ -231,8 +235,10 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 		dev_err(dev, "Couldn't map long term buffer,rc = %d\n",
 			adapter->fw_done_rc);
 		dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
+		mutex_unlock(&adapter->fw_lock);
 		return -1;
 	}
+	mutex_unlock(&adapter->fw_lock);
 	return 0;
 }
 
@@ -258,15 +264,21 @@ static int reset_long_term_buff(struct ibmvnic_adapter *adapter,
 
 	memset(ltb->buff, 0, ltb->size);
 
+	mutex_lock(&adapter->fw_lock);
+	adapter->fw_done_rc = 0;
+
 	reinit_completion(&adapter->fw_done);
 	rc = send_request_map(adapter, ltb->addr, ltb->size, ltb->map_id);
-	if (rc)
+	if (rc) {
+		mutex_unlock(&adapter->fw_lock);
 		return rc;
+	}
 
 	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
 	if (rc) {
 		dev_info(dev,
 			 "Reset failed, long term map request timed out or aborted\n");
+		mutex_unlock(&adapter->fw_lock);
 		return rc;
 	}
 
@@ -274,8 +286,10 @@ static int reset_long_term_buff(struct ibmvnic_adapter *adapter,
 		dev_info(dev,
 			 "Reset failed, attempting to free and reallocate buffer\n");
 		free_long_term_buff(adapter, ltb);
+		mutex_unlock(&adapter->fw_lock);
 		return alloc_long_term_buff(adapter, ltb, ltb->size);
 	}
+	mutex_unlock(&adapter->fw_lock);
 	return 0;
 }
 
@@ -992,18 +1006,25 @@ static int ibmvnic_get_vpd(struct ibmvnic_adapter *adapter)
 	if (adapter->vpd->buff)
 		len = adapter->vpd->len;
 
+	mutex_lock(&adapter->fw_lock);
+	adapter->fw_done_rc = 0;
 	reinit_completion(&adapter->fw_done);
+
 	crq.get_vpd_size.first = IBMVNIC_CRQ_CMD;
 	crq.get_vpd_size.cmd = GET_VPD_SIZE;
 	rc = ibmvnic_send_crq(adapter, &crq);
-	if (rc)
+	if (rc) {
+		mutex_unlock(&adapter->fw_lock);
 		return rc;
+	}
 
 	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
 	if (rc) {
 		dev_err(dev, "Could not retrieve VPD size, rc = %d\n", rc);
+		mutex_unlock(&adapter->fw_lock);
 		return rc;
 	}
+	mutex_unlock(&adapter->fw_lock);
 
 	if (!adapter->vpd->len)
 		return -ENODATA;
@@ -1030,7 +1051,10 @@ static int ibmvnic_get_vpd(struct ibmvnic_adapter *adapter)
 		return -ENOMEM;
 	}
 
+	mutex_lock(&adapter->fw_lock);
+	adapter->fw_done_rc = 0;
 	reinit_completion(&adapter->fw_done);
+
 	crq.get_vpd.first = IBMVNIC_CRQ_CMD;
 	crq.get_vpd.cmd = GET_VPD;
 	crq.get_vpd.ioba = cpu_to_be32(adapter->vpd->dma_addr);
@@ -1039,6 +1063,7 @@ static int ibmvnic_get_vpd(struct ibmvnic_adapter *adapter)
 	if (rc) {
 		kfree(adapter->vpd->buff);
 		adapter->vpd->buff = NULL;
+		mutex_unlock(&adapter->fw_lock);
 		return rc;
 	}
 
@@ -1047,9 +1072,11 @@ static int ibmvnic_get_vpd(struct ibmvnic_adapter *adapter)
 		dev_err(dev, "Unable to retrieve VPD, rc = %d\n", rc);
 		kfree(adapter->vpd->buff);
 		adapter->vpd->buff = NULL;
+		mutex_unlock(&adapter->fw_lock);
 		return rc;
 	}
 
+	mutex_unlock(&adapter->fw_lock);
 	return 0;
 }
 
@@ -1750,10 +1777,14 @@ static int __ibmvnic_set_mac(struct net_device *netdev, u8 *dev_addr)
 	crq.change_mac_addr.cmd = CHANGE_MAC_ADDR;
 	ether_addr_copy(&crq.change_mac_addr.mac_addr[0], dev_addr);
 
+	mutex_lock(&adapter->fw_lock);
+	adapter->fw_done_rc = 0;
 	reinit_completion(&adapter->fw_done);
+
 	rc = ibmvnic_send_crq(adapter, &crq);
 	if (rc) {
 		rc = -EIO;
+		mutex_unlock(&adapter->fw_lock);
 		goto err;
 	}
 
@@ -1761,9 +1792,10 @@ static int __ibmvnic_set_mac(struct net_device *netdev, u8 *dev_addr)
 	/* netdev->dev_addr is changed in handle_change_mac_rsp function */
 	if (rc || adapter->fw_done_rc) {
 		rc = -EIO;
+		mutex_unlock(&adapter->fw_lock);
 		goto err;
 	}
-
+	mutex_unlock(&adapter->fw_lock);
 	return 0;
 err:
 	ether_addr_copy(adapter->mac_addr, netdev->dev_addr);
@@ -4481,15 +4513,24 @@ static int send_query_phys_parms(struct ibmvnic_adapter *adapter)
 	memset(&crq, 0, sizeof(crq));
 	crq.query_phys_parms.first = IBMVNIC_CRQ_CMD;
 	crq.query_phys_parms.cmd = QUERY_PHYS_PARMS;
+
+	mutex_lock(&adapter->fw_lock);
+	adapter->fw_done_rc = 0;
 	reinit_completion(&adapter->fw_done);
+
 	rc = ibmvnic_send_crq(adapter, &crq);
-	if (rc)
+	if (rc) {
+		mutex_unlock(&adapter->fw_lock);
 		return rc;
+	}
 
 	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
-	if (rc)
+	if (rc) {
+		mutex_unlock(&adapter->fw_lock);
 		return rc;
+	}
 
+	mutex_unlock(&adapter->fw_lock);
 	return adapter->fw_done_rc ? -EIO : 0;
 }
 
@@ -5045,6 +5086,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 			  __ibmvnic_delayed_reset);
 	INIT_LIST_HEAD(&adapter->rwi_list);
 	spin_lock_init(&adapter->rwi_lock);
+	mutex_init(&adapter->fw_lock);
 	init_completion(&adapter->init_done);
 	init_completion(&adapter->fw_done);
 	init_completion(&adapter->reset_done);
@@ -5106,6 +5148,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 ibmvnic_init_fail:
 	release_sub_crqs(adapter, 1);
 	release_crq_queue(adapter);
+	mutex_destroy(&adapter->fw_lock);
 	free_netdev(netdev);
 
 	return rc;
@@ -5130,6 +5173,7 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	adapter->state = VNIC_REMOVED;
 
 	rtnl_unlock();
+	mutex_destroy(&adapter->fw_lock);
 	device_remove_file(&dev->dev, &dev_attr_failover);
 	free_netdev(netdev);
 	dev_set_drvdata(&dev->dev, NULL);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index ebc39248b334..60eccaf91b12 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -1026,6 +1026,8 @@ struct ibmvnic_adapter {
 	int init_done_rc;
 
 	struct completion fw_done;
+	/* Used for serialization of device commands */
+	struct mutex fw_lock;
 	int fw_done_rc;
 
 	struct completion reset_done;
-- 
2.12.3

