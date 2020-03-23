Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D42190224
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 00:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCWXpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 19:45:01 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:42788 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgCWXpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 19:45:00 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E1AA340F15;
        Tue, 24 Mar 2020 07:44:57 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeedm@mellanox.com
Cc:     paulb@mellanox.com, vladbu@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH net-next v5 0/2] net/mlx5e: add indr block support in the FT mode
Date:   Tue, 24 Mar 2020 07:44:55 +0800
Message-Id: <1585007097-28475-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVNTU9CQkJCTUpDTkhLSFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PE06Fyo4Dzg6AhMTCSlCMg1J
        ODlPCz1VSlVKTkNOS0tMS0JDSUhJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlCSUo3Bg++
X-HM-Tid: 0a7109c8f85b2086kuqye1aa340f15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Indr block supported in FT mode can offload the tunnel device in the
flowtables of nftable.

The netfilter patches:
http://patchwork.ozlabs.org/cover/1242812/

Test with mlx driver as following with nft:

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


wenxu (2):
  net/mlx5e: refactor indr setup block
  net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 94 ++++++++++++++++++------
 1 file changed, 73 insertions(+), 21 deletions(-)

-- 
1.8.3.1

