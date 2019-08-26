Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF53E9CCA5
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 11:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfHZJj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 05:39:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40270 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfHZJj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 05:39:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7Q9cdQ7132615;
        Mon, 26 Aug 2019 09:39:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=PJrZg2I/nO98b3Ai0cqDED4pWii9I9dXjdUdSxVk63M=;
 b=E/kXIIi8OsNuqWQi8AUY2n8C64cY3vDIbR8HVoDPw981nb3rPzJXkEeTbUG6Jk0w3Ywa
 T07vIQ/BDZHstzWoj1LBemQKNjfUmiVFKO0TKDDHC0Ux9fuSO1vuki3PcCpQ5v7GzIKM
 qys81h4GOTvKE/o3i1kYoVEBBJA+q7NdOGOqj1kPNKnXfRHjbw/w8jUFqL5CBZ7RMNGV
 FX00tHQrz7Ch1jJxddxRq7d79jBJEOPaOSgOWi+Fzd/N2zOe/oiPyS923f2sAEuoOKO8
 VSLYL4UXIwwFeCAWkJ+1BGr311UwIdEOHK30F5urHUlTe2CXb+yXlugNJGkMQcVKD6uG YQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ujw6yyttm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 09:39:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7Q9brV6185388;
        Mon, 26 Aug 2019 09:39:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ujw6hk3vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Aug 2019 09:39:18 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7Q9dIUM188704;
        Mon, 26 Aug 2019 09:39:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ujw6hk3vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 09:39:18 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7Q9dHxY012100;
        Mon, 26 Aug 2019 09:39:17 GMT
Received: from ca-dev40.us.oracle.com (/10.129.135.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 02:39:17 -0700
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
To:     netdev@vger.kernel.org
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        rds-devel@oss.oracle.com
Subject: [PATCH net] net/rds: Fix info leak in rds6_inc_info_copy()
Date:   Mon, 26 Aug 2019 02:39:12 -0700
Message-Id: <1566812352-27332-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=849 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260106
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
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
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

