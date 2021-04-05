Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1807353AD0
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 03:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhDEBaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 21:30:08 -0400
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:62916 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231881AbhDEB35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 21:29:57 -0400
Received: from pps.filterd (m0170389.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1351NTG9011182;
        Sun, 4 Apr 2021 21:29:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id; s=smtpout1;
 bh=6OTcpncNHZdbBOeLLaayM6TYpLhol0EpvCCM3G0pG2I=;
 b=LTN/svqq3Zy7pxtSELbD9i5y4wUYod/x6MRZV+6XE2FI4s7xgiNT+VjrJMFaXqhgm3+f
 8hH78DEgqx5RyS5Ht8fHeGQ4fbaJRIyzjw3hhbYtr+6hyXFFM0KCzF5StYFIY34yu3Me
 aiJq6xwt1QvvHX0y7hdryYnZmwyqhiEp9F2H74bg1AoBZzced0tVO7Nz71u9cyriwVda
 J45hLpPwQyVM1CRNYF7lldgpaWdDU5Zu8hM97xVhIZeX733LsNACmIk3xow3wmnDOcc1
 cXmgV9zv1V7D7Ff22javYkxI42fMEApRjCdL83hZCCB8dDyYtM7aBx0z9nT+P0A3nHqo qA== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 37q2n39scb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 04 Apr 2021 21:29:51 -0400
Received: from pps.filterd (m0133268.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1351P5Cr029987;
        Sun, 4 Apr 2021 21:29:51 -0400
Received: from esaploutdur05.us.dell.com ([128.221.233.10])
        by mx0a-00154901.pphosted.com with ESMTP id 37q5yx8eyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 04 Apr 2021 21:29:51 -0400
X-PREM-Routing: D-Outbound
X-LoopCount0: from 10.244.196.237
Received: from hopcyc-dionc-1-01.cec.lab.emc.com ([10.244.196.237])
  by esaploutdur05.us.dell.com with ESMTP; 04 Apr 2021 20:29:49 -0500
From:   Chris Dion <Christopher.Dion@dell.com>
To:     linux-nfs@vger.kernel.org
Cc:     trond.myklebust@hammerspace.com,
        Chris Dion <Christopher.Dion@dell.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] SUNRPC: Handle major timeout in xprt_adjust_timeout()
Date:   Sun,  4 Apr 2021 21:29:26 -0400
Message-Id: <20210405012926.20746-1-Christopher.Dion@dell.com>
X-Mailer: git-send-email 2.18.2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-05_01:2021-04-01,2021-04-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 phishscore=0 adultscore=0 clxscore=1011 priorityscore=1501 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104050006
X-Proofpoint-GUID: K4YQ6utG77hKBAzHeDatoLkt_dESbi0_
X-Proofpoint-ORIG-GUID: K4YQ6utG77hKBAzHeDatoLkt_dESbi0_
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104050006
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently if a major timeout value is reached, but the minor value has
not been reached, an ETIMEOUT will not be sent back to the caller.
This can occur if the v4 server is not responding to requests and
retrans is configured larger than the default of two.

For example, A TCP mount with a configured timeout value of 50 and a
retransmission count of 3 to a v4 server which is not responding:

1. Initial value and increment set to 5s, maxval set to 20s, retries at 3
2. Major timeout is set to 20s, minor timeout set to 5s initially
3. xport_adjust_timeout() is called after 5s, retry with 10s timeout,
   minor timeout is bumped to 10s
4. And again after another 10s, 15s total time with minor timeout set
   to 15s
5. After 20s total time xport_adjust_timeout is called as major timeout is
   reached, but skipped because the minor timeout is not reached
       - After this time the cpu spins continually calling
       	 xport_adjust_timeout() and returning 0 for 10 seconds.
	 As seen on perf sched:
   	 39243.913182 [0005]  mount.nfs[3794] 4607.938      0.017   9746.863
6. This continues until the 15s minor timeout condition is reached (in
   this case for 10 seconds). After which the ETIMEOUT is processed
   back to the caller, the cpu spinning stops, and normal operations
   continue

Fixes: 7de62bc09fe6 ("SUNRPC dont update timeout value on connection reset")
Signed-off-by: Chris Dion <Christopher.Dion@dell.com>
---
Hello,

We recently have noticed an issue where we see a cpu spinning for a few
seconds at a time bouncing between xprt_adjust_timeout() and call_connect().
This is ocurring with an v4 client mounting a non-responsive server with a
low timeout and retransmissions set. In this case if the major timeout is
not serviced there appears to be a spin/bouncing between these functions
until such timeout is returned. It made sense to service the major timeout
in this scenario.  I am not clear on the implications on the original
implementation here but I will submit for your review.

Regards,
Chris

 net/sunrpc/xprt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 691ccf8049a4..7fe975c1000a 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -698,9 +698,9 @@ int xprt_adjust_timeout(struct rpc_rqst *req)
 	const struct rpc_timeout *to = req->rq_task->tk_client->cl_timeout;
 	int status = 0;
 
-	if (time_before(jiffies, req->rq_minortimeo))
-		return status;
 	if (time_before(jiffies, req->rq_majortimeo)) {
+		if (time_before(jiffies, req->rq_minortimeo))
+			return status;
 		if (to->to_exponential)
 			req->rq_timeout <<= 1;
 		else
-- 
2.18.2

