Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE941ED5A
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 01:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbfD2Xhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 19:37:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58932 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729063AbfD2Xhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 19:37:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3TNZEnR189994;
        Mon, 29 Apr 2019 23:37:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=mD1Is/O3MiRW3O/EUNcHOv5j5rXcN7oJuM4O+nRBzdY=;
 b=yFnYsmljRry7Gtfn4CqZr8nA3S/UI7u8EQZt3QW1QmYMyn3vO/8exhsia8DNbKRtajTR
 0LIGT1fEgoTP+n0FHydeZo7YTPxFh2aLxN6cmSTy0omD3P7AbBsq37GoEEauaj0325Q7
 RgpmQ1K93IcYlP9MJKxrzzUK03U1wPj+G/CnY1YQwhFkWTLRTL1+eP0ErTiooX/LzkIF
 z6NkdbBCFm8M6y2QnE5LhMGxCwXkQNKwAGuVSkIAbLqXLME2dHMonnsjK7M0QDh+fq1J
 MWIUQU8S/EDu3VhraPf6f+FP697p2hJKiNJwp/U9RFSRjd2VslGlpYC3GrZ8FLNkPf5w XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2s4fqq1aup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 23:37:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3TNbYNe153501;
        Mon, 29 Apr 2019 23:37:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2s4yy97wbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 23:37:33 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3TNbQsi014498;
        Mon, 29 Apr 2019 23:37:26 GMT
Received: from userv0022.oracle.com (/10.11.38.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Apr 2019 16:37:26 -0700
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     santosh.shilimkar@oracle.com
Subject: [net-next][PATCH v2 1/2] rds: handle unsupported rdma request to fs dax memory
Date:   Mon, 29 Apr 2019 16:37:19 -0700
Message-Id: <1556581040-4812-2-git-send-email-santosh.shilimkar@oracle.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9242 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904290153
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9242 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904290153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>

RDS doesn't support RDMA on memory apertures that require On Demand
Paging (ODP), such as FS DAX memory. User applications can try to use
RDS to perform RDMA over such memories and since it doesn't report any
failure, it can lead to unexpected issues like memory corruption when
a couple of out of sync file system operations like ftruncate etc. are
performed.

The patch adds a check so that such an attempt to RDMA to/from memory
apertures requiring ODP will fail.

Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
---
 net/rds/rdma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 182ab84..e0a6b72 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -158,8 +158,9 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
 {
 	int ret;
 
-	ret = get_user_pages_fast(user_addr, nr_pages, write, pages);
-
+	/* get_user_pages return -EOPNOTSUPP for fs_dax memory */
+	ret = get_user_pages_longterm(user_addr, nr_pages,
+				      write, pages, NULL);
 	if (ret >= 0 && ret < nr_pages) {
 		while (ret--)
 			put_page(pages[ret]);
-- 
1.9.1

