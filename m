Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A95AC640B9
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfGJFdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:33:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42922 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbfGJFdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 01:33:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6A5SXOT028961;
        Wed, 10 Jul 2019 05:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=H+rWN670hlGoEtpZkFCMuPem8Qs5xZ/ECDfvutwW7y4=;
 b=AA1DzF0R/4vUc8+pyL4tGK/h09hQO7CAIL7LRgPgu2mGvsONn9UyMdmgRRR1uXT/GXlK
 SgB6GalfosaYs+DAQpqlbqOhtowBmYV+G4d/h/C+2VjIcBIAmbRzoq6iBZcdf3syhFO9
 1aN/S1nIRBceUNx1ROPalQ+A8VouLHoQ1ps5Eqa7RcE3k1ouk4ulpqWQJWX/hbKT4EVM
 nv5UMPSrJXSvPdR8XccMn96HywF6jKulGcmXzTqzd94bLChuK6Kc3rGEE47aPdymUBgU
 kXPz9OL2/7xp3LEhM28wteEmdaE1SIKdfIvtI7YdvRBRhBD4Vf8ypejaP/AhDTXIplC9 XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tjm9qqvaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 05:33:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6A5X3mn083909;
        Wed, 10 Jul 2019 05:33:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2tmwgx9yat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 05:33:09 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6A5X8fK016461;
        Wed, 10 Jul 2019 05:33:08 GMT
Received: from localhost.localdomain (/10.159.154.151)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 22:33:08 -0700
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     santosh.shilimkar@oracle.com
Subject: [net][PATCH 5/5] rds: avoid version downgrade to legitimate newer peer connections
Date:   Tue,  9 Jul 2019 22:32:44 -0700
Message-Id: <1562736764-31752-6-git-send-email-santosh.shilimkar@oracle.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1562736764-31752-1-git-send-email-santosh.shilimkar@oracle.com>
References: <1562736764-31752-1-git-send-email-santosh.shilimkar@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907100067
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Connections with legitimate tos values can get into usual connection
race. It can result in consumer reject. We don't want tos value or
protocol version to be demoted for such connections otherwise
piers would end up different tos values which can results in
no connection. Example a peer initiated connection with say
tos 8 while usual connection racing can get downgraded to tos 0
which is not desirable.

Patch fixes above issue introduced by commit
commit d021fabf525f ("rds: rdma: add consumer reject")

Reported-by: Yanjun Zhu <yanjun.zhu@oracle.com>
Tested-by: Yanjun Zhu <yanjun.zhu@oracle.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
---
 net/rds/rdma_transport.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 9db455d..ff74c4b 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -117,8 +117,10 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 		     ((*err) <= RDS_RDMA_REJ_INCOMPAT))) {
 			pr_warn("RDS/RDMA: conn <%pI6c, %pI6c> rejected, dropping connection\n",
 				&conn->c_laddr, &conn->c_faddr);
-			conn->c_proposed_version = RDS_PROTOCOL_COMPAT_VERSION;
-			conn->c_tos = 0;
+
+			if (!conn->c_tos)
+				conn->c_proposed_version = RDS_PROTOCOL_COMPAT_VERSION;
+
 			rds_conn_drop(conn);
 		}
 		rdsdebug("Connection rejected: %s\n",
-- 
1.9.1

