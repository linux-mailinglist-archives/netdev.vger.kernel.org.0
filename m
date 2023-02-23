Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151E66A0D2F
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 16:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbjBWPkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 10:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbjBWPkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 10:40:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBF7D502
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 07:39:51 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31NFDT1i007883
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 15:39:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=HysA9eS4k0aE0X7WQCped0NKqN9Lvani9kaBlHVUt6s=;
 b=KaEbGVjUSIJ9dPuTaNCuiAA1uA/oE8aC0ZTG7iQY5Y2pXqwaKDw4i0b4mCbIEb1wjnj6
 prEJgxJqgixpzy2q5XLOMBQR7aWh4Op167zrI0XVKqzCh1IcfeKWfQxH1aO2WB4AN1Q8
 R8RuYbSw90OY0G+UAUlJ7vPBtV1FmoZydv6S5UVR2h5mCdYS0Tv0KIhhHnRdU+7QOS/n
 dLIIc/dGEVQ0xnXNAw62W+QShwB70BBgabR0jVhBJKrMH8bxFBuZU8sIIgZH75UQlPe4
 C3LSOYqtEa62Ftya0ro9ZomlKOGU27GR8jNUSENRFxnnkgVk//er3Wv1bGJxBnP1/4GC SA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxakd0sye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 15:39:51 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31NF6Ivh019805
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 15:39:49 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3ntpa7pjp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 15:39:49 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31NFdmv165208720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 15:39:48 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F8DB5805C;
        Thu, 23 Feb 2023 15:39:48 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D838F5805A;
        Thu, 23 Feb 2023 15:39:47 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com.com (unknown [9.65.195.24])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Feb 2023 15:39:47 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, ricklind@us.ibm.com,
        Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH net-next] ibmvnic: Assign XPS map to correct queue index
Date:   Thu, 23 Feb 2023 09:39:44 -0600
Message-Id: <20230223153944.44969-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZrUohcrWD4PvwN_prORh3DVCY9LCgMbU
X-Proofpoint-ORIG-GUID: ZrUohcrWD4PvwN_prORh3DVCY9LCgMbU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-23_10,2023-02-23_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011 spamscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting the XPS map value for TX queues, use the index of the
transmit queue.
Previously, the function was passing the index of the loop that iterates
over all queues (RX and TX). This was causing invalid XPS map values.

Fixes: 6831582937bd ("ibmvnic: Toggle between queue types in affinity mapping")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---

I am a little surprised that __netif_set_xps_queue() did not complain that some
index values were greater than the number of tx queues. Though maybe the function
assumes that the developers are wise enough :)

Should __netif_set_xps_queue() have a check that index < dev->num_tx_queues?

 drivers/net/ethernet/ibm/ibmvnic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 146ca1d8031b..c63d3ec9d328 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -296,10 +296,10 @@ static void ibmvnic_set_affinity(struct ibmvnic_adapter *adapter)
 
 		rc = __netif_set_xps_queue(adapter->netdev,
 					   cpumask_bits(queue->affinity_mask),
-					   i, XPS_CPUS);
+					   i_txqs - 1, XPS_CPUS);
 		if (rc)
 			netdev_warn(adapter->netdev, "%s: Set XPS on queue %d failed, rc = %d.\n",
-				    __func__, i, rc);
+				    __func__, i_txqs - 1, rc);
 	}
 
 out:
-- 
2.31.1

