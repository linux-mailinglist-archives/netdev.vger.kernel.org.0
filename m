Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEB337B9EA
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 12:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhELKE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 06:04:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39872 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbhELKEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 06:04:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14C9t8KL044138;
        Wed, 12 May 2021 10:02:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=oSROxLxMjMzVR/1fzvE5Hkm3ORHRPZoMp7iusaLvJkE=;
 b=zT+1VQe6KwrGTryFVtjnWBfY4/9yHNOqiHGNhH4rbHWVG1GhMDlxjnUAc2GXG7lOYgE6
 XGvgwVrbY5UN2bU7cM9uvXGruhseQQx4D9GR39IHZKWnfvtyH50zNKm7zVYEXtZpxMsO
 FBfd6H97YJWt+Ahs6sYt2Kvn0Xr6RVHbNt9PhVvUhBUIFmLsdcEWKGXvayW4z6S/Y9Os
 VEGIUsPpdkQdhTjIFMA6BlCn9TRNtyDCpkn0uWDizRlc1HVXU3IqNM5KH6qvHI65lvHF
 NJ8Tuu2Nk9ZPrBg3kKr/PVSn27zuIhTDxQLzatrQWZZCYv6AOT+BtYbUYBQw280HkLie bQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38djkmhg23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 10:02:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14C9xs5s155604;
        Wed, 12 May 2021 10:02:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 38e5pyr5gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 10:02:57 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14CA2uq5162100;
        Wed, 12 May 2021 10:02:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 38e5pyr5fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 10:02:57 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 14CA2te9028537;
        Wed, 12 May 2021 10:02:55 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 May 2021 03:02:55 -0700
Date:   Wed, 12 May 2021 13:02:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Cc:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] chelsio/chtls: unlock on error in chtls_pt_recvmsg()
Message-ID: <YJunyKKpMGnT/Ms/@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: GiBISkxCPcm7amvWY71gAGxOAx1Q-8sW
X-Proofpoint-ORIG-GUID: GiBISkxCPcm7amvWY71gAGxOAx1Q-8sW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1011 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This error path needs to release some memory and call release_sock(sk);
before returning.

Fixes: 6919a8264a32 ("Crypto/chtls: add/delete TLS header in driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index 188d871f6b8c..c320cc8ca68d 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1564,8 +1564,10 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			cerr = put_cmsg(msg, SOL_TLS, TLS_GET_RECORD_TYPE,
 					sizeof(thdr->type), &thdr->type);
 
-			if (cerr && thdr->type != TLS_RECORD_TYPE_DATA)
-				return -EIO;
+			if (cerr && thdr->type != TLS_RECORD_TYPE_DATA) {
+				copied = -EIO;
+				break;
+			}
 			/*  don't send tls header, skip copy */
 			goto skip_copy;
 		}
-- 
2.30.2

