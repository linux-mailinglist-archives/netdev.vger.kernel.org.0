Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCB542725F
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 22:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhJHUhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 16:37:50 -0400
Received: from mailout3.hostsharing.net ([176.9.242.54]:33605 "EHLO
        mailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbhJHUht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 16:37:49 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 5C2111034F9CB;
        Fri,  8 Oct 2021 22:35:52 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 267C260272E6;
        Fri,  8 Oct 2021 22:35:52 +0200 (CEST)
X-Mailbox-Line: From 732e7c0a386a0a4a22201db433122dbf82d14808 Mon Sep 17 00:00:00 2001
Message-Id: <732e7c0a386a0a4a22201db433122dbf82d14808.1633693519.git.lukas@wunner.de>
In-Reply-To: <cover.1633693519.git.lukas@wunner.de>
References: <cover.1633693519.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Fri, 8 Oct 2021 22:06:04 +0200
Subject: [PATCH nf-next v6 4/4] af_packet: Introduce egress hook
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        "Laura Garcia Liebana" <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Willem de Bruijn" <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Add egress hook for AF_PACKET sockets that have the PACKET_QDISC_BYPASS
socket option set to on, which allows packets to escape without being
filtered in the egress path.

This patch only updates the AF_PACKET path, it does not update
dev_direct_xmit() so the XDP infrastructure has a chance to bypass
Netfilter.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[lukas: acquire rcu_read_lock, fix typos, rebase]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 net/packet/af_packet.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 2a2bc64f75cf..46943a18a10d 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -91,6 +91,7 @@
 #endif
 #include <linux/bpf.h>
 #include <net/compat.h>
+#include <linux/netfilter_netdev.h>
 
 #include "internal.h"
 
@@ -241,8 +242,42 @@ struct packet_skb_cb {
 static void __fanout_unlink(struct sock *sk, struct packet_sock *po);
 static void __fanout_link(struct sock *sk, struct packet_sock *po);
 
+#ifdef CONFIG_NETFILTER_EGRESS
+static noinline struct sk_buff *nf_hook_direct_egress(struct sk_buff *skb)
+{
+	struct sk_buff *next, *head = NULL, *tail;
+	int rc;
+
+	rcu_read_lock();
+	for (; skb != NULL; skb = next) {
+		next = skb->next;
+		skb_mark_not_on_list(skb);
+
+		if (!nf_hook_egress(skb, &rc, skb->dev))
+			continue;
+
+		if (!head)
+			head = skb;
+		else
+			tail->next = skb;
+
+		tail = skb;
+	}
+	rcu_read_unlock();
+
+	return head;
+}
+#endif
+
 static int packet_direct_xmit(struct sk_buff *skb)
 {
+#ifdef CONFIG_NETFILTER_EGRESS
+	if (nf_hook_egress_active()) {
+		skb = nf_hook_direct_egress(skb);
+		if (!skb)
+			return NET_XMIT_DROP;
+	}
+#endif
 	return dev_direct_xmit(skb, packet_pick_tx_queue(skb));
 }
 
-- 
2.31.1

