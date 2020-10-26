Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47D32987B6
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 09:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771140AbgJZIDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 04:03:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41208 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1771134AbgJZIDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 04:03:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09Q7xRQa078254;
        Mon, 26 Oct 2020 08:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=pr6obRTulTqTkO89FKUl+xovWsO+pV4oCRsFFUTxBXI=;
 b=NgiDkBosaS21YxaWba3QHDQlw9ZqHJJwpAP/M9Ue4VWxCRtD57sDE6aUtizROF59plWs
 LVmiUAdMTnZl0Z8pU3tg9QQSpIgraFmvG7QdNrKg8FqkYO1pKoQmoG1DK+JPXCcsoliK
 T2Zhl1kAxcVc+w6Y02HWnfB0FaamdfAA9k8X17hczdGy8KO/2e/XsrVsGynbEJMsFQCN
 h8GS0aKWrhlE69Q17UDxe2BA2AbPL+XTv/+PE824u7PsRsG2BIe1hrG89l7/wKiMFT7n
 1M3KMdjFjMpR2oyDlVr1AlGU/DNJY7B9oDzhVqghW2lLQpMji4AIGBvYF5DI7Wv/43qU XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm3rxxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 08:03:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09Q81GO9050944;
        Mon, 26 Oct 2020 08:01:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34cx6uhveb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 08:01:35 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09Q81Yxs024887;
        Mon, 26 Oct 2020 08:01:34 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 01:01:33 -0700
Date:   Mon, 26 Oct 2020 11:01:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jiri Pirko <jiri@nvidia.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2 net] devlink: Unlock on error in dumpit()
Message-ID: <20201026080127.GB1628785@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026080059.GA1628785@mwanda>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260057
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260057
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This needs to unlock before returning.

Fixes: 544e7c33ec2f ("net: devlink: Add support for port regions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/core/devlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 039f7bd8bf28..8b0e1c318e8d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4919,8 +4919,10 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
 
 		port = devlink_port_get_by_index(devlink, index);
-		if (!port)
-			return -ENODEV;
+		if (!port) {
+			err = -ENODEV;
+			goto out_unlock;
+		}
 	}
 
 	region_name = nla_data(attrs[DEVLINK_ATTR_REGION_NAME]);
-- 
2.28.0

