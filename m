Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA356397C2E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbhFAWIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:08:42 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39546 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbhFAWIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:08:21 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 50371641CC;
        Wed,  2 Jun 2021 00:05:32 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 09/16] netfilter: x_tables: reduce xt_action_param by 8 byte
Date:   Wed,  2 Jun 2021 00:06:22 +0200
Message-Id: <20210601220629.18307-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The fragment offset in ipv4/ipv6 is a 16bit field, so use
u16 instead of unsigned int.

On 64bit: 40 bytes to 32 bytes. By extension this also reduces
nft_pktinfo (56 to 48 byte).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h | 2 +-
 net/ipv6/netfilter/ip6_tables.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 07c6ad8f2a02..28d7027cd460 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -36,8 +36,8 @@ struct xt_action_param {
 		const void *matchinfo, *targinfo;
 	};
 	const struct nf_hook_state *state;
-	int fragoff;
 	unsigned int thoff;
+	u16 fragoff;
 	bool hotdrop;
 };
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index e810a23baf99..de2cf3943b91 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -51,7 +51,7 @@ ip6_packet_match(const struct sk_buff *skb,
 		 const char *outdev,
 		 const struct ip6t_ip6 *ip6info,
 		 unsigned int *protoff,
-		 int *fragoff, bool *hotdrop)
+		 u16 *fragoff, bool *hotdrop)
 {
 	unsigned long ret;
 	const struct ipv6hdr *ipv6 = ipv6_hdr(skb);
-- 
2.30.2

