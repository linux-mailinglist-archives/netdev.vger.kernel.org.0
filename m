Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA8D3B0FC4
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 00:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhFVWDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 18:03:01 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59270 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbhFVWC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 18:02:58 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 14D3D64271;
        Tue, 22 Jun 2021 23:59:17 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/8] netfilter: nft_tproxy: restrict support to TCP and UDP transport protocols
Date:   Tue, 22 Jun 2021 23:59:57 +0200
Message-Id: <20210622220001.198508-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210622220001.198508-1-pablo@netfilter.org>
References: <20210622220001.198508-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add unfront check for TCP and UDP packets before performing further
processing.

Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tproxy.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index accef672088c..5cb4d575d47f 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -30,6 +30,12 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 	__be16 tport = 0;
 	struct sock *sk;
 
+	if (pkt->tprot != IPPROTO_TCP &&
+	    pkt->tprot != IPPROTO_UDP) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
 	hp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_hdr), &_hdr);
 	if (!hp) {
 		regs->verdict.code = NFT_BREAK;
@@ -91,7 +97,8 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 
 	memset(&taddr, 0, sizeof(taddr));
 
-	if (!pkt->tprot_set) {
+	if (pkt->tprot != IPPROTO_TCP &&
+	    pkt->tprot != IPPROTO_UDP) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-- 
2.30.2

