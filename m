Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2873282D62
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 21:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgJDTuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 15:50:17 -0400
Received: from correo.us.es ([193.147.175.20]:34984 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbgJDTuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 15:50:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11FB1EF432
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02434DA78B
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 00C7CDA789; Sun,  4 Oct 2020 21:50:12 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE87DDA78A;
        Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 04 Oct 2020 21:50:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 95DDA42EF9E0;
        Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 09/11] netfilter: nfnetlink: place subsys mutexes in distinct lockdep classes
Date:   Sun,  4 Oct 2020 21:49:38 +0200
Message-Id: <20201004194940.7368-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201004194940.7368-1-pablo@netfilter.org>
References: <20201004194940.7368-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

From time to time there are lockdep reports similar to this one:

 WARNING: possible circular locking dependency detected
 ------------------------------------------------------
 000000004f61aa56 (&table[i].mutex){+.+.}, at: nfnl_lock [nfnetlink]
 but task is already holding lock:
 [..] (&net->nft.commit_mutex){+.+.}, at: nf_tables_valid_genid [nf_tables]
 which lock already depends on the new lock.
 the existing dependency chain (in reverse order) is:
 -> #1 (&net->nft.commit_mutex){+.+.}:
 [..]
        nf_tables_valid_genid+0x18/0x60 [nf_tables]
        nfnetlink_rcv_batch+0x24c/0x620 [nfnetlink]
        nfnetlink_rcv+0x110/0x140 [nfnetlink]
        netlink_unicast+0x12c/0x1e0
 [..]
        sys_sendmsg+0x18/0x40
        linux_sparc_syscall+0x34/0x44
 -> #0 (&table[i].mutex){+.+.}:
 [..]
        nfnl_lock+0x24/0x40 [nfnetlink]
        ip_set_nfnl_get_byindex+0x19c/0x280 [ip_set]
        set_match_v1_checkentry+0x14/0xc0 [xt_set]
        xt_check_match+0x238/0x260 [x_tables]
        __nft_match_init+0x160/0x180 [nft_compat]
 [..]
        sys_sendmsg+0x18/0x40
        linux_sparc_syscall+0x34/0x44
 other info that might help us debug this:
  Possible unsafe locking scenario:
        CPU0                    CPU1
        ----                    ----
   lock(&net->nft.commit_mutex);
                                lock(&table[i].mutex);
                                lock(&net->nft.commit_mutex);
   lock(&table[i].mutex);

Lockdep considers this an ABBA deadlock because the different nfnl subsys
mutexes reside in the same lockdep class, but this is a false positive.

CPU1 table[i] refers to the nftables subsys mutex, whereas CPU1 locks
the ipset subsys mutex.

Yi Che reported a similar lockdep splat, this time between ipset and
ctnetlink subsys mutexes.

Time to place them in distinct classes to avoid these warnings.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 3a2e64e13b22..2daa1f6ae344 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -46,6 +46,23 @@ static struct {
 	const struct nfnetlink_subsystem __rcu	*subsys;
 } table[NFNL_SUBSYS_COUNT];
 
+static struct lock_class_key nfnl_lockdep_keys[NFNL_SUBSYS_COUNT];
+
+static const char *const nfnl_lockdep_names[NFNL_SUBSYS_COUNT] = {
+	[NFNL_SUBSYS_NONE] = "nfnl_subsys_none",
+	[NFNL_SUBSYS_CTNETLINK] = "nfnl_subsys_ctnetlink",
+	[NFNL_SUBSYS_CTNETLINK_EXP] = "nfnl_subsys_ctnetlink_exp",
+	[NFNL_SUBSYS_QUEUE] = "nfnl_subsys_queue",
+	[NFNL_SUBSYS_ULOG] = "nfnl_subsys_ulog",
+	[NFNL_SUBSYS_OSF] = "nfnl_subsys_osf",
+	[NFNL_SUBSYS_IPSET] = "nfnl_subsys_ipset",
+	[NFNL_SUBSYS_ACCT] = "nfnl_subsys_acct",
+	[NFNL_SUBSYS_CTNETLINK_TIMEOUT] = "nfnl_subsys_cttimeout",
+	[NFNL_SUBSYS_CTHELPER] = "nfnl_subsys_cthelper",
+	[NFNL_SUBSYS_NFTABLES] = "nfnl_subsys_nftables",
+	[NFNL_SUBSYS_NFT_COMPAT] = "nfnl_subsys_nftcompat",
+};
+
 static const int nfnl_group2type[NFNLGRP_MAX+1] = {
 	[NFNLGRP_CONNTRACK_NEW]		= NFNL_SUBSYS_CTNETLINK,
 	[NFNLGRP_CONNTRACK_UPDATE]	= NFNL_SUBSYS_CTNETLINK,
@@ -632,7 +649,7 @@ static int __init nfnetlink_init(void)
 		BUG_ON(nfnl_group2type[i] == NFNL_SUBSYS_NONE);
 
 	for (i=0; i<NFNL_SUBSYS_COUNT; i++)
-		mutex_init(&table[i].mutex);
+		__mutex_init(&table[i].mutex, nfnl_lockdep_names[i], &nfnl_lockdep_keys[i]);
 
 	return register_pernet_subsys(&nfnetlink_net_ops);
 }
-- 
2.20.1

