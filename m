Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E0A2B86EF
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 22:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgKRVky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 16:40:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726468AbgKRVkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 16:40:53 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AILVstI035327;
        Wed, 18 Nov 2020 16:40:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=VnAx4VODEmZ+Xlj6BCFMGh5EDaIU1nizgGymuQQPrns=;
 b=nAxc38UMjKs7oIich0SDvz2tD7cZNbnk9JlS7dKeN4nhRjC/f1ZjNMCmbhHyKXBCo8Qn
 yw2S9lQ+nIwj4VnJFPZVq76G8rvSDAiBot8hPqAVB5VKBQjiC5yBps2aWG/FyClZ6YZm
 JEQxE25UUsu9nnf/43RmerzUJ0+4lJZDG5fwfvx41iKwOAgUv3gMGdCgg3MZatRboWvs
 PXcPE2iRaIZ23ZA01NUViwDckd8FBEoSyXPyYfyBBL9rbqL5GkxL6dHUYaJct1tUAcab
 0wqiqccAT9zMbytXOeAVPkudR7kSMsucE7/fQ0oYhsuGRuLQ87vjEE95uCMVLwc6kzyq fg== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w4xbmajg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 16:40:52 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AILddmC031049;
        Wed, 18 Nov 2020 21:40:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 34t6v82b5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 21:40:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AILelwW60424474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 21:40:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CCD242045;
        Wed, 18 Nov 2020 21:40:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19B5E42041;
        Wed, 18 Nov 2020 21:40:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Nov 2020 21:40:47 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net 2/2] net/smc: fix direct access to ib_gid_addr->ndev in smc_ib_determine_gid()
Date:   Wed, 18 Nov 2020 22:40:38 +0100
Message-Id: <20201118214038.24039-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201118214038.24039-1-kgraul@linux.ibm.com>
References: <20201118214038.24039-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_08:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 mlxscore=0 adultscore=0 impostorscore=0 suspectscore=1
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180145
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse complaints 3 times about:
net/smc/smc_ib.c:203:52: warning: incorrect type in argument 1 (different address spaces)
net/smc/smc_ib.c:203:52:    expected struct net_device const *dev
net/smc/smc_ib.c:203:52:    got struct net_device [noderef] __rcu *const ndev

Fix that by using the existing and validated ndev variable instead of
accessing attr->ndev directly.

Fixes: 5102eca9039b ("net/smc: Use rdma_read_gid_l2_fields to L2 fields")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_ib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 1c314dbdc7fa..fc766b537ac7 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -198,9 +198,9 @@ int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
 		rcu_read_lock();
 		ndev = rdma_read_gid_attr_ndev_rcu(attr);
 		if (!IS_ERR(ndev) &&
-		    ((!vlan_id && !is_vlan_dev(attr->ndev)) ||
-		     (vlan_id && is_vlan_dev(attr->ndev) &&
-		      vlan_dev_vlan_id(attr->ndev) == vlan_id)) &&
+		    ((!vlan_id && !is_vlan_dev(ndev)) ||
+		     (vlan_id && is_vlan_dev(ndev) &&
+		      vlan_dev_vlan_id(ndev) == vlan_id)) &&
 		    attr->gid_type == IB_GID_TYPE_ROCE) {
 			rcu_read_unlock();
 			if (gid)
-- 
2.17.1

