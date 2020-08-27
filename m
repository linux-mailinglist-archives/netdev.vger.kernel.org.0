Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B022543E6
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgH0Kj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:39:58 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:3549 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgH0Kj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:39:56 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 893285C1741;
        Thu, 27 Aug 2020 18:39:53 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, marcelo.leitner@gmail.com
Subject: [PATCH net-next 2/2] openvswitch: using ip6_fragment in ipv6_stub
Date:   Thu, 27 Aug 2020 18:39:52 +0800
Message-Id: <1598524792-30597-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598524792-30597-1-git-send-email-wenxu@ucloud.cn>
References: <1598524792-30597-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSkoZSB0fHkoYQ00fVkpOQkNOSU9MQkhNS0xVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NAw6HBw*ET4CERkuDAMpHzIB
        TTIKC09VSlVKTkJDTklPTEJITElKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJQ0M3Bg++
X-HM-Tid: 0a742f80a2e92087kuqy893285c1741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Using ipv6_stub->ipv6_fragment to avoid the netfilter dependency

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/openvswitch/actions.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 2611657..1f3d406 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -9,7 +9,6 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/openvswitch.h>
-#include <linux/netfilter_ipv6.h>
 #include <linux/sctp.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
@@ -848,11 +847,10 @@ static void ovs_fragment(struct net *net, struct vport *vport,
 		ip_do_fragment(net, skb->sk, skb, ovs_vport_output);
 		refdst_drop(orig_dst);
 	} else if (key->eth.type == htons(ETH_P_IPV6)) {
-		const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
 		unsigned long orig_dst;
 		struct rt6_info ovs_rt;
 
-		if (!v6ops)
+		if (!ipv6_stub->ipv6_fragment)
 			goto err;
 
 		prepare_frag(vport, skb, orig_network_offset,
@@ -866,7 +864,7 @@ static void ovs_fragment(struct net *net, struct vport *vport,
 		skb_dst_set_noref(skb, &ovs_rt.dst);
 		IP6CB(skb)->frag_max_size = mru;
 
-		v6ops->fragment(net, skb->sk, skb, ovs_vport_output);
+		ipv6_stub->ipv6_fragment(net, skb->sk, skb, ovs_vport_output);
 		refdst_drop(orig_dst);
 	} else {
 		WARN_ONCE(1, "Failed fragment ->%s: eth=%04x, MRU=%d, MTU=%d.",
-- 
1.8.3.1

