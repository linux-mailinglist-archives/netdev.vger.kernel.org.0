Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5658B488D37
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbiAIXRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:17:22 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42126 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237477AbiAIXRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:17:08 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 86A55607C1;
        Mon, 10 Jan 2022 00:14:18 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 31/32] netfilter: nft_payload: cancel register tracking after payload update
Date:   Mon, 10 Jan 2022 00:16:39 +0100
Message-Id: <20220109231640.104123-32-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The payload expression might mangle the packet, cancel register tracking
since any payload data in the registers is stale.

Finer grain register tracking cancellation by inspecting the payload
base, offset and length on the register is also possible.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index f518bf634997..10f422caa76a 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -798,12 +798,33 @@ static int nft_payload_set_dump(struct sk_buff *skb, const struct nft_expr *expr
 	return -1;
 }
 
+static bool nft_payload_set_reduce(struct nft_regs_track *track,
+				   const struct nft_expr *expr)
+{
+	int i;
+
+	for (i = 0; i < NFT_REG32_NUM; i++) {
+		if (!track->regs[i].selector)
+			continue;
+
+		if (track->regs[i].selector->ops != &nft_payload_ops &&
+		    track->regs[i].selector->ops != &nft_payload_fast_ops)
+			continue;
+
+		track->regs[i].selector = NULL;
+		track->regs[i].bitwise = NULL;
+	}
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_payload_set_ops = {
 	.type		= &nft_payload_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload_set)),
 	.eval		= nft_payload_set_eval,
 	.init		= nft_payload_set_init,
 	.dump		= nft_payload_set_dump,
+	.reduce		= nft_payload_set_reduce,
 };
 
 static const struct nft_expr_ops *
-- 
2.30.2

