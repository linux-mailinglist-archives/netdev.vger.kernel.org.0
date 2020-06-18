Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5A91FFD99
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731499AbgFRV4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:56:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29284 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726573AbgFRV4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:56:06 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05ILXIW1061138;
        Thu, 18 Jun 2020 17:55:59 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31repa32g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 17:55:59 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05ILtFgt029872;
        Thu, 18 Jun 2020 21:55:58 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 31rdtr17k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 21:55:58 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05ILtwj054198594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 21:55:58 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 164D2112062;
        Thu, 18 Jun 2020 21:55:58 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 891A7112061;
        Thu, 18 Jun 2020 21:55:57 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.202.56])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 18 Jun 2020 21:55:57 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net v2] ibmveth: Fix max MTU limit
Date:   Thu, 18 Jun 2020 16:55:53 -0500
Message-Id: <1592517353-16844-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_21:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 clxscore=1015
 mlxscore=0 cotscore=-2147483648 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180163
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The max MTU limit defined for ibmveth is not accounting for
virtual ethernet buffer overhead, which is twenty-two additional
bytes set aside for the ethernet header and eight additional bytes
of an opaque handle reserved for use by the hypervisor. Update the
max MTU to reflect this overhead.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Fixes: d894be57ca92 ("ethernet: use net core MTU range checking in more drivers")
Fixes: 110447f8269a ("ethernet: fix min/max MTU typos")
---
v2: Include Fixes tags suggested by Jakub Kicisnki
---
 drivers/net/ethernet/ibm/ibmveth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 96d36ae5049e..c5c732601e35 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1715,7 +1715,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	}
 
 	netdev->min_mtu = IBMVETH_MIN_MTU;
-	netdev->max_mtu = ETH_MAX_MTU;
+	netdev->max_mtu = ETH_MAX_MTU - IBMVETH_BUFF_OH;
 
 	memcpy(netdev->dev_addr, mac_addr_p, ETH_ALEN);
 
-- 
2.26.2

