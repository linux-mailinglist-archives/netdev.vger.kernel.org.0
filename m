Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC46563F7E
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 12:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbiGBKjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 06:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiGBKjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 06:39:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C434D13D6F
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 03:39:40 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 262ARsbN011841
        for <netdev@vger.kernel.org>; Sat, 2 Jul 2022 10:39:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=TVWhu1NRm9Hd7/sr/nHZvOUgCbVjrzDz92U9PZCOLdU=;
 b=bnMnJxq0/IsxwPmctznLPJpELwnNGT3/+yZKZxHWOGg+yA+psh0lDJS4dyY52Em64jY0
 r1E6VTU2M5aGG6IgEQwjRWzf8uwQzL4BZFLcHBiMWCNaiLN0At62i+WyXTdyrv7ysrrd
 42xUs9pflDLdQmKaVitIRTUBPdukkcIhqJCBRkfgFH9ZgEboSTfJfAMAX4oh5Pl1ORig
 Ip8QfhmqxNxgtzCIXy/Yss7xZvoBbqXsE43jUoiyzAbOGfNTDqbTgWIQll1AtMdzRVw6
 cEGRMWTbf4bc6CQ2FoXnDeJmeiuiLEZ5bYTARrSko4zk7KdVbpQCPN0u8BYWqf8OrMcm TA== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h2m9rg7p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 02 Jul 2022 10:39:40 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 262AZRmP003016
        for <netdev@vger.kernel.org>; Sat, 2 Jul 2022 10:39:39 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04wdc.us.ibm.com with ESMTP id 3h2dn91mkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 02 Jul 2022 10:39:38 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 262AdboT32178628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 Jul 2022 10:39:37 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C77A4C606D;
        Sat,  2 Jul 2022 10:39:37 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9094AC6057;
        Sat,  2 Jul 2022 10:39:36 +0000 (GMT)
Received: from fledgling.ibm.com.com (unknown [9.65.244.101])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat,  2 Jul 2022 10:39:36 +0000 (GMT)
From:   Rick Lindsley <ricklind@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, nnac123@linux.ibm.com,
        mmc@linux.ibm.com, ricklind@linux.ibm.com
Subject: [PATCH net v2] ibmvnic: Properly dispose of all skbs during a failover.
Date:   Sat,  2 Jul 2022 03:37:12 -0700
Message-Id: <20220702103711.4036357-1-ricklind@us.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9DvHRkwKdpSsZiKZmFj1Z-7w42g68Ki5
X-Proofpoint-GUID: 9DvHRkwKdpSsZiKZmFj1Z-7w42g68Ki5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-02_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=928
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207020047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During a reset, there may have been transmits in flight that are no
longer valid and cannot be fulfilled.  Resetting and clearing the
queues is insufficient; each skb also needs to be explicitly freed
so that upper levels are not left waiting for confirmation of a
transmit that will never happen.  If this happens frequently enough,
the apparent backlog will cause TCP to begin "congestion control"
unnecessarily, culminating in permanently decreased throughput.

Fixes: d7c0ef36bde03 ("ibmvnic: Free and re-allocate scrqs when tx/rx scrqs change")
Tested-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Rick Lindsley <ricklind@us.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 7e7fe5bdf1f8..5ab7c0f81e9a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5981,6 +5981,15 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 			release_sub_crqs(adapter, 0);
 			rc = init_sub_crqs(adapter);
 		} else {
+			/* no need to reinitialize completely, but we do
+			 * need to clean up transmits that were in flight
+			 * when we processed the reset.  Failure to do so
+			 * will confound the upper layer, usually TCP, by
+			 * creating the illusion of transmits that are
+			 * awaiting completion.
+			 */
+			clean_tx_pools(adapter);
+
 			rc = reset_sub_crq_queues(adapter);
 		}
 	} else {
-- 
2.31.1

