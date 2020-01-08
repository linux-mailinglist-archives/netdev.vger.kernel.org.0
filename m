Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37752133B50
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 06:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgAHFlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 00:41:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49256 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgAHFlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 00:41:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0085faYB080715;
        Wed, 8 Jan 2020 05:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=VKnoz3p8SAtFiJKrrQq5C0HQE4Qk07nl5em6ZIpxVAE=;
 b=LcJrFDEgCh38NwgtCSThvsV1y7RawgvOYyIku3TXEV28LYrixFhva1Z8LYAbsxnE/CgQ
 bqzxmFOiYZTMFO2Iukb7IDei9NilY+E1kAFIJQz8R+z8YkAEZK1E1cGpMYleoSsUJ/+c
 zNikyMX1tvgWaBztgkQM1Hg1oAb3/gVk6cUCbhBAhD+NuV9HxQTIieeLtC2maM7EHcLb
 WO1YboRPc0LzNGxon49CFvar8N074DyB9DbOJMkEK+urzSdxHJEM8Ido8yPSCg+F5xWU
 Z7IfXto2YiD1h+8i7nVVunXh327gyU67UqSdW9q7N0HtH0CehbMk7JTdb8dBkuzh5RBQ Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xajnq1ndd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 05:41:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0085fZlK078445;
        Wed, 8 Jan 2020 05:41:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xcpap3fr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 05:41:36 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0085fZA8018735;
        Wed, 8 Jan 2020 05:41:35 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 21:41:34 -0800
Date:   Wed, 8 Jan 2020 08:41:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] ethtool: fix ->reply_size() error handling
Message-ID: <20200108054125.feeckqg6xhab3wam@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "ret < 0" comparison is never true because "ret" is still zero.

Fixes: 728480f12442 ("ethtool: default handlers for GET requests")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/ethtool/netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 5d16436498ac..86b79f9bc08d 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -319,9 +319,10 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 	rtnl_unlock();
 	if (ret < 0)
 		goto err_cleanup;
-	reply_len = ops->reply_size(req_info, reply_data);
+	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
+	reply_len = ret;
 	ret = -ENOMEM;
 	rskb = ethnl_reply_init(reply_len, req_info->dev, ops->reply_cmd,
 				ops->hdr_attr, info, &reply_payload);
@@ -555,9 +556,10 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
 	ret = ops->prepare_data(req_info, reply_data, NULL);
 	if (ret < 0)
 		goto err_cleanup;
-	reply_len = ops->reply_size(req_info, reply_data);
+	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
+	reply_len = ret;
 	ret = -ENOMEM;
 	skb = genlmsg_new(reply_len, GFP_KERNEL);
 	if (!skb)
-- 
2.11.0

