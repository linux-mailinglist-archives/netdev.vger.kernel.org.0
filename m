Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E4441F98
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 10:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731863AbfFLIrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 04:47:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18138 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726636AbfFLIrm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 04:47:42 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DB3D0222C3369D7533CC;
        Wed, 12 Jun 2019 16:47:38 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Wed, 12 Jun 2019
 16:47:28 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>, <fw@strlen.de>,
        <davem@davemloft.net>, <rdunlap@infradead.org>
CC:     <linux-kernel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] netfilter: ipv6: Fix build error without CONFIG_IPV6
Date:   Wed, 12 Jun 2019 16:47:15 +0800
Message-ID: <20190612084715.21656-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_IPV6 is not set, building fails:

net/bridge/netfilter/nf_conntrack_bridge.o: In function `nf_ct_bridge_pre':
nf_conntrack_bridge.c:(.text+0x41c): undefined symbol `nf_ct_frag6_gather'
net/bridge/netfilter/nf_conntrack_bridge.o: In function `nf_ct_bridge_post':
nf_conntrack_bridge.c:(.text+0x820): undefined symbol `br_ip6_fragment'

Reported-by: Hulk Robot <hulkci@huawei.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: c9bb6165a16e ("netfilter: nf_conntrack_bridge: fix CONFIG_IPV6=y")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 include/linux/netfilter_ipv6.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 3a3dc4b..0e1febc 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -108,8 +108,11 @@ static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
 		return 1;
 
 	return v6_ops->br_defrag(net, skb, user);
-#else
+#endif
+#if IS_BUILTIN(CONFIG_IPV6)
 	return nf_ct_frag6_gather(net, skb, user);
+#else
+	return 1;
 #endif
 }
 
@@ -133,8 +136,11 @@ static inline int nf_br_ip6_fragment(struct net *net, struct sock *sk,
 		return 1;
 
 	return v6_ops->br_fragment(net, sk, skb, data, output);
-#else
+#endif
+#if IS_BUILTIN(CONFIG_IPV6)
 	return br_ip6_fragment(net, sk, skb, data, output);
+#else
+	return 1;
 #endif
 }
 
-- 
2.7.4


