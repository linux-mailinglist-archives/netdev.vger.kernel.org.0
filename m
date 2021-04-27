Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2B936CC8B
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 22:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238967AbhD0Uoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 16:44:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54322 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239010AbhD0Uok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 16:44:40 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C522864145;
        Tue, 27 Apr 2021 22:43:18 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 7/7] netfilter: nft_socket: fix build with CONFIG_SOCK_CGROUP_DATA=n
Date:   Tue, 27 Apr 2021 22:43:45 +0200
Message-Id: <20210427204345.22043-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210427204345.22043-1-pablo@netfilter.org>
References: <20210427204345.22043-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

In some configurations, the sock_cgroup_ptr() function is not available:

net/netfilter/nft_socket.c: In function 'nft_sock_get_eval_cgroupv2':
net/netfilter/nft_socket.c:47:16: error: implicit declaration of function 'sock_cgroup_ptr'; did you mean 'obj_cgroup_put'? [-Werror=implicit-function-declaration]
   47 |         cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
      |                ^~~~~~~~~~~~~~~
      |                obj_cgroup_put
net/netfilter/nft_socket.c:47:14: error: assignment to 'struct cgroup *' from 'int' makes pointer from integer without a cast [-Werror=int-conversion]
   47 |         cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
      |              ^

Change the caller to match the same #ifdef check, only calling it
when the function is defined.

Fixes: e0bb96db96f8 ("netfilter: nft_socket: add support for cgroupsv2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index f9c5ff6024e0..d601974c9d2e 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -34,7 +34,7 @@ static void nft_socket_wildcard(const struct nft_pktinfo *pkt,
 	}
 }
 
-#ifdef CONFIG_CGROUPS
+#ifdef CONFIG_SOCK_CGROUP_DATA
 static noinline bool
 nft_sock_get_eval_cgroupv2(u32 *dest, const struct nft_pktinfo *pkt, u32 level)
 {
@@ -106,7 +106,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		}
 		nft_socket_wildcard(pkt, regs, sk, dest);
 		break;
-#ifdef CONFIG_CGROUPS
+#ifdef CONFIG_SOCK_CGROUP_DATA
 	case NFT_SOCKET_CGROUPV2:
 		if (!nft_sock_get_eval_cgroupv2(dest, pkt, priv->level)) {
 			regs->verdict.code = NFT_BREAK;
-- 
2.30.2

