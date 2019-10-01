Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAB0C448A
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 01:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbfJAXmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 19:42:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41332 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfJAXme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 19:42:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91Ne0cc152468;
        Tue, 1 Oct 2019 23:42:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=fvc9eGFu4MrRha5H/Nsv16npaJxs0MMW1MZ3LliDhzo=;
 b=QNAXOSBrB7AV2bxnZe07ooEAkfmHAE1/bVwBalgmBJZ3/cAFgkH9fPdvl6fWYpJYBs36
 ZRjVfTwIfoK7w5xFo9rwQaKv7KjYLHwkeQrZHLsJAZOXFGLs7jf6Dj9iL/VcPdMjv88D
 8HK54J6HM4q/vjg3Y/l6RfE8kyQDdcoYkaMVZFaBkvXDL9g8bRQl1tg6lIeWroQGyCcV
 mVLjh+SCF/KpllW9I26ZYIh20NLRCMuLuiqmXVeu9gmSr+q+fGJ3sR72VkvoiPaipxrm
 nNgwsGLJtUXeCnq+AFcWbO8iT0Bx3HvV0jhSP+FW1N3/DgqJLZB9jEh4OuPDWRFmYrdO hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v9yfq9jbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 23:42:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91NchPk056929;
        Tue, 1 Oct 2019 23:42:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2vc9dj7v1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Oct 2019 23:42:31 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x91NgUUb064896;
        Tue, 1 Oct 2019 23:42:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vc9dj7v17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 23:42:30 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x91NgUp5008720;
        Tue, 1 Oct 2019 23:42:30 GMT
Received: from ca-dev92.us.oracle.com (/10.129.135.31)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 16:42:29 -0700
From:   Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        santosh.shilimkar@oracle.com, rds-devel@oss.oracle.com
Cc:     Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>
Subject: [PATCH net-next v2] net/rds: Log vendor error if send/recv Work requests fail
Date:   Tue,  1 Oct 2019 16:33:14 -0700
Message-Id: <1569972794-47390-1-git-send-email-sudhakar.dindukurti@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010202
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Log vendor error if work requests fail. Vendor error provides
more information that is used for debugging the issue.

Signed-off-by: Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

---
 net/rds/ib_recv.c | 5 +++--
 net/rds/ib_send.c | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 3cae88c..e668bac 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -983,10 +983,11 @@ void rds_ib_recv_cqe_handler(struct rds_ib_connection *ic,
 	} else {
 		/* We expect errors as the qp is drained during shutdown */
 		if (rds_conn_up(conn) || rds_conn_connecting(conn))
-			rds_ib_conn_error(conn, "recv completion on <%pI6c,%pI6c, %d> had status %u (%s), disconnecting and reconnecting\n",
+			rds_ib_conn_error(conn, "recv completion on <%pI6c,%pI6c, %d> had status %u (%s), vendor err 0x%x, disconnecting and reconnecting\n",
 					  &conn->c_laddr, &conn->c_faddr,
 					  conn->c_tos, wc->status,
-					  ib_wc_status_msg(wc->status));
+					  ib_wc_status_msg(wc->status),
+					  wc->vendor_err);
 	}
 
 	/* rds_ib_process_recv() doesn't always consume the frag, and
diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index dfe6237..102c5c5 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -300,10 +300,10 @@ void rds_ib_send_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 
 	/* We expect errors as the qp is drained during shutdown */
 	if (wc->status != IB_WC_SUCCESS && rds_conn_up(conn)) {
-		rds_ib_conn_error(conn, "send completion on <%pI6c,%pI6c,%d> had status %u (%s), disconnecting and reconnecting\n",
+		rds_ib_conn_error(conn, "send completion on <%pI6c,%pI6c,%d> had status %u (%s), vendor err 0x%x, disconnecting and reconnecting\n",
 				  &conn->c_laddr, &conn->c_faddr,
 				  conn->c_tos, wc->status,
-				  ib_wc_status_msg(wc->status));
+				  ib_wc_status_msg(wc->status), wc->vendor_err);
 	}
 }
 
-- 
1.8.3.1

