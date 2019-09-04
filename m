Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217FAA9260
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731986AbfIDThB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 15:37:01 -0400
Received: from correo.us.es ([193.147.175.20]:37896 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbfIDTg6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 15:36:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 490C1303D04
        for <netdev@vger.kernel.org>; Wed,  4 Sep 2019 21:36:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3AB0BB7FFB
        for <netdev@vger.kernel.org>; Wed,  4 Sep 2019 21:36:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3067CDA72F; Wed,  4 Sep 2019 21:36:55 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27AAFB7FFB;
        Wed,  4 Sep 2019 21:36:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Sep 2019 21:36:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 002434265A5A;
        Wed,  4 Sep 2019 21:36:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/5] netfilter: nft_fib_netdev: Terminate rule eval if protocol=IPv6 and ipv6 module is disabled
Date:   Wed,  4 Sep 2019 21:36:44 +0200
Message-Id: <20190904193646.23830-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190904193646.23830-1-pablo@netfilter.org>
References: <20190904193646.23830-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leonardo Bras <leonardo@linux.ibm.com>

If IPv6 is disabled on boot (ipv6.disable=1), but nft_fib_inet ends up
dealing with a IPv6 packet, it causes a kernel panic in
fib6_node_lookup_1(), crashing in bad_page_fault.

The panic is caused by trying to deference a very low address (0x38
in ppc64le), due to ipv6.fib6_main_tbl = NULL.
BUG: Kernel NULL pointer dereference at 0x00000038

The kernel panic was reproduced in a host that disabled IPv6 on boot and
have to process guest packets (coming from a bridge) using it's ip6tables.

Terminate rule evaluation when packet protocol is IPv6 but the ipv6 module
is not loaded.

Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_fib_netdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_fib_netdev.c b/net/netfilter/nft_fib_netdev.c
index 2cf3f32fe6d2..a2e726ae7f07 100644
--- a/net/netfilter/nft_fib_netdev.c
+++ b/net/netfilter/nft_fib_netdev.c
@@ -14,6 +14,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/ipv6.h>
 
 #include <net/netfilter/nft_fib.h>
 
@@ -34,6 +35,8 @@ static void nft_fib_netdev_eval(const struct nft_expr *expr,
 		}
 		break;
 	case ETH_P_IPV6:
+		if (!ipv6_mod_enabled())
+			break;
 		switch (priv->result) {
 		case NFT_FIB_RESULT_OIF:
 		case NFT_FIB_RESULT_OIFNAME:
-- 
2.11.0

