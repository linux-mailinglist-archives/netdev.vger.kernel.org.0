Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6353B1F2A
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 19:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhFWRF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 13:05:29 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33506 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhFWRF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 13:05:28 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6B8596427C;
        Wed, 23 Jun 2021 19:01:44 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 1/6] netfilter: nft_exthdr: Search chunks in SCTP packets only
Date:   Wed, 23 Jun 2021 19:02:56 +0200
Message-Id: <20210623170301.59973-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210623170301.59973-1-pablo@netfilter.org>
References: <20210623170301.59973-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Since user space does not generate a payload dependency, plain sctp
chunk matches cause searching in non-SCTP packets, too. Avoid this
potential mis-interpretation of packet data by checking pkt->tprot.

Fixes: 133dc203d77df ("netfilter: nft_exthdr: Support SCTP chunks")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 7f705b5c09de..9cf86be2cff4 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -312,6 +312,9 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 	const struct sctp_chunkhdr *sch;
 	struct sctp_chunkhdr _sch;
 
+	if (pkt->tprot != IPPROTO_SCTP)
+		goto err;
+
 	do {
 		sch = skb_header_pointer(pkt->skb, offset, sizeof(_sch), &_sch);
 		if (!sch || !sch->length)
@@ -334,7 +337,7 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 		}
 		offset += SCTP_PAD4(ntohs(sch->length));
 	} while (offset < pkt->skb->len);
-
+err:
 	if (priv->flags & NFT_EXTHDR_F_PRESENT)
 		nft_reg_store8(dest, false);
 	else
-- 
2.30.2

