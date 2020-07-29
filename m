Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA822326DD
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgG2Vgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:36:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgG2Vgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 17:36:44 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TLXoTL085870;
        Wed, 29 Jul 2020 17:36:40 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32jw2ku53v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 17:36:39 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06TLZNSo018155;
        Wed, 29 Jul 2020 21:36:38 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 32gcy5w0r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 21:36:38 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06TLaZFh62063068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 21:36:35 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AE14BE051;
        Wed, 29 Jul 2020 21:36:37 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6975FBE04F;
        Wed, 29 Jul 2020 21:36:36 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.109.59])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 29 Jul 2020 21:36:36 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, drt@linux.ibm.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net] ibmvnic: Fix IRQ mapping disposal in error path
Date:   Wed, 29 Jul 2020 16:36:32 -0500
Message-Id: <1596058592-12025-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_14:2020-07-29,2020-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=959 clxscore=1015
 lowpriorityscore=0 phishscore=0 spamscore=0 suspectscore=3
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RX queue IRQ mappings are disposed in both the TX IRQ and RX IRQ
error paths. Fix this and dispose of TX IRQ mappings correctly in
case of an error.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0fd7eae..5afb3c9 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3206,7 +3206,7 @@ static int init_sub_crq_irqs(struct ibmvnic_adapter *adapter)
 req_tx_irq_failed:
 	for (j = 0; j < i; j++) {
 		free_irq(adapter->tx_scrq[j]->irq, adapter->tx_scrq[j]);
-		irq_dispose_mapping(adapter->rx_scrq[j]->irq);
+		irq_dispose_mapping(adapter->tx_scrq[j]->irq);
 	}
 	release_sub_crqs(adapter, 1);
 	return rc;
-- 
1.8.3.1

