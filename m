Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2D812A716
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 10:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfLYJsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 04:48:30 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:26273 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfLYJs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 04:48:29 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 27F4841AF8;
        Wed, 25 Dec 2019 17:48:24 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, paulb@mellanox.com, netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, jiri@mellanox.com
Subject: [PATCH net-next 0/5] netfilter: add indr block setup in nf_flow_table_offload
Date:   Wed, 25 Dec 2019 17:48:18 +0800
Message-Id: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0lCQkJCQklITEtNSllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PjI6CAw6EDg1C0JOMBc2MhEc
        IUoaCi9VSlVKTkxMSU1MSEtPSElKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhOQkM3Bg++
X-HM-Tid: 0a6f3c7516fb2086kuqy27f4841af8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch provide tunnel offload in nf_flow_table_offload based on
route lwtunnel. 
The first patch add TC_SETP_FT type in flow_indr_block_call.
The next two patches add support indr callback setup in flowtable offload.
The last two patches add tunnel match and action offload.

Test with mlx driver as following:

ip link add user1 type vrf table 1
ip l set user1 up 
ip l set dev mlx_pf0vf0 down
ip l set dev mlx_pf0vf0 master user1
ifconfig mlx_pf0vf0 10.0.0.1/24 up

ifconfig mlx_p0 172.168.152.75/24 up

ip l add dev tun1 type gretap key 1000
ip l set dev tun1 master user1
ifconfig tun1 10.0.1.1/24 up

ip r r 10.0.1.241 encap ip id 1000 dst 172.168.152.241 key dev tun1 table 1

nft add table firewall
nft add chain firewall zones { type filter hook prerouting priority - 300 \; }
nft add rule firewall zones counter ct zone set iif map { "tun1" : 1, "mlx_pf0vf0" : 1 }
nft add chain firewall rule-1000-ingress
nft add rule firewall rule-1000-ingress ct zone 1 ct state established,related counter accept
nft add rule firewall rule-1000-ingress ct zone 1 ct state invalid counter drop
nft add rule firewall rule-1000-ingress ct zone 1 tcp dport 5001 ct state new counter accept
nft add rule firewall rule-1000-ingress ct zone 1 udp dport 5001 ct state new counter accept
nft add rule firewall rule-1000-ingress ct zone 1 tcp dport 22 ct state new counter accept
nft add rule firewall rule-1000-ingress ct zone 1 ip protocol icmp ct state new counter accept
nft add rule firewall rule-1000-ingress counter drop
nft add chain firewall rules-all { type filter hook prerouting priority - 150 \; }
nft add rule firewall rules-all meta iifkind "vrf" counter accept
nft add rule firewall rules-all iif vmap { "tun1" : jump rule-1000-ingress }

nft add flowtable firewall fb1 { hook ingress priority 2 \; devices = { tun1, mlx_pf0vf0 } \; }
nft add chain firewall ftb-all {type filter hook forward priority 0 \; policy accept \; }
nft add rule firewall ftb-all ct zone 1 ip protocol tcp flow offload @fb1
nft add rule firewall ftb-all ct zone 1 ip protocol udp flow offload @fb1


wenxu (5):
  flow_offload: add TC_SETP_FT type in flow_indr_block_call
  netfilter: nf_flow_table_offload: refactor nf_flow_table_offload_setup
    to support indir setup
  netfilter: nf_flow_table_offload: add indr block setup support
  netfilter: nf_flow_table_offload: add tunnel match offload support
  netfilter: nf_flow_table_offload: add tunnel encap/decap action
    offload support

 include/net/flow_offload.h            |   3 +-
 net/core/flow_offload.c               |   6 +-
 net/netfilter/nf_flow_table_offload.c | 253 +++++++++++++++++++++++++++++++---
 net/netfilter/nf_tables_offload.c     |   2 +-
 net/sched/cls_api.c                   |   2 +-
 5 files changed, 243 insertions(+), 23 deletions(-)

-- 
1.8.3.1

