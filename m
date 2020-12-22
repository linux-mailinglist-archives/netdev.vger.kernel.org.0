Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FC32E0342
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 01:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgLVAKW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Dec 2020 19:10:22 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24388 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726617AbgLVAKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 19:10:19 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BM00fiF013676
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:38 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35k0e8ssby-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:38 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Dec 2020 16:09:33 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 3ACC65BD9C3A; Mon, 21 Dec 2020 16:09:26 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 10/12 v2 RFC] tap/tun: use skb_zcopy_set() instead of open coded assignment
Date:   Mon, 21 Dec 2020 16:09:24 -0800
Message-ID: <20201222000926.1054993-11-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-21_13:2020-12-21,2020-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 clxscore=1034
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210163
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Replace direct assignments with skb_zcopy_set() for clarity.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/tap.c   | 3 +--
 drivers/net/tun.c   | 3 +--
 drivers/vhost/net.c | 1 +
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index c2bcbf9218dc..7e7a4c7ca891 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -722,8 +722,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	tap = rcu_dereference(q->tap);
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
-		skb_shinfo(skb)->destructor_arg = msg_control;
-		skb_shinfo(skb)->zc_flags |= SKBZC_FRAGMENTS;
+		skb_zcopy_set(skb, msg_control, NULL);
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
 		uarg->callback(NULL, uarg, false);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index bad4b0229584..0844da91e2ed 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1814,8 +1814,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
-		skb_shinfo(skb)->destructor_arg = msg_control;
-		skb_shinfo(skb)->zc_flags |= SKBZC_FRAGMENTS;
+		skb_zcopy_set(skb, msg_control, NULL);
 	} else if (msg_control) {
 		struct ubuf_info *uarg = msg_control;
 		uarg->callback(NULL, uarg, false);
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index bf28d0b75c1b..174c05c90872 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -904,6 +904,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			ubuf->callback = vhost_zerocopy_callback;
 			ubuf->ctx = nvq->ubufs;
 			ubuf->desc = nvq->upend_idx;
+			ubuf->zc_flags = SKBZC_FRAGMENTS;
 			refcount_set(&ubuf->refcnt, 1);
 			msg.msg_control = &ctl;
 			ctl.type = TUN_MSG_UBUF;
-- 
2.24.1

