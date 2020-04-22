Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5BD1B3B85
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 11:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgDVJgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 05:36:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39554 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVJgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 05:36:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M9YS8I046798;
        Wed, 22 Apr 2020 09:36:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=lVFEYa9FLN9V7tZiN4XFyrj0fF6Aq9VZmqOz4exZud8=;
 b=psNJzeFuZiJZxSPMSQn1GlAL6ezdXlg8c1RpWysw7idMliJTfd1x8gLE0senPawno0ti
 m8xdYmOZTUxX7jLEJojoTQC1WXhT+zX9tywwOfS6WE/CnwfmW8GWmeUpNd/BqIPuT1xQ
 A6gsPeAriC6lZkLSXMKjDA6vXEvyXzKxXdnB6PVX0d9hca3exbRVtzgmcyIGdKEEJF6w
 08WXKIwmr1SD9gnxctrh0l8QM0x0Yf97ob8MoNspQNxkpcmiRKTYyWjXyaLbutI7AEKb
 I112F9I2Of5g+oFbM8xWIyhp5VNEDUz95nCSjnVRrGi0klZ7qn0KNOqM6zSpZu2BiHoi zQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30fsgm1qpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 09:36:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M9WG2N164011;
        Wed, 22 Apr 2020 09:36:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30gb1j59v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 09:36:48 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M9amSb029236;
        Wed, 22 Apr 2020 09:36:48 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Apr 2020 02:36:47 -0700
Date:   Wed, 22 Apr 2020 12:36:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jiri Pirko <jiri@mellanox.com>
Cc:     Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] mlxsw: Fix some IS_ERR() vs NULL bugs
Message-ID: <20200422093641.GA189235@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220076
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlxsw_sp_acl_rulei_create() function is supposed to return an error
pointer from mlxsw_afa_block_create().  The problem is that these
functions both return NULL instead of error pointers.  Half the callers
expect NULL and half expect error pointers so it could lead to a NULL
dereference on failure.

This patch changes both of them to return error pointers and changes all
the callers which checked for NULL to check for IS_ERR() instead.

Fixes: 4cda7d8d7098 ("mlxsw: core: Introduce flexible actions support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c          | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c    | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c      | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index 70a104e728f6..c3d04319ff44 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -380,7 +380,7 @@ struct mlxsw_afa_block *mlxsw_afa_block_create(struct mlxsw_afa *mlxsw_afa)
 
 	block = kzalloc(sizeof(*block), GFP_KERNEL);
 	if (!block)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	INIT_LIST_HEAD(&block->resource_list);
 	block->afa = mlxsw_afa;
 
@@ -408,7 +408,7 @@ struct mlxsw_afa_block *mlxsw_afa_block_create(struct mlxsw_afa *mlxsw_afa)
 	mlxsw_afa_set_destroy(block->first_set);
 err_first_set_create:
 	kfree(block);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL(mlxsw_afa_block_create);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 67ee880a8727..01cff711bbd2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -464,7 +464,7 @@ mlxsw_sp_acl_rulei_create(struct mlxsw_sp_acl *acl,
 
 	rulei = kzalloc(sizeof(*rulei), GFP_KERNEL);
 	if (!rulei)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (afa_block) {
 		rulei->act_block = afa_block;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c
index 6c66a0f1b79e..ad69913f19c1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c
@@ -88,8 +88,8 @@ static int mlxsw_sp2_acl_tcam_init(struct mlxsw_sp *mlxsw_sp, void *priv,
 	 * to be written using PEFA register to all indexes for all regions.
 	 */
 	afa_block = mlxsw_afa_block_create(mlxsw_sp->afa);
-	if (!afa_block) {
-		err = -ENOMEM;
+	if (IS_ERR(afa_block)) {
+		err = PTR_ERR(afa_block);
 		goto err_afa_block;
 	}
 	err = mlxsw_afa_block_continue(afa_block);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c
index 346f4a5fe053..221aa6a474eb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c
@@ -199,8 +199,8 @@ mlxsw_sp_mr_tcam_afa_block_create(struct mlxsw_sp *mlxsw_sp,
 	int err;
 
 	afa_block = mlxsw_afa_block_create(mlxsw_sp->afa);
-	if (!afa_block)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(afa_block))
+		return afa_block;
 
 	err = mlxsw_afa_block_append_allocated_counter(afa_block,
 						       counter_index);
-- 
2.26.1

