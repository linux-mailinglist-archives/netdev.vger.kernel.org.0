Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB9724DFCD
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 20:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgHUSjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 14:39:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57128 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725768AbgHUSjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 14:39:09 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LIVknB153727
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 14:39:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=tIQkWmZ+ilOIzmxvKcfUFRhm/79Ap/19IXcasFUQTp0=;
 b=rR4knvs5ijDWQ89d2dE7v63YGATSEzMBZHx0/e/Z9Y0dOksCnMBscGEtHXr+bcoWGn4Z
 Y1CtXMociKNPYv0mzNxp9hYtgJsCqijg+IkDFx88lMkMmzBtJZRpJuc3Uyxt8fz5jodn
 JpkgUpG4Na1xakBitI/MatD2N1iFWd2/Phxojv4RnraI7np3kdh/FaYSpTphK0bHN/lr
 ch17u8nemfMkrByfVmlXCwh9PDSIOG9pLR4lTKc+vJyFrlFqbg2Bm/okBL4uJ1wiRkQD
 d2MjEKHdP8VnYL/pqv0DGbANM4ty+wdPhF70SNaJqjHtYP+Z/5dgZ+v0A/JfYRvFFkm5 CA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3314eej7y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 14:39:06 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LITnfA017445
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 18:39:05 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 3304cddvyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 18:39:05 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LId5FM54526434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 18:39:05 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC077124055;
        Fri, 21 Aug 2020 18:39:04 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84AB012405B;
        Fri, 21 Aug 2020 18:39:04 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.254.185])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 21 Aug 2020 18:39:04 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.vnet.ibm.com, Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net-next] ibmvnic: Fix use-after-free of VNIC login response buffer
Date:   Fri, 21 Aug 2020 13:39:01 -0500
Message-Id: <1598035141-25974-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 clxscore=1011 bulkscore=0 malwarescore=0 phishscore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The login response buffer is freed after it is received
and parsed, but other functions in the driver still attempt
to read it, such as when the device is opened, causing the
Oops below. Store relevant information in the driver's
private data structures and use those instead.

BUG: Kernel NULL pointer dereference on read at 0x00000010
Faulting instruction address: 0xc00800000050a900
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: pseries_rng rng_core vmx_crypto gf128mul binfmt_misc ip_tables x_tables ibmvnic ibmveth crc32c_vpmsum autofs4
CPU: 7 PID: 759 Comm: NetworkManager Not tainted 5.9.0-rc1-00124-gd0a84e1f38d9 #14
NIP:  c00800000050a900 LR: c00800000050a8f0 CTR: 00000000005b1904
REGS: c0000001ed746d20 TRAP: 0300   Not tainted  (5.9.0-rc1-00124-gd0a84e1f38d9)
MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24428484  XER: 00000001
CFAR: c0000000000101b0 DAR: 0000000000000010 DSISR: 40000000 IRQMASK: 0
GPR00: c00800000050a8f0 c0000001ed746fb0 c008000000518e00 0000000000000000
GPR04: 00000000000000c0 0000000000000080 0003c366c60c4501 0000000000000352
GPR08: 000000000001f400 0000000000000010 0000000000000000 0000000000000000
GPR12: 0001cf0000000019 c00000001ec97680 00000001003dfd40 0000010008dbb22c
GPR16: 0000000000000000 0000000000000000 0000000000000000 c000000000edb6c8
GPR20: c000000004e73e00 c000000004fd2448 c000000004e6d700 c000000004fd2448
GPR24: c000000004fd2400 c000000004a0cd20 c0000001ed961860 c0080000005029d8
GPR28: 0000000000000000 0000000000000003 c000000004a0c000 0000000000000000
NIP [c00800000050a900] init_resources+0x338/0xa00 [ibmvnic]
LR [c00800000050a8f0] init_resources+0x328/0xa00 [ibmvnic]
Call Trace:
[c0000001ed746fb0] [c00800000050a8f0] init_resources+0x328/0xa00 [ibmvnic] (unreliable)
[c0000001ed747090] [c00800000050b024] ibmvnic_open+0x5c/0x100 [ibmvnic]
[c0000001ed747110] [c000000000bdcc0c] __dev_open+0x17c/0x250
[c0000001ed7471b0] [c000000000bdd1ec] __dev_change_flags+0x1dc/0x270
[c0000001ed747260] [c000000000bdd2bc] dev_change_flags+0x3c/0x90
[c0000001ed7472a0] [c000000000bf24b8] do_setlink+0x3b8/0x1280
[c0000001ed747450] [c000000000bf8cc8] __rtnl_newlink+0x5a8/0x980
[c0000001ed7478b0] [c000000000bf9110] rtnl_newlink+0x70/0xb0
[c0000001ed7478f0] [c000000000bf07c4] rtnetlink_rcv_msg+0x364/0x460
[c0000001ed747990] [c000000000c68b94] netlink_rcv_skb+0x84/0x1a0
[c0000001ed747a00] [c000000000bef758] rtnetlink_rcv+0x28/0x40
[c0000001ed747a20] [c000000000c68188] netlink_unicast+0x218/0x310
[c0000001ed747a80] [c000000000c6848c] netlink_sendmsg+0x20c/0x4e0
[c0000001ed747b20] [c000000000b9dc88] ____sys_sendmsg+0x158/0x360
[c0000001ed747bb0] [c000000000ba1c88] ___sys_sendmsg+0x98/0xf0
[c0000001ed747d10] [c000000000ba1db8] __sys_sendmsg+0x78/0x100
[c0000001ed747dc0] [c000000000033820] system_call_exception+0x160/0x280
[c0000001ed747e20] [c00000000000d740] system_call_common+0xf0/0x27c
Instruction dump:
3be00000 38810068 b1410076 3941006a 93e10072 fbea0000 b1210068 4bff9915
eb9e0ca0 eabe0900 393c0010 3ab50048 <7fa04c2c> 7fba07b4 7b431764 7b4917a0
---[ end trace fbc5949a28e103bd ]---

