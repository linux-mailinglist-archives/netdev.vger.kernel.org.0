Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1712AC3E97
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbfJARa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:30:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33204 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfJARa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 13:30:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91HEB6Z037370;
        Tue, 1 Oct 2019 17:30:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=9dxYTAN2a/aSq7vR8sC+CkVhlZRn5DgOhPik95ijhU0=;
 b=aV4N5WxC9zfcbT3/iG77MYuyVQ+XU/m3rYA4BwBlYzknYdkS3c6qecioNoZ3dHAmmlmk
 rZwjF5h3mOBF2lTSkYEnfssyZWEu2vo17fKRIfajtjdqGQc05+29jN15kDwU6as6eZoG
 zZnGkgN/jgygqlDVEhsGhiXiEfF63NCegEdkAUR5PBSqePoGxrIE0WtDCkSyF/euhlRS
 um2J0V5weXFVQzMNny1DtrEPesed6iToB39mh0snsOz8mkv3gdqajF7CT9qboTHARldb
 sAsybjecDXlKG0l5u2jYIYxzEBrAphVCRg190N6d8f1WWGOJ8e9q/mGXuWGrLEibqFRk Lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v9yfq7nc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 17:30:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91HDDUR117278;
        Tue, 1 Oct 2019 17:30:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2vbmq017vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Oct 2019 17:30:23 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x91HSwbJ163873;
        Tue, 1 Oct 2019 17:30:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vbmq017vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 17:30:23 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x91HULbi003436;
        Tue, 1 Oct 2019 17:30:21 GMT
Received: from ca-dev92.us.oracle.com (/10.129.135.31)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 10:30:21 -0700
From:   Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        santosh.shilimkar@oracle.com, rds-devel@oss.oracle.com
Cc:     Dotan Barak <dotanb@dev.mellanox.co.il>,
        Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>
Subject: [PATCH net] net/rds: Fix error handling in rds_ib_add_one()
Date:   Tue,  1 Oct 2019 10:21:02 -0700
Message-Id: <1569950462-37680-1-git-send-email-sudhakar.dindukurti@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010143
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dotan Barak <dotanb@dev.mellanox.co.il>

rds_ibdev:ipaddr_list and rds_ibdev:conn_list are initialized
after allocation some resources such as protection domain.
If allocation of such resources fail, then these uninitialized
variables are accessed in rds_ib_dev_free() in failure path. This
can potentially crash the system. The code has been updated to
initialize these variables very early in the function.

Signed-off-by: Dotan Barak <dotanb@dev.mellanox.co.il>
Signed-off-by: Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>
---
 net/rds/ib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 45acab2..9de2ae2 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -143,6 +143,9 @@ static void rds_ib_add_one(struct ib_device *device)
 	refcount_set(&rds_ibdev->refcount, 1);
 	INIT_WORK(&rds_ibdev->free_work, rds_ib_dev_free);
 
+	INIT_LIST_HEAD(&rds_ibdev->ipaddr_list);
+	INIT_LIST_HEAD(&rds_ibdev->conn_list);
+
 	rds_ibdev->max_wrs = device->attrs.max_qp_wr;
 	rds_ibdev->max_sge = min(device->attrs.max_send_sge, RDS_IB_MAX_SGE);
 
@@ -203,9 +206,6 @@ static void rds_ib_add_one(struct ib_device *device)
 		device->name,
 		rds_ibdev->use_fastreg ? "FRMR" : "FMR");
 
-	INIT_LIST_HEAD(&rds_ibdev->ipaddr_list);
-	INIT_LIST_HEAD(&rds_ibdev->conn_list);
-
 	down_write(&rds_ib_devices_lock);
 	list_add_tail_rcu(&rds_ibdev->list, &rds_ib_devices);
 	up_write(&rds_ib_devices_lock);
-- 
1.8.3.1

