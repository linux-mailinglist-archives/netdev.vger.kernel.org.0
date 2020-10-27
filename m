Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE1029CBB9
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832202AbgJ0WFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:05:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3562 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1832200AbgJ0WFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:05:02 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09RM2JZU044936;
        Tue, 27 Oct 2020 18:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=MHXRF0AdAD0+gEHNSXKd14rznueMxkSpFzOEMq4G+Ws=;
 b=QLhBWcbEoyd5cghDuuO/JmgajsNxUiMFHm1jgT/28NerM06kQgu3Zh0G+2N2aaktj9xK
 t6dtorTM2P1tBIbY11PcFDTwpkI1Tq6Ac5ZvNxiRr0OUUq2xT6fqqFUqK5phqb5sAy3h
 VAMSGcmgleQo9P4/jl0RR+k0mmfIjqnMq5OKpYr15bUkX6utsQ920cseNw5kO3fha+XL
 US+OT16hQVkHLvKDYsEPkeZBz+PuWoQbkjTznsiVUo5CvJRDcUWJ7KK2c1mJwcyPWbTj
 vGMPPXAEqypeFh2YFzEvsI4CTNPX/Kq/ySCCAy0MdaNkGu8Yve/GXBPu2dcy9LrsjNx1 jg== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34endj5xy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 18:04:59 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09RM2TUi031110;
        Tue, 27 Oct 2020 22:04:59 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 34ernq97vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 22:04:59 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09RM4oat524918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 22:04:50 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4A4AC6095;
        Tue, 27 Oct 2020 22:04:57 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10F3AC6092;
        Tue, 27 Oct 2020 22:04:56 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.105])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 27 Oct 2020 22:04:56 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3] ibmvnic: fix ibmvnic_set_mac
Date:   Tue, 27 Oct 2020 17:04:56 -0500
Message-Id: <20201027220456.71450-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-27_15:2020-10-26,2020-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxlogscore=964 mlxscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0 suspectscore=1
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270125
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

The fix is to validate ethernet address at the beginning of
ibmvnic_set_mac(), and move the ether_addr_copy to
the case of "adapter->state != VNIC_PROBED".

Fixes: 62740e97881c ("net/ibmvnic: Update MAC address settings after adapter reset")
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
v2: change the subject from v1's 
    "ibmvnic: no need to update adapter->mac_addr before it completes"
    handle adapter->state==VNIC_PROBED case in else statement.
v3: take Maciej Fijalkowski's advice.

 drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 4dd3625a4fbc..660761538c55 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1828,9 +1828,13 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
 	int rc;
 
 	rc = 0;
-	ether_addr_copy(adapter->mac_addr, addr->sa_data);
-	if (adapter->state != VNIC_PROBED)
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	if (adapter->state != VNIC_PROBED) {
+		ether_addr_copy(adapter->mac_addr, addr->sa_data);
 		rc = __ibmvnic_set_mac(netdev, addr->sa_data);
+	}
 
 	return rc;
 }
-- 
2.23.0

