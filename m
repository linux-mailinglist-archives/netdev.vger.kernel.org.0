Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB72133B52
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 06:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgAHFmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 00:42:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50044 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgAHFmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 00:42:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0085fKJD080645;
        Wed, 8 Jan 2020 05:42:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=ru+zq87r3mP5PnyR7+LoroHJbeqirZP2eV58W5CxK84=;
 b=YnNgwHS7zIgVa7s0k8ioS7rByIxZrIhdnSgSn8bCI2Gzrfr05Yo6L9wi2dSL9jhk9TY6
 oevnsCI1Bawfz3PRYsSaVkyCZczAw6M6B6sFILwPF9ERMiAZuehfXSzqRJAYtH34WZER
 9CM+8Bcdn9xYjNdwZBQH3mIJ+qrTIwwAlOexgNBv+VaNFUZTk57+3eaTgqL3T501izBx
 55kmCcTqpflu+b25boGYJHq3Qd3qa8wHQzsdNMApz3CfPL01UJvmcgu0OIiCC0kTIyx4
 Yr7/MQykJqeoxcQWXWGMU/28KXMkhxqJ2OfnzJYqqqCRtScGVCnMXMrBeBAEe5aIOO2D 4Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xajnq1nj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 05:42:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0085faMk078579;
        Wed, 8 Jan 2020 05:42:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xcpap3hak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 05:42:44 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0085ghBD026417;
        Wed, 8 Jan 2020 05:42:43 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 21:42:42 -0800
Date:   Wed, 8 Jan 2020 08:42:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ethtool: potential NULL dereference in strset_prepare_data()
Message-ID: <20200108054236.ult5qxiiwpw2wamk@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=882
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=948 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch complains that the NULL checking isn't done consistently:

    net/ethtool/strset.c:253 strset_prepare_data()
    error: we previously assumed 'dev' could be null (see line 233)

It looks like there is a missing return on this path.

Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/ethtool/strset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 9f2243329015..82a059c13c1c 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -239,6 +239,7 @@ static int strset_prepare_data(const struct ethnl_req_info *req_base,
 				return -EINVAL;
 			}
 		}
+		return 0;
 	}
 
 	ret = ethnl_ops_begin(dev);
-- 
2.11.0

