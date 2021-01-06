Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB4B2EC622
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbhAFWTg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 Jan 2021 17:19:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26230 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727363AbhAFWTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 17:19:35 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 106MDuVZ009790
        for <netdev@vger.kernel.org>; Wed, 6 Jan 2021 14:18:54 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35w3y9vw92-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 14:18:54 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 6 Jan 2021 14:18:49 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 07DAB6556F47; Wed,  6 Jan 2021 14:18:42 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <willemdebruijn.kernel@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [RESEND PATCH net-next v1 12/13] tap/tun: add skb_zcopy_init() helper for initialization.
Date:   Wed, 6 Jan 2021 14:18:40 -0800
Message-ID: <20210106221841.1880536-13-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
References: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-06_12:2021-01-06,2021-01-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 suspectscore=0 clxscore=1034 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace direct assignments with skb_zcopy_init() for zerocopy
cases where a new skb is initialized, without changing the
reference counts.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/tap.c      | 3 +--
 drivers/net/tun.c      | 3 +--
 drivers/vhost/net.c    | 1 +
 include/linux/skbuff.h | 9 +++++++--
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index f7a19d9b7c27..3c652c8ac5ba 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -722,8 +722,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	tap = rcu_dereference(q->tap);
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
-		skb_shinfo(skb)->destructor_arg = msg_control;
-		skb_shinfo(skb)->flags |= SKBFL_ZEROCOPY_FRAG;
+		skb_zcopy_init(skb, msg_control);
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
 		uarg->callback(NULL, uarg, false);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index d8f1c3d34612..02a93cfdb6b1 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1814,8 +1814,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
-		skb_shinfo(skb)->destructor_arg = msg_control;
-		skb_shinfo(skb)->flags |= SKBFL_ZEROCOPY_FRAG;
+		skb_zcopy_init(skb, msg_control);
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
 		uarg->callback(NULL, uarg, false);
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f834a097895e..3b744031ec8f 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -903,6 +903,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			ubuf->callback = vhost_zerocopy_callback;
 			ubuf->ctx = nvq->ubufs;
 			ubuf->desc = nvq->upend_idx;
+			ubuf->flags = SKBFL_ZEROCOPY_FRAG;
 			refcount_set(&ubuf->refcnt, 1);
 			msg.msg_control = &ctl;
 			ctl.type = TUN_MSG_UBUF;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 58010df9d183..3ec8b83aca3e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1448,6 +1448,12 @@ static inline void skb_zcopy_get(struct ubuf_info *uarg)
 	refcount_inc(&uarg->refcnt);
 }
 
+static inline void skb_zcopy_init(struct sk_buff *skb, struct ubuf_info *uarg)
+{
+	skb_shinfo(skb)->destructor_arg = uarg;
+	skb_shinfo(skb)->flags |= uarg->flags;
+}
+
 static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
 				 bool *have_ref)
 {
@@ -1456,8 +1462,7 @@ static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
 			*have_ref = false;
 		else
 			skb_zcopy_get(uarg);
-		skb_shinfo(skb)->destructor_arg = uarg;
-		skb_shinfo(skb)->flags |= uarg->flags;
+		skb_zcopy_init(skb, uarg);
 	}
 }
 
-- 
2.24.1

