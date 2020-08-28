Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA48D255D9A
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 17:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgH1PRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 11:17:13 -0400
Received: from mail-proxy25223.qiye.163.com ([103.129.252.23]:12070 "EHLO
        mail-proxy25223.qiye.163.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728222AbgH1PQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 11:16:54 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 837DA5C1646
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 23:14:33 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/2] openvswitch: using ip6_fragment in ipv6_stub
Date:   Fri, 28 Aug 2020 23:14:32 +0800
Message-Id: <1598627672-10439-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598627672-10439-1-git-send-email-wenxu@ucloud.cn>
References: <1598627672-10439-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGkNJSBpDSUpDSUwaVkpOQkNNSUxNTEhOTkxVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ODI6Fio6Cz4MKxk#IU4RIxMa
        STIKFD1VSlVKTkJDTUlMTUxITE9MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJSEg3Bg++
X-HM-Tid: 0a7435a275c72087kuqy837da5c1646
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Using ipv6_stub->ipv6_fragment to avoid the netfilter dependency

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/openvswitch/actions.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 2611657..fd34089 100644
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
@@ -848,13 +847,9 @@ static void ovs_fragment(struct net *net, struct vport *vport,
 		ip_do_fragment(net, skb->sk, skb, ovs_vport_output);
 		refdst_drop(orig_dst);
 	} else if (key->eth.type == htons(ETH_P_IPV6)) {
-		const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
 		unsigned long orig_dst;
 		struct rt6_info ovs_rt;
 
-		if (!v6ops)
-			goto err;
-
 		prepare_frag(vport, skb, orig_network_offset,
 			     ovs_key_mac_proto(key));
 		memset(&ovs_rt, 0, sizeof(ovs_rt));
@@ -866,7 +861,7 @@ static void ovs_fragment(struct net *net, struct vport *vport,
 		skb_dst_set_noref(skb, &ovs_rt.dst);
 		IP6CB(skb)->frag_max_size = mru;
 
-		v6ops->fragment(net, skb->sk, skb, ovs_vport_output);
+		ipv6_stub->ipv6_fragment(net, skb->sk, skb, ovs_vport_output);
 		refdst_drop(orig_dst);
 	} else {
 		WARN_ONCE(1, "Failed fragment ->%s: eth=%04x, MRU=%d, MTU=%d.",
-- 
1.8.3.1

