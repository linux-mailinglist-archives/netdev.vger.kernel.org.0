Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A5329FC38
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 04:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgJ3DcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 23:32:13 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:55938 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgJ3DcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 23:32:12 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id E91385C1876;
        Fri, 30 Oct 2020 11:32:08 +0800 (CST)
From:   wenxu@ucloud.cn
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net v2] ip_tunnel: fix over-mtu packet send fail without TUNNEL_DONT_FRAGMENT flags
Date:   Fri, 30 Oct 2020 11:32:08 +0800
Message-Id: <1604028728-31100-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZHkkeTR9JTEwaSx1NVkpNS09LSUNMSUJLSk1VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pxw6Pyo6Nj5NHU4JCAw9DEIi
        HTRPCxxVSlVKTUtPS0lDTElCSk5PVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpDQk43Bg++
X-HM-Tid: 0a757790068a2087kuqye91385c1876
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The tunnel dvice such as vxlan, bareudp  and geneve in the lwt mode set
the outer df only based TUNNEL_DONT_FRAGMENT. 
And this is also the some behavior for gre device before switching to use 
ip_md_tunnel_xmit as the following patch.

962924f ip_gre: Refactor collect metatdata mode tunnel xmit to 
ip_md_tunnel_xmit

When the ip_gre in lwt mode xmit with ip_md_tunnel_xmi changed the rule and
make the discrepancy between handling of DF by different tunnels. So in the
ip_md_tunnel_xmit should follow the same rule like other tunnels.

Fixes: cfc7381b3002 ("ip_tunnel: add collect_md mode to IPIP tunnel")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: amend the commit message

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

