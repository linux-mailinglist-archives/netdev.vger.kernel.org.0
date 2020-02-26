Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDA5170197
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 15:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgBZOwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 09:52:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52560 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbgBZOwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 09:52:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QEmljx075990;
        Wed, 26 Feb 2020 14:52:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=46vlA6mOu0BbkXPWXMQoRuLsu6ysXBgjgmhdIarDGNA=;
 b=KB8ZyJaXoSt5CsF94Ghje1RlVhk7SUsN+c6A/vEoMktu37Z8UFKPe8yYbxuMY7mvZhJ9
 maPP5+LFfedg0dT2wVdvzwujcpwPnrEtxJDDeEX2/Edd2QoOD/wbsfMLXGun2HGxN1iL
 qzUH3z4eflN3PfqkPFx2Vy2DB9egdltz2LbgOlSseFE52m/7aM9iAQ+X0d5A82UHTeLD
 r3xjhmmuhRtL9CWMhVg6gk3+GFNTOMZJqdjQZzrgMPkL8P8/mtY40QDSuIA16lC6UCbZ
 WplG2bhb3L0FVh51PZslnljg15padj1iv4RickFVFywgTpizxHqCdlzPY0Nl4M7fu3vO dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ydct342gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 14:52:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QEm5xb029326;
        Wed, 26 Feb 2020 14:52:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ydj4hpj8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 14:52:02 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01QEq0Qn022797;
        Wed, 26 Feb 2020 14:52:00 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 06:52:00 -0800
Date:   Wed, 26 Feb 2020 17:51:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: qrtr: Fix error pointer vs NULL bugs
Message-ID: <20200226145153.a7u2jzhseaipas54@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The callers only expect NULL pointers, so returning an error pointer
will lead to an Oops.

Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/qrtr/ns.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 67a4e59cdf4d..20463cd26e39 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -76,7 +76,7 @@ static struct qrtr_node *node_get(unsigned int node_id)
 	/* If node didn't exist, allocate and insert it to the tree */
 	node = kzalloc(sizeof(*node), GFP_KERNEL);
 	if (!node)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	node->id = node_id;
 
@@ -224,7 +224,7 @@ static struct qrtr_server *server_add(unsigned int service,
 
 	srv = kzalloc(sizeof(*srv), GFP_KERNEL);
 	if (!srv)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	srv->service = service;
 	srv->instance = instance;
-- 
2.11.0

