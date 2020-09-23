Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0287D275337
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIWIbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:31:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52742 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgIWIbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:31:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08N8TCPx005684;
        Wed, 23 Sep 2020 08:30:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=LwWNEwdDLy+BwVf25VOLJQ7mq5JE6nvU0LL8xQOsN7Y=;
 b=x7PrreU9yuXBQEhOdghHiQSgGvgnU4u8SbYAAMBAE70WGBzqu9MOFmHvhnvqfqgxo1tB
 r5VhePQrdBRkWGfdDkk8hbuKFer+CAbVXMFeIvxfusFLblnhKTj/qCsWr0uafZiWrSSj
 wkgXVXSt2IHK9kVG3eI7uRq5FC0mU/MUsWJQo1WHTlm0j5/0fFyhF61olPpAmP3Puk/n
 XHo0pgrq6l08xUyGEw5t1vMF10fyfL/vGrYL4vp9P31QS32DzKdPGbELCyjRWB/wQv+c
 JDdqinsstz1qQ8IF486TEYzsY85eQy22hg4hd5fw5cQMBKCvi85H6O0quT1c3S1SlRfq vA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33q5rgfd4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 08:30:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08N8U1Lq016192;
        Wed, 23 Sep 2020 08:30:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33r28uu5b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 08:30:30 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08N8UPfL024771;
        Wed, 23 Sep 2020 08:30:25 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 01:30:24 -0700
Date:   Wed, 23 Sep 2020 11:30:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH net-next] tipc: potential memory corruption in
 tipc_crypto_key_rcv()
Message-ID: <20200923083017.GA1454948@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1011 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code uses "skey->keylen" as an memcpy() size and then checks that
it is valid on the next line.  The other problem is that the check has
a potential integer overflow, it's better to use struct_size() for this.

Fixes: 23700da29b83 ("tipc: add automatic rekeying for encryption key")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Hey Kees and Julia,

It would be nice to change tipc_aead_key_size() but I'm not sure how the
UAPI stuff works.  My first attempt at to change it to

	return struct_size(key, key, key->keylen);

broke the build.  I think you guys used Coccinelle to automatically
update these calculations.  Probably this wasn't updated because you
didn't want to break the build either?

 net/tipc/crypto.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 40c44101fe8e..291ba276b835 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -2281,6 +2281,7 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
 	u16 key_gen = msg_key_gen(hdr);
 	u16 size = msg_data_sz(hdr);
 	u8 *data = msg_data(hdr);
+	u32 keylen;
 
 	spin_lock(&rx->lock);
 	if (unlikely(rx->skey || (key_gen == rx->key_gen && rx->key.keys))) {
@@ -2289,6 +2290,10 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
 		goto exit;
 	}
 
+	keylen = ntohl(*((__be32 *)(data + TIPC_AEAD_ALG_NAME)));
+	if (struct_size(skey, key, keylen) != size)
+		goto exit;
+
 	/* Allocate memory for the key */
 	skey = kmalloc(size, GFP_ATOMIC);
 	if (unlikely(!skey)) {
@@ -2297,18 +2302,11 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
 	}
 
 	/* Copy key from msg data */
-	skey->keylen = ntohl(*((__be32 *)(data + TIPC_AEAD_ALG_NAME)));
+	skey->keylen = keylen;
 	memcpy(skey->alg_name, data, TIPC_AEAD_ALG_NAME);
 	memcpy(skey->key, data + TIPC_AEAD_ALG_NAME + sizeof(__be32),
 	       skey->keylen);
 
-	/* Sanity check */
-	if (unlikely(size != tipc_aead_key_size(skey))) {
-		kfree(skey);
-		skey = NULL;
-		goto exit;
-	}
-
 	rx->key_gen = key_gen;
 	rx->skey_mode = msg_key_mode(hdr);
 	rx->skey = skey;
-- 
2.28.0

