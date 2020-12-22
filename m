Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D432E033B
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 01:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgLVAKQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Dec 2020 19:10:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46070 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgLVAKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 19:10:16 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BM00fi9013676
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:36 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35k0e8ssby-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:35 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Dec 2020 16:09:33 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 30A595BD9C36; Mon, 21 Dec 2020 16:09:26 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 08/12 v2 RFC] skbuff: Call sock_zerocopy_put_abort from skb_zcopy_put_abort
Date:   Mon, 21 Dec 2020 16:09:22 -0800
Message-ID: <20201222000926.1054993-9-jonathan.lemon@gmail.com>
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
 spamscore=0 mlxlogscore=454 malwarescore=0 adultscore=0 clxscore=1034
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210163
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

The sock_zerocopy_put_abort function contains logic which is
specific to the current zerocopy implementation.  Add a wrapper
which checks the callback and dispatches apppropriately.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 10 ++++++++++
 net/core/skbuff.c      | 12 +++++-------
 net/ipv4/ip_output.c   |  3 +--
 net/ipv4/tcp.c         |  2 +-
 net/ipv6/ip6_output.c  |  3 +--
 5 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8403ea509cee..da0c1dddd0da 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1480,6 +1480,16 @@ static inline void skb_zcopy_put(struct ubuf_info *uarg)
 		uarg->callback(NULL, uarg, true);
 }
 
+static inline void skb_zcopy_put_abort(struct ubuf_info *uarg, bool have_uref)
+{
+	if (uarg) {
+		if (uarg->callback == sock_zerocopy_callback)
+			sock_zerocopy_put_abort(uarg, have_uref);
+		else if (have_uref)
+			skb_zcopy_put(uarg);
+	}
+}
+
 /* Release a reference on a zerocopy structure */
 static inline void skb_zcopy_clear(struct sk_buff *skb, bool success)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 328385cd141e..8352da29f052 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1254,15 +1254,13 @@ EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
 
 void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 {
-	if (uarg) {
-		struct sock *sk = skb_from_uarg(uarg)->sk;
+	struct sock *sk = skb_from_uarg(uarg)->sk;
 
-		atomic_dec(&sk->sk_zckey);
-		uarg->len--;
+	atomic_dec(&sk->sk_zckey);
+	uarg->len--;
 
-		if (have_uref)
-			skb_zcopy_put(uarg);
-	}
+	if (have_uref)
+		sock_zerocopy_callback(NULL, uarg, true);
 }
 EXPORT_SYMBOL_GPL(sock_zerocopy_put_abort);
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 879b76ae4435..65f2299fd682 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1230,8 +1230,7 @@ static int __ip_append_data(struct sock *sk,
 error_efault:
 	err = -EFAULT;
 error:
-	if (uarg)
-		sock_zerocopy_put_abort(uarg, extra_uref);
+	skb_zcopy_put_abort(uarg, extra_uref);
 	cork->length -= length;
 	IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTDISCARDS);
 	refcount_add(wmem_alloc_delta, &sk->sk_wmem_alloc);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5c38080df13f..900b6bb7b280 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1440,7 +1440,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	if (copied + copied_syn)
 		goto out;
 out_err:
-	sock_zerocopy_put_abort(uarg, true);
+	skb_zcopy_put_abort(uarg, true);
 	err = sk_stream_error(sk, flags, err);
 	/* make sure we wake any epoll edge trigger waiter */
 	if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 749ad72386b2..c8c87891533a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1715,8 +1715,7 @@ static int __ip6_append_data(struct sock *sk,
 error_efault:
 	err = -EFAULT;
 error:
-	if (uarg)
-		sock_zerocopy_put_abort(uarg, extra_uref);
+	skb_zcopy_put_abort(uarg, extra_uref);
 	cork->length -= length;
 	IP6_INC_STATS(sock_net(sk), rt->rt6i_idev, IPSTATS_MIB_OUTDISCARDS);
 	refcount_add(wmem_alloc_delta, &sk->sk_wmem_alloc);
-- 
2.24.1

