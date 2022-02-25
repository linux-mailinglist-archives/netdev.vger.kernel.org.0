Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D064C3E5A
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237796AbiBYGYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237822AbiBYGYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:24:53 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E61269295
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 22:24:20 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21P3URtI026638
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Ttftc5rDyLEG4Aveah3JlFtyLXYuskFdfiRq+LaRJho=;
 b=NVX1Rr1UnSTI7WJjHIOTDB37pgEPhqNkDRyPE2KptArVXsLViqR21hTNh03t4WhJgOKx
 svjQIVCfJgb9nnkdj1XaVe4Y9UX3HqAcfajdbZD0VANRLSF9obHCTOxEeZNYUY8x3M05
 yzEsG04AuAY8m4j5UQ+OuwcZU7F2IpYEXvE1ypjcLbnoW17KfXhDprogKGS+UMytfQVk
 p82y8gItO3GbdE6cPuT0ZqTOy1ZYfP+IGbO7tTrzEGWgPgiXw6XRg95L/63t107jMAdi
 0xPUnHfrX2T2HkddBQAwc+ZMma6ZAXrFSTH/YNsFsMIlx0hYb+w1YHJy4PK2Tc6R7Xhq Mw== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edsju1g1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:19 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21P6MToj004934
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:18 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3ed22f189g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:24:18 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21P6OHrs25493978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 06:24:17 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E86C513605D;
        Fri, 25 Feb 2022 06:24:16 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0081C136061;
        Fri, 25 Feb 2022 06:24:04 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.204.104])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 06:24:03 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net 3/8] ibmvnic: define flush_reset_queue helper
Date:   Thu, 24 Feb 2022 22:23:53 -0800
Message-Id: <20220225062358.1435652-4-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220225062358.1435652-1-sukadev@linux.ibm.com>
References: <20220225062358.1435652-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8H-ZsjaPLh2BM_2qEW5VbA72n7cP9egP
X-Proofpoint-GUID: 8H-ZsjaPLh2BM_2qEW5VbA72n7cP9egP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_05,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250030
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define and use a helper to flush the reset queue.

Fixes: 2770a7984db5 ("ibmvnic: Introduce hard reset recovery")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 830f3e45ec65..d8911a2a4370 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2735,12 +2735,23 @@ static void __ibmvnic_delayed_reset(struct work_struct *work)
 	__ibmvnic_reset(&adapter->ibmvnic_reset);
 }
 
+static void flush_reset_queue(struct ibmvnic_adapter *adapter)
+{
+	struct list_head *entry, *tmp_entry;
+
+	if (!list_empty(&adapter->rwi_list)) {
+		list_for_each_safe(entry, tmp_entry, &adapter->rwi_list) {
+			list_del(entry);
+			kfree(list_entry(entry, struct ibmvnic_rwi, list));
+		}
+	}
+}
+
 static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 			 enum ibmvnic_reset_reason reason)
 {
-	struct list_head *entry, *tmp_entry;
-	struct ibmvnic_rwi *rwi, *tmp;
 	struct net_device *netdev = adapter->netdev;
+	struct ibmvnic_rwi *rwi, *tmp;
 	unsigned long flags;
 	int ret;
 
@@ -2783,12 +2794,9 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	/* if we just received a transport event,
 	 * flush reset queue and process this reset
 	 */
-	if (adapter->force_reset_recovery && !list_empty(&adapter->rwi_list)) {
-		list_for_each_safe(entry, tmp_entry, &adapter->rwi_list) {
-			list_del(entry);
-			kfree(list_entry(entry, struct ibmvnic_rwi, list));
-		}
-	}
+	if (adapter->force_reset_recovery)
+		flush_reset_queue(adapter);
+
 	rwi->reset_reason = reason;
 	list_add_tail(&rwi->list, &adapter->rwi_list);
 	netdev_dbg(adapter->netdev, "Scheduling reset (reason %s)\n",
-- 
2.27.0

