Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32BC36CBF7
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 21:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238983AbhD0Tqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 15:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235661AbhD0Tqn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 15:46:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E71C6023B;
        Tue, 27 Apr 2021 19:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619552759;
        bh=xLX5Y1/h9Ll5Xq3l/iKgtd536wc5fsuPUiC9i35GC2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r4uY2em21Cu3E3S8kfddwM0mxkRxB9zBBQRGyyb7mSCF9MrLOo+kvN00n9VCLj8WN
         8c3ZCrGMVzcdnz8Ms05Uksdy6/xGONCIhNaAdG5F7Qw0ZEJP99TsPjg/FERUtkddZ1
         hjY0xnBpwNzPmkAWx+bHwgxPHGE/ksoIXzqLPo6otOLWj2s8UE4LMdUyiO5kpfZwXy
         bObx/C9cMN5fjE//6/FrvYX6jU2sn+PR8/ZF17cxVNSJJDtT+eX6KiBZEj8an4eIcG
         7ic2zr4fZW505hvMnXlekVtU+tM7QevYQI10b94RGuQ2TmwoPXdCRC9ECebHxTA09q
         UwcJoHFyeB/hw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Balazs Scheidler <bazsi77@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] netfilter: nft_socket: fix build with CONFIG_SOCK_CGROUP_DATA=n
Date:   Tue, 27 Apr 2021 21:45:19 +0200
Message-Id: <20210427194528.2325108-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427194528.2325108-1-arnd@kernel.org>
References: <20210427194528.2325108-1-arnd@kernel.org>
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
---
I don't actually know what the right fix is for this, I only checked
that my patch fixes the build failure. Is is possible that the function
should always be defined.

Please make sure you review carefully before applying.
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
2.29.2

