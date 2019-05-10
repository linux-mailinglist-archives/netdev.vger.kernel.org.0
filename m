Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1201974D
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 06:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbfEJEN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 00:13:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726132AbfEJEN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 00:13:56 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4A42por020633
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 00:13:55 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2scwp38h0c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 00:13:55 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <tlfalcon@linux.ibm.com>;
        Fri, 10 May 2019 05:13:54 +0100
Received: from b03cxnp08025.gho.boulder.ibm.com (9.17.130.17)
        by e36.co.us.ibm.com (192.168.1.136) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 May 2019 05:13:52 +0100
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4A4DoeJ54395108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 04:13:50 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B2886E050;
        Fri, 10 May 2019 04:13:50 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6CCE6E04E;
        Fri, 10 May 2019 04:13:49 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.213.250])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 10 May 2019 04:13:49 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     julietk@linux.ibm.com, Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net] net/ibmvnic: Update carrier state after link state change
Date:   Thu,  9 May 2019 23:13:44 -0500
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557461624-21959-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1557461624-21959-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19051004-0020-0000-0000-00000EE63281
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011080; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01201127; UDB=6.00630283; IPR=6.00982022;
 MB=3.00026822; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-10 04:13:53
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051004-0021-0000-0000-000065C3DC55
Message-Id: <1557461624-21959-2-git-send-email-tlfalcon@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905100027
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only set the device carrier state to on after receiving an up link
state indication from the underlying adapter. Likewise, if a down
link indication is receieved, update the carrier state accordingly.
This fix ensures that accurate carrier state is reported by the driver
following a link state update by the underlying adapter.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index faee60914874..13c9562e2cc6 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1111,7 +1111,6 @@ static int ibmvnic_open(struct net_device *netdev)
 	}
 
 	rc = __ibmvnic_open(netdev);
-	netif_carrier_on(netdev);
 
 	return rc;
 }
@@ -1864,8 +1863,6 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	    adapter->reset_reason != VNIC_RESET_CHANGE_PARAM)
 		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
 
-	netif_carrier_on(netdev);
-
 	return 0;
 }
 
@@ -1935,8 +1932,6 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 		return 0;
 	}
 
-	netif_carrier_on(netdev);
-
 	return 0;
 }
 
@@ -4480,6 +4475,10 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 		    crq->link_state_indication.phys_link_state;
 		adapter->logical_link_state =
 		    crq->link_state_indication.logical_link_state;
+		if (adapter->phys_link_state && adapter->logical_link_state)
+			netif_carrier_on(netdev);
+		else
+			netif_carrier_off(netdev);
 		break;
 	case CHANGE_MAC_ADDR_RSP:
 		netdev_dbg(netdev, "Got MAC address change Response\n");
-- 
2.12.3

