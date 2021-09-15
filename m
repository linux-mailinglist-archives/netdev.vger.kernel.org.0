Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656EF40BEA1
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbhIODyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:54:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16752 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236159AbhIODye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:54:34 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18F0CRrC034722
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Jsk2R6ZUYFJG7D3Xc8Da4lDSV4BiePSMPVBBYZ4hBB4=;
 b=mTPUTXeR6xzYvpXH+ZUOeqOwjLwXfZ9O2e+bKRYeweDHds5y55gVMyLYZXJ3ixiJ1att
 XfR16tX8ctved0atsFyeB6LrlZE31xLHrsnaOJ22VRV0JKvsH6uFJi3ImYtyPkte/jkt
 OSybrqQd8ttYS7Pd2Veng8ZjShz48sbD0VnkEWqgrJ3mMe18St1r7W6gxF69eCIBW29L
 pxubhCzUmDHxg28iLtX+VVXWF3VlYwuU3+4oXw3iPE/PaY80yOkbFMWkjptrf0zBPMgx
 aPl3KGMolOs0C9nG41ZKMc5R2JJ3cozfO9YV40KaHBxrZ2bTWfHapPf94r9D+A2QNddh PQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b32u2fc8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:15 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18F3lPU9006021
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:14 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 3b0m3b8506-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:14 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18F3rEqO39715178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:53:14 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1A7D112061;
        Wed, 15 Sep 2021 03:53:13 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5962112063;
        Wed, 15 Sep 2021 03:53:12 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.142.77])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 15 Sep 2021 03:53:12 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.vnet.ibm.com>
Subject: [PATCH net-next RESEND v2 6/9] ibmvnic: Use bitmap for LTB map_ids
Date:   Tue, 14 Sep 2021 20:52:56 -0700
Message-Id: <20210915035259.355092-7-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915035259.355092-1-sukadev@linux.ibm.com>
References: <20210915035259.355092-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ERFmOV_0jKiRIvdWHdDPeyUDrJ4pMtzG
X-Proofpoint-ORIG-GUID: ERFmOV_0jKiRIvdWHdDPeyUDrJ4pMtzG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-11_02,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109140109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a follow-on patch, we will reuse long term buffers when possible.
When doing so we have to be careful to properly assign map ids. We
can no longer assign them sequentially because a lower map id may be
available and we could wrap at 255 and collide with an in-use map id.

Instead, use a bitmap to track active map ids and to find a free map id.
Don't need to take locks here since the map_id only changes during reset
and at that time only the reset worker thread should be using the adapter.

Noticed this when analyzing an error Dany Madden ran into with the
patch set.

Reported-by: Dany Madden <drt@linux.ibm.com>
Reviewed-by: Rick Lindsley <ricklind@linux.vnet.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 12 ++++++++----
 drivers/net/ethernet/ibm/ibmvnic.h |  3 ++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index bb9b8aec9c9b..4603597a9c10 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -228,8 +228,9 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 		dev_err(dev, "Couldn't alloc long term buffer\n");
 		return -ENOMEM;
 	}
-	ltb->map_id = adapter->map_id;
-	adapter->map_id++;
+	ltb->map_id = find_first_zero_bit(adapter->map_ids,
+					  MAX_MAP_ID);
+	bitmap_set(adapter->map_ids, ltb->map_id, 1);
 
 	mutex_lock(&adapter->fw_lock);
 	adapter->fw_done_rc = 0;
@@ -284,6 +285,8 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
 
 	ltb->buff = NULL;
+	/* mark this map_id free */
+	bitmap_clear(adapter->map_ids, ltb->map_id, 1);
 	ltb->map_id = 0;
 }
 
@@ -1235,8 +1238,6 @@ static int init_resources(struct ibmvnic_adapter *adapter)
 		return rc;
 	}
 
-	adapter->map_id = 1;
-
 	rc = init_napi(adapter);
 	if (rc)
 		return rc;
@@ -5557,6 +5558,9 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	adapter->vdev = dev;
 	adapter->netdev = netdev;
 	adapter->login_pending = false;
+	memset(&adapter->map_ids, 0, sizeof(adapter->map_ids));
+	/* map_ids start at 1, so ensure map_id 0 is always "in-use" */
+	bitmap_set(adapter->map_ids, 0, 1);
 
 	ether_addr_copy(adapter->mac_addr, mac_addr_p);
 	ether_addr_copy(netdev->dev_addr, adapter->mac_addr);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 5652566818fb..e97f1aa98c05 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -979,7 +979,8 @@ struct ibmvnic_adapter {
 	u64 opt_tx_entries_per_subcrq;
 	u64 opt_rxba_entries_per_subcrq;
 	__be64 tx_rx_desc_req;
-	u8 map_id;
+#define MAX_MAP_ID	255
+	DECLARE_BITMAP(map_ids, MAX_MAP_ID);
 	u32 num_active_rx_scrqs;
 	u32 num_active_rx_pools;
 	u32 num_active_rx_napi;
-- 
2.26.2

