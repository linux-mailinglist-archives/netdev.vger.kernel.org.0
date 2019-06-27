Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD82D57815
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfF0AhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbfF0AhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:37:08 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56EE62184E;
        Thu, 27 Jun 2019 00:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595827;
        bh=Do+ZFldgUIPiXLB7n1y+uxP70mE2qkdNAeMpDck2sYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugy0OgtlbpSSgrmrRWoXqKwaCv/ZumbETB30nw2wIGh+M0aionWTZIP5u1doisoA0
         gG8PaGQTFwMsouM/QvzESxSjxza2SBgk92CdYct0Kb1t/s+4uB88531PLWGiyNp2W3
         QNBb5x8pvPxIXvj6tsJ22JqxBGgaqP9qiuOY/g1g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Tom Herbert <tom@herbertland.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/60] bpf: udp: Avoid calling reuseport's bpf_prog from udp_gro
Date:   Wed, 26 Jun 2019 20:35:32 -0400
Message-Id: <20190627003616.20767-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit 257a525fe2e49584842c504a92c27097407f778f ]

When the commit a6024562ffd7 ("udp: Add GRO functions to UDP socket")
added udp[46]_lib_lookup_skb to the udp_gro code path, it broke
the reuseport_select_sock() assumption that skb->data is pointing
to the transport header.

This patch follows an earlier __udp6_lib_err() fix by
passing a NULL skb to avoid calling the reuseport's bpf_prog.

Fixes: a6024562ffd7 ("udp: Add GRO functions to UDP socket")
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 6 +++++-
 net/ipv6/udp.c | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index e45a5e19e509..e6dbe3912b93 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -542,7 +542,11 @@ static inline struct sock *__udp4_lib_lookup_skb(struct sk_buff *skb,
 struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
 				 __be16 sport, __be16 dport)
 {
-	return __udp4_lib_lookup_skb(skb, sport, dport, &udp_table);
+	const struct iphdr *iph = ip_hdr(skb);
+
+	return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
+				 iph->daddr, dport, inet_iif(skb),
+				 inet_sdif(skb), &udp_table, NULL);
 }
 EXPORT_SYMBOL_GPL(udp4_lib_lookup_skb);
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index cab8b2b647f9..7c3ea06f86a9 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -282,7 +282,7 @@ struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
 
 	return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
 				 &iph->daddr, dport, inet6_iif(skb),
-				 inet6_sdif(skb), &udp_table, skb);
+				 inet6_sdif(skb), &udp_table, NULL);
 }
 EXPORT_SYMBOL_GPL(udp6_lib_lookup_skb);
 
-- 
2.20.1

