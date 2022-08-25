Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88555A19F5
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243290AbiHYUCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbiHYUBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:01:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1803DBFE85
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 13:01:43 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PIlcn2018063;
        Thu, 25 Aug 2022 20:01:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=VekIjRblNSsmhNiFqXlscdgUVaWJfl7pqSTkhUPe5EQ=;
 b=miKbQPKW8WQAvMFkU2BNTLRY0kesxK5mxey3ziQ5MKxQ5fnCVC2zU0ONq9ND9xpERG+A
 nLb17j5rDAY0VzmaZK85yM+f0qSi6zPl2R7LCt59F/Q3Epsl4y283okbcYBctqH6V0iR
 /mMiD6Xdy/zBAZGZ5q8WJf3AlLEW8pC6hjtyJbs5VC9Hq/WS1rGoWP71e4F1GrYV9Eoc
 uMHjlwkNGo1ZKZ74cvAcJgInYkXf+gS4E83Wf/WBGMI3OQZa1NlSOPSqr9Y8DSDyWoyA
 zTNkNEW3pIZvoOfJIUKlgMLvlRbM/Z9kFpZSy+HlEKz/CRxiSk4IkmjuO4sxIMMLeAmR RA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6enqj27m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 20:01:37 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27PJse3W023328;
        Thu, 25 Aug 2022 20:01:36 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3j2q8aj12t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 20:01:35 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27PK1YJ36029826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 20:01:34 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB73A136051;
        Thu, 25 Aug 2022 20:01:34 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B9A213604F;
        Thu, 25 Aug 2022 20:01:34 +0000 (GMT)
Received: from ltc17u3.stglabs.ibm.com (unknown [9.114.219.126])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 25 Aug 2022 20:01:34 +0000 (GMT)
From:   Thinh Tran <thinhtr@linux.vnet.ibm.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, aelior@marvell.com, davem@davemloft.net,
        manishc@marvell.com, skalluru@marvell.com,
        Thinh Tran <thinhtr@linux.vnet.ibm.com>
Subject: [PATCH] bnx2x: Fix error recovering in switch configuration
Date:   Thu, 25 Aug 2022 20:00:29 +0000
Message-Id: <20220825200029.4143670-1-thinhtr@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6ZAO8IRmeaWn5ti7YUOeYU6ZwmXYCcYe
X-Proofpoint-ORIG-GUID: 6ZAO8IRmeaWn5ti7YUOeYU6ZwmXYCcYe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_09,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=738
 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1011 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the BCM57810 and other I/O adapters are connected
through a PCIe switch, the bnx2x driver causes unexpected
system hang/crash while handling PCIe switch errors, if 
its error handler is called after other drivers' handlers.

In this case, after numbers of bnx2x_tx_timout(), the
bnx2x_nic_unload() is  called, frees up resources and
calls bnx2x_napi_disable(). Then when EEH calls its
error handler, the bnx2x_io_error_detected() and
bnx2x_io_slot_reset() also calling bnx2x_napi_disable()
and freeing the resources.

This patch will:
- reduce the numbers of bnx2x_panic_dump() while in
  bnx2x_tx_timeout(), avoid filling up dmesg buffer.
- use checking new napi_enable flags to prevent calling 
  disable again which causing system hangs.
- cheking if fp->page_pool already freed avoid system
  crash.

Signed-off-by: Thinh Tran <thinhtr@linux.vnet.ibm.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  4 ++++
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 24 ++++++++++++++++++-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  3 +++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index dd5945c4bfec..7fa23d47907a 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -1509,6 +1509,10 @@ struct bnx2x {
 	bool			cnic_loaded;
 	struct cnic_eth_dev	*(*cnic_probe)(struct net_device *);
 
+	bool			napi_enable;
+	bool			cnic_napi_enable;
+	int			tx_timeout_cnt;
+
 	/* Flag that indicates that we can start looking for FCoE L2 queue
 	 * completions in the default status block.
 	 */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 712b5595bc39..bb8d91f44642 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -1860,37 +1860,49 @@ static int bnx2x_setup_irqs(struct bnx2x *bp)
 static void bnx2x_napi_enable_cnic(struct bnx2x *bp)
 {
 	int i;
+	if (bp->cnic_napi_enable)
+		return;
 
 	for_each_rx_queue_cnic(bp, i) {
 		napi_enable(&bnx2x_fp(bp, i, napi));
 	}
+	bp->cnic_napi_enable = true;
 }
 
 static void bnx2x_napi_enable(struct bnx2x *bp)
 {
 	int i;
+	if (bp->napi_enable)
+		return;
 
 	for_each_eth_queue(bp, i) {
 		napi_enable(&bnx2x_fp(bp, i, napi));
 	}
+	bp->napi_enable = true;
 }
 
 static void bnx2x_napi_disable_cnic(struct bnx2x *bp)
 {
 	int i;
+	if (!bp->cnic_napi_enable)
+		return;
 
 	for_each_rx_queue_cnic(bp, i) {
 		napi_disable(&bnx2x_fp(bp, i, napi));
 	}
+	bp->cnic_napi_enable = false;
 }
 
 static void bnx2x_napi_disable(struct bnx2x *bp)
 {
 	int i;
+	if (!bp->napi_enable)
+		return;
 
 	for_each_eth_queue(bp, i) {
 		napi_disable(&bnx2x_fp(bp, i, napi));
 	}
+	bp->napi_enable = false;
 }
 
 void bnx2x_netif_start(struct bnx2x *bp)
@@ -2554,6 +2566,7 @@ int bnx2x_load_cnic(struct bnx2x *bp)
 	}
 
 	/* Add all CNIC NAPI objects */
+	bp->cnic_napi_enable = false;
 	bnx2x_add_all_napi_cnic(bp);
 	DP(NETIF_MSG_IFUP, "cnic napi added\n");
 	bnx2x_napi_enable_cnic(bp);
@@ -2701,7 +2714,9 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
 	 */
 	bnx2x_setup_tc(bp->dev, bp->max_cos);
 
+	bp->tx_timeout_cnt = 0;
 	/* Add all NAPI objects */
+	bp->napi_enable = false;
 	bnx2x_add_all_napi(bp);
 	DP(NETIF_MSG_IFUP, "napi added\n");
 	bnx2x_napi_enable(bp);
@@ -4982,7 +4997,14 @@ void bnx2x_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	 */
 	if (!bp->panic)
 #ifndef BNX2X_STOP_ON_ERROR
-		bnx2x_panic_dump(bp, false);
+	{
+		if (++bp->tx_timeout_cnt > 3) {
+			bnx2x_panic_dump(bp, false);
+			bp->tx_timeout_cnt = 0;
+		} else {
+			netdev_err(bp->dev, "TX timeout %d times\n", bp->tx_timeout_cnt);
+		}
+	}
 #else
 		bnx2x_panic();
 #endif
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
index d8b1824c334d..7e1d38a2c7ec 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -1018,6 +1018,9 @@ static inline void bnx2x_free_rx_sge_range(struct bnx2x *bp,
 	if (fp->mode == TPA_MODE_DISABLED)
 		return;
 
+	if (!fp->page_pool.page)
+		return;
+
 	for (i = 0; i < last; i++)
 		bnx2x_free_rx_sge(bp, fp, i);
 
-- 
2.25.1

