Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9A3560DD2
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 02:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiF3AEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 20:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiF3AEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 20:04:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0534C248DF
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 17:04:37 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25TNBZIV004849
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 00:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=QY/2UzcwvwzDu5APxqxC4c27Z1+yDTS8VEOBDwiHHmM=;
 b=dUCgiP4KhN/kQ72Z+eiFSU6hUUdt0QMg70U+jkJ/lBNHBzpDoe0syfQ3s/Ca4sJsAIUA
 Cy2oSkqcapW8c4/t9/HR4NpIbYu5BxnIz2IQ0E7jTE40/xGR1LuQloITwgyTXcyhDTOO
 VQBE6KCGpmC3dKx8eHctYwWYKRbHirU8h1wnHbzMRKmyXEQvHin/yccrEJYK/tHRNuzp
 qyKqsqGhKQw1zBIR/3W8InVtpd23TCdPZ0jwXzQ/6OGP+Cqe1aTZLIniab5hpVyuGcr4
 Bactzg7CdOLIpZcoxTXQPKkJYSN97oVSSOIpCErYehZNOol86wVn09mT96n5Y0UW0SQN Uw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h0yvq9rn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 00:04:36 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25TNcHFs024313
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 00:04:36 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 3gwt0bh2ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 00:04:36 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25U04ZOg10420708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 00:04:35 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2C47124053;
        Thu, 30 Jun 2022 00:04:34 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43CAA124054;
        Thu, 30 Jun 2022 00:04:34 +0000 (GMT)
Received: from fledgling.ibm.com.com (unknown [9.65.244.101])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jun 2022 00:04:34 +0000 (GMT)
From:   Rick Lindsley <ricklind@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, nnac123@linux.ibm.com,
        mmc@linux.ibm.com
Subject: [PATCH]     ibmvnic: Properly dispose of all skbs during a failover.
Date:   Wed, 29 Jun 2022 17:03:17 -0700
Message-Id: <20220630000317.2509347-1-ricklind@us.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oYT87M70OCRLT7usjGslY9qQEK9VIUhG
X-Proofpoint-ORIG-GUID: oYT87M70OCRLT7usjGslY9qQEK9VIUhG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_23,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 mlxscore=0 malwarescore=0 clxscore=1011 spamscore=0
 bulkscore=0 mlxlogscore=778 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206290082
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

    This was noted during testing of heavy data transfers in
    conjunction with multiple consecutive device failovers.

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
2.27.0

