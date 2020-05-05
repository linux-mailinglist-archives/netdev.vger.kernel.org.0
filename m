Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC1D1C6240
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgEEUri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:47:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59516 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729123AbgEEUrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:47:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045Kd8Ow083317;
        Tue, 5 May 2020 20:47:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=WUIzdKS1I7w0qbMI/4oHLxgLL6fcqlw5W8h5bvRuxm8=;
 b=lYbLVxkTQ0LSV+knWH1oM2q3PWGfAEs4RD7rWwp8tBmHesGzDwebNpD/6VM3g/2xw+Xe
 NibasiD0ub2FsYXtSz7RySuUdO8KHTlQrREHQ+jKclNx5AoCcKNMLebTp5gtCMV3og0l
 62TXU9P24OkVTpZetRrUPZCJY6awEs06Qbdnqsl0SS6pCtq0fNwgSCR8GmGbEwO2q/XI
 JBbGi0evapeIXHOPxbnyWC4sv65bh8a3lC8ryYRZeGJNgyR4s9Ir+2S1M5r1TtNLXeKP
 5LJDWgL8XyMAZdvfOHTRZVhiTM1I5pC/WXWX6UoRaE9E72WKX81AeG7j+fYpRmOnS4V4 eQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30s0tmf1sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 20:47:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045KktVB038246;
        Tue, 5 May 2020 20:47:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30sjdttduv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 20:47:30 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 045KlTUE016522;
        Tue, 5 May 2020 20:47:29 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 13:47:28 -0700
Date:   Tue, 5 May 2020 23:47:21 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>, Po Liu <Po.Liu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] enetc: Fix use after free in stream_filter_unref()
Message-ID: <20200505204721.GA51853@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1011 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050159
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code frees "sfi" and then dereferences it on the next line.

Fixes: 888ae5a3952b ("net: enetc: add tc flower psfp offload driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 48e589e9d0f7c..10d79eb46c2e8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -902,8 +902,8 @@ static void stream_filter_unref(struct enetc_ndev_priv *priv, u32 index)
 	if (z) {
 		enetc_streamfilter_hw_set(priv, sfi, false);
 		hlist_del(&sfi->node);
-		kfree(sfi);
 		clear_bit(sfi->index, epsfp.psfp_sfi_bitmap);
+		kfree(sfi);
 	}
 }
 
-- 
2.26.2

