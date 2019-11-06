Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB53F14BF
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 12:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731414AbfKFLNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 06:13:06 -0500
Received: from correo.us.es ([193.147.175.20]:44066 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfKFLMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 06:12:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 42FF03066C3
        for <netdev@vger.kernel.org>; Wed,  6 Nov 2019 12:12:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 35111DA801
        for <netdev@vger.kernel.org>; Wed,  6 Nov 2019 12:12:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 29C02B7FF6; Wed,  6 Nov 2019 12:12:45 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FECFB7FF6;
        Wed,  6 Nov 2019 12:12:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Nov 2019 12:12:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D30D641E4802;
        Wed,  6 Nov 2019 12:12:42 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/9] netfilter: nf_tables: Align nft_expr private data to 64-bit
Date:   Wed,  6 Nov 2019 12:12:33 +0100
Message-Id: <20191106111237.3183-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191106111237.3183-1-pablo@netfilter.org>
References: <20191106111237.3183-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

Invoking the following commands on a 32-bit architecture with strict
alignment requirements (such as an ARMv7-based Raspberry Pi) results
in an alignment exception:

 # nft add table ip test-ip4
 # nft add chain ip test-ip4 output { type filter hook output priority 0; }
 # nft add rule  ip test-ip4 output quota 1025 bytes

Alignment trap: not handling instruction e1b26f9f at [<7f4473f8>]
Unhandled fault: alignment exception (0x001) at 0xb832e824
Internal error: : 1 [#1] PREEMPT SMP ARM
Hardware name: BCM2835
[<7f4473fc>] (nft_quota_do_init [nft_quota])
[<7f447448>] (nft_quota_init [nft_quota])
[<7f4260d0>] (nf_tables_newrule [nf_tables])
[<7f4168dc>] (nfnetlink_rcv_batch [nfnetlink])
[<7f416bd0>] (nfnetlink_rcv [nfnetlink])
[<8078b334>] (netlink_unicast)
[<8078b664>] (netlink_sendmsg)
[<8071b47c>] (sock_sendmsg)
[<8071bd18>] (___sys_sendmsg)
[<8071ce3c>] (__sys_sendmsg)
[<8071ce94>] (sys_sendmsg)

The reason is that nft_quota_do_init() calls atomic64_set() on an
atomic64_t which is only aligned to 32-bit, not 64-bit, because it
succeeds struct nft_expr in memory which only contains a 32-bit pointer.
Fix by aligning the nft_expr private data to 64-bit.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.13+
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 001d294edf57..2d0275f13bbf 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -820,7 +820,8 @@ struct nft_expr_ops {
  */
 struct nft_expr {
 	const struct nft_expr_ops	*ops;
-	unsigned char			data[];
+	unsigned char			data[]
+		__attribute__((aligned(__alignof__(u64))));
 };
 
 static inline void *nft_expr_priv(const struct nft_expr *expr)
-- 
2.11.0

