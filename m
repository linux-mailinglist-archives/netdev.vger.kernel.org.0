Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121EF68F84
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389536AbfGOOPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388820AbfGOOO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:14:57 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD747206B8;
        Mon, 15 Jul 2019 14:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200096;
        bh=6ZfNFaNDbZXLhczr3NiuI23GxalUYqmEAJnecquVb6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5GpSTStz3FcOBtN6T7+HBc2bOnpHcVXbJ6g+pu8BxNdsZamV/lXvD0uw7ldl8w/Q
         zOxJqePe5bqG4PGzBl3qDh3LjqbsCN7ZW8mJ7rH7eo6Of6wWqgKD4+F+yDk5fdJdRn
         CMayuHnHS3+g+JBk7Tnpggy8OqgPDp9Sm85vI28I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     He Zhe <zhe.he@windriver.com>, Yi Zhao <yi.zhao@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 183/219] netfilter: Fix remainder of pseudo-header protocol 0
Date:   Mon, 15 Jul 2019 10:03:04 -0400
Message-Id: <20190715140341.6443-183-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

[ Upstream commit 5d1549847c76b1ffcf8e388ef4d0f229bdd1d7e8 ]

Since v5.1-rc1, some types of packets do not get unreachable reply with the
following iptables setting. Fox example,

$ iptables -A INPUT -p icmp --icmp-type 8 -j REJECT
$ ping 127.0.0.1 -c 1
PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
— 127.0.0.1 ping statistics —
1 packets transmitted, 0 received, 100% packet loss, time 0ms

We should have got the following reply from command line, but we did not.
From 127.0.0.1 icmp_seq=1 Destination Port Unreachable

Yi Zhao reported it and narrowed it down to:
7fc38225363d ("netfilter: reject: skip csum verification for protocols that don't support it"),

This is because nf_ip_checksum still expects pseudo-header protocol type 0 for
packets that are of neither TCP or UDP, and thus ICMP packets are mistakenly
treated as TCP/UDP.

This patch corrects the conditions in nf_ip_checksum and all other places that
still call it with protocol 0.

Fixes: 7fc38225363d ("netfilter: reject: skip csum verification for protocols that don't support it")
Reported-by: Yi Zhao <yi.zhao@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_icmp.c | 2 +-
 net/netfilter/nf_nat_proto.c            | 2 +-
 net/netfilter/utils.c                   | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 9becac953587..71a84a0517f3 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -221,7 +221,7 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 	/* See ip_conntrack_proto_tcp.c */
 	if (state->net->ct.sysctl_checksum &&
 	    state->hook == NF_INET_PRE_ROUTING &&
-	    nf_ip_checksum(skb, state->hook, dataoff, 0)) {
+	    nf_ip_checksum(skb, state->hook, dataoff, IPPROTO_ICMP)) {
 		icmp_error_log(skb, state, "bad hw icmp checksum");
 		return -NF_ACCEPT;
 	}
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 62743da3004f..0b0efbb953bf 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -567,7 +567,7 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 
 	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
 		return 0;
-	if (nf_ip_checksum(skb, hooknum, hdrlen, 0))
+	if (nf_ip_checksum(skb, hooknum, hdrlen, IPPROTO_ICMP))
 		return 0;
 
 	inside = (void *)skb->data + hdrlen;
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 06dc55590441..51b454d8fa9c 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -17,7 +17,8 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 	case CHECKSUM_COMPLETE:
 		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
 			break;
-		if ((protocol == 0 && !csum_fold(skb->csum)) ||
+		if ((protocol != IPPROTO_TCP && protocol != IPPROTO_UDP &&
+		    !csum_fold(skb->csum)) ||
 		    !csum_tcpudp_magic(iph->saddr, iph->daddr,
 				       skb->len - dataoff, protocol,
 				       skb->csum)) {
@@ -26,7 +27,7 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 		}
 		/* fall through */
 	case CHECKSUM_NONE:
-		if (protocol == 0)
+		if (protocol != IPPROTO_TCP && protocol != IPPROTO_UDP)
 			skb->csum = 0;
 		else
 			skb->csum = csum_tcpudp_nofold(iph->saddr, iph->daddr,
-- 
2.20.1

