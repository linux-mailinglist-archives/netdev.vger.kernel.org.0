Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E827182F32
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 12:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgCLLbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 07:31:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46616 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgCLLbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 07:31:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CBMXLT090672;
        Thu, 12 Mar 2020 11:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=SZAWvTkDSrViEpOrsb4DKmEA0cKFNj03DFEl3DHh1Ck=;
 b=QAk4FRJracEmObV2HUSlMX2cz7dC51IsJ9st60tAjksQlE9fLH1c02eLGn3/a8QMWnwr
 cxAmqEfraKvNls5FX//BANA9/G7eJoV8fRp3OSWIzqcVGwrWEhpyoWnP7jrkBpomS9Ja
 9SbyBqAdMTlcWfYwaKT+m2E1ZLU+WrRqFb9EJtQI70W+7SPAzkaecH/cxK7na+iAfW+A
 eQCnCb+CqxIB91/lVRjTqB9OCEIkl8bOHbla6pnjVgMAFkE6xewWgV+Bck2sdwVmKUOm
 pyru+f15SFLj252vF7twwmYHKupDiACXb28NEQ/EInTotGMNuCQOaIOg1sDMC90zSOky oQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yp9v6c4m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 11:30:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CBN1hh070659;
        Thu, 12 Mar 2020 11:30:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2yqgvcq4ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 11:30:56 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02CBUtFN015341;
        Thu, 12 Mar 2020 11:30:55 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 04:30:54 -0700
Date:   Thu, 12 Mar 2020 14:30:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] octeontx2-pf: unlock on error path in otx2_config_pause_frm()
Message-ID: <20200312113048.GB20562@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120062
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120062
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to unlock before returning if this allocation fails.

Fixes: 75f36270990c ("octeontx2-pf: Support to enable/disable pause frames via ethtool")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index af4437d4dfcb..157735443473 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -227,14 +227,17 @@ int otx2_config_pause_frm(struct otx2_nic *pfvf)
 
 	otx2_mbox_lock(&pfvf->mbox);
 	req = otx2_mbox_alloc_msg_cgx_cfg_pause_frm(&pfvf->mbox);
-	if (!req)
-		return -ENOMEM;
+	if (!req) {
+		err = -ENOMEM;
+		goto unlock;
+	}
 
 	req->rx_pause = !!(pfvf->flags & OTX2_FLAG_RX_PAUSE_ENABLED);
 	req->tx_pause = !!(pfvf->flags & OTX2_FLAG_TX_PAUSE_ENABLED);
 	req->set = 1;
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
+unlock:
 	otx2_mbox_unlock(&pfvf->mbox);
 	return err;
 }
-- 
2.20.1

