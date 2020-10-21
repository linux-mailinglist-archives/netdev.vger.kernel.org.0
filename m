Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3472A294A85
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 11:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437029AbgJUJ2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 05:28:31 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:16342 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395089AbgJUJ2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 05:28:31 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 4B5E55C0F36
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 17:21:56 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Subject: [PATCH net] ip_tunnel: fix over-mtu packet send fail without TUNNEL_DONT_FRAGMENT flags
Date:   Wed, 21 Oct 2020 17:21:55 +0800
Message-Id: <1603272115-25351-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSUNOSUxLTE8fHksZVkpNS0hJTElKSk1IQkpVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ND46LDo*Dz5WCUo*HzQ0SUIa
        KzBPFB5VSlVKTUtISUxJSkpNTUhMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpPQ0g3Bg++
X-HM-Tid: 0a754a7708592087kuqy4b5e55c0f36
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The TUNNEL_DONT_FRAGMENT flags specific the tunnel outer ip can do
fragment or not in the md mode. Without the TUNNEL_DONT_FRAGMENT
should always do fragment. So it should not care the frag_off in
inner ip.

Fixes: cfc7381b3002 ("ip_tunnel: add collect_md mode to IPIP tunnel")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/ipv4/ip_tunnel.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 8b04d1d..ee65c92 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -608,9 +608,6 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 			ttl = ip4_dst_hoplimit(&rt->dst);
 	}
 
-	if (!df && skb->protocol == htons(ETH_P_IP))
-		df = inner_iph->frag_off & htons(IP_DF);
-
 	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
 	if (headroom > dev->needed_headroom)
 		dev->needed_headroom = headroom;
-- 
1.8.3.1

