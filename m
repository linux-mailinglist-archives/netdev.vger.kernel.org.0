Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E718D8A679
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 20:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfHLSqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 14:46:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726610AbfHLSqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 14:46:07 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CHgH56138269;
        Mon, 12 Aug 2019 13:43:13 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ub9m0rk9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 13:43:13 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7CHhD8C140639;
        Mon, 12 Aug 2019 13:43:13 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ub9m0rk91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 13:43:12 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7CHPaJv022221;
        Mon, 12 Aug 2019 17:43:12 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 2u9nj6ge60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 17:43:11 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7CHhB2v43581894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 17:43:11 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32A66112061;
        Mon, 12 Aug 2019 17:43:11 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C58D5112064;
        Mon, 12 Aug 2019 17:43:10 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.213.234])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 12 Aug 2019 17:43:10 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     liuhangbin@gmail.com, davem@davemloft.net, joe@perches.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net] ibmveth: Convert multicast list size for little-endian systems
Date:   Mon, 12 Aug 2019 12:43:06 -0500
Message-Id: <1565631786-18860-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120194
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ibm,mac-address-filters property defines the maximum number of
addresses the hypervisor's multicast filter list can support. It is
encoded as a big-endian integer in the OF device tree, but the virtual
ethernet driver does not convert it for use by little-endian systems.
As a result, the driver is not behaving as it should on affected systems
when a large number of multicast addresses are assigned to the device.

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index d654c23..b50a6cf 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1645,7 +1645,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	adapter->vdev = dev;
 	adapter->netdev = netdev;
-	adapter->mcastFilterSize = *mcastFilterSize_p;
+	adapter->mcastFilterSize = be32_to_cpu(*mcastFilterSize_p);
 	adapter->pool_config = 0;
 
 	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
-- 
1.8.3.1

