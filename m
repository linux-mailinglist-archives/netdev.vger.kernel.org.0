Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629E620EAA3
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgF3BGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:06:40 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:60171 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgF3BGj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:06:39 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b9c2aa66;
        Tue, 30 Jun 2020 00:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=R30iPEA3kGpRlXyH+u+OY6kpV
        j0=; b=XEry14lBpFDbO3+ezVRNpL9Bo2UX5mK8G9Qn+ygAPlQVvzUKufbFlcwJY
        Wb8424JH0f9fM0EsT6GG79hJcYUG1WbWdAFGTP6Rpap2twxCL7OxMLA4TetLnQ9F
        7soa6MRAV/f5kbZKVgeJpBioo1bBZHZcn2p6Z1RZa0b7tY/9PKVo4OF84NZKUg34
        nNHIUwmg2ugVtueq6jyqeuJaejxKKrVb3iWYn2znoYAYtMA8xkbW/6wyq0oD6vcv
        C4lNzf5CSbvDQv04655VgYKeoDAR8v07fzsfcrokvsFlnfCNrspO8SxpxXlIo+Ro
        RXGFdhunnNQUkp0Z03T5WB+EyheVA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3d06bb00 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 30 Jun 2020 00:46:54 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net v2 1/8] net: ip_tunnel: add header_ops for layer 3 devices
Date:   Mon, 29 Jun 2020 19:06:18 -0600
Message-Id: <20200630010625.469202-2-Jason@zx2c4.com>
In-Reply-To: <20200630010625.469202-1-Jason@zx2c4.com>
References: <20200630010625.469202-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices that take straight up layer 3 packets benefit from having a
shared header_ops so that AF_PACKET sockets can inject packets that are
recognized. This shared infrastructure will be used by other drivers
that currently can't inject packets using AF_PACKET. It also exposes the
parser function, as it is useful in standalone form too.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Changes v1->v2:
- [Willem] Remove added copyright header from v1.

 include/net/ip_tunnels.h  |  3 +++
 net/ipv4/ip_tunnel_core.c | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 076e5d7db7d3..36025dea7612 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -290,6 +290,9 @@ int ip_tunnel_newlink(struct net_device *dev, struct nlattr *tb[],
 		      struct ip_tunnel_parm *p, __u32 fwmark);
 void ip_tunnel_setup(struct net_device *dev, unsigned int net_id);
 
+extern const struct header_ops ip_tunnel_header_ops;
+__be16 ip_tunnel_parse_protocol(const struct sk_buff *skb);
+
 struct ip_tunnel_encap_ops {
 	size_t (*encap_hlen)(struct ip_tunnel_encap *e);
 	int (*build_header)(struct sk_buff *skb, struct ip_tunnel_encap *e,
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 181b7a2a0247..f8b419e2475c 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -844,3 +844,21 @@ void ip_tunnel_unneed_metadata(void)
 	static_branch_dec(&ip_tunnel_metadata_cnt);
 }
 EXPORT_SYMBOL_GPL(ip_tunnel_unneed_metadata);
+
+/* Returns either the correct skb->protocol value, or 0 if invalid. */
+__be16 ip_tunnel_parse_protocol(const struct sk_buff *skb)
+{
+	if (skb_network_header(skb) >= skb->head &&
+	    (skb_network_header(skb) + sizeof(struct iphdr)) <= skb_tail_pointer(skb) &&
+	    ip_hdr(skb)->version == 4)
+		return htons(ETH_P_IP);
+	if (skb_network_header(skb) >= skb->head &&
+	    (skb_network_header(skb) + sizeof(struct ipv6hdr)) <= skb_tail_pointer(skb) &&
+	    ipv6_hdr(skb)->version == 6)
+		return htons(ETH_P_IPV6);
+	return 0;
+}
+EXPORT_SYMBOL(ip_tunnel_parse_protocol);
+
+const struct header_ops ip_tunnel_header_ops = { .parse_protocol = ip_tunnel_parse_protocol };
+EXPORT_SYMBOL(ip_tunnel_header_ops);
-- 
2.27.0