Fixes: f3ae59c0c015 ("ibmvnic: store RX and TX subCRQ handle array in ibmvnic_adapter struct")
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 46 ++++++++++++++++--------------
 drivers/net/ethernet/ibm/ibmvnic.h |  1 +
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 597801e7e8ba..589b411617e9 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -297,8 +297,7 @@ static void deactivate_rx_pools(struct ibmvnic_adapter *adapter)
 {
 	int i;
 
-	for (i = 0; i < be32_to_cpu(adapter->login_rsp_buf->num_rxadd_subcrqs);
-	     i++)
+	for (i = 0; i < adapter->num_active_rx_pools; i++)
 		adapter->rx_pool[i].active = 0;
 }
 
@@ -402,8 +401,7 @@ static void replenish_pools(struct ibmvnic_adapter *adapter)
 	int i;
 
 	adapter->replenish_task_cycles++;
-	for (i = 0; i < be32_to_cpu(adapter->login_rsp_buf->num_rxadd_subcrqs);
-	     i++) {
+	for (i = 0; i < adapter->num_active_rx_pools; i++) {
 		if (adapter->rx_pool[i].active)
 			replenish_rx_pool(adapter, &adapter->rx_pool[i]);
 	}
@@ -470,22 +468,20 @@ static int init_stats_token(struct ibmvnic_adapter *adapter)
 static int reset_rx_pools(struct ibmvnic_adapter *adapter)
 {
 	struct ibmvnic_rx_pool *rx_pool;
+	u64 buff_size;
 	int rx_scrqs;
 	int i, j, rc;
-	u64 *size_array;
 
-	size_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
-		be32_to_cpu(adapter->login_rsp_buf->off_rxadd_buff_size));
-
-	rx_scrqs = be32_to_cpu(adapter->login_rsp_buf->num_rxadd_subcrqs);
+	buff_size = adapter->cur_rx_buf_sz;
+	rx_scrqs = adapter->num_active_rx_pools;
 	for (i = 0; i < rx_scrqs; i++) {
 		rx_pool = &adapter->rx_pool[i];
 
 		netdev_dbg(adapter->netdev, "Re-setting rx_pool[%d]\n", i);
 
-		if (rx_pool->buff_size != be64_to_cpu(size_array[i])) {
+		if (rx_pool->buff_size != buff_size) {
 			free_long_term_buff(adapter, &rx_pool->long_term_buff);
-			rx_pool->buff_size = be64_to_cpu(size_array[i]);
+			rx_pool->buff_size = buff_size;
 			rc = alloc_long_term_buff(adapter,
 						  &rx_pool->long_term_buff,
 						  rx_pool->size *
@@ -553,13 +549,11 @@ static int init_rx_pools(struct net_device *netdev)
 	struct device *dev = &adapter->vdev->dev;
 	struct ibmvnic_rx_pool *rx_pool;
 	int rxadd_subcrqs;
-	u64 *size_array;
+	u64 buff_size;
 	int i, j;
 
-	rxadd_subcrqs =
-		be32_to_cpu(adapter->login_rsp_buf->num_rxadd_subcrqs);
-	size_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
-		be32_to_cpu(adapter->login_rsp_buf->off_rxadd_buff_size));
+	rxadd_subcrqs = adapter->num_active_rx_scrqs;
+	buff_size = adapter->cur_rx_buf_sz;
 
 	adapter->rx_pool = kcalloc(rxadd_subcrqs,
 				   sizeof(struct ibmvnic_rx_pool),
@@ -577,11 +571,11 @@ static int init_rx_pools(struct net_device *netdev)
 		netdev_dbg(adapter->netdev,
 			   "Initializing rx_pool[%d], %lld buffs, %lld bytes each\n",
 			   i, adapter->req_rx_add_entries_per_subcrq,
-			   be64_to_cpu(size_array[i]));
+			   buff_size);
 
 		rx_pool->size = adapter->req_rx_add_entries_per_subcrq;
 		rx_pool->index = i;
-		rx_pool->buff_size = be64_to_cpu(size_array[i]);
+		rx_pool->buff_size = buff_size;
 		rx_pool->active = 1;
 
 		rx_pool->free_map = kcalloc(rx_pool->size, sizeof(int),
@@ -644,7 +638,7 @@ static int reset_tx_pools(struct ibmvnic_adapter *adapter)
 	int tx_scrqs;
 	int i, rc;
 
-	tx_scrqs = be32_to_cpu(adapter->login_rsp_buf->num_txsubm_subcrqs);
+	tx_scrqs = adapter->num_active_tx_pools;
 	for (i = 0; i < tx_scrqs; i++) {
 		rc = reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
 		if (rc)
@@ -733,7 +727,7 @@ static int init_tx_pools(struct net_device *netdev)
 	int tx_subcrqs;
 	int i, rc;
 
-	tx_subcrqs = be32_to_cpu(adapter->login_rsp_buf->num_txsubm_subcrqs);
+	tx_subcrqs = adapter->num_active_tx_scrqs;
 	adapter->tx_pool = kcalloc(tx_subcrqs,
 				   sizeof(struct ibmvnic_tx_pool), GFP_KERNEL);
 	if (!adapter->tx_pool)
@@ -4290,6 +4284,7 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 	u64 *rx_handle_array;
 	int num_tx_pools;
 	int num_rx_pools;
+	u64 *size_array;
 	int i;
 
 	dma_unmap_single(dev, adapter->login_buf_token, adapter->login_buf_sz,
@@ -4324,6 +4319,12 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 		ibmvnic_remove(adapter->vdev);
 		return -EIO;
 	}
+	size_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
+		be32_to_cpu(adapter->login_rsp_buf->off_rxadd_buff_size));
+	/* variable buffer sizes are not supported, so just read the
+	 * first entry.
+	 */
+	adapter->cur_rx_buf_sz = be64_to_cpu(size_array[0]);
 
 	num_tx_pools = be32_to_cpu(adapter->login_rsp_buf->num_txsubm_subcrqs);
 	num_rx_pools = be32_to_cpu(adapter->login_rsp_buf->num_rxadd_subcrqs);
@@ -4339,6 +4340,8 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 	for (i = 0; i < num_rx_pools; i++)
 		adapter->rx_scrq[i]->handle = rx_handle_array[i];
 
+	adapter->num_active_tx_scrqs = num_tx_pools;
+	adapter->num_active_rx_scrqs = num_rx_pools;
 	release_login_rsp_buffer(adapter);
 	release_login_buffer(adapter);
 	complete(&adapter->init_done);
@@ -5298,8 +5301,7 @@ static unsigned long ibmvnic_get_desired_dma(struct vio_dev *vdev)
 	for (i = 0; i < adapter->req_tx_queues + adapter->req_rx_queues; i++)
 		ret += 4 * PAGE_SIZE; /* the scrq message queue */
 
-	for (i = 0; i < be32_to_cpu(adapter->login_rsp_buf->num_rxadd_subcrqs);
-	     i++)
+	for (i = 0; i < adapter->num_active_rx_pools; i++)
 		ret += adapter->rx_pool[i].size *
 		    IOMMU_PAGE_ALIGN(adapter->rx_pool[i].buff_size, tbl);
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index d99820212edd..8da98794eda9 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -1076,6 +1076,7 @@ struct ibmvnic_adapter {
 	u32 num_active_rx_napi;
 	u32 num_active_tx_scrqs;
 	u32 num_active_tx_pools;
+	u32 cur_rx_buf_sz;
 
 	struct tasklet_struct tasklet;
 	enum vnic_state state;
-- 
2.26.2

