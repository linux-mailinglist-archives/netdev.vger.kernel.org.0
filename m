Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC639EFC9
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbfH0QKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:10:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9486 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726420AbfH0QKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 12:10:17 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7RG2qnd023510;
        Tue, 27 Aug 2019 12:10:10 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2un5cy061u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Aug 2019 12:10:09 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7RG7A4f015037;
        Tue, 27 Aug 2019 16:10:09 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 2ujvv6gma4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Aug 2019 16:10:09 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7RGA8Bq13697292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 16:10:08 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B634112062;
        Tue, 27 Aug 2019 16:10:08 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5383E112063;
        Tue, 27 Aug 2019 16:10:08 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.41.178.211])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 27 Aug 2019 16:10:08 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net] ibmvnic: Do not process reset during or after device removal
Date:   Tue, 27 Aug 2019 11:10:04 -0500
Message-Id: <1566922204-8770-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-27_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908270160
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the ibmvnic driver will not schedule device resets
if the device is being removed, but does not check the device
state before the reset is actually processed. This leads to a race
where a reset is scheduled with a valid device state but is
processed after the driver has been removed, resulting in an oops.

Fix this by checking the device state before processing a queued
reset event.

Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index cebd20f..fa4bb94 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1983,6 +1983,10 @@ static void __ibmvnic_reset(struct work_struct *work)
 
 	rwi = get_next_rwi(adapter);
 	while (rwi) {
+		if (adapter->state == VNIC_REMOVING ||
+		    adapter->state == VNIC_REMOVED)
+			goto out;
+
 		if (adapter->force_reset_recovery) {
 			adapter->force_reset_recovery = false;
 			rc = do_hard_reset(adapter, rwi, reset_state);
@@ -2007,7 +2011,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 		netdev_dbg(adapter->netdev, "Reset failed\n");
 		free_all_rwi(adapter);
 	}
-
+out:
 	adapter->resetting = false;
 	if (we_lock_rtnl)
 		rtnl_unlock();
-- 
1.8.3.1

