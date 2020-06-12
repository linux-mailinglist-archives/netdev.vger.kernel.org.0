Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86A31F7CE8
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 20:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgFLScF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 14:32:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54704 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbgFLScF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 14:32:05 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05CIW1G9047863;
        Fri, 12 Jun 2020 14:32:01 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31kyem9d3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jun 2020 14:31:47 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05CILIEk006647;
        Fri, 12 Jun 2020 18:31:46 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 31hyh0duv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jun 2020 18:31:46 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05CIViBr26542436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jun 2020 18:31:44 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 714D178063;
        Fri, 12 Jun 2020 18:31:44 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C178A7805C;
        Fri, 12 Jun 2020 18:31:43 +0000 (GMT)
Received: from oc7186267434.ibm.com.com (unknown [9.160.93.4])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jun 2020 18:31:43 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, danymadden@us.ibm.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net] ibmvnic: Harden device login requests
Date:   Fri, 12 Jun 2020 13:31:39 -0500
Message-Id: <1591986699-19484-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-11_23:2020-06-11,2020-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=1
 adultscore=0 malwarescore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 cotscore=-2147483648 phishscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006120134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VNIC driver's "login" command sequence is the final step
in the driver's initialization process with device firmware,
confirming the available device queue resources to be utilized
by the driver. Under high system load, firmware may not respond
to the request in a timely manner or may abort the request. In
such cases, the driver should reattempt the login command
sequence. In case of a device error, the number of retries
is bounded.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 197dc5b2c090..1cb2b7f3b2cb 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -841,13 +841,14 @@ static int ibmvnic_login(struct net_device *netdev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 	unsigned long timeout = msecs_to_jiffies(30000);
+	int retries = 10;
 	int retry_count = 0;
 	bool retry;
 	int rc;
 
 	do {
 		retry = false;
-		if (retry_count > IBMVNIC_MAX_QUEUES) {
+		if (retry_count > retries) {
 			netdev_warn(netdev, "Login attempts exceeded\n");
 			return -1;
 		}
@@ -862,11 +863,23 @@ static int ibmvnic_login(struct net_device *netdev)
 
 		if (!wait_for_completion_timeout(&adapter->init_done,
 						 timeout)) {
-			netdev_warn(netdev, "Login timed out\n");
-			return -1;
+			netdev_warn(netdev, "Login timed out, retrying...\n");
+			retry = true;
+			adapter->init_done_rc = 0;
+			retry_count++;
+			continue;
 		}
 
-		if (adapter->init_done_rc == PARTIALSUCCESS) {
+		if (adapter->init_done_rc == ABORTED) {
+			netdev_warn(netdev, "Login aborted, retrying...\n");
+			retry = true;
+			adapter->init_done_rc = 0;
+			retry_count++;
+			/* FW or device may be busy, so
+			 * wait a bit before retrying login
+			 */
+			msleep(500);
+		} else if (adapter->init_done_rc == PARTIALSUCCESS) {
 			retry_count++;
 			release_sub_crqs(adapter, 1);
 
-- 
2.18.1

