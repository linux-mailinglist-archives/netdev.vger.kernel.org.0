Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAA82B7DFE
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 14:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgKRNBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 08:01:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56930 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgKRNBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 08:01:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AID0bm8033164;
        Wed, 18 Nov 2020 13:00:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Sa6V/CmnxV/C6v22R7lRkJxn5tiv5ZTRNw/grKo0Fyw=;
 b=TtNKBOJLBymes09UdnbcvDIMR0Xw9SQ373STdFN3/xI7RYSi+6KUsTmEtiVMREWpkuMT
 Yuw2Gd/jWh2acVlFfLsbr7rBqeKJBpR82nPpARLNK7o+aE0NkW4uGivkVmHWANS/6uoa
 ZhixRYyDKCx0GfGPiNwo1fjWI1so0mrPVrKoGxXq7PgxckTR6LuOindKsfoJli54LTiM
 1bTRDNcBs5vGfjesuOyI4Ld/584NW5c20PLrvFOQZGAjIkbs+QSZ17WBxGeGYncjlX1+
 ezy+V1vte/54hRLzQO94CbTTFt6cU5oaVQoLbAmlnstxJSGX8CqDnMdhie+AmxOuRleJ LQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34t76kyvr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Nov 2020 13:00:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AICfKOw188510;
        Wed, 18 Nov 2020 13:00:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34umd0j7df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 13:00:58 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AID0uE9018806;
        Wed, 18 Nov 2020 13:00:56 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Nov 2020 05:00:56 -0800
Date:   Wed, 18 Nov 2020 16:00:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] mlxsw: spectrum_router: Fix a double free on error
Message-ID: <20201118130048.GA334813@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180090
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a double free here because mlxsw_sp_nexthop6_group_create() and
mlxsw_sp_nexthop6_group_info_init() free "nh_grp".  It should only be
freed in the create function.

Fixes: 7f7a417e6a11 ("mlxsw: spectrum_router: Split nexthop group configuration to a different struct")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index a2e81ad5790f..fde8667a2f60 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5423,7 +5423,6 @@ mlxsw_sp_nexthop6_group_info_init(struct mlxsw_sp *mlxsw_sp,
 		nh = &nhgi->nexthops[i];
 		mlxsw_sp_nexthop6_fini(mlxsw_sp, nh);
 	}
-	kfree(nh_grp);
 	return err;
 }
 
-- 
2.29.2

