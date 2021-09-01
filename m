Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862DB3FD020
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242933AbhIAALW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:11:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243443AbhIAAJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:09:23 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18104IMj130135
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tQE6rPq6VdWTS3HxtldlMm3dpmKebOQ5bf6L05Jjeh0=;
 b=ma5RV7/QCH8iICclvSs2K3Y28Dpx6gwm9wLI5v0+GtQoVPcLiZd7EbMtIKE4ivVPbJGC
 gPB+DD/IQtVluWRScSBCrr+EOqfooN9B81SWF2p4xaWJIcY9YYGW3WqARaLTxxLSGPe9
 tDCxy7cLClXk/OCImTdrW3R+CbT7io+unSbHl85v9F3bwDDA2gGjyGHqnjyAW7F8hr5M
 aCi1wKc0OTNqaNakzzpYLHk54I/fKRFkGs2ZxEdi6CWeeZvv854bSEJPAyYfblsaCZGC
 H4NwPlYgUccJPwisM8YhRt0VFtPB3x4R0tVMXaM1JQTpSrN+VoeK0yT/Tl8vSUGse6OB yA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3asxncg2kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:26 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18107eFQ022641
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 00:08:26 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 3aqcsca6h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 00:08:26 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18108P5T36176206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 00:08:25 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1799E78064;
        Wed,  1 Sep 2021 00:08:25 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3DCB7805F;
        Wed,  1 Sep 2021 00:08:23 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.237.107])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 00:08:23 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-next 6/9] ibmvnic: Use bitmap for LTB map_ids
Date:   Tue, 31 Aug 2021 17:08:09 -0700
Message-Id: <20210901000812.120968-7-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901000812.120968-1-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e6Y5andw62o27Xz9RZ-4_8X-0ucwpA7F
X-Proofpoint-ORIG-GUID: e6Y5andw62o27Xz9RZ-4_8X-0ucwpA7F
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 adultscore=0 impostorscore=0 spamscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108310133
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
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 12 ++++++++----
 drivers/net/ethernet/ibm/ibmvnic.h |  3 ++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 8894afdb3cb3..30153a8bb5ec 100644
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
 
@@ -1231,8 +1234,6 @@ static int init_resources(struct ibmvnic_adapter *adapter)
 		return rc;
 	}
 
-	adapter->map_id = 1;
-
 	rc = init_napi(adapter);
 	if (rc)
 		return rc;
@@ -5553,6 +5554,9 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
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
2.31.1

