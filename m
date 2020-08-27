Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA972543E5
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgH0KkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:40:02 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:3547 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbgH0Kj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:39:57 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 5CC0D5C1049;
        Thu, 27 Aug 2020 18:39:53 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, marcelo.leitner@gmail.com
Subject: [PATCH net-next 1/2] ipv6: add ipv6_fragment hook in ipv6_stub
Date:   Thu, 27 Aug 2020 18:39:51 +0800
Message-Id: <1598524792-30597-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598524792-30597-1-git-send-email-wenxu@ucloud.cn>
References: <1598524792-30597-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZHkhNTRhMSRlJSkIYVkpOQkNOSU9MQkhPT0JVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mxw6Czo5Ej4BKxlRDAJNHz8N
        ThIKCjZVSlVKTkJDTklPTEJITk9JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpCTUs3Bg++
X-HM-Tid: 0a742f80a24c2087kuqy5cc0d5c1049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add ipv6_fragment to ipv6_stub to avoid calling netfilter when
access ip6_fragment.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/ipv6_stubs.h | 3 +++
 net/ipv6/af_inet6.c      | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index d7a7f7c..8fce558 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -63,6 +63,9 @@ struct ipv6_stub {
 			       int encap_type);
 #endif
 	struct neigh_table *nd_tbl;
+
+	int (*ipv6_fragment)(struct net *net, struct sock *sk, struct sk_buff *skb,
+			     int (*output)(struct net *, struct sock *, struct sk_buff *));
 };
 extern const struct ipv6_stub *ipv6_stub __read_mostly;
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index d9a1493..e648fbe 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1027,6 +1027,7 @@ static int ipv6_route_input(struct sk_buff *skb)
 	.xfrm6_rcv_encap = xfrm6_rcv_encap,
 #endif
 	.nd_tbl	= &nd_tbl,
+	.ipv6_fragment = ip6_fragment,
 };
 
 static const struct ipv6_bpf_stub ipv6_bpf_stub_impl = {
-- 
1.8.3.1

