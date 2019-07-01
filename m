Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC705C14C
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbfGAQkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:40:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52714 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbfGAQkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:40:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GY0jp180996;
        Mon, 1 Jul 2019 16:40:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=HP71PdIMTGY4SDjcjnXYD6zgxtMD7lC/0zvbQ3WWJH8=;
 b=cy91+kNxWldSlbv4CJL9V+8KRHxK+NbWlyNWBvrAZmsCOYgg2wXoNHlnY6n13GwKQua2
 Aet8BaR7UeqEbcsWlVM7HWuo/YZz87cG1GKFBD+k4WlfL3Yf/1gR2w8WnbEtHGc3/Nmn
 CjAAZETM3aD+mJwdGHO9fvTLcWv5ppysyOORrp8G7V2lkm8dLg27JzxjbtE5lN+VRBbZ
 ezn2MoM9WEHNOfvrVvAaoPCffGmzZm2bA8rvY3trAPZ7mmXzAtCgg5FALQczUejIgDmE
 Ro/B7ddS2hWUYv6Xmduf2zQZ2JKj9G+c+0PEdpi9TJkdcN7NNLlPHxhG5FAtNmyGC8om fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2te61ppqyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:40:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GWUPK147694;
        Mon, 1 Jul 2019 16:40:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tebktsb1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:40:06 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x61Ge5fe021318;
        Mon, 1 Jul 2019 16:40:06 GMT
Received: from [10.159.137.152] (/10.159.137.152)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 09:40:05 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next 5/7] net/rds: Set fr_state only to FRMR_IS_FREE if
 IB_WR_LOCAL_INV had been successful
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Message-ID: <eb94e6bf-cbde-8cf1-b139-66fc8351f181@oracle.com>
Date:   Mon, 1 Jul 2019 09:40:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a bug where fr_state first goes to FRMR_IS_STALE, because of a failure
of operation IB_WR_LOCAL_INV, but then gets set back to "FRMR_IS_FREE"
uncoditionally, even though the operation failed.

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/ib_frmr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 3c953034dca3..a5d8f4128515 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -328,7 +328,8 @@ void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 	}
 
 	if (frmr->fr_inv) {
-		frmr->fr_state = FRMR_IS_FREE;
+		if (frmr->fr_state == FRMR_IS_INUSE)
+			frmr->fr_state = FRMR_IS_FREE;
 		frmr->fr_inv = false;
 		wake_up(&frmr->fr_inv_done);
 	}
-- 
2.18.0


