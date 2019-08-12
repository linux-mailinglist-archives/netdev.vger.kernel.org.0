Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C96838A90E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfHLVNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:13:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2336 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfHLVNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:13:16 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CL7Q3W048174
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 17:13:15 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ubcdjyjka-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 17:13:15 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <tlfalcon@linux.ibm.com>;
        Mon, 12 Aug 2019 22:13:14 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 12 Aug 2019 22:13:10 +0100
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7CLD95q48693698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 21:13:09 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D133AE05F;
        Mon, 12 Aug 2019 21:13:09 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AD62AE05C;
        Mon, 12 Aug 2019 21:13:09 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.213.234])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 12 Aug 2019 21:13:09 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     liuhangbin@gmail.com, davem@davemloft.net, joe@perches.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net v2] ibmveth: Convert multicast list size for little-endian system
Date:   Mon, 12 Aug 2019 16:13:06 -0500
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
x-cbid: 19081221-0064-0000-0000-0000040803BF
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011586; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000287; SDB=6.01245905; UDB=6.00657437; IPR=6.01027407;
 MB=3.00028151; MTD=3.00000008; XFM=3.00000015; UTC=2019-08-12 21:13:12
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081221-0065-0000-0000-00003EA5337D
Message-Id: <1565644386-22284-1-git-send-email-tlfalcon@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120206
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
v2: define filter size pointer as __be32 instead of unsigned int,
    suggested by Joe Perches
---
 drivers/net/ethernet/ibm/ibmveth.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 77af9c2c0571..5641c00d34f2 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1643,7 +1643,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	struct net_device *netdev;
 	struct ibmveth_adapter *adapter;
 	unsigned char *mac_addr_p;
-	unsigned int *mcastFilterSize_p;
+	__be32 *mcastFilterSize_p;
 	long ret;
 	unsigned long ret_attr;
 
@@ -1665,8 +1665,9 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 		return -EINVAL;
 	}
 
-	mcastFilterSize_p = (unsigned int *)vio_get_attribute(dev,
-						VETH_MCAST_FILTER_SIZE, NULL);
+	mcastFilterSize_p = (__be32 *)vio_get_attribute(dev,
+							VETH_MCAST_FILTER_SIZE,
+							NULL);
 	if (!mcastFilterSize_p) {
 		dev_err(&dev->dev, "Can't find VETH_MCAST_FILTER_SIZE "
 			"attribute\n");
@@ -1683,7 +1684,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	adapter->vdev = dev;
 	adapter->netdev = netdev;
-	adapter->mcastFilterSize = *mcastFilterSize_p;
+	adapter->mcastFilterSize = be32_to_cpu(*mcastFilterSize_p);
 	adapter->pool_config = 0;
 	ibmveth_init_link_settings(adapter);
 
-- 
2.16.4

