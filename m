Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD9D2958D3
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 09:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505280AbgJVHKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 03:10:11 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33040 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505183AbgJVHKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 03:10:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M79d0r162787;
        Thu, 22 Oct 2020 07:09:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=XqvNAC90CyFQXW1Z3vcE+rjxX+IqxetT35/EghdWeXU=;
 b=V86ymzEfRe3xJ2hKotVxvsvlE867+vkxT0TkxDpF5+mL9/nmIkPWbMFgoi6hi+KkDPXj
 LQnTFTEMa2VrlI59DE9KnljaDBKYfcmbnKOBvxvgo+wKnAfDp1jHRQaHYNF/Vj2GDU6g
 Kf86YmdA+eBTlUejsx9mSax7RwHc52VfMAGsoN/kGWzytUvSITLecxAow1GuUdYj/yeH
 AhjgEeE/x3FewdEkqAkrmqTah1qBJZGaHiEhG/4RwomDnqcOmkxftEj4nZsVGkbq1OHW
 iAeYVMDGg41iS0pFsy88XF1kPWJu70yf46ATbO017iSEfXB9uD/rARl1lEOCdav7dtgO 0A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 347p4b4avf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 07:09:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M6oAuX047546;
        Thu, 22 Oct 2020 07:07:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 348a6q9b9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 07:07:53 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09M77lCt010460;
        Thu, 22 Oct 2020 07:07:47 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 00:07:47 -0700
Date:   Thu, 22 Oct 2020 10:07:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Karsten Keil <isdn@linux-pingi.de>
Cc:     Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] mISDN: hfcpci: Fix a use after free in hfcmulti_tx()
Message-ID: <20201022070739.GB2817762@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220044
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1011 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220045
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This frees "*sp" before dereferencing it to get "len = (*sp)->len;".

Fixes: af69fb3a8ffa ("Add mISDN HFC multiport driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 7013a3f08429..ce6c160e0df4 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -2152,16 +2152,14 @@ hfcmulti_tx(struct hfc_multi *hc, int ch)
 		HFC_wait_nodebug(hc);
 	}
 
+	len = (*sp)->len;
 	dev_kfree_skb(*sp);
 	/* check for next frame */
-	if (bch && get_next_bframe(bch)) {
-		len = (*sp)->len;
+	if (bch && get_next_bframe(bch))
 		goto next_frame;
-	}
-	if (dch && get_next_dframe(dch)) {
-		len = (*sp)->len;
+
+	if (dch && get_next_dframe(dch))
 		goto next_frame;
-	}
 
 	/*
 	 * now we have no more data, so in case of transparent,
-- 
2.28.0

