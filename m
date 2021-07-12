Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DFB3C40A9
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhGLA64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:58:56 -0400
Received: from novek.ru ([213.148.174.62]:38598 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231928AbhGLA6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 20:58:54 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 29EC8503DBD;
        Mon, 12 Jul 2021 03:53:50 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 29EC8503DBD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626051231; bh=GlvJLZw8Yg8LyNXhz51DQL83Jyduqxf7+JQJQAsTtlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ek1ntYiLPPuMgxWXx9Evq+Lt+HDhl4EUbsWdWvHJuCrbDY60b5SfUpRQTD+aP0bKL
         LwiajqxyqvqJACHeRXTAnblK7Wte+V/u9+LtzqtVrrKHyagitIESYtQs0WrnoBbAdk
         825fCbRhk7r55Q6rTICXZe9sBiPfAlVYFxKahb3U=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net 2/3] udp: check encap socket in __udp_lib_err
Date:   Mon, 12 Jul 2021 03:55:53 +0300
Message-Id: <20210712005554.26948-3-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210712005554.26948-1-vfedorenko@novek.ru>
References: <20210712005554.26948-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
added checks for encapsulated sockets but it broke cases when there is
no implementation of encap_err_lookup for encapsulation, i.e. ESP in
UDP encapsulation. Fix it by calling encap_err_lookup only if socket
implements this method otherwise treat it as legal socket.

Fixes: d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/ipv4/udp.c | 24 +++++++++++++++++++++++-
 net/ipv6/udp.c | 22 ++++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index e5cb7fedfbcd..4980e0f19990 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -707,7 +707,29 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
 			       iph->saddr, uh->source, skb->dev->ifindex,
 			       inet_sdif(skb), udptable, NULL);
-	if (!sk || udp_sk(sk)->encap_enabled) {
+	if (sk && udp_sk(sk)->encap_enabled) {
+		int (*lookup)(struct sock *sk, struct sk_buff *skb);
+
+		lookup = READ_ONCE(udp_sk(sk)->encap_err_lookup);
+		if (lookup) {
+			int network_offset, transport_offset;
+
+			network_offset = skb_network_offset(skb);
+			transport_offset = skb_transport_offset(skb);
+
+			/* Network header needs to point to the outer IPv4 header inside ICMP */
+			skb_reset_network_header(skb);
+
+			/* Transport header needs to point to the UDP header */
+			skb_set_transport_header(skb, iph->ihl << 2);
+			if (lookup(sk, skb))
+				sk = NULL;
+			skb_set_transport_header(skb, transport_offset);
+			skb_set_network_header(skb, network_offset);
+		}
+	}
+
+	if (!sk) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udp_encap_needed_key)) {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 798916d2e722..ed49a8589d9f 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -558,6 +558,28 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
 			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
+	if (sk && udp_sk(sk)->encap_enabled) {
+		int (*lookup)(struct sock *sk, struct sk_buff *skb);
+
+		lookup = READ_ONCE(udp_sk(sk)->encap_err_lookup);
+		if (lookup) {
+			int network_offset, transport_offset;
+
+			network_offset = skb_network_offset(skb);
+			transport_offset = skb_transport_offset(skb);
+
+			/* Network header needs to point to the outer IPv6 header inside ICMP */
+			skb_reset_network_header(skb);
+
+			/* Transport header needs to point to the UDP header */
+			skb_set_transport_header(skb, offset);
+			if (lookup(sk, skb))
+				sk = NULL;
+			skb_set_transport_header(skb, transport_offset);
+			skb_set_network_header(skb, network_offset);
+		}
+	}
+
 	if (!sk || udp_sk(sk)->encap_enabled) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
-- 
2.18.4

