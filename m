Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A636E35F8CC
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351584AbhDNQNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbhDNQNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 12:13:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16931C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 09:13:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lWi8c-0005rZ-Pu; Wed, 14 Apr 2021 18:13:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        herbert@gondor.apana.org.au, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 2/3] xfrm: remove stray synchronize_rcu from xfrm_init
Date:   Wed, 14 Apr 2021 18:12:52 +0200
Message-Id: <20210414161253.27586-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210414161253.27586-1-fw@strlen.de>
References: <20210414161253.27586-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function is called during boot, from ipv4 stack, there is no need
to set the pointer to NULL (static storage duration, so already NULL).

No need for the synchronize_rcu either.  Remove both.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/xfrm/xfrm_policy.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index c49f20657cdb..59691611a9ab 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4134,9 +4134,6 @@ void __init xfrm_init(void)
 #ifdef CONFIG_XFRM_ESPINTCP
 	espintcp_init();
 #endif
-
-	RCU_INIT_POINTER(xfrm_if_cb, NULL);
-	synchronize_rcu();
 }
 
 #ifdef CONFIG_AUDITSYSCALL
-- 
2.26.3

