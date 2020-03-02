Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9F3175EF7
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 16:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgCBP6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 10:58:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8420 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727195AbgCBP6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 10:58:24 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 022FoSrk128176
        for <netdev@vger.kernel.org>; Mon, 2 Mar 2020 10:58:23 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yfnccq8s0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 10:58:22 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <bmt@zurich.ibm.com>;
        Mon, 2 Mar 2020 15:58:20 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 2 Mar 2020 15:58:17 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 022FwGrd51118282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Mar 2020 15:58:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D24CFA4062;
        Mon,  2 Mar 2020 15:58:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AD0AA405B;
        Mon,  2 Mar 2020 15:58:16 +0000 (GMT)
Received: from spoke.zurich.ibm.com (unknown [9.4.69.152])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Mar 2020 15:58:16 +0000 (GMT)
From:   Bernard Metzler <bmt@zurich.ibm.com>
To:     dledford@redhat.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Cc:     Bernard Metzler <bmt@zurich.ibm.com>
Subject: [Patch for-rc v2] RDMA/siw: Fix failure handling during device creation
Date:   Mon,  2 Mar 2020 16:58:14 +0100
X-Mailer: git-send-email 2.17.2
X-TM-AS-GCONF: 00
x-cbid: 20030215-0008-0000-0000-000003587D7C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030215-0009-0000-0000-00004A79A9BE
Message-Id: <20200302155814.9896-1-bmt@zurich.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_05:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A failing call to ib_device_set_netdev() during device creation
caused system crash due to xa_destroy of uninitialized xarray
hit by device deallocation. Fixed by moving xarray initialization
before potential device deallocation.

Fixes: bdcf26bf9b3a (rdma/siw: network and RDMA core interface)
Reported-by: syzbot+2e80962bedd9559fe0b3@syzkaller.appspotmail.com
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
---
v1 -> v2:
- Fix here only potential system crash during failing device
  creation, but not missing correct error propagation.

 drivers/infiniband/sw/siw/siw_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index 96ed349c0939..5cd40fb9e20c 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
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
 
-- 
2.17.2

