Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFBE51635F8
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 23:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgBRWVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 17:21:20 -0500
Received: from correo.us.es ([193.147.175.20]:57518 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgBRWVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 17:21:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5BAAA303D0C
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 23:21:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4C8FADA3A4
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 23:21:11 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4228DDA3A1; Tue, 18 Feb 2020 23:21:11 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64BDFDA39F;
        Tue, 18 Feb 2020 23:21:09 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Feb 2020 23:21:09 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3A99142EE38E;
        Tue, 18 Feb 2020 23:21:09 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 9/9] netfilter: nft_set_pipapo: Don't abuse unlikely() in pipapo_refill()
Date:   Tue, 18 Feb 2020 23:21:01 +0100
Message-Id: <20200218222101.635808-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200218222101.635808-1-pablo@netfilter.org>
References: <20200218222101.635808-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

I originally used unlikely() in the if (match_only) clause, which
we hit on the mapping table for the last field in a set, to ensure
we avoid branching to the rest of for loop body, which is executed
more frequently.

However, Pablo reports, this is confusing as it gives the impression
that this is not a common case, and it's actually not the intended
usage of unlikely().

I couldn't observe any statistical difference in matching rates on
x864_64 and aarch64 without it, so just drop it.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 579600b39f39..feac8553f6d9 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -503,7 +503,7 @@ static int pipapo_refill(unsigned long *map, int len, int rules,
 				return -1;
 			}
 
-			if (unlikely(match_only)) {
+			if (match_only) {
 				bitmap_clear(map, i, 1);
 				return i;
 			}
-- 
2.11.0

