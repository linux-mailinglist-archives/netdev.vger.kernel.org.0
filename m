Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0045E291C9B
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbgJRTYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:24:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730911AbgJRTYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:24:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C8D6222EB;
        Sun, 18 Oct 2020 19:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049087;
        bh=kL3mHtvkjdVI/1qd0rJa0p8tK+xfTgXhxpSVFK5HJho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkaU2M4FqawdP5U98QtRBmlDOWkdhUkJI1Q1VDJU1i8hIoygnvp7TKwn+JlvRPujR
         0pvC1ZkoxxNrQOR3u7i62XVAngr1hyqnULQTbqDtI4zZhQpJ4oKq4E0X3SWPMZkSzu
         rgeO6ufqmAhyWwxlTEkuJg94TRUhRemII57FnxLA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Xie He <xie.he.0141@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 23/56] ip_gre: set dev->hard_header_len and dev->needed_headroom properly
Date:   Sun, 18 Oct 2020 15:23:44 -0400
Message-Id: <20201018192417.4055228-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192417.4055228-1-sashal@kernel.org>
References: <20201018192417.4055228-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit fdafed459998e2be0e877e6189b24cb7a0183224 ]

GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
conditionally. When it is set, it assumes the outer IP header is
already created before ipgre_xmit().

This is not true when we send packets through a raw packet socket,
where L2 headers are supposed to be constructed by user. Packet
socket calls dev_validate_header() to validate the header. But
GRE tunnel does not set dev->hard_header_len, so that check can
be simply bypassed, therefore uninit memory could be passed down
to ipgre_xmit(). Similar for dev->needed_headroom.

dev->hard_header_len is supposed to be the length of the header
created by dev->header_ops->create(), so it should be used whenever
header_ops is set, and dev->needed_headroom should be used when it
is not set.

Reported-and-tested-by: syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com
Cc: William Tu <u9012063@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index ffcb5983107db..de6f89511a216 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -680,9 +680,7 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 	}
 
 	if (dev->header_ops) {
-		/* Need space for new headers */
-		if (skb_cow_head(skb, dev->needed_headroom -
-				      (tunnel->hlen + sizeof(struct iphdr))))
+		if (skb_cow_head(skb, 0))
 			goto free_skb;
 
 		tnl_params = (const struct iphdr *)skb->data;
@@ -800,7 +798,11 @@ static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 	len = tunnel->tun_hlen - len;
 	tunnel->hlen = tunnel->hlen + len;
 
-	dev->needed_headroom = dev->needed_headroom + len;
+	if (dev->header_ops)
+		dev->hard_header_len += len;
+	else
+		dev->needed_headroom += len;
+
 	if (set_mtu)
 		dev->mtu = max_t(int, dev->mtu - len, 68);
 
@@ -1003,6 +1005,7 @@ static void __gre_tunnel_init(struct net_device *dev)
 	tunnel->parms.iph.protocol = IPPROTO_GRE;
 
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen;
+	dev->needed_headroom = tunnel->hlen + sizeof(tunnel->parms.iph);
 
 	dev->features		|= GRE_FEATURES;
 	dev->hw_features	|= GRE_FEATURES;
@@ -1046,10 +1049,14 @@ static int ipgre_tunnel_init(struct net_device *dev)
 				return -EINVAL;
 			dev->flags = IFF_BROADCAST;
 			dev->header_ops = &ipgre_header_ops;
+			dev->hard_header_len = tunnel->hlen + sizeof(*iph);
+			dev->needed_headroom = 0;
 		}
 #endif
 	} else if (!tunnel->collect_md) {
 		dev->header_ops = &ipgre_header_ops;
+		dev->hard_header_len = tunnel->hlen + sizeof(*iph);
+		dev->needed_headroom = 0;
 	}
 
 	return ip_tunnel_init(dev);
-- 
2.25.1

