Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3673A75444
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 18:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbfGYQkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 12:40:46 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:2359 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbfGYQkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 12:40:46 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.17]) by rmmx-syy-dmz-app10-12010 (RichMail) with SMTP id 2eea5d39db803aa-2e984; Fri, 26 Jul 2019 00:40:32 +0800 (CST)
X-RM-TRANSID: 2eea5d39db803aa-2e984
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee95d39db7fe7d-57bd5;
        Fri, 26 Jul 2019 00:40:32 +0800 (CST)
X-RM-TRANSID: 2ee95d39db7fe7d-57bd5
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH] ip6_tunnel: fix possible use-after-free on xmit
Date:   Fri, 26 Jul 2019 00:40:17 +0800
Message-Id: <1564072817-13240-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip4ip6/ip6ip6 tunnels run iptunnel_handle_offloads on xmit which
can cause a possible use-after-free accessing iph/ipv6h pointer
since the packet will be 'uncloned' running pskb_expand_head if
it is a cloned gso skb.

Fixes: 0e9a709560db ("ip6_tunnel, ip6_gre: fix setting of DSCP on encapsulated packets")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
 net/ipv6/ip6_tunnel.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 3134fbb..754a484 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1278,12 +1278,11 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	}
 
 	fl6.flowi6_uid = sock_net_uid(dev_net(dev), NULL);
+	dsfield = INET_ECN_encapsulate(dsfield, ipv4_get_dsfield(iph));
 
 	if (iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6))
 		return -1;
 
-	dsfield = INET_ECN_encapsulate(dsfield, ipv4_get_dsfield(iph));
-
 	skb_set_inner_ipproto(skb, IPPROTO_IPIP);
 
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
@@ -1367,12 +1366,11 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	}
 
 	fl6.flowi6_uid = sock_net_uid(dev_net(dev), NULL);
+	dsfield = INET_ECN_encapsulate(dsfield, ipv6_get_dsfield(ipv6h));
 
 	if (iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6))
 		return -1;
 
-	dsfield = INET_ECN_encapsulate(dsfield, ipv6_get_dsfield(ipv6h));
-
 	skb_set_inner_ipproto(skb, IPPROTO_IPV6);
 
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
-- 
1.8.3.1



