Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC45B32DBDD
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239531AbhCDVfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:35:34 -0500
Received: from mga12.intel.com ([192.55.52.136]:5221 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239480AbhCDVfa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 16:35:30 -0500
IronPort-SDR: kXaD578Y/2BWEwAg8QNhcdWp4nISC099BlMBA2TRlthfwkobUCjtiv8oaUtq3t9D/uEgki/4cy
 yf1ak48UOJBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="166769414"
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="166769414"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:24 -0800
IronPort-SDR: lRSzzFIyx7PnzzMh9+e8zaWJBBwaIKqbatSHg/22N6hYnDgmXQjaO+f6kdCZGdL+tmFo3WNgPh
 4buDsDCkjfTg==
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="368329481"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.105.71])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:22 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Christoph Paasch <cpaasch@apple.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 3/9] mptcp: fix memory accounting on allocation error
Date:   Thu,  4 Mar 2021 13:32:10 -0800
Message-Id: <20210304213216.205472-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
References: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

In case of memory pressure the MPTCP xmit path keeps
at most a single skb in the tx cache, eventually freeing
additional ones.

The associated counter for forward memory is not update
accordingly, and that causes the following splat:

WARNING: CPU: 0 PID: 12 at net/core/stream.c:208 sk_stream_kill_queues+0x3ca/0x530 net/core/stream.c:208
Modules linked in:
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.11.0-rc2 #59
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Workqueue: events mptcp_worker
RIP: 0010:sk_stream_kill_queues+0x3ca/0x530 net/core/stream.c:208
Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 63 01 00 00 8b ab 00 01 00 00 e9 60 ff ff ff e8 2f 24 d3 fe 0f 0b eb 97 e8 26 24 d3 fe <0f> 0b eb a0 e8 1d 24 d3 fe 0f 0b e9 a5 fe ff ff 4c 89 e7 e8 0e d0
RSP: 0018:ffffc900000c7bc8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88810030ac40 RSI: ffffffff8262ca4a RDI: 0000000000000003
RBP: 0000000000000d00 R08: 0000000000000000 R09: ffffffff85095aa7
R10: ffffffff8262c9ea R11: 0000000000000001 R12: ffff888108908100
R13: ffffffff85095aa0 R14: ffffc900000c7c48 R15: 1ffff92000018f85
FS:  0000000000000000(0000) GS:ffff88811b200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa7444baef8 CR3: 0000000035ee9005 CR4: 0000000000170ef0
Call Trace:
 __mptcp_destroy_sock+0x4a7/0x6c0 net/mptcp/protocol.c:2547
 mptcp_worker+0x7dd/0x1610 net/mptcp/protocol.c:2272
 process_one_work+0x896/0x1170 kernel/workqueue.c:2275
 worker_thread+0x605/0x1350 kernel/workqueue.c:2421
 kthread+0x344/0x410 kernel/kthread.c:292
 ret_from_fork+0x22/0x30 arch/x86/entry/entry_64.S:296

At close time, as reported by syzkaller/Christoph.

This change address the issue properly updating the fwd
allocated memory counter in the error path.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/136
Fixes: 724cfd2ee8aa ("mptcp: allocate TX skbs in msk context")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 7362a536cbc0..aa59101ffe54 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1189,6 +1189,7 @@ static bool mptcp_tx_cache_refill(struct sock *sk, int size,
 			 */
 			while (skbs->qlen > 1) {
 				skb = __skb_dequeue_tail(skbs);
+				*total_ts -= skb->truesize;
 				__kfree_skb(skb);
 			}
 			return skbs->qlen > 0;
-- 
2.30.1

