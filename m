Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BF636CC8A
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 22:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239039AbhD0Uon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 16:44:43 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54336 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238992AbhD0Uoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 16:44:39 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3C35D64143;
        Tue, 27 Apr 2021 22:43:18 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 6/7] netfilter: nft_socket: fix an unused variable warning
Date:   Tue, 27 Apr 2021 22:43:44 +0200
Message-Id: <20210427204345.22043-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210427204345.22043-1-pablo@netfilter.org>
References: <20210427204345.22043-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The variable is only used in an #ifdef, causing a harmless warning:

net/netfilter/nft_socket.c: In function 'nft_socket_init':
net/netfilter/nft_socket.c:137:27: error: unused variable 'level' [-Werror=unused-variable]
  137 |         unsigned int len, level;
      |                           ^~~~~

Move it into the same #ifdef block.

Fixes: e0bb96db96f8 ("netfilter: nft_socket: add support for cgroupsv2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_socket.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 9c169d100651..f9c5ff6024e0 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -134,7 +134,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_socket *priv = nft_expr_priv(expr);
-	unsigned int len, level;
+	unsigned int len;
 
 	if (!tb[NFTA_SOCKET_DREG] || !tb[NFTA_SOCKET_KEY])
 		return -EINVAL;
@@ -160,7 +160,9 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 		len = sizeof(u32);
 		break;
 #ifdef CONFIG_CGROUPS
-	case NFT_SOCKET_CGROUPV2:
+	case NFT_SOCKET_CGROUPV2: {
+		unsigned int level;
+
 		if (!tb[NFTA_SOCKET_LEVEL])
 			return -EINVAL;
 
@@ -171,6 +173,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 		priv->level = level;
 		len = sizeof(u64);
 		break;
+	}
 #endif
 	default:
 		return -EOPNOTSUPP;
-- 
2.30.2

