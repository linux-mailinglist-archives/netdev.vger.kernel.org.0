Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB10A18CEBC
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgCTNXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:23:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38922 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgCTNXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:23:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02KDE3W2106996;
        Fri, 20 Mar 2020 13:23:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=GWBqcLJVqqizx+c4t6vsOhemKvLjhfwd2QQHwu9uWOo=;
 b=0Wi4QBu4CtGBAj3Lhu2Nhh4gLtxAKA/mEG178Tn7V3uGpcl9TpW1SOP3Rj96gOpXU2CB
 OFn/Np+e/Nzaittd5xw+r26D+L6WpElnAQWaoCNg0NCUzMaXmzlFfrKhBO3ZMe5b+HDs
 VcAs96Vn/HUWLk2QwmK9kYoWSFDCOxuNh8Z41urJJXeJVT5igTboHvj58gHfli0wfShH
 Q/uehJYgloSEQg8Ly7WNCv7ujuaESRZvVAl26yg7mf8d0Ffqh/2t7GUnhNPNu2hcmjhe
 KechvCB1A3vpteV8z/CyPH2y3rCAAk+D86xWZRwEce6J0iYXGaZXhRCc2DW0R7ke3OjM 8w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yub27dgbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Mar 2020 13:23:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02KDKpF8031400;
        Fri, 20 Mar 2020 13:23:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ys8rpus84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Mar 2020 13:23:15 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02KDNE11010187;
        Fri, 20 Mar 2020 13:23:14 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Mar 2020 06:23:13 -0700
Date:   Fri, 20 Mar 2020 16:23:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/mlx5e: Fix actions_match_supported() return
Message-ID: <20200320132305.GB95012@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9565 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003200057
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9565 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1011 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200057
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The actions_match_supported() function returns a bool, true for success
and false for failure.  This error path is returning a negative which
is cast to true but it should return false.

Fixes: 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 044891a03be3..e5de7d2bac2b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3058,7 +3058,7 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 			 */
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Can't offload mirroring with action ct");
-			return -EOPNOTSUPP;
+			return false;
 		}
 	} else {
 		actions = flow->nic_attr->action;
-- 
2.25.1

