Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55674D0914
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbfJIIFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:05:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25814 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729320AbfJIIFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:05:02 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9982xaY120199
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 04:05:01 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vhbewrj2v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 04:05:01 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Wed, 9 Oct 2019 09:04:59 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 9 Oct 2019 09:04:56 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9984PKT17105396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Oct 2019 08:04:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC75D11C050;
        Wed,  9 Oct 2019 08:04:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACEF311C04A;
        Wed,  9 Oct 2019 08:04:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Oct 2019 08:04:54 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 3/3] net/smc: receive pending data after RCV_SHUTDOWN
Date:   Wed,  9 Oct 2019 10:04:41 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009080441.76077-1-kgraul@linux.ibm.com>
References: <20191009080441.76077-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19100908-0020-0000-0000-000003775F16
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100908-0021-0000-0000-000021CD6438
Message-Id: <20191009080441.76077-4-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=853 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910090076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smc_rx_recvmsg() first checks if data is available, and then if
RCV_SHUTDOWN is set. There is a race when smc_cdc_msg_recv_action() runs
in between these 2 checks, receives data and sets RCV_SHUTDOWN.
In that case smc_rx_recvmsg() would return from receive without to
process the available data.
Fix that with a final check for data available if RCV_SHUTDOWN is set.
Move the check for data into a function and call it twice.
And use the existing helper smc_rx_data_available().

Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_rx.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 000002642288..97e8369002d7 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -261,6 +261,18 @@ static int smc_rx_recv_urg(struct smc_sock *smc, struct msghdr *msg, int len,
 	return -EAGAIN;
 }
 
+static bool smc_rx_recvmsg_data_available(struct smc_sock *smc)
+{
+	struct smc_connection *conn = &smc->conn;
+
+	if (smc_rx_data_available(conn))
+		return true;
+	else if (conn->urg_state == SMC_URG_VALID)
+		/* we received a single urgent Byte - skip */
+		smc_rx_update_cons(smc, 0);
+	return false;
+}
+
 /* smc_rx_recvmsg - receive data from RMBE
  * @msg:	copy data to receive buffer
  * @pipe:	copy data to pipe if set - indicates splice() call
@@ -302,15 +314,18 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 		if (read_done >= target || (pipe && read_done))
 			break;
 
-		if (atomic_read(&conn->bytes_to_rcv))
+		if (smc_rx_recvmsg_data_available(smc))
 			goto copy;
-		else if (conn->urg_state == SMC_URG_VALID)
-			/* we received a single urgent Byte - skip */
-			smc_rx_update_cons(smc, 0);
 
 		if (sk->sk_shutdown & RCV_SHUTDOWN ||
-		    conn->local_tx_ctrl.conn_state_flags.peer_conn_abort)
+		    conn->local_tx_ctrl.conn_state_flags.peer_conn_abort) {
+			/* smc_cdc_msg_recv_action() could have run after
+			 * above smc_rx_recvmsg_data_available()
+			 */
+			if (smc_rx_recvmsg_data_available(smc))
+				goto copy;
 			break;
+		}
 
 		if (read_done) {
 			if (sk->sk_err ||
-- 
2.17.1

