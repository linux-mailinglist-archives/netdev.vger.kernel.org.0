Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945F9624D0C
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiKJVcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiKJVcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:32:45 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFA9554CD
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 13:32:44 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AALN7wf011252
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=q244ANpVnrTAfmE8kM4wdeEPqdwpSsdeGbhLIhY2X7Q=;
 b=fAk3Io1UdeahnV3AYn4uuPjcZy07KyzTYSqesdvLaV2u1vK3Yx4d0BpesDIHRN7sIrIt
 Ut9pYn1ilNwyrvbo49l1RRgqfFX+Tgy3OQ4nVxc/q8cpYwiu5SubFGyKzMQFUJcFihfI
 XUyMQzLNb8mz7/JL2uMQiSjyNLToXR/CoyMwfZGVtaxNbNSetOMH5K521GLARiJPdrOX
 U4Spuo001TlOfhteXs3QRlQAF2l3A+n6or2p8ezxlibWGJ5vgNUDDKgg3B0pT0qw2g2X
 nXNqaYfiCBNpjV9zbvvS/hw743bisJOKDSnC7P4Nb+5A0pfAU+gJju6YgKBKT0H2AS7r AA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ks95q864j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:43 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AALLExO019885
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:42 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 3kngmtrhhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:42 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AALWdHL39256812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 21:32:39 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B2C55805A;
        Thu, 10 Nov 2022 21:32:40 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9293C5805C;
        Thu, 10 Nov 2022 21:32:39 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.160.178.220])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 10 Nov 2022 21:32:39 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, ricklind@us.ibm.com,
        mmc@linux.ibm.com, Nick Child <nnac123@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-next 3/3] ibmvnic: Update XPS assignments during affinity binding
Date:   Thu, 10 Nov 2022 15:32:18 -0600
Message-Id: <20221110213218.28662-4-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221110213218.28662-1-nnac123@linux.ibm.com>
References: <20221110213218.28662-1-nnac123@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7TAiBc6XmO_joHdNJ2j5Dgu9Qnzfi4x4
X-Proofpoint-ORIG-GUID: 7TAiBc6XmO_joHdNJ2j5Dgu9Qnzfi4x4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211100144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Transmit Packet Steering (XPS) maps cpu numbers to transmit
queues. By running the same connection on the same set of cpu's,
contention for the queue and cache miss rate can be minimized.
When assigning a cpu mask for a tranmit queues irq number, assign
the same cpu mask as the set of cpu's that XPS should use for that
queue.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>
Reviewed-by: Haren Myneni <haren@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2fc0d50dbb86..e19a6bb3f444 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -279,6 +279,16 @@ static void ibmvnic_set_affinity(struct ibmvnic_adapter *adapter)
 						stride);
 		if (rc)
 			goto out;
+
+		if (!queue)
+			continue;
+
+		rc = __netif_set_xps_queue(adapter->netdev,
+					   cpumask_bits(queue->affinity_mask),
+					   i, XPS_CPUS);
+		if (rc)
+			netdev_warn(adapter->netdev, "%s: Set XPS on queue %d failed, rc = %d.\n",
+				    __func__, i, rc);
 	}
 
 	for (i = 0; i < num_rxqs; i++) {
-- 
2.31.1

