Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023BA274112
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 13:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgIVLkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 07:40:12 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13823 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726454AbgIVLkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 07:40:03 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5966745496516D02CC23;
        Tue, 22 Sep 2020 19:40:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Tue, 22 Sep 2020 19:39:53 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <linmiaohe@huawei.com>,
        <martin.varghese@nokia.com>, <fw@strlen.de>, <edumazet@google.com>,
        <dcaratti@redhat.com>, <steffen.klassert@secunet.com>,
        <pabeni@redhat.com>, <kyk.segfault@gmail.com>, <saeed@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH RFC] net: add in_softirq() debug checking in napi_consume_skb()
Date:   Tue, 22 Sep 2020 19:36:21 +0800
Message-ID: <1600774581-150072-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current semantic for napi_consume_skb() is that caller need
to provide non-zero budget when calling from NAPI context, and
breaking this semantic will cause hard to debug problem, because
_kfree_skb_defer() need to run in atomic context in order to push
the skb to the particular cpu' napi_alloc_cache atomically.

So add a in_softirq() debug checking in napi_consume_skb() to catch
this kind of error.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/netdevice.h | 6 ++++++
 net/Kconfig               | 7 +++++++
 net/core/skbuff.c         | 4 ++++
 3 files changed, 17 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fef0eb9..e06d5e5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5095,6 +5095,12 @@ do {								\
 })
 #endif
 
+#if defined(CONFIG_DEBUG_NET)
+#define DEBUG_NET_WARN(condition, ...)	WARN(condition, ##__VA_ARGS__)
+#else
+#define DEBUG_NET_WARN(condition, ...)
+#endif
+
 /*
  *	The list of packet types we will receive (as opposed to discard)
  *	and the routines to invoke.
diff --git a/net/Kconfig b/net/Kconfig
index 3831206..b176670 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -460,6 +460,13 @@ config ETHTOOL_NETLINK
 	  netlink. It provides better extensibility and some new features,
 	  e.g. notification messages.
 
+config DEBUG_NET
+	bool "Net debugging and diagnostics"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  Say Y here to add some extra checks and diagnostics to networking.
+
 endif   # if NET
 
 # Used by archs to tell that they support BPF JIT compiler plus which flavour.
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e077447..378e66c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -901,6 +901,10 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 		return;
 	}
 
+	DEBUG_NET_WARN(!in_softirq(),
+		       "%s is called with non-zero budget outside softirq context.\n",
+		       __func__);
+
 	if (!skb_unref(skb))
 		return;
 
-- 
2.8.1

