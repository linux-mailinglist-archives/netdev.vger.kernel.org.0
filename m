Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387381CB1E3
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 16:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgEHOhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 10:37:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45970 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgEHOhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 10:37:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 048EYEY5066844;
        Fri, 8 May 2020 14:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=mRBlnLIi63DIBclr56V03rZJn6uvyhzmKtShbOW07ng=;
 b=oxJ0BwQx8NfahV28FF4nFdjUz/nYuzv5SBUVE0IAASj9gU8UorTSjLuIPpmMeb0h9ZP8
 0IeKHq8jHnhPL8Av+EG7dcauOCE8bopzk1ZWLSrRlKDekNvMPZmq4aWuqxWyzoKSc+Hi
 995j7O7YmzTwolWSsUeABN5fHtNDyKQHsHUio7zmJtV1wPI5queKFue3FkN74Ctw/o6P
 0u+hM9t8eFaqukN7LbFEC+EXzCXNYneBRPUkt81Jl3V28qIcpf1f1OhaaPpIsLRm0YRA
 TAI2gUpYF4LFwLwJF88S0jGR5N8bQlUeY6XwyNJtqkYyaecTJNbXPJR9Cg/wjnWLnbLn gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30vtexuak1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 14:37:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 048Ea0qH099152;
        Fri, 8 May 2020 14:37:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30vtecnydh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 14:37:29 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 048EbRGa027544;
        Fri, 8 May 2020 14:37:27 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 May 2020 07:37:27 -0700
Date:   Fri, 8 May 2020 17:37:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] dpaa2-eth: prevent array underflow in update_cls_rule()
Message-ID: <20200508143720.GA410645@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "location" is controlled by the user via the ethtool_set_rxnfc()
function.  This update_cls_rule() function checks for array overflows
but it doesn't check if the value is negative.  I have changed the type
to unsigned to prevent array underflows.

Fixes: afb90dbb5f78 ("dpaa2-eth: Add ethtool support for flow classification")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index bd13ee48d6230..049afd1d6252d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -635,7 +635,7 @@ static int num_rules(struct dpaa2_eth_priv *priv)
 
 static int update_cls_rule(struct net_device *net_dev,
 			   struct ethtool_rx_flow_spec *new_fs,
-			   int location)
+			   unsigned int location)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	struct dpaa2_eth_cls_rule *rule;
-- 
2.26.2

