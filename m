Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18DE495A0
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbfFQW7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:10995 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbfFQW6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:49 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:49 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, cpaasch@apple.com,
        pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com, matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 08/33] mptcp: add mptcp_poll
Date:   Mon, 17 Jun 2019 15:57:43 -0700
Message-Id: <20190617225808.665-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Can't use tcp_poll directly:

BUG: KASAN: slab-out-of-bounds in tcp_poll+0x17f/0x540
Read of size 4 at addr ffff88806ac5e50c by task mptcp_connect/2085
Call Trace:
 tcp_poll+0x17f/0x540
 sock_poll+0x152/0x180

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 56637e4474da..3d9cd52e3e1e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -181,6 +181,19 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	return inet_stream_connect(msk->subflow, uaddr, addr_len, flags);
 }
 
+static __poll_t mptcp_poll(struct file *file, struct socket *sock,
+			   struct poll_table_struct *wait)
+{
+	const struct mptcp_sock *msk;
+	struct sock *sk = sock->sk;
+
+	msk = mptcp_sk(sk);
+	if (msk->subflow)
+		return tcp_poll(file, msk->subflow, wait);
+
+	return tcp_poll(file, msk->connection_list, wait);
+}
+
 static struct proto_ops mptcp_stream_ops;
 
 static struct inet_protosw mptcp_protosw = {
@@ -197,6 +210,7 @@ void __init mptcp_init(void)
 	mptcp_stream_ops = inet_stream_ops;
 	mptcp_stream_ops.bind = mptcp_bind;
 	mptcp_stream_ops.connect = mptcp_stream_connect;
+	mptcp_stream_ops.poll = mptcp_poll;
 
 	subflow_init();
 
-- 
2.22.0

