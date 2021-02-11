Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CD13196AE
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 00:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhBKXd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 18:33:58 -0500
Received: from mga05.intel.com ([192.55.52.43]:55189 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229935AbhBKXdz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 18:33:55 -0500
IronPort-SDR: FaFYvGW1tjaiBy8U7fTAOwxW3EtpWtX8A+l+H9hlsRSmQDIzSk//4uHRVB//2EsnMfIA5RfC0f
 pgmhzw+GsqwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9892"; a="267177937"
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="267177937"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:49 -0800
IronPort-SDR: IPWXWF4IQWZWDOk8dB1FsFTRNcI6bouhGlfY43/O2Mwa60uqdPXPRo+cVXCR07DbCuQ4nisYOh
 g4Eg9NCroxqg==
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="381226385"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.100.224])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:48 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Christoph Paasch <cpaasch@apple.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 3/6] mptcp: fix spurious retransmissions
Date:   Thu, 11 Feb 2021 15:30:39 -0800
Message-Id: <20210211233042.304878-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
References: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Syzkaller was able to trigger the following splat again:

WARNING: CPU: 1 PID: 12512 at net/mptcp/protocol.c:761 mptcp_reset_timer+0x12a/0x160 net/mptcp/protocol.c:761
Modules linked in:
CPU: 1 PID: 12512 Comm: kworker/1:6 Not tainted 5.10.0-rc6 #52
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Workqueue: events mptcp_worker
RIP: 0010:mptcp_reset_timer+0x12a/0x160 net/mptcp/protocol.c:761
Code: e8 4b 0c ad ff e8 56 21 88 fe 48 b8 00 00 00 00 00 fc ff df 48 c7 04 03 00 00 00 00 48 83 c4 40 5b 5d 41 5c c3 e8 36 21 88 fe <0f> 0b 41 bc c8 00 00 00 eb 98 e8 e7 b1 af fe e9 30 ff ff ff 48 c7
RSP: 0018:ffffc900018c7c68 EFLAGS: 00010293
RAX: ffff888108cb1c80 RBX: 1ffff92000318f8d RCX: ffffffff82ad0307
RDX: 0000000000000000 RSI: ffffffff82ad036a RDI: 0000000000000007
RBP: ffff888113e2d000 R08: ffff888108cb1c80 R09: ffffed10227c5ab7
R10: ffff888113e2d5b7 R11: ffffed10227c5ab6 R12: 0000000000000000
R13: ffff88801f100000 R14: ffff888113e2d5b0 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88811b500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd76a874ef8 CR3: 000000001689c005 CR4: 0000000000170ee0
Call Trace:
 mptcp_worker+0xaa4/0x1560 net/mptcp/protocol.c:2334
 process_one_work+0x8d3/0x1200 kernel/workqueue.c:2272
 worker_thread+0x9c/0x1090 kernel/workqueue.c:2418
 kthread+0x303/0x410 kernel/kthread.c:292
 ret_from_fork+0x22/0x30 arch/x86/entry/entry_64.S:296

The mptcp_worker tries to update the MPTCP retransmission timer
even if such timer is not currently scheduled.

The mptcp_rtx_head() return value is bogus: we can have enqueued
data not yet transmitted. The above may additionally cause spurious,
unneeded MPTCP-level retransmissions.

Fix the issue adding an explicit clearing of the rtx queue before
trying to retransmit and checking for unacked data.
Additionally drop an unneeded timer stop call and the unused
mptcp_rtx_tail() helper.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c |  3 +--
 net/mptcp/protocol.h | 11 ++---------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 42ca49954bdd..c11fcf6f5faf 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -364,8 +364,6 @@ static void mptcp_check_data_fin_ack(struct sock *sk)
 
 	/* Look for an acknowledged DATA_FIN */
 	if (mptcp_pending_data_fin_ack(sk)) {
-		mptcp_stop_timer(sk);
-
 		WRITE_ONCE(msk->snd_data_fin_enable, 0);
 
 		switch (sk->sk_state) {
@@ -2299,6 +2297,7 @@ static void mptcp_worker(struct work_struct *work)
 	if (!test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
 		goto unlock;
 
+	__mptcp_clean_una(sk);
 	dfrag = mptcp_rtx_head(sk);
 	if (!dfrag)
 		goto unlock;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 0743f48a0644..6a164add5b6f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -326,20 +326,13 @@ static inline struct mptcp_data_frag *mptcp_pending_tail(const struct sock *sk)
 	return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
 }
 
-static inline struct mptcp_data_frag *mptcp_rtx_tail(const struct sock *sk)
+static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (!before64(msk->snd_nxt, READ_ONCE(msk->snd_una)))
+	if (msk->snd_una == READ_ONCE(msk->snd_nxt))
 		return NULL;
 
-	return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
-}
-
-static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
 	return list_first_entry_or_null(&msk->rtx_queue, struct mptcp_data_frag, list);
 }
 
-- 
2.30.1

