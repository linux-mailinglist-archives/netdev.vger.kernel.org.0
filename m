Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE35467FF4
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 23:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383430AbhLCWjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 17:39:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:46471 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383423AbhLCWjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 17:39:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="223940932"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="223940932"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:47 -0800
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="460185306"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.18.88])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:47 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 03/10] mptcp: add SIOCINQ, OUTQ and OUTQNSD ioctls
Date:   Fri,  3 Dec 2021 14:35:34 -0800
Message-Id: <20211203223541.69364-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Allows to query in-sequence data ready for read(), total bytes in
write queue and total bytes in write queue that have not yet been sent.

v2: remove unneeded READ_ONCE() (Paolo Abeni)
v3: check for new data unconditionally in SIOCINQ ioctl (Mat Martineau)

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 53 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ffc8068aaad0..943f74e804bd 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -22,6 +22,7 @@
 #endif
 #include <net/mptcp.h>
 #include <net/xfrm.h>
+#include <asm/ioctls.h>
 #include "protocol.h"
 #include "mib.h"
 
@@ -3211,6 +3212,57 @@ static int mptcp_forward_alloc_get(const struct sock *sk)
 	return sk->sk_forward_alloc + mptcp_sk(sk)->rmem_fwd_alloc;
 }
 
+static int mptcp_ioctl_outq(const struct mptcp_sock *msk, u64 v)
+{
+	const struct sock *sk = (void *)msk;
+	u64 delta;
+
+	if (sk->sk_state == TCP_LISTEN)
+		return -EINVAL;
+
+	if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
+		return 0;
+
+	delta = msk->write_seq - v;
+	if (delta > INT_MAX)
+		delta = INT_MAX;
+
+	return (int)delta;
+}
+
+static int mptcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	bool slow;
+	int answ;
+
+	switch (cmd) {
+	case SIOCINQ:
+		if (sk->sk_state == TCP_LISTEN)
+			return -EINVAL;
+
+		lock_sock(sk);
+		__mptcp_move_skbs(msk);
+		answ = mptcp_inq_hint(sk);
+		release_sock(sk);
+		break;
+	case SIOCOUTQ:
+		slow = lock_sock_fast(sk);
+		answ = mptcp_ioctl_outq(msk, READ_ONCE(msk->snd_una));
+		unlock_sock_fast(sk, slow);
+		break;
+	case SIOCOUTQNSD:
+		slow = lock_sock_fast(sk);
+		answ = mptcp_ioctl_outq(msk, msk->snd_nxt);
+		unlock_sock_fast(sk, slow);
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	return put_user(answ, (int __user *)arg);
+}
+
 static struct proto mptcp_prot = {
 	.name		= "MPTCP",
 	.owner		= THIS_MODULE,
@@ -3223,6 +3275,7 @@ static struct proto mptcp_prot = {
 	.shutdown	= mptcp_shutdown,
 	.destroy	= mptcp_destroy,
 	.sendmsg	= mptcp_sendmsg,
+	.ioctl		= mptcp_ioctl,
 	.recvmsg	= mptcp_recvmsg,
 	.release_cb	= mptcp_release_cb,
 	.hash		= mptcp_hash,
-- 
2.34.1

