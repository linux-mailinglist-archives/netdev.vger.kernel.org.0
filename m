Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC9EEB14E
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 14:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfJaNgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 09:36:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35154 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbfJaNgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 09:36:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9VDYCwY137785;
        Thu, 31 Oct 2019 13:36:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=IxCYNjjZ1IvULQfBfGORGMeo74pUAoobKaMQUOAnRYk=;
 b=msPxw321i7nZR6v5Ouw+0czDdze8cAwLCV07gl/uUZGxJOizphgnbwkckFjzcCA/owpz
 WVSPKVtW3H2cmgLJfL+fcN3TH6jyipFmxn1i9rhdQGQR+RTimbl7sF2qExWz9cpJFrDq
 Y3qukuSP6N3L6QGmJvrm+ugAgcoxRyV4D7U0T7LuW0etgYQCo4pvCYqx9YjuBvQR3Y4D
 yTev8IB19XGlOcvM1JdB4/A5Gdz9cLYnqxy4rXzF+Gsi1kJFxe+fxzhLIJDrZTjHH4Wr
 SbbJUDGyVI/isEU/Gap3nxHm7E6g8t/F7w5FO2bpmyTczN8dERYZMWGVOkkoG2WyZpOi MA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vxwhfu9at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 13:36:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9VDY6r9190805;
        Thu, 31 Oct 2019 13:36:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2vysbu8tw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 31 Oct 2019 13:36:05 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x9VDYFNX191691;
        Thu, 31 Oct 2019 13:36:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vysbu8tv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 13:36:05 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9VDa3ut009379;
        Thu, 31 Oct 2019 13:36:03 GMT
Received: from dm-oel.no.oracle.com (/10.172.157.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Oct 2019 06:36:03 -0700
From:   Dag Moxnes <dag.moxnes@oracle.com>
To:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     davem@davemloft.net, dag.moxnes@oracle.com, haakon.bugge@oracle.com
Subject: [PATCH net-next] rds: Cancel pending connections on connection request
Date:   Thu, 31 Oct 2019 14:35:56 +0100
Message-Id: <1572528956-8504-1-git-send-email-dag.moxnes@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910310141
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RDS connections can enter the RDS_CONN_CONNECTING state in two ways:
1. It can be started using the connection workqueue (this can happen
both on queue_reconnect and upon send if the workqueue is not up)
2. It can enter the RDS_CONN_CONNECTING state due to an incoming
connection request

In case RDS connections enter RDS_CONN_CONNECTION state due to an incoming
connection request, the connection workqueue might already be scheduled. In
this case the connection workqueue needs to be cancelled.

Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
---
 net/rds/ib_cm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 6b345c858d..1fdd76f70d 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -880,6 +880,12 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
 			rds_ib_stats_inc(s_ib_connect_raced);
 		}
 		goto out;
+	} else {
+		/* Cancel any pending reconnect */
+		struct rds_conn_path *cp = &conn->c_path[0];
+
+		cancel_delayed_work_sync(&cp->cp_conn_w);
+		rds_clear_reconnect_pending_work_bit(cp);
 	}
 
 	ic = conn->c_transport_data;
-- 
2.20.1

