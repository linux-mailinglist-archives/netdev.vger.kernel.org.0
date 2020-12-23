Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9782E1739
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731872AbgLWDHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:07:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgLWCSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A137233FA;
        Wed, 23 Dec 2020 02:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689868;
        bh=O0S+26ciccrfnNwun4+sPx00DqUVef45cMQSOJcp3sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAWT/8dpRc93NUNbgeKfj5/tApF2OYV1WSqGdT160BLLn3p2IUkDKZRY08jUisCf7
         o+nuHsOF/tIl0B6K5HeICiXv/Q49oZJVXiLvn8EC2SevGLKCGP4aqgJcLIn2uHFlsv
         Tbq4vMs3k5Jzup+wxO8zhVcW/mDq39NeEJOoQaZw//4HfWCFt42A7UA6GnsrAA+x0L
         mm+HIcCIcNsc2V5hfNvVyUuZ1AH0QcaBFCS4nWix0D63Ajldq8rygl++ZpP37zhq4F
         LCc/0J9OirOtBWtRBSJgGZDYqwr2RnFEfFqhaPuWIXunkOjsL+gxQ6aqBDGk1ljgJ3
         Uq/ZICO/Mirdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 063/217] net: skb_vlan_untag(): don't reset transport offset if set by GRO layer
Date:   Tue, 22 Dec 2020 21:13:52 -0500
Message-Id: <20201223021626.2790791-63-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
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
index e578544b2cc71..08d69e062eca6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5430,7 +5430,8 @@ struct sk_buff *skb_vlan_untag(struct sk_buff *skb)
 		goto err_free;
 
 	skb_reset_network_header(skb);
-	skb_reset_transport_header(skb);
+	if (!skb_transport_header_was_set(skb))
+		skb_reset_transport_header(skb);
 	skb_reset_mac_len(skb);
 
 	return skb;
-- 
2.27.0

