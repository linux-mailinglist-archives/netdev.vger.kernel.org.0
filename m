Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F6F4AA27
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbfFRSpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:45:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44752 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730073AbfFRSpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:45:22 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5IIjAKD000773
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 14:45:20 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t731r6e5r-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 14:45:10 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 18 Jun 2019 19:43:15 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 18 Jun 2019 19:43:12 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5IIhBDH56492222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 18:43:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40D08A4057;
        Tue, 18 Jun 2019 18:43:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1744A4051;
        Tue, 18 Jun 2019 18:43:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jun 2019 18:43:10 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 2/3] net/af_iucv: build proper skbs for HiperTransport
Date:   Tue, 18 Jun 2019 20:43:00 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190618184301.96472-1-jwi@linux.ibm.com>
References: <20190618184301.96472-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061818-0016-0000-0000-0000028A3102
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061818-0017-0000-0000-000032E78393
Message-Id: <20190618184301.96472-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=751 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The HiperSockets-based transport path in af_iucv is still too closely
entangled with qeth.
With commit a647a02512ca ("s390/qeth: speed-up L3 IQD xmit"), the
relevant xmit code in qeth has begun to use skb_cow_head(). So to avoid
unnecessary skb head expansions, af_iucv must learn to
1) respect dev->needed_headroom when allocating skbs, and
2) drop the header reference before cloning the skb.

While at it, also stop hard-coding the LL-header creation stage and just
use the appropriate helper.

Fixes: a647a02512ca ("s390/qeth: speed-up L3 IQD xmit")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/iucv/af_iucv.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 2ee68d2d4693..5264a182d2c3 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -14,6 +14,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/module.h>
+#include <linux/netdevice.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/errno.h>
@@ -347,14 +348,14 @@ static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
 	if (imsg)
 		memcpy(&phs_hdr->iucv_hdr, imsg, sizeof(struct iucv_message));
 
-	skb_push(skb, ETH_HLEN);
-	memset(skb->data, 0, ETH_HLEN);
-
 	skb->dev = iucv->hs_dev;
 	if (!skb->dev) {
 		err = -ENODEV;
 		goto err_free;
 	}
+
+	dev_hard_header(skb, skb->dev, ETH_P_AF_IUCV, NULL, NULL, skb->len);
+
 	if (!(skb->dev->flags & IFF_UP) || !netif_carrier_ok(skb->dev)) {
 		err = -ENETDOWN;
 		goto err_free;
@@ -367,6 +368,8 @@ static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
 		skb_trim(skb, skb->dev->mtu);
 	}
 	skb->protocol = cpu_to_be16(ETH_P_AF_IUCV);
+
+	__skb_header_release(skb);
 	nskb = skb_clone(skb, GFP_ATOMIC);
 	if (!nskb) {
 		err = -ENOMEM;
@@ -466,12 +469,14 @@ static void iucv_sever_path(struct sock *sk, int with_user_data)
 /* Send controlling flags through an IUCV socket for HIPER transport */
 static int iucv_send_ctrl(struct sock *sk, u8 flags)
 {
+	struct iucv_sock *iucv = iucv_sk(sk);
 	int err = 0;
 	int blen;
 	struct sk_buff *skb;
 	u8 shutdown = 0;
 
-	blen = sizeof(struct af_iucv_trans_hdr) + ETH_HLEN;
+	blen = sizeof(struct af_iucv_trans_hdr) +
+	       LL_RESERVED_SPACE(iucv->hs_dev);
 	if (sk->sk_shutdown & SEND_SHUTDOWN) {
 		/* controlling flags should be sent anyway */
 		shutdown = sk->sk_shutdown;
@@ -1133,7 +1138,8 @@ static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	 * segmented records using the MSG_EOR flag), but
 	 * for SOCK_STREAM we might want to improve it in future */
 	if (iucv->transport == AF_IUCV_TRANS_HIPER) {
-		headroom = sizeof(struct af_iucv_trans_hdr) + ETH_HLEN;
+		headroom = sizeof(struct af_iucv_trans_hdr) +
+			   LL_RESERVED_SPACE(iucv->hs_dev);
 		linear = len;
 	} else {
 		if (len < PAGE_SIZE) {
-- 
2.17.1

