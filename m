Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C8E4ACDB8
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343665AbiBHBGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343997AbiBHAT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 19:19:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E149AC061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 16:19:28 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217LvAB6025179
        for <netdev@vger.kernel.org>; Tue, 8 Feb 2022 00:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8WDRT84T+pvtZNH35Jq6X35VD3fAB+fbmoGFc0hBOuI=;
 b=VcISSrQtJUPaLHK/EJQgFxx8pOzNQxYpKQnYbjEGpZkkRf+KLHxbBMV4VpPrGGGfDh9R
 wErwgTVFKn2DcYsQW/SUDkwOQrApAB81EeW0LYc19sVSl3w/vK6Hw9cE0Z8lbhRaqarE
 RcH1kQBo1j0BOhrMFMbmfWFyjePejA8kiRsYHV9paWFkCEGSUGI4ND1XEjv64Be6pJ8z
 DhSwCgNXmtLi4VB+kCY++XQOXfzGbC0j+sXPXUKjDU+poxE1xKJ3QVX3HkmsqFHOTfc+
 09+4BCyjWMffJP5ORbxjzqTRJWUOtF6nZKY+28JfGI1fyjob/Hnu5yNw8a6jyv9ZdoOp lQ== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22tr31mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 00:19:28 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2180Fwqi022453
        for <netdev@vger.kernel.org>; Tue, 8 Feb 2022 00:19:27 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma05wdc.us.ibm.com with ESMTP id 3e1gvahd98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 00:19:27 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2180JLEG8651750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 00:19:21 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 845B42805C;
        Tue,  8 Feb 2022 00:19:21 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1AC12805E;
        Tue,  8 Feb 2022 00:19:19 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.159.11])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 00:19:19 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com,
        vaish123@in.ibm.com, Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Subject: [PATCH net 1/1] ibmvnic: don't release napi in __ibmvnic_open()
Date:   Mon,  7 Feb 2022 16:19:18 -0800
Message-Id: <20220208001918.900602-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RXMs7qnC9KYXw5FYbI0NW5ZyzJZDzUad
X-Proofpoint-GUID: RXMs7qnC9KYXw5FYbI0NW5ZyzJZDzUad
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_07,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=940
 impostorscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If __ibmvnic_open() encounters an error such as when setting link state,
it calls release_resources() which frees the napi structures needlessly.
Instead, have __ibmvnic_open() only clean up the work it did so far (i.e.
disable napi and irqs) and leave the rest to the callers.

If caller of __ibmvnic_open() is ibmvnic_open(), it should release the
resources immediately. If the caller is do_reset() or do_hard_reset(),
they will release the resources on the next reset.

This fixes following crash that occured when running the drmgr command
several times to add/remove a vnic interface:

	[102056] ibmvnic 30000003 env3: Disabling rx_scrq[6] irq
	[102056] ibmvnic 30000003 env3: Disabling rx_scrq[7] irq
	[102056] ibmvnic 30000003 env3: Replenished 8 pools
	Kernel attempted to read user page (10) - exploit attempt? (uid: 0)
	BUG: Kernel NULL pointer dereference on read at 0x00000010
	Faulting instruction address: 0xc000000000a3c840
	Oops: Kernel access of bad area, sig: 11 [#1]
	LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA pSeries
	...
	CPU: 9 PID: 102056 Comm: kworker/9:2 Kdump: loaded Not tainted 5.16.0-rc5-autotest-g6441998e2e37 #1
	Workqueue: events_long __ibmvnic_reset [ibmvnic]
	NIP:  c000000000a3c840 LR: c0080000029b5378 CTR: c000000000a3c820
	REGS: c0000000548e37e0 TRAP: 0300   Not tainted  (5.16.0-rc5-autotest-g6441998e2e37)
	MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28248484  XER: 00000004
	CFAR: c0080000029bdd24 DAR: 0000000000000010 DSISR: 40000000 IRQMASK: 0 
	GPR00: c0080000029b55d0 c0000000548e3a80 c0000000028f0200 0000000000000000 
	...
	NIP [c000000000a3c840] napi_enable+0x20/0xc0
	LR [c0080000029b5378] __ibmvnic_open+0xf0/0x430 [ibmvnic]
	Call Trace:
	[c0000000548e3a80] [0000000000000006] 0x6 (unreliable)
	[c0000000548e3ab0] [c0080000029b55d0] __ibmvnic_open+0x348/0x430 [ibmvnic]
	[c0000000548e3b40] [c0080000029bcc28] __ibmvnic_reset+0x500/0xdf0 [ibmvnic]
	[c0000000548e3c60] [c000000000176228] process_one_work+0x288/0x570
	[c0000000548e3d00] [c000000000176588] worker_thread+0x78/0x660
	[c0000000548e3da0] [c0000000001822f0] kthread+0x1c0/0x1d0
	[c0000000548e3e10] [c00000000000cf64] ret_from_kernel_thread+0x5c/0x64
	Instruction dump:
	7d2948f8 792307e0 4e800020 60000000 3c4c01eb 384239e0 f821ffd1 39430010 
	38a0fff6 e92d1100 f9210028 39200000 <e9030010> f9010020 60420000 e9210020 
	---[ end trace 5f8033b08fd27706 ]---

Fixes: ed651a10875f ("ibmvnic: Updated reset handling)
Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f5d1ba9bea48..50d2e48274eb 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -110,6 +110,7 @@ static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter *adapter,
 					 struct ibmvnic_sub_crq_queue *tx_scrq);
 static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 				struct ibmvnic_long_term_buff *ltb);
+static void ibmvnic_disable_irqs(struct ibmvnic_adapter *adapter);
 
 struct ibmvnic_stat {
 	char name[ETH_GSTRING_LEN];
@@ -1424,7 +1425,7 @@ static int __ibmvnic_open(struct net_device *netdev)
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_UP);
 	if (rc) {
 		ibmvnic_napi_disable(adapter);
-		release_resources(adapter);
+		ibmvnic_disable_irqs(adapter);
 		return rc;
 	}
 
@@ -1474,9 +1475,6 @@ static int ibmvnic_open(struct net_device *netdev)
 		rc = init_resources(adapter);
 		if (rc) {
 			netdev_err(netdev, "failed to initialize resources\n");
-			release_resources(adapter);
-			release_rx_pools(adapter);
-			release_tx_pools(adapter);
 			goto out;
 		}
 	}
@@ -1493,6 +1491,13 @@ static int ibmvnic_open(struct net_device *netdev)
 		adapter->state = VNIC_OPEN;
 		rc = 0;
 	}
+
+	if (rc) {
+		release_resources(adapter);
+		release_rx_pools(adapter);
+		release_tx_pools(adapter);
+	}
+
 	return rc;
 }
 
-- 
2.27.0

