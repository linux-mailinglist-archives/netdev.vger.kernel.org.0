Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1A21F8AFE
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 23:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgFNVxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 17:53:15 -0400
Received: from correo.us.es ([193.147.175.20]:59922 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbgFNVxO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 17:53:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A9C6AB56E5
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 23:53:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9AD6ADA78A
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 23:53:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 90354DA78F; Sun, 14 Jun 2020 23:53:11 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0EDBEDA78B;
        Sun, 14 Jun 2020 23:53:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 14 Jun 2020 23:53:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CF6AE426CCBB;
        Sun, 14 Jun 2020 23:53:08 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 2/4] netfilter: nft_set_pipapo: Disable preemption before getting per-CPU pointer
Date:   Sun, 14 Jun 2020 23:52:59 +0200
Message-Id: <20200614215301.9101-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200614215301.9101-1-pablo@netfilter.org>
References: <20200614215301.9101-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

The lkp kernel test robot reports, with CONFIG_DEBUG_PREEMPT enabled:

  [  165.316525] BUG: using smp_processor_id() in preemptible [00000000] code: nft/6247
  [  165.319547] caller is nft_pipapo_insert+0x464/0x610 [nf_tables]
  [  165.321846] CPU: 1 PID: 6247 Comm: nft Not tainted 5.6.0-rc5-01595-ge32a4dc6512ce3 #1
  [  165.332128] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
  [  165.334892] Call Trace:
  [  165.336435]  dump_stack+0x8f/0xcb
  [  165.338128]  debug_smp_processor_id+0xb2/0xc0
  [  165.340117]  nft_pipapo_insert+0x464/0x610 [nf_tables]
  [  165.342290]  ? nft_trans_alloc_gfp+0x1c/0x60 [nf_tables]
  [  165.344420]  ? rcu_read_lock_sched_held+0x52/0x80
  [  165.346460]  ? nft_trans_alloc_gfp+0x1c/0x60 [nf_tables]
  [  165.348543]  ? __mmu_interval_notifier_insert+0xa0/0xf0
  [  165.350629]  nft_add_set_elem+0x5ff/0xa90 [nf_tables]
  [  165.352699]  ? __lock_acquire+0x241/0x1400
  [  165.354573]  ? __lock_acquire+0x241/0x1400
  [  165.356399]  ? reacquire_held_locks+0x12f/0x200
  [  165.358384]  ? nf_tables_valid_genid+0x1f/0x40 [nf_tables]
  [  165.360502]  ? nla_strcmp+0x10/0x50
  [  165.362199]  ? nft_table_lookup+0x4f/0xa0 [nf_tables]
  [  165.364217]  ? nla_strcmp+0x10/0x50
  [  165.365891]  ? nf_tables_newsetelem+0xd5/0x150 [nf_tables]
  [  165.367997]  nf_tables_newsetelem+0xd5/0x150 [nf_tables]
  [  165.370083]  nfnetlink_rcv_batch+0x4fd/0x790 [nfnetlink]
  [  165.372205]  ? __lock_acquire+0x241/0x1400
  [  165.374058]  ? __nla_validate_parse+0x57/0x8a0
  [  165.375989]  ? cap_inode_getsecurity+0x230/0x230
  [  165.377954]  ? security_capable+0x38/0x50
  [  165.379795]  nfnetlink_rcv+0x11d/0x140 [nfnetlink]
  [  165.381779]  netlink_unicast+0x1b2/0x280
  [  165.383612]  netlink_sendmsg+0x351/0x470
  [  165.385439]  sock_sendmsg+0x5b/0x60
  [  165.387133]  ____sys_sendmsg+0x200/0x280
  [  165.388871]  ? copy_msghdr_from_user+0xd9/0x160
  [  165.390805]  ___sys_sendmsg+0x88/0xd0
  [  165.392524]  ? __might_fault+0x3e/0x90
  [  165.394273]  ? sock_getsockopt+0x3d5/0xbb0
  [  165.396021]  ? __handle_mm_fault+0x545/0x6a0
  [  165.397822]  ? find_held_lock+0x2d/0x90
  [  165.399593]  ? __sys_sendmsg+0x5e/0xa0
  [  165.401338]  __sys_sendmsg+0x5e/0xa0
  [  165.402979]  do_syscall_64+0x60/0x280
  [  165.404680]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
  [  165.406621] RIP: 0033:0x7ff1fa46e783
  [  165.408299] Code: c7 c0 ff ff ff ff eb bb 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 89 54 24 1c 48
  [  165.414163] RSP: 002b:00007ffedf59ea78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
  [  165.416804] RAX: ffffffffffffffda RBX: 00007ffedf59fc60 RCX: 00007ff1fa46e783
  [  165.419419] RDX: 0000000000000000 RSI: 00007ffedf59fb10 RDI: 0000000000000005
  [  165.421886] RBP: 00007ffedf59fc10 R08: 00007ffedf59ea54 R09: 0000000000000001
  [  165.424445] R10: 00007ff1fa630c6c R11: 0000000000000246 R12: 0000000000020000
  [  165.426954] R13: 0000000000000280 R14: 0000000000000005 R15: 00007ffedf59ea90

Disable preemption before accessing the lookup scratch area in
nft_pipapo_insert().

Reported-by: kernel test robot <lkp@intel.com>
Analysed-by: Florian Westphal <fw@strlen.de>
Cc: <stable@vger.kernel.org> # 5.6.x
Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 8b5acc6910fd..8c04388296b0 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1242,7 +1242,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 		end += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 	}
 
-	if (!*this_cpu_ptr(m->scratch) || bsize_max > m->bsize_max) {
+	if (!*get_cpu_ptr(m->scratch) || bsize_max > m->bsize_max) {
+		put_cpu_ptr(m->scratch);
+
 		err = pipapo_realloc_scratch(m, bsize_max);
 		if (err)
 			return err;
@@ -1250,6 +1252,8 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 		this_cpu_write(nft_pipapo_scratch_index, false);
 
 		m->bsize_max = bsize_max;
+	} else {
+		put_cpu_ptr(m->scratch);
 	}
 
 	*ext2 = &e->ext;
-- 
2.20.1

