Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E377B14E81E
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 06:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgAaFDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 00:03:49 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45322 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgAaFDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 00:03:49 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V53k5m176237;
        Fri, 31 Jan 2020 05:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=9sNTMAKFTv/tI+97KZmMlKHszrRhGNKBMSVdP6eiijY=;
 b=Xd+wALHIVtmgNc1KFObgvN6ionGzGX2iH9DYGy3EZHx2pQsyifbKaDoNdN6Fqq9MNct1
 KoIhGcfXHMcQGmEWuFPiamqCf0wpIMyGTiV1a0Ob28m8RPy3kXFLInE/RJlqgIIU2D5l
 bc69ZjFcGfPmIPnTpznAha+UqZnwuDe0vYbWkgV/lGtPEnMp03NrlfAPU0x2dwl/88sY
 f3xL6y5zjdrjbZsvMIti+lPzEkdYiYy9j40C6rvvQFtBtuUu87TPyQ9m9INU6SGO25yV
 bqzBBubsnzjo1pEJqpeU952SUQeyHemjPyD6Ys1E9MorN8l73sxlnwWnmnf0PXIEe3HK dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xrearr03q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 05:03:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V53iiM088017;
        Fri, 31 Jan 2020 05:03:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xva6pnth1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 05:03:45 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00V53X8m011920;
        Fri, 31 Jan 2020 05:03:33 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 21:03:33 -0800
Date:   Fri, 31 Jan 2020 08:03:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Cc:     GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] qed: Fix a error code in qed_hw_init()
Message-ID: <20200131050326.n3axoo7axxvzcrv3@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=972
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001310044
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001310044
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the qed_fw_overlay_mem_alloc() then we should return -ENOMEM instead
of success.

Fixes: 30d5f85895fa ("qed: FW 8.42.2.0 Add fw overlay feature")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 7912911337d4..03bdd2e26329 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -3114,6 +3114,7 @@ int qed_hw_init(struct qed_dev *cdev, struct qed_hw_init_params *p_params)
 		if (!p_hwfn->fw_overlay_mem) {
 			DP_NOTICE(p_hwfn,
 				  "Failed to allocate fw overlay memory\n");
+			rc = -ENOMEM;
 			goto load_err;
 		}
 
-- 
2.11.0

