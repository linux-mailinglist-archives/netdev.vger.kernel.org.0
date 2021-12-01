Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F70B4646D8
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 06:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346799AbhLAFwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 00:52:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62614 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230497AbhLAFwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 00:52:00 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B15N0hQ027669
        for <netdev@vger.kernel.org>; Wed, 1 Dec 2021 05:48:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=kZpVz0PqZt68ocJfdZxhrsrPIYaWwKdYNiuvAH3l/no=;
 b=FVgjhaAZ4Vl+AZKxq35oR06kQWuUuQdrfLxjl6VCJXXa+pEMs3bBH30dBjM1hfWWcldO
 Xxlev+FmColA0XBpVcLAz1+mIHPUGUE7JOJ4O/o0M59GmMRQZVRmhQUN4PJIF0exEoa+
 uEFxdjzl2qOXMdmVX9pDleUbL29QK4W/aLpdGrFiKZjeGu+mV36nZR8hj0hZIzTgUGQE
 /MDbhbb7bcOsRVeWL/wuAXc2zwMbEvrqj5xNW61dw/k6tHPrGAgm57KTIkwvEFdePaLz
 C2i4K03oqIRm/IG0mm9Kx107iIVC0wP0ryV2Zl69yAIxCYd6KwAwyq77vZNut9DRbbjy yA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cp2ukgb87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 05:48:39 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B15hJJE029678
        for <netdev@vger.kernel.org>; Wed, 1 Dec 2021 05:48:39 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3cnne1up9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 05:48:39 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B15mcJU58589488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Dec 2021 05:48:38 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19589112065;
        Wed,  1 Dec 2021 05:48:38 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CA62112061;
        Wed,  1 Dec 2021 05:48:37 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.160.98.147])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Dec 2021 05:48:36 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net 1/2] ibmvnic: drop bad optimization in reuse_rx_pools()
Date:   Tue, 30 Nov 2021 21:48:35 -0800
Message-Id: <20211201054836.3488211-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yxaEGeFwCa_jqmri4_xxVN5uDyE13J1B
X-Proofpoint-GUID: yxaEGeFwCa_jqmri4_xxVN5uDyE13J1B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxscore=0 spamscore=0
 impostorscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112010031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When trying to decide whether or not reuse existing rx/tx pools
we tried to allow a range of values for the pool parameters rather
than exact matches. This was intended to reuse the resources for
instance when switching between two VIO servers with different
default parameters.

But this optimization is incomplete and breaks when we try to
change the number of queues for instance. The optimization needs
to be updated, so drop it for now and simplify the code.

Fixes: 489de956e7a2 ("ibmvnic: Reuse rx pools when possible")
Reported-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3cca51735421..6df92a872f0f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -628,17 +628,9 @@ static bool reuse_rx_pools(struct ibmvnic_adapter *adapter)
 	old_buff_size = adapter->prev_rx_buf_sz;
 	new_buff_size = adapter->cur_rx_buf_sz;
 
-	/* Require buff size to be exactly same for now */
-	if (old_buff_size != new_buff_size)
-		return false;
-
-	if (old_num_pools == new_num_pools && old_pool_size == new_pool_size)
-		return true;
-
-	if (old_num_pools < adapter->min_rx_queues ||
-	    old_num_pools > adapter->max_rx_queues ||
-	    old_pool_size < adapter->min_rx_add_entries_per_subcrq ||
-	    old_pool_size > adapter->max_rx_add_entries_per_subcrq)
+	if (old_buff_size != new_buff_size ||
+	    old_num_pools != new_num_pools ||
+	    old_pool_size != new_pool_size)
 		return false;
 
 	return true;
-- 
2.27.0

