Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6205A2EC61D
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbhAFWTa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 Jan 2021 17:19:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15828 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727705AbhAFWTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 17:19:30 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 106MFdjO016568
        for <netdev@vger.kernel.org>; Wed, 6 Jan 2021 14:18:49 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 35w24knbmm-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 14:18:48 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 6 Jan 2021 14:18:47 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 0A3AB6556F49; Wed,  6 Jan 2021 14:18:42 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <willemdebruijn.kernel@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [RESEND PATCH net-next v1 13/13] skbuff: Rename skb_zcopy_{get|put} to net_zcopy_{get|put}
Date:   Wed, 6 Jan 2021 14:18:41 -0800
Message-ID: <20210106221841.1880536-14-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
References: <20210106221841.1880536-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-06_12:2021-01-06,2021-01-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 mlxlogscore=351 adultscore=0 malwarescore=0 mlxscore=0 clxscore=1034
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike the rest of the skb_zcopy_ functions, these routines
operate on a 'struct ubuf', not a skb.  Remove the 'skb_'
prefix from the naming to make things clearer.

Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/skbuff.h | 10 +++++-----
 net/core/skbuff.c      |  2 +-
 net/ipv4/ip_output.c   |  2 +-
 net/ipv4/tcp.c         |  4 ++--
 net/ipv6/ip6_output.c  |  2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3ec8b83aca3e..961908a22d0e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1443,7 +1443,7 @@ static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
 	return is_zcopy ? skb_uarg(skb) : NULL;
 }
 
-static inline void skb_zcopy_get(struct ubuf_info *uarg)
+static inline void net_zcopy_get(struct ubuf_info *uarg)
 {
 	refcount_inc(&uarg->refcnt);
 }
@@ -1461,7 +1461,7 @@ static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
 		if (unlikely(have_ref && *have_ref))
 			*have_ref = false;
 		else
-			skb_zcopy_get(uarg);
+			net_zcopy_get(uarg);
 		skb_zcopy_init(skb, uarg);
 	}
 }
@@ -1482,19 +1482,19 @@ static inline void *skb_zcopy_get_nouarg(struct sk_buff *skb)
 	return (void *)((uintptr_t) skb_shinfo(skb)->destructor_arg & ~0x1UL);
 }
 
-static inline void skb_zcopy_put(struct ubuf_info *uarg)
+static inline void net_zcopy_put(struct ubuf_info *uarg)
 {
 	if (uarg)
 		uarg->callback(NULL, uarg, true);
 }
 
-static inline void skb_zcopy_put_abort(struct ubuf_info *uarg, bool have_uref)
+static inline void net_zcopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 {
 	if (uarg) {
 		if (uarg->callback == msg_zerocopy_callback)
 			msg_zerocopy_put_abort(uarg, have_uref);
 		else if (have_uref)
-			skb_zcopy_put(uarg);
+			net_zcopy_put(uarg);
 	}
 }
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ee288af095f0..45d60c5286fe 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1165,7 +1165,7 @@ struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 
 			/* no extra ref when appending to datagram (MSG_MORE) */
 			if (sk->sk_type == SOCK_STREAM)
-				skb_zcopy_get(uarg);
+				net_zcopy_get(uarg);
 
 			return uarg;
 		}
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index ffee03729285..102b1998ba3c 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1230,7 +1230,7 @@ static int __ip_append_data(struct sock *sk,
 error_efault:
 	err = -EFAULT;
 error:
-	skb_zcopy_put_abort(uarg, extra_uref);
+	net_zcopy_put_abort(uarg, extra_uref);
 	cork->length -= length;
 	IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTDISCARDS);
 	refcount_add(wmem_alloc_delta, &sk->sk_wmem_alloc);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1954190b33c7..2267d21c73a6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1429,7 +1429,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		tcp_push(sk, flags, mss_now, tp->nonagle, size_goal);
 	}
 out_nopush:
-	skb_zcopy_put(uarg);
+	net_zcopy_put(uarg);
 	return copied + copied_syn;
 
 do_error:
@@ -1440,7 +1440,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	if (copied + copied_syn)
 		goto out;
 out_err:
-	skb_zcopy_put_abort(uarg, true);
+	net_zcopy_put_abort(uarg, true);
 	err = sk_stream_error(sk, flags, err);
 	/* make sure we wake any epoll edge trigger waiter */
 	if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f59cfa39686a..072ce9678616 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1715,7 +1715,7 @@ static int __ip6_append_data(struct sock *sk,
 error_efault:
 	err = -EFAULT;
 error:
-	skb_zcopy_put_abort(uarg, extra_uref);
+	net_zcopy_put_abort(uarg, extra_uref);
 	cork->length -= length;
 	IP6_INC_STATS(sock_net(sk), rt->rt6i_idev, IPSTATS_MIB_OUTDISCARDS);
 	refcount_add(wmem_alloc_delta, &sk->sk_wmem_alloc);
-- 
2.24.1

