Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424962CD199
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 09:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbgLCIpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 03:45:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53744 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728872AbgLCIpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 03:45:31 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B38ZDrt109270;
        Thu, 3 Dec 2020 08:44:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=5xM+W6iVfraIXHMKNLkXszMJwouu1bVLZDAXHcAkFeY=;
 b=oBa6b3B3yUTVnWaV+kmyL/6o0nnvnYcG1LSDV75y345tZjy/HSvf33CHtNtrV/GW+2tx
 bjcJ9VRgNOD1h3qA0f2hBs+3vIfi3hMji3/PboBL27i/saVLG0arDvUR2W0mAsAgPW0n
 vVTGrXHzHNgd+2zDA/2qcwztdt3xudAsM72yUSzLXvFrRsHAVhx7EHFgaOJokzPWxLI9
 KbeEYM4rcv4OEoJOiGs0cA/XRqZ5F214SWBKXka3+It6o7upOe5B0TOEZ2qQjys2sKnq
 0VJkRSuBHgWC9OnPRSd3uvNoHIc7Hjb6XjPElgKDhfWDG6ObIO6l5L5D/FDtLuciqJx5 bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egkvhqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 08:44:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B38eDF6194491;
        Thu, 3 Dec 2020 08:44:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3540f1hu3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 08:44:40 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B38idDF022475;
        Thu, 3 Dec 2020 08:44:39 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 08:44:38 +0000
Date:   Thu, 3 Dec 2020 11:44:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>
Cc:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] chelsio/chtls: fix a double free in chtls_setkey()
Message-ID: <X8ilb6PtBRLWiSHp@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=2 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=2
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030052
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "skb" is freed by the transmit code in cxgb4_ofld_send() and we
shouldn't use it again.  But in the current code, if we hit an error
later on in the function then the clean up code will call kfree_skb(skb)
and so it causes a double free.

Set the "skb" to NULL and that makes the kfree_skb() a no-op.

Fixes: d25f2f71f653 ("crypto: chtls - Program the TLS session Key")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
index 62c829023da5..a4fb463af22a 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
@@ -391,6 +391,7 @@ int chtls_setkey(struct chtls_sock *csk, u32 keylen,
 	csk->wr_unacked += DIV_ROUND_UP(len, 16);
 	enqueue_wr(csk, skb);
 	cxgb4_ofld_send(csk->egress_dev, skb);
+	skb = NULL;
 
 	chtls_set_scmd(csk);
 	/* Clear quiesce for Rx key */
-- 
2.29.2

