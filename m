Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26FE2987B3
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 09:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770124AbgJZIDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 04:03:19 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50296 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1420919AbgJZIDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 04:03:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09Q7xDRw014587;
        Mon, 26 Oct 2020 08:03:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=EheQS8UO6+RT/KlClPEQ3VjXl8/wgs76dkBjtyvB5os=;
 b=PjifR63nolAKTVq4R+0vK2EvdvcMx3Y59/bMLxe0GQGr5ee50gfRCmNKYytlNgkzceRd
 XrQ8Dt1XBpMsxJrFs/STQ4WN0B6fxM0iOEDT9/KDLJv7tHzcplR22+xrseTcMb9GANrX
 FPlXRBV73APey+kuoC4UwA1SBN13tDRRhYeZsljsRZWwO1nDKH/keAI9+10DSlC78iZQ
 pGleFQTvWiy3gCStFeP6z9wrPabAYUKEwCfavyLvdBQPoWd/Z1NtFxUbqxD+sqNzYIKL
 4DEn9/SdymBF0pFFkAOv8ToeW6r0ZeQ/7L3GbIZGOIt25fPdpB93Juo2eIj+xackZVVx cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sakgf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 08:03:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09Q80DGB176396;
        Mon, 26 Oct 2020 08:01:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1pa022-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 08:01:08 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09Q8166a027674;
        Mon, 26 Oct 2020 08:01:06 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 01:01:05 -0700
Date:   Mon, 26 Oct 2020 11:00:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jiri Pirko <jiri@nvidia.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2 net] devlink: Fix some error codes
Message-ID: <20201026080059.GA1628785@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260057
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1011 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260057
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These paths don't set the error codes.  It's especially important in
devlink_nl_region_notify_build() where it leads to a NULL dereference in
the caller.

Fixes: 544e7c33ec2f ("net: devlink: Add support for port regions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/core/devlink.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index a578634052a3..925da7c0fcf3 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4213,10 +4213,12 @@ static int devlink_nl_region_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto nla_put_failure;
 
-	if (region->port)
-		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX,
-				region->port->index))
+	if (region->port) {
+		err = nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX,
+				  region->port->index);
+		if (err)
 			goto nla_put_failure;
+	}
 
 	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME, region->ops->name);
 	if (err)
@@ -4265,10 +4267,12 @@ devlink_nl_region_notify_build(struct devlink_region *region,
 	if (err)
 		goto out_cancel_msg;
 
-	if (region->port)
-		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX,
-				region->port->index))
+	if (region->port) {
+		err = nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX,
+				  region->port->index);
+		if (err)
 			goto out_cancel_msg;
+	}
 
 	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME,
 			     region->ops->name);
@@ -4962,10 +4966,12 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	if (err)
 		goto nla_put_failure;
 
-	if (region->port)
-		if (nla_put_u32(skb, DEVLINK_ATTR_PORT_INDEX,
-				region->port->index))
+	if (region->port) {
+		err = nla_put_u32(skb, DEVLINK_ATTR_PORT_INDEX,
+				  region->port->index);
+		if (err)
 			goto nla_put_failure;
+	}
 
 	err = nla_put_string(skb, DEVLINK_ATTR_REGION_NAME, region_name);
 	if (err)
-- 
2.28.0

