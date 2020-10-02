Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE29B281673
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388115AbgJBPWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:22:30 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:37894 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBPWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:22:30 -0400
Received: from relay10.mail.gandi.net (unknown [217.70.178.230])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 4DEFD3A8EB5;
        Fri,  2 Oct 2020 15:17:42 +0000 (UTC)
Received: from localhost.localdomain (91-166-177-199.subs.proxad.net [91.166.177.199])
        (Authenticated sender: thibaut.sautereau@clip-os.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 6580324000F;
        Fri,  2 Oct 2020 15:17:17 +0000 (UTC)
From:   Thibaut Sautereau <thibaut.sautereau@clip-os.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>
Cc:     netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-kernel@vger.kernel.org,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>, Emese Revfy <re.emese@gmail.com>
Subject: [PATCH] random32: Restore __latent_entropy attribute on net_rand_state
Date:   Fri,  2 Oct 2020 17:16:11 +0200
Message-Id: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>

Commit f227e3ec3b5c ("random32: update the net random state on interrupt
and activity") broke compilation and was temporarily fixed by Linus in
83bdc7275e62 ("random32: remove net_rand_state from the latent entropy
gcc plugin") by entirely moving net_rand_state out of the things handled
by the latent_entropy GCC plugin.

From what I understand when reading the plugin code, using the
__latent_entropy attribute on a declaration was the wrong part and
simply keeping the __latent_entropy attribute on the variable definition
was the correct fix.

Fixes: 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy gcc plugin")
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Emese Revfy <re.emese@gmail.com>
Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
---
 lib/random32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/random32.c b/lib/random32.c
index 932345323af0..dfb9981ab798 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -49,7 +49,7 @@ static inline void prandom_state_selftest(void)
 }
 #endif
 
-DEFINE_PER_CPU(struct rnd_state, net_rand_state);
+DEFINE_PER_CPU(struct rnd_state, net_rand_state)  __latent_entropy;
 
 /**
  *	prandom_u32_state - seeded pseudo-random number generator.
-- 
2.28.0

