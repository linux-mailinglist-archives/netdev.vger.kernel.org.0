Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB12027AA3D
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgI1JIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 05:08:17 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42102 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgI1JIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 05:08:17 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S93hJV194769;
        Mon, 28 Sep 2020 09:08:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=jfgO1O7Ck5C96o5hB9CZqDDeCkVWsRHno5yUPfNdobY=;
 b=SHrRNC/EYgSqWf4UMZAt3acjFOmY5dZWWBZfeuJeATXT0EwqrgvmSi85QE0GN2g0LF88
 1MKsDKM/XrrToIC/1RxJWNPBIdAxSj/M9oUHydCZUCpe4BpK8CwRDOTSu6xcnAEsLU60
 UsUxkdWFDIWu3CVo3VERK4MqaVy4hmDdnjWQEkTHrIxbJ1baKc18cvqa9eVj03Mhbudi
 tYbyeLSB4I1H7IkMKrsWj6c5PyN1SnfCPjSDXphucBSWBWEtO48ddbwu+wZ4edZvmV8R
 gWBlWPbGUNW7rJIFfzXxKDAWdjDmhnLhLv70OxRhVhcZzsR3QzWYzI7OBVq2bWHr/SYo 8A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33su5am0uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 09:08:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S94jHF072788;
        Mon, 28 Sep 2020 09:06:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33tf7k2mmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 09:06:06 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08S964Hi006320;
        Mon, 28 Sep 2020 09:06:04 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 02:06:04 -0700
Date:   Mon, 28 Sep 2020 12:05:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Ariel Levkovich <lariel@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/mlx5e: Fix a use after free on error in
 mlx5_tc_ct_shared_counter_get()
Message-ID: <20200928090556.GA377727@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280076
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1011 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280076
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code frees "shared_counter" and then dereferences on the next line
to get the error code.

Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both directions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index b5f8ed30047b..cea2070af9af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -739,6 +739,7 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_core_dev *dev = ct_priv->dev;
 	struct mlx5_ct_entry *rev_entry;
 	__be16 tmp_port;
+	int ret;
 
 	/* get the reversed tuple */
 	tmp_port = rev_tuple.port.src;
@@ -778,8 +779,9 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	shared_counter->counter = mlx5_fc_create(dev, true);
 	if (IS_ERR(shared_counter->counter)) {
 		ct_dbg("Failed to create counter for ct entry");
+		ret = PTR_ERR(shared_counter->counter);
 		kfree(shared_counter);
-		return ERR_PTR(PTR_ERR(shared_counter->counter));
+		return ERR_PTR(ret);
 	}
 
 	refcount_set(&shared_counter->refcount, 1);
-- 
2.28.0

