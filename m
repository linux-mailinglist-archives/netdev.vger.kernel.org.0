Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5F010FE43
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 14:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfLCNAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 08:00:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36878 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfLCNAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 08:00:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3CxGds005144;
        Tue, 3 Dec 2019 13:00:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=5tZAlCPgdVP36CP+akVJP1u8E+MEetlLScOAxSdVQhw=;
 b=SJu8Y51JJ5p6fOvhe/9orsFUTwliY2bSUX6SRJkaHgN4MlXf8H1u/yvbNA59AGVefu67
 JyMzafeXOFgcZJFJ9L5N7rIAQ3Q2FN+1MsrCQj2OITx14tJDFk8jhiCqF1KpCWQa4rqy
 pIC94IscUFAicRWwQcE2XIxv+HlcWptF5Vjh0x7lcmK702/SvhNgPwGn9hNfPanc4rAg
 O9hwCHV0vwhTh/vMCF8Z6H8a8KxI7TVXXLg98neiAqi3HqQ6UwpYYYdXzkb6M6iGMaE/
 1VFV1owSjNozociKkGJMoEuwFn39kJ6CJ8o7GYOdskugx94cM0hX3/qd0BMn6a1c2RoO fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wkgcq7dss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 13:00:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3CxC1i051007;
        Tue, 3 Dec 2019 13:00:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wn7pq19uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 13:00:23 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB3D0K6v009086;
        Tue, 3 Dec 2019 13:00:20 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 05:00:19 -0800
Date:   Tue, 3 Dec 2019 16:00:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexander Lobakin <alobakin@dlink.ru>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: fix a leak in register_netdevice()
Message-ID: <20191203130011.wzzwdi5sebevkenj@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have to free "dev->name_node" on this error path.

Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
Reported-by: syzbot+6e13e65ffbaa33757bcb@syzkaller.appspotmail.com
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/core/dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d75fd04d4e2c..9cc4b193d8c4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9246,7 +9246,7 @@ int register_netdevice(struct net_device *dev)
 		if (ret) {
 			if (ret > 0)
 				ret = -EIO;
-			goto out;
+			goto err_free_name;
 		}
 	}
 
@@ -9361,12 +9361,13 @@ int register_netdevice(struct net_device *dev)
 	return ret;
 
 err_uninit:
-	if (dev->name_node)
-		netdev_name_node_free(dev->name_node);
 	if (dev->netdev_ops->ndo_uninit)
 		dev->netdev_ops->ndo_uninit(dev);
 	if (dev->priv_destructor)
 		dev->priv_destructor(dev);
+err_free_name:
+	if (dev->name_node)
+		netdev_name_node_free(dev->name_node);
 	goto out;
 }
 EXPORT_SYMBOL(register_netdevice);
-- 
2.11.0

