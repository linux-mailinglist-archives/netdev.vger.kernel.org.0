Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125E4294806
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 08:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408288AbgJUGHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 02:07:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406819AbgJUGHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 02:07:16 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09L627Kp171103;
        Wed, 21 Oct 2020 02:07:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=0fkNehO/hT9/rbpAv0S6ESR9pqyGqzBH8mV+UwELmdk=;
 b=r4T8cOT0JB0IcMySDn8MsTRaM6kVexN3mZ27GT9dFG81i3wtQQQON4/mEupGGYWj9Kl3
 ZYSs1eLdFYr+WJVDQ0ETjYbzjDMLzRxwoCqmKsS8+596Y3xa/kR8sXQn/FlCjNnWTzGG
 k945M4TzI9lX9A6FOvrjItmIK2v6O5endkYCu7zq+QjpezrkZFiaXMA+AiqFbtOUv/I5
 NxTGnV+j3ick5aYodxpAwO3pF7jMRZ1GIpMB9WGATM79kGcP+vvTNKsWCXpLK+MOr4qR
 qj76eDdpWhttBj86+ZAQ3GIT7D6AVsyMWeMsMgYEhWuRIe5lnTPXnD2nkqc5p66HBs1P ag== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34aewrrtjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 02:07:14 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09L66rDM011710;
        Wed, 21 Oct 2020 06:07:13 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 347r895rys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 06:07:13 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09L67DrO26673468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Oct 2020 06:07:13 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 099DC124052;
        Wed, 21 Oct 2020 06:07:13 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAEBC124055;
        Wed, 21 Oct 2020 06:07:12 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.179.149])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 21 Oct 2020 06:07:12 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2] ibmvnic: fix ibmvnic_set_mac
Date:   Wed, 21 Oct 2020 01:07:12 -0500
Message-Id: <20201021060712.48806-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_03:2020-10-20,2020-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=843 spamscore=0 impostorscore=0 phishscore=0 mlxscore=0
 clxscore=1015 suspectscore=1 lowpriorityscore=0 malwarescore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010210045
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski brought up a concern in ibmvnic_set_mac().
ibmvnic_set_mac() does this:

	ether_addr_copy(adapter->mac_addr, addr->sa_data);
	if (adapter->state != VNIC_PROBED)
		rc = __ibmvnic_set_mac(netdev, addr->sa_data);

So if state == VNIC_PROBED, the user can assign an invalid address to
adapter->mac_addr, and ibmvnic_set_mac() will still return 0.

The fix is to add the handling for "adapter->state == VNIC_PROBED" case,
which saves the old mac address back to adapter->mac_addr, and
returns an error code.

Fixes: 62740e97881c ("net/ibmvnic: Update MAC address settings after adapter reset")
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
v2: change the subject from v1's 
    "ibmvnic: no need to update adapter->mac_addr before it completes"
    handle adapter->state==VNIC_PROBED case in else statement.

 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 4dd3625a4fbc..0d78e1e3d44c 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1829,8 +1829,12 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
 
 	rc = 0;
 	ether_addr_copy(adapter->mac_addr, addr->sa_data);
-	if (adapter->state != VNIC_PROBED)
+	if (adapter->state != VNIC_PROBED) {
 		rc = __ibmvnic_set_mac(netdev, addr->sa_data);
+	} else {
+		ether_addr_copy(adapter->mac_addr, netdev->dev_addr);
+		rc = -EIO;
+	}
 
 	return rc;
 }
-- 
2.23.0

