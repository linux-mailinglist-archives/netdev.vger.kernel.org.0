Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7402606A6B
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 23:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiJTVlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 17:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiJTVlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 17:41:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E051D6A64
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 14:41:00 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KL9RU4032685
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 21:40:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=bjvSBAgRnfo6afQ5lMTh5iVDSBEPgoM4p/osS26dkc0=;
 b=fuJGIjjGZifiUKOr/U8MzaGGeAi7a8iLBa5HmRlteTnnwVRBZ6MwI6lk5QDG7tit9t9d
 2BVTQs01IrX9Z92LC2oHknZ1heJAE5D5rCee/+N4eOMqkacZh+rZSKTNtrGmBJH2SU+S
 crd+PuAXNyNQ2uJXO2vDUxIydbSF7b93zyOXB0sDJSFVCJgdkaIZEfEJkecT2uaY5iwf
 odXsiL7sVBWdin66svAfO43ZCxCOKljHegQE1Dt6zGzO8IRo+4aomXAvd0yWuqo6hdTe
 iBERKz8GgLCH+7p7+7YkZS2FPFaAn7CuJDxIqlDAzPGh+g/YlDppM/Z9V+01v1PfkDzL /A== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbdv28yx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 21:40:59 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KLZ77A029339
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 21:40:59 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 3kakejtytp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 21:40:59 +0000
Received: from smtpav02.wdc07v.mail.ibm.com ([9.208.128.114])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KLeu9O19268186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 21:40:57 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FC315805E;
        Thu, 20 Oct 2022 21:40:56 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA1FA5805F;
        Thu, 20 Oct 2022 21:40:55 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.77.147.33])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 21:40:55 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     nick.child@ibm.com, Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH v2 net-next] ibmveth: Always stop tx queues during close
Date:   Thu, 20 Oct 2022 16:40:52 -0500
Message-Id: <20221020214052.33737-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZKGW1gMHB4wuaKvt88IXqbkW8BEN3D70
X-Proofpoint-GUID: ZKGW1gMHB4wuaKvt88IXqbkW8BEN3D70
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_11,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 spamscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200136
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netif_stop_all_queues must be called before calling H_FREE_LOGICAL_LAN.
As a result, we can remove the pool_config field from the ibmveth
adapter structure.

Some device configuration changes call ibmveth_close in order to free
the current resources held by the device. These functions then make
their changes and call ibmveth_open to reallocate and reserve resources
for the device.

Prior to this commit, the flag pool_config was used to tell ibmveth_close
that it should not halt the transmit queue. pool_config was introduced in
commit 860f242eb534 ("[PATCH] ibmveth change buffer pools dynamically")
to avoid interrupting the tx flow when making rx config changes. Since
then, other commits adopted this approach, even if making tx config
changes.

The issue with this approach was that the hypervisor freed all of
the devices control structures after the hcall H_FREE_LOGICAL_LAN
was performed but the transmit queues were never stopped. So the higher
layers in the network stack would continue transmission but any
H_SEND_LOGICAL_LAN hcall would fail with H_PARAMETER until the
hypervisor's structures for the device were allocated with the
H_REGISTER_LOGICAL_LAN hcall in ibmveth_open. This resulted in
no real networking harm but did cause several of these error
messages to be logged: "h_send_logical_lan failed with rc=-4"

So, instead of trying to keep the transmit queues alive during network
configuration changes, just stop the queues, make necessary changes then
restart the queues.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 18 +-----------------
 drivers/net/ethernet/ibm/ibmveth.h |  1 -
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 3b14dc93f59d..7d79006250ae 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -690,8 +690,7 @@ static int ibmveth_close(struct net_device *netdev)
 
 	napi_disable(&adapter->napi);
 
-	if (!adapter->pool_config)
-		netif_tx_stop_all_queues(netdev);
+	netif_tx_stop_all_queues(netdev);
 
 	h_vio_signal(adapter->vdev->unit_address, VIO_IRQ_DISABLE);
 
@@ -799,9 +798,7 @@ static int ibmveth_set_csum_offload(struct net_device *dev, u32 data)
 
 	if (netif_running(dev)) {
 		restart = 1;
-		adapter->pool_config = 1;
 		ibmveth_close(dev);
-		adapter->pool_config = 0;
 	}
 
 	set_attr = 0;
@@ -883,9 +880,7 @@ static int ibmveth_set_tso(struct net_device *dev, u32 data)
 
 	if (netif_running(dev)) {
 		restart = 1;
-		adapter->pool_config = 1;
 		ibmveth_close(dev);
-		adapter->pool_config = 0;
 	}
 
 	set_attr = 0;
@@ -1535,9 +1530,7 @@ static int ibmveth_change_mtu(struct net_device *dev, int new_mtu)
 	   only the buffer pools necessary to hold the new MTU */
 	if (netif_running(adapter->netdev)) {
 		need_restart = 1;
-		adapter->pool_config = 1;
 		ibmveth_close(adapter->netdev);
-		adapter->pool_config = 0;
 	}
 
 	/* Look for an active buffer pool that can hold the new MTU */
@@ -1701,7 +1694,6 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	adapter->vdev = dev;
 	adapter->netdev = netdev;
 	adapter->mcastFilterSize = be32_to_cpu(*mcastFilterSize_p);
-	adapter->pool_config = 0;
 	ibmveth_init_link_settings(netdev);
 
 	netif_napi_add_weight(netdev, &adapter->napi, ibmveth_poll, 16);
@@ -1841,9 +1833,7 @@ static ssize_t veth_pool_store(struct kobject *kobj, struct attribute *attr,
 					return -ENOMEM;
 				}
 				pool->active = 1;
-				adapter->pool_config = 1;
 				ibmveth_close(netdev);
-				adapter->pool_config = 0;
 				if ((rc = ibmveth_open(netdev)))
 					return rc;
 			} else {
@@ -1869,10 +1859,8 @@ static ssize_t veth_pool_store(struct kobject *kobj, struct attribute *attr,
 			}
 
 			if (netif_running(netdev)) {
-				adapter->pool_config = 1;
 				ibmveth_close(netdev);
 				pool->active = 0;
-				adapter->pool_config = 0;
 				if ((rc = ibmveth_open(netdev)))
 					return rc;
 			}
@@ -1883,9 +1871,7 @@ static ssize_t veth_pool_store(struct kobject *kobj, struct attribute *attr,
 			return -EINVAL;
 		} else {
 			if (netif_running(netdev)) {
-				adapter->pool_config = 1;
 				ibmveth_close(netdev);
-				adapter->pool_config = 0;
 				pool->size = value;
 				if ((rc = ibmveth_open(netdev)))
 					return rc;
@@ -1898,9 +1884,7 @@ static ssize_t veth_pool_store(struct kobject *kobj, struct attribute *attr,
 			return -EINVAL;
 		} else {
 			if (netif_running(netdev)) {
-				adapter->pool_config = 1;
 				ibmveth_close(netdev);
-				adapter->pool_config = 0;
 				pool->buff_size = value;
 				if ((rc = ibmveth_open(netdev)))
 					return rc;
diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
index daf6f615c03f..4f8357187292 100644
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -146,7 +146,6 @@ struct ibmveth_adapter {
     dma_addr_t filter_list_dma;
     struct ibmveth_buff_pool rx_buff_pool[IBMVETH_NUM_BUFF_POOLS];
     struct ibmveth_rx_q rx_queue;
-    int pool_config;
     int rx_csum;
     int large_send;
     bool is_active_trunk;
-- 
2.31.1

