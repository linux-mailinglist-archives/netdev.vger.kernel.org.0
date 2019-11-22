Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C59A10626F
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbfKVGDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:03:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbfKVGC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 01:02:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE25C20726;
        Fri, 22 Nov 2019 06:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402577;
        bh=DgcQXiIgyHSxGbSxUc51xg1P7nmKC/rS5icNxdhZ+EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3YIyOxuTF+QDDprStkjPVmgwMF0aOFWrPzxj/ZC1Uo8ufathvYC0Z1Pi7dm9y2o9
         oiKm5n71FCUfV9RNmrQSbuiWDxFOVA2HE2qm03DlQTELK3C6FoaqVkTG9g7EkbUuaS
         FNe61WXUp025laJ1Zs4oFhu9++LyH5qOZSjuvtMY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wenxu <wenxu@ucloud.cn>, "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 79/91] ip_tunnel: Make none-tunnel-dst tunnel port work with lwtunnel
Date:   Fri, 22 Nov 2019 01:01:17 -0500
Message-Id: <20191122060129.4239-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

[ Upstream commit d71b57532d70c03f4671dd04e84157ac6bf021b0 ]

ip l add dev tun type gretap key 1000
ip a a dev tun 10.0.0.1/24

Packets with tun-id 1000 can be recived by tun dev. But packet can't
be sent through dev tun for non-tunnel-dst

With this patch: tunnel-dst can be get through lwtunnel like beflow:
ip r a 10.0.0.7 encap ip dst 172.168.0.11 dev tun

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index e6ee6acac80c4..a4db2d79b9134 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -653,13 +653,19 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	dst = tnl_params->daddr;
 	if (dst == 0) {
 		/* NBMA tunnel */
+		struct ip_tunnel_info *tun_info;
 
 		if (!skb_dst(skb)) {
 			dev->stats.tx_fifo_errors++;
 			goto tx_error;
 		}
 
-		if (skb->protocol == htons(ETH_P_IP)) {
+		tun_info = skb_tunnel_info(skb);
+		if (tun_info && (tun_info->mode & IP_TUNNEL_INFO_TX) &&
+		    ip_tunnel_info_af(tun_info) == AF_INET &&
+		    tun_info->key.u.ipv4.dst)
+			dst = tun_info->key.u.ipv4.dst;
+		else if (skb->protocol == htons(ETH_P_IP)) {
 			rt = skb_rtable(skb);
 			dst = rt_nexthop(rt, inner_iph->daddr);
 		}
-- 
2.20.1

