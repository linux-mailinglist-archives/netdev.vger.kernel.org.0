Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955EB1E6160
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389969AbgE1MuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:50:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54890 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389851AbgE1MuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 08:50:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04SCcB6f077838;
        Thu, 28 May 2020 12:50:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=42pW05J+XGKKbj5116SvnJ6S67bu8Mxa49NL4WicG40=;
 b=EaK3zKf/TUl6Wd7VsummzrwfJVG5Y93Xh6hhruHbf7oaNJ+851oyypQG8hPMz4+cU9/o
 ywLqMW1IoorIjhRYxbboKP0+uB57Cmdj14BYoXBXeHUFWNqCPf+EoONAgDN+IhTTzQJz
 jTEcr8qfZvr7Lfbq2s/OUKgDyFE0R+LqtmxlEyNGE08+JNT9d3CxflVjg4BzZkfvNHAL
 UzksfDCkH25/i2my3bcakBNxNoccEV+phHXxDfO3Lhh8A/d7YnriiZOTauqdD9zkxTVF
 jC0LHCygtdEmhR3VqjAB9LIiypaFApkk6Z0VBmmheI0rowt6h+kGx6/r3LSasPQZpkDG GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 318xe1msbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 28 May 2020 12:50:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04SCbcum004032;
        Thu, 28 May 2020 12:50:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 317j5v71bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 May 2020 12:50:05 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04SCo3Ur002534;
        Thu, 28 May 2020 12:50:03 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 May 2020 05:50:02 -0700
Date:   Thu, 28 May 2020 15:49:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vishal Kulkarni <vishal@chelsio.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] cxgb4: cleanup error code in setup_sge_queues_uld()
Message-ID: <20200528124957.GD1219412@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9634 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005280087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9634 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005280087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The caller doesn't care about the error codes, they only check for zero
vs non-zero.  Still, it's better to preserve the negative error codes
from alloc_uld_rxqs() instead of changing it to 1.  We can also return
directly if there is a failure.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This isn't a bugfix so it should probably go to net-next, but the code
is pretty old.

The other error handling only checks the last iteration in the
for_each_port() loop.  I didn't change that because it's slightly
riskier and I can't test the code.

 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 6b1d3df4b9bae..9e3c6b36cde89 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -174,13 +174,14 @@ static int
 setup_sge_queues_uld(struct adapter *adap, unsigned int uld_type, bool lro)
 {
 	struct sge_uld_rxq_info *rxq_info = adap->sge.uld_rxq_info[uld_type];
-	int i, ret = 0;
+	int i, ret;
 
-	ret = !(!alloc_uld_rxqs(adap, rxq_info, lro));
+	ret = alloc_uld_rxqs(adap, rxq_info, lro);
+	if (ret)
+		return ret;
 
 	/* Tell uP to route control queue completions to rdma rspq */
-	if (adap->flags & CXGB4_FULL_INIT_DONE &&
-	    !ret && uld_type == CXGB4_ULD_RDMA) {
+	if (adap->flags & CXGB4_FULL_INIT_DONE && uld_type == CXGB4_ULD_RDMA) {
 		struct sge *s = &adap->sge;
 		unsigned int cmplqid;
 		u32 param, cmdop;
-- 
2.26.2

