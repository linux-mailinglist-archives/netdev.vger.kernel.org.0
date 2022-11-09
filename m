Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83297622A81
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiKIL2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiKIL2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:28:33 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C90B111F;
        Wed,  9 Nov 2022 03:28:30 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 2/3] netfilter: Cleanup nft_net->module_list from nf_tables_exit_net()
Date:   Wed,  9 Nov 2022 12:28:19 +0100
Message-Id: <20221109112820.206807-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221109112820.206807-1-pablo@netfilter.org>
References: <20221109112820.206807-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shigeru Yoshida <syoshida@redhat.com>

syzbot reported a warning like below [1]:

WARNING: CPU: 3 PID: 9 at net/netfilter/nf_tables_api.c:10096 nf_tables_exit_net+0x71c/0x840
Modules linked in:
CPU: 2 PID: 9 Comm: kworker/u8:0 Tainted: G        W          6.1.0-rc3-00072-g8e5423e991e8 #47
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.fc36 04/01/2014
Workqueue: netns cleanup_net
RIP: 0010:nf_tables_exit_net+0x71c/0x840
...
Call Trace:
 <TASK>
 ? __nft_release_table+0xfc0/0xfc0
 ops_exit_list+0xb5/0x180
 cleanup_net+0x506/0xb10
 ? unregister_pernet_device+0x80/0x80
 process_one_work+0xa38/0x1730
 ? pwq_dec_nr_in_flight+0x2b0/0x2b0
 ? rwlock_bug.part.0+0x90/0x90
 ? _raw_spin_lock_irq+0x46/0x50
 worker_thread+0x67e/0x10e0
 ? process_one_work+0x1730/0x1730
 kthread+0x2e5/0x3a0
 ? kthread_complete_and_exit+0x40/0x40
 ret_from_fork+0x1f/0x30
 </TASK>

In nf_tables_exit_net(), there is a case where nft_net->commit_list is
empty but nft_net->module_list is not empty.  Such a case occurs with
the following scenario:

1. nfnetlink_rcv_batch() is called
2. nf_tables_newset() returns -EAGAIN and NFNL_BATCH_FAILURE bit is
   set to status
3. nf_tables_abort() is called with NFNL_ABORT_AUTOLOAD
   (nft_net->commit_list is released, but nft_net->module_list is not
   because of NFNL_ABORT_AUTOLOAD flag)
4. Jump to replay label
5. netlink_skb_clone() fails and returns from the function (this is
   caused by fault injection in the reproducer of syzbot)

This patch fixes this issue by calling __nf_tables_abort() when
nft_net->module_list is not empty in nf_tables_exit_net().

Fixes: eb014de4fd41 ("netfilter: nf_tables: autoload modules from the abort path")
Link: https://syzkaller.appspot.com/bug?id=802aba2422de4218ad0c01b46c9525cc9d4e4aa3 [1]
Reported-by: syzbot+178efee9e2d7f87f5103@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 76bd4d03dbda..e7152d599d73 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10090,7 +10090,8 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	struct nftables_pernet *nft_net = nft_pernet(net);
 
 	mutex_lock(&nft_net->commit_mutex);
-	if (!list_empty(&nft_net->commit_list))
+	if (!list_empty(&nft_net->commit_list) ||
+	    !list_empty(&nft_net->module_list))
 		__nf_tables_abort(net, NFNL_ABORT_NONE);
 	__nft_release_tables(net);
 	mutex_unlock(&nft_net->commit_mutex);
-- 
2.30.2

