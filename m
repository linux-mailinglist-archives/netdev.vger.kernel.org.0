Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712754FDD1C
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiDLK5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356912AbiDLKpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:45:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E9D413F7F;
        Tue, 12 Apr 2022 02:42:55 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 73F8D625B1;
        Tue, 12 Apr 2022 11:38:50 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/2] netfilter: nft_socket: make cgroup match work in input too
Date:   Tue, 12 Apr 2022 11:42:45 +0200
Message-Id: <20220412094246.448055-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220412094246.448055-1-pablo@netfilter.org>
References: <20220412094246.448055-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

cgroupv2 helper function ignores the already-looked up sk
and uses skb->sk instead.

Just pass sk from the calling function instead; this will
make cgroup matching work for udp and tcp in input even when
edemux did not set skb->sk already.

Fixes: e0bb96db96f8 ("netfilter: nft_socket: add support for cgroupsv2")
Signed-off-by: Florian Westphal <fw@strlen.de>
Tested-by: Topi Miettinen <toiwoton@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_socket.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index bd3792f080ed..6d9e8e0a3a7d 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -37,12 +37,11 @@ static void nft_socket_wildcard(const struct nft_pktinfo *pkt,
 
 #ifdef CONFIG_SOCK_CGROUP_DATA
 static noinline bool
-nft_sock_get_eval_cgroupv2(u32 *dest, const struct nft_pktinfo *pkt, u32 level)
+nft_sock_get_eval_cgroupv2(u32 *dest, struct sock *sk, const struct nft_pktinfo *pkt, u32 level)
 {
-	struct sock *sk = skb_to_full_sk(pkt->skb);
 	struct cgroup *cgrp;
 
-	if (!sk || !sk_fullsock(sk) || !net_eq(nft_net(pkt), sock_net(sk)))
+	if (!sk_fullsock(sk))
 		return false;
 
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
@@ -109,7 +108,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		break;
 #ifdef CONFIG_SOCK_CGROUP_DATA
 	case NFT_SOCKET_CGROUPV2:
-		if (!nft_sock_get_eval_cgroupv2(dest, pkt, priv->level)) {
+		if (!nft_sock_get_eval_cgroupv2(dest, sk, pkt, priv->level)) {
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
-- 
2.30.2

