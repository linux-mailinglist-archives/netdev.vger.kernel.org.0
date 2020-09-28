Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD6227B376
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgI1RmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:42:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46890 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgI1RmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 13:42:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SHTB1i018682;
        Mon, 28 Sep 2020 17:42:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=ft+fh2wKCwo7NRM0MMPHB9K/JVk8KBIzsAQhZCAIlX0=;
 b=eRdb2ixcmpQets+fDsOfZjoi020DO0gD1ernIDaxMdkSdhFECTV85dQd1XOGmiItCSiu
 yRbAzVfgPm1cwOxiU6iOsV1reyy4QqI+5mleRuhu2k64WbSSQAH/I4bwPzCwaRembBT9
 1WM+gp7Wqbyix6o0gMaM7UIK6lHIePJbtonQqVkh2seNDbwhBnMZJ5rwYrWR00qZhObK
 DIaArgFSOuCzhAQrQb+5PiYMJcn4OLCd6MSwR1QsE9WXXPYL5d2Qji7WhWguLwToGRZW
 EK63ElJjmo7pb+VvZbo+jG0Z+Ek6olgMJ8YEaRPQqOWQ9YpLsDsPc34N+/tRAwdPMSj6 SQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33sx9mxcn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 17:42:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SHUgwc188074;
        Mon, 28 Sep 2020 17:42:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33tfdqgyvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 17:42:02 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SHg1GF030558;
        Mon, 28 Sep 2020 17:42:01 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 10:42:00 -0700
Date:   Mon, 28 Sep 2020 20:41:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2 net-next] net/mlx5e: TC: Fix IS_ERR() vs NULL checks
Message-ID: <20200928174153.GA446008@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx5_tc_ct_init() function doesn't return error pointers it returns
NULL.  Also we need to set the error codes on this path.

Fixes: aedd133d17bc ("net/mlx5e: Support CT offload for tc nic flows")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 104b1c339de0..438fbcf478d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5224,8 +5224,10 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 
 	tc->ct = mlx5_tc_ct_init(priv, tc->chains, &priv->fs.tc.mod_hdr,
 				 MLX5_FLOW_NAMESPACE_KERNEL);
-	if (IS_ERR(tc->ct))
+	if (!tc->ct) {
+		err = -ENOMEM;
 		goto err_ct;
+	}
 
 	tc->netdevice_nb.notifier_call = mlx5e_tc_netdev_event;
 	err = register_netdevice_notifier_dev_net(priv->netdev,
@@ -5300,8 +5300,10 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 					       esw_chains(esw),
 					       &esw->offloads.mod_hdr,
 					       MLX5_FLOW_NAMESPACE_FDB);
-	if (IS_ERR(uplink_priv->ct_priv))
+	if (!uplink_priv->ct_priv) {
+		err = -ENOMEM;
 		goto err_ct;
+	}
 
 	mapping = mapping_create(sizeof(struct tunnel_match_key),
 				 TUNNEL_INFO_BITS_MASK, true);
-- 
2.28.0

