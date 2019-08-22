Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85436989C4
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 05:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbfHVDSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 23:18:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfHVDSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 23:18:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7M34EnO176121;
        Thu, 22 Aug 2019 03:18:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=TEN9J0TVzIO5lpwlqcWXDsPUaydj7RNQXaL/LZUbb58=;
 b=QTV+penf9GvgAN4beZnuTLUAxyUOsqnu8agMyR69Nu+6VNDwb97v0WUREnpJfzMCy+QQ
 Ktp9/eYo6kfZk9muVbe+qQSpiKkD+UpL3veyaDSh563bEr7IARpZUhhvSOutTnD9PVK3
 24QNyay5r1JFcFs5lG4hwdNgPgh2BTvTbgT8q6yUey9x3x7S2aChii9aCCfbG8pboPyb
 zvjqpjU/DzgjVIRBT/bvro+GuRCoACoABEPvmwlwOG438BleZtpWD1YttC9dYKY6F/IR
 pBP1uHRg3LT0os5dSCpmZP9oWy2PfT2KoCFkfFWRv+gf7HlIENHvTWQWQRATqgtIzQNE lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ue90tt6wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 03:18:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7M38Mfo106175;
        Thu, 22 Aug 2019 03:18:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2ugj7r4smj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Aug 2019 03:18:29 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7M3ISI3131996;
        Thu, 22 Aug 2019 03:18:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ugj7r4smc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 03:18:28 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7M3IRxP019494;
        Thu, 22 Aug 2019 03:18:27 GMT
Received: from ca-dev40.us.oracle.com (/10.129.135.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Aug 2019 20:18:27 -0700
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        rds-devel@oss.oracle.com
Subject: [PATCH net-next] net/rds: Fix info leak in rds6_inc_info_copy()
Date:   Wed, 21 Aug 2019 20:18:24 -0700
Message-Id: <1566443904-12671-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=904 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908220031
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rds6_inc_info_copy() function has a couple struct members which
are leaking stack information.  The ->tos field should hold actual
information and the ->flags field needs to be zeroed out.

Fixes: 3eb450367d08 ("rds: add type of service(tos) infrastructure")
Fixes: b7ff8b1036f0 ("rds: Extend RDS API for IPv6 support")
Reported-by: 黄ID蝴蝶 <butterflyhuangxx@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
---
 net/rds/recv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index 853de48..a42ba7f 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006, 2018 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2006, 2019 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -811,6 +811,7 @@ void rds6_inc_info_copy(struct rds_incoming *inc,
 
 	minfo6.seq = be64_to_cpu(inc->i_hdr.h_sequence);
 	minfo6.len = be32_to_cpu(inc->i_hdr.h_len);
+	minfo6.tos = inc->i_conn->c_tos;
 
 	if (flip) {
 		minfo6.laddr = *daddr;
@@ -824,6 +825,8 @@ void rds6_inc_info_copy(struct rds_incoming *inc,
 		minfo6.fport = inc->i_hdr.h_dport;
 	}
 
+	minfo6.flags = 0;
+
 	rds_info_copy(iter, &minfo6, sizeof(minfo6));
 }
 #endif
-- 
1.8.3.1

