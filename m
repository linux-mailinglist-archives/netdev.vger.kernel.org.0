Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D81A2E1451
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgLWCXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:23:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730011AbgLWCXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70A6C225AC;
        Wed, 23 Dec 2020 02:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690194;
        bh=+UTwsuGRzzZhpz0EhL6quu0QIDzAmdWzEoKDyc32D14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PrpOy1/RugdnUlindMTyKBrm8xW5fWLGJ2AU0fc7rzfaG4VQoznYDHZMviUl/EFw3
         0Rswct0pI7bVv+VYA+7U91TNBo6rux2pVNCyZyl1+zwCCRwGW7ilvho8Jl6zcT2fP7
         H9MF0ahHtyj5T9MbbdBPLuyQEwdg7u9fM7bVtrv94J7v3/rUnud2d143RpDkrQEK3U
         gdLqGbVp/YmkFL5IxgFoADKwAT30nesSbEVJKJGsDGkmKc9LMmPAeJ+S08VnPWYKX0
         d6WhTkmIT0+rMYtw1eQttnnDvdjf+OLuscdzWRTZHtU/FFAzWGukxXQF0w37aZZ02n
         /to7QiadvgS5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/66] net: skb_vlan_untag(): don't reset transport offset if set by GRO layer
Date:   Tue, 22 Dec 2020 21:22:03 -0500
Message-Id: <20201223022253.2793452-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
index c4f412526dfeb..9ab02babfcebc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5069,7 +5069,8 @@ struct sk_buff *skb_vlan_untag(struct sk_buff *skb)
 		goto err_free;
 
 	skb_reset_network_header(skb);
-	skb_reset_transport_header(skb);
+	if (!skb_transport_header_was_set(skb))
+		skb_reset_transport_header(skb);
 	skb_reset_mac_len(skb);
 
 	return skb;
-- 
2.27.0

