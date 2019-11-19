Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6823101A05
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 08:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfKSHI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 02:08:57 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:27053 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfKSHI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 02:08:56 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 1BE8B41651;
        Tue, 19 Nov 2019 15:08:52 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] ip_gre: Make none-tun-dst gre tunnel keep tunnel info
Date:   Tue, 19 Nov 2019 15:08:51 +0800
Message-Id: <1574147331-31096-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIT0xLS0tKSUlLTEtISllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6KxA6ATo5DTg8NQhJHDARQy8O
        CDIwFE5VSlVKTkxPSk9MSEhJSk1KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlPTUg3Bg++
X-HM-Tid: 0a6e827e18202086kuqy1be8b41651
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Currently only collect_md gre tunnel keep tunnel info.
But the nono-tun-dst gre tunnel already can send packte through
lwtunnel.

For non-tun-dst gre tunnel should keep the tunnel info to make
the arp response can send success through the tunnel_info in
iptunnel_metadata_reply.

The following is the test script:

ip netns add cl
ip l add dev vethc type veth peer name eth0 netns cl

ifconfig vethc 172.168.0.7/24 up
ip l add dev tun1000 type gretap key 1000

ip link add user1000 type vrf table 1
ip l set user1000 up
ip l set dev tun1000 master user1000
ifconfig tun1000 10.0.1.1/24 up

ip netns exec cl ifconfig eth0 172.168.0.17/24 up
ip netns exec cl ip l add dev tun type gretap local 172.168.0.17 remote 172.168.0.7 key 1000
ip netns exec cl ifconfig tun 10.0.1.7/24 up
ip r r 10.0.1.7 encap ip id 1000 dst 172.168.0.17 key dev tun1000 table 1

With this patch
ip netns exec cl ping 10.0.1.1 can success

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/ipv4/ip_gre.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 10636fb..572b630 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -340,6 +340,8 @@ static int __ipgre_rcv(struct sk_buff *skb, const struct tnl_ptk_info *tpi,
 				  iph->saddr, iph->daddr, tpi->key);
 
 	if (tunnel) {
+		const struct iphdr *tnl_params;
+
 		if (__iptunnel_pull_header(skb, hdr_len, tpi->proto,
 					   raw_proto, false) < 0)
 			goto drop;
@@ -348,7 +350,9 @@ static int __ipgre_rcv(struct sk_buff *skb, const struct tnl_ptk_info *tpi,
 			skb_pop_mac_header(skb);
 		else
 			skb_reset_mac_header(skb);
-		if (tunnel->collect_md) {
+
+		tnl_params = &tunnel->parms.iph;
+		if (tunnel->collect_md || tnl_params->daddr == 0) {
 			__be16 flags;
 			__be64 tun_id;
 
-- 
1.8.3.1

