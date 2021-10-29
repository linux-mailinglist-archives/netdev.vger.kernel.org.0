Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F249F43FB67
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhJ2Ldg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231754AbhJ2Ldf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 07:33:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 722B76115C;
        Fri, 29 Oct 2021 11:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635507067;
        bh=ZibYs1n7SeX+lPdL2kgZFAXJ2QBZdBxW/6A+ShFuqiU=;
        h=From:To:Cc:Subject:Date:From;
        b=EnW6uzMzO1PCn2gXLQEFEEhV9xjlPhVU7pp1ZLMb82lKdh8ke0trZoWn1ndjvVXmi
         pgJrQlN64XQoR+RPuRTME5Eo7UrZWO0O4VCBuWdSeXZQKIugTykKRPwW017nir4OrP
         DhohMcMG90XASipNqlXccav7Seocg17th35pXcpeHEtBWwRYX79XMEGmefqqPXhW2n
         j/8IZF42Cvo6vfL35r07xE3oPCSxhV/Y4togs5Dsvgtw5jH8KbQ4g5qfZjiiG9aTfG
         a1KWDBOX7o8eUFQtv0V3A5v3EV9rpGApQ1qHkUnPyoJHUs64zI2tF+p+ai5dFykGyD
         dO3zmcZSlxuaA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lukas Wunner <lukas@wunner.de>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Willem de Bruijn <willemb@google.com>,
        Hui Tang <tanghui20@huawei.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] ifb: fix building without CONFIG_NET_CLS_ACT
Date:   Fri, 29 Oct 2021 13:30:51 +0200
Message-Id: <20211029113102.769823-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The driver no longer depends on this option, but it fails to
build if it's disabled because the skb->tc_skip_classify is
hidden behind an #ifdef:

drivers/net/ifb.c:81:8: error: no member named 'tc_skip_classify' in 'struct sk_buff'
                skb->tc_skip_classify = 1;

Use the same #ifdef around the assignment.

Fixes: 046178e726c2 ("ifb: Depend on netfilter alternatively to tc")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ifb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 2c319dd27f29..31f522b8e54e 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -78,7 +78,9 @@ static void ifb_ri_tasklet(struct tasklet_struct *t)
 	while ((skb = __skb_dequeue(&txp->tq)) != NULL) {
 		/* Skip tc and netfilter to prevent redirection loop. */
 		skb->redirected = 0;
+#ifdef CONFIG_NET_CLS_ACT
 		skb->tc_skip_classify = 1;
+#endif
 		nf_skip_egress(skb, true);
 
 		u64_stats_update_begin(&txp->tsync);
-- 
2.29.2

