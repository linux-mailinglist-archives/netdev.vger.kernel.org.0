Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBEC4104F1F
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 10:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfKUJWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 04:22:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55642 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfKUJWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 04:22:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAL9Jqmw061121;
        Thu, 21 Nov 2019 09:21:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=YVJb3xjnvo+lZOSP+MrYXMysiTQ6g7glOzUX2cp7MDw=;
 b=J+qXxwYnKqLACMMhg8LeqwB4wxt/1iuEIVpfqVEI8yYizrtJrnRoDcondkiilRw9r8V7
 pXHS1l6N7nDKS37/5eEbZU/z8jeitqye4GriZd7n994pDUEEf28+2v435pcZMFsZ4Dzx
 EZfNL84eKdmDhbaOfvM+KTRUgueNUDkVzXxq9q5ihhhfsuUmUHXrmZoucnRaFGG9XzQ8
 dyEr5SGopadaniuBMQZLeOJuJEW3XpgWopqvm0NdsWyfJTddafwwG6S5bEse/GwzQ/ws
 kMkfuGCw6q/w/Rq9WZQixY+C25K2BtCQow3fvS4tpRC+JpthTGUySkHTW//8y1g9qRkx iQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wa9rqtqeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 09:21:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAL9JDxf017116;
        Thu, 21 Nov 2019 09:21:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wdfrrh9nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 09:21:57 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAL9LuEr021279;
        Thu, 21 Nov 2019 09:21:56 GMT
Received: from kili.mountain (/41.210.154.230)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 01:21:55 -0800
Date:   Thu, 21 Nov 2019 12:21:46 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>
Cc:     Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] octeontx2-af: Fix uninitialized variable in debugfs
Message-ID: <20191121092146.hnvdwnzpirskw3wr@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210084
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If rvu_get_blkaddr() fails, then this rvu_cgx_nix_cuml_stats() returns
zero and we write some uninitialized data into the debugfs output.

On the error paths, the use of the uninitialized "*stat" is harmless,
but it will lead to a Smatch warning (static analysis) and a UBSan
warning (runtime analysis) so we should prevent that as well.

Fixes: f967488d095e ("octeontx2-af: Add per CGX port level NIX Rx/Tx counters")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 0bbb2eb1446e..11e5921c55b9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -608,6 +608,8 @@ int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id,
 	u16 pcifunc;
 	int pf, lf;
 
+	*stat = 0;
+
 	if (!cgxd || !rvu)
 		return -EINVAL;
 
@@ -624,7 +626,6 @@ int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id,
 		return 0;
 	block = &rvu->hw->block[blkaddr];
 
-	*stat = 0;
 	for (lf = 0; lf < block->lf.max; lf++) {
 		/* Check if a lf is attached to this PF or one of its VFs */
 		if (!((block->fn_map[lf] & ~RVU_PFVF_FUNC_MASK) == (pcifunc &
-- 
2.11.0

