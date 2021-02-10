Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280F33164A7
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhBJLJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:09:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49266 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbhBJLHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:07:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11AB4YG4123166;
        Wed, 10 Feb 2021 11:06:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=rbP8aoJc2CDQBxtPsjMfM8dDDD67LU7ZXNhHZUy5x5U=;
 b=Mgm80g55dEB9RPV+5f92OQaz6Y3IA3fz6zFrTwmreRKrfOtsvBYLmfYpsDEG/oRFGTzq
 VJrX4JcfLYxcWFv1m4538M3g+hH9CR7Z9dlb83DHoZ4LMH/k/y+798335f+cNeo46NCT
 bCBfNftUquDuSc3zMAVL9z0MMBXA43e0fzm8shr4azB53DRI8aNdUGyty9VX2JqUCvm6
 7S17vBtwLXj0UT9VC4ikNyWOykL96F5TYIvtWNsSYp2gxc0FCJ0gtgMQnra9RuicWDWh
 QCwjt37wnijzNVDey22uV7N1ScvgNyI4+Y2zl1MdQycWR+KZ5hMAcpGjfVWynvW4Dvls Zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36hjhqtyrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 11:06:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11AB4hLR025838;
        Wed, 10 Feb 2021 11:06:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 36j4vsnfju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 11:06:41 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 11AB6eeL000920;
        Wed, 10 Feb 2021 11:06:40 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Feb 2021 03:06:39 -0800
Date:   Wed, 10 Feb 2021 14:06:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/mlx5: Fix a NULL vs IS_ERR() check
Message-ID: <YCO+NCjissLTG1H6@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100109
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100108
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx5_chains_get_table() function doesn't return NULL, it returns
error pointers so we need to fix this condition.

Fixes: 34ca65352ddf ("net/mlx5: E-Switch, Indirect table infrastructure")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This applies to net-next but it might actually go through a different
tree before going to net?  I don't know how this works...

 drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
index b7d00c4c7046..6f6772bf61a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
@@ -216,7 +216,7 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 	flow_act.flags = FLOW_ACT_IGNORE_FLOW_LEVEL | FLOW_ACT_NO_APPEND;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = mlx5_chains_get_table(chains, 0, 1, 0);
-	if (!dest.ft) {
+	if (IS_ERR(dest.ft)) {
 		err = PTR_ERR(dest.ft);
 		goto err_table;
 	}
-- 
2.30.0

