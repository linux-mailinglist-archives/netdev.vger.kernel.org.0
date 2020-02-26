Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1877C170BF6
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 23:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgBZWzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 17:55:10 -0500
Received: from correo.us.es ([193.147.175.20]:36432 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgBZWzC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 17:55:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 930921C4392
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:54:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 811F4DA840
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:54:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 75D57DA736; Wed, 26 Feb 2020 23:54:51 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B207DA7B2;
        Wed, 26 Feb 2020 23:54:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Feb 2020 23:54:49 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 579C042EF4E0;
        Wed, 26 Feb 2020 23:54:49 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/6] nft_set_pipapo: Actually fetch key data in nft_pipapo_remove()
Date:   Wed, 26 Feb 2020 23:54:40 +0100
Message-Id: <20200226225442.9598-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200226225442.9598-1-pablo@netfilter.org>
References: <20200226225442.9598-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

Phil reports that adding elements, flushing and re-adding them
right away:

  nft add table t '{ set s { type ipv4_addr . inet_service; flags interval; }; }'
  nft add element t s '{ 10.0.0.1 . 22-25, 10.0.0.1 . 10-20 }'
  nft flush set t s
  nft add element t s '{ 10.0.0.1 . 10-20, 10.0.0.1 . 22-25 }'

triggers, almost reliably, a crash like this one:

  [   71.319848] general protection fault, probably for non-canonical address 0x6f6b6e696c2e756e: 0000 [#1] PREEMPT SMP PTI
  [   71.321540] CPU: 3 PID: 1201 Comm: kworker/3:2 Not tainted 5.6.0-rc1-00377-g2bb07f4e1d861 #192
  [   71.322746] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190711_202441-buildvm-armv7-10.arm.fedoraproject.org-2.fc31 04/01/2014
  [   71.324430] Workqueue: events nf_tables_trans_destroy_work [nf_tables]
  [   71.325387] RIP: 0010:nft_set_elem_destroy+0xa5/0x110 [nf_tables]
  [   71.326164] Code: 89 d4 84 c0 74 0e 8b 77 44 0f b6 f8 48 01 df e8 41 ff ff ff 45 84 e4 74 36 44 0f b6 63 08 45 84 e4 74 2c 49 01 dc 49 8b 04 24 <48> 8b 40 38 48 85 c0 74 4f 48 89 e7 4c 8b
  [   71.328423] RSP: 0018:ffffc9000226fd90 EFLAGS: 00010282
  [   71.329225] RAX: 6f6b6e696c2e756e RBX: ffff88813ab79f60 RCX: ffff88813931b5a0
  [   71.330365] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88813ab79f9a
  [   71.331473] RBP: ffff88813ab79f60 R08: 0000000000000008 R09: 0000000000000000
  [   71.332627] R10: 000000000000021c R11: 0000000000000000 R12: ffff88813ab79fc2
  [   71.333615] R13: ffff88813b3adf50 R14: dead000000000100 R15: ffff88813931b8a0
  [   71.334596] FS:  0000000000000000(0000) GS:ffff88813bd80000(0000) knlGS:0000000000000000
  [   71.335780] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [   71.336577] CR2: 000055ac683710f0 CR3: 000000013a222003 CR4: 0000000000360ee0
  [   71.337533] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  [   71.338557] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  [   71.339718] Call Trace:
  [   71.340093]  nft_pipapo_destroy+0x7a/0x170 [nf_tables_set]
  [   71.340973]  nft_set_destroy+0x20/0x50 [nf_tables]
  [   71.341879]  nf_tables_trans_destroy_work+0x246/0x260 [nf_tables]
  [   71.342916]  process_one_work+0x1d5/0x3c0
  [   71.343601]  worker_thread+0x4a/0x3c0
  [   71.344229]  kthread+0xfb/0x130
  [   71.344780]  ? process_one_work+0x3c0/0x3c0
  [   71.345477]  ? kthread_park+0x90/0x90
  [   71.346129]  ret_from_fork+0x35/0x40
  [   71.346748] Modules linked in: nf_tables_set nf_tables nfnetlink 8021q [last unloaded: nfnetlink]
  [   71.348153] ---[ end trace 2eaa8149ca759bcc ]---
  [   71.349066] RIP: 0010:nft_set_elem_destroy+0xa5/0x110 [nf_tables]
  [   71.350016] Code: 89 d4 84 c0 74 0e 8b 77 44 0f b6 f8 48 01 df e8 41 ff ff ff 45 84 e4 74 36 44 0f b6 63 08 45 84 e4 74 2c 49 01 dc 49 8b 04 24 <48> 8b 40 38 48 85 c0 74 4f 48 89 e7 4c 8b
  [   71.350017] RSP: 0018:ffffc9000226fd90 EFLAGS: 00010282
  [   71.350019] RAX: 6f6b6e696c2e756e RBX: ffff88813ab79f60 RCX: ffff88813931b5a0
  [   71.350019] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88813ab79f9a
  [   71.350020] RBP: ffff88813ab79f60 R08: 0000000000000008 R09: 0000000000000000
  [   71.350021] R10: 000000000000021c R11: 0000000000000000 R12: ffff88813ab79fc2
  [   71.350022] R13: ffff88813b3adf50 R14: dead000000000100 R15: ffff88813931b8a0
  [   71.350025] FS:  0000000000000000(0000) GS:ffff88813bd80000(0000) knlGS:0000000000000000
  [   71.350026] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [   71.350027] CR2: 000055ac683710f0 CR3: 000000013a222003 CR4: 0000000000360ee0
  [   71.350028] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  [   71.350028] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  [   71.350030] Kernel panic - not syncing: Fatal exception
  [   71.350412] Kernel Offset: disabled
  [   71.365922] ---[ end Kernel panic - not syncing: Fatal exception ]---

which is caused by dangling elements that have been deactivated, but
never removed.

On a flush operation, nft_pipapo_walk() walks through all the elements
in the mapping table, which are then deactivated by nft_flush_set(),
one by one, and added to the commit list for removal. Element data is
then freed.

On transaction commit, nft_pipapo_remove() is called, and failed to
remove these elements, leading to the stale references in the mapping.
The first symptom of this, revealed by KASan, is a one-byte
use-after-free in subsequent calls to nft_pipapo_walk(), which is
usually not enough to trigger a panic. When stale elements are used
more heavily, though, such as double-free via nft_pipapo_destroy()
as in Phil's case, the problem becomes more noticeable.

The issue comes from that fact that, on a flush operation,
nft_pipapo_remove() won't get the actual key data via elem->key,
elements to be deleted upon commit won't be found by the lookup via
pipapo_get(), and removal will be skipped. Key data should be fetched
via nft_set_ext_key(), instead.

Reported-by: Phil Sutter <phil@nwl.cc>
Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index feac8553f6d9..4fc0c924ed5d 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1766,11 +1766,13 @@ static bool pipapo_match_field(struct nft_pipapo_field *f,
 static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 			      const struct nft_set_elem *elem)
 {
-	const u8 *data = (const u8 *)elem->key.val.data;
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m = priv->clone;
+	struct nft_pipapo_elem *e = elem->priv;
 	int rules_f0, first_rule = 0;
-	struct nft_pipapo_elem *e;
+	const u8 *data;
+
+	data = (const u8 *)nft_set_ext_key(&e->ext);
 
 	e = pipapo_get(net, set, data, 0);
 	if (IS_ERR(e))
-- 
2.11.0

