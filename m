Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2A81096A4
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfKYXN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:13:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5658 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727369AbfKYXNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:13:12 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAPMvBIv039597;
        Mon, 25 Nov 2019 18:13:06 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wf0f79cgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Nov 2019 18:13:06 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAPMtTx2007217;
        Mon, 25 Nov 2019 23:13:05 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 2wevd6p39h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Nov 2019 23:13:05 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAPND4kv44630414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Nov 2019 23:13:04 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D51DBE051;
        Mon, 25 Nov 2019 23:13:04 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EA41BE056;
        Mon, 25 Nov 2019 23:13:03 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.224.141])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 25 Nov 2019 23:13:02 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com,
        julietk@linux.vnet.ibm.com, Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net v2 2/4] ibmvnic: Terminate waiting device threads after loss of service
Date:   Mon, 25 Nov 2019 17:12:54 -0600
Message-Id: <1574723576-27553-3-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574723576-27553-1-git-send-email-tlfalcon@linux.ibm.com>
References: <20191125112359.7a468352@cakuba.hsd1.ca.comcast.net>
 <1574723576-27553-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-25_06:2019-11-21,2019-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=1
 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=823 adultscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911250181
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we receive a notification that the device has been deactivated
or removed, force a completion of all waiting threads.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 48225297a5e2..78a3ef70f1ef 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4500,6 +4500,15 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 	case IBMVNIC_CRQ_XPORT_EVENT:
 		netif_carrier_off(netdev);
 		adapter->crq.active = false;
+		/* terminate any thread waiting for a response
+		 * from the device
+		 */
+		if (!completion_done(&adapter->fw_done)) {
+			adapter->fw_done_rc = -EIO;
+			complete(&adapter->fw_done);
+		}
+		if (!completion_done(&adapter->stats_done))
+			complete(&adapter->stats_done);
 		if (test_bit(0, &adapter->resetting))
 			adapter->force_reset_recovery = true;
 		if (gen_crq->cmd == IBMVNIC_PARTITION_MIGRATED) {
-- 
2.12.3

