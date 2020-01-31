Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47EB014E81C
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 06:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgAaFC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 00:02:56 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgAaFC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 00:02:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V4wGMM172361;
        Fri, 31 Jan 2020 05:02:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=7lB9BFwRGl+gpGzX5mXbvqVaCHXHrsMfqd4Acacq2U0=;
 b=WwbLKBbr8lS727YPdsst0dgG6kNIWuYOSQW8lkqDMLV3Ec35NlazZkj3WQyTUukAszcD
 zedb7zwVPqcGJujgKgeezmiPYGNdaYRMxmFWd8Z0canq2dRLmgGl0Wl4oLDX6FQZ252M
 DUlDMIOI6AoB2aCCSDFwmzcdHgAo1xaQH06cIb48NsrNVJ29S3L7EweDJtBgtScXUFxO
 G0MJ0j3yAi+xsM3JxKwLdN977bkD8zStYz4zCgRS9Y02n08eGPj1yjSo2N5YPFXOJw4e
 IN9hwVlanlX/3PD1iy9QmjyuJV8l+SS5FII8cWyv5N8S5ELMTn29fj45PRFkb2mI8nS/ Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xrearr010-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 05:02:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V4wUkV182713;
        Fri, 31 Jan 2020 05:02:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xv8nq154u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 05:02:51 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00V52ovD008708;
        Fri, 31 Jan 2020 05:02:50 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 21:02:49 -0800
Date:   Fri, 31 Jan 2020 08:02:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] octeontx2-pf: Fix an IS_ERR() vs NULL bug
Message-ID: <20200131050241.aoqatlxubobkmi4y@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=661
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001310043
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=724 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001310043
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The otx2_mbox_get_rsp() function never returns NULL, it returns error
pointers on error.

Fixes: 34bfe0ebedb7 ("octeontx2-pf: MTU, MAC and RX mode config support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 8247d21d0432..b945bd3d5d88 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -171,9 +171,9 @@ static int otx2_hw_get_mac_addr(struct otx2_nic *pfvf,
 	}
 
 	msghdr = otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
-	if (!msghdr) {
+	if (IS_ERR(msghdr)) {
 		otx2_mbox_unlock(&pfvf->mbox);
-		return -ENOMEM;
+		return PTR_ERR(msghdr);
 	}
 	rsp = (struct nix_get_mac_addr_rsp *)msghdr;
 	ether_addr_copy(netdev->dev_addr, rsp->mac_addr);
-- 
2.11.0

