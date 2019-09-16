Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82BB4B3CDF
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 16:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbfIPOvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 10:51:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48526 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726690AbfIPOvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 10:51:15 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8GEb6ex140854
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 10:51:13 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v2adsdvu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 10:51:13 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8GEe4rf023049
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 14:51:12 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 2v0t3d13kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 14:51:12 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8GEp9nJ39387602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 14:51:09 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42E17C6057;
        Mon, 16 Sep 2019 14:51:09 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0BE6C6061;
        Mon, 16 Sep 2019 14:51:07 +0000 (GMT)
Received: from Murilos-MBP.home (unknown [9.85.184.203])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 16 Sep 2019 14:51:07 +0000 (GMT)
From:   Murilo Fossa Vicentini <muvic@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     tlfalcon@linux.ibm.com, muvic@br.ibm.com,
        abdhalee@linux.vnet.ibm.com
Subject: [PATCH net] ibmvnic: Warn unknown speed message only when carrier is present
Date:   Mon, 16 Sep 2019 11:50:37 -0300
Message-Id: <20190916145037.77376-1-muvic@linux.ibm.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=814 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909160151
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit 0655f9943df2 ("net/ibmvnic: Update carrier state after link
state change") we are now able to detect when the carrier is properly
present in the device, so only report an unexpected unknown speed when it
is properly detected. Unknown speed is expected to be seen by the device
in case the backing device has no link detected.

Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Murilo Fossa Vicentini <muvic@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5cb55ea671e3..3a6725daf7dc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4312,13 +4312,14 @@ static int handle_query_phys_parms_rsp(union ibmvnic_crq *crq,
 {
 	struct net_device *netdev = adapter->netdev;
 	int rc;
+	__be32 rspeed = cpu_to_be32(crq->query_phys_parms_rsp.speed);
 
 	rc = crq->query_phys_parms_rsp.rc.code;
 	if (rc) {
 		netdev_err(netdev, "Error %d in QUERY_PHYS_PARMS\n", rc);
 		return rc;
 	}
-	switch (cpu_to_be32(crq->query_phys_parms_rsp.speed)) {
+	switch (rspeed) {
 	case IBMVNIC_10MBPS:
 		adapter->speed = SPEED_10;
 		break;
@@ -4344,8 +4345,8 @@ static int handle_query_phys_parms_rsp(union ibmvnic_crq *crq,
 		adapter->speed = SPEED_100000;
 		break;
 	default:
-		netdev_warn(netdev, "Unknown speed 0x%08x\n",
-			    cpu_to_be32(crq->query_phys_parms_rsp.speed));
+		if (netif_carrier_ok(netdev))
+			netdev_warn(netdev, "Unknown speed 0x%08x\n", rspeed);
 		adapter->speed = SPEED_UNKNOWN;
 	}
 	if (crq->query_phys_parms_rsp.flags1 & IBMVNIC_FULL_DUPLEX)
-- 
2.20.1 (Apple Git-117)

