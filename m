Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A45F32362
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 15:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfFBNWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 09:22:30 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:2029 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfFBNWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 09:22:30 -0400
Received: from 10-19-61-167.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 363C8410AF;
        Sun,  2 Jun 2019 21:22:26 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] netfilter: ipv6: Fix undefined symbol nf_ct_frag6_gather
Date:   Sun,  2 Jun 2019 21:22:21 +0800
Message-Id: <1559481741-9604-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kIGBQJHllBWUlVT0lDQkJCQktLQ0pMQ0xZV1koWUFJQjdXWS1ZQUlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6KyI6PBw*ETg6KiFPDTY3NgFW
        PgIKFE9VSlVKTk5CT0NKTE9NSUJDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpOTUs3Bg++
X-HM-Tid: 0a6b185b03392086kuqy363c8410af
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

CONFIG_NETFILTER=m and CONFIG_NF_DEFRAG_IPV6 is not set

ERROR: "nf_ct_frag6_gather" [net/ipv6/ipv6.ko] undefined!

Fixes: c9bb6165a16e ("netfilter: nf_conntrack_bridge: fix CONFIG_IPV6=y")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/ipv6/netfilter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 9530cc2..96d7abf 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -238,8 +238,10 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
 	.reroute		= nf_ip6_reroute,
-#if IS_MODULE(CONFIG_IPV6)
+#if IS_MODULE(CONFIG_IPV6) && IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	.br_defrag		= nf_ct_frag6_gather,
+#endif
+#if IS_MODULE(CONFIG_IPV6)
 	.br_fragment		= br_ip6_fragment,
 #endif
 };
-- 
1.8.3.1

