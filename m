Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A6C3D06BE
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 04:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhGUBzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 21:55:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231255AbhGUByE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 21:54:04 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16L2XF3O167986
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 22:34:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=vjte2g6X1YlaVW9v/oKUCZylHUw6lkCSUV6/T/3M8u8=;
 b=XVWyeLgFFfrXFUHkveClCbjc0tHi6gc/0+LwPlcTlLmxbsKIbmtWb3NOe/yfmI9oZYwo
 MSu67VglsLmpm7LX0ATLpimyzJqsL5Uy97OOwR9k3VwNeOWIF624rloUEDc2zbQQCnCl
 ebxH4+NxWiUPFc4yhrqcjwNUiGf+61slByvDzn91Ne6Se45T7XPqsQAPD6Vd8Sbqo19K
 oBqTtrgOXpwGXGk5b4D/qLKupc7h0KBWegbEr+kKz9ZHvbwkvLlicyqqxG0v1WHBtxaJ
 gq+/FHoCFFcCCOjCtWoE0KKPCuTT0qMIbNie1YkYD686bKD9D5OMuKuLk5lAOadippem yg== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39x9c8t02q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 22:34:41 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16L2BeoH014569
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 02:34:40 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 39upubpa08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 02:34:40 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16L2Yep039125354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 02:34:40 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E7CD124055;
        Wed, 21 Jul 2021 02:34:40 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C17B5124053;
        Wed, 21 Jul 2021 02:34:39 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.184.186])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 21 Jul 2021 02:34:39 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com
Subject: [PATCH net 1/1] ibmvnic: Remove the proper scrq flush
Date:   Tue, 20 Jul 2021 19:34:39 -0700
Message-Id: <20210721023439.1018976-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: u-DcLF6lbxXlZ0t0hcmL9OrYPD13MFMp
X-Proofpoint-GUID: u-DcLF6lbxXlZ0t0hcmL9OrYPD13MFMp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-20_15:2021-07-19,2021-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 phishscore=0 impostorscore=0
 mlxlogscore=990 suspectscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107210012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 65d6470d139a ("ibmvnic: clean pending indirect buffs during reset")
intended to remove the call to ibmvnic_tx_scrq_flush() when the
->resetting flag is true and was tested that way. But during the final
rebase to net-next, the hunk got applied to a block few lines below
(which happened to have the same diff context) and the wrong call to
ibmvnic_tx_scrq_flush() got removed.

Fix that by removing the correct ibmvnic_tx_scrq_flush() and restoring
the one that was incorrectly removed.

Fixes: 65d6470d139a ("ibmvnic: clean pending indirect buffs during reset")
Reported-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index d193023b6f30..8ab1b6f9fdde 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1895,7 +1895,6 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_send_failed++;
 		tx_dropped++;
 		ret = NETDEV_TX_OK;
-		ibmvnic_tx_scrq_flush(adapter, tx_scrq);
 		goto out;
 	}
 
@@ -1917,6 +1916,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		dev_kfree_skb_any(skb);
 		tx_send_failed++;
 		tx_dropped++;
+		ibmvnic_tx_scrq_flush(adapter, tx_scrq);
 		ret = NETDEV_TX_OK;
 		goto out;
 	}
-- 
2.26.2

