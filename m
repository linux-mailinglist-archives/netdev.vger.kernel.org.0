Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF44C640B8
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfGJFdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:33:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49150 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbfGJFdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 01:33:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6A5Svv1016905;
        Wed, 10 Jul 2019 05:33:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=8qj3/+MJCPn4bxNsFTpMRTpIAWn6rJwe2q2OpGI6P7I=;
 b=YL3+5PGxACIvrJClE7VeFI51hG1PAMlzLxOL6YcPlIyTZeF/FreoWxf0sch1xhO4IZtf
 vDlj7VbweZFiAcpkxVedg+IuXKKHwI5bBJhmJI98j/hIxeUpbStlYGi/LLyeUMNfMMBd
 Q49dPKipcpPEY/MAWjTaNksR+kIjD6KwSoRtx2F+fueYXp7Y576VCbLRCKVgvsoEG9ot
 nTxq2c5HZT+smE+75s0VPtv58kb8hgGEhOLu1E8PKjjXSgNMJ+lSodemim1xt/+U9OD5
 dVOPl+gh3vXMh6OsmfLpVTYd+ah+MTXiQnZskCVajtgLKr5sVRS/KSmTozoC748exmz9 hQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tjk2tqxf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 05:33:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6A5WvSe026382;
        Wed, 10 Jul 2019 05:33:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tjjym69f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 05:33:09 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6A5X8CC009419;
        Wed, 10 Jul 2019 05:33:08 GMT
Received: from localhost.localdomain (/10.159.154.151)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 22:33:08 -0700
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     santosh.shilimkar@oracle.com
Subject: [net][PATCH 3/5] rds: Accept peer connection reject messages due to incompatible version
Date:   Tue,  9 Jul 2019 22:32:42 -0700
Message-Id: <1562736764-31752-4-git-send-email-santosh.shilimkar@oracle.com>
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

From: Gerd Rausch <gerd.rausch@oracle.com>

Prior to
commit d021fabf525ff ("rds: rdma: add consumer reject")

function "rds_rdma_cm_event_handler_cmn" would always honor a rejected
connection attempt by issuing a "rds_conn_drop".

The commit mentioned above added a "break", eliminating
the "fallthrough" case and made the "rds_conn_drop" rather conditional:

Now it only happens if a "consumer defined" reject (i.e. "rdma_reject")
carries an integer-value of "1" inside "private_data":

  if (!conn)
    break;
    err = (int *)rdma_consumer_reject_data(cm_id, event, &len);
    if (!err || (err && ((*err) == RDS_RDMA_REJ_INCOMPAT))) {
      pr_warn("RDS/RDMA: conn <%pI6c, %pI6c> rejected, dropping connection\n",
              &conn->c_laddr, &conn->c_faddr);
              conn->c_proposed_version = RDS_PROTOCOL_COMPAT_VERSION;
              rds_conn_drop(conn);
    }
    rdsdebug("Connection rejected: %s\n",
             rdma_reject_msg(cm_id, event->status));
    break;
    /* FALLTHROUGH */
A number of issues are worth mentioning here:
   #1) Previous versions of the RDS code simply rejected a connection
       by calling "rdma_reject(cm_id, NULL, 0);"
       So the value of the payload in "private_data" will not be "1",
       but "0".

   #2) Now the code has become dependent on host byte order and sizing.
       If one peer is big-endian, the other is little-endian,
       or there's a difference in sizeof(int) (e.g. ILP64 vs LP64),
       the *err check does not work as intended.

   #3) There is no check for "len" to see if the data behind *err is even valid.
       Luckily, it appears that the "rdma_reject(cm_id, NULL, 0)" will always
       carry 148 bytes of zeroized payload.
       But that should probably not be relied upon here.

   #4) With the added "break;",
       we might as well drop the misleading "/* FALLTHROUGH */" comment.

This commit does _not_ address issue #2, as the sender would have to
agree on a byte order as well.

Here is the sequence of messages in this observed error-scenario:
   Host-A is pre-QoS changes (excluding the commit mentioned above)
   Host-B is post-QoS changes (including the commit mentioned above)

   #1 Host-B
      issues a connection request via function "rds_conn_path_transition"
      connection state transitions to "RDS_CONN_CONNECTING"

   #2 Host-A
      rejects the incompatible connection request (from #1)
      It does so by calling "rdma_reject(cm_id, NULL, 0);"

   #3 Host-B
      receives an "RDMA_CM_EVENT_REJECTED" event (from #2)
      But since the code is changed in the way described above,
      it won't drop the connection here, simply because "*err == 0".

   #4 Host-A
      issues a connection request

   #5 Host-B
      receives an "RDMA_CM_EVENT_CONNECT_REQUEST" event
      and ends up calling "rds_ib_cm_handle_connect".
      But since the state is already in "RDS_CONN_CONNECTING"
      (as of #1) it will end up issuing a "rdma_reject" without
      dropping the connection:
         if (rds_conn_state(conn) == RDS_CONN_CONNECTING) {
             /* Wait and see - our connect may still be succeeding */
             rds_ib_stats_inc(s_ib_connect_raced);
         }
         goto out;

   #6 Host-A
      receives an "RDMA_CM_EVENT_REJECTED" event (from #5),
      drops the connection and tries again (goto #4) until it gives up.

Tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
---
 net/rds/rdma_transport.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 46bce83..9db455d 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -112,7 +112,9 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 		if (!conn)
 			break;
 		err = (int *)rdma_consumer_reject_data(cm_id, event, &len);
-		if (!err || (err && ((*err) == RDS_RDMA_REJ_INCOMPAT))) {
+		if (!err ||
+		    (err && len >= sizeof(*err) &&
+		     ((*err) <= RDS_RDMA_REJ_INCOMPAT))) {
 			pr_warn("RDS/RDMA: conn <%pI6c, %pI6c> rejected, dropping connection\n",
 				&conn->c_laddr, &conn->c_faddr);
 			conn->c_proposed_version = RDS_PROTOCOL_COMPAT_VERSION;
@@ -122,7 +124,6 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 		rdsdebug("Connection rejected: %s\n",
 			 rdma_reject_msg(cm_id, event->status));
 		break;
-		/* FALLTHROUGH */
 	case RDMA_CM_EVENT_ADDR_ERROR:
 	case RDMA_CM_EVENT_ROUTE_ERROR:
 	case RDMA_CM_EVENT_CONNECT_ERROR:
-- 
1.9.1

