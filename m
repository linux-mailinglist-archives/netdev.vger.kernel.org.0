Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7543A1F46
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFIVrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:47:49 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60500 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhFIVrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 17:47:32 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8206D64233;
        Wed,  9 Jun 2021 23:44:23 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 10/13] netfilter: nft_exthdr: Fix for unsafe packet data read
Date:   Wed,  9 Jun 2021 23:45:20 +0200
Message-Id: <20210609214523.1678-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609214523.1678-1-pablo@netfilter.org>
References: <20210609214523.1678-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

While iterating through an SCTP packet's chunks, skb_header_pointer() is
called for the minimum expected chunk header size. If (that part of) the
skbuff is non-linear, the following memcpy() may read data past
temporary buffer '_sch'. Use skb_copy_bits() instead which does the
right thing in this situation.

Fixes: 133dc203d77df ("netfilter: nft_exthdr: Support SCTP chunks")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 1b0579cb62d0..7f705b5c09de 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -327,7 +327,9 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 				break;
 
 			dest[priv->len / NFT_REG32_SIZE] = 0;
-			memcpy(dest, (char *)sch + priv->offset, priv->len);
+			if (skb_copy_bits(pkt->skb, offset + priv->offset,
+					  dest, priv->len) < 0)
+				break;
 			return;
 		}
 		offset += SCTP_PAD4(ntohs(sch->length));
-- 
2.30.2

