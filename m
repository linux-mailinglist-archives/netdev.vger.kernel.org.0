Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0342BBEF6
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 13:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgKUMgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 07:36:20 -0500
Received: from correo.us.es ([193.147.175.20]:60592 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727750AbgKUMgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 07:36:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A9649EBAD5
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 13:36:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 988E3DA78F
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 13:36:16 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8E2B5DA78A; Sat, 21 Nov 2020 13:36:16 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 044FDDA78B;
        Sat, 21 Nov 2020 13:36:14 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 21 Nov 2020 13:36:14 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id D10954265A5A;
        Sat, 21 Nov 2020 13:36:13 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/4] netfilter: nf_tables: avoid false-postive lockdep splat
Date:   Sat, 21 Nov 2020 13:36:01 +0100
Message-Id: <20201121123601.21733-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201121123601.21733-1-pablo@netfilter.org>
References: <20201121123601.21733-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

There are reports wrt lockdep splat in nftables, e.g.:
------------[ cut here ]------------
WARNING: CPU: 2 PID: 31416 at net/netfilter/nf_tables_api.c:622
lockdep_nfnl_nft_mutex_not_held+0x28/0x38 [nf_tables]
...

These are caused by an earlier, unrelated bug such as a n ABBA deadlock
in a different subsystem.
In such an event, lockdep is disabled and lockdep_is_held returns true
unconditionally.  This then causes the WARN() in nf_tables.

Make the WARN conditional on lockdep still active to avoid this.

Fixes: f102d66b335a417 ("netfilter: nf_tables: use dedicated mutex to guard transactions")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Link: https://lore.kernel.org/linux-kselftest/CA+G9fYvFUpODs+NkSYcnwKnXm62tmP=ksLeBPmB+KFrB2rvCtQ@mail.gmail.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0f58e98542be..23abf1578594 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -619,7 +619,8 @@ static int nft_request_module(struct net *net, const char *fmt, ...)
 static void lockdep_nfnl_nft_mutex_not_held(void)
 {
 #ifdef CONFIG_PROVE_LOCKING
-	WARN_ON_ONCE(lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
+	if (debug_locks)
+		WARN_ON_ONCE(lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
 #endif
 }
 
-- 
2.20.1

