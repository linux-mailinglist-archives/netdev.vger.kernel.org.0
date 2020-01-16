Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7087113F764
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387699AbgAPRAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:00:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387685AbgAPRAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCC3E2468B;
        Thu, 16 Jan 2020 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194010;
        bh=M7pKHob5n3us2aSh5joiFKVhkWDKifwR8/doQiFngqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjIvlASfZr+ybAmWjvMsc6s7Dy1Cb0SlLAU8BoSlZutbo7DVYI3fecU5Fgh6BansF
         r9dA1C6pAsSuX5Wa7tEpYUmfnsuON8ReQlpDf1J6zDfkzhzsT1GXrm1IALgatYDrJ8
         GAag5XJS5P+TRupt+VHDrNUZC244F/a0F6PQlrJ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wenxu <wenxu@ucloud.cn>, "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 134/671] ip_tunnel: Fix route fl4 init in ip_md_tunnel_xmit
Date:   Thu, 16 Jan 2020 11:50:43 -0500
Message-Id: <20200116165940.10720-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

[ Upstream commit 6e6b904ad4f9aed43ec320afbd5a52ed8461ab41 ]

Init the gre_key from tuninfo->key.tun_id and init the mark
from the skb->mark, set the oif to zero in the collect metadata
mode.

Fixes: cfc7381b3002 ("ip_tunnel: add collect_md mode to IPIP tunnel")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 420e891ac59d..f03a1b68e70f 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -574,8 +574,9 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev, u8 proto)
 		else if (skb->protocol == htons(ETH_P_IPV6))
 			tos = ipv6_get_dsfield((const struct ipv6hdr *)inner_iph);
 	}
-	ip_tunnel_init_flow(&fl4, proto, key->u.ipv4.dst, key->u.ipv4.src, 0,
-			    RT_TOS(tos), tunnel->parms.link, tunnel->fwmark);
+	ip_tunnel_init_flow(&fl4, proto, key->u.ipv4.dst, key->u.ipv4.src,
+			    tunnel_id_to_key32(key->tun_id), RT_TOS(tos),
+			    0, skb->mark);
 	if (tunnel->encap.type != TUNNEL_ENCAP_NONE)
 		goto tx_error;
 	rt = ip_route_output_key(tunnel->net, &fl4);
-- 
2.20.1

