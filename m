Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAB62E1367
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbgLWC3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:29:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730599AbgLWCZr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0DEF225AC;
        Wed, 23 Dec 2020 02:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690332;
        bh=TfDWUcl0vAODPs76zq2CyzeCyKorb9dNWNx5tVF4Gis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAGKUmuYZk5ECoiRjEDIZhDZvMZNLTL7C76bk2zHbO//TvIcmhrR1EUDG/JUrPeoC
         nW6hL0qU1aH/RCldOPiOp1jff1c/62OFQdErH1Qf+aZQfna040iZyNQBJUUP769nEF
         E1VtNNwIDoZd9t1zMb+4AiiX7jheH2Xorr4IngP8MnGoMf8H52c4GT1LBFVZAZ7bG3
         3ArmSmvNIaUjRA7pWnxYItWO7qtP1f/44+UN5eC5jD7+0Sll219JmluUzpqrWyHPGN
         +OESocEap4KZx+BL/rumCK7VXuvVDhZrY/Px3hJkPpz43Ow690QWeWJXy3JvDuS7Hi
         v2HOVkEdijNtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 12/38] net: skb_vlan_untag(): don't reset transport offset if set by GRO layer
Date:   Tue, 22 Dec 2020 21:24:50 -0500
Message-Id: <20201223022516.2794471-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022516.2794471-1-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit 8be33ecfc1ffd2da20cc29e957e4cb6eb99310cb ]

Similar to commit fda55eca5a33f
("net: introduce skb_transport_header_was_set()"), avoid resetting
transport offsets that were already set by GRO layer. This not only
mirrors the behavior of __netif_receive_skb_core(), but also makes
sense when it comes to UDP GSO fraglists forwarding: transport offset
of such skbs is set only once by GRO receive callback and remains
untouched and correct up to the xmitting driver in 1:1 case, but
becomes junk after untagging in ingress VLAN case and breaks UDP
GSO offload. This does not happen after this change, and all types
of forwarding of UDP GSO fraglists work as expected.

Since v1 [1]:
 - keep the code 1:1 with __netif_receive_skb_core() (Jakub).

[1] https://lore.kernel.org/netdev/zYurwsZRN7BkqSoikWQLVqHyxz18h4LhHU4NFa2Vw@cp4-web-038.plabs.ch

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Link: https://lore.kernel.org/r/7JgIkgEztzt0W6ZtC9V9Cnk5qfkrUFYcpN871syCi8@cp4-web-040.plabs.ch
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e87ec3659ef61..c3993afc32e2c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4386,7 +4386,8 @@ struct sk_buff *skb_vlan_untag(struct sk_buff *skb)
 		goto err_free;
 
 	skb_reset_network_header(skb);
-	skb_reset_transport_header(skb);
+	if (!skb_transport_header_was_set(skb))
+		skb_reset_transport_header(skb);
 	skb_reset_mac_len(skb);
 
 	return skb;
-- 
2.27.0

