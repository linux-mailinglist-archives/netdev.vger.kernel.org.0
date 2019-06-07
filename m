Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D23E38C0A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 15:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbfFGN4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 09:56:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45770 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727915AbfFGN4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 09:56:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57Dmpce007694;
        Fri, 7 Jun 2019 13:56:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=wCcpCJJ5E/lKFhkG6QP8lWHon8q7sPH1icP0EYuahQI=;
 b=RYgtjc1td1fg/lpplD81autb7rlF+B8LeyqN63LXpRErJJGcbVBlhJ9lXUNB2OryTGbM
 a8Bdsd2GmWYcKqYJ78NziuLAG9VokNAyKrl5AK/Q+zo7qVC9RlDFNUdM0AooLIXElj8h
 jjcp/JEgheO1pIkRk+jkCerVarehECxpOx+Z6HoH1IpBvhSLGTWvTAkasyn29WJLtj91
 RFqzYT/UsVeeMV7YP5V1i6IHNyajNgRJnbqA0DrlAQB310IHJ0FPCipdareVM+VyoHL5
 PQwSc26RMxZhgBuUrDjvxYywIH33m5+b2gbAtIEIPk8MRZGHNctZWVbWfNjEfGfFJ0Qw JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2suevdxp7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 13:56:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57DubsK012067;
        Fri, 7 Jun 2019 13:56:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2swnhbbbxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 13:56:44 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x57DuhGT024463;
        Fri, 7 Jun 2019 13:56:43 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 06:56:43 -0700
Date:   Fri, 7 Jun 2019 16:56:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH next] nexthop: off by one in nexthop_mpath_select()
Message-ID: <20190607135636.GB16718@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906070098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906070098
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nhg->nh_entries[] array is allocated in nexthop_grp_alloc() and it
has nhg->num_nh elements so this check should be >= instead of >.

Fixes: f88d8ea67fbd ("ipv6: Plumb support for nexthop object in a fib6_info")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
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

