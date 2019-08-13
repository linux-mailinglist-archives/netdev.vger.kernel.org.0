Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D518C083
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbfHMSWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:22:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34418 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfHMSWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:22:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DI905g088246;
        Tue, 13 Aug 2019 18:22:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=qt62rX0U1Kdy3YTjwSb31/PYv3lT70DbEEcqVenwSYI=;
 b=IpnpnjM8rFOLJdX/NM9idQWpKW/Xq6TPr2G/8meZCJvPKYeaU21gNLeHh4ybaOAGTq5V
 VZfLX/z+QeeebjXytaujoh2Tipechi4NDoYfoZWTLSgOJMTdNqBAelr7NK2DjORPPChY
 TaJGdL+fNs/1h0llxCUpafgoYcUPz7dolFbbU9+2i+KsrwNWe7rR18sDdYo7V2GdwX6l
 CF+DW2wgc7MZFBMNYl9E5cDpkWH9ffo2iR0n9iCJ93DWIUwAra1Ixo7I6pBdJwgzm+N0
 p+xkl/V9qySouKINnT/xY2PYon49vLSFCFxQislo/7po+SqWP5TG/q5mt4Fodfs1QB4n QA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u9pjqfxar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 18:22:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DID8oU087626;
        Tue, 13 Aug 2019 18:21:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2ubwrga7jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Aug 2019 18:21:59 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7DILxvf111676;
        Tue, 13 Aug 2019 18:21:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ubwrga7gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 18:21:59 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7DILvZG011602;
        Tue, 13 Aug 2019 18:21:57 GMT
Received: from [10.211.54.53] (/10.211.54.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 11:21:57 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next 5/5] rds: check for excessive looping in
 rds_send_xmit
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <333232d5-311d-ba38-c906-540ef792ab77@oracle.com>
Date:   Tue, 13 Aug 2019 11:21:55 -0700
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

From: Andy Grover <andy.grover@oracle.com>
Date: Thu, 13 Jan 2011 11:40:31 -0800

Original commit from 2011 updated to include a change by
Yuval Shaia <yuval.shaia@oracle.com>
that adds a new statistic counter "send_stuck_rm"
to capture the messages looping exessively
in the send path.

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/rds.h   |  2 +-
 net/rds/send.c  | 12 ++++++++++++
 net/rds/stats.c |  1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/rds/rds.h b/net/rds/rds.h
index f0066d168499..ad605fd61655 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -717,7 +717,7 @@ struct rds_statistics {
 	uint64_t	s_cong_send_blocked;
 	uint64_t	s_recv_bytes_added_to_socket;
 	uint64_t	s_recv_bytes_removed_from_socket;
-
+	uint64_t	s_send_stuck_rm;
 };
 
 /* af_rds.c */
diff --git a/net/rds/send.c b/net/rds/send.c
index 031b1e97a466..9ce552abf9e9 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -145,6 +145,7 @@ int rds_send_xmit(struct rds_conn_path *cp)
 	LIST_HEAD(to_be_dropped);
 	int batch_count;
 	unsigned long send_gen = 0;
+	int same_rm = 0;
 
 restart:
 	batch_count = 0;
@@ -200,6 +201,17 @@ int rds_send_xmit(struct rds_conn_path *cp)
 
 		rm = cp->cp_xmit_rm;
 
+		if (!rm) {
+			same_rm = 0;
+		} else {
+			same_rm++;
+			if (same_rm >= 4096) {
+				rds_stats_inc(s_send_stuck_rm);
+				ret = -EAGAIN;
+				break;
+			}
+		}
+
 		/*
 		 * If between sending messages, we can send a pending congestion
 		 * map update.
diff --git a/net/rds/stats.c b/net/rds/stats.c
index 6bbab4d74c4f..9e87da43c004 100644
--- a/net/rds/stats.c
+++ b/net/rds/stats.c
@@ -78,6 +78,7 @@ static const char *const rds_stat_names[] = {
 	"cong_send_blocked",
 	"recv_bytes_added_to_sock",
 	"recv_bytes_freed_fromsock",
+	"send_stuck_rm",
 };
 
 void rds_stats_info_copy(struct rds_info_iterator *iter,
-- 
2.22.0

