Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649FE37BA1E
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 12:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhELKNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 06:13:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43442 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhELKNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 06:13:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CAAPrH085034;
        Wed, 12 May 2021 10:11:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=frsJ3gWEEOGEwkeUn5duv/vxaTqrnkMpHV+BEUEGnDg=;
 b=VnS2mKu6j2D52hmkihUW3iZny7K2O3f/201AlVz2pivWQcn49HnB1seLQPfhT+GvN2CR
 u3yup0DVVjq1aS3wypWf5MSnE+9LAnv9rgiSd1qD9A673/9Esqk1T7TRbwdCvCXyjjUo
 e7hgWtXNQF9ghzz3lim+uHljtc94hopngeZzMirJi6PKgn8e0GO0wtkCXe2/Gs8KKm3W
 hKVXC37HW6S96FTtXx5xYXKXofJNoZTiCNZaCPOsLr910eSrGo4FlY6TCrddwzET0uxS
 8wzyhdHzH9noChWr1G8rHHLeMJeeKKDr4QcIGLw/j+cYIoVB+hv5PflSMc/ZUHxuBe5R kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38djkmhgt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 10:11:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CAA1bE174348;
        Wed, 12 May 2021 10:11:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 38e5pyrca8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 10:11:53 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14CABqcE178019;
        Wed, 12 May 2021 10:11:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 38e5pyrc9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 10:11:52 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14CABp03015720;
        Wed, 12 May 2021 10:11:51 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 May 2021 03:11:50 -0700
Date:   Wed, 12 May 2021 13:11:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] octeontx2-pf: fix a buffer overflow in
 otx2_set_rxfh_context()
Message-ID: <YJup3/Ih2vIOXK2R@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: kIk20bMHM1yRqNQjoTrXraaiN0YDb9o7
X-Proofpoint-ORIG-GUID: kIk20bMHM1yRqNQjoTrXraaiN0YDb9o7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1011 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120073
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function is called from ethtool_set_rxfh() and "*rss_context"
comes from the user.  Add some bounds checking to prevent memory
corruption.

Fixes: 81a4362016e7 ("octeontx2-pf: Add RSS multi group support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index f4962a97a075..9d9a2e438acf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -786,6 +786,10 @@ static int otx2_set_rxfh_context(struct net_device *dev, const u32 *indir,
 	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
 		return -EOPNOTSUPP;
 
+	if (*rss_context != ETH_RXFH_CONTEXT_ALLOC &&
+	    *rss_context >= MAX_RSS_GROUPS)
+		return -EINVAL;
+
 	rss = &pfvf->hw.rss_info;
 
 	if (!rss->enable) {
-- 
2.30.2

