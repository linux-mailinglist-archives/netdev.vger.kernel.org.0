Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5E31F89C6
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 19:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgFNRHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 13:07:15 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:18445 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbgFNRHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 13:07:14 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 49lLVM2GGjzB09bL;
        Sun, 14 Jun 2020 19:07:07 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id fFXltivinHFx; Sun, 14 Jun 2020 19:07:07 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 49lLVM1QrWzB09b0;
        Sun, 14 Jun 2020 19:07:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id EC3C18B76A;
        Sun, 14 Jun 2020 19:07:11 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id JN9iOU_Lvrkr; Sun, 14 Jun 2020 19:07:11 +0200 (CEST)
Received: from pc16570vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B3CF58B75F;
        Sun, 14 Jun 2020 19:07:11 +0200 (CEST)
Received: by pc16570vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 6C40565AF2; Sun, 14 Jun 2020 17:07:11 +0000 (UTC)
Message-Id: <a356625c9aa1b5d711e320c39779e0c713f204cb.1592154127.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH] SUNRPC: Add missing asm/cacheflush.h
To:     Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Date:   Sun, 14 Jun 2020 17:07:11 +0000 (UTC)
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

Fixes: ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 I detected this on linux-next on June 4th and warned Chuck. Seems like it went into mainline anyway.

 net/sunrpc/svcsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 5c4ec9386f81..d9e99cb09aab 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -45,6 +45,7 @@
 #include <net/tcp_states.h>
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
+#include <asm/cacheflush.h>
 
 #include <linux/sunrpc/types.h>
 #include <linux/sunrpc/clnt.h>
-- 
2.25.0

