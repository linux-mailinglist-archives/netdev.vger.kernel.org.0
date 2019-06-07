Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C37B238F1B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbfFGPbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:31:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59100 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbfFGPbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 11:31:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57FIl1x087828;
        Fri, 7 Jun 2019 15:31:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : sender
 : to : cc : subject : message-id : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=a3OkgmEzH6gqSwNclMouTxKHku5+xPAshN1b6v2wvBU=;
 b=Se0OGrfEzlE5W2rp8kutTudx+kqD2weKKQCLl+pp2DlatcDldXTCGowFs/+VfaewxQ/O
 ipl3Io88xLJCfpGHtHvLV0kg3STwY282psTb620PJwhDeRQZaAuEJQYFoqLp/Juo6ml0
 EmCkgjIUmIgZM6gi8gSwU0emA+xdjUjAosCE2KbIZfLD0vAuIK47hpn8VcOSXiZgzJbK
 t7yM1tPumj0DEr4D6snZIoINo0dzGiiFRsE0OeP17FIsT5SlGDCZvKCa093geC+qx6eB
 h7iZz1bPSYzSKWvyH3/2Txot4iMZhbgzVO89zw4RYhmeuNdB3ZLly1xhJKj/VBWRkX2V mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2suevdy7hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 15:31:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57FUhCQ145050;
        Fri, 7 Jun 2019 15:31:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2swnhdase8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 15:31:14 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x57FVDC6031482;
        Fri, 7 Jun 2019 15:31:13 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 08:31:13 -0700
Date:   Fri, 7 Jun 2019 18:31:07 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2 next] nexthop: off by one in nexthop_mpath_select()
Message-ID: <20190607153107.GS31203@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e02a744-f28e-e206-032b-a0ffac9f7311@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906070107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906070107
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nhg->nh_entries[] array is allocated in nexthop_grp_alloc() and it
has nhg->num_nh elements so this check should be >= instead of >.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
v2: Use the correct Fixes tag

 include/net/nexthop.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index aff7b2410057..e019ed9b3dc3 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -160,7 +160,7 @@ struct nexthop *nexthop_mpath_select(const struct nexthop *nh, int nhsel)
 	/* for_nexthops macros in fib_semantics.c grabs a pointer to
 	 * the nexthop before checking nhsel
 	 */
-	if (nhsel > nhg->num_nh)
+	if (nhsel >= nhg->num_nh)
 		return NULL;
 
 	return nhg->nh_entries[nhsel].nh;
-- 
2.20.1
