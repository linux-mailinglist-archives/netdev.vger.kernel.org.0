Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774553EF8AC
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 05:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237277AbhHRDee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 23:34:34 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8874 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237271AbhHRDeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 23:34:24 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GqD0n3445z8sZf;
        Wed, 18 Aug 2021 11:29:45 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:29 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:28 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <alexander.duyck@gmail.com>, <linux@armlinux.org.uk>,
        <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <memxor@gmail.com>, <linux@rempel-privat.de>, <atenart@kernel.org>,
        <weiwan@google.com>, <ap420073@gmail.com>, <arnd@arndb.de>,
        <mathew.j.martineau@linux.intel.com>, <aahringo@redhat.com>,
        <ceggers@arri.de>, <yangbo.lu@nxp.com>, <fw@strlen.de>,
        <xiangxia.m.yue@gmail.com>, <linmiaohe@huawei.com>
Subject: [PATCH RFC 5/7] sock: support refilling pfrag from pfrag_pool
Date:   Wed, 18 Aug 2021 11:32:21 +0800
Message-ID: <1629257542-36145-6-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As previous patch has added pfrag pool based on the page
pool, so support refilling pfrag from the new pfrag pool
for tcpv4.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/sock.h |  1 +
 net/core/sock.c    |  9 +++++++++
 net/ipv4/tcp.c     | 34 ++++++++++++++++++++++++++--------
 3 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 6e76145..af40084 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -455,6 +455,7 @@ struct sock {
 	unsigned long		sk_pacing_rate; /* bytes per second */
 	unsigned long		sk_max_pacing_rate;
 	struct page_frag	sk_frag;
+	struct pfrag_pool	*sk_frag_pool;
 	netdev_features_t	sk_route_caps;
 	netdev_features_t	sk_route_nocaps;
 	netdev_features_t	sk_route_forced_caps;
diff --git a/net/core/sock.c b/net/core/sock.c
index aada649..53152c9 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -140,6 +140,7 @@
 #include <net/busy_poll.h>
 
 #include <linux/ethtool.h>
+#include <net/pfrag_pool.h>
 
 static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
@@ -1934,6 +1935,11 @@ static void __sk_destruct(struct rcu_head *head)
 		put_page(sk->sk_frag.page);
 		sk->sk_frag.page = NULL;
 	}
+	if (sk->sk_frag_pool) {
+		pfrag_pool_flush(sk->sk_frag_pool);
+		kfree(sk->sk_frag_pool);
+		sk->sk_frag_pool = NULL;
+	}
 
 	if (sk->sk_peer_cred)
 		put_cred(sk->sk_peer_cred);
@@ -3134,6 +3140,9 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 	sk->sk_frag.page	=	NULL;
 	sk->sk_frag.offset	=	0;
+
+	sk->sk_frag_pool = kzalloc(sizeof(*sk->sk_frag_pool), sk->sk_allocation);
+
 	sk->sk_peek_off		=	-1;
 
 	sk->sk_peer_pid 	=	NULL;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f931def..992dcbc 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -280,6 +280,7 @@
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
 #include <net/busy_poll.h>
+#include <net/pfrag_pool.h>
 
 /* Track pending CMSGs. */
 enum {
@@ -1337,12 +1338,20 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			if (err)
 				goto do_fault;
 		} else if (!zc) {
-			bool merge = true;
+			bool merge = true, pfrag_pool = true;
 			int i = skb_shinfo(skb)->nr_frags;
-			struct page_frag *pfrag = sk_page_frag(sk);
+			struct page_frag *pfrag;
 
-			if (!sk_page_frag_refill(sk, pfrag))
-				goto wait_for_space;
+			pfrag_pool_updata_napi(sk->sk_frag_pool,
+					       READ_ONCE(sk->sk_napi_id));
+			pfrag = pfrag_pool_refill(sk->sk_frag_pool, sk->sk_allocation);
+			if (!pfrag) {
+				pfrag = sk_page_frag(sk);
+				if (!sk_page_frag_refill(sk, pfrag))
+					goto wait_for_space;
+
+				pfrag_pool = false;
+			}
 
 			if (!skb_can_coalesce(skb, i, pfrag->page,
 					      pfrag->offset)) {
@@ -1369,11 +1378,20 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			if (merge) {
 				skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
 			} else {
-				skb_fill_page_desc(skb, i, pfrag->page,
-						   pfrag->offset, copy);
-				page_ref_inc(pfrag->page);
+				if (pfrag_pool) {
+					skb_fill_pp_page_desc(skb, i, pfrag->page,
+							      pfrag->offset, copy);
+				} else {
+					page_ref_inc(pfrag->page);
+					skb_fill_page_desc(skb, i, pfrag->page,
+							   pfrag->offset, copy);
+				}
 			}
-			pfrag->offset += copy;
+
+			if (pfrag_pool)
+				pfrag_pool_commit(sk->sk_frag_pool, copy, merge);
+			else
+				pfrag->offset += copy;
 		} else {
 			if (!sk_wmem_schedule(sk, copy))
 				goto wait_for_space;
-- 
2.7.4

