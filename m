Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0325C150
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbfGAQkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:40:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50712 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727671AbfGAQkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:40:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GY00V171859;
        Mon, 1 Jul 2019 16:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=ic/dRTfD7Gk/cZTRzvHfmZOvKTqSeGZarbpvRfaOYmQ=;
 b=bGBonY8TiN5Eocrafv92ShL1sbPgj7EFTy9D5h67A/UInpsb+76nsFDVNpY9Xh3aGgKX
 3eHvrKEd2z3kng/XPXROpojbCp+wO7Zz0hgqX4EkiCbLqZ48qLR5yI17CCFCgjwQL1B9
 nplek1VRKXiZTZ78mAiwXy7NM/F52rmoXbys/4GqjuVmfiUKiH1zC2xv1xgx9PTEZIoj
 7bwJ0R0svnY3iDAr+kGs2Z77Gicir7jwCMbND74QRTeTszkNa4fh/1Qdp+gRcgS7RX8o
 nDlxzbI0hMsxYHaU1T0eJlJMLCfRMaS5BLwtIHuL8b2GoMLXA02Qv9Xtd6CyYn/qn5Sh fA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2te61dxqxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:40:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GWW6U045060;
        Mon, 1 Jul 2019 16:40:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2tebak9bss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:40:17 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x61GeH17028945;
        Mon, 1 Jul 2019 16:40:17 GMT
Received: from [10.159.137.152] (/10.159.137.152)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 09:40:16 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next 7/7] net/rds: Initialize ic->i_fastreg_wrs upon
 allocation
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Message-ID: <a97a92d4-c443-12e1-6d82-1646f9584828@oracle.com>
Date:   Mon, 1 Jul 2019 09:40:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise, if an IB connection is torn down before "rds_ib_setup_qp"
is called, the value of "ic->i_fastreg_wrs" is still at zero
(as it wasn't initialized by "rds_ib_setup_qp").
Consequently "rds_ib_conn_path_shutdown" will spin forever,
waiting for it to go back to "RDS_IB_DEFAULT_FR_WR",
which of course will never happen as there are no
outstanding work requests.

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/ib_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 1b6fd6c8b12b..4de0214da63c 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -527,7 +527,6 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	attr.qp_type = IB_QPT_RC;
 	attr.send_cq = ic->i_send_cq;
 	attr.recv_cq = ic->i_recv_cq;
-	atomic_set(&ic->i_fastreg_wrs, RDS_IB_DEFAULT_FR_WR);
 
 	/*
 	 * XXX this can fail if max_*_wr is too large?  Are we supposed
@@ -1139,6 +1138,7 @@ int rds_ib_conn_alloc(struct rds_connection *conn, gfp_t gfp)
 	spin_lock_init(&ic->i_ack_lock);
 #endif
 	atomic_set(&ic->i_signaled_sends, 0);
+	atomic_set(&ic->i_fastreg_wrs, RDS_IB_DEFAULT_FR_WR);
 
 	/*
 	 * rds_ib_conn_shutdown() waits for these to be emptied so they
-- 
2.18.0

