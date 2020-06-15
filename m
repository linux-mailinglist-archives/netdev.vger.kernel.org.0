Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D15B1F8DC5
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 08:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgFOGZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 02:25:28 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:55046 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728210AbgFOGZ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 02:25:28 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 49lhCM0q56zB09ZD;
        Mon, 15 Jun 2020 08:25:19 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 2k3kTte1w7S0; Mon, 15 Jun 2020 08:25:19 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 49lhCL735Yz9vBnX;
        Mon, 15 Jun 2020 08:25:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 751B38B77C;
        Mon, 15 Jun 2020 08:25:24 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id bD3UugvlelPy; Mon, 15 Jun 2020 08:25:24 +0200 (CEST)
Received: from pc16570vm.idsi0.si.c-s.fr (po15451.idsi0.si.c-s.fr [172.25.230.104])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A3F468B75F;
        Mon, 15 Jun 2020 08:25:23 +0200 (CEST)
Received: by pc16570vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 7CCC065AF4; Mon, 15 Jun 2020 06:25:23 +0000 (UTC)
Message-Id: <9e9882a2fb57b6f9d98a0a5d8b6bf9cff9fcbd93.1592202173.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH v2] SUNRPC: Add missing definition of
 ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
To:     Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Date:   Mon, 15 Jun 2020 06:25:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even if that's only a warning, not including asm/cacheflush.h
leads to svc_flush_bvec() being empty allthough powerpc defines
ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE.

  CC      net/sunrpc/svcsock.o
net/sunrpc/svcsock.c:227:5: warning: "ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE" is not defined [-Wundef]
 #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
     ^

Include linux/highmem.h so that asm/cacheflush.h will be included.

Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Fixes: ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
v2: Use linux/highmem.h instead of asm/cacheflush.sh
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 net/sunrpc/svcsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 5c4ec9386f81..c537272f9c7e 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -44,6 +44,7 @@
 #include <net/tcp.h>
 #include <net/tcp_states.h>
 #include <linux/uaccess.h>
+#include <linux/highmem.h>
 #include <asm/ioctls.h>
 
 #include <linux/sunrpc/types.h>
-- 
2.25.0

