Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B56629EACE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 12:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbgJ2Li2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 07:38:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:6988 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgJ2Li2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 07:38:28 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CMNjv3XvxzhdFv;
        Thu, 29 Oct 2020 19:38:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 29 Oct 2020 19:38:16 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <linmiaohe@huawei.com>,
        <martin.varghese@nokia.com>, <pabeni@redhat.com>,
        <pshelar@ovn.org>, <fw@strlen.de>, <gnault@redhat.com>,
        <steffen.klassert@secunet.com>, <kyk.segfault@gmail.com>,
        <viro@zeniv.linux.org.uk>, <vladimir.oltean@nxp.com>,
        <edumazet@google.com>, <saeed@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next] net: add in_softirq() debug checking in napi_consume_skb()
Date:   Thu, 29 Oct 2020 19:34:48 +0800
Message-ID: <1603971288-4786-1-git-send-email-linyunsheng@huawei.com>
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
v1: drop RFC in the title
---
 include/linux/netdevice.h | 6 ++++++
 net/Kconfig               | 7 +++++++
 net/core/skbuff.c         | 4 ++++
 3 files changed, 17 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 964b494..8042bf1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5158,6 +5158,12 @@ do {								\
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
index d656716..82e69b0 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -459,6 +459,13 @@ config ETHTOOL_NETLINK
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
index 1ba8f01..1834007 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -897,6 +897,10 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
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

