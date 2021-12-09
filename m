Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BAA46DF3D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241344AbhLIAMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:12:33 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41746 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241334AbhLIAMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:12:32 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2525E605C1;
        Thu,  9 Dec 2021 01:06:36 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 5/7] netfilter: nft_exthdr: break evaluation if setting TCP option fails
Date:   Thu,  9 Dec 2021 01:08:45 +0100
Message-Id: <20211209000847.102598-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211209000847.102598-1-pablo@netfilter.org>
References: <20211209000847.102598-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Break rule evaluation on malformed TCP options.

Fixes: 99d1712bc41c ("netfilter: exthdr: tcp option set support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index af4ee874a067..dbe1f2e7dd9e 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -236,7 +236,7 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 
 	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
 	if (!tcph)
-		return;
+		goto err;
 
 	opt = (u8 *)tcph;
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
@@ -251,16 +251,16 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 			continue;
 
 		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
-			return;
+			goto err;
 
 		if (skb_ensure_writable(pkt->skb,
 					nft_thoff(pkt) + i + priv->len))
-			return;
+			goto err;
 
 		tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff,
 					      &tcphdr_len);
 		if (!tcph)
-			return;
+			goto err;
 
 		offset = i + priv->offset;
 
@@ -303,6 +303,9 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 
 		return;
 	}
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
-- 
2.30.2

