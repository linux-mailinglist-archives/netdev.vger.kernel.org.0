Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2E258EE86
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733098AbfHOOnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:43:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58542 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729838AbfHOOnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:43:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FEVWdN083341;
        Thu, 15 Aug 2019 14:43:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nMsYPMoYmwV5SXmTmk2bacMSb5F8g0yBpO2XL1HPzdc=;
 b=eOgN4SQCD5smuqGpRSaabM1gSFcgFmtjsTC2Zh4ov5ozVCJa5x1JzwblDSBwiBZs77+j
 K0G0vB7i8aezm7owRG2xpC3UcgcWmgR39F53GMACQneCKXPVugqVA9oAG56xX2KhsfIc
 sJPBxRpiexrDrHWpJpqfpRI3xeO4xQDbpzI8iNQAGp2a+JLVRsBltdaQSRCGc1rQ/YdG
 P/iQcDZfmzIntSUAfY/90gWusbUFNiNghYVB6dtn0PPB9y7snz9yJ5HOexYS3Gf1QVym
 1DE0IiMc1NsqqWTvUmWOi4n3IzHlcrp9iD6mfxtZTnPrrtySeAWbhDfqtbfvJMo1LwkF sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbtu4r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 14:43:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FEXa9D172227;
        Thu, 15 Aug 2019 14:43:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ucgf1325c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 14:43:20 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7FEhKuP003067;
        Thu, 15 Aug 2019 14:43:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ucgf1324t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 14:43:20 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7FEhJRe025300;
        Thu, 15 Aug 2019 14:43:19 GMT
Received: from [10.159.252.166] (/10.159.252.166)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 07:43:19 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next v2 4/4] rds: check for excessive looping in
 rds_send_xmit
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <20190814.212525.326606319186601317.davem@davemloft.net>
 <cover.1565879451.git.gerd.rausch@oracle.com>
Message-ID: <d91e3273-48bb-13bf-af65-40472890f975@oracle.com>
Date:   Thu, 15 Aug 2019 07:43:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1565879451.git.gerd.rausch@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150148
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
2.22.1

