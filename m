Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4327958A422
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 02:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239733AbiHEAVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 20:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiHEAVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 20:21:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F9E19C3E
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 17:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659658895; x=1691194895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=As8F2NZFMzIE3CqfkdUNC3uOYKMCXanxAzq2aOrswzE=;
  b=ASVl8MWFUlRaNZ2tFR/QiOu2sBTgnG+YjJSYV/C6k6hArTrZ9RZ6DJDi
   hS6QiJPhI98qiEN8ZwdT/+EY8VeNTW1Y6WbCgYRKdRTwqY8INyeH0lwKa
   zkPARZlSomw+zYcxzf/HZaLJ+iBiwcqr7hmu/yAsYKhvAbW3Njn9Dnk39
   My/PQhIx90aWIt1P1XbJ/NGhHtOulLBqRYRlBFLvc10XBHZk/T66JY1yw
   fJPwG1pD3vk1qCncnR4rGLgaUIyZ3CP8ELOOZx66odQ/5n2miev5KOsAo
   BaTbw6SppJ4v98p7H6XEEUSr0vIIYyizgjWmhLLLEDr+LWWNf8OPmNdY3
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10429"; a="270467353"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="270467353"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 17:21:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="729810991"
Received: from ramankur-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.169.219])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 17:21:34 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        fw@strlen.de, dcaratti@redhat.com, mptcp@lists.linux.dev,
        Dipanjan Das <mail.dipanjan.das@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/3] mptcp: do not queue data on closed subflows
Date:   Thu,  4 Aug 2022 17:21:26 -0700
Message-Id: <20220805002127.88430-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220805002127.88430-1-mathew.j.martineau@linux.intel.com>
References: <20220805002127.88430-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Dipanjan reported a syzbot splat at close time:

WARNING: CPU: 1 PID: 10818 at net/ipv4/af_inet.c:153
inet_sock_destruct+0x6d0/0x8e0 net/ipv4/af_inet.c:153
Modules linked in: uio_ivshmem(OE) uio(E)
CPU: 1 PID: 10818 Comm: kworker/1:16 Tainted: G           OE
5.19.0-rc6-g2eae0556bb9d #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: events mptcp_worker
RIP: 0010:inet_sock_destruct+0x6d0/0x8e0 net/ipv4/af_inet.c:153
Code: 21 02 00 00 41 8b 9c 24 28 02 00 00 e9 07 ff ff ff e8 34 4d 91
f9 89 ee 4c 89 e7 e8 4a 47 60 ff e9 a6 fc ff ff e8 20 4d 91 f9 <0f> 0b
e9 84 fe ff ff e8 14 4d 91 f9 0f 0b e9 d4 fd ff ff e8 08 4d
RSP: 0018:ffffc9001b35fa78 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000002879d0 RCX: ffff8881326f3b00
RDX: 0000000000000000 RSI: ffff8881326f3b00 RDI: 0000000000000002
RBP: ffff888179662674 R08: ffffffff87e983a0 R09: 0000000000000000
R10: 0000000000000005 R11: 00000000000004ea R12: ffff888179662400
R13: ffff888179662428 R14: 0000000000000001 R15: ffff88817e38e258
FS:  0000000000000000(0000) GS:ffff8881f5f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020007bc0 CR3: 0000000179592000 CR4: 0000000000150ee0
Call Trace:
 <TASK>
 __sk_destruct+0x4f/0x8e0 net/core/sock.c:2067
 sk_destruct+0xbd/0xe0 net/core/sock.c:2112
 __sk_free+0xef/0x3d0 net/core/sock.c:2123
 sk_free+0x78/0xa0 net/core/sock.c:2134
 sock_put include/net/sock.h:1927 [inline]
 __mptcp_close_ssk+0x50f/0x780 net/mptcp/protocol.c:2351
 __mptcp_destroy_sock+0x332/0x760 net/mptcp/protocol.c:2828
 mptcp_worker+0x5d2/0xc90 net/mptcp/protocol.c:2586
 process_one_work+0x9cc/0x1650 kernel/workqueue.c:2289
 worker_thread+0x623/0x1070 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>

The root cause of the problem is that an mptcp-level (re)transmit can
race with mptcp_close() and the packet scheduler checks the subflow
state before acquiring the socket lock: we can try to (re)transmit on
an already closed ssk.

Fix the issue checking again the subflow socket status under the
subflow socket lock protection. Additionally add the missing check
for the fallback-to-tcp case.

Fixes: d5f49190def6 ("mptcp: allow picking different xmit subflows")
Reported-by: Dipanjan Das <mail.dipanjan.das@gmail.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c |  8 +++++++-
 net/mptcp/protocol.h | 11 +++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 07fcc86e1fc9..da4257504fad 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1240,6 +1240,9 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			 info->limit > dfrag->data_len))
 		return 0;
 
+	if (unlikely(!__tcp_can_send(ssk)))
+		return -EAGAIN;
+
 	/* compute send limit */
 	info->mss_now = tcp_send_mss(ssk, &info->size_goal, info->flags);
 	copy = info->size_goal;
@@ -1413,7 +1416,8 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 	if (__mptcp_check_fallback(msk)) {
 		if (!msk->first)
 			return NULL;
-		return sk_stream_memory_free(msk->first) ? msk->first : NULL;
+		return __tcp_can_send(msk->first) &&
+		       sk_stream_memory_free(msk->first) ? msk->first : NULL;
 	}
 
 	/* re-use last subflow, if the burst allow that */
@@ -1564,6 +1568,8 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 
 			ret = mptcp_sendmsg_frag(sk, ssk, dfrag, &info);
 			if (ret <= 0) {
+				if (ret == -EAGAIN)
+					continue;
 				mptcp_push_release(ssk, &info);
 				goto out;
 			}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 40881a7df5d5..132d50833df1 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -624,16 +624,19 @@ void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
 			 struct sockaddr_storage *addr,
 			 unsigned short family);
 
-static inline bool __mptcp_subflow_active(struct mptcp_subflow_context *subflow)
+static inline bool __tcp_can_send(const struct sock *ssk)
 {
-	struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+	/* only send if our side has not closed yet */
+	return ((1 << inet_sk_state_load(ssk)) & (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT));
+}
 
+static inline bool __mptcp_subflow_active(struct mptcp_subflow_context *subflow)
+{
 	/* can't send if JOIN hasn't completed yet (i.e. is usable for mptcp) */
 	if (subflow->request_join && !subflow->fully_established)
 		return false;
 
-	/* only send if our side has not closed yet */
-	return ((1 << ssk->sk_state) & (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT));
+	return __tcp_can_send(mptcp_subflow_tcp_sock(subflow));
 }
 
 void mptcp_subflow_set_active(struct mptcp_subflow_context *subflow);
-- 
2.37.1

