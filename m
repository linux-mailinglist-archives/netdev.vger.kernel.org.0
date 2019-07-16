Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675EB6B1DA
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388885AbfGPW3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:29:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41368 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388741AbfGPW3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 18:29:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMDhOw102473;
        Tue, 16 Jul 2019 22:29:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=pxNQHTno4A83nkPk/fZMsQI9T82YpWaGDqhDdM2FnP0=;
 b=vkFIr4Y5UzEje24oeFVEw3AnHv5dfxMXEjMAnEpGdjFZrOE2N6Om2UR6aa88GN6ur3d/
 0ebjjXv7dS/83WMKSHQflup82DMJzOAeZMrpHfbQWzNd997PxLYi2VjYWCxGe4raKe6z
 i5Dyg/1JbDn0TsbysJF+zhuLyW9NpAVmmpFtyOQqdM8XgVdNsilCGRxIAhEaF/ZDga8Y
 HMVZ5xd+blWPwtuQgEW37gLh/xIjwiXDNl0GezpRxyzDvQx8RdWgFTI06m4O7V0Fo+MM
 QnQ1Xki5m3ErTfMH5MFYwkC7xN4ODCtCsShWgO2zAz6Wn2KuNXJKRn4cme6v8TuTEPe+ rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tq6qtq954-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:29:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMChKx153594;
        Tue, 16 Jul 2019 22:29:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2tsctwhx5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jul 2019 22:29:15 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6GMQwP9188631;
        Tue, 16 Jul 2019 22:29:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tsctwhx59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:29:15 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6GMTDtH017963;
        Tue, 16 Jul 2019 22:29:14 GMT
Received: from [10.211.55.164] (/10.211.55.164)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 22:29:13 +0000
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net v3 5/7] net/rds: Set fr_state only to FRMR_IS_FREE if
 IB_WR_LOCAL_INV had been successful
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <78bfebd7-c445-bd41-c5c5-d49e6ed51230@oracle.com>
Date:   Tue, 16 Jul 2019 15:29:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160261
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
index 708c553c3da5..adaa8e99e5a9 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -309,7 +309,8 @@ void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 	}
 
 	if (frmr->fr_inv) {
-		frmr->fr_state = FRMR_IS_FREE;
+		if (frmr->fr_state == FRMR_IS_INUSE)
+			frmr->fr_state = FRMR_IS_FREE;
 		frmr->fr_inv = false;
 		wake_up(&frmr->fr_inv_done);
 	}
-- 
2.22.0


