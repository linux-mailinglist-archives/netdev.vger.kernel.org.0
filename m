Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D05170128
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 15:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgBZO33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 09:29:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27954 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727446AbgBZO33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 09:29:29 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QETNCo058790
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:29:28 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydkf97dth-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:29:28 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <bmt@zurich.ibm.com>;
        Wed, 26 Feb 2020 14:29:26 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 26 Feb 2020 14:29:24 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01QETNCV47906952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 14:29:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 281A8A4055;
        Wed, 26 Feb 2020 14:29:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4928A4053;
        Wed, 26 Feb 2020 14:29:22 +0000 (GMT)
Received: from spoke.zurich.ibm.com (unknown [9.4.69.152])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Feb 2020 14:29:22 +0000 (GMT)
From:   Bernard Metzler <bmt@zurich.ibm.com>
To:     dledford@redhat.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Cc:     Bernard Metzler <bmt@zurich.ibm.com>
Subject: [PATCH for-rc] RDMA/siw: Fix failure handling during device creation
Date:   Wed, 26 Feb 2020 15:29:20 +0100
X-Mailer: git-send-email 2.17.2
X-TM-AS-GCONF: 00
x-cbid: 20022614-0016-0000-0000-000002EA7B26
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022614-0017-0000-0000-0000334DAAFD
Message-Id: <20200226142920.11074-1-bmt@zurich.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_05:2020-02-26,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 bulkscore=0 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002260107
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A failing call to ib_device_set_netdev() during device creation
caused system crash due to xa_destroy of uninitialized xarray
hit by device deallocation. Fixed by moving xarray initialization
before potential device deallocation.
Fixes also correct propagation of ib_device_set_netdev() failure
to caller.

Reported-by: syzbot+2e80962bedd9559fe0b3@syzkaller.appspotmail.com
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
---
 drivers/infiniband/sw/siw/siw_main.c | 39 ++++++++++++++--------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index 96ed349c0939..839decfd9032 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -303,7 +303,7 @@ static const struct ib_device_ops siw_device_ops = {
 
 static struct siw_device *siw_device_create(struct net_device *netdev)
 {
-	struct siw_device *sdev = NULL;
+	struct siw_device *sdev;
 	struct ib_device *base_dev;
 	struct device *parent = netdev->dev.parent;
 	int rv;
@@ -319,13 +319,13 @@ static struct siw_device *siw_device_create(struct net_device *netdev)
 		if (netdev->type != ARPHRD_LOOPBACK) {
 			pr_warn("siw: device %s error: no parent device\n",
 				netdev->name);
-			return NULL;
+			return ERR_PTR(-EINVAL);
 		}
 		parent = &netdev->dev;
 	}
 	sdev = ib_alloc_device(siw_device, base_dev);
 	if (!sdev)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	base_dev = &sdev->base_dev;
 
@@ -388,6 +388,9 @@ static struct siw_device *siw_device_create(struct net_device *netdev)
 		{ .max_segment_size = SZ_2G };
 	base_dev->num_comp_vectors = num_possible_cpus();
 
+	xa_init_flags(&sdev->qp_xa, XA_FLAGS_ALLOC1);
+	xa_init_flags(&sdev->mem_xa, XA_FLAGS_ALLOC1);
+
 	ib_set_device_ops(base_dev, &siw_device_ops);
 	rv = ib_device_set_netdev(base_dev, netdev, 1);
 	if (rv)
@@ -415,9 +418,6 @@ static struct siw_device *siw_device_create(struct net_device *netdev)
 	sdev->attrs.max_srq_wr = SIW_MAX_SRQ_WR;
 	sdev->attrs.max_srq_sge = SIW_MAX_SGE;
 
-	xa_init_flags(&sdev->qp_xa, XA_FLAGS_ALLOC1);
-	xa_init_flags(&sdev->mem_xa, XA_FLAGS_ALLOC1);
-
 	INIT_LIST_HEAD(&sdev->cep_list);
 	INIT_LIST_HEAD(&sdev->qp_list);
 
@@ -435,7 +435,7 @@ static struct siw_device *siw_device_create(struct net_device *netdev)
 error:
 	ib_dealloc_device(base_dev);
 
-	return NULL;
+	return ERR_PTR(rv);
 }
 
 /*
@@ -542,8 +542,8 @@ static struct notifier_block siw_netdev_nb = {
 static int siw_newlink(const char *basedev_name, struct net_device *netdev)
 {
 	struct ib_device *base_dev;
-	struct siw_device *sdev = NULL;
-	int rv = -ENOMEM;
+	struct siw_device *sdev;
+	int rv;
 
 	if (!siw_dev_qualified(netdev))
 		return -EINVAL;
@@ -554,18 +554,19 @@ static int siw_newlink(const char *basedev_name, struct net_device *netdev)
 		return -EEXIST;
 	}
 	sdev = siw_device_create(netdev);
-	if (sdev) {
-		dev_dbg(&netdev->dev, "siw: new device\n");
+	if (IS_ERR(sdev))
+		return PTR_ERR(sdev);
 
-		if (netif_running(netdev) && netif_carrier_ok(netdev))
-			sdev->state = IB_PORT_ACTIVE;
-		else
-			sdev->state = IB_PORT_DOWN;
+	dev_dbg(&netdev->dev, "siw: new device\n");
 
-		rv = siw_device_register(sdev, basedev_name);
-		if (rv)
-			ib_dealloc_device(&sdev->base_dev);
-	}
+	if (netif_running(netdev) && netif_carrier_ok(netdev))
+		sdev->state = IB_PORT_ACTIVE;
+	else
+		sdev->state = IB_PORT_DOWN;
+
+	rv = siw_device_register(sdev, basedev_name);
+	if (rv)
+		ib_dealloc_device(&sdev->base_dev);
 	return rv;
 }
 
-- 
2.17.2

