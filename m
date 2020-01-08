Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED89133B4C
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 06:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgAHFkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 00:40:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59186 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgAHFkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 00:40:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0085Ubu5099173;
        Wed, 8 Jan 2020 05:39:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=HlUcOR7YLkyQHpJxh+kBYY8sqNeg72DZ06z6I4cFIoc=;
 b=PmUTLzKHo4g5IRr5wZ7NzSf3RcmXere73W1PnnKAqmXc4Lp7rokikvPSrKpbfYeVIqzB
 66P0LjA3NdRGhsOQ0IkwquiAQrHEJTqD+wMKAvtpk23m2kYlA4hU3tU8PGSAoImHC8Fo
 WCJqFe5Xrj5A9dNZ/nV3mS83QbV152Q41X8D4m6WqV9LCjZhp56nyhsWNIEvWI8/zC3Y
 nFwKydKX2A149UoI6EixZ/y3WENEdBlQF1wMdYeFDcAHU13FKoFMHsW1QUB67xt1F8rk
 MuTQfrySQZtb3CPuasEgqwWMixCspQhQmbaiiLfr4N+nLG6onpmT+ARL5/kR6kKZWEu4 9Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xaj4u1st3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 05:39:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0085YAs1014353;
        Wed, 8 Jan 2020 05:39:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xcjvet4c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 05:39:57 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0085dtwN013399;
        Wed, 8 Jan 2020 05:39:56 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 21:39:55 -0800
Date:   Wed, 8 Jan 2020 08:39:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] ethtool: fix a memory leak in ethnl_default_start()
Message-ID: <20200108053947.776s3sp3op6v7a6r@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=828
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=888 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080048
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ethnl_default_parse() fails then we need to free a couple
memory allocations before returning.

Fixes: 728480f12442 ("ethtool: default handlers for GET requests")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/ethtool/netlink.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 4ca96c7b86b3..5d16436498ac 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -472,8 +472,8 @@ static int ethnl_default_start(struct netlink_callback *cb)
 		return -ENOMEM;
 	reply_data = kmalloc(ops->reply_data_size, GFP_KERNEL);
 	if (!reply_data) {
-		kfree(req_info);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto free_req_info;
 	}
 
 	ret = ethnl_default_parse(req_info, cb->nlh, sock_net(cb->skb->sk), ops,
@@ -487,7 +487,7 @@ static int ethnl_default_start(struct netlink_callback *cb)
 		req_info->dev = NULL;
 	}
 	if (ret < 0)
-		return ret;
+		goto free_reply_data;
 
 	ctx->ops = ops;
 	ctx->req_info = req_info;
@@ -496,6 +496,13 @@ static int ethnl_default_start(struct netlink_callback *cb)
 	ctx->pos_idx = 0;
 
 	return 0;
+
+free_reply_data:
+	kfree(reply_data);
+free_req_info:
+	kfree(req_info);
+
+	return ret;
 }
 
 /* default ->done() handler for GET requests */
-- 
2.11.0

