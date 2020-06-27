Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3628C20BFF9
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 10:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgF0IH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 04:07:29 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:48179 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgF0IH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 04:07:27 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id bea1e8e4;
        Sat, 27 Jun 2020 07:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=Cz702woikBQPXSFMDcaXkR3Bj
        5s=; b=U3nsn0OeI3SnCKIxa+FX+mmzoj6amZ2g3resRkHlEw/THYlKhhefc9oQp
        xzqvlsBgbvX+eD7Q/K8w+VuHblCnyK25VxyR5OG3+SU+tZZYuzBdPmTnM0iuBKWW
        +HN3rCqzlvR0w2vjicj9GjD0hNBFkEC3cjB0WZEmPH4yofmXw/gY3x6jwZh/c/rb
        bmMl0qNffKucERKRm1dfLntzaQhE+LhDG8QSAE0teUHRXDySreEn8fYis5ZWiNwu
        APK+4a17kxTyLM4EEE+P05+IE/dc+6XNOb2uhG4mbKW3KfY1rOPsix/kuw2Bzta2
        XpyalB9SpcqHb10vlX5UQhNHqK2rg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8efff8dc (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 27 Jun 2020 07:48:02 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 1/5] net: ip_tunnel: add header_ops for layer 3 devices
Date:   Sat, 27 Jun 2020 02:07:09 -0600
Message-Id: <20200627080713.179883-2-Jason@zx2c4.com>
In-Reply-To: <20200627080713.179883-1-Jason@zx2c4.com>
References: <20200627080713.179883-1-Jason@zx2c4.com>
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
 include/net/ip_tunnels.h  |  3 +++
 net/ipv4/ip_tunnel_core.c | 19 +++++++++++++++++++
 2 files changed, 22 insertions(+)

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
index 181b7a2a0247..07d958aa03f8 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (c) 2013 Nicira, Inc.
+ * Copyright (C) 2020 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -844,3 +845,21 @@ void ip_tunnel_unneed_metadata(void)
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

