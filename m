Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA20842D902
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhJNMNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhJNMNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 08:13:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041C6C061753;
        Thu, 14 Oct 2021 05:11:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1maza0-0002lq-Gu; Thu, 14 Oct 2021 14:11:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, me@ubique.spb.ru,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 5/9] netfilter: reduce allowed hook count to 32
Date:   Thu, 14 Oct 2021 14:10:42 +0200
Message-Id: <20211014121046.29329-7-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211014121046.29329-1-fw@strlen.de>
References: <20211014121046.29329-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1k is huge and will mean we'd need to support tailcalls in the
nf_hook bpf converter.

We need about 5 insns per hook at this time, ignoring prologue/epilogue.

32 should be fine, typically even extreme cases need about 8 hooks per
hook location.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 3fd268afc13e..f4359179eba9 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -42,7 +42,7 @@ EXPORT_SYMBOL(nf_hooks_needed);
 static DEFINE_MUTEX(nf_hook_mutex);
 
 /* max hooks per family/hooknum */
-#define MAX_HOOK_COUNT		1024
+#define MAX_HOOK_COUNT		32
 
 #define nf_entry_dereference(e) \
 	rcu_dereference_protected(e, lockdep_is_held(&nf_hook_mutex))
-- 
2.32.0

