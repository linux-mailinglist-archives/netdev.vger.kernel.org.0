Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9838EE7C
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731422AbfHOOmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:42:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56794 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729838AbfHOOmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:42:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FEVVud083322;
        Thu, 15 Aug 2019 14:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QT5Yxfk+gctT48VVnsY//GunQu36dRLAVKJgR21/6w0=;
 b=GFQiDVNHvCCVUb0BlrTTb7eoAuYmG6KS415E0wRBNvxMolmodIrrG+Buj7IEfC1lZwRd
 ww3PlDmlC1bKkPAnnb+QCeKhcV+IYRDWSqY8ZKXFPbKlRrtMQOjhXs8gyn3z2f8v/xHD
 erO3q917mUigRs5jNtzlLLicyTSZTNIrWmw6Zrw5VmBB0H0dx5W1GriYUmbTK/1DQdgL
 DCXeXo4MjDyzX+vE3G+BExSshOVfgww2DWx9ToUfS/1dZCEqqLdSryVJmeIzaWPGLGy+
 wu2EEp7A1BqfsvZ68tEdif3CWMA8zh3na1MK9qALyXXETwBnS3GhMm5jP/j3h69njSoh RQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbtu4h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 14:42:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FEXcH9172427;
        Thu, 15 Aug 2019 14:42:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ucgf130tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 14:42:08 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7FEfrob194638;
        Thu, 15 Aug 2019 14:42:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ucgf130t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 14:42:08 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7FEg7bE003046;
        Thu, 15 Aug 2019 14:42:07 GMT
Received: from [10.159.252.166] (/10.159.252.166)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 07:42:06 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next v2 1/4] RDS: limit the number of times we loop in
 rds_send_xmit
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <20190814.212525.326606319186601317.davem@davemloft.net>
 <cover.1565879451.git.gerd.rausch@oracle.com>
Message-ID: <90b76f24-d799-5362-df53-19102d781e3e@oracle.com>
Date:   Thu, 15 Aug 2019 07:42:03 -0700
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
2.22.1


