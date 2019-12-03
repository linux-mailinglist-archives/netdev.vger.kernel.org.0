Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F180A10FFBC
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 15:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfLCONc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 09:13:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54134 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfLCONN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 09:13:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3E9Ctm067137;
        Tue, 3 Dec 2019 14:12:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2019-08-05; bh=GM0jiXaauXNj1lZfBLUl0t+NfrgLr79nfwmNhOWBOXY=;
 b=RMIpwZ3ERMXgeRRQVNs89QzUq3gsVhU8qsRDkqxCTbPWZ3kpIuXI1diEV5n/DyWXOprf
 0i+tpo0yAHwqZCx5mFHDpT1Rzcennxjdk+vagM2oGO/EVRajTU4GjSGnq27WReioFkf2
 nihKS3H3i8ESaRj1ZCcBhN584IflSYjBEQNjPxuto9khDnZQ5wIcXHNiHW1+GCCZYCTF
 e0DkYHAPfNKeBXKNKu6FjRCgAX4uwyPalUxx0JI23BxlbtrnML9SgJ6jDP3DETEEq2Pq
 vWJg2ttO0CmMk5kvMvozoG1+PZad1J49XUCcBoC7oAagVoxTqo3t49SR+9WVZQPTUdgv /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wkgcq7uce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 14:12:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3E8nCS088870;
        Tue, 3 Dec 2019 14:12:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wn4qq0ve3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 14:12:53 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB3ECoE9000795;
        Tue, 3 Dec 2019 14:12:50 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 06:12:49 -0800
Date:   Tue, 3 Dec 2019 17:12:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, walter harms <wharms@bfs.de>
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexander Lobakin <alobakin@dlink.ru>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2] net: fix a leak in register_netdevice()
Message-ID: <20191203141239.hztnqxtsa67ramsh@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5DE6663F.40803@bfs.de>
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=974
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have to free "dev->name_node" on this error path.

Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
Reported-by: syzbot+6e13e65ffbaa33757bcb@syzkaller.appspotmail.com
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: dev->name_node can't be NULL so we can remove the check for that
    in the cleanup code.

 net/core/dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d75fd04d4e2c..c4ef4d7638ca 100644
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
 
@@ -9361,12 +9361,12 @@ int register_netdevice(struct net_device *dev)
 	return ret;
 
 err_uninit:
-	if (dev->name_node)
-		netdev_name_node_free(dev->name_node);
 	if (dev->netdev_ops->ndo_uninit)
 		dev->netdev_ops->ndo_uninit(dev);
 	if (dev->priv_destructor)
 		dev->priv_destructor(dev);
+err_free_name:
+	netdev_name_node_free(dev->name_node);
 	goto out;
 }
 EXPORT_SYMBOL(register_netdevice);
-- 
2.11.0

