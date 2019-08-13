Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 805648C071
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbfHMSUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:20:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35142 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbfHMSUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:20:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DI91eh107580;
        Tue, 13 Aug 2019 18:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=oRJkJgrXT76QdvLc1KMWDXURdxrfwV4b+y8f06Jhz3c=;
 b=PDkzw5sse4WJ5Jva5MoYL+oiU24GHpNvkK0nJn5o0+k8rWrYlBjGgz8KbkmWDDj0LOfl
 xpJnACpfv8RtrQxxEkH7id0bI51O0eWay4dUUOhSZ0JwZ2z6b8SFPoy9vfKCSVyZeo4c
 XB9NjbumGH4yCLAs/zf8qIt+1+amyLuAtybeZxgdNdfXqq3vd2nU6IAHYTQAPxJmE2mR
 xd0upp811Q2vZV9+aHFckHTjJvO5aPCLO1879/sVtc3c72CPiLllGfq/AP657ay+35gG
 bcwtl3Gwj3EXfR3P99RQsuejr8etY/rdjXqXu5k9cKQIX4zI7o7Gl8nKXAh0N1kJCbYQ Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u9nvp83mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 18:20:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DIDmOs060674;
        Tue, 13 Aug 2019 18:20:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ubwrrmc5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Aug 2019 18:20:39 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7DIKdhK081374;
        Tue, 13 Aug 2019 18:20:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ubwrrmc57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 18:20:39 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7DIKcZF031613;
        Tue, 13 Aug 2019 18:20:38 GMT
Received: from [10.211.54.53] (/10.211.54.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 11:20:38 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next 2/5] RDS: limit the number of times we loop in
 rds_send_xmit
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <4d04cec6-ef2d-392b-233b-0abf7a57fe44@oracle.com>
Date:   Tue, 13 Aug 2019 11:20:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9348 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mason <chris.mason@oracle.com>
Date: Fri, 3 Feb 2012 11:07:54 -0500

This will kick the RDS worker thread if we have been looping
too long.

Original commit from 2012 updated to include a change by
Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
that triggers "must_wake" if "rds_ib_recv_refill_one" fails.

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/ib_recv.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 3cae88cbdaa0..1a8a4a760b84 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -385,6 +385,7 @@ void rds_ib_recv_refill(struct rds_connection *conn, int prefill, gfp_t gfp)
 	unsigned int posted = 0;
 	int ret = 0;
 	bool can_wait = !!(gfp & __GFP_DIRECT_RECLAIM);
+	bool must_wake = false;
 	u32 pos;
 
 	/* the goal here is to just make sure that someone, somewhere
@@ -405,6 +406,7 @@ void rds_ib_recv_refill(struct rds_connection *conn, int prefill, gfp_t gfp)
 		recv = &ic->i_recvs[pos];
 		ret = rds_ib_recv_refill_one(conn, recv, gfp);
 		if (ret) {
+			must_wake = true;
 			break;
 		}
 
@@ -423,6 +425,11 @@ void rds_ib_recv_refill(struct rds_connection *conn, int prefill, gfp_t gfp)
 		}
 
 		posted++;
+
+		if ((posted > 128 && need_resched()) || posted > 8192) {
+			must_wake = true;
+			break;
+		}
 	}
 
 	/* We're doing flow control - update the window. */
@@ -445,10 +452,13 @@ void rds_ib_recv_refill(struct rds_connection *conn, int prefill, gfp_t gfp)
 	 * if we should requeue.
 	 */
 	if (rds_conn_up(conn) &&
-	    ((can_wait && rds_ib_ring_low(&ic->i_recv_ring)) ||
+	    (must_wake ||
+	    (can_wait && rds_ib_ring_low(&ic->i_recv_ring)) ||
 	    rds_ib_ring_empty(&ic->i_recv_ring))) {
 		queue_delayed_work(rds_wq, &conn->c_recv_w, 1);
 	}
+	if (can_wait)
+		cond_resched();
 }
 
 /*
-- 
2.22.0


